List<dynamic> myCart = [];
double calculateTotal() {
  double total = 0;
  for (var item in myCart) {
    if (item['isSelected'] == true) {
      var price = item['promo'] ?? item['price'];
      total += double.parse(price.toString());
    }
  }
  return total;
}

void removePurchasedItems() {
  // Hapus semua item yang isSelected-nya true
  myCart.removeWhere((item) => item['isSelected'] == true);
}
