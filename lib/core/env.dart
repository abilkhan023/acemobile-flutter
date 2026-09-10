abstract final class Env {
  static const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  static const debugGuest = bool.fromEnvironment('DEBUG_GUEST');
  static const coreUrl = String.fromEnvironment('CORE_URL', defaultValue: 'https://ace-core.acegaming.gg/api');
  static const shopUrl = String.fromEnvironment('SHOP_URL', defaultValue: 'https://ace-shop.acegaming.gg');
  static const fileUrl = String.fromEnvironment('FILE_URL', defaultValue: 'https://ace-filetransfer.acegaming.gg');
  static const bankingUrl = String.fromEnvironment('BANKING_URL', defaultValue: 'https://ace-banking-service.acegaming.gg');
  static const wsUrl = String.fromEnvironment('WS_URL', defaultValue: 'wss://test-ace-sockets.acegaming.gg/ws');

  static const deepLinkHost = 'app.acegaming.gg';
  static const telegramBotUrl = 'https://t.me/ace_gaming_gg_bot';
  static const privacyPdfUrl =
      'https://ace-test.fra1.cdn.digitaloceanspaces.com/docs/%D0%9F%D0%BE%D0%BB%D0%B8%D1%82%D0%B8%D0%BA%D0%B0%20%D0%BA%D0%BE%D0%BD%D1%84%D0%B8%D0%B4%D0%B5%D0%BD%D1%86%D0%B8%D0%B0%D0%BB%D1%8C%D0%BD%D0%BE%D1%81%D1%82%D0%B8.pdf';
  static const timezone = 'Asia/Almaty';
  static const shopGameCenterId = 'a75d6f90-32de-402f-8fc8-8227114fb7b5';
  static const defaultMapSize = 20;
}
