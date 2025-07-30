import 'package:evently/widgets/default_text_form_field.dart';
import 'package:evently/widgets/event_item.dart';
import 'package:flutter/material.dart';

class LoveTab extends StatelessWidget {
  const LoveTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            DefaultTextFormField(
              hintText: 'Search For Event',
              prefixIconImageName: 'search',
              onChanged: (query) {},
            ),
            SizedBox(height: 16),
            // Expanded(
            //   child: ListView.separated(
            //     itemBuilder: (_, index) => EventItem(),
            //     separatorBuilder: (_, _) => SizedBox(height: 16),
            //     itemCount: 20,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
