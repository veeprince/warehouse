class DishwareCheckList {
  String name;
  String quantity;
  String color;
  String productPosition;
  String imageUrl;
  String size;
  Map<String, dynamic> tags;

  DishwareCheckList(this.name, this.quantity, this.color, this.productPosition,
      this.imageUrl, this.size, this.tags);

  factory DishwareCheckList.fromJSON(Map<String, dynamic> json) {
    return DishwareCheckList(
      json["name"],
      json["quantity"].toString(),
      json["color"],
      json["productPosition"],
      json["imageUrl"],
      json["size"],
      Map.from(json['tags']),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "quantity": quantity,
      "color": color,
      "productPosition": productPosition,
      "imageUrl": imageUrl,
      "size": size,
      "tags": tags,
    };
  }
}
