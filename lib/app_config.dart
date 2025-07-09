var this_year = DateTime.now().year.toString();

class AppConfig {
  static String copyright_text =
      "@ Pasar Al Huda " + this_year; //this shows in the splash screen
  static String app_name = "Pasar Al Huda"; //this shows in the splash screen

  static String purchase_code =
      "00fa75fa-89e8-4897-a1af-2bab6de323c6"; //enter your purchase code for the app from codecanyon
  static String system_key =
      r"$2y$10$quL3ka6.deYjwSlVfGnT6.XZGreRVAKeZipPRsT3nsN5eEs6KyD96"; //enter your purchase code for the app from codecanyon

  //Default language config
  static String default_language = "id";
  static String mobile_app_code = "id";
  static bool app_language_rtl = false;

  //configure this
  static const bool HTTPS = true;

  static const DOMAIN_PATH = "new.pasaralhuda.com";

  //do not configure these below
  static const String API_ENDPATH = "api/v2";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "${PROTOCOL}${DOMAIN_PATH}";
  static const String BASE_URL = "${RAW_BASE_URL}/${API_ENDPATH}";

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
