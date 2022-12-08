import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_app_panel/const/colors.dart';
import 'package:food_app_panel/model/cart_model.dart';
import 'package:food_app_panel/provider/cart_provider.dart';
import 'package:food_app_panel/screen/productList.dart';
import 'package:food_app_panel/services/firebase_services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = "/productScreen";
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final FirebaseServices _services = FirebaseServices();

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionNameController =
      TextEditingController();
  final TextEditingController productDiscountNameController =
      TextEditingController();
  final TextEditingController productOldPriceController =
      TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productRateController = TextEditingController();
  dynamic image;
  late String fileName;
  final _formkey = GlobalKey<FormState>();

  late CategoryModel dropdownValue;

  late QuerySnapshot querySnapshot;

  List<CategoryModel> cartList = [];
  CategoryProvider cartProvider = CategoryProvider();

  bool isLoading = true;

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 1),
      () async {
        await cartProvider.getCartData();
        dropdownValue = cartProvider.cartList[0];
        setState(() {
          isLoading = false;
        });
      },
    );
    super.initState();
  }

  Widget dropDownButton() {
    return DropdownButton<CategoryModel>(
      value: dropdownValue,
      hint: const Text("Chọn thể loại"),
      onChanged: (CategoryModel? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: cartProvider.cartList
          .map<DropdownMenuItem<CategoryModel>>((CategoryModel value) {
        return DropdownMenuItem<CategoryModel>(
          value: value,
          child: Text(value.categoryName),
        );
      }).toList(),
    );
  }

  pickImg() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Chưa chọn ảnh")));
    }
  }

  cleanImg() {
    setState(() {
      productDescriptionNameController.clear();
      productDiscountNameController.clear();
      productNameController.clear();
      productOldPriceController.clear();
      productPriceController.clear();
      productRateController.clear();
      image = null;
    });
  }

  saveDataToFireBase() async {
    dynamic productId = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('gs://food-app-3d1f6.appspot.com/image/$fileName');
    EasyLoading.show(status: "Đang tải...");
    try {
      await ref.putData(image);
      String downloadURL = await ref.getDownloadURL().then((value) {
        if (value.isNotEmpty) {
          _services.SaveCategory(
                  _services.products,
                  {
                    'categoryId': dropdownValue.categoryId,
                    'productName': productNameController.text,
                    'productImg': value,
                    'productOldPrice':
                        int.parse(productOldPriceController.text),
                    'productPrice': int.parse(productPriceController.text),
                    'productDescription': productDescriptionNameController.text,
                    'productRate': double.parse(productRateController.text),
                    'productDiscount':
                        int.parse(productDiscountNameController.text),
                    'productId': productId,
                  },
                  productId)
              .then((value) {
            EasyLoading.dismiss();
            cleanImg();
          });
        }
        return value;
      });
    } on firebase_storage.FirebaseException catch (e) {
      cleanImg();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white24,
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: '/homeScreen',
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Quản lý Thể loại',
            route: '/categoryScreen',
            icon: Icons.file_copy,
          ),
          AdminMenuItem(
            title: 'Quản lý sản phẩm',
            icon: Icons.production_quantity_limits_sharp,
          ),
          AdminMenuItem(
            title: 'Đơn đặt hàng',
            icon: Icons.castle_outlined,
            route: '/orderHistoryScreen',
          ),
        ],
        selectedRoute: '/',
        onSelected: (item) {
          if (item.route != null) {
            Navigator.of(context).pushNamed(item.route!);
          }
        },
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        "Thêm sản phẩm",
                        style: TextStyle(color: Colors.blue, fontSize: 30),
                      ),
                      //
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 40, 0, 0),
                        child: dropDownButton(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                color: AppColor.placeholderBg,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.blue, width: 2),
                              ),
                              child: InkWell(
                                  onTap: () {
                                    pickImg();
                                  },
                                  child: image == null
                                      ? const Center(
                                          child: Icon(
                                          Icons.file_upload,
                                          size: 50,
                                        ))
                                      : Image.memory(
                                          image,
                                          fit: BoxFit.cover,
                                        )),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 5),
                                  height: 80,
                                  width: 250,
                                  child: TextFormField(
                                    controller: productNameController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Nhập tên sản phẩm";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      // ignore: unnecessary_const
                                      label: Text("Nhập tên sản phẩm"),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  //              padding: const EdgeInsets.only(top: 5),
                                  height: 50,
                                  width: 250,
                                  child: TextFormField(
                                    controller:
                                        productDescriptionNameController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Nhập mô tả";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      // ignore: unnecessary_const
                                      label: Text("Nhập Nhập mô tả"),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 5),
                                  height: 50,
                                  width: 250,
                                  child: TextFormField(
                                    controller: productDiscountNameController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return ('Sản phẩm giảm giá chỉ(1 và 0)');
                                      }
                                      if (!RegExp("^[0-1]").hasMatch(value)) {
                                        return ('Sản phẩm giảm giá chỉ(1 và 0)');
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      // ignore: unnecessary_const
                                      label:
                                          Text("Sản phẩm giảm giá chỉ(1 và 0)"),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 5),
                                  height: 50,
                                  width: 250,
                                  child: TextFormField(
                                    controller: productOldPriceController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return ('Vui lòng nhập giá ban đầu(ví dụ 50000)');
                                      }
                                      if (!RegExp("^[0-9]").hasMatch(value)) {
                                        return ('Vui lòng nhập đúng giá chỉ từ 0-9');
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      // ignore: unnecessary_const
                                      label: Text(
                                          "Nhập giá ban đầu (ví dụ 50000)"),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 5),
                                  height: 50,
                                  width: 250,
                                  child: TextFormField(
                                    controller: productPriceController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return ('Vui Lòng giá hiện tại (ví dụ 40000)');
                                      }
                                      if (!RegExp("^[0-9]").hasMatch(value)) {
                                        return ('Vui lòng nhập đúng giá chỉ từ 0-9');
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      // ignore: unnecessary_const
                                      label: Text(
                                          "Nhập giá hiện tại (ví dụ 40000)"),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 5),
                                  height: 50,
                                  width: 250,
                                  child: TextFormField(
                                    controller: productRateController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Nhập lượt đánh giá (ví dụ 4.2)";
                                      }
                                      if (!RegExp("^[0-9]").hasMatch(value)) {
                                        return ('Vui lòng nhập đúng lượt đánh giá');
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      // ignore: unnecessary_const
                                      label: Text(
                                          "Nhập lượt đánh giá (ví dụ 4.2)"),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    image == null
                                        ? Container()
                                        : TextButton(
                                            onPressed: () {
                                              if (_formkey.currentState!
                                                  .validate()) {
                                                saveDataToFireBase();
                                              }
                                            },
                                            // ignore: sort_child_properties_last
                                            child: const Text(
                                              "Lưu",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      AppColor.placeholder),
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      // ignore: sort_child_properties_last
                                      child: const Text(
                                        "Hủy",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColor.placeholder),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const ProductList(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
