import 'package:flutter/material.dart';

import 'models.dart';

final _now = DateTime.now();

/// Jeu de données de démonstration — 100% local (mode hors ligne).
abstract final class Mock {
 // ============================================================ Catégories
 static const categories = <Category>[
 Category(id: 'c1', name: 'Alimentation', emoji: '', color: Color(0xFF12889B), count: 1284),
 Category(id: 'c2', name: 'Électronique', emoji: '', color: Color(0xFF2F6FDB), count: 942),
 Category(id: 'c3', name: 'Mode', emoji: '', color: Color(0xFFD84262), count: 763),
 Category(id: 'c4', name: 'Maison', emoji: '', color: Color(0xFF7C4DFF), count: 517),
 Category(id: 'c5', name: 'Beauté & Santé', emoji: '', color: Color(0xFFE07A1F), count: 388),
 Category(id: 'c6', name: 'Auto & Moto', emoji: '', color: Color(0xFF4A5B7A), count: 274),
 Category(id: 'c7', name: 'Services', emoji: '', color: Color(0xFF1F9D55), count: 452),
 Category(id: 'c8', name: 'Artisanat', emoji: '', color: Color(0xFF9A7B2D), count: 196),
 Category(id: 'c9', name: 'Immobilier', emoji: '', color: Color(0xFF0066CC), count: 89),
 Category(id: 'c10', name: 'Animaux', emoji: '', color: Color(0xFF7B8B3D), count: 143),
 ];

 // ============================================================== Vendeurs
 static const sellers = <Seller>[
 Seller(id: 's1', name: 'Maman Édith — Frais du marché', type: SellerType.social, emoji: '', seed: 2, verified: true, rating: 4.8, reviews: 312, city: 'Libreville — Mont-Bouët', followers: 1840, description: 'Produits frais du marché Mont-Bouët, livrés le jour même dans tout Libreville.', responseMin: 5, sinceYear: 2023),
 Seller(id: 's2', name: 'TechLibre 241', type: SellerType.commercant, emoji: '', seed: 0, verified: true, rating: 4.7, reviews: 521, city: 'Libreville — Glass', followers: 4210, description: 'Smartphones, accessoires et high-tech neufs et reconditionnés. Garantie 6 mois.', responseMin: 3, sinceYear: 2021),
 Seller(id: 's3', name: 'Atelier Mabé & Co', type: SellerType.artisan, emoji: '', seed: 6, verified: true, rating: 4.9, reviews: 188, city: 'Libreville — Akanda', followers: 970, description: 'Bijoux en perles de Mabé, sculptures et artisanat 100% gabonais.', responseMin: 15, sinceYear: 2022),
 Seller(id: 's4', name: "Douceur de l'Ogooué", type: SellerType.artisan, emoji: '', seed: 1, verified: true, rating: 4.9, reviews: 96, city: 'Lambaréné', followers: 620, description: 'Miel, karité, huiles et savons naturels du Moyen-Ogooué.', responseMin: 20, sinceYear: 2023),
 Seller(id: 's5', name: 'LibreStyle Boutique', type: SellerType.commercant, emoji: '', seed: 4, verified: false, rating: 4.5, reviews: 274, city: 'Libreville — Centre', followers: 2310, description: 'Mode femme & homme, wax, sur-mesure. Nouveautés chaque semaine.', responseMin: 10, sinceYear: 2020),
 Seller(id: 's6', name: 'MotoCenter Gabon', type: SellerType.commercant, emoji: '', seed: 7, verified: true, rating: 4.6, reviews: 163, city: 'Owendo', followers: 1140, description: 'Motos, pièces et accessoires. Atelier agréé toutes marques.', responseMin: 12, sinceYear: 2019),
 Seller(id: 's7', name: 'Maison Bantou Déco', type: SellerType.commercant, emoji: '', seed: 3, verified: false, rating: 4.4, reviews: 88, city: 'Libreville — Louis', followers: 430, description: 'Meubles, déco et électroménager. Livraison et montage inclus.', responseMin: 25, sinceYear: 2021),
 Seller(id: 's8', name: 'Glow Beauté LBV', type: SellerType.social, emoji: '', seed: 4, verified: false, rating: 4.7, reviews: 205, city: 'Libreville — Nzeng-Ayong', followers: 1520, description: 'Coiffure, ongles et soins à domicile sur rendez-vous. ', responseMin: 8, sinceYear: 2022),
 Seller(id: 's9', name: 'Pro Services 241', type: SellerType.entreprise, emoji: '', seed: 7, verified: true, rating: 4.5, reviews: 141, city: 'Libreville — PK9', followers: 760, description: 'Plomberie, électricité, solaire et cours particuliers. Devis gratuit.', responseMin: 30, sinceYear: 2018),
 Seller(id: 's10', name: 'AgroPêche Akanda', type: SellerType.commercant, emoji: '', seed: 5, verified: true, rating: 4.8, reviews: 233, city: 'Akanda', followers: 2050, description: 'Poisson frais et fumé, huile de palme, riz — du producteur au client.', responseMin: 10, sinceYear: 2020),
 Seller(id: 's11', name: 'Ferme Okala', type: SellerType.artisan, emoji: '', seed: 2, verified: false, rating: 4.6, reviews: 74, city: 'Ntoum', followers: 380, description: 'Élevage fermier : volailles, chèvres, œufs frais. Retrait ou livraison.', responseMin: 45, sinceYear: 2021),
 Seller(id: 's12', name: 'Immo Nzeng-Ayong', type: SellerType.entreprise, emoji: '', seed: 0, verified: true, rating: 4.3, reviews: 57, city: 'Libreville', followers: 910, description: 'Terrains titrés, appartements et bureaux à louer ou vendre.', responseMin: 60, sinceYear: 2017),
 ];

