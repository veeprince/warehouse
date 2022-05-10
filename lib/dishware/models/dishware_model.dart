class Dishware {
  final String name, color, productPosition, imageUrl, size, quantity;
  List<String> tags;

  Dishware(
      {this.name = "",
      this.quantity = "",
      this.color = "",
      this.productPosition = "",
      this.imageUrl = "",
      this.size = "",
      required this.tags});
}
