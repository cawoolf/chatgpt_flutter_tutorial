
import 'package:chatgpt_flutter_tutorial/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/models_model.dart';
import '../services/api_services.dart';

class ModelsDropDownWidget extends StatefulWidget {
  const ModelsDropDownWidget({super.key});

  @override
  State<ModelsDropDownWidget> createState() => _ModelsDropDownWidgetState();
}

class _ModelsDropDownWidgetState extends State<ModelsDropDownWidget> {
  String currentModel = "gpt-3.5-turbo-0613";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ModelsModel>>(
        future: ApiService.getModels(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextWidget(label: snapshot.error.toString()),
            );
          }
          return snapshot.data == null || snapshot.data!.isEmpty
              ? const SizedBox.shrink()
              : buildModelDropDown(snapshot);
        });
  }

  FittedBox buildModelDropDown(AsyncSnapshot<List<ModelsModel>> snapshot) {
    return FittedBox(
          child: DropdownButton(
            dropdownColor: scaffoldBackgroundColor,
            iconEnabledColor: Colors.white,
            items: List<DropdownMenuItem<String>>.generate(
                snapshot.data!.length,
                    (index) => DropdownMenuItem(
                    value: snapshot.data![index].id,
                    child: TextWidget(
                      label: snapshot.data![index].id,
                      fontSize: 15,
                    ))),
            value: currentModel,
            onChanged: (value) {
              setState(() {
                currentModel = value.toString();
              });
            },
          ),
        );
  }
}