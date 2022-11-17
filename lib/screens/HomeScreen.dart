import 'dart:collection';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_internship/constants.dart';
import 'package:shopping_app_internship/screens/CartScreen.dart';
import 'package:http/http.dart';

import '../CartObject.dart';
import '../networking.dart';

/**
 * HomePage is the product list page
 * */
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  static const id  = 'homepage';
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Data>(context,listen: false);
    counter.getData();
    return Scaffold(
      backgroundColor: offWhite2,
      appBar: AppBar(toolbarHeight: 70,elevation: 0,
        backgroundColor: offWhite,leading: IconButton(onPressed: (){}, icon: Icon(Icons.menu,color: Colors.black,)),actions: [
        IconButton(onPressed: ()async{

        }, icon: Icon(Iconsax.search_favorite,color: Colors.black,))],),
      body:  SizedBox.expand(

        child: Container(color: offWhite2,child: Column(children: [
          Container(
            alignment: Alignment.bottomLeft,width: double.infinity,height: 56,color: offWhite,child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text("New Arrivals",style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),),
        ),),

         Consumer<Data>(builder:(context,counter,child)=> counter.got? Expanded(
           child: GridView.builder(
             itemCount: counter.data.length,

             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1/1.6,
                 crossAxisCount:2),
             itemBuilder: (BuildContext context, int index) {
               return ItemElement(image: counter.data[index]['image'], title: counter.data[index]['title'], price:counter.data[index]['price'],category: counter.data[index]['category']
                 ,id: counter.data[index]['id'],);
             },
           ),
         ) :Container()
           ,),
        ],),),
      ),
      bottomNavigationBar: Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        child: BottomNavyBar(
          backgroundColor: offWhite2,
          showElevation: false,
          selectedIndex: _currentIndex,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          onItemSelected: (index) {
             counter.getCart();
            Navigator.pushNamed(context, CartScreen.id);
          },itemCornerRadius: 18,
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                title: Text('Home',style: GoogleFonts.poppins(),),
                icon: Icon(Iconsax.home),
                activeColor: Colors.black,inactiveColor: inactiveGrey
            ),
            BottomNavyBarItem(
                title: Text('Cart'),
                icon: Icon(Icons.shopping_bag),
                activeColor: Colors.black,inactiveColor: inactiveGrey
            ),
          ],
        ),
      ),
      );
  }
}

/**
 * Item element for products
 * @param image - url for product image
 * @param title - title for product
 * @param price - price for product
 * @param category - category of product
 * @param id - id of product
 * */
class ItemElement extends StatelessWidget {
  String image;
  String title;
  String category;
  num price;
  int id;
  ItemElement({required this.image,required this.title,required this.price,required this.category,required this.id});
  /*
     * Function to capitalize string
     * @param s - string to be capitalized
     * @return capitalized string
     * */
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);


  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Data>(context,listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:  Container(padding: EdgeInsets.all(0),color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,children: [
        Center(child: CachedNetworkImage(imageUrl: image,height: 150,fit: BoxFit.cover,),),
        // Image.network(image,height:150,fit: BoxFit.cover,)),
        // Image.asset("assets/img1.png",height: 200,fit: BoxFit.cover,),
        SizedBox(height: 5,)
           ,Padding(
             padding: const EdgeInsets.symmetric(horizontal: 8.0),
             child: Text(capitalize(category),style:GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600,color: Colors.purple)),textAlign: TextAlign.start,),
           )
        ,Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(title.length>25?"${title.substring(0,24)}..":title,style: GoogleFonts.poppins(textStyle : TextStyle(fontWeight: FontWeight.w500,color: Color(0xff4B4A5A
          ))),textAlign: TextAlign.start,),
        ),
        Spacer(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [ Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("\$ $price",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),textAlign: TextAlign.start,)

        ),IconButton(onPressed: (){counter.addToCart(id);
        }, icon: Icon(Iconsax.shopping_bag))],)
            ],),),
    );
  }
}


/**
 * Data class for provider widget
 * */
class Data with ChangeNotifier{
  var data;
  bool got = false;
  double total= 0 ;
  var cartData;
  bool gotCart=false;
  List<CartObject> objects=[];
  HashMap<int,int> map = HashMap<int,int>();

  /*
     * Function to sign in once credentials are generated
     * @param credential authentication credentials generated
     * @return void
     * */
  void getData()async{
    NetworkHelper networkHelper= NetworkHelper('https://fakestoreapi.com/products');
    data = await networkHelper.getData();
    got=true;
    notifyListeners();
  }
  /*
     * Function to add objects to cart
     * @param id of object to be added
     * @return void
     * */
  void addToCart(int id)async {
    if(!map.containsKey(id)){
      map[id] = 1;
    }else{
      map.update(id, (value) => value+1);
    }
    print(map);
    notifyListeners();
  }
  /*
     * Function to get list of cartObjects
     * @param void
     * @return void
     * */
  void getCart()async{
    objects=[];
    NetworkHelper networkHelper= NetworkHelper('https://fakestoreapi.com/');
    for(int id in map.keys){
      var data =await networkHelper.getObject(id);
      objects.add(CartObject(image: data['image'], name: data['title'], price:data['price'].toDouble() , quantity:map[id]!,id: id));
    }
    print(objects.length);
    gotCart=true;
    totalPrice();
    notifyListeners();
  }
    /*
     * Function to calculate total price for cart screen
     * @param void
     * @return void
     * */
  void totalPrice(){
    total=0;
    for(var object in objects){
      total+=(object.price * object.quantity);
    }
    total = double.parse((total).toStringAsFixed(2));
    notifyListeners();
  }

/*
     * Function to increase count of product in cart screen
     * @param int index - index at which object is present
     * @return void
     * */
  void increaseCount(int index){
    objects[index].quantity+=1;
    totalPrice();
    notifyListeners();
  }
/*
     * Function to decrease count of product in cart screen
     * @param int index - index at which object is present
     * @return void
     * */
  void decreaseCount(int index){
    if( objects[index].quantity > 0){
      objects[index].quantity-=1;
    }
    else if(objects[index].quantity==0){
      map.remove(objects[index].id);
      objects.remove(index) ;
    }
    notifyListeners();
    totalPrice();

  }
}
//   void getCart()async{
//     objects=[];
//     NetworkHelper networkHelper= NetworkHelper('https://fakestoreapi.com/carts');
//     cartData = await networkHelper.getCart();
//     gotCart=true;
//     for(int i=0;i<cartData['products'].length;i++){
//       int val = cartData['products'][i]['productId'];
//       var data =await networkHelper.getObject(val);
//       objects.add(CartObject(image: data['image'], name: data['title'], price:data['price'].toDouble() , quantity:cartData['products'][i]['quantity']));
//     }
//     totalPrice();
//     notifyListeners();
//   }