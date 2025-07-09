import 'package:active_ecommerce_flutter/other_config.dart';
import 'package:flutter/material.dart';
import 'package:midtrans_snap/midtrans_snap.dart';
import 'package:midtrans_snap/models.dart';

import 'orders/order_list.dart';

class MidtransSnapPage extends StatelessWidget {
  final String snapToken;

  const MidtransSnapPage({
    Key? key,
    required this.snapToken,
  }) : super(key: key);

  Future<bool?> _showBackDialog(context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Perhatian'),
          content:
              const Text('Apakah Anda yakin akan menutup halaman pembayaran?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('Ya'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return OrderList(from_checkout: true);
                }));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showBackDialog(context) ?? false;
        if (context.mounted && shouldPop) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OrderList(from_checkout: true);
          }));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Pembayaran')),
        body: MidtransSnap(
          token: snapToken,
          midtransClientKey: OtherConfig.MIDTRANS_CLIENT_KEY_Production,
          mode: MidtransEnvironment.production,
          // Gunakan `production` jika sudah live
          onPageFinished: (url) {
            print("Halaman selesai dimuat: $url");
          },
          onResponse: (result) {
            print("Hasil transaksi: ${result.toJson()}");
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OrderList(from_checkout: true);
            }));
          },
        ),
      ),
    );
  }
}
