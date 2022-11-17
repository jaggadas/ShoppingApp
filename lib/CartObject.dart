
/**
 * CartObject is element of cart
 * @param image - image of product
 * @param name - name of product
 * @param price - price of product
 * @param quantity - quantity of product
 * @param id - int id of product
 * */
class CartObject{
  String image;
  String name;
  int id;
  double price;
  int quantity;
  CartObject({required this.image,required this.name,required this.price,required this.quantity,required this.id});

  @override
  String toString() {
    // TODO: implement toString
    return "{CartObject image:"+image+" name:"+name+" price:"+price.toString()+" quantity:"+quantity.toString()+"}";
  }
}