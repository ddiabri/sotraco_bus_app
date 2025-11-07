import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_helper.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    debugPrint('📱 Loading banner ad with ID: ${AdHelper.bannerAdUnitId}');
    debugPrint('📱 Using TEST ads: ${AdHelper.useTestAds}');

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('✅ BannerAd loaded successfully');
          setState(() {
            _isLoaded = true;
            _isLoading = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ BannerAd failed to load: $error');
          debugPrint('❌ Error code: ${error.code}');
          debugPrint('❌ Error domain: ${error.domain}');
          debugPrint('❌ Error message: ${error.message}');
          setState(() {
            _isLoading = false;
            _errorMessage = error.message;
          });
          ad.dispose();
        },
        onAdOpened: (ad) {
          debugPrint('🔵 BannerAd opened');
        },
        onAdClosed: (ad) {
          debugPrint('🔵 BannerAd closed');
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded && _bannerAd != null) {
      // Ad loaded successfully
      return Container(
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: AdWidget(ad: _bannerAd!),
      );
    } else if (_isLoading) {
      // Show loading indicator
      return Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text('Loading ad...', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      );
    } else if (_errorMessage != null) {
      // Show error message (only in debug mode)
      return Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          border: Border(
            top: BorderSide(color: Colors.red.shade300),
          ),
        ),
        child: Text(
          'Ad failed: $_errorMessage',
          style: const TextStyle(fontSize: 10, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      // No ad to show
      return const SizedBox.shrink();
    }
  }
}
