import 'package:flutter/material.dart';

class CustomDrawerDropdownButton2 extends StatelessWidget {
  const CustomDrawerDropdownButton2({
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.onChanged,
    this.icon,
    super.key,
  });
  final String hint;
  final String? value;
  final List<String> dropdownItems;
  final ValueChanged<String?>? onChanged;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),  // Adjusted the padding
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            'Select Item',textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color:Colors.white,fontSize: 20, fontWeight: FontWeight.bold,),
            overflow: TextOverflow.ellipsis,
          ),
          items: dropdownItems
              .map((String item) => DropdownMenuItem<String>(
            value: item,
            child: Align(alignment: Alignment.centerRight,
              child: Text(
                item,textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,  // Update the color to black or your preference
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ))
              .toList(),
          value: value,
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,  // Set color to match your theme
          ),borderRadius: BorderRadius.circular(14),

        ),
      ),
    );
  }
}
