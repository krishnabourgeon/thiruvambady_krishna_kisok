package com.example.thiruvambady_krishna_kisok

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.hardware.usb.UsbManager
import android.text.Layout
import android.text.StaticLayout
import android.text.TextPaint
import android.util.Log
import com.kioskworldline.com.PrintCmd
import com.kioskworldline.com.UsbDriver
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PrinterPlugin(
    private val context: Context
) : MethodChannel.MethodCallHandler {

    private var usbDriver: UsbDriver? = null

    // The printer only understands GB2312 (see PrintCmd.PrintString), which has
    // no Malayalam glyphs — those bytes come back as literal '?' on paper.
    // Malayalam lines are rendered to a bitmap using the system's default
    // typeface (Android's built-in font fallback handles Malayalam glyph
    // shaping reliably) and sent as an image so the printer's font ROM is
    // bypassed.

    init {
        usbDriver = UsbDriver(
            context.getSystemService(
                Context.USB_SERVICE
            ) as UsbManager,
            context
        )
    }

    private fun containsMalayalam(text: String): Boolean {
        return text.any { it.code in 0x0D00..0x0D7F }
    }

    companion object {
        // Characters per line at the default 12x24 font. 48 = 80mm paper,
        // 32 = 58mm paper. Dashed separators and two-column rows use this,
        // so change only this if the line is too long / too short.
        const val LINE_WIDTH = 48

        // Max width of the logo bitmap (see note in printTextAsBitmap).
        const val LOGO_WIDTH = 256
        const val LOGO_MAX_HEIGHT = 200

        // Full paper width in printer dots (12 dots per character).
        const val PAPER_DOTS = LINE_WIDTH * 12
    }

    /**
     * Sends a bitmap, optionally centered on the paper. The printer ignores
     * text alignment for images, so centering is done by setting the left
     * margin to half of the unused paper width, then resetting it.
     */
    private fun writeBitmap(bitmap: Bitmap, center: Boolean): Boolean {
        val bytes = PrintCmd.PrintBitmap(bitmap) ?: return false
        usbDriver?.write(PrintCmd.SetAlignment(0))
        if (center) {
            val margin = ((PAPER_DOTS - bitmap.width) / 2).coerceAtLeast(0)
            usbDriver?.write(PrintCmd.SetLeftmargin(margin))
        }
        usbDriver?.write(bytes)
        if (center) usbDriver?.write(PrintCmd.SetLeftmargin(0))
        return true
    }

    private fun printLine(text: String, center: Boolean = false, bold: Boolean = false) {
        if (text.isEmpty()) return
        if (containsMalayalam(text)) {
            printTextAsBitmap(text, center, bold)
        } else {
            usbDriver?.write(PrintCmd.SetAlignment(if (center) 1 else 0))
            if (bold) usbDriver?.write(PrintCmd.SetBold(1))
            usbDriver?.write(PrintCmd.PrintString(text, 0))
            if (bold) usbDriver?.write(PrintCmd.SetBold(0))
            if (center) usbDriver?.write(PrintCmd.SetAlignment(0))
        }
    }

    private fun printDashes() {
        printLine("-".repeat(LINE_WIDTH))
    }

    /** Decodes the bill_image bytes and prints them centered at the top. */
    private fun printLogo(imageBytes: ByteArray?) {
        if (imageBytes == null || imageBytes.isEmpty()) return
        val src = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
        if (src == null) {
            Log.e("PrinterPlugin", "bill_image could not be decoded (${imageBytes.size} bytes)")
            return
        }

        // Fit inside LOGO_WIDTH x LOGO_MAX_HEIGHT keeping aspect ratio.
        val scale = minOf(
            LOGO_WIDTH.toFloat() / src.width,
            LOGO_MAX_HEIGHT.toFloat() / src.height
        )
        val w = (src.width * scale).toInt().coerceAtLeast(1)
        val h = (src.height * scale).toInt().coerceAtLeast(1)
        val scaled = Bitmap.createScaledBitmap(src, w, h, true)

        // White canvas (transparent PNG areas would print black), image
        // centered horizontally inside it.
        val out = Bitmap.createBitmap(LOGO_WIDTH, h, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(out)
        canvas.drawColor(Color.WHITE)
        canvas.drawBitmap(scaled, ((LOGO_WIDTH - w) / 2).toFloat(), 0f, null)

        if (!writeBitmap(out, center = true)) {
            Log.e("PrinterPlugin", "PrintBitmap failed for bill_image (${out.width}x${out.height})")
        }

        if (scaled !== src) scaled.recycle()
        src.recycle()
        out.recycle()
    }

    private fun printTextAsBitmap(text: String, center: Boolean = false, bold: Boolean = false) {
        val paint = TextPaint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.BLACK
            textSize = 24f
            isFakeBoldText = bold
        }

        // Must match the printer's actual dot width (same width the 32-char
        // GB2312 text lines use elsewhere) - going wider makes the native
        // PrintBitmap() call silently fail, which falls back to GB2312 and
        // Malayalam stops printing.
        val maxLineWidthPx = 256
        val padding = 10

        val layout = StaticLayout(
            text,
            paint,
            maxLineWidthPx - padding * 2,
            if (center) Layout.Alignment.ALIGN_CENTER else Layout.Alignment.ALIGN_NORMAL,
            1f,
            0f,
            false
        )

        val bitmapHeight = layout.height.coerceAtLeast(40) + padding * 2
        val bitmap = Bitmap.createBitmap(maxLineWidthPx, bitmapHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        canvas.drawColor(Color.WHITE)
        canvas.save()
        canvas.translate(padding.toFloat(), padding.toFloat())
        layout.draw(canvas)
        canvas.restore()

        if (!writeBitmap(bitmap, center)) {
            Log.e(
                "PrinterPlugin",
                "PrintBitmap failed for \"$text\" (${bitmap.width}x${bitmap.height}); " +
                    "falling back to GB2312, Malayalam glyphs will not render"
            )
            // Fall back to the GB2312 path (renders as '?') rather than dropping the line silently.
            usbDriver?.write(PrintCmd.PrintString(text, 0))
        }
        bitmap.recycle()
    }

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {

        when (call.method) {

            "connect" -> {

                val connected =
                    usbDriver?.openUsbDevice() ?: false

                result.success(connected)
            }

            "printText" -> {

                val text =
                    call.argument<String>("text") ?: ""

                usbDriver?.write(
                    PrintCmd.SetClean()
                )

                usbDriver?.write(
                    PrintCmd.PrintString(
                        text,
                        0
                    )
                )

                usbDriver?.write(
                    PrintCmd.PrintFeedline(2)
                )

                result.success(true)
            }

            "cutPaper" -> {

                usbDriver?.write(
                    PrintCmd.PrintCutpaper(0)
                )

                result.success(true)
            }

            "printReceipt" -> {
val temple =  call.argument<String>("temple") ?: ""
val templeAddress =  call.argument<String>("templeAddress") ?: ""
val templePlace =  call.argument<String>("templePlace") ?: ""
                val billNo =
                    call.argument<String>("billNo") ?: ""

                val date =
                    call.argument<String>("date") ?: ""

                val mode =
                    call.argument<String>("mode") ?: ""

                val total =
                    call.argument<String>("total") ?: ""

                val website =
                    call.argument<String>("website") ?: ""
                val image = call.argument<ByteArray>("image")
                val items =call.argument<List<Map<String, Any?>>>("items")
        ?: emptyList()

                printReceipt(
                    image,
                    temple,
                    templeAddress,
                    templePlace,
                    billNo,
                    date,
                    mode,
                    total,
                    website,
                    items
                )

                result.success(true)
            }

            else -> result.notImplemented()
        }
    }

    private fun printTwoColumn(
        left: String,
        right: String,
        bold: Boolean = false
    ) {

        val spaces =
            (LINE_WIDTH - left.length - right.length)
                .coerceAtLeast(1)

        val line =
            left + " ".repeat(spaces) + right

        printLine(line, bold = bold)
    }

    /**
     * Bold heading line, then the values underneath, with the right column
     * starting at the same position on both lines:
     *   Bill No                      Date
     *   1234                         05-11-2026 10:15:00
     */
    private fun printLabelValue(
        leftLabel: String,
        rightLabel: String,
        leftValue: String,
        rightValue: String,
        boldValues: Boolean = false
    ) {
        // Keep a few characters free at the right edge so the full date
        // (e.g. "05-11-2026 10:15:00") never runs past the paper and wraps.
        val rightMargin = 4
        val rightStart = (LINE_WIDTH - rightMargin - maxOf(rightLabel.length, rightValue.length))
            .coerceAtLeast(maxOf(leftLabel.length, leftValue.length) + 1)
        printLine(leftLabel.padEnd(rightStart) + rightLabel, bold = true)
        printLine(leftValue.padEnd(rightStart) + rightValue, bold = boldValues)
    }

    private fun printReceipt(
        image: ByteArray?,
        temple: String,
    templeAddress: String,
    templePlace: String,
    billNo: String,
    date: String,
    mode: String,
    total: String,
    website: String,
    items: List<Map<String, Any?>>
) {

  usbDriver?.write(PrintCmd.SetClean())

    printLogo(image)

    printLine(temple.uppercase(), center = true, bold = true)
    printLine(templeAddress, center = true, bold = true)
    printLine(templePlace, center = true, bold = true)

    usbDriver?.write(PrintCmd.PrintFeedline(1))

    printDashes()

    printLabelValue("Bill No", "Date", billNo, date)

    printDashes()

    for (item in items) {

        val personId =
            item["personId"]?.toString() ?: ""

        val personName =
            item["personName"]?.toString() ?: ""

        val deity =
            item["deity"]?.toString() ?: ""

        val star =
            item["star"]?.toString() ?: ""

        val pooja =
            item["pooja"]?.toString() ?: ""

        val qty =
            item["qty"]?.toString() ?: ""

        val rate =
            item["rate"]?.toString() ?: ""

        val poojaDate =
            item["date"]?.toString() ?: ""

        val address =
            item["address"]?.toString() ?: ""

        printLine("$personId. $deity")

        printLine("$personName - $star")

        printLine("$pooja  $qty x $rate")

        if (poojaDate.isNotEmpty()) {
            printLine(poojaDate)
        }

        if (address.isNotEmpty()) {
            printLine(address)
        }

        usbDriver?.write(
            PrintCmd.PrintFeedline(1)
        )
    }

    printDashes()

    printLabelValue("Mode", "Total", mode, "Rs.$total", boldValues = true)

    printDashes()

    usbDriver?.write(
        PrintCmd.PrintFeedline(1)
    )

    printLine("Book Online $website", center = true)

    // Extra blank space after the last line so the text isn't cut off
    // by the cutter.
    usbDriver?.write(
        PrintCmd.PrintFeedline(8)
    )

    usbDriver?.write(
        PrintCmd.PrintCutpaper(0)
    )
}

}