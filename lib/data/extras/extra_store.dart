import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/extra/extra_spec.dart';

/// Élément affiché par une liste vivante (emoji, titre, sous-titre, état).
typedef ExtraItem = (String emoji, String title, String? subtitle, String? trailing);

/// État applicatif réel des écrans « catalogue » (démo 100 % locale).
///
/// Toutes les mutations (validations, créations, réglages, dossiers) sont
/// réelles : elles modifient cet état, persistent pendant la session et sont
/// visibles **entre les écrans** (ex. valider un KYC dans AD-11 met à jour la
/// file de AD-10 ; créer un code promo dans AD-54 l'affiche dans AD-53).
class ExtraStoreState {
  ExtraStoreState({
    this.rev = 0,
    Map<String, bool>? toggles,
    Map<String, List<String>>? activity,
    Map<String, List<String>>? formEntries,
    List<String>? systemLogs,
    List<ExtraItem>? kycQueue,
    List<String>? kycValidated,
    List<ExtraItem>? promos,
    List<ExtraItem>? zones,
    List<ExtraItem>? disputes,
    List<ExtraItem>? withdrawVendor,
    List<ExtraItem>? withdrawLivreur,
    List<ExtraItem>? tickets,
    List<ExtraItem>? campaigns,
    List<ExtraItem>? moderationProducts,
    List<ExtraItem>? moderationContent,
    List<ExtraItem>? categories,
    List<ExtraItem>? banners,
    List<ExtraItem>? admins,
    List<ExtraItem>? faqArticles,
    List<ExtraItem>? reports,
    Map<String, int>? stock,
    List<ExtraItem>? vendorPromos,
  })  : toggles = toggles ?? {},
        activity = activity ?? {},
        formEntries = formEntries ?? {},
        systemLogs = systemLogs ?? [],
        kycQueue = kycQueue ?? [],
        kycValidated = kycValidated ?? [],
        promos = promos ?? [],
        zones = zones ?? [],
        disputes = disputes ?? [],
        withdrawVendor = withdrawVendor ?? [],
        withdrawLivreur = withdrawLivreur ?? [],
        tickets = tickets ?? [],
        campaigns = campaigns ?? [],
        moderationProducts = moderationProducts ?? [],
        moderationContent = moderationContent ?? [],
        categories = categories ?? [],
        banners = banners ?? [],
        admins = admins ?? [],
        faqArticles = faqArticles ?? [],
        reports = reports ?? [],
        stock = stock ?? {},
        vendorPromos = vendorPromos ?? [];

  /// Version (force la reconstruction des écouteurs à chaque mutation).
  final int rev;

  final Map<String, bool> toggles;
  final Map<String, List<String>> activity;
  final Map<String, List<String>> formEntries;
  final List<String> systemLogs;
  final List<ExtraItem> kycQueue;
  final List<String> kycValidated;
  final List<ExtraItem> promos;
  final List<ExtraItem> zones;
  final List<ExtraItem> disputes;
  final List<ExtraItem> withdrawVendor;
  final List<ExtraItem> withdrawLivreur;
  final List<ExtraItem> tickets;
  final List<ExtraItem> campaigns;
  final List<ExtraItem> moderationProducts;
  final List<ExtraItem> moderationContent;
  final List<ExtraItem> categories;
  final List<ExtraItem> banners;
  final List<ExtraItem> admins;
  final List<ExtraItem> faqArticles;
  final List<ExtraItem> reports;
  final Map<String, int> stock;
  final List<ExtraItem> vendorPromos;

  /// Nouvelle version partageant les mêmes collections (mutation en place).
  ExtraStoreState bump() => ExtraStoreState(
        rev: rev + 1,
        toggles: toggles,
        activity: activity,
        formEntries: formEntries,
        systemLogs: systemLogs,
        kycQueue: kycQueue,
        kycValidated: kycValidated,
        promos: promos,
        zones: zones,
        disputes: disputes,
        withdrawVendor: withdrawVendor,
        withdrawLivreur: withdrawLivreur,
        tickets: tickets,
        campaigns: campaigns,
        moderationProducts: moderationProducts,
        moderationContent: moderationContent,
        categories: categories,
        banners: banners,
        admins: admins,
        faqArticles: faqArticles,
        reports: reports,
        stock: stock,
        vendorPromos: vendorPromos,
      );

