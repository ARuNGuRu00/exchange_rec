import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
// import 'package:currency_converter/currency.dart';
// import 'package:currency_converter/currency_converter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

const cData = [
  ["AFN", "Afghan Afghani"],
  ["ALL", "Albanian Lek"],
  ["DZD", "Algerian Dinar"],
  ["ARS", "Argentine Peso"],
  ["AMD", "Armenian Dram"],
  ["AWG", "Aruban Florin"],
  ["AUD", "Australian Dollar"],
  ["AZN", "Azerbaijani Manat"],
  ["BSD", "Bahamian Dollar"],
  ["BHD", "Baharaini Dinar"],
  ["BDT", "Bangladeshi Taka"],
  ["BBD", "Barbadian Dollar"],
  ["BYN", "Belarusian Ruble"],
  ["BZD", "Belize Dollar"],
  ["BMD", "Bermudian Dollar"],
  ["BTN", "Bhutanese Ngultrum"],
  ["BTC", "Bitcoin"],
  ["BCH", "Bitcoin Cash"],
  ["VES", "Bolívar Soberano"],
  ["BOB", "Bolivian Boliviano"],
  ["BAM", "Bosnian Convertible Marka"],
  ["BWP", "Botswana Pula"],
  ["BRL", "Brazilian Real"],
  ["BND", "Brunei Dollar"],
  ["BGN", "Bulgarian Lev"],
  ["BIF", "Burundian Franc"],
  ["KHR", "Cambodian Riel"],
  ["CAD", "Canadian Dollar"],
  ["CVE", "Cape Verdean Escudo"],
  ["KYD", "Cayman Islands Dollar"],
  ["XAF", "Central African CFA Franc"],
  ["CLP", "Chilean Peso"],
  ["CNY", "Chinese Yuan"],
  ["CNH", "Chinese Yuan Offshore"],
  ["COP", "Colombian Peso"],
  ["KMF", "Comorian Franc"],
  ["CDF", "Congolese Franc"],
  ["CRC", "Costa Rican Colón"],
  ["HRK", "Croatian Kuna"],
  ["CUP", "Cuban Peso"],
  ["CZK", "Czech Koruna"],
  ["DKK", "Danish Krone"],
  ["DJF", "Djiboutian Franc"],
  ["STN", "Dobra"],
  ["DOP", "Dominican Peso"],
  ["XCD", "East Caribbean Dollar"],
  ["EGP", "Egyptian Pound"],
  ["AED", "Emirati Dirham"],
  ["ETH", "Ethereum"],
  ["ETB", "Ethiopian Birr"],
  ["EUR", "Euro"],
  ["FKP", "Falkland Islands (Malvinas) Pound"],
  ["FJD", "Fijian Dollar"],
  ["XPF", "French Pacific Franc"],
  ["GMD", "Gambian Dalasi"],
  ["GEL", "Georgian Lari"],
  ["GHS", "Ghana Cedi"],
  ["GIP", "Gibraltar Pound"],
  ["XAU", "Gold"],
  ["GTQ", "Guatemalan Quetzal"],
  ["GNF", "Guinean Franc"],
  ["GYD", "Guyana Dollar"],
  ["HTG", "Haitian Gourde"],
  ["HNL", "Honduran Lempira"],
  ["HKD", "Hong Kong Dollar"],
  ["HUF", "Hungarian Forint"],
  ["ISK", "Icelandic Krona"],
  ["INR", "Indian Rupee"],
  ["IDR", "Indonesian Rupiah"],
  ["IRR", "Iranian Rial"],
  ["IQD", "Iraqi Dinar"],
  ["JMD", "Jamaican Dollar"],
  ["JPY", "Japanese Yen"],
  ["JOD", "Jordanian Dinar"],
  ["KZT", "Kazakhstani Tenge"],
  ["KES", "Kenyan Shilling"],
  ["KPW", "Korea (North) Won"],
  ["KWD", "Kuwaiti Dinar"],
  ["AOA", "Kwanza"],
  ["KGS", "Kyrgyzstani Som"],
  ["LAK", "Lao Kip"],
  ["LBP", "Lebanese Pound"],
  ["LSL", "Lesotho Loti"],
  ["LRD", "Liberian Dollar"],
  ["LYD", "Libyan Dinar"],
  ["LTC", "Litecoin"],
  ["MOP", "Macanese Pataca"],
  ["MKD", "Macedonian Denar"],
  ["MGA", "Malagasy Ariary"],
  ["MWK", "Malawian Kwacha"],
  ["MYR", "Malaysian Ringgit"],
  ["MVR", "Maldivian Rufiyaa"],
  ["MUR", "Mauritian Rupee"],
  ["MXN", "Mexican Peso"],
  ["MDL", "Moldovan Leu"],
  ["MNT", "Mongolia Tughrik"],
  ["MAD", "Moroccan Dirham"],
  ["MZN", "Mozambican Metical"],
  ["MMK", "Myanmar Kyat"],
  ["ERN", "Nakfa"],
  ["NAD", "Namibian Dollar"],
  ["NPR", "Nepalese Rupee"],
  ["ANG", "Netherlands Antilles Guilder"],
  ["ILS", "New Israeli Sheqel"],
  ["NZD", "New Zealand Dollar"],
  ["NIO", "Nicaraguan Córdoba"],
  ["NGN", "Nigerian Naira"],
  ["NOK", "Norwegian Krone"],
  ["OMR", "Omani Rial"],
  ["MRU", "Ouguiya"],
  ["TOP", "Pa’anga"],
  ["PKR", "Pakistan Rupee"],
  ["XPD", "Palladium"],
  ["PAB", "Panamanian Balboa"],
  ["PGK", "Papua New Guinean Kina"],
  ["PYG", "Paraguayan Guaraní"],
  ["PEN", "Peruvian Nuevo Sol"],
  ["PHP", "Philippine Peso"],
  ["XPT", "Platinum"],
  ["PLN", "Polish Zloty"],
  ["GBP", "Pound Sterling"],
  ["QAR", "Qatari Rial"],
  ["XRP", "Ripple"],
  ["RON", "Romanian Leu"],
  ["RUB", "Russian Ruble"],
  ["RWF", "Rwandan Franc"],
  ["SHP", "Saint Helena Pound"],
  ["SVC", "Salvadoran Colon"],
  ["SAR", "Saudi Riyal"],
  ["RSD", "Serbian Dinar"],
  ["SCR", "Seychellois Rupee"],
  ["SLL", "Sierra Leonean Leone"],
  ["XAG", "Silver"],
  ["SGD", "Singapore Dollar"],
  ["SBD", "Solomon Islands Dollar"],
  ["SOS", "Somali Shilling"],
  ["TJS", "Somoni"],
  ["ZAR", "South African Rand"],
  ["KRW", "South Korean Won"],
  ["LKR", "Sri Lankan Rupee"],
  ["SDG", "Sudanese Pound"],
  ["SRD", "Suriname Dollar"],
  ["SZL", "Swazi Lilangeni"],
  ["SEK", "Swedish Krone"],
  ["CHF", "Swiss Franc"],
  ["SYP", "Syrian Pound"],
  ["TWD", "Taiwan Dollar"],
  ["WST", "Tala"],
  ["TZS", "Tanzanian Shilling"],
  ["THB", "Thai Baht"],
  ["TTD", "Trinidad and Tobago Dollar"],
  ["TND", "Tunisian Dinar"],
  ["TRY", "Turkish Lira"],
  ["TMT", "Turkmenistan Manat"],
  ["UGX", "Ugandan Shilling"],
  ["UAH", "Ukrainian Hryvnia"],
  ["UYU", "Uruguayan Peso"],
  ["USD", "US Dollar"],
  ["UZS", "Uzbekistani Som"],
  ["VUV", "Vanuatu Vatu"],
  ["VND", "Vietnamese Dong"],
  ["XOF", "West African CFA Franc"],
  ["YER", "Yemeni Rial"],
  ["ZMW", "Zambian Kwacha"],
];
const currencySymbols = {
  "AFN": "AF", // fixed
  "ALL": "L",
  "DZD": "DZ", // fixed (Arabic)
  "ARS": "\$",
  "AMD": "֏",
  "AWG": "ƒ",
  "AUD": "\$",
  "AZN": "₼",
  "BSD": "\$",
  "BHD": "BH", // fixed
  "BDT": "৳",
  "BBD": "\$",
  "BYN": "Br",
  "BZD": "\$",
  "BMD": "\$",
  "BTN": "Nu.",
  "BTC": "₿",
  "BCH": "₿",
  "VES": "Bs.",
  "BOB": "Bs.",
  "BAM": "KM",
  "BWP": "P",
  "BRL": "R\$",
  "BND": "\$",
  "BGN": "лв",
  "BIF": "FBu",
  "KHR": "៛",
  "CAD": "\$",
  "CVE": "\$",
  "KYD": "\$",
  "XAF": "FCFA",
  "CLP": "\$",
  "CNY": "¥",
  "CNH": "¥",
  "COP": "\$",
  "KMF": "CF",
  "CDF": "FC",
  "CRC": "₡",
  "HRK": "kn",
  "CUP": "\$",
  "CZK": "Kč",
  "DKK": "kr",
  "DJF": "Fdj",
  "STN": "Db",
  "DOP": "\$",
  "XCD": "\$",
  "EGP": "EG", // fixed
  "AED": "AE", // fixed
  "ETH": "Ξ",
  "ETB": "Br",
  "EUR": "€",
  "FKP": "£",
  "FJD": "\$",
  "XPF": "₣",
  "GMD": "D",
  "GEL": "₾",
  "GHS": "₵",
  "GIP": "£",
  "XAU": "Au",
  "GTQ": "Q",
  "GNF": "FG",
  "GYD": "\$",
  "HTG": "G",
  "HNL": "L",
  "HKD": "\$",
  "HUF": "Ft",
  "ISK": "kr",
  "INR": "₹",
  "IDR": "Rp",
  "IRR": "IR", // fixed
  "IQD": "IQ", // fixed
  "JMD": "\$",
  "JPY": "¥",
  "JOD": "JO", // fixed
  "KZT": "₸",
  "KES": "KSh",
  "KPW": "₩",
  "KWD": "KW", // fixed
  "AOA": "Kz",
  "KGS": "сом",
  "LAK": "₭",
  "LBP": "LB", // fixed
  "LSL": "L",
  "LRD": "\$",
  "LYD": "LY", // fixed
  "LTC": "Ł",
  "MOP": "P",
  "MKD": "ден",
  "MGA": "Ar",
  "MWK": "MK",
  "MYR": "RM",
  "MVR": "Rf",
  "MUR": "₨",
  "MXN": "\$",
  "MDL": "L",
  "MNT": "₮",
  "MAD": "MA", // fixed
  "MZN": "MT",
  "MMK": "Ks",
  "ERN": "Nfk",
  "NAD": "\$",
  "NPR": "₨",
  "ANG": "ƒ",
  "ILS": "₪",
  "NZD": "\$",
  "NIO": "\$",
  "NGN": "₦",
  "NOK": "kr",
  "OMR": "OM", // fixed
  "MRU": "UM",
  "TOP": "\$",
  "PKR": "₨",
  "XPD": "Pd",
  "PAB": "B/.",
  "PGK": "K",
  "PYG": "₲",
  "PEN": "S/",
  "PHP": "₱",
  "XPT": "Pt",
  "PLN": "zł",
  "GBP": "£",
  "QAR": "QA", // fixed
  "XRP": "Ʀ",
  "RON": "lei",
  "RUB": "₽",
  "RWF": "FRw",
  "SHP": "£",
  "SVC": "₡",
  "SAR": "SA", // fixed
  "RSD": "дин",
  "SCR": "₨",
  "SLL": "Le",
  "XAG": "Ag",
  "SGD": "\$",
  "SBD": "\$",
  "SOS": "Sh",
  "TJS": "SM",
  "ZAR": "R",
  "KRW": "₩",
  "LKR": "₨",
  "SDG": "SD", // fixed
  "SRD": "\$",
  "SZL": "E",
  "SEK": "kr",
  "CHF": "CHF",
  "SYP": "SY", // fixed
  "TWD": "\$",
  "WST": "T",
  "TZS": "Sh",
  "THB": "฿",
  "TTD": "\$",
  "TND": "TN", // fixed
  "TRY": "₺",
  "TMT": "m",
  "UGX": "USh",
  "UAH": "₴",
  "UYU": "\$",
  "USD": "\$",
  "UZS": "so'm",
  "VUV": "Vt",
  "VND": "₫",
  "XOF": "CFA",
  "YER": "YE", // fixed
  "ZMW": "ZK",
};
const Map<String, String> currencyLocale = {
  // 🌍 International (default style)
  "USD": "en_US", "CAD": "en_CA", "AUD": "en_AU", "NZD": "en_NZ",
  "SGD": "en_SG", "HKD": "en_HK", "ZAR": "en_ZA", "NGN": "en_NG",
  "KES": "en_KE", "GHS": "en_GH", "JMD": "en_JM", "TTD": "en_TT",

  // 🇬🇧 UK style
  "GBP": "en_GB",

  // 🇮🇳 Indian format
  "INR": "en_IN", "NPR": "en_IN", "PKR": "en_PK", "LKR": "en_LK",
  "BDT": "bn_BD",

  // 🇪🇺 European format
  "EUR": "de_DE", "BRL": "pt_BR", "PLN": "pl_PL", "TRY": "tr_TR",
  "RON": "ro_RO", "HUF": "hu_HU", "CZK": "cs_CZ", "DKK": "da_DK",
  "NOK": "nb_NO", "SEK": "sv_SE", "ISK": "is_IS",

  // 🇷🇺 / Eastern Europe
  "RUB": "ru_RU", "UAH": "uk_UA", "BYN": "be_BY", "RSD": "sr_RS",

  // 🇨🇳 East Asia
  "CNY": "zh_CN", "CNH": "zh_CN", "TWD": "zh_TW",
  "JPY": "ja_JP", "KRW": "ko_KR",

  // 🌏 Southeast Asia
  "THB": "th_TH", "IDR": "id_ID", "MYR": "ms_MY",
  "PHP": "en_PH", "VND": "vi_VN",

  // 🕌 Middle East (Arabic style)
  "AED": "ar_AE", "SAR": "ar_SA", "QAR": "ar_QA", "KWD": "ar_KW",
  "BHD": "ar_BH", "OMR": "ar_OM", "JOD": "ar_JO",
  "EGP": "ar_EG", "IQD": "ar_IQ", "IRR": "fa_IR",

  // 🌍 Africa
  "ETB": "am_ET", "TZS": "sw_TZ", "UGX": "en_UG",
  "ZMW": "en_ZM", "MWK": "en_MW", "BWP": "en_BW",

  // 🌎 Latin America
  "MXN": "es_MX", "ARS": "es_AR", "CLP": "es_CL",
  "COP": "es_CO", "PEN": "es_PE", "UYU": "es_UY",
  "PYG": "es_PY", "BOB": "es_BO", "CRC": "es_CR",

  // ⚠️ Special / fallback (no strict country)
  "XOF": "fr_FR", "XAF": "fr_FR", "XCD": "en_US",
  "XPF": "fr_FR",

  // ⚠️ Crypto / metals → use default
  "BTC": "en_US", "ETH": "en_US", "XRP": "en_US",
  "XAU": "en_US", "XAG": "en_US", "XPT": "en_US",
};

