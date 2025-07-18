import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/address_repository.dart';
import 'package:active_ecommerce_flutter/screens/address.dart';
import 'package:active_ecommerce_flutter/screens/shipping_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../custom/loading.dart';
import 'map_location.dart';

class SelectAddress extends StatefulWidget {
  int? owner_id;

  SelectAddress({Key? key, this.owner_id}) : super(key: key);

  @override
  State<SelectAddress> createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  ScrollController _mainScrollController = ScrollController();

  // integer type variables
  int? _seleted_shipping_address = 0;

  // list type variables
  List<dynamic> _shippingAddressList = [];

  // List<PickupPoint> _pickupList = [];
  // List<City> _cityList = [];
  // List<Country> _countryList = [];

  // String _shipping_cost_string = ". . .";

  // Boolean variables
  bool isVisible = true;
  bool _faceData = false;

  //double variables

  var isLocationAvailable;
  var address;
  double mWidth = 0;
  double mHeight = 0;

  fetchAll() {
    if (is_logged_in.$ == true) {
      fetchShippingAddressList();
      //fetchPickupPoints();
    }
    setState(() {});
  }

  fetchShippingAddressList() async {
    var addressResponse = await AddressRepository().getAddressList();
    _shippingAddressList.addAll(addressResponse.addresses);
    if (_shippingAddressList.length > 0) {
      _seleted_shipping_address = _shippingAddressList[0].id;

      _shippingAddressList.forEach((address) {
        if (address.set_default == 1) {
          _seleted_shipping_address = address.id;
        }
      });
    }
    _faceData = true;
    setState(() {});

    // getSetShippingCost();
  }

  reset() {
    _shippingAddressList.clear();
    _faceData = false;
    _seleted_shipping_address = 0;
  }

