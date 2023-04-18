import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:clear_avenues/widgets/my_scaffold.dart';
import 'package:clear_avenues/utility/http_assist.dart';
import 'package:clear_avenues/constants.dart';
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
BuildContext? dcontext;

class ReportScreen extends StatefulWidget {
  final LatLng coordinates;

  const ReportScreen({Key? key, this.coordinates = const LatLng(0, 0)})
      : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class UnsafeCondition {
  const UnsafeCondition(this.displayName, this.name, this.img);
  final String displayName;
  final String name;
  final Image img;
}

class _ReportScreenState extends State<ReportScreen> {
  bool isDriving = false;

  //Allows for Images and Other Customization
  List<UnsafeCondition> conditions = [
    UnsafeCondition("Debris", "debris",
        Image.asset("assets/images/Debris64.png")),
    UnsafeCondition("Flooding", "flooding",
        Image.asset("assets/images/TrafficCone64.png")),
    UnsafeCondition("Missing Sign", "missing_signage",
        Image.asset("assets/images/MissingSign64.png")),
    UnsafeCondition("Pothole", "pothole",
        Image.asset("assets/images/Pothole64.png")),
    UnsafeCondition("Obstructed Sign", "obstructed_sign",
        Image.asset("assets/images/ObstructedSign64.png")),
    UnsafeCondition("Vehicular Related", "vehicle_accident",
        Image.asset("assets/images/TrafficCone64.png")),
    UnsafeCondition("Other", "other",
        Image.asset("assets/images/TrafficCone64.png")),
  ];

  List<XFile> imageFileList = []; //For multi-images + gallery
  UnsafeCondition? selectedCondition;
  String? _address;

  //Function that converts longitude and latitude to readable address
  //Function modified from:
  // https://medium.com/@fernnandoptr/how-to-get-users-current-location-address-in-flutter-geolocator-geocoding-be563ad6f66a
  Future<void> _getAddressFromCoords() async {
    await placemarkFromCoordinates(
            widget.coordinates.latitude, widget.coordinates.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _address =
            '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}';
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getAddressFromCoords(); //Set Display Text when screen starts
  }

  @override
  Widget build(BuildContext context) {
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
                          target: widget.coordinates,
                          zoom: 20.0,
                          tilt: 0,
                          bearing: 0),
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
                          position: widget.coordinates,
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
                  child: Text(
                    "$_address",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                        Text(
                          condition.displayName,
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
              onPressed: () =>
                  _onPressSubmit(context, imageFileList, selectedCondition),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------
//                                FUNCTIONS
// -----------------------------------------------------------------------

dismissDialog() {
  if (dcontext != null) {
    Navigator.of(dcontext!).pop();
  }
}

//Asks user where they want to grab a photo from and calls methods to fetch those photos
void _onPressUpload(BuildContext context, List<XFile> imageFileList) {
  //Set context to pop whenever needed
  dcontext = context;

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
      dismissDialog();
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

//Submit the information of the report and leave the report screen
void _onPressSubmit(BuildContext context, List<XFile> imageFileList,
    UnsafeCondition? selectedCondition) async {
  if (selectedCondition == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please Select Unsafe Condition Type",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
    return;
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

  //TODO Implement this with proper URL
  // Below in the parameters when the code is provided they can be access as such:
  // widget.coordinates.latitude, widget.coordinates.longitude for coordinate submission
  // encodedImages[0] for first image as a string, if not empty (will need to see what to pass if image is empty)
  // selectedCondition.name to get the type
  // description.text to get the description

  var url = Uri(
    scheme: 'http',
    host: Constants.serverIP,
    port: Constants.serverPort,
    path: '##',
    queryParameters: {},
  );

  //Response response = await post(url);

  //Leave Screen Section - Cleanup
  //description.dispose();
  cheatUpdate.value = 0;

  if (context.mounted) {
    context.pop();
  }
}

//Get an image from the gallery, can be multiple
void selectImagesGallery(List<XFile> imageFileList) async {
  final List<XFile> selectedImages = await picker.pickMultiImage();
  if (selectedImages!.isNotEmpty) {
    imageFileList!.addAll(selectedImages);
  }
  cheatUpdate.value++;
  dismissDialog();
}

//Get an image from the camera
void selectImagesCamera(List<XFile> imageFileList) async {
  final XFile? selectedImage =
      await picker.pickImage(source: ImageSource.camera);
  if (selectedImage != null) {
    imageFileList.add(selectedImage);
  }
  cheatUpdate.value++;
  dismissDialog();
}
