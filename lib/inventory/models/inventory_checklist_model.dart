class InventoryCheckList {
  String name;
  String quantity;
  String productLocation;
  String productPosition;
  String imageUrl;

  InventoryCheckList(
    this.name,
    this.quantity,
    this.productLocation,
    this.productPosition,
    this.imageUrl,
  );

  factory InventoryCheckList.fromJSON(Map<String, dynamic> json) {
    return InventoryCheckList(json["name"], json["quantity"],
        json["productLocation"], json["productPosition"], json["imageUrl"]);
  }

  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "quantity": quantity,
      "productLocation": productLocation,
      "productPosition": productPosition,
      "imageUrl": imageUrl
    };
  }
}
