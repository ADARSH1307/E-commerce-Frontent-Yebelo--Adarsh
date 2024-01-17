import 'package:flutter/material.dart';
import 'package:e_commerce_yebelo_adarsh/products/product_service.dart';
import 'package:e_commerce_yebelo_adarsh/products/product_dialog.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> originalProducts = [];
  List<Map<String, dynamic>> filteredProducts = [];
  String selectedCategory = 'All';
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    List<Map<String, dynamic>> productList = await ProductService.getProducts();
    setState(() {
      originalProducts = productList;
      filteredProducts = productList;
    });
  }

  void filterProducts() {
    setState(() {
      if (selectedCategory == '' || selectedCategory == 'All') {
        filteredProducts = originalProducts;
      } else {
        filteredProducts = originalProducts
            .where((product) => product['p_category'] == selectedCategory)
            .toList();
      }
    });
  }

  void openDialog(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Quantity'),
          content: Container(
            padding: EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text("Enter the ${product['p_name']}'s quantity:"),
                    SizedBox(width: 3),
                    Container(
                      width: 36,
                      height: 36,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            quantity = int.tryParse(value) ?? 1;
                          });
                        },
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        textAlign: TextAlign.center, 
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets
                              .zero, 
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                checkAvailability(product);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void checkAvailability(Map<String, dynamic> product) {
    if (quantity <= product['p_availability']) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ProductDialog(product: product, quantity: quantity);
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Insufficient Quantity'),
            content: Text(
                'Sorry, we have only ${product['p_availability']} ${product['p_name']} available.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: Column(
        children: [
         
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Select Category:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
               Container(
                height: 45,
                padding: EdgeInsets.all(8),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.black, width: 1),
    borderRadius: BorderRadius.circular(8),
  ),
  child: DropdownButton<String>(
    value: selectedCategory,
    onChanged: (value) {
      setState(() {
        selectedCategory = value!;
        filterProducts();
      });
    },
    items: ['All', 'Premium', 'Tamilnadu', 'Karnataka', 'Nagpur']
        .map((String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value,
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            ))
        .toList(),
    style: TextStyle(color: Colors.black),
    underline: Container(), 
  ),
),

              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                var product = filteredProducts[index];
                return Card(
                  elevation: 7,
                  margin: EdgeInsets.all(8),
                  child: ListTile(
  contentPadding: EdgeInsets.all(0),
  title: Row(
    children: [
      SizedBox(
        width: 120,
        height: 120,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/${product['image']}',
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(width: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product['p_name'],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '${product['p_category']} - \₹${product['p_cost']}',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Availability: ${product['p_availability'] >= 1 ? 'In Stock' : 'Out of Stock'}',
            style: TextStyle(
              fontSize: 16,
              color: product['p_availability'] >= 1 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ],
  ),
  onTap: () => openDialog(product),
)

                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
