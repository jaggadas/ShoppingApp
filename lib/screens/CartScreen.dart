import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'HomeScreen.dart';

/**
 * CartScreen is the screen with all the cart objects and leads to payment page
 * */
class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const id  = 'cart';
  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Data>(context,listen: false);
    // counter.getCart();
    return Scaffold(appBar: AppBar(toolbarHeight: 70,elevation: 0,
      backgroundColor: offWhite,title: Text("Your Cart",style: GoogleFonts.poppins(textStyle:TextStyle(color: Colors.black),)),centerTitle: true,
      leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.black,), onPressed: () {Navigator.pushNamed(context,HomePage.id );  },),),
    backgroundColor: offWhite,
    body: Column(mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(flex: 12,child: Consumer<Data>(builder:(context,counter,child)=> counter.gotCart&&counter.objects.length!=0?
        Container(child:
        ListView.builder(itemCount: counter.objects.length,itemBuilder: (context,index){
          if(counter.objects.length!=0) {
            return CartItem(title: counter.objects[index].name,
              price: counter.objects[index].price,
              image: counter.objects[index].image,
              quantity: counter.objects[index].quantity,
              index: index,);
          }
         return Container(child: Center(child: Text("Please Wait",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.blueGrey,fontSize: 25,fontWeight: FontWeight.w600)),)
            ,),);
        })
        )

            :counter.objects.length==0?Container(child: Center(child: Text("Please Wait",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.blueGrey,fontSize: 25,fontWeight: FontWeight.w600)),)
          ,),):Container(child: Center(child: Text("Please Wait",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.blueGrey,fontSize: 25,fontWeight: FontWeight.w600)),)
          ,),),
        ))

        ,Flexible (flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0,top: 10,right: 30,bottom:0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Price",style: GoogleFonts.poppins(textStyle:TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),)),
            Consumer<Data> (builder: (context,counter,child)=>Text("\$${counter.total}",style: GoogleFonts.poppins(textStyle:
            TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 30,))),)
            ,
            ],
      ),
          ),
        ),
        Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0,top: 10,right: 25,bottom: 30),
              child: TextButton(

                style: ButtonStyle(

                    alignment: Alignment.center,
                    padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xff1C1C19)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(

                          borderRadius: BorderRadius.circular(6.0),
                        )
                    )
                ),
                onPressed: () async{

                },
                child: Text('Payment',style:GoogleFonts.poppins(textStyle:
                TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600))),
              ),
            ),
          ),
        ],
      ),],
    ),

    );
  }
}
/**
 * CartItem is an item of the list of objects in the cart
 * @param title - title of the product
 * @param price - price of the product
 * @param image - image of the product
 * @param quantity - quantity of the product
 * */
class CartItem extends StatelessWidget {
  String title;
  double price;
  String image;
  int quantity;
  int index;
  CartItem({required this.title,required this.price,required this.image,required this.quantity,required this.index});
  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Data>(context,listen: false);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(child:
      Column(mainAxisAlignment: MainAxisAlignment.start,children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start,children: [CachedNetworkImage(imageUrl: image,height: 100,width: 100,fit: BoxFit.cover,),SizedBox(width: 15,),
        Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max, children: [
          Row(mainAxisSize: MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.start,children: [
            Text(title.length>22?"${title.substring(0,21)}..":title,style: GoogleFonts.poppins(textStyle:TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),)),
            SizedBox(width: 18,),Text('\$$price',style:GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold,)),)],),
          SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.start,children: [Text("Size: ",style:GoogleFonts.poppins(textStyle: TextStyle(color: inactiveGrey,fontWeight: FontWeight.bold))),
            Text('S',style: GoogleFonts.poppins(textStyle:TextStyle(color: Colors.black,fontWeight: FontWeight.bold))),SizedBox(width: 5,),
            Text('Color: ',style: GoogleFonts.poppins(textStyle:TextStyle(color: inactiveGrey,fontWeight: FontWeight.bold))),Container(height: 20,width: 20,color: Colors.black87,),
            IconButton(iconSize: 18,onPressed: (){
                  counter.decreaseCount(index);
            }, icon: Icon(Icons.remove,)),
            Text(quantity.toString(),style: GoogleFonts.poppins(textStyle:TextStyle(color: Colors.black,fontSize: 12))),
            IconButton(iconSize: 18,onPressed: (){
                counter.increaseCount(index);
            }, icon: Icon(Icons.add))],)
        ],)
      ],)
        ,SizedBox(height: 20,),
        Container(height: 1,width: double.infinity,color: Colors.grey,)
      ],)
        ,),
    );
  }
}
