import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/screens/myOrderScreen.dart';
import 'package:monkey_app_demo/utils/helper.dart';
import 'package:monkey_app_demo/widgets/searchBar.dart';

class VoucherScreen extends StatefulWidget {
  static const routeName = "/voucherScreen";
  const VoucherScreen({Key key}) : super(key: key);

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.placeholderBg,
      body: Stack(
        children: [
          SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppColor.primary,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            "Nhập mã giảm giá",
                            style: Helper.getTheme(context).headline5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SearchBar(title: "Nhập mã giảm giá"),
              SizedBox(
                height: 200,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("voucher")
                        .snapshots(),
                    builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) => VoucherItem(
                              ontap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MyOrderScreen(
                                    isDiscount: true,
                                    discount: snapshot.data.docs[index]
                                        ["discountPrice"],
                                  ),
                                ));
                              },
                              voucherName: snapshot.data.docs[index]
                                  ["discountName"]),
                          itemCount: snapshot.data.docs.length);
                    })),
              ),
            ],
          ))
        ],
      ),
    );
  }
}

class VoucherItem extends StatelessWidget {
  const VoucherItem(
      {Key key, @required Function ontap, @required String voucherName})
      : _ontap = ontap,
        _voucherName = voucherName,
        super(key: key);

  final Function _ontap;
  final String _voucherName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _ontap,
      child: Container(
        width: double.infinity,
        height: 60,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Text(
              " Mã",
              style: Helper.getTheme(context).headline3,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
                child: Text(
              "$_voucherName",
              style: TextStyle(color: AppColor.orange, fontSize: 18),
            )),
            Text(
              "Áp dụng",
              style: TextStyle(
                  fontSize: 18,
                  color: AppColor.orange,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
