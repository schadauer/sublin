import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sublin/models/address_id_arguments.dart';

import 'package:sublin/models/auth.dart';
import 'package:sublin/models/provider_user.dart';
import 'package:sublin/screens/provider/provider_home_screen.dart';
import 'package:sublin/screens/provider/provider_registration.dart';
import 'package:sublin/screens/user/user_routing_screen.dart';
import 'package:sublin/services/auth_service.dart';
import 'package:sublin/services/google_map_service.dart';
import 'package:sublin/services/routing_service.dart';

import 'package:sublin/models/routing.dart';
import 'package:sublin/widgets/address_search_widget.dart';
import 'package:sublin/widgets/drawer_side_navigation_widget.dart';
// import 'package:sublin/widgets/drawer_side_navigation_widget.dart';
// import 'package:sublin/widgets/provider_bottom_navigation_bar_widget.dart';

class StartEnd extends StatefulWidget {
  static const routeName = '/startEnd';
  String startAddress;
  String startId;
  bool showStartAddress;
  String endAddress;
  String endId;
  String buttonText;
  bool providerRequest;

  StartEnd({
    this.startAddress,
    this.startId,
    this.showStartAddress = true,
    this.endAddress,
    this.endId,
    this.buttonText = 'Verbindung suchen',
    this.providerRequest = false,
  });

  @override
  _StartEndState createState() => _StartEndState();
}

class _StartEndState extends State<StartEnd> {
  final AuthService _auth = AuthService();
  Routing _localRouting = Routing();
  bool _geoLocationPermissionIsGranted = false;
  Position _currentLocationLatLng;
  List _currentLocationAutocompleteResults;

  @override
  void initState() {
    super.initState();
    _localRouting.startAddress = widget.startAddress ?? '';
    _localRouting.startId = widget.startId ?? '';
    _localRouting.endAddress = widget.endAddress ?? '';
    _localRouting.endId = widget.endId ?? '';
    _isGeoLocationPermissionGranted();
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    // final ProviderUser providerUser = Provider.of<ProviderUser>(context);

    return Scaffold(
      body: SizedBox(
        height: 440,
        child: ListView(
          children: <Widget>[
            (_geoLocationPermissionIsGranted == false)
                ? InkWell(
                    onTap: () {
                      openAppSettings();
                    },
                    child: Container(
                      height: 80,
                      color: Color.fromRGBO(201, 228, 202, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                              onPressed: () => openAppSettings(),
                              child: Text('Location Service einschalten'))
                        ],
                      ),
                    ),
                  )
                : Container(),
            if (widget.showStartAddress)
              AddressSearchWidget(
                textInputFunction: textInputFunction,
                isStartAddress: true,
                address: _localRouting.startAddress,
              ),
            AddressSearchWidget(
              textInputFunction: textInputFunction,
              isEndAddress: true,
              address: _localRouting.endAddress,
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: (_localRouting.endAddress != '' &&
                            _localRouting.startAddress != '')
                        ? () async {
                            try {
                              await RoutingService().requestRoute(
                                uid: auth.uid,
                                startAddress: _localRouting.startAddress,
                                startId: _localRouting.startId,
                                endAddress: _localRouting.endAddress,
                                endId: _localRouting.endId,
                              );
                              if (widget.providerRequest) {
                                Navigator.pushNamed(
                                    context, ProviderRegistration.routeName);
                              } else {
                                await Navigator.pushNamed(
                                  context,
                                  RoutingScreen.routeName,
                                  arguments: AddressIdArguments(
                                    _localRouting.startId,
                                    _localRouting.endId,
                                  ),
                                );
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                        : null,
                    child: Text(widget.buttonText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void textInputFunction(
      String input, String id, bool startAddress, bool endAddress) {
    setState(() {
      if (startAddress) _localRouting.startAddress = input;
      if (startAddress) _localRouting.startId = id;
      if (endAddress) _localRouting.endAddress = input;
      if (endAddress) _localRouting.endId = id;
    });
  }

  Future<void> _getCurrentCoordinates() async {
    if (_geoLocationPermissionIsGranted) {
      try {
        final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
        Position position = await geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation);
        setState(() {
          _currentLocationLatLng = position;
        });
        String address = await _getPlacemarkFromCoordinates(
            _currentLocationLatLng.latitude, _currentLocationLatLng.longitude);
        _currentLocationAutocompleteResults =
            await GoogleMapService().getGoogleAddressAutocomplete(address, '');
        setState(() {
          _localRouting.startAddress =
              _currentLocationAutocompleteResults[0]['name'];
          _localRouting.startId = _currentLocationAutocompleteResults[0]['id'];
        });
      } catch (e) {
        print('_getCurrentCoordinates: $e');
      }
    }
  }

  Future<String> _getPlacemarkFromCoordinates(double lat, double lng) async {
    try {
      String address;
      List<Placemark> placemark = await Geolocator()
          .placemarkFromCoordinates(lat, lng, localeIdentifier: 'de_DE');
      placemark.map((e) {
        address = '${e.thoroughfare} ${e.subThoroughfare}, ${e.locality}';
      }).toList();
      return address;
    } catch (e) {
      print('_getPlacemarkFromCoordinates: $e');
      return '';
    }
  }

  Future<void> _isGeoLocationPermissionGranted() async {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();

    if (geolocationStatus == GeolocationStatus.granted) {
      setState(() {
        _geoLocationPermissionIsGranted = true;
      });
      _getCurrentCoordinates();
    } else {
      setState(() {
        _geoLocationPermissionIsGranted = false;
      });
    }
  }
}