class changeProvider extends ChangeNotifier {
  late List<String> _pCountry;
  late List<String> _sCountry;
  SharedPreferences? prefs;
  Future<void> initPrefernce() async {
    prefs = await SharedPreferences.getInstance();
    final String? seletedRate = prefs!.getString('SelectedRates');
    if (seletedRate != null) {
      final result = List<List<String>>.from(
        jsonDecode(seletedRate).map((e) => List<String>.from(e)),
      );
      _pCountry = result[0];
      _sCountry = result[1];
    }
    notifyListeners();
  }

  List<String> get pCountry => _pCountry;
  List<String> get sCountry => _sCountry;
  void pcChange(List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    final String? seletedRate = prefs.getString('SelectedRates');
    _pCountry = List<String>.from(value);
    final result = List<List<String>>.from(
      jsonDecode(seletedRate!).map((e) => List<String>.from(e)),
    );
    result.removeWhere((item) => item[0] == _pCountry[0]);
    result.insert(0, _pCountry);
    await prefs.setString("SelectedRates", jsonEncode(result));
    notifyListeners();
  }

  Future<bool> hasInternet() async {
    return await InternetConnectionChecker().hasConnection;
  }

  void scChange(List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    final String? seletedRate = prefs.getString('SelectedRates');
    _sCountry = List<String>.from(value);
    final result = List<List<String>>.from(
      jsonDecode(seletedRate!).map((e) => List<String>.from(e)),
    );
    result.removeWhere((item) => item[0] == _sCountry[0]);
    result.insert(1, _sCountry);
    await prefs.setString("SelectedRates", jsonEncode(result));
    notifyListeners();
  }

