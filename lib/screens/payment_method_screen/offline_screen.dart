import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/enum_classes.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/helpers/file_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/customer_package_repository.dart';
import 'package:active_ecommerce_flutter/repositories/file_repository.dart';
import 'package:active_ecommerce_flutter/repositories/offline_payment_repository.dart';
import 'package:active_ecommerce_flutter/repositories/offline_wallet_recharge_repository.dart';
import 'package:active_ecommerce_flutter/screens/orders/order_details.dart';
import 'package:active_ecommerce_flutter/screens/package/packages.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:active_ecommerce_flutter/ui_elements/html_content_webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OfflineScreen extends StatefulWidget {
  int? order_id;
  String? paymentInstruction;
  String? paymentMethod;

  PaymentFor? offLinePaymentFor;
  int? offline_payment_id;
  final double? rechargeAmount;
  var packageId;

  OfflineScreen(
      {Key? key,
      this.order_id,
      this.paymentInstruction,
      this.offLinePaymentFor,
      this.offline_payment_id,
      this.packageId = "0",
      this.paymentMethod,
      this.rechargeAmount})
      : super(key: key);

  @override
  _OfflineState createState() => _OfflineState();
}

class _OfflineState extends State<OfflineScreen> {
  ScrollController _mainScrollController = ScrollController();

  TextEditingController _amountController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _trxIdController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _photo_file;
  String? _photo_path = "";
  int? _photo_upload_id = 0;
  late BuildContext loadingcontext;

  Future<void> _onPageRefresh() async {
    reset();
  }

  reset() {
    _amountController.clear();
    _nameController.clear();
    _trxIdController.clear();
    _photo_path = "";
    _photo_upload_id = 0;
    setState(() {});
  }