 // ============================================================== Produits
 static final products = <Product>[
 Product(id: 'p1', title: 'Manioc frais du jour (5 kg)', price: 3500, emoji: '', seed: 2, categoryId: 'c1', sellerId: 's1', rating: 4.8, reviews: 231, sold: 890, stock: 120, city: 'Libreville', description: 'Manioc frais du marché Mont-Bouët, cueilli le matin même. Idéal pour le bâton de manioc et le tapioca.', tags: ['Frais', 'Local'], express: true, characteristics: {'Origine': 'Mont-Bouët', 'Poids': '5 kg'}, createdAt: _now.subtract(const Duration(days: 12))),
 Product(id: 'p2', title: 'Poisson salé fumé — lot de 10', price: 12500, oldPrice: 15000, emoji: '', seed: 5, categoryId: 'c1', sellerId: 's10', rating: 4.9, reviews: 187, sold: 430, stock: 64, city: 'Akanda', description: 'Capitaine fumé au bois, séché selon la tradition. Parfait pour le nzangué et les sauces.', tags: ['Fumé', 'Local'], express: true, characteristics: {'Type': 'Capitaine', 'Lot': '10 pièces'}, createdAt: _now.subtract(const Duration(days: 8))),
 Product(id: 'p3', title: 'Huile de palme rouge (5 L)', price: 8500, emoji: '', seed: 1, categoryId: 'c1', sellerId: 's10', rating: 4.7, reviews: 152, sold: 610, stock: 80, city: 'Akanda', description: 'Huile rouge artisanale, pressée localement. Goût authentique pour vos plats.', tags: ['Local'], characteristics: {'Contenance': '5 L'}, createdAt: _now.subtract(const Duration(days: 21))),
 Product(id: 'p4', title: 'Bâtons de manioc (50 pièces)', price: 5000, emoji: '', seed: 2, categoryId: 'c1', sellerId: 's1', rating: 4.8, reviews: 96, sold: 720, stock: 200, city: 'Libreville', description: 'Bâtons de manioc frais, emballés en feuilles. Prêts à consommer.', express: true, createdAt: _now.subtract(const Duration(days: 30))),
 Product(id: 'p5', title: 'Attiéké premium (2 kg)', price: 3000, emoji: '', seed: 6, categoryId: 'c1', sellerId: 's1', rating: 4.6, reviews: 84, sold: 540, stock: 150, city: 'Libreville', description: 'Attiéké fin et grainé, préparé le jour même.', express: true, createdAt: _now.subtract(const Duration(days: 18))),
 Product(id: 'p6', title: 'Ananas pain de sucre (x3)', price: 4500, emoji: '', seed: 3, categoryId: 'c1', sellerId: 's1', rating: 4.9, reviews: 142, sold: 380, stock: 90, city: 'Libreville', description: 'Ananas sucrés et juteux du Sud, triés à la main.', express: true, createdAt: _now.subtract(const Duration(days: 9))),
 Product(id: 'p7', title: 'Riz parfumé — sac 25 kg', price: 22000, oldPrice: 24500, emoji: '', seed: 1, categoryId: 'c1', sellerId: 's10', rating: 4.8, reviews: 267, sold: 350, stock: 46, city: 'Akanda', description: 'Riz parfumé longue grain, sac de 25 kg.', createdAt: _now.subtract(const Duration(days: 34))),
 Product(id: 'p8', title: 'Chocolat de Ntoum (100 g)', price: 2500, emoji: '', seed: 6, categoryId: 'c1', sellerId: 's11', rating: 4.7, reviews: 63, sold: 210, stock: 75, city: 'Ntoum', description: 'Tablette de chocolat artisanal 70%, cacao de Ntoum.', tags: ['Made in Gabon'], createdAt: _now.subtract(const Duration(days: 26))),
 Product(id: 'p9', title: 'Samsung Galaxy A15 — 128 Go', price: 145000, oldPrice: 159000, emoji: '', seed: 0, categoryId: 'c2', sellerId: 's2', rating: 4.7, reviews: 312, sold: 156, stock: 24, city: 'Libreville', description: 'Smartphone neuf scellé, garantie 6 mois. Écran AMOLED 6,5", batterie 5000 mAh, double SIM.', tags: ['Neuf', 'Garantie 6 mois'], variants: [ProductVariant('Couleur', ['Noir', 'Bleu']), ProductVariant('Stockage', ['128 Go', '256 Go'])], characteristics: {'Écran': '6,5" AMOLED', 'Batterie': '5000 mAh', 'Garantie': '6 mois'}, express: true, createdAt: _now.subtract(const Duration(days: 5))),
 Product(id: 'p10', title: 'iPhone 13 reconditionné — 128 Go', price: 385000, emoji: '', seed: 0, categoryId: 'c2', sellerId: 's2', rating: 4.6, reviews: 189, sold: 42, stock: 6, city: 'Libreville', description: 'iPhone 13 grade A+, batterie ≥ 87%, garantie 6 mois, débloqué tout opérateur.', tags: ['Reconditionné', 'Garantie 6 mois'], variants: [ProductVariant('Couleur', ['Minuit', 'Rose', 'Blanc']), ProductVariant('Stockage', ['128 Go', '256 Go'])], express: true, createdAt: _now.subtract(const Duration(days: 11))),
 Product(id: 'p11', title: 'Écouteurs Bluetooth ANC', price: 22000, oldPrice: 29000, emoji: '', seed: 5, categoryId: 'c2', sellerId: 's2', rating: 4.5, reviews: 421, sold: 310, stock: 58, city: 'Libreville', description: 'Réduction de bruit active, autonomie 30 h, étui de charge USB-C.', express: true, createdAt: _now.subtract(const Duration(days: 3))),
 Product(id: 'p12', title: 'Power bank 20 000 mAh', price: 18500, emoji: '', seed: 8, categoryId: 'c2', sellerId: 's2', rating: 4.6, reviews: 233, sold: 178, stock: 44, city: 'Libreville', description: 'Charge rapide 22,5 W, 3 ports, affichage LED du niveau.', express: true, createdAt: _now.subtract(const Duration(days: 16))),
 Product(id: 'p13', title: 'Chargeur rapide GaN 65 W', price: 15000, emoji: '', seed: 1, categoryId: 'c2', sellerId: 's2', rating: 4.8, reviews: 97, sold: 260, stock: 70, city: 'Libreville', description: 'Charge téléphone, tablette et PC portables. Compact et sûr.', express: true, createdAt: _now.subtract(const Duration(days: 20))),
 Product(id: 'p14', title: 'TV LED 43" Smart', price: 185000, emoji: '', seed: 7, categoryId: 'c2', sellerId: 's2', rating: 4.4, reviews: 76, sold: 22, stock: 4, city: 'Libreville', description: 'TV 43 pouces Full HD, Wi-Fi, Netflix & YouTube intégrés. Livraison incluse à Libreville.', express: true, createdAt: _now.subtract(const Duration(days: 14))),
 Product(id: 'p15', title: 'Ventilateur sur pied 3 vitesses', price: 25000, emoji: '', seed: 3, categoryId: 'c4', sellerId: 's7', rating: 4.3, reviews: 58, sold: 40, stock: 18, city: 'Libreville', description: 'Ventilateur silencieux, hauteur réglable, oscillation 90.', createdAt: _now.subtract(const Duration(days: 27))),
 Product(id: 'p16', title: 'Groupe électrogène 2,5 kVA', price: 210000, emoji: '', seed: 7, categoryId: 'c6', sellerId: 's6', rating: 4.5, reviews: 41, sold: 12, stock: 3, city: 'Owendo', description: 'Groupe électrogène essence, démarrage manuel, 2,5 kVA. Garantie 1 an.', tags: ['Garantie 1 an'], createdAt: _now.subtract(const Duration(days: 40))),
 Product(id: 'p17', title: 'Kit solaire 100 W + batterie', price: 95000, oldPrice: 120000, emoji: '', seed: 3, categoryId: 'c4', sellerId: 's9', rating: 4.6, reviews: 88, sold: 34, stock: 9, city: 'Libreville', description: 'Panneau 100 W, batterie 100 Ah, régulateur et câblage. Idéal en cas de délestage.', express: true, createdAt: _now.subtract(const Duration(days: 6))),
 Product(id: 'p18', title: 'Canapé 3 places (très bon état)', price: 165000, emoji: '', seed: 3, categoryId: 'c4', sellerId: 's7', rating: 4.5, reviews: 33, sold: 3, stock: 1, city: 'Libreville', description: 'Canapé tissu gris 3 places, acheté l\'an dernier, très bon état. Livraison + montage offerts.', condition: 'Occasion — très bon état', createdAt: _now.subtract(const Duration(days: 2))),
 Product(id: 'p19', title: 'Moustiquaire imprégnée OMS', price: 7500, emoji: '', seed: 4, categoryId: 'c5', sellerId: 's5', rating: 4.7, reviews: 154, sold: 230, stock: 120, city: 'Libreville', description: 'Moustiquaire imprégnée longue durée, format 2 personnes. Certifiée OMS.', express: true, createdAt: _now.subtract(const Duration(days: 22))),
 Product(id: 'p20', title: 'Ciment CPJ 35 — sac 50 kg', price: 5500, emoji: '', seed: 7, categoryId: 'c6', sellerId: 's9', rating: 4.8, reviews: 402, sold: 500, stock: 350, city: 'Libreville', description: 'Ciment CPJ 35 conforme CEMAC, sac de 50 kg. Livraison en gros possible.', createdAt: _now.subtract(const Duration(days: 45))),
 Product(id: 'p21', title: 'Yumbo 125 cc — 2024', price: 850000, emoji: '', seed: 7, categoryId: 'c6', sellerId: 's6', rating: 4.4, reviews: 66, sold: 5, stock: 2, city: 'Owendo', description: 'Moto neuve, 0 km, papiers inclus. Révision offerte à 1000 km.', tags: ['Neuf'], variants: [ProductVariant('Couleur', ['Rouge', 'Noir', 'Bleu'])], createdAt: _now.subtract(const Duration(days: 19))),
 Product(id: 'p22', title: 'Casque moto homologué', price: 20000, oldPrice: 24000, emoji: '', seed: 7, categoryId: 'c6', sellerId: 's6', rating: 4.6, reviews: 89, sold: 75, stock: 31, city: 'Owendo', description: 'Casque intégral homologué, taille M à XL, écran anti-UV.', variants: [ProductVariant('Taille', ['M', 'L', 'XL'])], createdAt: _now.subtract(const Duration(days: 24))),
 Product(id: 'p23', title: 'Tissu pagne wax — 6 yards', price: 15000, emoji: '', seed: 4, categoryId: 'c3', sellerId: 's5', rating: 4.8, reviews: 210, sold: 140, stock: 66, city: 'Libreville', description: 'Wax premium 6 yards, couleurs vives, idéal pour vos tenues sur mesure.', variants: [ProductVariant('Couleur', ['Orange', 'Bleu', 'Vert'])], createdAt: _now.subtract(const Duration(days: 13))),
 Product(id: 'p24', title: 'Robe Ankara sur mesure', price: 35000, oldPrice: 42000, emoji: '', seed: 4, categoryId: 'c3', sellerId: 's5', rating: 4.9, reviews: 132, sold: 40, stock: 15, city: 'Libreville', description: 'Robe en wax cousue main, coupe ajustée. Confection en 72 h après vos mesures.', tags: ['Sur mesure'], variants: [ProductVariant('Taille', ['S', 'M', 'L', 'XL'])], express: true, createdAt: _now.subtract(const Duration(days: 4))),
 Product(id: 'p25', title: 'Baskets import (42–45)', price: 45000, emoji: '', seed: 8, categoryId: 'c3', sellerId: 's5', rating: 4.3, reviews: 77, sold: 26, stock: 12, city: 'Libreville', description: 'Baskets confort, semelle épaisse, plusieurs tailles disponibles.', variants: [ProductVariant('Taille', ['42', '43', '44', '45'])], createdAt: _now.subtract(const Duration(days: 29))),
 Product(id: 'p26', title: 'Sac à main en cuir local', price: 35000, emoji: '', seed: 6, categoryId: 'c8', sellerId: 's3', rating: 4.8, reviews: 54, sold: 18, stock: 7, city: 'Libreville', description: 'Cuir tanné localement, finitions main. Pièce unique numérotée.', tags: ['Made in Gabon'], createdAt: _now.subtract(const Duration(days: 17))),
 Product(id: 'p27', title: 'Collier en perles de Mabé', price: 25000, emoji: '', seed: 6, categoryId: 'c8', sellerId: 's3', rating: 4.9, reviews: 121, sold: 33, stock: 12, city: 'Libreville', description: 'Perles de Mabé montées sur fil de soie. Élégance océane.', tags: ['Made in Gabon', 'Perles'], createdAt: _now.subtract(const Duration(days: 10))),
 Product(id: 'p28', title: 'Masque Fang sculpté (copie d\'art)', price: 45000, emoji: '', seed: 6, categoryId: 'c8', sellerId: 's3', rating: 5.0, reviews: 22, sold: 7, stock: 3, city: 'Libreville', description: 'Sculpture Fang reproduite par nos artisans, bois d\'okoumé.', tags: ['Made in Gabon'], createdAt: _now.subtract(const Duration(days: 38))),
 Product(id: 'p29', title: 'Panier tressé en rotin', price: 12000, emoji: '', seed: 6, categoryId: 'c8', sellerId: 's3', rating: 4.7, reviews: 66, sold: 45, stock: 21, city: 'Libreville', description: 'Panier robuste tressé main, parfait pour le marché.', createdAt: _now.subtract(const Duration(days: 31))),
 Product(id: 'p30', title: 'Huile de coco vierge (500 ml)', price: 3500, emoji: '', seed: 1, categoryId: 'c5', sellerId: 's4', rating: 4.8, reviews: 143, sold: 160, stock: 88, city: 'Lambaréné', description: 'Pressée à froid, 100% naturelle, sans conservateurs.', tags: ['Naturel'], createdAt: _now.subtract(const Duration(days: 23))),
 Product(id: 'p31', title: 'Beurre de karité brut (500 g)', price: 4000, emoji: '', seed: 3, categoryId: 'c5', sellerId: 's4', rating: 4.9, reviews: 188, sold: 210, stock: 130, city: 'Lambaréné', description: 'Karité pur non raffiné, nourrit peau et cheveux en profondeur.', tags: ['Naturel'], express: true, createdAt: _now.subtract(const Duration(days: 15))),
 Product(id: 'p32', title: 'Savon noir africain (x4)', price: 2500, emoji: '', seed: 3, categoryId: 'c5', sellerId: 's4', rating: 4.6, reviews: 97, sold: 300, stock: 160, city: 'Lambaréné', description: 'Savon noir traditionnel, cuit au feu de bois. Purifiant.', createdAt: _now.subtract(const Duration(days: 25))),
 Product(id: 'p33', title: "Miel d'Ogooué (1 L)", price: 9000, emoji: '', seed: 1, categoryId: 'c1', sellerId: 's4', rating: 4.9, reviews: 76, sold: 90, stock: 40, city: 'Lambaréné', description: 'Miel de forêt récolté à Lambaréné, non pasteurisé.', tags: ['Naturel', 'Local'], createdAt: _now.subtract(const Duration(days: 33))),
 Product(id: 'p34', title: 'Coiffure : tresses + soin (domicile)', price: 15000, emoji: '', seed: 4, categoryId: 'c7', sellerId: 's8', rating: 4.8, reviews: 205, sold: 999, stock: 999, city: 'Libreville', description: 'Prestation à domicile : tresses, nattes ou vanilles + soin capillaire. Sur rendez-vous.', isService: true, createdAt: _now.subtract(const Duration(days: 7))),
 Product(id: 'p35', title: 'Manucure & pédicure à domicile', price: 12000, emoji: '', seed: 4, categoryId: 'c7', sellerId: 's8', rating: 4.7, reviews: 132, sold: 999, stock: 999, city: 'Libreville', description: 'Pose vernis semi-permanent ou classique, à votre domicile.', isService: true, createdAt: _now.subtract(const Duration(days: 12))),
 Product(id: 'p36', title: 'Plomberie — réparation fuite (forfait)', price: 25000, emoji: '', seed: 7, categoryId: 'c7', sellerId: 's9', rating: 4.5, reviews: 88, sold: 999, stock: 999, city: 'Libreville', description: 'Diagnostic + réparation de fuite, pièces non incluses. Devis gratuit.', isService: true, createdAt: _now.subtract(const Duration(days: 28))),
 Product(id: 'p37', title: 'Cours de maths niveau lycée (1 h)', price: 7500, emoji: '', seed: 5, categoryId: 'c7', sellerId: 's9', rating: 4.9, reviews: 41, sold: 999, stock: 999, city: 'Libreville', description: 'Cours particuliers à domicile ou en visio, enseignants agr\u00e9és.', isService: true, createdAt: _now.subtract(const Duration(days: 36))),
 Product(id: 'p38', title: 'Terrain 300 m² titré — Nkok', price: 15000000, emoji: '', seed: 2, categoryId: 'c9', sellerId: 's12', rating: 4.2, reviews: 12, sold: 1, stock: 1, city: 'Nkok', description: 'Terrain titré dans la zone Nkok, viabilisé, accès route. Idéal projet résidentiel.', characteristics: {'Surface': '300 m²', 'Titre': 'Titré'}, createdAt: _now.subtract(const Duration(days: 51))),
 Product(id: 'p39', title: 'Appartement 2 ch. — Owendo (mois)', price: 250000, emoji: '', seed: 0, categoryId: 'c9', sellerId: 's12', rating: 4.4, reviews: 27, sold: 4, stock: 4, city: 'Owendo', description: 'Appartement 2 chambres, salon, cuisine équipée, parking. Charges incluses.', characteristics: {'Chambres': '2', 'Surface': '65 m²'}, createdAt: _now.subtract(const Duration(days: 41))),
 Product(id: 'p40', title: 'Chèvres naines (x2, vaccinées)', price: 45000, emoji: '', seed: 2, categoryId: 'c10', sellerId: 's11', rating: 4.7, reviews: 38, sold: 9, stock: 6, city: 'Ntoum', description: 'Chèvres naines vaccinées, idéales pour élevage familial.', createdAt: _now.subtract(const Duration(days: 46))),
 Product(id: 'p41', title: 'Poulets locaux (x5, fermiers)', price: 17500, emoji: '', seed: 2, categoryId: 'c10', sellerId: 's11', rating: 4.8, reviews: 64, sold: 25, stock: 15, city: 'Ntoum', description: 'Poulets élevés en plein air, nourris au maïs local.', express: true, createdAt: _now.subtract(const Duration(days: 20))),
 Product(id: 'p42', title: 'Perroquet gris PAP (élevage)', price: 120000, emoji: '', seed: 2, categoryId: 'c10', sellerId: 's11', rating: 4.9, reviews: 18, sold: 5, stock: 2, city: 'Ntoum', description: 'Perroquet gris du Gabon issu d\'élevage légal, papiers CITES fournis.', createdAt: _now.subtract(const Duration(days: 44))),
 ];

