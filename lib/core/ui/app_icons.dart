import 'package:flutter/widgets.dart';
import 'package:hugeicons/hugeicons.dart';

/// Donnée d'icône Hugeicons (bundle SVG stroke-rounded du package `hugeicons`).
typedef AppIconData = List<List<dynamic>>;

/// Mapping centralisé vers Hugeicons (style stroke-rounded).
///
/// Les noms conservent la convention Material (ex. `search_rounded`) pour que
/// la bascule soit mécanique et lisible. Les glyphes **à état** (étoiles de
/// notation, cœurs des favoris) restent en Material Icons : le remplissage y
/// est un indicateur d'état, absent des icônes stroke.
// ignore_for_file: constant_identifier_names
abstract final class AppIcons {
 static const account_balance_wallet_rounded = HugeIcons.strokeRoundedWallet01;
 static const add_card_rounded = HugeIcons.strokeRoundedCreditCardAdd;
 static const add_location_alt_rounded = HugeIcons.strokeRoundedLocationAdd01;
 static const add_rounded = HugeIcons.strokeRoundedPlusSign;
 static const add_shopping_cart_rounded =
   HugeIcons.strokeRoundedShoppingCartAdd01;
 static const arrow_back_rounded = HugeIcons.strokeRoundedArrowLeft02;
 static const arrow_forward_rounded = HugeIcons.strokeRoundedArrowRight02;
 static const block_rounded = HugeIcons.strokeRoundedBlocked;
 static const bolt_rounded = HugeIcons.strokeRoundedFlash;
 static const call_rounded = HugeIcons.strokeRoundedCall;
 static const cancel_rounded = HugeIcons.strokeRoundedCancelCircle;
 static const card_giftcard_rounded = HugeIcons.strokeRoundedGiftCard;
 static const chat_bubble_rounded = HugeIcons.strokeRoundedMessage01;
 static const chat_rounded = HugeIcons.strokeRoundedChat;
 static const check_circle_rounded = HugeIcons.strokeRoundedCheckmarkCircle02;
 static const check_rounded = HugeIcons.strokeRoundedTick02;
 static const chevron_right_rounded = HugeIcons.strokeRoundedArrowRight01;
 static const circle_outlined = HugeIcons.strokeRoundedCircle;
 static const close_rounded = HugeIcons.strokeRoundedCancel01;
 static const confirmation_number_outlined =
   HugeIcons.strokeRoundedTicket01;
 static const copy_rounded = HugeIcons.strokeRoundedCopy01;
 static const credit_card_rounded = HugeIcons.strokeRoundedCreditCard;
 static const delete_outline_rounded = HugeIcons.strokeRoundedDelete02;
 static const delete_sweep_outlined = HugeIcons.strokeRoundedDelete02;
 static const delivery_dining_rounded = HugeIcons.strokeRoundedScooter01;
 static const done_all_rounded = HugeIcons.strokeRoundedTickDouble01;
 static const download_rounded = HugeIcons.strokeRoundedDownload01;
 static const edit_rounded = HugeIcons.strokeRoundedPencilEdit02;
 static const electric_moped_rounded = HugeIcons.strokeRoundedScooter01;
 static const event_rounded = HugeIcons.strokeRoundedCalendar03;
 static const fast_forward_rounded = HugeIcons.strokeRoundedForward01;
 static const flag_rounded = HugeIcons.strokeRoundedFlag01;
 static const handshake_rounded = HugeIcons.strokeRoundedHandshake;
 static const history_rounded = HugeIcons.strokeRoundedHistory;
 static const home_repair_service_rounded = HugeIcons.strokeRoundedToolbox;
 static const home_rounded = HugeIcons.strokeRoundedHome01;
 static const insights_rounded = HugeIcons.strokeRoundedAnalytics01;
 static const inventory_2_rounded = HugeIcons.strokeRoundedPackage01;
 static const ios_share_rounded = HugeIcons.strokeRoundedShare08;
 static const keyboard_arrow_down_rounded = HugeIcons.strokeRoundedArrowDown01;
 static const label_rounded = HugeIcons.strokeRoundedTag02;
 static const link_rounded = HugeIcons.strokeRoundedLink01;
 static const local_fire_department_rounded = HugeIcons.strokeRoundedFire;
 static const local_shipping_rounded = HugeIcons.strokeRoundedDeliveryTruck01;
 static const location_city_rounded = HugeIcons.strokeRoundedBuilding01;
 static const location_on_rounded = HugeIcons.strokeRoundedLocation01;
 static const lock_open_rounded = HugeIcons.strokeRoundedSquareUnlock01;
 static const lock_rounded = HugeIcons.strokeRoundedSquareLock01;
 static const logout_rounded = HugeIcons.strokeRoundedLogout01;
 static const mail_rounded = HugeIcons.strokeRoundedMail01;
 static const map_rounded = HugeIcons.strokeRoundedMaps;
 static const more_vert_rounded = HugeIcons.strokeRoundedMoreVertical;
 static const my_location_rounded = HugeIcons.strokeRoundedGps01;
 static const navigation_rounded = HugeIcons.strokeRoundedNavigation;
 static const notes_rounded = HugeIcons.strokeRoundedNote01;
 static const notifications_active_rounded = HugeIcons.strokeRoundedNotification03;
 static const notifications_none_rounded = HugeIcons.strokeRoundedNotification01;
 static const payments_rounded = HugeIcons.strokeRoundedMoneyBag02;
 static const person_rounded = HugeIcons.strokeRoundedUser;
 static const phone_rounded = HugeIcons.strokeRoundedCall;
 static const photo_camera_rounded = HugeIcons.strokeRoundedCamera01;
 static const qr_code_scanner_rounded = HugeIcons.strokeRoundedQrCode01;
 static const radio_button_unchecked_rounded = HugeIcons.strokeRoundedCircle;
 static const receipt_long_rounded = HugeIcons.strokeRoundedInvoice01;
 static const remove_rounded = HugeIcons.strokeRoundedMinusSign;
 static const report_problem_rounded = HugeIcons.strokeRoundedAlert02;
 static const rocket_launch_rounded = HugeIcons.strokeRoundedRocket01;
 static const schedule_rounded = HugeIcons.strokeRoundedClock01;
 static const search_rounded = HugeIcons.strokeRoundedSearch01;
 static const sell_rounded = HugeIcons.strokeRoundedSaleTag01;
 static const send_rounded = HugeIcons.strokeRoundedSent02;
 static const shopping_bag_rounded = HugeIcons.strokeRoundedShoppingBag03;
 static const shopping_cart_outlined = HugeIcons.strokeRoundedShoppingCart01;
 static const signpost_rounded = HugeIcons.strokeRoundedSignpost;
 static const sms_rounded = HugeIcons.strokeRoundedMessageMultiple01;
 static const sort_rounded = HugeIcons.strokeRoundedSortingAZ01;
 static const south_west_rounded = HugeIcons.strokeRoundedArrowDownLeft01;
 static const star_rounded = HugeIcons.strokeRoundedStar;
 static const storefront_rounded = HugeIcons.strokeRoundedShoppingBag01;
 static const support_agent_rounded = HugeIcons.strokeRoundedCustomerSupport;
 static const title_rounded = HugeIcons.strokeRoundedTextFont;
 static const tune_rounded = HugeIcons.strokeRoundedFilter;
 static const verified_rounded = HugeIcons.strokeRoundedCheckmarkBadge01;
 static const verified_user_rounded = HugeIcons.strokeRoundedSecurityCheck;
 static const visibility_rounded = HugeIcons.strokeRoundedView;
}

/// Icône Hugeicons — API calquée sur [Icon] (taille/couleur depuis
/// l'[IconTheme], couleur par défaut = `onSurface`).
class AppIcon extends StatelessWidget {
 const AppIcon(
  this.icon, {
  super.key,
  this.size,
  this.color,
  this.strokeWidth = 1.8,
  this.semanticLabel,
 });

 final AppIconData? icon;
 final double? size;
 final Color? color;

 /// Épaisseur de trait (les icônes stroke sont plus fines que Material).
 final double? strokeWidth;
 final String? semanticLabel;

 @override
 Widget build(BuildContext context) {
  final data = icon;
  if (data == null) {
   return SizedBox(width: size ?? 24, height: size ?? 24);
  }
  return Semantics(
    label: semanticLabel ?? 'icon',
    child: HugeIcon(
     icon: data,
     size: size,
     color: color,
     strokeWidth: strokeWidth,
    ),
  );
 }
}
