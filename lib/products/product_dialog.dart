import 'package:flutter/material.dart';

class ProductDialog extends StatelessWidget {
  final Map<String, dynamic> product;
  final int quantity;

  ProductDialog({required this.product, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(product['p_name'], style: TextStyle(fontSize: 25,color: Color.fromARGB(255, 0, 0, 0)),),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('ID: ${product['p_id']}', style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 0, 0, 0)),),
          Text('Cost: \₹${product['p_cost']}', style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 0, 0, 0)),),
          Text('Availability: ${product['p_availability'] >= 1 ? 'In Stock' : 'Out of Stock'}', style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 0, 0, 0)),),
        
          Text('Quantity: $quantity', style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 0, 0, 0)),),
                    SizedBox(height: 16),

                    Center(
                      child: Text('Order Placed',
                      style: TextStyle(fontSize: 25,color: Color.fromARGB(255, 0, 0, 0)),),
                    ),

        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