  onPressSubmit() async {
    var amount = _amountController.text.toString();
    var name = _nameController.text.toString();
    var trx_id = _trxIdController.text.toString();

    if (amount == "" || name == "" || trx_id == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!
              .amount_name_and_transaction_id_are_necessary,
          gravity: ToastGravity.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }

    if (_photo_path == "" || _photo_upload_id == 0) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.photo_proof_is_necessary,
          gravity: ToastGravity.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }
    loading();
    if (widget.offLinePaymentFor == PaymentFor.WalletRecharge) {
      var submitResponse = await OfflineWalletRechargeRepository()
          .getOfflineWalletRechargeResponse(
        amount: amount,
        name: name,
        trx_id: trx_id,
        photo: _photo_upload_id,
      );
      Navigator.pop(loadingcontext);
      if (submitResponse.result == false) {
        ToastComponent.showDialog(submitResponse.message,
            gravity: ToastGravity.CENTER, duration: Toast.LENGTH_LONG);
      } else {
        ToastComponent.showDialog(submitResponse.message,
            gravity: ToastGravity.CENTER, duration: Toast.LENGTH_LONG);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Wallet(from_recharge: true);
        }));
      }
    } else if (widget.offLinePaymentFor == PaymentFor.ManualPayment) {
      var submitResponse = await OfflinePaymentRepository()
          .getOfflinePaymentSubmitResponse(
              order_id: widget.order_id,
              amount: amount,
              name: name,
              trx_id: trx_id,
              photo: _photo_upload_id);
      Navigator.pop(loadingcontext);
      if (submitResponse.result == false) {
        ToastComponent.showDialog(submitResponse.message,
            gravity: ToastGravity.CENTER, duration: Toast.LENGTH_LONG);
      } else {
        ToastComponent.showDialog(submitResponse.message,
            gravity: ToastGravity.CENTER, duration: Toast.LENGTH_LONG);

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OrderDetails(id: widget.order_id, go_back: false);
        }));
      }
    } else if (widget.offLinePaymentFor == PaymentFor.PackagePay) {
      var submitResponse = await CustomerPackageRepository()
          .offlinePackagePayment(
              packageId: widget.packageId,
              method: widget.paymentMethod,
              trx_id: trx_id,
              photo: _photo_upload_id);
      Navigator.pop(loadingcontext);
      if (submitResponse.result == false) {
        ToastComponent.showDialog(submitResponse.message,
            gravity: ToastGravity.CENTER, duration: Toast.LENGTH_LONG);
      } else {
        ToastComponent.showDialog(submitResponse.message,
            gravity: ToastGravity.CENTER, duration: Toast.LENGTH_LONG);

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return UpdatePackage(goHome: true);
        }));
      }
    }
  }

  onPickPhoto(context) async {
    _photo_file = await _picker.pickImage(source: ImageSource.gallery);

    if (_photo_file == null) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.no_file_is_chosen,
          gravity: ToastGravity.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    //return;
    String base64Image = FileHelper.getBase64FormateFile(_photo_file!.path);
    String fileName = _photo_file!.path.split("/").last;

    var imageUpdateResponse =
        await FileRepository().getSimpleImageUploadResponse(
      base64Image,
      fileName,
    );

    if (imageUpdateResponse.result == false) {
      print(imageUpdateResponse.message);
      ToastComponent.showDialog(imageUpdateResponse.message,
          gravity: ToastGravity.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else {
      ToastComponent.showDialog(imageUpdateResponse.message,
          gravity: ToastGravity.CENTER, duration: Toast.LENGTH_LONG);

      _photo_path = imageUpdateResponse.path;
      _photo_upload_id = imageUpdateResponse.upload_id;
      setState(() {});
    }
  }

  @override
  void initState() {
    _amountController.text = widget.rechargeAmount.toString();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildBody(context),
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
        AppLocalizations.of(context)!.make_offline_payment_ucf,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildBody(context) {
    if (is_logged_in == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.you_need_to_log_in,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        onRefresh: _onPageRefresh,
        displacement: 10,
        child: CustomScrollView(
          controller: _mainScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HtmlContentWebView(
                    html: widget.paymentInstruction ?? """<p>Heading</p>""",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    height: 24,
                  ),
                ),
                buildProfileForm(context)
              ]),
            )
          ],
        ),
      );
    }
  }

  Widget buildProfileForm(context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                AppLocalizations.of(context)!.all_marked_fields_are_mandatory,
                style: TextStyle(
                    color: MyTheme.grey_153,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                AppLocalizations.of(context)!
                    .correctly_fill_up_the_necessary_information,
                style: TextStyle(color: MyTheme.grey_153, fontSize: 14.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                "${AppLocalizations.of(context)!.amount_ucf}*",
                style: TextStyle(
                    color: MyTheme.accent_color, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                height: 36,
                child: TextField(
                  controller: _amountController,
                  autofocus: false,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: "12,000 or Tweleve Thousand Only"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                "${AppLocalizations.of(context)!.name_ucf}*",
                style: TextStyle(
                    color: MyTheme.accent_color, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                height: 36,
                child: TextField(
                  controller: _nameController,
                  autofocus: false,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: "John Doe"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                "${AppLocalizations.of(context)!.transaction_id_ucf}*",
                style: TextStyle(
                    color: MyTheme.accent_color, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                height: 36,
                child: TextField(
                  controller: _trxIdController,
                  autofocus: false,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: "BNI-4654321354"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                "${AppLocalizations.of(context)!.photo_proof_ucf}* (${AppLocalizations.of(context)!.only_image_file_allowed})",
                style: TextStyle(
                    color: MyTheme.accent_color, fontWeight: FontWeight.w600),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    width: 180,
                    height: 36,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: MyTheme.textfield_grey, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0))),
                    child: Btn.basic(
                      minWidth: MediaQuery.of(context).size.width,
                      color: MyTheme.medium_grey,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0))),
                      child: Text(
                        AppLocalizations.of(context)!.photo_proof_ucf,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        onPickPhoto(context);
                      },
                    ),
                  ),
                ),
                _photo_path != ""
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(AppLocalizations.of(context)!.selected_ucf),
                      )
                    : Container()
              ],
            ),
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    width: 120,
                    height: 36,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: MyTheme.textfield_grey, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0))),
                    child: Btn.basic(
                      minWidth: MediaQuery.of(context).size.width,
                      color: MyTheme.accent_color,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0))),
                      child: Text(
                        AppLocalizations.of(context)!.submit_ucf + "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        onPressSubmit();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingcontext = context;
          return AlertDialog(
              content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text("${AppLocalizations.of(context)!.please_wait_ucf}"),
            ],
          ));
        });
  }
}
