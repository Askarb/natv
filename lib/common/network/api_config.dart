class ApiConfig {
  ApiConfig._();

  static const String baseUrl = "https://app1.megacom.kg:9090/test_task/api/v1";
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const String channelList = '/channel/list';
  static const String channelCalculate = '/channel/calculate';
  static const String orderCreate = '/order/save';
  static const String orderBannerCreate = '/order/save-banner';
  static const header = {
    'Content-Type': 'application/json',
  };
}
