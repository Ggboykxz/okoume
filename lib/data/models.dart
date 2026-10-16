import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/ui/app_icons.dart';

// ============================================================ Rôles & enums

enum UserRole { acheteur, vendeur, livreur }

extension UserRoleX on UserRole {
  String get label => switch (this) {
        UserRole.acheteur => 'Acheteur',
        UserRole.vendeur => 'Vendeur',
        UserRole.livreur => 'Livreur',
      };
  String get emoji => switch (this) {
        UserRole.acheteur => '🛍️',
        UserRole.vendeur => '🏪',
        UserRole.livreur => '🛵',
      };
  AppIconData get icon => switch (this) {
        UserRole.acheteur => AppIcons.shopping_bag_rounded,
        UserRole.vendeur => AppIcons.storefront_rounded,
        UserRole.livreur => AppIcons.electric_moped_rounded,
      };
}

enum SellerType { social, commercant, artisan, entreprise }

extension SellerTypeX on SellerType {
  String get label => switch (this) {
        SellerType.social => 'Vendeur social',
        SellerType.commercant => 'Commerçant',
        SellerType.artisan => 'Artisan / Producteur',
        SellerType.entreprise => 'Entreprise',
      };
}

enum OrderStatus {
  enAttente,
  confirmee,
  enPreparation,
  expediee,
  enLivraison,
  livree,
  annulee,
}

extension OrderStatusX on OrderStatus {
  String get label => switch (this) {
        OrderStatus.enAttente => 'En attente',
        OrderStatus.confirmee => 'Confirmée',
        OrderStatus.enPreparation => 'En préparation',
        OrderStatus.expediee => 'Expédiée',
        OrderStatus.enLivraison => 'En livraison',
        OrderStatus.livree => 'Livrée',
        OrderStatus.annulee => 'Annulée',
      };
  String get emoji => switch (this) {
        OrderStatus.enAttente => '⏳',
        OrderStatus.confirmee => '✅',
        OrderStatus.enPreparation => '📦',
        OrderStatus.expediee => '🚚',
        OrderStatus.enLivraison => '🛵',
        OrderStatus.livree => '🎉',
        OrderStatus.annulee => '❌',
      };
  Color get color => switch (this) {
        OrderStatus.enAttente => AppColors.pending,
        OrderStatus.confirmee => AppColors.confirmed,
        OrderStatus.enPreparation => AppColors.preparing,
        OrderStatus.expediee => AppColors.shipped,
        OrderStatus.enLivraison => AppColors.inDelivery,
        OrderStatus.livree => AppColors.delivered,
        OrderStatus.annulee => AppColors.cancelled,
      };
  /// Position dans la timeline (confirmee → livree = 0 → 4).
  int get step => switch (this) {
        OrderStatus.enAttente || OrderStatus.confirmee => 0,
        OrderStatus.enPreparation => 1,
        OrderStatus.expediee => 2,
        OrderStatus.enLivraison => 3,
        OrderStatus.livree => 4,
        OrderStatus.annulee => -1,
      };
  bool get isActive => this != OrderStatus.livree && this != OrderStatus.annulee;

  OrderStatus get next => switch (this) {
        OrderStatus.enAttente => OrderStatus.confirmee,
        OrderStatus.confirmee => OrderStatus.enPreparation,
        OrderStatus.enPreparation => OrderStatus.expediee,
        OrderStatus.expediee => OrderStatus.enLivraison,
        OrderStatus.enLivraison => OrderStatus.livree,
        _ => this,
      };
}

enum PaymentMethod { airtel, moov, carte, cash, wallet }