 // =============================================================== Bannières
 static const banners = <BannerPromo>[
 BannerPromo(id: 'b1', title: 'Rentrée 241', subtitle: '-20% sur l\'électronique', emoji: '', colors: [Color(0xFF0066CC), Color(0xFF3399FF)], tag: 'Promo'),
 BannerPromo(id: 'b2', title: 'Livraison offerte', subtitle: 'dès 25 000 FCFA à Libreville', emoji: '', colors: [Color(0xFF00813F), Color(0xFF57D98A)], tag: 'Livraison'),
 BannerPromo(id: 'b3', title: 'Made in Gabon', subtitle: 'Soutenez nos artisans', emoji: '', colors: [Color(0xFF8A6D24), Color(0xFFC9A648)], tag: 'Local'),
 BannerPromo(id: 'b4', title: 'Airtel Money', subtitle: 'Payez en 1 clin d\'œil', emoji: '', colors: [Color(0xFF9E0007), Color(0xFFE50914)], tag: 'Paiement'),
 ];

 // ============================================================= Codes promo
 static const promoCodes = <PromoCode>[
 PromoCode(code: 'BIENVENUE10', label: 'Bienvenue — -10% (max 5 000)', minOrder: 10000, percent: 10),
 PromoCode(code: 'LIVRAISON0', label: 'Livraison gratuite dès 20 000', minOrder: 20000, freeShipping: true),
 PromoCode(code: 'OKOUME5000', label: '-5 000 FCFA dès 40 000', minOrder: 40000, fixed: 5000),
 ];

