import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hecolin_surveillance/Controller/BaselineInformationController.dart';
import 'package:hecolin_surveillance/Model/PreScreeningVisits.dart';
import 'package:hecolin_surveillance/View/HecolinTrialPreScreeningPage.dart';
import 'package:intl/intl.dart';

import '../Controller/PrescreeningVisitController.dart';
import '../Widgets/RoundButton.dart';
import '../config.dart';
import 'Login.dart';
import 'LoginScreen.dart';
import 'PrescreeningListViewPage.dart';

class HecolinHomePage extends StatefulWidget {
  final String title;

  const HecolinHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HecolinHomePage> createState() => _HecolinHomePageState();
}

class _HecolinHomePageState extends State<HecolinHomePage> {
  Future<void> _refreshItems() async {
    // You can add any additional logic here to fetch updated data
    setState(
        () {}); // For simplicity, we are just calling setState to refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    final BaselineInformationController baselineInformationController =
        BaselineInformationController();

    return Scaffold(
      appBar: AppBar(title: Text('Item List')),
      // body:
      // StreamBuilder<List<Map<String, dynamic>>>(
      //   stream: baselineInformationController.GetWomenInformation().asStream(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     } else {
      //       final items = snapshot.data ?? [];
      //
      //       return ListView.builder(
      //         itemCount: items.length,
      //         itemBuilder: (context, index) {
      //           final item = items[index];
      //           final itemName = item['VRID']; // Assuming 'name' is a field in the table
      //           return ListTile(
      //             title: Text(itemName),
      //           );
      //         },
      //       );
      //     }
      //   },
      // ),

      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Padding(padding: EdgeInsets.fromLTRB(globals.diffSizes.tabwidth/200, 0, 0, 0),child: const Align( alignment: Alignment.centerLeft, child: Text('Recent Activity')),),
              SizedBox(
                height: 800,
                child: Card(
                  shadowColor: Colors.white,
                  elevation: 0.3,
                  clipBehavior: Clip.antiAlias,
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: baselineInformationController.GetWomenInformation()
                        .asStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final items = snapshot.data ?? [];

                        return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            print(items[index]);
                            final itemName = item[
                                'FullName']; // Assuming 'name' is a field in the table
                            return ListTile(
                              title: Text(item['VRID'].toString()),
                              // title: Text(itemName),
                              //title: Text(data['studyID'].toString()),
                              subtitle: Text('added on: ' +
                                  ' by ' +
                                  item['FullName'].toString()),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),

              // Align( alignment: Alignment.centerRight, child: TextButton(onPressed: (){Get.to(() => ViewAll(component: widget.component));}, child: const Text('View All'))),
              // Expanded(child:
              // Column(children: [
              //   Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch,children: [
              //     Expanded(child: Stack(fit: StackFit.expand,children: [ElevatedButton(style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>( RoundedRectangleBorder( borderRadius: BorderRadius.circular(18.0),) )),onPressed: () {Get.to(() => NewCasePage(component: widget.component))!.then((value) {Get.forceAppUpdate();});}, child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [const Expanded(child: FittedBox( child: Icon( Icons.add_comment,  ), )), FittedBox( child: Text('New Case',style: globals.apptexttheme.headline6, textAlign: TextAlign.center) ), const SizedBox(height: 20,)],)), Align(alignment: Alignment.bottomCenter, child: Container(height: 15,decoration: BoxDecoration(color: Colors.white,borderRadius: new BorderRadius.only( bottomLeft: const Radius.circular(18.0), bottomRight: const Radius.circular(18.0), ))) )],),),
              //     // SizedBox(width: Get.width/20,),
              //     Expanded(child: Stack(fit: StackFit.expand,children: [ElevatedButton(style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>( RoundedRectangleBorder( borderRadius: BorderRadius.circular(18.0),) )),onPressed: () {}, child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [const Expanded(child: FittedBox( child: Icon( Icons.report_problem_rounded,  ), )),FittedBox(child: Text('Report Case', style: globals.apptexttheme.headline6,textAlign: TextAlign.center)), const SizedBox(height: 20,)],)), Align(alignment: Alignment.bottomCenter, child: Container(height: 15,decoration: BoxDecoration(color: Colors.white,borderRadius: new BorderRadius.only( bottomLeft: const Radius.circular(18.0), bottomRight: const Radius.circular(18.0), ))) )],),),
              //     // SizedBox(width: Get.width/20,),
              //     Expanded(child: Stack(fit: StackFit.expand,children: [ElevatedButton(style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>( RoundedRectangleBorder( borderRadius: BorderRadius.circular(18.0),) )),onPressed: () {Get.to(() => DeviceHealth());}, child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [const Expanded(child: FittedBox( child: Icon( Icons.health_and_safety_rounded,  ), )),FittedBox(child: Text('Device Health', style: globals.apptexttheme.headline6,textAlign: TextAlign.center,)), const SizedBox(height: 20,)],)), Align(alignment: Alignment.bottomCenter, child: Container(height: 15,decoration: BoxDecoration(color: Colors.white,borderRadius: new BorderRadius.only(bottomLeft: const Radius.circular(18.0), bottomRight: const Radius.circular(18.0), ))) )],)
              //     )],
              //   ),
              //   )
              //
              // ],)
              // ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Row(mainAxisAlignment: MainAxisAlignment.center, children: [Image(image: const AssetImage("assets/images/aku-logo.png"), height: globals.diffSizes.tabheight/16, isAntiAlias: true, filterQuality: FilterQuality.high,),const SizedBox(width: 10,),Image(image: const AssetImage("assets/images/mits-logo.png"), height: globals.diffSizes.tabheight/12.5, isAntiAlias: true, filterQuality: FilterQuality.high,),],),
                  const SizedBox(
                    height: 5,
                  ),
                  // Text(globals.prjdesc,style:globals.apptexttheme.overline, textAlign: TextAlign.center),
                ],
              ))
            ],
          )),
    );
  }
