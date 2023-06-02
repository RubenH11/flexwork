import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexwork/database/firebaseService.dart';
import 'package:flexwork/models/floors.dart';
import 'package:flexwork/models/newReservationNotifier.dart';
import 'package:flexwork/models/uiState.dart';
import 'package:flexwork/user/my_reservations/myReservations.dart';
import 'package:flexwork/user/my_reservations/myReservationsContent.dart';
import 'package:flexwork/user/my_reservations/myReservationsMenu.dart';
import 'package:flexwork/user/new_reservation/content.dart';
import 'package:flexwork/user/new_reservation/menu.dart';
import 'package:flexwork/widgets/navButton.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class FlexWork extends StatelessWidget {
  const FlexWork({super.key});

  @override
  Widget build(BuildContext context) {
    print("|||| Flexwork ||||");
    return ChangeNotifierProvider(
      create: (context) => FlexWorkUIState(),
      child: StreamBuilder(
        stream: FirebaseService().getWorkspaceTypesStream(),
        builder: (context, typeSnapshot) {
          if (typeSnapshot.hasError) {
            print(typeSnapshot.error);
            return const Text("An error occurred, please reload the page.");
          }

          if (typeSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary),
            );
          }

          FirebaseService().buildWorkspaceTypesRepo(typeSnapshot.data!);

          return StreamBuilder(
            stream: FirebaseService().getWorkspacesStream(),
            builder: (context, workspaceSnapshot) {
              if (workspaceSnapshot.hasError) {
                print(workspaceSnapshot.error);
                return const Text("An error occurred, please reload the page.");
              }

              if (workspaceSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary),
                );
              }

              FirebaseService().buildWorkspacesRepo(workspaceSnapshot.data!);
              return StreamBuilder(
                stream: FirebaseService().getReservationsStream(),
                builder: (context, reservationsSnapshot) {
                  if (reservationsSnapshot.hasError) {
                    return Text("error: ${reservationsSnapshot.error}");
                  }
                  if (reservationsSnapshot.connectionState ==
                          ConnectionState.waiting ||
                      !reservationsSnapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }

                  FirebaseService()
                      .buildReservationsRepo(reservationsSnapshot.data!);
                  return StreamBuilder(
                    stream: FirebaseService().getRequestsStream(),
                    builder: (context, requestsSnapshot) {
                      if (requestsSnapshot.hasError) {
                        print("44");
                        return Text("error: ${requestsSnapshot.error}");
                      }
                      if (requestsSnapshot.connectionState ==
                              ConnectionState.waiting ||
                          !requestsSnapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      }

                      FirebaseService()
                          .buildRequestsRepo(requestsSnapshot.data!);

                      return const _FlexworkScreen();
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _FlexworkScreen extends StatelessWidget {
  const _FlexworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uiState = Provider.of<FlexWorkUIState>(context);

    print("|||| _FlexworkScreen ||||");
    return Column(
      children: [
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            border: Border(
              bottom:
                  BorderSide(color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
          child: Row(
            children: [
              const Expanded(flex: 1, child: SizedBox()),
              Expanded(
                  flex: 20,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NavButton(
                          selected: uiState.getOpenPage() ==
                              FlexworkPages.newReservation,
                          action: () =>
                              uiState.setOpenPage(FlexworkPages.newReservation),
                          text: "New reservation",
                        ),
                        Container(
                          height: 25,
                          width: 1,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        NavButton(
                          selected: uiState.getOpenPage() == FlexworkPages.myReservations,
                          action: () =>
                              uiState.setOpenPage(FlexworkPages.myReservations),
                          text: "My reservations",
                        ),
                      ],
                    ),
                  )),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  icon: const Icon(Icons.logout),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ChangeNotifierProvider(
            create: (_) => NewReservationNotifier(Floors.f9),
            child: uiState.getOpenPage() == FlexworkPages.newReservation
                ? const _NewReservationScreen()
                : const MyReservations(),
          ),
        ),
      ],
    );
  }
}

class _NewReservationScreen extends StatelessWidget {
  const _NewReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          width: 350,
          child: const NewReservationMenu(),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: const NewReservationContent(),
          ),
        ),
      ],
    );
  }
}
