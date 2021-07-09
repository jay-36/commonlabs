  import 'dart:async';
import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';


class AdTypes extends StatefulWidget {
  @override
  _AdTypesState createState() => _AdTypesState();
}

class _AdTypesState extends State<AdTypes> {
  final ams = AdMobServices();
  AdmobReward rewardAd;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // createRewardAdAndLoad();
    rewardAd = AdmobReward(
      adUnitId: "ca-app-pub-3940256099942544/5224354917",
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) {
          print(">>> Closed");
          rewardAd.load();
          setState(() {});
        }
        if (event == AdmobAdEvent.clicked) {
          print(">>> clicked");
        }
        if (event == AdmobAdEvent.completed) {
          rewardAd.load();
        setState(() {});
          print(">>> completed");
        }
        if (event == AdmobAdEvent.opened) {
          print(">>> opened");
        }
        if (event == AdmobAdEvent.rewarded) {
          rewardAd.load();
          setState(() {});
         print(">>> rewarded");
        }
        if(event == AdmobAdEvent.closed){
          return showDialog(context: context,builder: (BuildContext context){
            return AlertDialog(
              title: Text("You get 10 Coins"),
            );
          });
          rewardAd.load();
          setState(() {});
        }
      },
    );
    rewardAd.load();
    setState(() {});
  }

  // createRewardAdAndLoad() {
  //   RewardedVideoAd.instance.load(
  //       adUnitId: RewardedVideoAd.testAdUnitId,
  //       targetingInfo: MobileAdTargetingInfo());
  //   RewardedVideoAd.instance.listener =
  //       (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
  //     switch (event) {
  //       case RewardedVideoAdEvent.rewarded:
  //       print(">>>"+rewardAmount.toString());
  //         break;
  //       default:
  //     }
  //     print(
  //         "************************************createReawrdAdAndLoad $event****************************************");
  //   };
  // }

  @override
  void dispose() {
    rewardAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AdmobInterstitial showInterstitial = ams.getNewTripInterstitial();
    showInterstitial.load();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: () async {
                      if (await showInterstitial.isLoaded) {
                        showInterstitial.show();
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => nativDemo(),
                          ));
                    },
                    child: Text("Show Interstitial"),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      if (await rewardAd.isLoaded) {
                        rewardAd.show();
                      }
                      // RewardedVideoAd.instance..show();
                    },
                    child: Text("Show Reward"),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                child: AdmobBanner(
                    adUnitId: ams.getBannerAdId(),
                    adSize: AdmobBannerSize.FULL_BANNER),
              ),
              Container(
                width: double.infinity,
                child: AdmobBanner(
                    adUnitId: ams.getBannerAdId(),
                    adSize: AdmobBannerSize.SMART_BANNER(context)),
              ),
              Container(
                width: double.infinity,
                child: AdmobBanner(
                    adUnitId: ams.getBannerAdId(),
                    adSize: AdmobBannerSize.LARGE_BANNER),
              ),
              Container(
                width: double.infinity,
                child: AdmobBanner(
                    adUnitId: ams.getBannerAdId(),
                    adSize: AdmobBannerSize.BANNER),
              ),
              Container(
                width: double.infinity,
                child: AdmobBanner(
                    adUnitId: ams.getBannerAdId(),
                    adSize: AdmobBannerSize.ADAPTIVE_BANNER(width: 500)),
              ),
              Container(
                width: double.infinity,
                child: AdmobBanner(
                    adUnitId: ams.getBannerAdId(),
                    adSize: AdmobBannerSize.MEDIUM_RECTANGLE),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdMobServices {
  AdmobInterstitial interstitialAd;

  String getBannerAdId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }

  String getInterstitialAdId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    return null;
  }

  AdmobInterstitial getNewTripInterstitial() {
    return interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        break;
      case AdmobAdEvent.opened:
        break;
      case AdmobAdEvent.closed:
        break;
      case AdmobAdEvent.failedToLoad:
        break;
      default:
    }
  }
}


class nativDemo extends StatefulWidget {
  @override
  _nativDemoState createState() => _nativDemoState();
}

class _nativDemoState extends State<nativDemo> {
  static const _adUnitID = "ca-app-pub-3940256099942544/8135179316";

  final _nativeAdController = NativeAdmobController();
  double _height = 0;

  StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _nativeAdController.dispose();
    super.dispose();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _height = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _height = 330;
        });
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            height: 200.0,
            color: Colors.green,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            height: 200.0,
            color: Colors.green,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            height: 200.0,
            color: Colors.green,
          ),
          Container(
            height: _height,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 20.0),
            child: NativeAdmob(
              // Your ad unit id
              adUnitID: _adUnitID,
              controller: _nativeAdController,

              // Don't show loading widget when in loading state
              loading: Container(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            height: 200.0,
            color: Colors.green,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            height: 200.0,
            color: Colors.green,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            height: 200.0,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}