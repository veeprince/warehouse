class DishwareCheckList {
  String name;
  String quantity;
  String color;
  String productPosition;
  String imageUrl;
  String type;
  String size;
  List<String> tags;

  DishwareCheckList(this.name, this.quantity, this.color, this.productPosition,
      this.imageUrl, this.type, this.size, this.tags);

  factory DishwareCheckList.fromJSON(Map<String, dynamic> json) {
    return DishwareCheckList(
      json["name"],
      json["quantity"].toString(),
      json["color"],
      json["productPosition"],
      json["imageUrl"],
      json["type"],
      json["size"],
      List.from(json['tags']),
    );
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
      "tags": tags,
    };
  }
}
