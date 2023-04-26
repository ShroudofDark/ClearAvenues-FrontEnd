import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:clear_avenues/providers.dart';
import 'package:clear_avenues/utility/utility.dart';
import 'package:clear_avenues/widgets/my_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

ImagePicker picker = ImagePicker();
TextEditingController description = TextEditingController();

/// Hacky way to get image list to update by changing this value and having the image
/// list built inside a value listen builder. Not 100% if the reason this is working is due
/// to it actually being rebuilt upon an update or if its because the async function is being
/// funky. If image has weird issues loading, then this is why.
final cheatUpdate = ValueNotifier<int>(0);

//Dismiss dialogue box help

class ReportScreen extends ConsumerStatefulWidget {
  final LatLng coordinates;

  const ReportScreen({Key? key, required this.coordinates}) : super(key: key);

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class UnsafeCondition {
  const UnsafeCondition(this.displayName, this.name, this.img);
  final String displayName;
  final String name;
  final Image img;
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  //Allows for Images and Other Customization
  List<UnsafeCondition> conditions = [
    UnsafeCondition("Animal Carcass", "dead_animal",
        Image.asset("assets/images/roadkill.png")),
    UnsafeCondition("Animal Crossing Road", "animal_crossing",
        Image.asset("assets/images/animal_crossing.png")),
    UnsafeCondition("Blind Turn", "blind_turn",
        Image.asset("assets/images/blind.png")),
    UnsafeCondition("Damaged Sign", "damaged_sign",
        Image.asset("assets/images/damage_sign.png")),
    UnsafeCondition("Debris", "debris",
        Image.asset("assets/images/icon.png")),
    UnsafeCondition("Fallen Tree", "fallen_tree",
        Image.asset("assets/images/Fallen_tree.png")),
    UnsafeCondition("Flooding", "flooding",
        Image.asset("assets/images/icon.png")),
    UnsafeCondition("Fog", "fog",
        Image.asset("assets/images/icon.png")),
    UnsafeCondition("Hail", "hail",
        Image.asset("assets/images/icon.png")),
    UnsafeCondition("Ice", "ice",
        Image.asset("assets/images/icy.png")),
    UnsafeCondition("Leaves", "leaves",
        Image.asset("assets/images/icon.png")),
    UnsafeCondition("Missing Sign", "missing_signage",
        Image.asset("assets/images/missing_sign.png")),
    UnsafeCondition("Pothole", "pothole",
        Image.asset("assets/images/Pothole.png")),
    UnsafeCondition("Obfuscation - Rain", "blinding_rain",
        Image.asset("assets/images/icon.png")),
    UnsafeCondition("Obfuscation - Sun", "blinding_sun",
        Image.asset("assets/images/sunny.png")),
    UnsafeCondition("Obstructed Sign", "obstructed_sign",
        Image.asset("assets/images/icon.png")),
    UnsafeCondition("Obstructed Sign - Building", "sign_blocked_building",
        Image.asset("assets/images/icon.png")),
    UnsafeCondition("Obstructed Sign - Foliage", "sign_blocked_foliage",
        Image.asset("assets/images/sign_blocked_by_foliage.png")),
    UnsafeCondition("Obstructed Sign - Different Sign", "sign_blocked_sign",
        Image.asset("assets/images/icon.png")),
    UnsafeCondition("Obstructed Sign - Vehicle", "sign_blocked_vehicle",
        Image.asset("assets/images/icon.png")),
    UnsafeCondition("Overgrowth", "overgrowth",
        Image.asset("assets/images/overgrowth.png")),
    UnsafeCondition("Snorlax in Road", "snorlax",
        Image.asset("assets/images/sleeping_snorlax.png")),
    UnsafeCondition("Spilled Material", "spill_material",
        Image.asset("assets/images/icon.png")),
    UnsafeCondition("Unplowed Road", "unplowed_road",
        Image.asset("assets/images/icon.png")),
    UnsafeCondition("Vehicle Accident", "vehicle_accident",
        Image.asset("assets/images/icon.png")),
    UnsafeCondition("Other", "other",
        Image.asset("assets/images/icon.png")),
  ];

  List<XFile> imageFileList = []; //For multi-images + gallery
  UnsafeCondition? selectedCondition;
  String? postalCode;
  //Function that converts longitude and latitude to readable address
  //Function modified from:
  // https://medium.com/@fernnandoptr/how-to-get-users-current-location-address-in-flutter-geolocator-geocoding-be563ad6f66a
  Future<String> _getAddressFromCoords(LatLng coords) async {
    String address = "";
    await placemarkFromCoordinates(coords.latitude, coords.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      postalCode = place.postalCode;
      address =
          '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}';
    });
    return address;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final coords = widget.coordinates;
    return MyScaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Stack(
              children: [
                SizedBox(
                  height: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 3.0, color: Colors.green),
                    ),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: coords, zoom: 20.0, tilt: 0, bearing: 0),
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,

                      //disables movement of map
                      zoomGesturesEnabled: false,
                      scrollGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      rotateGesturesEnabled: false,

                      markers: {
                        Marker(
                          markerId: const MarkerId("location"),
                          draggable: false,
                          position: coords,
                          infoWindow:
                              const InfoWindow(title: "location of issue"),
                        ),
                      },
                      onMapCreated: (GoogleMapController controller) {
                        controller
                            .showMarkerInfoWindow(const MarkerId("location"));
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: 3.0),
                    color: Colors.white,
                  ),
                  child: FutureBuilder(
                      future: _getAddressFromCoords(coords),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data as String,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
                ),
              ],
            ),

            /* New dropdown button for unsafe condition types.
             * Allows for images to act as icons to work alongside the text.
             */
            DropdownButton(
              //Decorations
              hint: const Text("Choose Unsafe Condition"),
              isExpanded: true,
              itemHeight: 125, //Changes internal height of box
              menuMaxHeight: MediaQuery.of(context).size.height * 0.75,
              iconSize: 48, //Adjust dropdown arrow size
              borderRadius: BorderRadius.circular(10),
              //Wrapped in Container to allow for background coloring
              icon: Container(
                color: Colors.green[500],
                //The padding size is different here, but matches up size wise with the item
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
              ),
              elevation: 16,
              focusColor: Colors.cyan,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              //Removes the underline from dropdown
              underline: Container(
                height: 0,
              ),

              //Value Info
              value: selectedCondition,
              onChanged: (value) {
                setState(() {
                  selectedCondition = value!;
                });
              },

              items: conditions.map((UnsafeCondition condition) {
                return DropdownMenuItem(
                  value: condition,
                  child: Container(
                    //Highlights already selected value
                    color: selectedCondition == condition
                        ? Colors.green[400]
                        : null,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        condition.img,
                        const SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          child: Text(
                            condition.displayName,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(width: 4.0, color: Colors.cyan)),
              ),
              child: TextField(
                controller: description,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                decoration:
                    const InputDecoration(labelText: "Enter Description"),
                maxLines: 5,
              ),
            ),
            //Upload image box
            ElevatedButton(
              onPressed: () => _onPressUpload(context, imageFileList),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.camera_alt,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Upload Image(s)'),
                ],
              ),
            ),
            //Image display
            ValueListenableBuilder(
                valueListenable: cheatUpdate,
                builder: (context, value, widget) {
                  if (imageFileList.isNotEmpty) {
                    return SizedBox(
                        height: 150,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imageFileList.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 150,
                                //Row here in order to add a more controlled version of spacing between the images
                                child: Row(
                                  children: [
                                    Image.file(File(imageFileList[index].path)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              );
                            }));
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Images Are Optional",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                }),
            ElevatedButton(
              onPressed: () => _onPressSubmit(imageFileList, selectedCondition),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  //Submit the information of the report and leave the report screen
  void _onPressSubmit(
      List<XFile> imageFileList, UnsafeCondition? selectedCondition) async {
    if (selectedCondition == null) {
      showMySnackbar(context, "Please Select Unsafe Condition Type");
    } else {
      bool success = await ref.read(userProvider.notifier).submitReport(
          selectedCondition.name,
          description.text,
          widget.coordinates.latitude.toString(),
          widget.coordinates.longitude.toString(),
          postalCode!);
      if (success && context.mounted) {
        showMySnackbar(context, "Submission successful.");
      } else if (context.mounted) {
        showMySnackbar(context, "Submission error.");
      }
    }

    //Unless there is change in back end, only first image in list will be submitted.
    //Kept it this way to show that the code is there to future proof it.

    List<String> encodedImages = [];
    if (imageFileList.isNotEmpty) {
      for (var image in imageFileList) {
        Uint8List bytes = await image.readAsBytes();
        String convertedImage = base64Encode(bytes);
        encodedImages.add(convertedImage);
      }
    }

    cheatUpdate.value = 0;

    if (context.mounted) {
      context.pop();
    }
  }

  //Get an image from the gallery, can be multiple
  void selectImagesGallery(List<XFile> imageFileList) async {
    final List<XFile> selectedImages = await picker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    cheatUpdate.value++;
    if (context.mounted) context.pop();
  }

//Get an image from the camera
  void selectImagesCamera(List<XFile> imageFileList) async {
    final XFile? selectedImage =
        await picker.pickImage(source: ImageSource.camera);
    if (selectedImage != null) {
      imageFileList.add(selectedImage);
    }
    cheatUpdate.value++;
    if (context.mounted) context.pop();
  }

  void _onPressUpload(BuildContext context, List<XFile> imageFileList) {
    //Set context to pop whenever needed

    Widget cameraButton = TextButton(
      onPressed: () => selectImagesCamera(imageFileList),
      child: const Text("Camera"),
    );
    Widget galleryButton = TextButton(
      onPressed: () => selectImagesGallery(imageFileList),
      child: const Text("Gallery"),
    );
    Widget cancelButton = TextButton(
      onPressed: () {
        context.pop();
      },
      child: const Text("Close"),
    );

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Choose"),
              content: const Text("How would you like to upload an image?"),
              actions: [
                cameraButton,
                galleryButton,
                cancelButton,
              ],
            ));
  }
}