 // ================================================================ Adresses
 static const addresses = <Address>[
 Address(id: 'a1', label: 'Maison', details: 'Rue 12, derrière la pharmacie du Rond-point', city: 'Nzeng-Ayong, Libreville', isDefault: true),
 Address(id: 'a2', label: 'Bureau', details: 'Immeuble Ozangué, 3e étage, Boulevard Triomphal', city: 'Libreville'),
 ];

 // =========================================================== Notifications
 static final notifications = <AppNotification>[
 AppNotification(id: 'n1', title: 'Commande OKM-2026-0051 en livraison', body: 'Marc O. arrive dans ~35 min. Préparez votre code de réception.', time: _now.subtract(const Duration(minutes: 12)), emoji: ''),
 AppNotification(id: 'n2', title: 'Baisse de prix sur un favori', body: 'Écouteurs Bluetooth ANC : 22 000 FCFA au lieu de 29 000.', time: _now.subtract(const Duration(hours: 2)), emoji: ''),
 AppNotification(id: 'n3', title: 'Rentrée 241 — -20%', body: 'Jusqu\'à dimanche sur tout l\'électronique.', time: _now.subtract(const Duration(hours: 5)), emoji: '', read: true),
 AppNotification(id: 'n4', title: 'Message de TechLibre 241', body: 'Le A15 est bien scellé, garantie 6 mois ', time: _now.subtract(const Duration(hours: 8)), emoji: '', read: true),
 AppNotification(id: 'n5', title: '+50 points fidélité', body: 'Merci pour votre commande ! 320 points au total.', time: _now.subtract(const Duration(days: 1)), emoji: '', read: true),
 ];

