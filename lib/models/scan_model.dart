class ScanModel {
  String productName;
  String message;
  String reason;
  String companyName;
  String? companyImage;
  String companyproof;
  String proofUrl;
  String parentCompanyName;
  String parentUrl;


  ScanModel({
    required this.productName,
    required this.message,
    required this.reason,
    required this.companyName,
    this.companyImage,
    required this.companyproof,
    required this.proofUrl,
    required this.parentCompanyName,
    required this.parentUrl,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) {
    final barcodeDetails = json["barcode_details"] ?? {};
    final company = json["company"] ?? {};
    final parentCompany = json["parentCompany"]??{};
    return ScanModel(
      productName: barcodeDetails["product_name"] ?? "",
      message: json["message"] ?? "",
      reason: json["reason"] ?? "",
      companyName: company["name"] ?? "",
      companyImage: company["image"],
      companyproof: company[ "proof"],
      proofUrl: company[ "proof_url"],
      parentCompanyName: parentCompany["name"],
      parentUrl: parentCompany["proof_url"]

    );
  }
}
