import 'package:flutter/material.dart';
import 'package:slist/models/grocery_item.dart';
import 'package:slist/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {


 final List<GroceryItem> groceryItems = []; 



  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => NewItem()));

        if(newItem==null){
          return;
        }

        setState(() {
          groceryItems.add(newItem);
        });
  }

  void _removeItem(GroceryItem item){
    setState(() {
      groceryItems.remove(item);
    });
  }

  

  @override
  Widget build(BuildContext context) {

    Widget activeWidget = Scaffold(
      body: Center(
        child: Text("Nothing to show here! \n try adding something"),
      ),
    );

  if(groceryItems.length>0){
    activeWidget = ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (ctx, index) => Dismissible(
            onDismissed: (direction) {
              _removeItem(groceryItems[index]);
            },
            key: ValueKey(groceryItems[index].id),
            child: ListTile(
                title: Text(groceryItems[index].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: groceryItems[index].category.selectedColor,
                ),
                trailing: Text(
                  groceryItems[index].quantity.toString(),
                ),
              ),
          ),
    );
  }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: Icon(Icons.add),
            )
        ],
      ),
      body: activeWidget,
    );
  }
}