 // ================================================================ Portefeuille
 static final walletTxns = <WalletTxn>[
 WalletTxn(label: 'Remboursement commande OKM-2026-0033', amount: 7500, date: _now.subtract(const Duration(days: 2)), emoji: ''),
 WalletTxn(label: 'Bonus parrainage', amount: 2500, date: _now.subtract(const Duration(days: 5)), emoji: ''),
 WalletTxn(label: 'Paiement commande OKM-2026-0042', amount: -18500, date: _now.subtract(const Duration(days: 3)), emoji: ''),
 WalletTxn(label: 'Retrait vers Airtel Money', amount: -25000, date: _now.subtract(const Duration(days: 8)), emoji: ''),
 ];

 // ===================================================================== Chat
 static final threads = <ChatThread>[
 ChatThread(id: 't1', sellerId: 's2', unread: 2, messages: [
  ChatMessage(text: 'Bonjour Le A15 est bien neuf scellé, garantie 6 mois.', fromMe: false, time: _now.subtract(const Duration(minutes: 26))),
  ChatMessage(text: 'Super. Vous livrez à Nzeng-Ayong demain ?', fromMe: true, time: _now.subtract(const Duration(minutes: 20)), read: true),
  ChatMessage(text: 'Oui, livraison express possible avant 14 h ', fromMe: false, time: _now.subtract(const Duration(minutes: 8))),
 ]),
 ChatThread(id: 't2', sellerId: 's5', messages: [
  ChatMessage(text: 'Bonjour, la robe est disponible en M ?', fromMe: true, time: _now.subtract(const Duration(hours: 5)), read: true),
  ChatMessage(text: 'Bonjour ! Oui en M et L ', fromMe: false, time: _now.subtract(const Duration(hours: 5))),
  ChatMessage(text: 'Parfait, je prends la M ', fromMe: true, time: _now.subtract(const Duration(hours: 4)), read: true),
 ]),
 ];

