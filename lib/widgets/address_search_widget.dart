import 'package:Sublin/models/address_info_class.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/utils/get_readable_address_from_formatted_address.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Sublin/screens/address_input_screen.dart';

class AddressSearchWidget extends StatefulWidget {
  final String userUid;
  final User user;
  final bool isStartAddress;
  final bool isEndAddress;
  final bool showGeolocationOption;
  final String startAddress;
  final String startHintText;
  final String endAddress;
  final String endHintText;
  final String address;
  final int startTime;
  final Function addressInputFunction;
  final bool isCheckOnly;
  final String restrictions;
  final String addressTypes;
  final bool isStation;
  final ProviderUser providerUser;
  final String station;
  final List<AddressInfo> addressInfoList;

  AddressSearchWidget({
    this.userUid,
    this.user,
    this.isStartAddress = false,
    this.isEndAddress = false,
    this.showGeolocationOption = false,
    this.startAddress,
    this.startHintText = 'Deinen Standort finden',
    this.endAddress,
    this.endHintText = 'Deine Zieladresse finden',
    this.address = '',
    this.startTime,
    this.addressInputFunction,
    this.isCheckOnly = false,
    this.restrictions = '',
    this.addressTypes = '',
    this.isStation = false,
    this.providerUser,
    this.station,
    this.addressInfoList,
  });

  @override
  _AddressSearchWidgetState createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<AddressSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: 120,
        child: Container(
          child: Stack(children: <Widget>[
            SizedBox(
              height: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if (!widget.isCheckOnly)
                      Container(
                        padding: EdgeInsets.all(0),
                        width: 60,
                        height: 100,
                        color: Colors.white54,
                      ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: (widget.address == '')
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _pushNavigation(context);
                                      },
                                      child: AbsorbPointer(
                                          child: Container(
                                              child: Material(
                                        child: SizedBox(
                                          height: 50,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              contentPadding: Theme.of(context)
                                                  .inputDecorationTheme
                                                  .contentPadding,
                                              fillColor: Theme.of(context)
                                                  .inputDecorationTheme
                                                  .fillColor,
                                              hintText: widget.isStartAddress
                                                  ? widget.startHintText
                                                  : widget.endHintText,
                                              filled: Theme.of(context)
                                                  .inputDecorationTheme
                                                  .filled,
                                              border: Theme.of(context)
                                                  .inputDecorationTheme
                                                  .border,
                                            ),
                                          ),
                                        ),
                                      ))),
                                    ),
                                  )
                                ],
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    if (widget.address != '')
                                      Expanded(
                                        child: AutoSizeText(
                                          getReadableAddressFromFormattedAddress(
                                              widget.address),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          maxLines: 3,
                                          minFontSize: 14,
                                        ),
                                      ),
                                    if (widget.isEndAddress ||
                                        widget.isStartAddress ||
                                        widget.isStation)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              _pushNavigation(context);
                                            },
                                            child: Container(
                                                child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.edit_location,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                                Text(
                                                  'Adresse ändern',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                )
                                              ],
                                            )),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      )
                                  ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!widget.isCheckOnly)
              Container(
                width: 80,
                height: double.infinity,
                child: Stack(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: (widget.isStartAddress)
                            ? EdgeInsets.only(top: 20)
                            : null,
                        height: (widget.isEndAddress) ? 30 : double.infinity,
                        width: 5,
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          (widget.isEndAddress) ? Icons.flag : Icons.home,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
          ]),
        ),
      ),
    );
  }

  Future _pushNavigation(BuildContext context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddressInputScreen(
                  userUid: widget.userUid,
                  user: widget.user,
                  addressInputCallback: widget.addressInputFunction,
                  isEndAddress: widget.isEndAddress,
                  isStartAddress: widget.isStartAddress,
                  showGeolocationOption: widget.showGeolocationOption,
                  isStation: widget.isStation,
                  restrictions: widget.restrictions,
                  addressTypes: widget.addressTypes,
                  title: widget.isEndAddress
                      ? widget.endHintText
                      : widget.startHintText,
                )));
  }
}