  /// Données initiales — cohérentes avec les contenus du catalogue.
  factory ExtraStoreState.initial() => ExtraStoreState(
        systemLogs: [
          '🔴 ERROR · API paiement Airtel timeout — Aujourd’hui 14h02 · 2 retries OK',
          '🟠 WARN · latence matching livreur 48 s — Aujourd’hui 12h40',
          '🔵 INFO · bannissement OK-88121 par admin — Aujourd’hui 11h15',
        ],
        kycQueue: [
          ('🛵', 'Ibrahim K. · livreur', 'CNI + permis + assurance reçus', 'À valider'),
          ('🏪', 'Nguema Fashion · vendeur', 'CNI + patente reçues', 'À valider'),
          ('🏪', 'Mama Mavoungou · vendeur', 'Dossier incomplet (NIF manquant)', 'Bloqué'),
        ],
        promos: [
          ('🎫', 'BIENVENUE10', '−10 % première commande', '4 128 usages'),
          ('🎫', 'LIVRAISON0', 'Livraison offerte · min. 25 000 F', '2 011 usages'),
          ('🎫', 'OKOUME5000', '−5 000 F · min. 50 000 F', '1 402 usages'),
          ('🎫', 'FIDELE-10', 'Clients fidèles uniquement', '312 usages'),
        ],
        zones: [
          ('✅', 'Libreville centre', '12 quartiers · Délai moyen 45 min', '1 500 F'),
          ('✅', 'Akanda', '6 quartiers · Délai moyen 1h10', '2 000 F'),
          ('✅', 'Owendo', '5 quartiers · Délai moyen 55 min', '2 000 F'),
        ],
        disputes: [
          ('🔥', 'LM-221 · « article manquant »', 'Aline N. ↔ TechGabon', '24 h'),
          ('⏳', 'LM-219 · « délai trop long »', 'Jean-P. M. ↔ Nguema Fashion', '2 j'),
          ('❄️', 'LM-214 · « produit non conforme »', 'Escaladé — médiation', '5 j'),
        ],
        withdrawVendor: [
          ('🏪', 'TechGabon — 850 000 F', 'Vers Airtel Money · demandé il y a 1 h', 'À traiter'),
          ('🏪', 'Nguema Fashion — 320 000 F', 'Vers Moov Money · demandé il y a 3 h', 'À traiter'),
          ('🏪', 'Mama Mavoungou — 150 000 F', 'Vers banque BGFI · vérif. renforcée', 'Contrôle'),
        ],
        withdrawLivreur: [
          ('🛵', 'Marc O. — 120 000 F', 'Vers Moov Money · demandé il y a 20 min', 'À traiter'),
          ('🛵', 'Synthia O. — 85 000 F', 'Vers Airtel Money · demandé il y a 1 h', 'À traiter'),
        ],
        tickets: [
          ('🔴', 'TK-4412 · commande jamais reçue', 'Aline N. · ouvert il y a 3 h', 'Prioritaire'),
          ('🟠', 'TK-4409 · remboursement lent', 'Jean-P. M. · hier', 'En cours'),
          ('🟡', 'TK-4401 · question facture', 'TechGabon · lundi', 'Standby'),
        ],
        campaigns: [
          ('📣', '« Black Friday : −60 % »', 'Envoyée à 86 210 utilisateurs', 'CTR 6,8 %'),
          ('📣', '« Vos favoris sont en promo »', 'Ciblage paniers abandonnés', 'CTR 9,2 %'),
          ('📣', '« Nouveau : paiement Moov »', 'Programmée demain 10h', 'Prévue'),
        ],
        moderationProducts: [
          ('🎭', '« iPhone 15 Pro » — contrefaçon présumée', '3 signalements · vendeur s9', 'Urgent'),
          ('🖼️', '« Montre luxe » — photos volées', '2 signalements', 'À traiter'),
          ('⚠️', '« Complément minceur » — produit interdit', '1 signalement', 'Urgent'),
        ],
        moderationContent: [
          ('💬', 'Avis « arnaqueurs !!! »', 'Signé d’un compte suspendu', 'Avis'),
          ('🖼️', 'Photo non conforme (fiche produit)', 'Signalée 4 fois', 'Photo'),
          ('📢', 'Message privé publicitaire', 'Spam répété — vendeur s9', 'Message'),
        ],
        categories: [
          ('📱', 'Électronique', '4 sous-catégories · 6 218 produits', 'Éditer'),
          ('👗', 'Mode', '6 sous-catégories · 5 402 produits', 'Éditer'),
          ('🏠', 'Maison', '5 sous-catégories · 3 110 produits', 'Éditer'),
          ('🌿', 'Made in Gabon', '3 sous-catégories · 1 240 produits', 'Éditer'),
        ],
        banners: [
          ('🎉', 'Black Friday — jusqu’à −60 %', 'Du 24/11 au 30/11 · toutes villes', 'Programmée'),
          ('🌿', 'Made in Gabon Days', 'Chaque 1er week-end · ciblage local', 'Active'),
          ('🚀', 'Livraison offerte dès 50 000 F', 'Bannière permanente', 'Active'),
        ],
        admins: [
          ('👑', 'Super Admin — 2 personnes', 'Tous les droits', 'Actif'),
          ('🧑‍💼', 'Opérations — 5 personnes', 'Commandes, livraisons, litiges', 'Actif'),
          ('🎧', 'Support — 8 personnes', 'Tickets, chat, remboursements < 50 kF', 'Actif'),
          ('📊', 'Analyste — 3 personnes', 'Lecture seule des rapports', 'Actif'),
        ],
        faqArticles: [
          ('📄', 'Comment suivre ma commande ?', 'Vu 12 840 fois · à jour', 'Publié'),
          ('📄', 'Payer avec Airtel Money', 'Vu 8 210 fois', 'Publié'),
          ('📝', 'Devenir vendeur — guide', 'En révision', 'Brouillon'),
        ],
        reports: [
          ('📊', 'Rapport TVA mars 2026', 'Généré automatiquement', 'PDF'),
          ('📊', 'Rapport TVA février 2026', 'Généré automatiquement', 'PDF'),
          ('📊', 'Export Excel T1 2026', 'Généré automatiquement', 'XLS'),
        ],
        stock: {
          'Écouteurs ProSound': 34,
          'Power bank 20 000': 8,
          'Coque renforcée': 52,
          'Montre Fit 3': 0,
          'Coffret karité': 5,
        },
        vendorPromos: [
          ('⚡', 'Flash « Mercredi Tech »', 'Demain 12h–18h · 6 produits', 'Programmée'),
          ('📉', 'Power bank −20 %', 'En cours · fin dans 2 j', 'Active'),
        ],
      );
}

