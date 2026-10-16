import 'package:flutter/material.dart';

/// Palette officielle Okoumé — cf. §7.2 du cahier des charges.
abstract final class AppColors {
 // Couleurs de marque
 static const primary = Color(0xFF0066CC); // Bleu Gabon — confiance, technologie
 static const primaryLight = Color(0xFF3D8FE0);
 static const secondary = Color(0xFFFF6B00); // Orange — action, achat
 static const secondaryLight = Color(0xFFFF8A3D);
 static const success = Color(0xFF00C853); // Vert — succès, livraison
 static const danger = Color(0xFFFF1744); // Rouge — erreur, annulation
 static const warning = Color(0xFFFFC107); // Jaune — attention, attente

 // Surfaces (thème clair)
 static const background = Color(0xFFF5F7FA);
 static const surface = Color(0xFFFFFFFF);
 static const text = Color(0xFF1A1A2E);
 static const textSecondary = Color(0xFF6B7280);

 // Surfaces (thème sombre)
 static const darkBackground = Color(0xFF0F1218);
 static const darkSurface = Color(0xFF1A1F29);
 static const darkSurfaceHigh = Color(0xFF232A36);
 static const darkText = Color(0xFFF2F4F8);
 static const darkTextSecondary = Color(0xFF9AA3B2);

 // Marques partenaires
 static const airtel = Color(0xFFE50914);
 static const moov = Color(0xFF0067B1);
 static const visa = Color(0xFF1A1F71);
 static const whatsapp = Color(0xFF25D366);

 // Statuts commande
 static const pending = Color(0xFFFFC107);
 static const confirmed = Color(0xFF0066CC);
 static const preparing = Color(0xFFFF6B00);
 static const shipped = Color(0xFF7C4DFF);
 static const inDelivery = Color(0xFF0091EA);
 static const delivered = Color(0xFF00C853);
 static const cancelled = Color(0xFF9AA3B2);
}
