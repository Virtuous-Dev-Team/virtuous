import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtuetracker/App_Configuration/apptheme.dart';

class NearbyPage extends StatefulWidget {
  const NearbyPage({Key? key}) : super(key: key);

  @override
  _NearbyPageState createState() => _NearbyPageState();
}

class _NearbyPageState extends State<NearbyPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight=MediaQuery.of(context).size.height;
    double screenWidth=MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF9),
        border: Border.all(color: const Color(0xFFFEFE5CC), width: 9.0),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colours.swatch(clrBackground),),
          child: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontSize: 16,fontFamily: "Poppins",fontWeight: FontWeight.w600,color: Colours.black),
          indicatorSize: TabBarIndicatorSize.tab,
          
          unselectedLabelColor: Colours.swatch(clrBlack),
          indicatorPadding: const EdgeInsets.only(left: 0,right: 0),
          
          indicator: BoxDecoration( borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),color: Colours.swatch(clrWhite),),
          indicatorColor: Colours.swatch(clrBlack),
          tabs: const [
            Tab(text: "Vitruous",),
          
          
            Tab(text: "My Community",)
          ],
                ),
        ),

    Expanded(
    child: TabBarView(
    controller: _tabController,
    physics: const NeverScrollableScrollPhysics(),
    children: [
      Vitruous(screenWidth,screenHeight),
      MyCommunity(screenWidth,screenHeight)

    // ClientScreen(widget.clientsResponseData!,widget.authentication!,session.tokens!,widget.index!),
    // // ClientScreen(widget.clientsResponseData!,widget.authentication!,widget.token!,widget.index!),
    // SignatureScreen(widget.clientsResponseData!,widget.authentication!,session.tokens!,widget.index!,_scaffoldKey),
    //
    ],
    ),)
        ],

      )


    );
  }
}

Widget Vitruous(double screnWidth,double screenHeight){
  return
      SingleChildScrollView(
        child: Container(
          color: Colours.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        Padding(
          padding:  EdgeInsets.only(top: screenHeight/60),
          child: Container(
            width: screnWidth/3,
              constraints: BoxConstraints(maxWidth: screnWidth),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colours.swatch("#FAD4E3")
            ),
            child:Center(child: Text("Why use virtues?",style: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.normal,
              color: Colours.swatch(clrBlack),
            )),)

          ),
        ),
              Padding(
                padding:  EdgeInsets.only(top: screenHeight/60),
                child: Container(
                   // width: screnWidth/3,
                    constraints: BoxConstraints(maxWidth: screnWidth),
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(5),
                    //     color: Colours.swatch("#FAD4E3")
                    // ),
                    child:Center(child: Text("Using virtues can have a positive impact on one’s mental state. Focusing on the positive aspects of life greatly increases one’s outlook and mood. and stuff"
                        ,style: TextStyle(
                      fontSize: 16,
        
                      fontWeight: FontWeight.normal,
                      color: Colours.swatch(clrBlack),
                    )),)
        
                ),
              )
            ],
          ),
        ),
      );
}
Widget MyCommunity(double screnWidth,double screenHeight){
  final List<String> virtues = [
    "Honesty is being truthful and sincere in both words and actions, without deceit or deception.",
    "Courage is the willingness to face fear, danger, or challenges with bravery and determination.",
    "Compassion is caring for others and wanting to help them when they are going through difficult times.",
    "Generosity is the act of giving or sharing with others, often without expecting anything in return.",
    "Fairness is treating people justly, not letting your personal feelings bias your decisions about others.",
    "Integrity is the practice of being honest and showing a consistent and uncompromising adherence to strong moral and ethical principles and values.",
    "Fidelity is faithfulness, loyalty, and the commitment to keeping promises and maintaining trust in a relationship or duty."
  ];
  return
    SingleChildScrollView(
      child: Container(
        color: Colours.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding:  EdgeInsets.only(top: screenHeight/60),
              child: Container(
                  width: screnWidth/1.5,
                  constraints: BoxConstraints(maxWidth: screnWidth),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colours.swatch("#D7F1F7")
                  ),
                  child:Center(child: Text("Why are virtues important in my community?",
                      style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.normal,
                    color: Colours.swatch(clrBlack),
                  )),)

              ),
            ),
            Padding(
              padding:  EdgeInsets.only(top: screenHeight/60),
              child: Container(
                // width: screnWidth/3,
                  constraints: BoxConstraints(maxWidth: screnWidth),
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(5),
                  //     color: Colours.swatch("#FAD4E3")
                  // ),
                  child:Center(child: Text("The legal community has seen an increase in corruption. Using virtues ensures that those who practice law use their knowledge for noble purposes etc etc etc"
                      ,style: TextStyle(
                        fontSize: 16,

                        fontWeight: FontWeight.normal,
                        color: Colours.swatch(clrBlack),
                      )),)

              ),
            ),
            Divider(
              endIndent: 10,
              indent: 10,
              color: Colours.swatch(clrBlack),
              height: screenHeight / 35,
            ),
            Padding(
              padding:  EdgeInsets.only(top: screenHeight/60),
              child: Container(
                  width: screnWidth/3,
                  constraints: BoxConstraints(maxWidth: screnWidth),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colours.swatch("#FAD4E3")
                  ),
                  child:Center(child: Text("About my virtues:",style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.normal,
                    color: Colours.swatch(clrBlack),
                  )),),


              ),

            ),
            SizedBox(
              height: screenHeight,
              child: ListView.builder(
                itemCount: virtues.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.circle,size: 10,), // You can replace this icon with a bullet point icon
                    title: Text(virtues[index],
                        style: TextStyle(
                          fontSize: 16,

                          fontWeight: FontWeight.normal,
                          color: Colours.swatch(clrBlack),
                        )),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
}