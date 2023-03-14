// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_print
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:id_card/photo_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:permission_handler/permission_handler.dart';

class ClickPic extends StatefulWidget {
  const ClickPic({super.key});

  @override
  State<ClickPic> createState() => _ClickPicState();
}

class _ClickPicState extends State<ClickPic> {
  String imagepath = "";
  bool showBtn = false;
  File? imageFile;
  int serialNo = 0;
  bool isInit = true;
  bool isPageLoading = false;
  bool isValidSerial = false;
  bool isSerialChangedByUser = false;
  TextEditingController serialText = TextEditingController();
  SeriesModel? currentSeries; // SeriesModel(startSeries: 0, endSeries: 0);

  late GetStorage _box;
  PhotoDataModel photoDataModel = PhotoDataModel(
      lastSerialNo: 0, photoCount: 0, serialSeriesStart: 0, seriesList: []);

  @override
  void initState() {
    _box = GetStorage();
    getLastSessionData();
    super.initState();
  }

  getLastSessionData() async {
    isPageLoading = true;
    if (_box.hasData('photoData')) {
      photoDataModel = PhotoDataModel.fromJson(await _box.read('photoData'));
      print(photoDataModel.serialSeriesStart);
      serialNo = photoDataModel.lastSerialNo ?? 0;
      // photoCount = photoDataModel.photoCount ?? 0;
      int? index;
      int count = 0;
      photoDataModel.seriesList != null
          ? print(
              "Size------------------------${photoDataModel.seriesList!.length}")
          : print("----------------null");
      if (photoDataModel.seriesList != null &&
          photoDataModel.seriesList!.isNotEmpty) {
        for (var element in photoDataModel.seriesList!) {
          print(element.startSeries.toString() + element.endSeries.toString());
          if (element.startSeries == photoDataModel.serialSeriesStart) {
            index = count;
            break;
          }
          count = count + 1;
        }
        if (index != null) {
          SeriesModel ctempSeries = photoDataModel.seriesList![index];
          serialNo =
              isInit ? ctempSeries.endSeries! + 1 : ctempSeries.endSeries!;
          serialText.text =
              isInit ? (serialNo).toString() : (serialNo + 1).toString();
          isInit = false;
          currentSeries = ctempSeries;
          print(serialNo);
          showBtn = true;
        }
      } else {}
      setState(() {
        isPageLoading = false;
      });
    } else {
      photoDataModel.seriesList != null
          ? print(
              "Size------------------------${photoDataModel.seriesList!.length}")
          : print("----------------null");
      isInit = false;
    }

    isPageLoading = false;
  }

  savePhotoGallery() async {
    isValidSerial = checkSerialValidation(serialNo);
    print(isValidSerial);
    print(isSerialChangedByUser);
    if (imageFile == null || imageFile!.path.isEmpty) {
      Get.snackbar("Image Not Picked", "Please Pick Image");
      return "not valid";
    }
    if (isValidSerial && imageFile != null && imageFile!.path.isNotEmpty) {
      if (isSerialChangedByUser) {
        createNewSeries(serialNo);
        imageFile = await changeFileNameOnly(
            File(imageFile!.path), "${serialNo.toString()}.jpg");
        imagepath = imageFile!.path;
        print(imagepath);
      } else {
        print(serialNo);
        imageFile = await changeFileNameOnly(
            File(imageFile!.path), "${serialNo.toString()}.jpg");
        imagepath = imageFile!.path;
        print(imagepath);
      }

      await GallerySaver.saveImage(imagepath,
          albumName: 'ID Card', toDcim: false);
      // photoCount =
      //     photoDataModel.lastSerialNo! - photoDataModel.serialSeriesStart!;
      // photoDataModel.photoCount = photoCount;
      photoDataModel.lastSerialNo = serialNo;
      int? index;
      int count = 0;
      if (photoDataModel.seriesList != null &&
          photoDataModel.seriesList!.isNotEmpty) {
        for (var element in photoDataModel.seriesList!) {
          if (element.startSeries == photoDataModel.serialSeriesStart) {
            index = count;
            break;
          }
          count = count + 1;
        }
        if (index != null && currentSeries != null) {
          currentSeries = photoDataModel.seriesList![index];
          photoDataModel.seriesList![index] = SeriesModel(
              startSeries: currentSeries!.startSeries, endSeries: serialNo);
          currentSeries = photoDataModel.seriesList![index];
        } else {
          createNewSeries(serialNo);
        }
      }
      await _box.write('photoData', photoDataModel.toJson());
      await getLastSessionData();
      serialNo = serialNo + 1;
      setState(() {
        isValidSerial = false;
        // imagepath = "";
        imageFile = null;
      });
    } else {
      Get.snackbar("Invalid Serial No", "Serial no exists");
    }
  }

