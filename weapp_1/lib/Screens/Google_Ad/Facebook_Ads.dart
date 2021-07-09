import 'package:flutter/material.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

class AdsPage extends StatefulWidget {
  @override
  AdsPageState createState() => AdsPageState();
}

class AdsPageState extends State<AdsPage> {
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;
  bool _isRewardedVideoComplete = false;

  @override
  void initState() {
    super.initState();
    FacebookAudienceNetwork.init(
      testingId: "b9f2908b-1a6b-4a5b-b862-ded7ce289e41",
    );
    _loadInterstitialAd();
    _loadRewardedVideoAd();
  }

  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617",//898853027568012_898874570899191
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED){
          setState(() {
            _isInterstitialAdLoaded = true;
          });
        }
        if (result == InterstitialAdResult.DISMISSED && value["invalidated"] == true) {
          setState(() {
            _isInterstitialAdLoaded = false;
          });
          _loadInterstitialAd();
        }
      },
    );
  }

  void _loadRewardedVideoAd() {
    FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: "VID_HD_9_16_39S_APP_INSTALL#898853027568012_965302514256396",
      listener: (result, value) {
        print("Rewarded Ad: $result --> $value");
        if (result == RewardedVideoAdResult.LOADED) _isRewardedAdLoaded = true;
        if (result == RewardedVideoAdResult.VIDEO_COMPLETE)
          _isRewardedVideoComplete = true;

        /// Once a Rewarded Ad has been closed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == RewardedVideoAdResult.VIDEO_CLOSED &&
            (value == true || value["invalidated"] == true)) {
          _isRewardedAdLoaded = false;
          _loadRewardedVideoAd();
        }
      },
    );
  }
  _showRewardedAd() {
    if (_isRewardedAdLoaded == true)
      FacebookRewardedVideoAd.showRewardedVideoAd();
    else
      print("Rewarded Ad not yet loaded!");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("FaceBook")),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: () {
                      if (_isInterstitialAdLoaded == true)
                        FacebookInterstitialAd.showInterstitialAd();
                    },
                    child: Text("Interstitial"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      _showRewardedAd();
                    },
                    child: Text("Reward"),
                  ),
                ],
              ),
              FacebookBannerAd(
                placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047",//898853027568012_898872740899374
                bannerSize: BannerSize.STANDARD,
              ),
              FacebookBannerAd(
                placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047",
                bannerSize: BannerSize.LARGE,
              ),
              FacebookNativeAd(
                placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964953543583512",
                adType: NativeAdType.NATIVE_BANNER_AD,
                bannerAdSize: NativeBannerAdSize.HEIGHT_100,
                width: double.infinity,
                backgroundColor: Colors.red,
                titleColor: Colors.purple,
                descriptionColor: Colors.green,
                buttonColor: Colors.yellowAccent,
                buttonTitleColor: Colors.pink,
                buttonBorderColor: Colors.orange,
                listener: (result, value) {
                  print("Native Banner Ad: $result --> $value");
                },
              ),
              FacebookNativeAd(
                placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964952163583650",
                adType: NativeAdType.NATIVE_AD_VERTICAL,
                width: double.infinity,
                height: 300,
                listener: (result, value) {
                  print("Native Ad: $result --> $value");
                },
                keepExpandedWhileLoading: true,
                expandAnimationDuraion: 1000,
              ),
            ],
          ),
        ),
      ),
    );
  }

}