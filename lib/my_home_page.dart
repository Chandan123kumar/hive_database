import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController myText=TextEditingController();
  TextEditingController myValue=TextEditingController();

  var mybox=Hive.box('myBox');
  List myData=[];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Hive DataBase',style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0,left: 10,right: 10),
        child: ListView(
            children: [
              TextField(
                controller: myText,
                decoration: InputDecoration(
                  hintText: 'Enter Items',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: myValue,
                decoration: InputDecoration(
                    hintText: 'Enter price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
                  Map m1={
                    'items':myText.text,
                    'price':myValue.text,
                  };
                  addItem(m1);
                  getItem();
                  myText.clear();
                  myValue.clear();
              },
                  child: Text('Add Item')),

            ListView.builder(
                itemCount: myData.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context,index){
                  return ListTile(

                    title: Text('${myData[index]['items']}'),
                    subtitle: Text('${myData[index]['price']}'),
                    leading: IconButton(onPressed: () {
                      myText.text=myData[index]['items'];
                      myValue.text=myData[index]['price'];
                      bottomSheet(myData[index]['key']);
                      getItem();
                    }, icon: Icon(Icons.edit),),
                    trailing: IconButton(onPressed: () {
                      deleteItem(myData[index]['key']);
                    }, icon: Icon(Icons.delete),)
                  );
                })
            ]
          ),
        ),
      );
  }

  void addItem(data) async{
    await mybox.add(data);
    print(mybox.values);
  }
  getItem(){
    myData=mybox.keys.map((e){
       var res=mybox.get(e);
       return {
        'key': e,
         'items':res['items'],
         'price':res['price'],
       };
    }).toList();

    setState(() {

    });
  }

  deleteItem(key)async{
    await mybox.delete(key);
    getItem();
  }

  void updateItem( key, data)async{
   await mybox.put(key, data);
   getItem();
  }

  @override
  void initState() {
    super.initState();
    getItem();
  }

  void bottomSheet(key) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        color: Colors.orange,
        height: 550, // Increased height for better visibility
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjusts height to content size
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Update your List',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 20),
              child: TextField(
                controller: myText, // Controller with initial value
                decoration: InputDecoration(
                  hintText: 'Enter Items',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 5),
              child: TextField(
                controller: myValue, // Controller with initial value
                decoration: InputDecoration(
                  hintText: 'Enter price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Map <String,String> updateDatas={
                  'items': myText.text,
                  'price':myValue.text
                };
                updateItem(key, updateDatas);

                Navigator.pop(context); // Close the bottom sheet
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

}