extension PaymentMethodX on PaymentMethod {
  String get label => switch (this) {
        PaymentMethod.airtel => 'Airtel Money',
        PaymentMethod.moov => 'Moov Money',
        PaymentMethod.carte => 'Carte bancaire',
        PaymentMethod.cash => 'Paiement à la livraison',
        PaymentMethod.wallet => 'Portefeuille Okoumé',
      };
  String get emoji => switch (this) {
        PaymentMethod.airtel => '📲',
        PaymentMethod.moov => '📲',
        PaymentMethod.carte => '💳',
        PaymentMethod.cash => '💵',
        PaymentMethod.wallet => '👛',
      };
  String get tagline => switch (this) {
        PaymentMethod.airtel => 'Payez depuis votre compte Airtel',
        PaymentMethod.moov => 'Payez depuis votre compte Moov',
        PaymentMethod.carte => 'Visa / Mastercard sécurisé',
        PaymentMethod.cash => 'Vous payez à la réception',
        PaymentMethod.wallet => 'Solde prépayé instantané',
      };
  Color get color => switch (this) {
        PaymentMethod.airtel => AppColors.airtel,
        PaymentMethod.moov => AppColors.moov,
        PaymentMethod.carte => AppColors.visa,
        PaymentMethod.cash => AppColors.success,
        PaymentMethod.wallet => AppColors.secondary,
      };
  bool get isMobileMoney =>
      this == PaymentMethod.airtel || this == PaymentMethod.moov;
}

enum DeliveryMode { domicile, pointRelais, retraitVendeur }

extension DeliveryModeX on DeliveryMode {
  String get label => switch (this) {
        DeliveryMode.domicile => 'Livraison à domicile',
        DeliveryMode.pointRelais => 'Point de retrait',
        DeliveryMode.retraitVendeur => 'Retrait chez le vendeur',
      };
  String get emoji => switch (this) {
        DeliveryMode.domicile => '🛵',
        DeliveryMode.pointRelais => '📦',
        DeliveryMode.retraitVendeur => '🏪',
      };
  int get fee => switch (this) {
        DeliveryMode.domicile => 1500,
        DeliveryMode.pointRelais => 700,
        DeliveryMode.retraitVendeur => 0,
      };
  String get hint => switch (this) {
        DeliveryMode.domicile => 'Le livreur vient à votre porte',
        DeliveryMode.pointRelais => 'Locker ou boutique partenaire',
        DeliveryMode.retraitVendeur => 'Récupérez chez la boutique',
      };
}

enum DeliverySpeed { express, standard, programme }

extension DeliverySpeedX on DeliverySpeed {
  String get label => switch (this) {
        DeliverySpeed.express => 'Express',
        DeliverySpeed.standard => 'Standard',
        DeliverySpeed.programme => 'Programmée',
      };
  String get hint => switch (this) {
        DeliverySpeed.express => '< 2 h en moto',
        DeliverySpeed.standard => 'Aujourd\'hui / demain',
        DeliverySpeed.programme => 'Choisir un créneau',
      };
  int get extraFee => switch (this) {
        DeliverySpeed.express => 1000,
        _ => 0,
      };
}

enum MessageKind { text, image, voice, offer }

enum VehicleType { moto, voiture, camionnette }

extension VehicleTypeX on VehicleType {
  String get label => switch (this) {
        VehicleType.moto => 'Moto',
        VehicleType.voiture => 'Voiture',
        VehicleType.camionnette => 'Camionnette',
      };
  String get emoji => switch (this) {
        VehicleType.moto => '🛵',
        VehicleType.voiture => '🚗',
        VehicleType.camionnette => '🚚',
      };
}

// ============================================================== Modèles

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    required this.count,
  });

  final String id;
  final String name;
  final String emoji;
  final Color color;
  final int count;
}

class Seller {
  const Seller({
    required this.id,
    required this.name,
    required this.type,
    required this.emoji,
    required this.seed,
    required this.verified,
    required this.rating,
    required this.reviews,
    required this.city,
    required this.followers,
    required this.description,
    required this.responseMin,
    required this.sinceYear,
  });

  final String id;
  final String name;
  final SellerType type;
  final String emoji;
  final int seed;
  final bool verified;
  final double rating;
  final int reviews;
  final String city;
  final int followers;
  final String description;
  final int responseMin;
  final int sinceYear;
}

class ProductVariant {
  const ProductVariant(this.name, this.values);

  final String name;
  final List<String> values;
}