/// Notifier : mutations réelles de l'état local de démo.
class ExtraStoreNotifier extends Notifier<ExtraStoreState> {
  @override
  ExtraStoreState build() => ExtraStoreState.initial();

  void setToggle(String key, bool value) {
    state.toggles[key] = value;
    state = state.bump();
  }

  void logActivity(String screenId, String text) {
    state.activity.putIfAbsent(screenId, () => []).insert(0, text);
    state = state.bump();
  }

  void logSystem(String text) {
    state.systemLogs.insert(0, text);
    state = state.bump();
  }

  void addFormEntry(String screenId, String entry) {
    state.formEntries.putIfAbsent(screenId, () => []).insert(0, entry);
    state = state.bump();
  }

  String _v(List<String> values, int i, [String fallback = '']) =>
      i < values.length && values[i].trim().isNotEmpty ? values[i].trim() : fallback;

  /// Applique une opération réelle et renvoie le message de résultat.
  String applyOp(ExtraOp op, {List<String> values = const [], String? target}) {
    switch (op) {
      case ExtraOp.kycApprove:
        if (state.kycQueue.isEmpty) return 'Aucun dossier en attente ✅';
        final item = state.kycQueue.removeAt(0);
        state.kycValidated.add(item.$2);
        state.systemLogs.insert(0, '🔵 INFO · KYC validé : ${item.$2}');
        state = state.bump();
        return 'Dossier ${item.$2} validé — notification envoyée ✅';

      case ExtraOp.kycReject:
        if (state.kycQueue.isEmpty) return 'Aucun dossier en attente ✅';
        final item = state.kycQueue.removeAt(0);
        final motif = _v(values, 0, 'documents à revoir');
        state.systemLogs.insert(
            0, '🟠 WARN · KYC rejeté : ${item.$2} — $motif');
        state = state.bump();
        return 'Dossier rejeté — motif « $motif » transmis ❌';

      case ExtraOp.withdrawalApprove:
        final q = target == 'livreur' ? state.withdrawLivreur : state.withdrawVendor;
        if (q.isEmpty) return 'Aucune demande en attente ✅';
        final item = q.removeAt(0);
        state.systemLogs.insert(0, '🔵 INFO · Retrait approuvé : ${item.$2}');
        state = state.bump();
        return 'Retrait approuvé — virement ${target == 'livreur' ? 'livreur' : 'vendeur'} en cours ✅';

      case ExtraOp.disputeDecide:
        if (state.disputes.isEmpty) return 'Aucun litige ouvert ✅';
        final item = state.disputes.removeAt(0);
        final sens = _v(values, 0, 'client');
        state.systemLogs.insert(0, '⚖️ Décision litige ${item.$2} : $sens');
        state = state.bump();
        return 'Décision « $sens » exécutée — fonds répartis automatiquement ⚖️';

      case ExtraOp.createPromo:
        final code = _v(values, 0, 'CODE').toUpperCase().replaceAll(' ', '');
        state.promos.insert(
            0, ('🎫', code, _v(values, 1, '−10 %'), '0 usage'));
        state = state.bump();
        return 'Code $code créé et actif immédiatement 🎫';

      case ExtraOp.createZone:
        final nom = _v(values, 0, 'Nouvelle zone');
        state.zones.add(
            ('📍', nom, 'Délai ${_v(values, 2, '1 h')}', _v(values, 1, '1 500 F')));
        state = state.bump();
        return 'Zone « $nom » créée — active immédiatement 📍';

      case ExtraOp.createCategory:
        final nom = _v(values, 0, 'Nouvelle catégorie');
        state.categories.add(
            ('🗂️', nom, _v(values, 3, 'Sous-catégories à définir'), 'Nouvelle'));
        state = state.bump();
        return 'Catégorie « $nom » créée — visible par les vendeurs 🗂️';

      case ExtraOp.createBanner:
        final titre = _v(values, 0, 'Nouvelle bannière');
        state.banners.insert(
            0, ('🖼️', titre, _v(values, 1, 'Diffusion à définir'), 'Programmée'));
        state = state.bump();
        return 'Bannière « $titre » programmée 🖼️';

      case ExtraOp.createCampaign:
        final titre = _v(values, 0, 'Nouvelle campagne');
        state.campaigns.insert(
            0, ('📣', titre, _v(values, 2, 'Cible : tous'), 'Prévue'));
        state = state.bump();
        return 'Campagne « $titre » prête — test interne envoyé 📣';

      case ExtraOp.createAdmin:
        final nom = _v(values, 0, 'Nouvel admin');
        state.admins.add(
            ('🪪', nom, _v(values, 3, 'Rôle à définir'), 'Invité'));
        state.systemLogs.insert(0, '👑 Nouveau compte admin : $nom');
        state = state.bump();
        return 'Compte admin « $nom » créé — invitation 2FA envoyée 🪪';

      case ExtraOp.createFaq:
        final titre = _v(values, 0, 'Nouvel article');
        state.faqArticles.insert(
            0, ('📄', titre, _v(values, 1, 'Centre d’aide'), 'Publié'));
        state = state.bump();
        return 'Article « $titre » publié dans le centre d’aide 📄';

      case ExtraOp.createVendorPromo:
        final produit = _v(values, 0, 'Produit');
        state.vendorPromos.insert(0,
            ('🏷️', '$produit — ${_v(values, 1, '−10 %')}', _v(values, 2, 'À partir d’aujourd’hui'), 'Programmée'));
        state = state.bump();
        return 'Promotion programmée pour « $produit » 🏷️';

      case ExtraOp.updateStock:
        final produit = _v(values, 0, 'Écouteurs ProSound');
        final qtyStr = _v(values, 1, '0').replaceAll(RegExp(r'[^0-9]'), '');
        final qty = int.tryParse(qtyStr) ?? 0;
        final key = state.stock.keys.firstWhere(
            (k) => k.toLowerCase().contains(produit.toLowerCase().split(' ').first),
            orElse: () => produit);
        state.stock[key] = qty;
        state.systemLogs.insert(0, '📊 Stock mis à jour : $key → $qty unités');
        state = state.bump();
        return 'Stock de « $key » mis à jour : $qty unités 📊';

      case ExtraOp.replyTicket:
        if (state.tickets.isEmpty) return 'Aucun ticket ouvert ✅';
        final t = state.tickets[0];
        state.tickets[0] = ('✅', t.$2.replaceFirst('· ', '· ✅ '), t.$3, 'Répondu');
        state = state.bump();
        return 'Réponse envoyée — ticket en attente du client ✍️';

      case ExtraOp.openRefund:
        final commande = _v(values, 0, 'commande sans numéro');
        final id = 'LM-${222 + state.disputes.length}';
        state.disputes.insert(
            0,
            ('⚠️', '$id · « remboursement » — $commande',
                'Ouvert à l’instant · médiation disponible', 'Nouveau'));
        state.systemLogs.insert(0, '⚖️ Nouveau litige ouvert : $id ($commande)');
        state = state.bump();
        return 'Dossier $id transmis — suivi possible dans « Litiges » 💸';

      case ExtraOp.generateReport:
        final type = _v(values, 0, 'rapport');
        state.reports.insert(0,
            ('📊', 'Rapport #${state.reports.length + 1} · $type', 'Généré à l’instant', 'PDF'));
        state = state.bump();
        return 'Rapport « $type » généré — disponible dans la liste 📊';

      case ExtraOp.moderateContent:
        if (state.moderationContent.isEmpty) return 'Aucun contenu à modérer ✅';
        final item = state.moderationContent.removeAt(0);
        state.systemLogs
            .insert(0, '⚖️ Contenu traité : ${item.$2} (${_v(values, 0, 'charte')})');
        state = state.bump();
        return 'Décision enregistrée — « ${item.$2} » traité ⚖️';

      case ExtraOp.toggleMaintenance:
        final on = !(state.toggles['maintenance'] ?? false);
        state.toggles['maintenance'] = on;
        state.systemLogs
            .insert(0, '🚧 Maintenance ${on ? 'activée' : 'désactivée'} par admin');
        state = state.bump();
        return on
            ? 'Mode maintenance activé — plateforme en lecture seule 🚧'
            : 'Maintenance terminée — plateforme de nouveau ouverte ✅';
    }
  }

