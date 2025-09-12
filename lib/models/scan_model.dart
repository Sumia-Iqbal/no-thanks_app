class ScanModel {
  String message;
  String reason;
  String companyName;
  String companyImageUrl;   // ✅ company image url
  String companyProof;
  String companyProofUrl;
  String productName;
  String productImageUrl;   // ✅ product image url
  String productProof;
  String productProofUrl;
  String parentCompanyName;

  ScanModel({
    required this.message,
    required this.reason,
    required this.companyName,
    required this.companyImageUrl,
    required this.companyProof,
    required this.companyProofUrl,
    required this.productName,
    required this.productImageUrl,
    required this.productProof,
    required this.productProofUrl,
    required this.parentCompanyName,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) {
    final company = json["company"] ?? {};
    final product = json["product"] ?? {};
    final barcodeDetails = json["barcode_details"] ?? {};

    return ScanModel(
      message: json["message"] ?? "",
      reason: json["reason"] ?? "",
      companyName: company["name"] ?? "",
      companyImageUrl: company["image_url"] ?? "",   // 🔥 null safe
      companyProof: company["proof"] ?? "",
      companyProofUrl: company["proof_url"] ?? "",
      productName: product["name"] ?? barcodeDetails["product_name"] ?? "",
      productImageUrl: product["image_url"] ?? "",   // 🔥 null safe
      productProof: product["proof"] ?? "",
      productProofUrl: product["proof_url"] ?? "",
      parentCompanyName: product["parentCompany"] ?? "",
    );
  }
}
