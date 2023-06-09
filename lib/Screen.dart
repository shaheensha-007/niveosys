import 'package:company/cameraset.dart';
import 'package:flutter/material.dart';


class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.only(top: mheight*0.3),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Camera()));
              },
                child: Container(
                  height: mheight*0.05,
                  width: mwidth*0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all()
                  ),
                  child: Center(
                    child:   const Text("calicut",style:TextStyle(fontSize: 14,fontWeight: FontWeight.bold) ,

                    ),
                  ),
                ),
              ),
              SizedBox(
                height: mheight*0.04,
              ),
              GestureDetector(onTap: (){},
                  child: Card(
                    child:   Container(
                        height: mheight*0.05,
                        width: mwidth*0.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all()
                        ),
                        child: Center(
                          child: const Text("malappuram",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                          ),
                        )
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

