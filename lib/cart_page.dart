import 'package:flutter/material.dart';
import 'cart_data.dart'; // File data cart global
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'payment_page.dart'; // File halaman WebView

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Variabel untuk loading saat tombol ditekan
  bool isCheckingOut = false;

  // Fungsi hapus item
  void removeItem(int index) {
    setState(() {
      myCart.removeAt(index);
    });
  }

  // --- FUNGSI BARU: PROSES CHECKOUT ---
  Future<void> processCheckout() async {
    setState(() {
      isCheckingOut = true; // Nyalakan loading
    });

    // 1. Ambil User ID dari Session Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('userID');

    // Cek apakah user sudah login
    if (userID == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please Login first to checkout!")),
      );
      setState(() => isCheckingOut = false);
      return;
    }

    // 2. Hitung Total Harga (dikonversi ke Integer)
    int totalAmount = calculateTotal().toInt();

    // 3. Kirim Data ke PHP
    // Pastikan IP Address benar (10.0.3.2 untuk Genymotion, 10.0.2.2 untuk Emulator Android)
    String url = "http://10.0.3.2/servershop_nauval/checkout.php";

    try {
      var response = await http.post(Uri.parse(url), body: {
        "user_id": userID,
        "total_amount": totalAmount.toString(),
      });

      var data = json.decode(response.body);

      if (data['success'] == true) {
        // Jika sukses, ambil Link Pembayaran
        String paymentUrl = data['payment_url'];

        // 4. Buka Halaman Webview (PaymentPage)
        if (!mounted) return;

        // Kita pakai 'await' untuk menunggu PaymentPage ditutup
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentPage(paymentUrl: paymentUrl),
          ),
        );

        // 5. Cek Hasilnya
        // Jika result == true (dikirim dari _handlePaymentSuccess)
        if (result == true) {
          setState(() {
            removePurchasedItems(); // Hapus barang yang dibeli
          });

          // Opsional: Redirect ke Home kalau Cart jadi kosong semua
          if (myCart.isEmpty) {
            Navigator.pop(context); // Kembali ke Home
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
      isCheckingOut = false; // Matikan loading
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
                        // --- UPDATE NOMOR 3 DI SINI ---
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          // Logika tombol: Jika sedang loading, tombol mati (null)
                          onPressed: isCheckingOut
                              ? null
                              : () {
                                  // Cek apakah ada barang yang dipilih (Total > 0)
                                  if (calculateTotal() > 0) {
                                    processCheckout(); // PANGGIL FUNGSI CHECKOUT
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
                          // Tampilan tombol: Jika loading muncul putaran, jika tidak muncul teks Checkout
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
