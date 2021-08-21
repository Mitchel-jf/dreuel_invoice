import 'package:dreuel_invoice/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        controller: context.read(invoiceProvider).scrollController,
        children: [
          Label('LOGO'),
          Consumer(
            builder: (_, watch, __) {
              var p = watch(invoiceProvider);
              if (p.details.logo == null)
                return IconButton(
                  icon: Icon(Icons.add_photo_alternate_outlined),
                  onPressed: context.read(invoiceProvider).addLogo,
                );
              else
                return Center(
                  child: IconButton(
                    icon: Icon(Icons.image_not_supported_outlined),
                    onPressed: context.read(invoiceProvider).removeLogo,
                  ),
                );
            },
          ),
          SizedBox(height: 10),
          Label('Account Deatils'),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: context.read(invoiceProvider).acctNameController,
                  onChanged: context.read(invoiceProvider).onAcctNameChanged,
                  decoration: InputDecoration(labelText: 'Account Name'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller:
                      context.read(invoiceProvider).acctNumberController,
                  onChanged: context.read(invoiceProvider).onAcctNumberChanged,
                  decoration: InputDecoration(labelText: 'Account Number'),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: context.read(invoiceProvider).bankController,
                  onChanged: context.read(invoiceProvider).onBankChanged,
                  decoration: InputDecoration(labelText: 'Bank'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(child: SizedBox(width: 10)),
            ],
          ),

          // invoice
          SizedBox(height: 20),
          Label('Invoice'),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller:
                      context.read(invoiceProvider).invoiceNumberController,
                  onChanged:
                      context.read(invoiceProvider).onInvoiceNumberChanged,
                  decoration: InputDecoration(labelText: 'Invoice'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: context.read(invoiceProvider).dateController,
                  onChanged: context.read(invoiceProvider).onDateChanged,
                  decoration: InputDecoration(labelText: 'Date'),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller:
                      context.read(invoiceProvider).deliveryDateController,
                  onChanged:
                      context.read(invoiceProvider).onDeliveryDateChanged,
                  decoration: InputDecoration(labelText: 'Delivery Date'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(child: SizedBox(width: 10)),
            ],
          ),

          // Bill to & Service
          SizedBox(height: 20),
          Label('Bill to & Service'),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: context.read(invoiceProvider).billToController,
                  onChanged: context.read(invoiceProvider).onBillToChanged,
                  decoration: InputDecoration(labelText: 'Bill to:'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: context.read(invoiceProvider).serviceController,
                  onChanged: context.read(invoiceProvider).onServiceChanged,
                  decoration: InputDecoration(labelText: 'Service'),
                ),
              )
            ],
          ),

          //table
          SizedBox(height: 20),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Label('Breakdown Table'),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: context.read(invoiceProvider).addTableRow,
                ),
              ],
            ),
          ),

          //
          Consumer(
            builder: (_, watch, __) {
              var p = watch(invoiceProvider);
              return ListView.builder(
                shrinkWrap: true,
                itemCount: p.tableRows.length,
                itemBuilder: (_, i) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(Icons.cancel_outlined),
                            onPressed: () => p.removeTableRow(i)),
                        Expanded(
                          child: TextFormField(
                            controller: p.tableRows[i].descriptionController,
                            onChanged:
                                context.read(invoiceProvider).onTableItemChanged,
                            decoration:
                                InputDecoration(labelText: 'Description:'),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller:
                                p.tableRows[i].unitPriceController,
                            onChanged:
                                context.read(invoiceProvider).onTableItemChanged,
                            decoration: InputDecoration(labelText: 'Unit Price'),
                          ),
                        )
                      ],
                    ),

                    //
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.cancel_outlined),
                          onPressed: null,
                          color: Colors.transparent,
                          disabledColor: Colors.transparent,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller:
                                p.tableRows[i].quantityController,
                            onChanged:
                                context.read(invoiceProvider).onTableItemChanged,
                            decoration: InputDecoration(labelText: 'Quantity:'),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller:
                                p.tableRows[i].totalController,
                            onChanged:
                                context.read(invoiceProvider).onTableItemChanged,
                            decoration: InputDecoration(labelText: 'Total'),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          
        ],
      ),
    );
  }
}

class Label extends StatelessWidget {
  final String label;

  const Label(this.label, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$label',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