  bool checkSerialValidation(serialNO) {
    List<SeriesModel> series = photoDataModel.seriesList ?? [];
    for (var element in series) {
      if (serialNO == element.startSeries) {
        return false;
      } else if (serialNO == element.startSeries) {
        return false;
      } else if (element.startSeries! < serialNO &&
          element.endSeries! > serialNO) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isPageLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: Get.height,
              color: const Color(0xfffff9eb),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: Get.height * .3,
                      decoration: const BoxDecoration(
                        color: Color(0xfff9be7c),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 40, bottom: 8, left: 8, right: 8),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              backgroundColor: Color(0xffeb6775),
                              radius: 40,
                              child: CircleAvatar(
                                radius: 39,
                                backgroundImage:
                                    AssetImage('asset/image/school.webp'),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "ID Card Application",
                                  style: TextStyle(
                                      fontSize: 20,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "lato",
                                      color: Color.fromARGB(255, 10, 39, 103)),
                                ),
                                Text(
                                  "App Developer",
                                  style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 0.5,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        "App Summary",
                        style: TextStyle(
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: "lato",
                            fontSize: 25,
                            color: Color(0xFF15222b)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      height: Get.height * .08,
                      // color: Colors.amber,
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(0xffeb6775),
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Picture Count",
                                style: TextStyle(
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "lato",
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 10, 39, 103)),
                              ),
                              Text(
                                "Total : ${currentSeries != null ? ((currentSeries!.endSeries! - currentSeries!.startSeries!) + 1) : ""}",
                                style: const TextStyle(
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "lato",
                                    fontSize: 14,
                                    color: Color(0xFF15222b)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      height: Get.height * .08,
                      // color: Colors.amber,
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(0xfff9bd81),
                            child: Icon(
                              Icons.pin_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Last Serial No ",
                                style: TextStyle(
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "lato",
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 10, 39, 103)),
                              ),
                              Text(
                                "Serial no : ${currentSeries != null ? currentSeries!.endSeries : ""}",
                                style: const TextStyle(
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "lato",
                                    fontSize: 14,
                                    color: Color(0xFF15222b)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      height: Get.height * .088,
                      // color: Colors.amber,
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(0xff628ae1),
                            child: Icon(
                              Icons.folder_open_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Storage Path",
                                style: TextStyle(
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "lato",
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 10, 39, 103)),
                              ),
                              Expanded(
                                child: SizedBox(
                                  width: Get.width * .7,
                                  child: Text(
                                    imagepath.isNotEmpty
                                        ? "Path : $imagepath "
                                        : "Path : ",
                                    style: const TextStyle(
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "lato",
                                        fontSize: 14,
                                        color: Color(0xFF15222b)),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 20),
                      child: Text(
                        "Enter Serial No",
                        style: TextStyle(
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: "lato",
                            fontSize: 25,
                            color: Color(0xFF15222b)),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 20, right: 10),
                            child: TextFormField(
                              cursorColor: Colors.red,
                              controller: serialText,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(8)
                              ],
                              // inputFormatters: [
                              //   LengthLimitingTextInputFormatter(10),
                              // ],
                              onChanged: (v) {
                                if (int.tryParse(v) != null && v.isNotEmpty) {
                                  serialNo = int.tryParse(v)!;
                                  print("change $v");
                                  isSerialChangedByUser = true;
                                  showBtn = true;
                                  setState(() {});
                                }
                              },
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'lato',
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 15),
                                hintText: "Enter Here...",
                                hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 10, 39, 103)),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: const BorderSide(
                                      width: 1.5,
                                      color: Color.fromARGB(255, 98, 109, 108)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: const BorderSide(
                                      width: 1.5,
                                      color: Color.fromARGB(255, 98, 109, 108)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            getImage(camera: ImageSource.camera);
                            // await Future.delayed(
                            // const Duration(seconds: 3), () {});
                            // Future.delayed(const Duration(seconds: 3), () {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Container(
                                height: Get.height * .058,
                                width: Get.width * .14,
                                // width: 50,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage("asset/image/camera.png"),
                                  fit: BoxFit.fill,
                                ))),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 22, top: 3),
                      child: Text(
                        "Enter Serial Number",
                        style: TextStyle(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // if (imageFile != null)
                    //   Center(
                    //     child: Container(
                    //       width: 150,
                    //       height: 200,
                    //       alignment: Alignment.center,
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         border: Border.all(color: Colors.black38),
                    //         borderRadius: BorderRadius.circular(3),
                    //         image:
                    //             DecorationImage(image: FileImage(imageFile!)),
                    //         // border: Border.all(width: 2, color: Colors.black12),
                    //         // borderRadius: BorderRadius.circular(12.0),
                    //       ),
                    //     ),
                    //   )
                    // else
                    //   Center(
                    //     child: Container(
                    //       width: 1,
                    //       height: 1,
                    //       alignment: Alignment.center,
                    //       decoration: const BoxDecoration(
                    //         color: Colors.white,
                    //         // image: DecorationImage(image: FileImage(imageFile!)),
                    //         // border: Border.all(width: 2, color: Colors.black12),
                    //         // borderRadius: BorderRadius.circular(12.0),
                    //       ),
                    //     ),
                    //   ),
                    const SizedBox(
                      height: 15,
                    ),
                    // (showBtn == true)
                    //     ? Center(
                    //         child: ElevatedButton(
                    //           style: ElevatedButton.styleFrom(
                    //             padding: const EdgeInsets.only(
                    //                 top: 7, bottom: 7, right: 25, left: 25),
                    //             backgroundColor: const Color(0xfff9be7c),
                    //             // side: BorderSide(color: Colors.yellow, width: 5),
                    //             textStyle: const TextStyle(
                    //                 color: Colors.white,
                    //                 fontSize: 25,
                    //                 fontStyle: FontStyle.normal),
                    //             shape: const BeveledRectangleBorder(
                    //                 borderRadius:
                    //                     BorderRadius.all(Radius.circular(5))),
                    //             shadowColor: Colors.lightBlue,
                    //           ),
                    //           onPressed: () async {
                    //             await savePhotoGallery();
                    //           },
                    //           child: const Text('Save'),
                    //         ),
                    //       )
                    // :
                    // const Center(child: Text("Enter Serial Number")),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void getImage({required ImageSource camera}) async {
    final file = await ImagePicker().pickImage(
        source: camera,
        maxHeight: 2400,
        maxWidth: 1200,
        requestFullMetadata: false);

    if (file != null) {
      imagepath = file.path;
      print(imagepath);
    } else {
      print("No image Selected");
    }
    if (file?.path != null) {
      imageFile = File(file!.path);
      imagepath = imageFile!.path;
      serialNo;
      setState(() {});
      getImage(camera: ImageSource.camera);
      // Get.snackbar("Serial no : ${serialText.text.toString()}", "",
      //     snackPosition: SnackPosition.BOTTOM);
      Fluttertoast.showToast(
          msg: "Serial no :  ${serialText.text.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0);
      savePhotoGallery();
      await Future.delayed(const Duration(seconds: 3), () {
        const ClickPic();
      });
    }
  }

  createNewSeries(serialNO) async {
    photoDataModel.serialSeriesStart = serialNo;
    SeriesModel newSeries =
        SeriesModel(startSeries: serialNo, endSeries: serialNo);
    if (photoDataModel.seriesList == null ||
        photoDataModel.seriesList!.isEmpty) {
      photoDataModel.seriesList = [newSeries];
    } else {
      photoDataModel.seriesList!.add(newSeries);
    }
    isSerialChangedByUser = false;
    photoDataModel.photoCount = 0;
    photoDataModel.lastSerialNo = serialNo;
    photoDataModel.serialSeriesStart = serialNo;
    await _box.write('photoData', photoDataModel.toJson());
//     photoDataModel = PhotoDataModel.fromJson(await _box.read('photoData'));
// //    photoCount = photoDataModel.photoCount ?? 0;
//     currentSeries = SeriesModel(
//         startSeries: photoDataModel.serialSeriesStart,
//         endSeries:  photoDataModel.serialSeriesStart);
    // setState(() {});
    getLastSessionData();
  }
}

Future<File> changeFileNameOnly(File file, String newFileName) {
  var path = file.path;
  var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
  var newPath = path.substring(0, lastSeparator + 1) + newFileName;
  return file.rename(newPath);
}
