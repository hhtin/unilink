import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/view_model/university_view_model.dart';

class UniversityList extends StatelessWidget {
  const UniversityList({this.unis});
  final List<UniversityViewModel> unis;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: unis.length,
        itemBuilder: (context, index) {
          final uni = unis[index];
          return ListTile(
            contentPadding: EdgeInsets.all(10),
            leading: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              width: 100,
              height: 150,
              child: Text(uni.university.id),
            ),
            trailing: InkWell(
              child: Text("Collect", style: TextStyle(fontSize: 22)),
              onTap: () async {
                print("Start");
                Provider.of<UniversityListViewModel>(context, listen: false)
                    .getAll();
                print("End");
              },
            ),
            title: Text(uni.university.name),
          );
        });
  }
}
