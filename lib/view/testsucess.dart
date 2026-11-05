import 'package:flutter/material.dart';
import 'package:kiosk/models/save_bill_body.dart';
import 'package:kiosk/view/homepage.dart';

class Testsucess extends StatefulWidget {
  const Testsucess({
    super.key,
    this.name,
    this.add1,
    this.add2,
    this.billno,
    this.date,
    this.mode,
    this.pooja,
    this.total,
  });
  final String? name;
  final String? add1;
  final String? add2;
  final String? billno;
  final String? date;
  final String? mode;
  final String? total;
  final List<PoojaDetails>? pooja;

  @override
  State<Testsucess> createState() => _TestsucessState();
}

class _TestsucessState extends State<Testsucess> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(minutes: 1),
      () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
        (route) => false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380),
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  widget.name ?? "NA",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  widget.add1 ?? "NA",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  widget.add2 ?? "NA",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(thickness: 2),
              const SizedBox(height: 10),
              Text(
                'Bill No: ${widget.billno ?? "NA"}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Bill Date: ${widget.date ?? "NA"}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // _buildReceiptRows(
              //   'Bill No: ${billno ?? "NA"}',
              //   'Bill Date: ${date ?? "NA"}',
              //   isBold: true,
              // ),
              const Divider(),
              if (widget.pooja == null || widget.pooja!.isEmpty)
                const Text("No pooja details", style: TextStyle(fontSize: 16))
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < widget.pooja!.length; i++) ...[
                      Text(
                        '${i + 1}. ${widget.pooja![i].name ?? "NA"} - ${widget.pooja![i].star ?? "NA"}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${widget.pooja![i].diety ?? "NA"}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${widget.pooja![i].pooja ?? "NA"} - ₹ ${widget.pooja![i].rate ?? "NA"}x${widget.pooja![i].qty ?? "NA"}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Divider(),
                    ],
                  ],
                ),
              const Divider(thickness: 2),
              _buildReceiptRows(
                'Mode: ${widget.mode ?? "NA"}',
                'Total: ₹ ${widget.total ?? "NA"}',
                isBold: true,
              ),
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  'Thank you!',
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildReceiptRows(
  String leftText,
  String rightText, {
  bool isBold = false,
}) {
  final style = TextStyle(
    fontSize: 16,
    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
  );
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(leftText, overflow: TextOverflow.ellipsis, style: style),
        ),
        Expanded(
          flex: 1,
          child: Text(
            rightText,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    ),
  );
}
