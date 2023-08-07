class WebApiConfig {
  static const String applicationURL =
      'PRE-SCREENING LOG SHEET – HECOLIN TRIAL-V1';

  //static const String webApplicationURL = 'https://10.1.182.65:7256/api/';
  static const String webApplicationURL = 'http://10.1.182.65:5002/api/';

  static const String loginURL = 'UserInformation';
  static const String loginByDeviceURL =
      'UserInformation/GetUserByDevice?deviceID=';
  static const String postWomenBaselineInformation =
      'WomenBaselineInformation/savewomeninformation/data';
  static const String postWomenPregnancyInformation =
      'WomenPregnancyInformation/savepregnancyinformation/data';

// Add more configuration strings as needed
}
