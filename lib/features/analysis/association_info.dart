import 'package:clear_avenues/models/Association.dart';
import 'package:clear_avenues/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssociationInfoScreen extends ConsumerStatefulWidget {
  final Association association;

  const AssociationInfoScreen({super.key, required this.association});

  @override
  ConsumerState<AssociationInfoScreen> createState() =>
      _AssociationInfoScreen();
}

class _AssociationInfoScreen extends ConsumerState<AssociationInfoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reportsList = ref.watch(
        reportsByLocationProvider(widget.association.associationId.toInt()));
    final reports = reportsList.value;

    return Scaffold(
        appBar: AppBar(
          title:
              Text('Association Report : ${widget.association.associationId}'),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Text(
                    "Region Intensity: ${widget.association.intensity}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "The intensity determines the weight of the unsafe conditions on the analysis map "
                    "that are now displayed as hotspots Intensity is determined by the number of "
                    "accidents and unsafe conditions correlated together within the past 7 days. "
                    "For every correlation it increases the intensity.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Region Reports",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Region reports are the unsafe conditions located within this zipcode. This will demonstrate every report, including resolved ones.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: reports?.length ?? 0,
                      itemBuilder: (context, index) {
                        final currItem = reports![index];
                        return Container(
                          color: Colors.green,
                          child: ExpansionTile(
                            iconColor: Colors.white,
                            textColor: Colors.white,
                            collapsedIconColor: Colors.white,
                            collapsedTextColor: Colors.white,
                            title: Text(
                              "Report ${currItem.reportId} [${currItem.reportType}]",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Divider(
                                      thickness: 2,
                                      color: Colors.green[300],
                                    ),
                                    Text(
                                      "Report Latitude: ${currItem.reportLocationLatitude}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "Report Longitude: ${currItem.reportLocationLongitude}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "Created At: ${currItem.reportDate}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                        "\"${currItem.reportComment.isNotEmpty ? currItem.reportComment : "No Comment"}\"",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                        "Report Status: ${currItem.reportStatus ?? "No Assigned Status"}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                        "Resolution Date: ${currItem.resolutionDate ?? "Not Resolved"}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Region Accidents",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Region accidents are accidents that occurred within this zipcode. Accidents are not submitted by user, instead pulled from public databases.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  //TODO Listbuilder Accidents
                ]))));
  }
}