class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    this.oldPrice,
    required this.emoji,
    required this.seed,
    required this.categoryId,
    required this.sellerId,
    required this.rating,
    required this.reviews,
    required this.sold,
    required this.stock,
    required this.city,
    required this.description,
    this.tags = const [],
    this.variants = const [],
    this.characteristics = const {},
    this.express = false,
    this.isService = false,
    this.condition,
    required this.createdAt,
  });

  final String id;
  final String title;
  final int price;
  final int? oldPrice;
  final String emoji;
  final int seed;
  final String categoryId;
  final String sellerId;
  final double rating;
  final int reviews;
  final int sold;
  final int stock;
  final String city;
  final String description;
  final List<String> tags;
  final List<ProductVariant> variants;
  final Map<String, String> characteristics;
  final bool express;
  final bool isService;
  final String? condition;
  final DateTime createdAt;

  int get discountPercent => oldPrice == null
      ? 0
      : (((oldPrice! - price) / oldPrice!) * 100).round();

  bool get isFlash => discountPercent >= 15 && !isService;
}

class Review {
  const Review({
    required this.author,
    required this.emoji,
    required this.rating,
    required this.date,
    required this.text,
  });

  final String author;
  final String emoji;
  final double rating;
  final DateTime date;
  final String text;
}

class ProductQA {
  const ProductQA(this.question, this.answer, this.author);

  final String question;
  final String answer;
  final String author;
}

class BannerPromo {
  const BannerPromo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.colors,
    required this.tag,
  });

  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> colors;
  final String tag;
}

class PromoCode {
  const PromoCode({
    required this.code,
    required this.label,
    required this.minOrder,
    this.percent,
    this.fixed,
    this.freeShipping = false,
  });

  final String code;
  final String label;
  final int minOrder;
  final int? percent;
  final int? fixed;
  final bool freeShipping;

  int discountFor(int subtotal) {
    if (subtotal < minOrder) return 0;
    if (percent != null) return (subtotal * percent! / 100).round();
    if (fixed != null) return fixed!;
    return 0;
  }
}

class CartLine {
  const CartLine({
    required this.productId,
    required this.qty,
    this.variant = const {},
  });

  final String productId;
  final int qty;
  final Map<String, String> variant;

  CartLine copyWith({int? qty, Map<String, String>? variant}) => CartLine(
        productId: productId,
        qty: qty ?? this.qty,
        variant: variant ?? this.variant,
      );

  String get variantLabel =>
      variant.entries.map((e) => e.value).join(' · ');
}