  /// Éléments des listes vivantes.
  List<ExtraItem> itemsFor(DynamicKind kind) => switch (kind) {
        DynamicKind.kycQueue => state.kycQueue,
        DynamicKind.promos => state.promos,
        DynamicKind.zones => state.zones,
        DynamicKind.disputes => state.disputes,
        DynamicKind.withdrawalsVendor => state.withdrawVendor,
        DynamicKind.withdrawalsLivreur => state.withdrawLivreur,
        DynamicKind.tickets => state.tickets,
        DynamicKind.campaigns => state.campaigns,
        DynamicKind.moderationProducts => state.moderationProducts,
        DynamicKind.moderationContent => state.moderationContent,
        DynamicKind.categories => state.categories,
        DynamicKind.banners => state.banners,
        DynamicKind.admins => state.admins,
        DynamicKind.faqArticles => state.faqArticles,
        DynamicKind.reports => state.reports,
        DynamicKind.vendorPromos => state.vendorPromos,
        DynamicKind.systemLogs => [
            for (final l in state.systemLogs) ('🧾', l, null, 'Log'),
          ],
        DynamicKind.stockAll => [
            for (final e in state.stock.entries)
              (
                e.value == 0
                    ? '⛔'
                    : e.value < 10
                        ? '⚠️'
                        : '✅',
                e.key,
                null,
                '${e.value} unités'
              ),
          ],
        DynamicKind.stockLow => [
            for (final e in state.stock.entries)
              if (e.value < 10)
                (
                  e.value == 0 ? '⛔' : '⚠️',
                  e.key,
                  e.value == 0 ? 'Épuisé — réappro. requis' : 'Sous le seuil (10)',
                  '${e.value} restants'
                ),
          ],
      };
}

/// Fournisseur global de l'état applicatif de démo.
final extraStoreProvider =
    NotifierProvider<ExtraStoreNotifier, ExtraStoreState>(
        ExtraStoreNotifier.new);
