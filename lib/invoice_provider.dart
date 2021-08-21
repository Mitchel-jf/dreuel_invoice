import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dreuel_invoice/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'table_model.dart';

final invoiceProvider = ChangeNotifierProvider((ref) => InvoiceProvider());

class InvoiceProvider extends ChangeNotifier {
  final preview = GlobalKey();
  Details details = Details();

  ScrollController scrollController = ScrollController();

  var acctNameController = TextEditingController();
  var acctNumberController = TextEditingController();
  var bankController = TextEditingController();
  var invoiceNumberController = TextEditingController();
  var dateController = TextEditingController();
  var deliveryDateController = TextEditingController();
  var billToController = TextEditingController();
  var serviceController = TextEditingController();

  List<TableModel> tableRows = [
    TableModel(
      descriptionController: TextEditingController(text: ''),
      unitPriceController: TextEditingController(text: ''),
      quantityController: TextEditingController(text: ''),
      totalController: TextEditingController(text: ''),
    )
  ];

  void takeScreenshot() async {
    RenderRepaintBoundary boundary = preview.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    download(pngBytes);
  }

  void download(Uint8List bytes) {
    final content = base64Encode(bytes);
    AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$content")
      ..setAttribute('download', 'invoice.jpeg')
      ..click();
  }

  void addLogo() {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files.length == 1) {
        final file = files[0];
        FileReader reader = FileReader();
        //
        reader.onLoad.listen((event) {
          details.logo = Image.memory(reader.result);
          // print(reader.result);
          notifyListeners();
        });
        //
        reader.onError.listen((event) {
          print('There\'s error');
        });
        reader.readAsArrayBuffer(file);
      }
    });
  }

  void removeLogo() {
    details.logo = null;
    notifyListeners();
  }

  void addTableRow() {
    tableRows.add(TableModel(
      descriptionController: TextEditingController(text: ''),
      unitPriceController: TextEditingController(text: ''),
      quantityController: TextEditingController(text: ''),
      totalController: TextEditingController(text: ''),
    ));
    notifyListeners();
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  void removeTableRow(int i) {
    tableRows.removeAt(i);
    notifyListeners();
  }

  String calculateSubTotal() {
    double subTotal = 0;
    for (var row in tableRows) {
      double d = double.tryParse(row.totalController.text);
      if (d == null) {
        return '-'; 
      }
      subTotal += d;
    }
    ;
    return subTotal.toStringAsFixed(2);
  }

  void onAcctNameChanged(String value) {
    details.acctName = value;
    notifyListeners();
  }

  void onAcctNumberChanged(String value) {
    details.acctNumber = value;
    notifyListeners();
  }

  void onBankChanged(String value) {
    details.bank = value;
    notifyListeners();
  }

  void onDateChanged(String value) {
    details.date = value;
    notifyListeners();
  }

  void onDeliveryDateChanged(String value) {
    details.deliveryDate = value;
    notifyListeners();
  }

  void onBillToChanged(String value) {
    details.billTo = value;
    notifyListeners();
  }

  void onServiceChanged(String value) {
    details.service = value;
    notifyListeners();
  }

  void onInvoiceNumberChanged(String value) {
    details.invoiceNumber = value;
    notifyListeners();
  }

  void onTableItemChanged(String value) {
    notifyListeners();
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  ui.Path getClip(ui.Size size) {
    ui.Path path = ui.Path();
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.width / 2);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<ui.Path> oldClipper) => false;
}
