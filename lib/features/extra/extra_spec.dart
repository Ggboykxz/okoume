/// Modèles des écrans catalogue Okoumé.
///
/// Les 317 écrans du CDC sont couverts : ceux du MVP ont une vraie route, les
/// autres sont rendus par `/screen/:id` à partir d'une [ExtraSpec]. Tous sont
/// **fonctionnels** : les formulaires, interrupteurs et actions modifient un
/// état applicatif local réel ([ExtraOp]) et les listes vivantes
/// ([DynamicKind]) reflètent cet état entre les écrans.
library;

/// Opération réelle déclenchée par une action ou un formulaire (état local).
enum ExtraOp {
 /// AD-11 valider le premier dossier KYC de la file.
 kycApprove,

 /// AD-12 rejeter le premier dossier KYC (motif = 1er champ).
 kycReject,

 /// AD-39/AD-41 approuver le premier retrait (target : vendeur/livreur).
 withdrawalApprove,

 /// AD-33 trancher le premier litige (sens = 1er champ).
 disputeDecide,

 /// AD-54 créer un code promo (champs : code, type, min, validité).
 createPromo,

 /// V-60 créer une zone (champs : nom, frais, délai).
 createZone,

 /// AD-26 créer une catégorie (champs : nom, emoji, couleur, attributs).
 createCategory,

 /// AD-29 programmer une bannière (champs : titre, dates, ciblage, lien).
 createBanner,

 /// AD-50 programmer une campagne push (champs : titre, message, cible, envoi).
 createCampaign,

 /// AD-75 créer un compte admin (champs : nom, tél, email, rôle).
 createAdmin,

 /// AD-65 publier un article d'aide (champs : titre, catégorie, contenu, liens).
 createFaq,

 /// V-25 programmer une promotion vendeur (champs : produit, %, dates).
 createVendorPromo,

 /// V-20 mettre à jour un stock (champs : produit, quantité, seuil).
 updateStock,

 /// AD-63 trancher le premier contenu signalé (justification = 1er champ).
 moderateContent,

 /// AD-60 répondre au premier ticket support (message = 1er champ).
 replyTicket,

 /// A-60 ouvrir un dossier de remboursement (commande = 1er champ).
 openRefund,

 /// AD-07/AD-57 générer un rapport (type = 1er champ).
 generateReport,

 /// AD-71 basculer le mode maintenance.
 toggleMaintenance,
}

/// Liste vivante affichée dans une section dynamique.
enum DynamicKind {
 kycQueue,
 promos,
 zones,
 disputes,
 withdrawalsVendor,
 withdrawalsLivreur,
 tickets,
 campaigns,
 moderationProducts,
 moderationContent,
 categories,
 banners,
 admins,
 faqArticles,
 reports,
 systemLogs,
 stockAll,
 stockLow,
 vendorPromos,
}

typedef ExtraStat = (String emoji, String value, String label);
typedef ExtraBar = (String label, int value);
typedef ExtraFormField = (String emoji, String hint);
typedef ExtraMapPin = (String emoji, String label, double x, double y);
typedef ExtraToggleItem = (String emoji, String label, bool initial);
typedef ExtraStep = (String emoji, String title, String time);

/// Section d'un écran du catalogue.
sealed class ExtraSection {
 const ExtraSection();
}

/// Paragraphe titré.
class TextSection extends ExtraSection {
 const TextSection(this.emoji, this.title, this.text);
 final String emoji;
 final String title;
 final String text;
}

/// Liste à puces.
class BulletSection extends ExtraSection {
 const BulletSection(this.title, this.bullets);
 final String title;
 final List<String> bullets;
}

/// Bandeau de statistiques (rendu en cartes).
class StatSection extends ExtraSection {
 const StatSection(this.stats, {this.title});
 final List<ExtraStat> stats;
 final String? title;
}

/// Rendu d'une liste vivante (état applicatif réel, partagé entre écrans).
class DynamicSection extends ExtraSection {
 const DynamicSection(
 this.kind, {
 this.title,
 this.emptyText = 'Rien pour le moment — vos actions apparaîtront ici.',
 });

 final DynamicKind kind;
 final String? title;
 final String emptyText;
}

/// Ligne de liste cliquable.
class ExtraRow {
 const ExtraRow(
 this.emoji,
 this.title, {
 this.subtitle,
 this.trailing,
 this.snack,
 this.route,
 });

 final String emoji;
 final String title;
 final String? subtitle;
 final String? trailing;
 final String? snack;

 /// Si non nul, l'appui navigue vers cette route réelle.
 final String? route;
}

/// Liste de lignes.
class ListSection extends ExtraSection {
 const ListSection(this.items, {this.title});
 final List<ExtraRow> items;
 final String? title;
}

/// Liens vers des écrans réels du MVP.
class LinkSection extends ExtraSection {
 const LinkSection(this.items, {this.title = 'Aller plus loin'});
 final List<ExtraRow> items;
 final String title;
}

/// Barres de progression avec libellés.
class ProgressSection extends ExtraSection {
 const ProgressSection(this.title, this.items);
 final String title;

 /// (libellé, valeur 0..1, valeur affichée)
 final List<(String, double, String)> items;
}

/// Frise d'étapes horodatées.
class TimelineSection extends ExtraSection {
 const TimelineSection(this.steps, {this.title});
 final List<ExtraStep> steps;
 final String? title;
}

/// Histogramme simple.
class ChartSection extends ExtraSection {
 const ChartSection(this.title, this.bars);
 final String title;
 final List<ExtraBar> bars;
}

/// Formulaire fonctionnel (les champs sont enregistrés, l'opération
/// ([FormSection.op]) est appliquée à l'état réel).
class FormSection extends ExtraSection {
 const FormSection({
 required this.title,
 required this.fields,
 this.submitLabel = 'Valider',
 this.success = 'Enregistré ',
 this.op,
 this.opArity,
 this.target,
 });

 final String title;
 final List<ExtraFormField> fields;
 final String submitLabel;
 final String success;
 final ExtraOp? op;

 /// Nombre de champs transmis à l'opération (les suivants sont optionnels).
 final int? opArity;

 /// Cible éventuelle de l'opération (ex. vendeur / livreur ).
 final String? target;
}

/// Mini-carte avec épingles positionnées (x, y ∈ 0..1).
class MapSection extends ExtraSection {
 const MapSection(this.pins, {this.title = 'Carte'});
 final List<ExtraMapPin> pins;
 final String title;
}

/// Interrupteurs persistants (état réel partagé).
class ToggleSection extends ExtraSection {
 const ToggleSection(this.items, {this.title});
 final List<ExtraToggleItem> items;
 final String? title;
}

/// Bouton d'action : navigation réelle, opération réelle ou journal local.
class ExtraAction {
 const ExtraAction(
 this.emoji,
 this.label, {
 this.snack,
 this.route,
 this.op,
 this.target,
 });

 final String emoji;
 final String label;
 final String? snack;
 final String? route;
 final ExtraOp? op;
 final String? target;
}

/// Spécification complète d'un écran du catalogue.
class ExtraSpec {
 const ExtraSpec({
 required this.emoji,
 required this.title,
 required this.tagline,
 this.sections = const [],
 this.actions = const [],
 });

 final String emoji;
 final String title;
 final String tagline;
 final List<ExtraSection> sections;
 final List<ExtraAction> actions;
}
