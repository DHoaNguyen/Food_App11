import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app_panel/const/colors.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:food_app_panel/screen/categoryList.dart';
import 'package:food_app_panel/services/firebase_services.dart';

class AddCategoryScreen extends StatefulWidget {
  static const routeName = "/categoryScreen";
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  // Get a non-default Storage bucket
  // Use a non-default App
  final _formkey = GlobalKey<FormState>();
  final FirebaseServices _services = FirebaseServices();

  final TextEditingController categoryNameController = TextEditingController();
  dynamic image;
  late String fileName;

// Points to "images/space.jpg"
// Note that you can use variables to create child values

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
      categoryNameController.clear();
      image = null;
    });
  }

  saveDataToFireBase() async {
    dynamic categoryId = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('gs://food-app-3d1f6.appspot.com/image/$fileName');
    EasyLoading.show(status: "Đang tải...");
    try {
      await ref.putData(image);
      String downloadURL = await ref.getDownloadURL().then((value) {
        if (value.isNotEmpty) {
          _services.SaveCategory(
                  _services.categories,
                  {
                    'categoryName': categoryNameController.text,
                    'categoryImg': value,
                    'categoryId': categoryId,
                  },
                  categoryId)
              .then((value) {
            EasyLoading.dismiss();
            cleanImg();
          });
        }
        return value;
      });
    } on firebase_storage.FirebaseException catch (e) {
      print(e);
      cleanImg();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white24,
      // appBar: AppBar(
      //   title: const Text('Menu Admin'),
      // ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: '/homeScreen',
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Quản lý Thể loại',
            //   route: '/',
            icon: Icons.file_copy,
          ),
          AdminMenuItem(
            title: 'Quản lý sản phẩm',
            route: '/productScreen',
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
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Text(
                "Thêm danh mục",
                style: TextStyle(color: Colors.blue, fontSize: 30),
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
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: InkWell(
                          onTap: () {
                            pickImg();
                          },
                          child: image == null
                              ? const Center(child: Icon(Icons.file_upload))
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
                          padding: const EdgeInsets.only(top: 80),
                          height: 200,
                          width: 200,
                          child: TextFormField(
                            controller: categoryNameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Nhập tên thể loại";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              // ignore: unnecessary_const
                              label: Text("Nhập tên thể loại"),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            image == null
                                ? Container()
                                : TextButton(
                                    onPressed: () {
                                      if (_formkey.currentState!.validate()) {
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
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
              const Divider(
                thickness: 5,
              ),
              const CategoryList(),
            ],
          ),
        ),
      ),
    );
  }
}
