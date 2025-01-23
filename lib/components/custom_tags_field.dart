import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTagsField extends StatefulWidget {
  final List<String> availableTags;
  final List<String> selectedTags;
  final String hintText;
  final String labelText;
  final bool isRequired;
  final Function(List<String>) onTagsUpdated;

  const CustomTagsField({
    Key? key,
    required this.availableTags,
    this.selectedTags = const [],
    required this.hintText,
    required this.labelText,
    this.isRequired = false,
    required this.onTagsUpdated,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomTagsFieldState createState() => _CustomTagsFieldState();
}

class _CustomTagsFieldState extends State<CustomTagsField> {
  final TextEditingController _tagController = TextEditingController();
  late List<String> _selectedTags;

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.selectedTags);
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.add(tag);
      });
      widget.onTagsUpdated(_selectedTags);
    }
    _tagController.clear();
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
    widget.onTagsUpdated(_selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          widget.labelText,
          style: GoogleFonts.karla(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 0.75,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),

        // Dropdown for selecting tags with a bordered container
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: const Color.fromARGB(255, 43, 51, 63), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          child: DropdownButton<String>(
            value: null,
            isExpanded: true,
            underline: const SizedBox(),
            hint: const Text(
              "Select a Tag",
              style: TextStyle(color: Colors.white),
            ),
            dropdownColor: const Color.fromARGB(255, 43, 51, 63),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              letterSpacing: 0.75,
              fontWeight: FontWeight.w400,
            ),
            items: widget.availableTags
                .where((tag) => !_selectedTags.contains(tag))
                .map((tag) {
              return DropdownMenuItem(
                value: tag,
                child: Text(tag),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                _addTag(value);
              }
            },
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _selectedTags.map((tag) {
            return Chip(
              label: Text(tag),
              backgroundColor: const Color.fromARGB(255, 43, 51, 63),
              labelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                letterSpacing: 0.75,
                fontWeight: FontWeight.w400,
              ),
              deleteIcon: const Icon(
                Icons.close,
                color: Colors.red,
                size: 12,
              ),
              onDeleted: () => _removeTag(tag),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
