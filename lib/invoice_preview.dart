import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'invoice_provider.dart';

class InvoicePreview extends StatefulWidget {
  @override
  _InvoicePreviewState createState() => _InvoicePreviewState();
}

class _InvoicePreviewState extends State<InvoicePreview> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: RepaintBoundary(
          key: context.read(invoiceProvider).preview,
          child: Container(
            color: Colors.white,
            child: ListView(children: [
              // logo and paid status
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Consumer(
                  builder: (_, watch, __) {
                    var p = watch(invoiceProvider);
                    return SizedBox(
                    height: 70,
                      child: p.details.logo == null
                          ? Center(child: Text('LOGO'))
                          : p.details.logo,
                    );
                  },
                ),
                SizedBox(
                    height:
                        40), // this removes the overlapping of the unpaid status
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    color: Colors.pink,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Transform.rotate(
                        alignment: Alignment.centerRight,
                        angle: pi / 4,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                          child: Text(
                            'Unpaid',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
              // SizedBox(height: 30),
              // invoice heading and address
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PROFORMA INVOICE',
                    style: TextStyle(
                      fontFamily: 'Futura',
                      color: Colors.pink,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                  Consumer(
                    builder: (_, watch, __) {
                      var p = watch(invoiceProvider);
                      return Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: "\nAccount Details\n",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "Account Name: ${p.details.acctName ?? ''}\n",
                          ),
                          TextSpan(
                            text:
                                "Account Number: ${p.details.acctNumber ?? ''}\n",
                          ),
                          TextSpan(
                            text: "Bank: ${p.details.bank ?? ''}\n\n",
                          ),
                          TextSpan(
                            text: "Invoice\n",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                "Invoice Number: ${p.details.invoiceNumber ?? ''}\n",
                          ),
                          TextSpan(
                            text: "Date: ${p.details.date ?? ''}\n",
                          ),
                          TextSpan(
                            text:
                                "Duration/Delivery Date: ${p.details.deliveryDate ?? ''}",
                          ),
                        ]),
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ],
              ),

              // bill to and service
              Align(
                alignment: Alignment.centerLeft,
                child: Consumer(
                  builder: (_, watch, __) {
                    var p = watch(invoiceProvider);
                    return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text.rich(
                                TextSpan(
                                    text: 'Bill to: ',
                                    style: TextStyle(
                                        color: Colors.pink, fontSize: 11),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${p.details.billTo?.toUpperCase() ?? 'COMPANY NAME'}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 13),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text.rich(
                                TextSpan(
                                    text: 'Service: ',
                                    style: TextStyle(
                                        color: Colors.pink, fontSize: 11),
                                    children: [
                                      TextSpan(
                                        text: '${p.details.service ?? 'SERVICE '
                                            'RENDERED'}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 13),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ]);
                  },
                ),
              ),

              SizedBox(height: 10),

              // table
              Consumer(
                builder: (_, watch, __) {
                  var p = watch(invoiceProvider);
                  return Table(
                    columnWidths: {
                      0: FlexColumnWidth(.25),
                      1: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                          decoration: BoxDecoration(color: Colors.yellow),
                          children: [
                            Text('S/N'),
                            Text('DESCRIPTION'),
                            Text('UNIT PRICE'),
                            Text('QUANTITY'),
                            Text('TOTAL (NGN)'),
                          ]),
                      for (var i = 0; i < p.tableRows.length; i++)
                        TableRow(children: [
                          Text('${i + 1}'),
                          Text('${p.tableRows[i].descriptionController.text}'),
                          Text('${p.tableRows[i].unitPriceController.text}'),
                          Text('${p.tableRows[i].quantityController.text}'),
                          Text('${p.tableRows[i].totalController.text}'),
                        ]),
                    ],
                  );
                },
              ),

              Table(
                children: [
                  TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(),
                        ),
                      ),
                      children: [
                        Text(''),
                        Text(''),
                        Text(''),
                        Text(''),
                        Text(''),
                      ]),
                  TableRow(children: [
                    Text(''),
                    Text(''),
                    Text(''),
                    Text('SUB-TOTAL'),
                    Consumer(
                      builder: (_, watch, __) {
                        var p = watch(invoiceProvider).calculateSubTotal();
                        return Text('$p');
                      },
                    ),
                  ]),
                  TableRow(children: [
                    Text(''),
                    Text(''),
                    Text(''),
                    Text('DISCOUNT'),
                    Text('0.00%'),
                  ]),
                  TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(),
                        ),
                      ),
                      children: [
                        Text(''),
                        Text(''),
                        Text(''),
                        Text('TOTAL',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Consumer(
                          builder: (_, watch, __) {
                            var p = watch(invoiceProvider).calculateSubTotal();
                            return Text(
                              '$p',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ]),
                ],
              ),

              SizedBox(height: 10),

              // payment terms and method
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Payment Terms',
                          style: TextStyle(color: Colors.pink)),
                      Text(
                        '75% deposit required before payment',
                        // style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      Text(
                        '25% balance payment on delivery',
                        // style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ]),
                Image.asset('images/qr-code.PNG'),
              ]),
              SizedBox(height: 10),
              Divider(color: Colors.grey),
              SizedBox(height: 10),

              Center(
                child: Text(
                    'Dreamworld Africana Amusement Park, Beside Orchid Hotel, Eleganza Bus/Stop, Lekki.\n+234 7085332288, suigeneris.com.ng, suigeneriskoncept@gmail.com, info@suigeneris.com.ng',
                    textAlign: TextAlign.center),
              ),

              SizedBox(height: 40),

              // decoration
            ]),
          ),
        ),
      ),
    );
  }
}
