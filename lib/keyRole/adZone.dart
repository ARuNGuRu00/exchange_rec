import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NtvAd extends StatefulWidget {
  const NtvAd({super.key});

  @override
  State<NtvAd> createState() => _NtvAdState();
}

class _NtvAdState extends State<NtvAd> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-7958650172143614/4424172807'
      : 'ca-app-pub-3940256099942544/3986624511';

  void loadAd() {
    _nativeAd = NativeAd(
      adUnitId: _adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
      request: const AdRequest(),
      // Styling
      nativeTemplateStyle: NativeTemplateStyle(
        // Required: Choose a template.
        templateType: TemplateType.medium,
        // Optional: Customize the ad's style.
        mainBackgroundColor: const Color.fromARGB(0, 0, 0, 0),
        cornerRadius: 10.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.cyan,
          backgroundColor: const Color.fromARGB(255, 30, 30, 30),
          style: NativeTemplateFontStyle.monospace,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: const Color.fromARGB(255, 224, 223, 223),
          backgroundColor: const Color.fromARGB(0, 146, 6, 50),
          style: NativeTemplateFontStyle.italic,
          size: 16.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: const Color.fromARGB(255, 129, 129, 129),
          backgroundColor: Colors.black,
          style: NativeTemplateFontStyle.bold,
          size: 12.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: const Color.fromARGB(255, 131, 131, 131),
          backgroundColor: const Color.fromARGB(0, 255, 193, 7),
          style: NativeTemplateFontStyle.normal,
          size: 11.0,
        ),
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded) {
      return const SizedBox(height: 150);
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(height: 150, child: AdWidget(ad: _nativeAd!)),
    );
  }
}

class AdSite extends StatefulWidget {
  const AdSite({super.key});

  @override
  State<AdSite> createState() => _AdSiteState();
}

class _AdSiteState extends State<AdSite> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  void _loadBanner() async {
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-7958650172143614/4943047556",
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (_, error) {},
      ),
    );
    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size;
    return SizedBox(
      height: height.height * 0.05,
      width: double.infinity,
      child: (_isAdLoaded) ? AdWidget(ad: _bannerAd) : null,
    );
  }
}