  Future<void> databaseDownload() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString("SelectedRates");
    final codes = List<List<String>>.from(
      jsonDecode(raw!).map((e) => List<String>.from(e)),
    );
    var dataset = {};
    String date = "null";
    for (var i in codes) {
      final responce = await get(
        Uri.parse(
          'https://latest.currency-api.pages.dev/v1/currencies/${i[0].toLowerCase()}.json',
        ),
      );
      final result = jsonDecode(responce.body);
      dataset[i[0].toLowerCase()] = result[i[0].toLowerCase()];
      if (date == "null") {
        date = result['date'];
      }
      // final prefs = await SharedPreferences.getInstance();
    }
    dataset['date'] = date;
    String? stored = prefs.getString("times");

    List<List<String>> times = stored != null
        ? List<List<String>>.from(
            jsonDecode(stored).map((e) => List<String>.from(e)),
          )
        : [];

    void addTime() {
      DateTime now = DateTime.now();

      String formattedTime =
          "${now.hour.toString().padLeft(2, '0')}:"
          "${now.minute.toString().padLeft(2, '0')}:"
          "${now.second.toString().padLeft(2, '0')}";
      String formattedDate =
          "${now.year.toString().padLeft(2, '0')}-"
          "${now.month.toString().padLeft(2, '0')}-"
          "${now.day.toString().padLeft(2, '0')}";
      times.insert(0, [formattedDate, formattedTime, dataset['date']]);

      if (times.length > 5) {
        times.removeLast();
      }
      prefs.setString("times", jsonEncode(times));
    }

