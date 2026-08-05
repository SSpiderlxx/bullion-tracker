import 'metal_type.dart';
import 'weight_unit.dart';

class Holding {
  final String id;
  final MetalType metalType;
  final String productName;
  final DateTime purchaseDate;
  final String dealer;
  final double weightInGrams;
  final WeightUnit weightUnit;
  final double displayQuantity;
  final double purity;
  final double purchasePrice;
  final double premiumPaid;
  final double shippingCost;
  final double fees;
  final double totalCost;
  final String? notes;
  final String? receiptPhotoPath;
  final bool isSold;
  final DateTime? soldDate;
  final double? soldPrice;
  final double? soldQuantityGrams;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Holding({
    required this.id,
    required this.metalType,
    required this.productName,
    required this.purchaseDate,
    required this.dealer,
    required this.weightInGrams,
    required this.weightUnit,
    required this.displayQuantity,
    required this.purity,
    required this.purchasePrice,
    required this.premiumPaid,
    required this.shippingCost,
    required this.fees,
    required this.totalCost,
    this.notes,
    this.receiptPhotoPath,
    this.isSold = false,
    this.soldDate,
    this.soldPrice,
    this.soldQuantityGrams,
    required this.createdAt,
    required this.updatedAt,
  });

  Holding copyWith({
    String? id,
    MetalType? metalType,
    String? productName,
    DateTime? purchaseDate,
    String? dealer,
    double? weightInGrams,
    WeightUnit? weightUnit,
    double? displayQuantity,
    double? purity,
    double? purchasePrice,
    double? premiumPaid,
    double? shippingCost,
    double? fees,
    double? totalCost,
    String? notes,
    String? receiptPhotoPath,
    bool? isSold,
    DateTime? soldDate,
    double? soldPrice,
    double? soldQuantityGrams,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Holding(
      id: id ?? this.id,
      metalType: metalType ?? this.metalType,
      productName: productName ?? this.productName,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      dealer: dealer ?? this.dealer,
      weightInGrams: weightInGrams ?? this.weightInGrams,
      weightUnit: weightUnit ?? this.weightUnit,
      displayQuantity: displayQuantity ?? this.displayQuantity,
      purity: purity ?? this.purity,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      premiumPaid: premiumPaid ?? this.premiumPaid,
      shippingCost: shippingCost ?? this.shippingCost,
      fees: fees ?? this.fees,
      totalCost: totalCost ?? this.totalCost,
      notes: notes ?? this.notes,
      receiptPhotoPath: receiptPhotoPath ?? this.receiptPhotoPath,
      isSold: isSold ?? this.isSold,
      soldDate: soldDate ?? this.soldDate,
      soldPrice: soldPrice ?? this.soldPrice,
      soldQuantityGrams: soldQuantityGrams ?? this.soldQuantityGrams,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