 // ================================================================ Commandes
 static final orders = <Order>[
 Order(
  id: 'o1', code: 'OKM-2026-0042', createdAt: _now.subtract(const Duration(days: 3)),
  lines: const [
  OrderLine(productId: 'p13', title: 'Chargeur rapide GaN 65 W', emoji: '', seed: 1, price: 15000, qty: 1, sellerName: 'TechLibre 241'),
  OrderLine(productId: 'p11', title: 'Écouteurs Bluetooth ANC', emoji: '', seed: 5, price: 22000, qty: 1, sellerName: 'TechLibre 241'),
  ],
  subtotal: 37000, deliveryFee: 1500, discount: 0, status: OrderStatus.livree,
  payment: PaymentMethod.airtel, deliveryLabel: 'Livraison à domicile Express',
  eta: _now.subtract(const Duration(days: 3)), addressLabel: 'Rue 12, Nzeng-Ayong, Libreville',
  otp: '3142', escrowHeld: false, rated: true,
  events: [
  OrderEvent(status: OrderStatus.confirmee, time: _now.subtract(const Duration(days: 3, hours: 6))),
  OrderEvent(status: OrderStatus.enPreparation, time: _now.subtract(const Duration(days: 3, hours: 5))),
  OrderEvent(status: OrderStatus.expediee, time: _now.subtract(const Duration(days: 3, hours: 4))),
  OrderEvent(status: OrderStatus.enLivraison, time: _now.subtract(const Duration(days: 3, hours: 3))),
  OrderEvent(status: OrderStatus.livree, time: _now.subtract(const Duration(days: 3, hours: 2))),
  ],
 ),
 Order(
  id: 'o2', code: 'OKM-2026-0051', createdAt: _now.subtract(const Duration(hours: 2)),
  lines: const [
  OrderLine(productId: 'p31', title: 'Beurre de karité brut (500 g)', emoji: '', seed: 3, price: 4000, qty: 2, sellerName: "Douceur de l'Ogooué"),
  OrderLine(productId: 'p30', title: 'Huile de coco vierge (500 ml)', emoji: '', seed: 1, price: 3500, qty: 1, sellerName: "Douceur de l'Ogooué"),
  OrderLine(productId: 'p33', title: "Miel d'Ogooué (1 L)", emoji: '', seed: 1, price: 9000, qty: 1, sellerName: "Douceur de l'Ogooué"),
  ],
  subtotal: 20500, deliveryFee: 1500, discount: 2050, status: OrderStatus.enLivraison,
  payment: PaymentMethod.moov, deliveryLabel: 'Livraison à domicile Standard',
  eta: _now.add(const Duration(minutes: 35)), addressLabel: 'Rue 12, Nzeng-Ayong, Libreville',
  otp: '4721', escrowHeld: true,
  events: [
  OrderEvent(status: OrderStatus.confirmee, time: _now.subtract(const Duration(minutes: 110))),
  OrderEvent(status: OrderStatus.enPreparation, time: _now.subtract(const Duration(minutes: 85))),
  OrderEvent(status: OrderStatus.expediee, time: _now.subtract(const Duration(minutes: 50))),
  OrderEvent(status: OrderStatus.enLivraison, time: _now.subtract(const Duration(minutes: 22))),
  OrderEvent(status: OrderStatus.livree, time: _now.add(const Duration(minutes: 35)), done: false),
  ],
 ),
 ];

