import 'package:slist/data/categories.dart';
import 'package:slist/models/category.dart';


class GroceryItem{
  GroceryItem(
    {
      required this.id,
      required this.name,
      required this.quantity,
      required this.category,
    }
  );
  String id;
  String name;
  int quantity;
  Category category;

}