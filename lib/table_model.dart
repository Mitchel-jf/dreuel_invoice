import 'package:flutter/cupertino.dart';

class TableModel {
   TextEditingController descriptionController,
      unitPriceController,
      quantityController,
      totalController;
  

  TableModel({
    this.descriptionController,
    this.unitPriceController,
    this.quantityController,
    this.totalController,
  });
}
