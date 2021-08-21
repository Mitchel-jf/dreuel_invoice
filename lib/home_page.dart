import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'invoice_editor.dart';
import 'invoice_preview.dart';
import 'invoice_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suigeneris Invoice'),
        actions: [
          IconButton(
            icon: Icon(Icons.download_outlined),
            onPressed: context.read(invoiceProvider).takeScreenshot,
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(child: InvoiceEditor()),
          VerticalDivider(),
          Expanded(child: InvoicePreview()),
        ],
      ),
    );
  }
}

