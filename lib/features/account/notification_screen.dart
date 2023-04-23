import 'package:clear_avenues/providers.dart';
import 'package:clear_avenues/models/Notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final userName = user.name;
    if (userName != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
        ),
        body: StreamBuilder<List<MyNotification>>(
          stream: fetchNotifications(),
          builder: (context, AsyncSnapshot<List<MyNotification>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return snapshot.data![index].displayNotification(index, context);
                },
              );
            }
          }
        ),
      // Add This if you want to debug adding notifications
        /*
      floatingActionButton: ElevatedButton(
          child: const Text("Add Notification"),
          onPressed: () {
            defaultList.add(exampleNotification);
          },
        ),
        */
      );
    }
    //User isn't logged in
    else {
      return Scaffold(
        appBar:  AppBar(
          title: const Text("Notifications"),
        ),
        body: const Center(
            child: Text("Login to view your Notifications",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            )
        ),
      );
    }
  }

  Stream<List<MyNotification>> fetchNotifications() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1), () {});
      yield defaultList;
    }
  }
}