 /// Commandes côté boutique (rôle vendeur — TechLibre 241).
 static final sellerOrders = <Order>[
 orders[1].copyWith(),
 Order(
  id: 'o3', code: 'OKM-2026-0055', createdAt: _now.subtract(const Duration(minutes: 40)),
  lines: const [OrderLine(productId: 'p12', title: 'Power bank 20 000 mAh', emoji: '', seed: 8, price: 18500, qty: 1, sellerName: 'TechLibre 241')],
  subtotal: 18500, deliveryFee: 1500, discount: 0, status: OrderStatus.enAttente,
  payment: PaymentMethod.wallet, deliveryLabel: 'Point de retrait Standard',
  eta: _now.add(const Duration(days: 1)), addressLabel: 'Locker Total Glass, Libreville',
  otp: '5583', escrowHeld: true,
  events: [OrderEvent(status: OrderStatus.enAttente, time: _now.subtract(const Duration(minutes: 40)))],
 ),
 Order(
  id: 'o4', code: 'OKM-2026-0058', createdAt: _now.subtract(const Duration(hours: 7)),
  lines: const [OrderLine(productId: 'p9', title: 'Samsung Galaxy A15 — 128 Go', emoji: '', seed: 0, price: 145000, qty: 1, variantLabel: 'Noir 128 Go', sellerName: 'TechLibre 241')],
  subtotal: 145000, deliveryFee: 2500, discount: 0, status: OrderStatus.enPreparation,
  payment: PaymentMethod.airtel, deliveryLabel: 'Livraison à domicile Express',
  eta: _now.add(const Duration(hours: 2)), addressLabel: 'Akanda, Libreville',
  otp: '2277', escrowHeld: true,
  events: [
  OrderEvent(status: OrderStatus.confirmee, time: _now.subtract(const Duration(hours: 6))),
  OrderEvent(status: OrderStatus.enPreparation, time: _now.subtract(const Duration(hours: 5))),
  ],
 ),
 ];

