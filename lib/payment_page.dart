import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String paymentUrl;

  const PaymentPage({super.key, required this.paymentUrl});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},

          // --- BAGIAN PENTING: MENCEGAT URL REDIRECT ---
          onNavigationRequest: (NavigationRequest request) {
            // Cek jika URL yang mau dibuka mengandung 'example.com'
            if (request.url.contains('example.com')) {
              // Cek status transaksi dari URL parameter
              // URL biasanya: http://example.com/?order_id=XXX&status_code=200&transaction_status=settlement

              if (request.url.contains('transaction_status=settlement') ||
                  request.url.contains('transaction_status=capture')) {
                // JIKA SUKSES
                _handlePaymentSuccess();
              } else if (request.url.contains('transaction_status=pending')) {
                // JIKA PENDING
                _handlePaymentPending();
              } else {
                // JIKA GAGAL
                _handlePaymentFailed();
              }

              // JANGAN buka halaman example.com (Cegah)
              return NavigationDecision.prevent;
            }

            // Kalau bukan example.com (masih halaman midtrans), izinkan
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handlePaymentSuccess() {
    // Navigator.pop(context, true) artinya:
    // Tutup halaman ini DAN kirim nilai 'true' ke halaman sebelumnya
    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Successful!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _handlePaymentPending() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Pending. Please complete your payment."),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handlePaymentFailed() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Failed!"),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Cancel Payment?"),
                content:
                    const Text("Are you sure you want to close this page?"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("No")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      child: const Text("Yes")),
                ],
              ),
            );
          },
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
