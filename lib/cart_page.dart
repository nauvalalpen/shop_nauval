import 'package:flutter/material.dart';
import 'cart_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'payment_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isCheckingOut = false;
  void removeItem(int index) {
    setState(() {
      myCart.removeAt(index);
    });
  }

  Future<void> processCheckout() async {
    setState(() {
      isCheckingOut = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('userID');
    if (userID == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please Login first to checkout!")),
      );
      setState(() => isCheckingOut = false);
      return;
    }
    int totalAmount = calculateTotal().toInt();
    String url =
        "https://shopnauval.alwaysdata.net/servershop_nauval/checkout.php";

    try {
      var response = await http.post(Uri.parse(url), body: {
        "user_id": userID,
        "total_amount": totalAmount.toString(),
      });

      var data = json.decode(response.body);

      if (data['success'] == true) {
        String paymentUrl = data['payment_url'];
        if (!mounted) return;
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentPage(paymentUrl: paymentUrl),
          ),
        );
        if (result == true) {
          setState(() {
            removePurchasedItems();
          });
          if (myCart.isEmpty) {
            Navigator.pop(context);
          }
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${data['message']}")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server Error / Connection Refused")),
      );
    }

    setState(() {
      isCheckingOut = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: myCart.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: myCart.length,
                    itemBuilder: (context, index) {
                      final item = myCart[index];
                      final displayPrice = item['promo'] ?? item['price'];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            Checkbox(
                              activeColor: Colors.green,
                              value: item['isSelected'] ?? true,
                              onChanged: (bool? value) {
                                setState(() {
                                  item['isSelected'] = value;
                                });
                              },
                            ),
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Image.network(
                                  item['images'] ?? '',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) =>
                                      const Icon(Icons.broken_image),
                                ),
                                title: Text(
                                  item['name'] ?? 'Product',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "Rp. $displayPrice",
                                  style: const TextStyle(color: Colors.blue),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    removeItem(index);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          offset: const Offset(0, -3)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Selected:",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            "Rp. ${calculateTotal()}",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: isCheckingOut
                              ? null
                              : () {
                                  if (calculateTotal() > 0) {
                                    processCheckout();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Please select items to checkout"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                          child: isCheckingOut
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text("Checkout",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
