import 'dart:io';

import 'package:clear_avenues/widgets/my_scaffold.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

ImagePicker picker = ImagePicker();
List<XFile> imageFileList = []; //For multi-images + gallery

//Dismiss dialogue box help
BuildContext? dcontext;
dismissDialog() {
  if(dcontext != null){
    Navigator.of(dcontext!).pop();
  }
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key, this.coordinates = const LatLng(0, 0)})
      : super(key: key);
  final LatLng coordinates;
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

  UnsafeCondition? selectedCondition;

  final TextEditingController _controller = TextEditingController();

  // static LatLng loc = LatLng(1.0,1.0);
  // static LatLng? loc = passed_location;
  // static String s = "${loc?.longitude} ${loc?.latitude}";

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Stack(
              children: [
                Image.asset(
                    "assets/gmaps_placeholder.webp"), // TODO: replace image with map preview centered around selected area
                TextField(
                  // Will be changed later
                  controller: _controller
                    ..text = widget.coordinates.latitude.toString() +
                        ", " +
                        widget.coordinates.longitude.toString(),
                  //"${widget.passed_location?.longitude} ${widget.passed_location?.latitude}",
                  onSubmitted: null,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Enter a location"),
                      filled: true,
                      fillColor: Colors.white),
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
              underline: Container(
                height: 4,
                color: Colors.cyan,
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
            const TextField(
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(labelText: "Enter Description"),
              maxLines: 5,
            ),
            //Upload image box
            ElevatedButton(
              onPressed: () => setState(() => _onPressUpload(context)),
              child: Row (
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
            //Image display box
            SizedBox(
              height: 150,
              child:ListView.builder(
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
                }
              )
            ),
            ElevatedButton(
              onPressed: () => _onPressSubmit(context),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

//Asks user where they want to grab a photo from and calls methods to fetch those photos
void _onPressUpload(BuildContext context) {

  //Set context to pop whenever needed
  dcontext = context;

  Widget cameraButton = const TextButton(
    onPressed: selectImagesCamera,
    child: Text("Camera"),
  );
  Widget galleryButton = const TextButton(
    onPressed: selectImagesGallery,
    child: Text("Gallery"),
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
    )
  );
}

//Submit the information of the report and leave the report screen
void _onPressSubmit(BuildContext context) async {
  imageFileList.clear(); //Needs to be manually cleared
  Navigator.popAndPushNamed(context, '/map');
}

//Get an image from the gallery, can be multiple
void selectImagesGallery() async {
  final List<XFile> selectedImages = await picker.pickMultiImage();
  if (selectedImages!.isNotEmpty) {
    imageFileList!.addAll(selectedImages);
  }
  dismissDialog();
}

//Get an image from the camera
void selectImagesCamera() async {
  final XFile? selectedImage = await picker.pickImage(source: ImageSource.camera);
  if (selectedImage != null) {
    imageFileList.add(selectedImage);
  }
  dismissDialog();
}