 // ============================================================== Livreur
 static const livreur = Livreur(name: 'Marc Ondo', emoji: '', vehicle: VehicleType.moto, plate: 'GA 4521 A', rating: 4.9, courses: 1247, phone: '+241 07 45 12 33');

 static const availableCourses = <Course>[
 Course(id: 'cb1', pickup: 'TechLibre 241 — Glass', dropoff: 'Nzeng-Ayong, rue 12', distanceKm: 3.2, payout: 1800, etaMin: 45, vehicle: VehicleType.moto, sellerEmoji: ''),
 Course(id: 'cb2', pickup: 'Maman Édith — Mont-Bouët', dropoff: 'Akanda, derrière le marché', distanceKm: 12.5, payout: 4500, etaMin: 60, vehicle: VehicleType.moto, sellerEmoji: ''),
 Course(id: 'cb3', pickup: 'Glow Beauté — Nzeng-Ayong', dropoff: 'PK9, immeuble Sogafric', distanceKm: 6.8, payout: 2600, etaMin: 40, vehicle: VehicleType.moto, sellerEmoji: ''),
 ];

 // ============================================================== Vendeur
 static const sellerStats = SellerStats(
 weekly: [45000, 120000, 80000, 210000, 95000, 160000, 130000],
 monthRevenue: 2450000, monthOrders: 68, avgBasket: 36000, views: 12400, conversion: 2.8,
 );

 // ============================================================== Helpers
 static Category categoryById(String id) =>
  categories.firstWhere((c) => c.id == id, orElse: () => categories.first);

 static Seller sellerById(String id) =>
  sellers.firstWhere((s) => s.id == id, orElse: () => sellers.first);

 static Product productById(String id) =>
  products.firstWhere((p) => p.id == id, orElse: () => products.first);

 static List<Product> productsOfSeller(String sellerId) =>
  products.where((p) => p.sellerId == sellerId).toList();

 static const _reviewTexts = <(String, String, String, double)>[
 ('Très bonne qualité, conforme à la description. Livraison rapide.', 'Aline M.', '', 5.0),
 ('Bon rapport qualité-prix, je recommande ', 'Yann K.', '', 4.5),
 ('Reçu en bon état, emballage soigné. Merci !', 'Sandrine B.', '', 5.0),
 ('Conforme, mais la livraison a pris un peu de retard.', 'Jean-Paul M.', '', 3.5),
 ('Excellent ! Le vendeur répond vite et bien.', 'Marie-Louise O.', '', 5.0),
 ('Bonne surprise, la qualité est au rendez-vous.', 'Hervé N.', '', 4.5),
 ];

 static List<Review> reviewsFor(Product p) {
 final n = 3 + (p.seed % 2);
 return List.generate(n, (i) {
  final r = _reviewTexts[(p.seed + i) % _reviewTexts.length];
  return Review(
  author: r.$2,
  emoji: r.$3,
  rating: r.$4,
  date: _now.subtract(Duration(days: 3 + i * 5 + p.seed)),
  text: r.$1,
  );
 });
 }

 static const _qaPool = <(String, String, String)>[
 ('Est-ce que la livraison est possible à Owendo ?', 'Oui, nous livrons Owendo sous 24 h ', 'Élodie R.'),
 ('C\'est neuf ou d\'occasion ?', 'Article neuf, garantie fournie avec facture.', 'Brice T.'),
 ('Puis-je payer à la livraison ?', 'Oui, l\'option paiement à la livraison est disponible ', 'Nadia M.'),
 ('Y a-t-il une réduction pour 2 pièces ?', 'Oui, -5% automatiquement dès 2 articles dans le panier.', 'Vendeur'),
 ];

 static List<ProductQA> qaFor(Product p) => List.generate(
  2,
  (i) {
   final q = _qaPool[(p.seed + i) % _qaPool.length];
   return ProductQA(q.$1, q.$2, q.$3);
  },
  );
}