  Future<void> _onRefresh() async {
    reset();
    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  afterAddingAnAddress() {
    reset();
    fetchAll();
  }

  onPressProceed(context) async {
    if (_seleted_shipping_address == 0) {
      ToastComponent.showDialog(
          LangText(context).local!.choose_an_address_or_pickup_point,
          gravity: ToastGravity.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }

    late var addressUpdateInCartResponse;

    // if (_seleted_shipping_address != 0 && isLocationAvailable) {
    print(_seleted_shipping_address.toString() + "dddd");
    Loading.show(context);
    addressUpdateInCartResponse = await AddressRepository()
        .getAddressUpdateInCartResponse(address_id: _seleted_shipping_address);
    // } else {
    //   onShowInfoLocation();
    //   return;
    // }
    if (addressUpdateInCartResponse.result == false) {
      Loading.close();
      ToastComponent.showDialog(addressUpdateInCartResponse.message,
          gravity: ToastGravity.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    ToastComponent.showDialog(addressUpdateInCartResponse.message,
        gravity: ToastGravity.CENTER, duration: Toast.LENGTH_LONG);

    Loading.close();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ShippingInfo(
          isLocationAvailable: isLocationAvailable, address: address);
    })).then((value) {
      onPopped(value);
    });
    // } else if (_seleted_shipping_pickup_point != 0) {
    //   print("Selected pickup point ");
    // } else {
    //   print("..........something is wrong...........");
    // }
  }

  onShowInfoLocation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        contentPadding:
            EdgeInsets.only(top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            "Alamat yang Anda pilih belum ada pin lokasi. Silahkan menambahkan pin lokasi terlebih dahulu.",
            maxLines: 3,
            style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
          ),
        ),
        actions: [
          Btn.basic(
            child: Text(
              LangText(context).local.cancel_ucf,
              style: TextStyle(color: MyTheme.medium_grey),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          Btn.basic(
            color: MyTheme.soft_accent_color,
            child: Text(
              "Pin Lokasi",
              style: TextStyle(color: MyTheme.dark_grey),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MapLocation(address: address);
              })).then((value) {
                onPopped(value);
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidth = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: UsefulElements.backButton(context),
          backgroundColor: MyTheme.white,
          title: buildAppbarTitle(context),
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: buildBottomAppBar(context),
        body: buildBody(context),
      ),
    );
  }

  RefreshIndicator buildBody(BuildContext context) {
    return RefreshIndicator(
      color: MyTheme.accent_color,
      backgroundColor: Colors.white,
      onRefresh: _onRefresh,
      displacement: 0,
      child: Container(
        child: buildBodyChildren(context),
      ),
    );
  }

  Widget buildBodyChildren(BuildContext context) {
    return buildShippingListContainer(context);
  }

  Container buildShippingListContainer(BuildContext context) {
    return Container(
      child: CustomScrollView(
        controller: _mainScrollController,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: buildShippingInfoList()),
            buildAddOrEditAddress(context),
            SizedBox(
              height: 100,
            )
          ]))
        ],
      ),
    );
  }

  Widget buildAddOrEditAddress(BuildContext context) {
    return Container(
      height: 40,
      child: Center(
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Address(
                from_shipping_info: true,
              );
            })).then((value) {
              onPopped(value);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              LangText(context)
                  .local!
                  .to_add_or_edit_addresses_go_to_address_page,
              style: TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  color: MyTheme.accent_color),
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        "${LangText(context).local!.shipping_cost_ucf}",
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildShippingInfoList() {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            LangText(context).local!.you_need_to_log_in,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else if (!_faceData && _shippingAddressList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shippingAddressList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _shippingAddressList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: buildShippingInfoItemCard(index),
            );
          },
        ),
      );
    } else if (_faceData && _shippingAddressList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            LangText(context).local!.no_address_is_added,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  GestureDetector buildShippingInfoItemCard(index) {
    return GestureDetector(
      onTap: () {
        if (_seleted_shipping_address != _shippingAddressList[index].id) {
          _seleted_shipping_address = _shippingAddressList[index].id;

          // onAddressSwitch();
        }
        //detectShippingOption();
        setState(() {});
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: _seleted_shipping_address == _shippingAddressList[index].id
              ? BorderSide(color: MyTheme.accent_color, width: 2.0)
              : BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: buildShippingInfoItemChildren(index),
        ),
      ),
    );
  }

  Column buildShippingInfoItemChildren(index) {
    if (_seleted_shipping_address == _shippingAddressList[index].id) {
      isLocationAvailable = _shippingAddressList[index].location_available;
      address = _shippingAddressList[index];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildShippingInfoItemAddress(index),
        buildShippingInfoItemCity(index),
        buildShippingInfoItemState(index),
        buildShippingInfoItemCountry(index),
        buildShippingInfoItemPostalCode(index),
        buildShippingInfoItemPhone(index),
        _shippingAddressList[index].location_available
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  width: 200,
                  child: Text(
                    "Alamat ini belum pin lokasi",
                    maxLines: 2,
                    style: TextStyle(
                        color: MyTheme.brick_red, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
      ],
    );
  }

  Padding buildShippingInfoItemPhone(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              LangText(context).local!.phone_ucf,
              style: TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 200,
            child: Text(
              _shippingAddressList[index].phone,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildShippingInfoItemPostalCode(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              LangText(context).local!.postal_code,
              style: TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 200,
            child: Text(
              _shippingAddressList[index].postal_code,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildShippingInfoItemCountry(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              LangText(context).local!.country_ucf,
              style: TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 200,
            child: Text(
              _shippingAddressList[index].country_name,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildShippingInfoItemState(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              LangText(context).local!.state_ucf,
              style: TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 200,
            child: Text(
              _shippingAddressList[index].state_name,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildShippingInfoItemCity(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              LangText(context).local!.city_ucf,
              style: TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 200,
            child: Text(
              _shippingAddressList[index].city_name,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildShippingInfoItemAddress(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              LangText(context).local!.address_ucf,
              style: TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 175,
            child: Text(
              _shippingAddressList[index].address,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
          Spacer(),
          buildShippingOptionsCheckContainer(
              _seleted_shipping_address == _shippingAddressList[index].id)
        ],
      ),
    );
  }

  Container buildShippingOptionsCheckContainer(bool check) {
    return check
        ? Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), color: Colors.green),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Icon(Icons.check, color: Colors.white, size: 10),
            ),
          )
        : Container();
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        color: Colors.transparent,
        height: 50,
        child: Btn.minWidthFixHeight(
          minWidth: MediaQuery.of(context).size.width,
          height: 50,
          color: MyTheme.accent_color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Text(
            LangText(context).local!.continue_to_delivery_info_ucf,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            onPressProceed(context);
          },
        ),
      ),
    );
  }

  Widget customAppBar(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: MyTheme.white,
              child: Row(
                children: [
                  buildAppbarBackArrow(),
                ],
              ),
            ),
            // container for gaping into title text and title-bottom buttons
            Container(
              padding: EdgeInsets.only(top: 2),
              width: mWidth,
              color: MyTheme.light_grey,
              height: 1,
            ),
            //buildChooseShippingOption(context)
          ],
        ),
      ),
    );
  }

  Container buildAppbarTitle(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: Text(
        "${LangText(context).local.shipping_info}",
        style: TextStyle(
          fontSize: 16,
          color: MyTheme.dark_font_grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container buildAppbarBackArrow() {
    return Container(
      width: 40,
      child: UsefulElements.backButton(context),
    );
  }

/*
  Widget buildChooseShippingOption(BuildContext context) {
    // if(carrier_base_shipping.$){
    if (true) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        width: DeviceInfo(context).width,
        alignment: Alignment.center,
        child: Text(
          "Choose Shipping Area",
          style: TextStyle(
              color: MyTheme.dark_grey,
              fontSize: 14,
              fontWeight: FontWeight.w700),
        ),
      );
    }
    return Visibility(
      visible: pick_up_status.$,
      child: ScrollToHideWidget(
        child: Container(
          color: MyTheme.white,
          //MyTheme.light_grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildAddresOption(context),
              Container(
                width: 0.5,
                height: 30,
                color: MyTheme.grey_153,
              ),
              buildPockUpPointOption(context),
            ],
          ),
        ),
        scrollController: _mainScrollController,
        childHeight: 40,
      ),
    );
  }*/
/*
  FlatButton buildPockUpPointOption(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        setState(() {
          changeShippingOption(false);
        });
      },
      child: Container(
        color: MyTheme.white,
        alignment: Alignment.center,
        height: 50,
        width: (mWidth / 2) - 1,
        child: Text(
          LangText(context).local.pickup_point,
          style: TextStyle(
              color: _shippingOptionIsAddress
                  ? MyTheme.medium_grey_50
                  : MyTheme.dark_grey,
              fontWeight: !_shippingOptionIsAddress
                  ? FontWeight.w700
                  : FontWeight.normal),
        ),
      ),
    );
  }


  FlatButton buildAddresOption(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        setState(() {
          changeShippingOption(true);
        });
      },
      child: Container(
        color: MyTheme.white,
        height: 50,
        width: (mWidth / 2) - 1,
        alignment: Alignment.center,
        child: Text(
          LangText(context).local.address_screen_address,
          style: TextStyle(
              color: _shippingOptionIsAddress
                  ? MyTheme.dark_grey
                  : MyTheme.medium_grey_50,
              fontWeight: _shippingOptionIsAddress
                  ? FontWeight.w700
                  : FontWeight.normal),
        ),
      ),
    );
  }
  */
}
