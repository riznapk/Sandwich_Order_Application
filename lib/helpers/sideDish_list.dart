class SideDishList {
  String id;
  String name;
  double price;
  String image;

  SideDishList({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });
}

var drinksList = [
  SideDishList(
      id: "DS1",
      name: 'Coco-Cola Zero Sugar',
      price: 1.50,
      image: "images/dietcola.png"),
  SideDishList(
      id: "DS2", name: 'Coco-Cola', price: 1.50, image: "images/cola.png"),
  SideDishList(
      id: "DS3", name: 'Monster', price: 1.50, image: "images/monster.png"),
  SideDishList(
      id: "DS4", name: 'Fanta', price: 1.50, image: "images/fanta.png"),
  SideDishList(
      id: "DS5", name: 'Lemonade', price: 2.50, image: "images/drinks.jpg"),
  SideDishList(
      id: "DS6",
      name: 'Flavoured Lemonade',
      price: 3.50,
      image: "images/drinks.jpg"),
];

var snacksList = [
  SideDishList(
      id: "SS1",
      name: 'French Fries',
      price: 2.50,
      image: "images/friesorg.jpg"),
  SideDishList(
      id: "SS2", name: 'Cookie', price: 2.50, image: "images/cookie.jpg"),
  SideDishList(
      id: "SS3",
      name: 'Cheesy Fries',
      price: 2.50,
      image: "images/cheesyFries.jpg"),
  SideDishList(
      id: "SS4", name: 'Muffin', price: 2.50, image: "images/muffin.jpg"),
  SideDishList(
      id: "SS5",
      name: 'Potato Wedges',
      price: 2.50,
      image: "images/drinks.jpg"),
  SideDishList(
      id: "SS6", name: 'Cheesy fries', price: 2.50, image: "images/wedges.jpg"),
];
