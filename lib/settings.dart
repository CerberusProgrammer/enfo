import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:enfo/secret.dart';
import 'package:enfo/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  final bool theme;
  const Settings({
    super.key,
    required this.theme,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late bool _theme;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _theme = widget.theme;
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    if (Platform.isAndroid) {
      InterstitialAd.load(
        adUnitId: admob_id,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => _interstitialAd = ad,
          onAdFailedToLoad: (error) =>
              print('Failed to load interstitial ad: $error'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Settings'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: const Text('Dark Theme'),
                trailing: Switch(
                  value: _theme,
                  onChanged: (bool value) {
                    setState(() {
                      if (value) {
                        AdaptiveTheme.of(context).setDark();
                      } else {
                        AdaptiveTheme.of(context).setLight();
                      }

                      _theme = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Change Theme'),
                trailing: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: const CircleBorder(),
                    side: const BorderSide(
                      color: Color.fromARGB(70, 35, 35, 35),
                      width: 8,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 300,
                                height: 300,
                                child: GridView.count(
                                  shrinkWrap: true,
                                  crossAxisCount: 4,
                                  children: List.generate(Themes.colors.length,
                                      (index) {
                                    return OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Themes.colors[index],
                                        side: const BorderSide(
                                          color: Color.fromARGB(70, 35, 35, 35),
                                          width: 8,
                                        ),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          AdaptiveTheme.of(context).setTheme(
                                            light: Themes.changeTheme(
                                                index, false),
                                            dark:
                                                Themes.changeTheme(index, true),
                                          );
                                        });
                                        Navigator.pop(context);
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        prefs.setInt('defaultIndex', index);
                                      },
                                      child: null,
                                    );
                                  }),
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: null,
                ),
              ),
              ListTile(
                title: const Text('Buy me a coffee'),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    color: Theme.of(context).colorScheme.primary,
                    icon: const Icon(Icons.coffee),
                    onPressed: () async {
                      if (Platform.isWindows) {
                        const url = 'https://www.buymeacoffee.com/sazarcode';
                        final uri = Uri.parse(url);

                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        } else {
                          throw 'Could not launch $url';
                        }
                      } else if (Platform.isAndroid) {
                        const url = 'https://www.buymeacoffee.com/sazarcode';
                        final uri = Uri.parse(url);

                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          throw 'Could not launch $url';
                        }
                      }
                    },
                  ),
                ),
              ),
              Platform.isAndroid
                  ? ListTile(
                      title: const Text('Watch an ad to help'),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          color: Theme.of(context).colorScheme.primary,
                          icon: const Icon(Icons.attach_money),
                          onPressed: () async {
                            if (_interstitialAd == null) {
                              print(
                                  'Warning: attempt to show interstitial before loaded.');
                              return;
                            }
                            _interstitialAd!.fullScreenContentCallback =
                                FullScreenContentCallback(
                              onAdShowedFullScreenContent: (ad) =>
                                  print('$ad onAdShowedFullScreenContent.'),
                              onAdDismissedFullScreenContent: (ad) {
                                print('$ad onAdDismissedFullScreenContent.');
                                ad.dispose();
                                _createInterstitialAd();
                              },
                              onAdFailedToShowFullScreenContent: (ad, error) {
                                print(
                                    '$ad onAdFailedToShowFullScreenContent: $error');
                                ad.dispose();
                                _createInterstitialAd();
                              },
                            );
                            _interstitialAd!.show();
                          },
                        ),
                      ),
                    )
                  : const Center(),
            ],
          ),
        ),
      ),
    );
  }
}