class Address {
  const Address({
    required this.id,
    required this.label,
    required this.details,
    required this.city,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String details;
  final String city;
  final bool isDefault;

  String get full => '$details, $city';
}

class OrderLine {
  const OrderLine({
    required this.productId,
    required this.title,
    required this.emoji,
    required this.seed,
    required this.price,
    required this.qty,
    this.variantLabel = '',
    required this.sellerName,
  });

  final String productId;
  final String title;
  final String emoji;
  final int seed;
  final int price;
  final int qty;
  final String variantLabel;
  final String sellerName;

  int get total => price * qty;
}

class OrderEvent {
  const OrderEvent({
    required this.status,
    required this.time,
    this.done = true,
  });

  final OrderStatus status;
  final DateTime time;
  final bool done;
}

class Order {
  const Order({
    required this.id,
    required this.code,
    required this.createdAt,
    required this.lines,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.status,
    required this.payment,
    required this.deliveryLabel,
    required this.eta,
    required this.addressLabel,
    required this.otp,
    required this.escrowHeld,
    this.rated = false,
    required this.events,
  });

  final String id;
  final String code;
  final DateTime createdAt;
  final List<OrderLine> lines;
  final int subtotal;
  final int deliveryFee;
  final int discount;
  final OrderStatus status;
  final PaymentMethod payment;
  final String deliveryLabel;
  final DateTime eta;
  final String addressLabel;
  final String otp;
  final bool escrowHeld;
  final bool rated;
  final List<OrderEvent> events;

  int get total => subtotal + deliveryFee - discount;

  Order copyWith({
    OrderStatus? status,
    bool? escrowHeld,
    bool? rated,
    List<OrderEvent>? events,
  }) =>
      Order(
        id: id,
        code: code,
        createdAt: createdAt,
        lines: lines,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        discount: discount,
        status: status ?? this.status,
        payment: payment,
        deliveryLabel: deliveryLabel,
        eta: eta,
        addressLabel: addressLabel,
        otp: otp,
        escrowHeld: escrowHeld ?? this.escrowHeld,
        rated: rated ?? this.rated,
        events: events ?? this.events,
      );
}

class Livreur {
  const Livreur({
    required this.name,
    required this.emoji,
    required this.vehicle,
    required this.plate,
    required this.rating,
    required this.courses,
    required this.phone,
  });

  final String name;
  final String emoji;
  final VehicleType vehicle;
  final String plate;
  final double rating;
  final int courses;
  final String phone;
}

class Course {
  const Course({
    required this.id,
    required this.pickup,
    required this.dropoff,
    required this.distanceKm,
    required this.payout,
    required this.etaMin,
    required this.vehicle,
    this.sellerEmoji = '🏪',
  });

  final String id;
  final String pickup;
  final String dropoff;
  final double distanceKm;
  final int payout;
  final int etaMin;
  final VehicleType vehicle;
  final String sellerEmoji;
}

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.fromMe,
    required this.time,
    this.kind = MessageKind.text,
    this.read = true,
  });

  final String text;
  final bool fromMe;
  final DateTime time;
  final MessageKind kind;
  final bool read;
}

class ChatThread {
  const ChatThread({
    required this.id,
    required this.sellerId,
    this.unread = 0,
    required this.messages,
  });

  final String id;
  final String sellerId;
  final int unread;
  final List<ChatMessage> messages;

  ChatMessage? get last => messages.isEmpty ? null : messages.last;

  ChatThread copyWith({int? unread, List<ChatMessage>? messages}) => ChatThread(
        id: id,
        sellerId: sellerId,
        unread: unread ?? this.unread,
        messages: messages ?? this.messages,
      );
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.emoji,
    this.read = false,
  });

  final String id;
  final String title;
  final String body;
  final DateTime time;
  final String emoji;
  final bool read;

  AppNotification copyWith({bool? read}) => AppNotification(
        id: id,
        title: title,
        body: body,
        time: time,
        emoji: emoji,
        read: read ?? this.read,
      );
}

class WalletTxn {
  const WalletTxn({
    required this.label,
    required this.amount,
    required this.date,
    required this.emoji,
  });

  final String label;
  final int amount;
  final DateTime date;
  final String emoji;
}

class SellerStats {
  const SellerStats({
    required this.weekly,
    required this.monthRevenue,
    required this.monthOrders,
    required this.avgBasket,
    required this.views,
    required this.conversion,
  });

  final List<int> weekly; // CA des 7 derniers jours
  final int monthRevenue;
  final int monthOrders;
  final int avgBasket;
  final int views;
  final double conversion;
}

class AppUser {
  const AppUser({
    required this.name,
    required this.phone,
    required this.role,
    required this.emoji,
    this.email,
    this.city,
    this.points = 0,
    this.balance = 0,
    this.kycVerified = false,
    this.referralCode = 'OKOUME-241',
  });

  final String name;
  final String phone;
  final UserRole role;
  final String emoji;
  final String? email;
  final String? city;
  final int points;
  final int balance;
  final bool kycVerified;
  final String referralCode;

  AppUser copyWith({
    int? points,
    int? balance,
    UserRole? role,
    String? name,
    String? email,
    String? city,
  }) =>
      AppUser(
        name: name ?? this.name,
        phone: phone,
        role: role ?? this.role,
        emoji: emoji,
        email: email ?? this.email,
        city: city ?? this.city,
        points: points ?? this.points,
        balance: balance ?? this.balance,
        kycVerified: kycVerified,
        referralCode: referralCode,
      );
}
