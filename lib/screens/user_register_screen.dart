import 'package:Sublin/models/sublin_error_enum.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:Sublin/widgets/progress_indicator_widget.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/widgets/provider_selection_widget.dart';
import 'package:Sublin/screens/user_sign_in_screen.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/utils/is_email_format.dart';

class UserRegisterScreen extends StatefulWidget {
  @override
  _UserRegisterScreenState createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final AuthService _auth = AuthService();
  String firstName = '';
  String email = '';
  String password = '';
  UserType userType = UserType.user;
  String providerName = '';
  bool textFocus = false;
  bool firstNameProvided = false;
  bool emailProvided = false;
  bool passwordProvided = false;
  bool providerChecked = false;
  PageController _pageViewController = PageController(initialPage: 0);
  // To controll which pages can be accessed
  int _pageStep = 0;
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwortTextController = TextEditingController();
  TextEditingController _firstNameTextController = TextEditingController();
  SublinError _emailError = SublinError.none;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageViewController ?? _pageViewController.dispose();
    _emailTextController ?? _emailTextController.dispose();
    _passwortTextController ?? _passwortTextController.dispose();
    _firstNameTextController ?? _firstNameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Form(
        key: _formKey,
        child: PageView(
          controller: _pageViewController,
          children: [
            if (_pageStep >= 0)
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      textFocus = false;
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      ProgressIndicatorWidget(
                        index: 1,
                        elements: 2,
                        showProgressIndicator: false,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 50, left: 15, right: 15),
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: AutoSizeText(
                                    'Hallo $firstName ',
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            AutoSizeText(
                              'Sublin ist ein Open-Source Projekt. Wir gestalten die Mobilität der Zukunft. Sublin verbindet dabei Mobilitätsdienstleister für eine lückenlose Tür-zu-Tür-Verbindung ohne eigenes Auto - in der Stadt und am Land. Melde dich an und werde Teil unseres Projekts.',
                              style: Theme.of(context).textTheme.bodyText1,
                              maxLines: 8,
                            ),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.only(top: (textFocus) ? 90 : 260),
                        duration: Duration(milliseconds: 100),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                TextFormField(
                                    validator: (val) => val.length < 2
                                        ? 'Bitte gib deinen Vornamen an'
                                        : null,
                                    onTap: () {
                                      textFocus = true;
                                    },
                                    controller: _firstNameTextController,
                                    onChanged: (val) {
                                      setState(() {
                                        _pageStep = 0;
                                        firstName = val;
                                        if (val.length > 0) {
                                          firstNameProvided = true;
                                        } else {
                                          firstNameProvided = false;
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Dein Vorname',
                                        prefixIcon: Icon(
                                          Icons.person,
                                        ))),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    validator: (val) => val.length < 2 ||
                                            !isEmailFormat(val)
                                        ? 'Bitte gib eine gültige E-Mailadresse an'
                                        : _emailError ==
                                                SublinError.emailAlreadyInUse
                                            ? 'Email existiert bereits'
                                            : null,
                                    onTap: () {
                                      setState(() {
                                        textFocus = true;
                                      });
                                    },
                                    controller: _emailTextController,
                                    onChanged: (val) {
                                      setState(() {
                                        _pageStep = 0;
                                        _emailError = SublinError.none;
                                        email = val;
                                        if (isEmailFormat(val)) {
                                          emailProvided = true;
                                        } else {
                                          emailProvided = false;
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Deine Email Adresse',
                                      filled: Theme.of(context)
                                          .inputDecorationTheme
                                          .filled,
                                      border: Theme.of(context)
                                          .inputDecorationTheme
                                          .border,
                                      focusedBorder: Theme.of(context)
                                          .inputDecorationTheme
                                          .focusedBorder,
                                      fillColor: Theme.of(context)
                                          .inputDecorationTheme
                                          .fillColor,
                                      prefixIcon: Icon(
                                        Icons.email,
                                      ),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    validator: (val) => val.length < 6
                                        ? 'Das Passwort muss eine Mindeslänge von 6 Zeichen haben'
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        textFocus = true;
                                      });
                                    },
                                    controller: _passwortTextController,
                                    onChanged: (val) {
                                      setState(() {
                                        _pageStep = 0;
                                        password = val;
                                      });
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: 'Passwort',
                                      filled: Theme.of(context)
                                          .inputDecorationTheme
                                          .filled,
                                      border: Theme.of(context)
                                          .inputDecorationTheme
                                          .border,
                                      focusedBorder: Theme.of(context)
                                          .inputDecorationTheme
                                          .focusedBorder,
                                      fillColor: Theme.of(context)
                                          .inputDecorationTheme
                                          .fillColor,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                      ),
                                    )),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        style: ButtonStyle(
                                            textStyle:
                                                MaterialStateProperty.all(
                                                    Theme.of(context)
                                                        .textTheme
                                                        .subtitle1)),
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserSignInScreen())),
                                        child: Text(
                                          'Bereits registriert?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .button,
                                        )),
                                    ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          if (_formKey.currentState
                                              .validate()) {
                                            FocusScope.of(context).unfocus();
                                            setState(() {
                                              _pageStep = 1;
                                            });
                                            _pageViewController.nextPage(
                                                duration:
                                                    Duration(milliseconds: 300),
                                                curve: Curves.easeOut);
                                          }
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: Text('Weiter'),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            // Second Page ------------------------------- 2 ----------------------------------
            if (_pageStep >= 1)
              SingleChildScrollView(
                  child: Column(
                children: [
                  ProgressIndicatorWidget(
                    index: 2,
                    elements: 2,
                    showProgressIndicator: false,
                  ),
                  Padding(
                    padding: ThemeConstants.mediumPadding,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: AutoSizeText(
                                  '$firstName, du meldest dich an als: ',
                                  style: Theme.of(context).textTheme.headline1,
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ProviderTypeSelectionWidget(
                          title: 'Fahrgast',
                          text:
                              'Du möchtest bequem ohne eigenes Auto überall hin mit öffentlichen Verkehr und Sublin für die "letzte Meile".',
                          selectionCallback: typeSelectionFunction,
                          userType: UserType.user,
                          active: userType == UserType.user,
                        ),
                        ProviderTypeSelectionWidget(
                          title: 'Anbieter',
                          text:
                              'Du bietest Transferdienste an, entweder zu einer bestimmten Adresse oder innerhalb eines bestimmten Gebiets.',
                          selectionCallback: typeSelectionFunction,
                          userType: UserType.provider,
                          active: userType == UserType.provider,
                        ),
                        ProviderTypeSelectionWidget(
                          title: 'Sponsor',
                          text:
                              'Du führst selbst keine Personentransfers durch und beauftragst einen Fahrtendienst.',
                          selectionCallback: typeSelectionFunction,
                          userType: UserType.sponsor,
                          active: userType == UserType.sponsor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  SublinError sublinError =
                                      await _auth.register(
                                    email: email,
                                    password: password,
                                    firstName: firstName,
                                    userType: userType,
                                  );
                                  if (sublinError ==
                                      SublinError.emailAlreadyInUse) {
                                    setState(() {
                                      _emailError =
                                          SublinError.emailAlreadyInUse;
                                    });
                                    _pageViewController
                                        .previousPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeOut)
                                        .then((value) =>
                                            _formKey.currentState.validate());
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Text('Jetzt registrieren'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ))
          ],
        ),
      ),
    ));
  }

  void typeSelectionFunction(userTypeParam) {
    setState(() {
      userType = userTypeParam;
    });
  }

  // Icon _checked(context) {
  //   return Icon(
  //     Icons.check_box,
  //     // color: Theme.of(context).accentColor,
  //   );
  // }

  // Icon _unchecked(context) {
  //   return Icon(
  //     Icons.check_box_outline_blank,
  //     color: Theme.of(context).accentColor,
  //   );
  // }

  // Future<void> _getCurrentCoordinates() async {
  //   final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  //   try {
  //      print(await isLocationPermissionGranted());
  //     await geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.bestForNavigation);
  //   } catch (e) {
  //     ('_getCurrentCoordinates: $e');
  //   }
  // }
}
