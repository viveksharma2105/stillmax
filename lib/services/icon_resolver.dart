import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Maps package names to FontAwesome icons for the "fun" theme
final Map<String, IconData> funIconMap = {
  // Browsers
  'com.android.chrome': FontAwesomeIcons.chrome,
  'org.mozilla.firefox': FontAwesomeIcons.firefoxBrowser,
  'com.opera.browser': FontAwesomeIcons.opera,
  'com.brave.browser': FontAwesomeIcons.fire,
  'org.chromium.webview_shell': FontAwesomeIcons.globe,

  // Social & Communication
  'com.whatsapp': FontAwesomeIcons.whatsapp,
  'com.facebook.katana': FontAwesomeIcons.facebook,
  'com.facebook.orca': FontAwesomeIcons.facebookMessenger,
  'com.instagram.android': FontAwesomeIcons.instagram,
  'com.twitter.android': FontAwesomeIcons.twitter,
  'com.snapchat.android': FontAwesomeIcons.snapchat,
  'org.telegram.messenger': FontAwesomeIcons.telegram,
  'com.discord': FontAwesomeIcons.discord,
  'com.slack': FontAwesomeIcons.slack,
  'com.skype.raider': FontAwesomeIcons.skype,
  'com.linkedin.android': FontAwesomeIcons.linkedin,
  'com.reddit.frontpage': FontAwesomeIcons.reddit,
  'com.zhiliaoapp.musically': FontAwesomeIcons.tiktok,

  // Media & Entertainment
  'com.google.android.youtube': FontAwesomeIcons.youtube,
  'com.spotify.music': FontAwesomeIcons.spotify,
  'com.netflix.mediaclient': FontAwesomeIcons.film,
  'com.amazon.avod.thirdpartyclient': FontAwesomeIcons.video,
  'com.soundcloud.android': FontAwesomeIcons.soundcloud,
  'com.vimeo.android.videoapp': FontAwesomeIcons.vimeo,
  'com.twitch.android.app': FontAwesomeIcons.twitch,
  'com.google.android.apps.youtube.music': FontAwesomeIcons.music,

  // Productivity
  'com.google.android.gm': FontAwesomeIcons.envelope,
  'com.microsoft.office.outlook': FontAwesomeIcons.microsoft,
  'com.google.android.calendar': FontAwesomeIcons.calendar,
  'com.google.android.keep': FontAwesomeIcons.noteSticky,
  'com.evernote': FontAwesomeIcons.fileLines,
  'com.notion.id': FontAwesomeIcons.book,
  'com.todoist': FontAwesomeIcons.listCheck,
  'com.trello': FontAwesomeIcons.trello,
  'com.asana.app': FontAwesomeIcons.listCheck,

  // Shopping
  'com.amazon.mShop.android.shopping': FontAwesomeIcons.amazon,
  'com.ebay.mobile': FontAwesomeIcons.store,
  'com.shopify.mobile': FontAwesomeIcons.shopify,
  'com.etsy.android': FontAwesomeIcons.cartShopping,

  // Finance
  'com.paypal.android.p2pmobile': FontAwesomeIcons.paypal,
  'com.venmo': FontAwesomeIcons.moneyBillTransfer,
  'com.coinbase.android': FontAwesomeIcons.bitcoin,

  // Development
  'com.github.android': FontAwesomeIcons.github,
  'com.gitlab.android': FontAwesomeIcons.gitlab,
  'com.bitbucket.mobile': FontAwesomeIcons.bitbucket,
  'com.termux': FontAwesomeIcons.terminal,

  // Photos & Design
  'com.google.android.apps.photos': FontAwesomeIcons.images,
  'com.adobe.lrmobile': FontAwesomeIcons.fileImage,
  'com.instagram.layout': FontAwesomeIcons.imagePortrait,
  'com.canva.editor': FontAwesomeIcons.paintbrush,
  'com.vsco.cam': FontAwesomeIcons.camera,

  // Games
  'com.google.android.play.games': FontAwesomeIcons.gamepad,
  'com.steam.android': FontAwesomeIcons.steam,
  'com.discord.game': FontAwesomeIcons.dice,

  // Maps & Travel
  'com.google.android.apps.maps': FontAwesomeIcons.mapLocationDot,
  'com.waze': FontAwesomeIcons.road,
  'com.uber.app': FontAwesomeIcons.car,
  'com.airbnb.android': FontAwesomeIcons.airbnb,
  'com.booking': FontAwesomeIcons.hotel,

  // System
  'com.android.settings': FontAwesomeIcons.gear,
  'com.android.vending': FontAwesomeIcons.googlePlay,
  'com.google.android.apps.messaging': FontAwesomeIcons.comment,
  'com.android.dialer': FontAwesomeIcons.phone,
  'com.android.contacts': FontAwesomeIcons.addressBook,
  'com.android.camera2': FontAwesomeIcons.camera,
  'com.google.android.calculator': FontAwesomeIcons.calculator,
  'com.android.gallery3d': FontAwesomeIcons.images,
  'com.android.deskclock': FontAwesomeIcons.clock,
  'com.android.documentsui': FontAwesomeIcons.folder,

  // Cloud & Storage
  'com.google.android.apps.docs': FontAwesomeIcons.googleDrive,
  'com.dropbox.android': FontAwesomeIcons.dropbox,
  'com.microsoft.skydrive': FontAwesomeIcons.cloud,

  // Health & Fitness
  'com.google.android.apps.fitness': FontAwesomeIcons.heartPulse,
  'com.strava': FontAwesomeIcons.personRunning,
  'com.myfitnesspal.android': FontAwesomeIcons.appleWhole,
};