// @override
// Widget build(BuildContext context) {
//   final PrescreeningVisitController prescreeningVisitController =
//       PrescreeningVisitController();
//
//   return Scaffold(
//     appBar: AppBar(
//       title: Text("Hecolin Trial"),
//       actions: [
//         IconButton(
//           onPressed: () {
//             //Navigator.of(context).pushNamed('/screen2');
//
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => LoginScreen()));
//           },
//           icon: Icon(Icons.logout_outlined),
//         ),
//         SizedBox(width: 10)
//       ],
//       backgroundColor: Colors.deepPurpleAccent,
//     ),
//     body: Center(
//       child: FutureBuilder<String>(
//         // future: fetchData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             return RefreshIndicator(
//                 child: Padding(
//                     padding: const EdgeInsets.all(0),
//                     child: ListView.builder(
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (context, position) {
//                         var data = snapshot.data![position];
//                         //var formdata = jsonDecode(data['formdata']);
//                         return Column(children: [
//                           Card(
//                             child: ListTile(
//                               // title: Text(data['studyID'].toString()),
//                               // subtitle: Text('added on: '+ DateFormat('d MMM y hh:mm a').format(DateTime.parse(data['createdAT'])) + ' by ' + data['user'].toString()),
//                               // subtitle: Row(children: <Widget>[
//                               //   Icon(Icons.redo, color: Colors.green),
//                               //   SizedBox(width:10),
//                               //   Text('${content.formattedTIdate} ${content.formattedTItime}'),
//                               //   SizedBox(width:10),
//                               //   Icon(Icons.undo, color: Colors.redAccent),
//                               //   SizedBox(width:10),
//                               //   displayer(content.formattedTOdate, content.formattedTOtime),
//                               //   ],),
//                               // onTap: () => {Get.to(() => CRFList(component: widget.component, studyID: data['studyID']))},
//                               trailing: Wrap(
//                                 children: const [
//                                   Icon(Icons.assignment),
//                                   Icon(Icons.arrow_right)
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ]);
//                       },
//                     )),
//                 onRefresh: _refreshItems);
//             //}
//
//             // Data is ready, display it
//             return Text('Data: ${snapshot.data}');
//           }
//         },
//       ),
//     ),
//   );
// }
}
