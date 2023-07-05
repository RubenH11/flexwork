import 'package:flexwork/helpers/database.dart';
import 'package:flexwork/models/floors.dart';
import 'package:flexwork/models/newReservationNotifier.dart';
import 'package:flexwork/models/uiState.dart';
import 'package:flexwork/user/my_reservations/myReservations.dart';
import 'package:flexwork/user/my_reservations/content.dart';
import 'package:flexwork/user/my_reservations/menu.dart';
import 'package:flexwork/user/new_reservation/content.dart';
import 'package:flexwork/user/new_reservation/menu.dart';
import 'package:flexwork/widgets/futureBuilder.dart';
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
      child: _FlexworkScreen(),
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
                          selected: uiState.getOpenPage() ==
                              FlexworkPages.myReservations,
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
                    DatabaseFunctions.logout();
                  },
                  icon: const Icon(Icons.logout),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: uiState.getOpenPage() == FlexworkPages.newReservation
              ? const _NewReservationScreen()
              : const MyReservations(),
        ),
      ],
    );
  }
}

class _NewReservationScreen extends StatefulWidget {
  const _NewReservationScreen({super.key});

  @override
  State<_NewReservationScreen> createState() => _NewReservationScreenState();
}

class _NewReservationScreenState extends State<_NewReservationScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewReservationNotifier(Floors.f9),
      child: FlexworkFutureBuilder(
        future: DatabaseFunctions.getWorkspaceTypes(),
        builder: (legend) {
          return Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                width: 350,
                child: NewReservationMenu(refreshPage: () {
                  print("refreshed page");
                  setState(() {});
                }),
              ),
              const VerticalDivider(),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  child: NewReservationContent(legend: legend),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