    addTime();
    prefs.setString("dataset", jsonEncode(dataset));
    initPrefernce();
    //time
    notifyListeners();
  }

  Future<void> addSelected() async {
    final prefs = await SharedPreferences.getInstance();
    final datavalue = jsonDecode(prefs.getString('addSet')!);
    final raw = jsonDecode(prefs.getString("SelectedRates")!);
    final dataset = jsonDecode(prefs.getString("dataset")!);

    for (var i in datavalue) {
      final responce = await get(
        Uri.parse(
          'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/${i[0].toLowerCase()}.json',
        ),
      );
      final result = jsonDecode(responce.body);
      if (dataset != null) {
        dataset[i[0].toLowerCase()] = result[i[0].toLowerCase()];
        raw.insert(0, i);
        prefs.setString("dataset", jsonEncode(dataset));
        prefs.setString("SelectedRates", jsonEncode(raw));
      }
    }
    notifyListeners();
  }

  Future<void> delSelect() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString("SelectedRates");
    final delList = prefs.getString("delSelect");
    final selRate = List<List<String>>.from(
      jsonDecode(raw!).map((e) => List<String>.from(e)),
    );
    final eList = List<List<String>>.from(
      jsonDecode(delList!).map((e) => List<String>.from(e)),
    );
    selRate.removeWhere((item) => eList.any((e) => e[0] == item[0]));
    await prefs.setString("SelectedRates", jsonEncode(selRate));
    notifyListeners();
  }
}
