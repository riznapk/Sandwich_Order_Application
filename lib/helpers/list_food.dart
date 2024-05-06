class ListFood {
  String id;
  String name;
  String description;
  String imageUrl;

  double price;

  ListFood({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });
}

var foodList = [
  ListFood(
    id: "BS1",
    name: 'FREE RANGE CHICKEN SANDWICH',
    price: 12.50,
    description:
        "Free range grilled chicken breast, with the tinge of basil, brown butter mastard mayo, fresh tomato and rocket.",
    imageUrl: 'images/burger3.png',
  ),
  ListFood(
    id: "BS2",
    name: 'HONEST BUTCHERS BEEF',
    price: 10.50,
    description: "Tender beef with red onion relist and lettuce.",
    imageUrl: 'images/burger4.png',
  ),
  ListFood(
    id: "BS3",
    name: 'HONEST BUTCHERS BEEF',
    price: 10.50,
    description: "Tender beef with red onion relist and lettuce.",
    imageUrl: 'images/sandwich3.png',
  ),
  ListFood(
    id: "BS4",
    name: 'HONEST BUTCHERS BEEF',
    price: 10.50,
    description: "Tender beef with red onion relist and lettuce.",
    imageUrl: 'images/burger6.png',
  ),
  ListFood(
    id: "BS5",
    name: 'HONEST BUTCHERS BEEF',
    price: 10.50,
    description: "Tender beef with red onion relist and lettuce.",
    imageUrl: 'images/burger1.png',
  ),
  ListFood(
    id: "BS6",
    name: 'HONEST BUTCHERS BEEF',
    price: 10.50,
    description: "Tender beef with red onion relist and lettuce.",
    imageUrl: 'images/burger2.png',
  ),
];
