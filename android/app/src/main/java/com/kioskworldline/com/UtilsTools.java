package com.kioskworldline.com;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.media.ThumbnailUtils;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.util.Base64;
import android.util.Log;
import androidx.annotation.RequiresApi;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Pattern;

import static android.content.ContentValues.TAG;
import static javax.xml.transform.OutputKeys.ENCODING;

public class UtilsTools {
    private static String hexString = "0123456789ABCDEF";
    public static Bitmap convertToBlackWhite(Bitmap bmp) {
        //System.out.println(bmp.getConfig());
        int width = bmp.getWidth();
        int height = bmp.getHeight();
        int[] pixels = new int[width * height];
        bmp.getPixels(pixels, 0, width, 0, 0, width, height);
        int[] gray=new int[height*width];
        try{
            for (int i = 0; i < height; i++) {
                for (int j = 0; j < width; j++) {
                    int grey = pixels[width * i + j];
                    int red = ((grey & 0x00FF0000 ) >>16);
                    gray[width*i+j]=red;
                }
            }
        }catch (Exception e){
            Log.e(TAG, "convertToBlackWhite:" + e.getMessage());
        }

        int e=0;
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                int g=gray[width*i+j];
                if (g>=128) {
                    pixels[width*i+j]=0xffffffff;
                    e=g-255;

                }else {
                    pixels[width*i+j]=0xff000000;
                    e=g-0;
                }
                if (j<width-1&&i<height-1) {
                    gray[width*i+j+1]+=3*e/8;
                    gray[width*(i+1)+j]+=3*e/8;
                    gray[width*(i+1)+j+1]+=e/4;
                }else if (j==width-1&&i<height-1) {
                    gray[width*(i+1)+j]+=3*e/8;
                }else if (j<width-1&&i==height-1) {
                    gray[width*(i)+j+1]+=e/4;
                }
            }
        }

        Bitmap newBmp = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565);
        newBmp.setPixels(pixels, 0, width, 0, 0, width, height);
        Bitmap resizeBmp = ThumbnailUtils.extractThumbnail(newBmp, width, height);
        return resizeBmp;
    }

    public static int saveBmpFile(Bitmap bitmap,String strFileName) {
        int iResult = -1;
        if (bitmap == null)
            return iResult;
        int nBmpWidth = bitmap.getWidth();
        int nBmpHeight = bitmap.getHeight();
        int bufferSize = nBmpHeight * (nBmpWidth * 3 + nBmpWidth % 4);
        try {
            File file = new File(strFileName);
            if (!file.exists()) {
                file.createNewFile();
            }
            FileOutputStream fileos = new FileOutputStream(strFileName);
            int bfType = 0x4d42;
            long bfSize = 14 + 40 + bufferSize;
            int bfReserved1 = 0;
            int bfReserved2 = 0;
            long bfOffBits = 14 + 40;
            writeWord(fileos, bfType);
            writeDword(fileos, bfSize);
            writeWord(fileos, bfReserved1);
            writeWord(fileos, bfReserved2);
            writeDword(fileos, bfOffBits);
            long biSize = 40L;
            long biWidth = nBmpWidth;
            long biHeight = nBmpHeight;
            int biPlanes = 1;
            int biBitCount = 24;
            long biCompression = 0L;
            long biSizeImage = 0L;
            long biXpelsPerMeter = 0L;
            long biYPelsPerMeter = 0L;
            long biClrUsed = 0L;
            long biClrImportant = 0L;
            writeDword(fileos, biSize);
            writeLong(fileos, biWidth);
            writeLong(fileos, biHeight);
            writeWord(fileos, biPlanes);
            writeWord(fileos, biBitCount);
            writeDword(fileos, biCompression);
            writeDword(fileos, biSizeImage);
            writeLong(fileos, biXpelsPerMeter);
            writeLong(fileos, biYPelsPerMeter);
            writeDword(fileos, biClrUsed);
            writeDword(fileos, biClrImportant);
            byte bmpData[] = new byte[bufferSize];
            int wWidth = (nBmpWidth * 3 + nBmpWidth % 4);
            for (int nCol = 0, nRealCol = nBmpHeight - 1; nCol < nBmpHeight; ++nCol, --nRealCol)
                for (int wRow = 0, wByteIdex = 0; wRow < nBmpWidth; wRow++, wByteIdex += 3) {
                    int clr = bitmap.getPixel(wRow, nCol);
                    bmpData[nRealCol * wWidth + wByteIdex] = (byte) Color.blue(clr);
                    bmpData[nRealCol * wWidth + wByteIdex + 1] = (byte) Color.green(clr);
                    bmpData[nRealCol * wWidth + wByteIdex + 2] = (byte) Color.red(clr);
                }
            fileos.write(bmpData);
            fileos.flush();
            fileos.close();
            iResult = 0;
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return iResult;
    }

    protected static void writeWord(FileOutputStream stream, int value) throws IOException {
        byte[] b = new byte[2];
        b[0] = (byte) (value & 0xff);
        b[1] = (byte) (value >> 8 & 0xff);
        stream.write(b);
    }

    protected static void writeDword(FileOutputStream stream, long value) throws IOException {
        byte[] b = new byte[4];
        b[0] = (byte) (value & 0xff);
        b[1] = (byte) (value >> 8 & 0xff);
        b[2] = (byte) (value >> 16 & 0xff);
        b[3] = (byte) (value >> 24 & 0xff);
        stream.write(b);
    }

    protected static void writeLong(FileOutputStream stream, long value) throws IOException {
        byte[] b = new byte[4];
        b[0] = (byte) (value & 0xff);
        b[1] = (byte) (value >> 8 & 0xff);
        b[2] = (byte) (value >> 16 & 0xff);
        b[3] = (byte) (value >> 24 & 0xff);
        stream.write(b);
    }

    public static String readTxtFile(String path){
        String str = "";
        try {
            File urlFile = new File(path);
            InputStreamReader isr = new InputStreamReader(new FileInputStream(urlFile), "UTF-8");
            BufferedReader br = new BufferedReader(isr);

            String mimeTypeLine = null ;
            while ((mimeTypeLine = br.readLine()) != null) {
                str = str+mimeTypeLine;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return  str;
    }

    public static String encodeCN(String data) {
        byte[] bytes;
        try {
            bytes = data.getBytes("gbk");
            StringBuilder sb = new StringBuilder(bytes.length * 2);
            for (int i = 0; i < bytes.length; i++) {
                sb.append(hexString.charAt((bytes[i] & 0xf0) >> 4));
                sb.append(hexString.charAt((bytes[i] & 0x0f) >> 0));
            }
            return sb.toString();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return "";
    }

    public static String encodeStr(String data) {
        String result = "";
        byte[] b;
        try {
            b = data.getBytes("gbk");
            for (int i = 0; i < b.length; i++) {
                result += Integer.toString((b[i] & 0xff) + 0x100, 16)
                        .substring(1);
            }
            return result;
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return "";
    }

    public static boolean isCN(String data) {
        boolean flag = false;
        String regex = "^[\u4e00-\u9fa5]*$";
        if (data.matches(regex)) {
            flag = true;
        }
        return flag;
    }

    //获取文件后缀名
    public static String getExtensionName(String filename) {
        if ((filename != null) && (filename.length() > 0)) {
            int dot = filename.lastIndexOf('.');
            if ((dot > -1) && (dot < (filename.length() - 1))) {
                return filename.substring(dot + 1);
            }
        }
        return filename;
    }

    /**
     * 字符串转含0x 16进制
     * @param paramString
     * @return
     */
    private static byte[] hexStr2Bytesnoenter(String paramString) {
        String[] paramStr = paramString.split(" ");
        byte[] arrayOfByte = new byte[paramStr.length];

        for (int j = 0; j < paramStr.length; j++) {
            arrayOfByte[j] = Integer.decode("0x" + paramStr[j]).byteValue();
        }
        return arrayOfByte;
    }

    /// <summary>
    /// byte数组转int数组
    /// </summary>
    /// <param name="src">源byte数组</param>
    /// <param name="offset">起始位置</param>
    /// <returns></returns>
    public static int[] bytesToInt(byte[] src, int offset)
    {
        int[] values=new int[src.length/4];
        for (int i = 0; i < src.length / 4; i++)
        {
            int value = (int)((src[offset] & 0xFF)
                    | ((src[offset + 1] & 0xFF) << 8)
                    | ((src[offset + 2] & 0xFF) << 16)
                    | ((src[offset + 3] & 0xFF) << 24));
            values[i] = value;
            offset += 4;
        }
        return values;
    }

    /**
     * 字节数组转16进制
     * @param bytes 需要转换的byte数组
     * @return  转换后的Hex字符串
     */
    public static String bytesToHex(byte[] bytes) {
        StringBuffer sb = new StringBuffer();
        for(int i = 0; i < bytes.length; i++) {
            String hex = Integer.toHexString(bytes[i] & 0xFF);
            if(hex.length() < 2){
                sb.append(0);
            }
            sb.append(hex);
        }
        return sb.toString();
    }

    public static String  unicodeToUtf8 (String s) {
        Log.e("TAG",getEncoding(s));
        try {
            if(getEncoding(s) == "UTF-8"){
                return new String( s.getBytes("GBK") , "UTF-8");
            }else
            if(getEncoding(s) == "GBK"||getEncoding(s) == "GB2312"){
                return new String( s.getBytes("GBK") , "GBK");
            }else
            if(getEncoding(s) == "ISO-8859-1"){
                return new String( s.getBytes("ISO-8859-1") , "UTF-8");
            }

        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String getEncoding(String str) {
        String encode = "GB2312";
        try {
            if (str.equals(new String(str.getBytes(encode), encode))) {
                String s = encode;
                return s;
            }
        } catch (Exception exception) {
        }
        encode = "ISO-8859-1";
        try {
            if (str.equals(new String(str.getBytes(encode), encode))) {
                String s1 = encode;
                return s1;
            }
        } catch (Exception exception1) {
        }
        encode = "UTF-8";
        try {
            if (str.equals(new String(str.getBytes(encode), encode))) {
                String s2 = encode;
                return s2;
            }
        } catch (Exception exception2) {
        }
        encode = "GBK";
        try {
            if (str.equals(new String(str.getBytes(encode), encode))) {
                String s3 = encode;
                return s3;
            }
        } catch (Exception exception3) {
        }
        return "";
    }

    /**
     * 判断字符串内是不是16进制的值
     * @param str
     * @return
     */
    public static boolean isHexStrValid(String str) {
        String pattern = "^[0-9A-F]+$";
        return Pattern.compile(pattern).matcher(str).matches();
    }

    static public byte hexToByte(String inHex)// Hex字符串转byte
    {
        return (byte) Integer.parseInt(inHex, 16);
    }

//    -----------------------------------------------------------------------------------
    /**
     * 将字符串形式表示的十六进制数转换为byte数组
     */
    public static byte[] hexStringToBytes(String hexString) {
        String strValues = hexString.toUpperCase().replace(" ","");
        if(!isHexStrValid(strValues))
            return null;

        int iHexlen = strValues.length();
        if ((iHexlen%2) != 0) {// 奇数
            return null;
        }
        byte[] result = new byte[(iHexlen / 2)];
        int j = 0;
        for (int i = 0; i < iHexlen; i += 2) {
            result[j] = hexToByte(strValues.substring(i, i + 2));
            j++;
        }
        return result;
    }

    // -------------------------------------------------------
    static public String byteArrToHex(byte[] inBytArr)// 字节数组转转hex字符串
    {
        StringBuilder strBuilder = new StringBuilder();
        int j = inBytArr.length;
        for (int i = 0; i < j; i++) {
            strBuilder.append(Byte2Hex(inBytArr[i]));
            strBuilder.append(" ");
        }
        return strBuilder.toString();
    }
    // -------------------------------------------------------
    static public String Byte2Hex(Byte inByte)// 1字节转2个Hex字符
    {
        return String.format("%02x", inByte).toUpperCase();
    }
 
    //获取文件获取内容 iDataType = 0 txt数据;iDataType = 1 BIN十六进制数据
    public static String ReadDataFile(String strFilePath,int iDataType){
        String path = strFilePath;
        String strResult = "";
        List<String> newList=new ArrayList<String>();
        //打开文件
        File file = new File(path);
        //如果path是传递过来的参数，可以做一个非目录的判断
        if (file.isDirectory()){
            Log.d("TestFile", "The File doesn't not exist.");
        }
        else{
            try {
                // 获取文件
                FileInputStream fin = new FileInputStream(strFilePath);
                // 获得长度
                int length = fin.available();
                // 创建字节数组
                byte[] buffer = new byte[length];
                // 读取内容
                fin.read(buffer);

                if(iDataType==0) {
                    // 获得编码格式
                    String type = getCodetype(buffer);
                    // 按编码格式获得内容
                    strResult = new String(buffer, type)
                    ;
                }else{
                    strResult = byteArrToHex(buffer);
                }
            } catch (FileNotFoundException e) {
                Log.d("TestFile", "The File doesn't not exist.");
                strResult = e.getMessage();
            } catch (Exception e) {
                Log.d("TestFile", e.getMessage());
                strResult = e.getMessage();
            }
        }
        return strResult;
    }

    /**
     * // 获得编码格式
     * @param head
     * @return
     */
    private static String getCodetype(byte[] head) {
        String type = "";
        byte[] codehead = new byte[3];
        System.arraycopy(head, 0, codehead, 0, 3);
        if(codehead[0] == -1 && codehead[1] == -2) {
            type = "UTF-16";
        }
        else if(codehead[0] == -2 && codehead[1] == -1) {
            type = "UNICODE";
        }
        else if(codehead[0] == -17 && codehead[1] == -69 && codehead[2] == -65) {
            type = "UTF-8";
        }
        else {
            type = "GB2312";
        }
        return type;
    }

    //从resources中的raw 文件夹中获取文件并读取数据
    public static String getFromRaw(InputStream in){
        String result = "";
        try {
            //获取文件的字节数
            int lenght = in.available();
            //创建byte数组
            byte[]  buffer = new byte[lenght];
            //将文件中的数据读到byte数组中
            in.read(buffer);
           result = new String(buffer, ENCODING);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 获取当前时间
     * @return
     */
    public static String getCurrentTime(){
        Date date = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss ");
        String strTime = dateFormat.format(date);
        return strTime;
    }

    public static String getFilePathByUri(Context context, Uri uri) {
        String path = null;
        try {
            // 以 file:// 开头的
            if (ContentResolver.SCHEME_FILE.equals(uri.getScheme())) {
                path = uri.getPath();
                return path;
            }
            // 以 content:// 开头的，比如 content://media/extenral/images/media/17766
            if (ContentResolver.SCHEME_CONTENT.equals(uri.getScheme()) && Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
                Cursor cursor = context.getContentResolver().query(uri, new String[]{MediaStore.Images.Media.DATA}, null, null, null);
                if (cursor != null) {
                    if (cursor.moveToFirst()) {
                        int columnIndex = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
                        if (columnIndex > -1) {
                            path = cursor.getString(columnIndex);
                        }
                    }
                    cursor.close();
                }
                return path;
            }
            // 4.4及之后的 是以 content:// 开头的，比如 content://com.android.providers.media.documents/document/image%3A235700
            if (ContentResolver.SCHEME_CONTENT.equals(uri.getScheme()) && Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                if (DocumentsContract.isDocumentUri(context, uri)) {
                    if (isExternalStorageDocument(uri)) {
                        // ExternalStorageProvider
                        final String docId = DocumentsContract.getDocumentId(uri);
                        final String[] split = docId.split(":");
                        final String type = split[0];
                        if ("primary".equalsIgnoreCase(type)) {
                            path = Environment.getExternalStorageDirectory() + "/" + split[1];
                            return path;
                        }
                    } else if (isDownloadsDocument(uri)) {
                        // DownloadsProvider
                        final String id = DocumentsContract.getDocumentId(uri);
                        final Uri contentUri = ContentUris.withAppendedId(Uri.parse("content://downloads/public_downloads"),
                                Long.valueOf(id));
                        path = getDataColumn(context, contentUri, null, null);
                        return path;
                    } else if (isMediaDocument(uri)) {
                        // MediaProvider
                        final String docId = DocumentsContract.getDocumentId(uri);
                        final String[] split = docId.split(":");
                        final String type = split[0];
                        Uri contentUri = null;
                        if ("image".equals(type)) {
                            contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                        } else if ("video".equals(type)) {
                            contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                        } else if ("audio".equals(type)) {
                            contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
                        }
                        final String selection = "_id=?";
                        final String[] selectionArgs = new String[]{split[1]};
                        path = getDataColumn(context, contentUri, selection, selectionArgs);
                        return path;
                    }
                } else    //不用"图片",用"图库"来选
                {
                    String[] filePathColumn = {MediaStore.Images.Media.DATA};
                    Cursor cursor = context.getContentResolver().query(uri, filePathColumn, null, null, null);
                    cursor.moveToFirst();
                    int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
                    path = cursor.getString(columnIndex);
                    cursor.close();
                    return path;
                }
            }
        }catch (Exception e){}
        return path;
    }
    private static String getDataColumn(Context context, Uri uri, String selection, String[] selectionArgs) {
        Cursor cursor = null;
        final String column = "_data";
        final String[] projection = {column};
        try {
            cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs, null);
            if (cursor != null && cursor.moveToFirst()) {
                final int column_index = cursor.getColumnIndexOrThrow(column);
                return cursor.getString(column_index);
            }
        } finally {
            if (cursor != null)
                cursor.close();
        }
        return null;
    }
    private static boolean isExternalStorageDocument(Uri uri) {
        return "com.android.externalstorage.documents".equals(uri.getAuthority());
    }
    private static boolean isDownloadsDocument(Uri uri) {
        return "com.android.providers.downloads.documents".equals(uri.getAuthority());
    }
    private static boolean isMediaDocument(Uri uri) {
        return "com.android.providers.media.documents".equals(uri.getAuthority());
    }

    /**
     * jpg png bmp 彩色图片转换Bitmap数据为int[]数组
     * @param bm
     * @return int[]
     */
    public static int[] getPixelsByBitmap(Bitmap bm) {
        int width, heigh;
        width = bm.getWidth();
        heigh = bm.getHeight();
        int iDataLen = width * heigh;
        int[] pixels = new int[iDataLen];
        bm.getPixels(pixels, 0, width, 0, 0, width, heigh);
        return pixels;
    }
}
