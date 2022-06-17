class DishwareCheckList {
  String quantity;
  String imageUrl;
  String color;
  Map<String, dynamic> tags;
  Map<String, dynamic> locations;

  DishwareCheckList(
      this.quantity, this.imageUrl, this.color, this.tags, this.locations);

  factory DishwareCheckList.fromJSON(Map<String, dynamic> json) {
    return DishwareCheckList(json["quantity"].toString(), json["imageUrl"],
        json["color"], Map.from(json['tags']), Map.from(json["locations"]));
  }

  Map<String, dynamic> toJSON() {
    return {
      "quantity": quantity,
      "imageUrl": imageUrl,
      "color": color,
      "tags": tags,
      "locations": locations
    };
  }
}
