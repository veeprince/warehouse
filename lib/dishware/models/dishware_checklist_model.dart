class DishwareCheckList {
  String name;
  String quantity;
  String color;
  String productPosition;
  String imageUrl;
  String type;
  String size;

  DishwareCheckList(this.name, this.quantity, this.color, this.productPosition,
      this.imageUrl, this.type, this.size);

  factory DishwareCheckList.fromJSON(Map<String, dynamic> json) {
    return DishwareCheckList(
        json["name"],
        json["quantity"].toString(),
        json["color"],
        json["productPosition"],
        json["imageUrl"],
        json["type"],
        json["size"]);
  }

  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "quantity": quantity,
      "color": color,
      "productPosition": productPosition,
      "imageUrl": imageUrl,
      "type": type,
      "size": size,
    };
  }
}
