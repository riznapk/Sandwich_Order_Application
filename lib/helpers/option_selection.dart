class OptionSelection {
  String optionHeading;
  String image;
  String value;

  OptionSelection(
      {required this.optionHeading, required this.image, required this.value});
}

var optionList = [
  OptionSelection(
      optionHeading: 'Drinks', image: "images/drinks.jpg", value: 'drinks'),
  // OptionSelection(
  //     optionHeading: 'Snacks and Dips',
  //     image: "images/fries.jpg",
  //     value: 'snacks'),
];
