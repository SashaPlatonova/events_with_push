import 'package:flutter_app/presentation/routes/routes.dart';
import 'package:flutter_app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: AppTheme.borderPurple);
    final styleHint = AppTheme.searchString;
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return Row(
      children: [
        Container(
            margin: const EdgeInsets.fromLTRB(0,23,0,0),
            child: const Icon(Icons.arrow_back, color: AppTheme.borderPurple))
            .addRipple(
          onTap: () => Navigator.pushNamed(context, PagePath.base),
        ),
        SizedBox(
          width: 350,
          child: Container(
            height: 40,
            margin: const EdgeInsets.fromLTRB(16,40,16,16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
              border: Border.all(color: AppTheme.borderPurple),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: AppTheme.borderPurple),
                suffixIcon: widget.text.isNotEmpty
                    ? GestureDetector(
                  child: Icon(Icons.close, color: AppTheme.borderPurple),
                  onTap: () {
                    controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
                    : null,
                hintText: widget.hintText,
                hintStyle: style,
                border: InputBorder.none,
              ),
              style: style,
              onChanged: widget.onChanged,
            ),
          ),
        ),
      ],
    );
  }
}