/// Maps package names to Lucide icons for the "cute" theme
final Map<String, IconData> cuteIconMap = {
  // Browsers
  'com.android.chrome': LucideIcons.chrome,
  'org.mozilla.firefox': LucideIcons.globe,
  'com.opera.browser': LucideIcons.globe2,
  'com.brave.browser': LucideIcons.shield,
  'org.chromium.webview_shell': LucideIcons.compass,

  // Social & Communication
  'com.whatsapp': LucideIcons.messageCircle,
  'com.facebook.katana': LucideIcons.users,
  'com.facebook.orca': LucideIcons.messageSquare,
  'com.instagram.android': LucideIcons.camera,
  'com.twitter.android': LucideIcons.bird,
  'com.snapchat.android': LucideIcons.ghost,
  'org.telegram.messenger': LucideIcons.send,
  'com.discord': LucideIcons.hash,
  'com.slack': LucideIcons.slack,
  'com.skype.raider': LucideIcons.video,
  'com.linkedin.android': LucideIcons.linkedin,
  'com.reddit.frontpage': LucideIcons.messagesSquare,
  'com.zhiliaoapp.musically': LucideIcons.music,

  // Media & Entertainment
  'com.google.android.youtube': LucideIcons.youtube,
  'com.spotify.music': LucideIcons.music2,
  'com.netflix.mediaclient': LucideIcons.tv,
  'com.amazon.avod.thirdpartyclient': LucideIcons.film,
  'com.soundcloud.android': LucideIcons.radio,
  'com.vimeo.android.videoapp': LucideIcons.video,
  'com.twitch.android.app': LucideIcons.twitch,
  'com.google.android.apps.youtube.music': LucideIcons.music,

  // Productivity
  'com.google.android.gm': LucideIcons.mail,
  'com.microsoft.office.outlook': LucideIcons.mailbox,
  'com.google.android.calendar': LucideIcons.calendar,
  'com.google.android.keep': LucideIcons.stickyNote,
  'com.evernote': LucideIcons.bookMarked,
  'com.notion.id': LucideIcons.bookOpen,
  'com.todoist': LucideIcons.checkSquare,
  'com.trello': LucideIcons.trello,
  'com.asana.app': LucideIcons.listChecks,

  // Shopping
  'com.amazon.mShop.android.shopping': LucideIcons.shoppingBag,
  'com.ebay.mobile': LucideIcons.store,
  'com.shopify.mobile': LucideIcons.shoppingCart,
  'com.etsy.android': LucideIcons.tag,

  // Finance
  'com.paypal.android.p2pmobile': LucideIcons.creditCard,
  'com.venmo': LucideIcons.dollarSign,
  'com.coinbase.android': LucideIcons.bitcoin,

  // Development
  'com.github.android': LucideIcons.github,
  'com.gitlab.android': LucideIcons.gitlab,
  'com.bitbucket.mobile': LucideIcons.code,
  'com.termux': LucideIcons.terminal,

  // Photos & Design
  'com.google.android.apps.photos': LucideIcons.image,
  'com.adobe.lrmobile': LucideIcons.sparkles,
  'com.instagram.layout': LucideIcons.layout,
  'com.canva.editor': LucideIcons.paintbrush,
  'com.vsco.cam': LucideIcons.camera,

  // Games
  'com.google.android.play.games': LucideIcons.gamepad2,
  'com.steam.android': LucideIcons.gamepad,
  'com.discord.game': LucideIcons.dices,

  // Maps & Travel
  'com.google.android.apps.maps': LucideIcons.map,
  'com.waze': LucideIcons.navigation,
  'com.uber.app': LucideIcons.car,
  'com.airbnb.android': LucideIcons.home,
  'com.booking': LucideIcons.building,

  // System
  'com.android.settings': LucideIcons.settings,
  'com.android.vending': LucideIcons.package,
  'com.google.android.apps.messaging': LucideIcons.messageCircle,
  'com.android.dialer': LucideIcons.phone,
  'com.android.contacts': LucideIcons.userSquare,
  'com.android.camera2': LucideIcons.camera,
  'com.google.android.calculator': LucideIcons.calculator,
  'com.android.gallery3d': LucideIcons.image,
  'com.android.deskclock': LucideIcons.clock,
  'com.android.documentsui': LucideIcons.folder,

  // Cloud & Storage
  'com.google.android.apps.docs': LucideIcons.hardDrive,
  'com.dropbox.android': LucideIcons.cloudCog,
  'com.microsoft.skydrive': LucideIcons.cloud,

  // Health & Fitness
  'com.google.android.apps.fitness': LucideIcons.heart,
  'com.strava': LucideIcons.activity,
  'com.myfitnesspal.android': LucideIcons.apple,
};

/// Fallback icon for fun theme
const IconData funFallbackIcon = FontAwesomeIcons.squareCheck;

/// Fallback icon for cute theme
const IconData cuteFallbackIcon = LucideIcons.appWindow;

/// Generates a deterministic color based on package name hash
Color getColorFromPackageName(String packageName) {
  final hash = packageName.hashCode;
  final hue = (hash % 360).toDouble();
  return HSLColor.fromAHSL(1.0, hue, 0.7, 0.5).toColor();
}

/// Generates a pastel color based on package name hash
Color getPastelColorFromPackageName(String packageName) {
  final hash = packageName.hashCode;
  final hue = (hash % 360).toDouble();
  return HSLColor.fromAHSL(1.0, hue, 0.4, 0.85).toColor();
}
