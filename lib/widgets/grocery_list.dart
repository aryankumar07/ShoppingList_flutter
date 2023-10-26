import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:slist/data/categories.dart';
import 'package:slist/models/grocery_item.dart';
import 'package:slist/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {


List<GroceryItem> groceryItems = [];
var _isloading = true;
String? _error;


 @override
  void initState() {
    super.initState();
    _loadItems();
  }

 void _loadItems() async {
final url = Uri.https('slist-2b760-default-rtdb.firebaseio.com','shopping-list.json');

try{
        final response  = await http.get(url);
    if(response.statusCode>=400){
       _error="failed to fetch data";
    }
    print(response.body);
    if(response.body=='null'){
      setState(() {
      _isloading=false;
      });
      return ; 
    }
    final Map<String,dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadItems = [];
    for(final items in listData.entries){
      final category = categories.entries.firstWhere((catItem) => 
      catItem.value.food == items.value['category']).value;
      loadItems.add(GroceryItem(id: items.key, name: items.value['name'],
       quantity: items.value['quantity'],
        category: category)
        );
    }
    setState(() {
      groceryItems = loadItems; 
      _isloading = false;
    });
}catch(err){
  setState(() {
    _error="Something went wrong!";
  });
}


 }



  void _addItem() async {
   final newItem =  await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => NewItem()));

      if(newItem==Null){
        return ;
      }

     setState(() {
       groceryItems.add(newItem!);
     }); 
  }

  void _removeItem(GroceryItem item) async {
    final index = groceryItems.indexOf(item);
    setState(() {
      groceryItems.remove(item);
    });
    final url = Uri.https('slist-2b760-default-rtdb.firebaseio.com','shopping-list/${item.id}.json');
    final response = await http.delete(url);

    if(response.statusCode>=400){
      setState(() {
        groceryItems.insert(index, item);
      });
    }
    
  }

  

  @override
  Widget build(BuildContext context) {

    Widget activeWidget = Scaffold(
      body: Center(
        child: Text("Nothing to show here! \n try adding something"),
      ),
    );

    if(_isloading){
      activeWidget = const Center(child: CircularProgressIndicator(),);
    }

    if(_error!=null){
      activeWidget = Center(child: Text(_error!),);
    }

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