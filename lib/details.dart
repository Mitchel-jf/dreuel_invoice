import 'package:flutter/material.dart';

import 'table_model.dart';

class Details {
  String acctName,
      acctNumber,
      bank,
      date,
      deliveryDate,
      billTo,
      service,
      invoiceNumber;
  Widget logo;
  List<TableModel> tableRows;

  @override
  String toString() {
    return super.toString();
  }
}
