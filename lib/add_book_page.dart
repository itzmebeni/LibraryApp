import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart'; // Make sure this file contains the ApiService.addManga method

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  String author = '';
  String genre = 'Action';
  String status = 'Ongoing';
  int chapters = 0;
  int year = 0;
  bool isFavorite = false;

  File? _imageFile;
  final picker = ImagePicker();

  final genres = ['Action', 'Romance', 'Comedy', 'Fantasy', 'Horror', 'Sci-Fi'];
  final statuses = ['Ongoing', 'Completed', 'Hiatus'];
  final Color darkBlack = const Color(0xFF0D0D0D);
  final Color lightYellow = const Color(0xFFFFF176);

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlack,
      appBar: AppBar(
        title: Text('Add Your Manga', style: TextStyle(color: lightYellow)),
        backgroundColor: darkBlack,
        iconTheme: IconThemeData(color: lightYellow),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Fill out the details below to add your manga to the list.',
                style: TextStyle(color: lightYellow, fontSize: 14),
              ),
              const SizedBox(height: 16),

              Text(
                'Cover Image',
                style: TextStyle(color: lightYellow, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 150, fit: BoxFit.cover)
                  : Container(
                height: 150,
                color: Colors.grey[800],
                child: Center(
                  child: Text(
                    'No image selected',
                    style: TextStyle(color: Colors.white60),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.photo_library, color: lightYellow),
                label: Text('Select Image', style: TextStyle(color: lightYellow)),
              ),

              const SizedBox(height: 16),
              _buildTextField(
                label: 'Title',
                onSaved: (value) => title = value ?? '',
                validator: (value) => value!.isEmpty ? 'Please enter the title' : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Author',
                onSaved: (value) => author = value ?? '',
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                label: 'Genre',
                value: genre,
                items: genres,
                onChanged: (value) => setState(() => genre = value!),
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                label: 'Status',
                value: status,
                items: statuses,
                onChanged: (value) => setState(() => status = value!),
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Total Chapters',
                keyboardType: TextInputType.number,
                onSaved: (value) => chapters = int.tryParse(value ?? '0') ?? 0,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Year',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: lightYellow),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: lightYellow, width: 2),
                  ),
                ),
                dropdownColor: darkBlack,
                style: TextStyle(color: Colors.white),
                value: year > 0 ? year : null,
                items: List.generate(26, (index) {
                  int value = 2000 + index;
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value.toString()),
                  );
                }),
                validator: (value) => value == null ? 'Please select a year' : null,
                onChanged: (value) => setState(() => year = value ?? 0),
                onSaved: (value) => year = value ?? 0,
              ),

              const SizedBox(height: 12),
              SwitchListTile(
                title: Text(
                  'Mark as Favorite',
                  style: TextStyle(color: lightYellow),
                ),
                value: isFavorite,
                activeColor: lightYellow,
                onChanged: (value) {
                  setState(() {
                    isFavorite = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: lightYellow),
                      foregroundColor: lightYellow,
                    ),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        final manga = {
                          "title": title,
                          "author": author,
                          "genre": genre,
                          "status": status,
                          "year": year,
                          "chapters": chapters,
                          "image": _imageFile?.path ?? "",
                          "isFavorite": isFavorite
                        };

                        try {
                          await ApiService.addManga(manga);
                          Navigator.pop(context);
                        } catch (e) {
                          print('Failed to save manga: $e');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightYellow,
                      foregroundColor: darkBlack,
                    ),
                    child: Text('Save'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    FormFieldValidator<String>? validator,
    FormFieldSetter<String>? onSaved,
  }) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightYellow),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightYellow, width: 2),
        ),
        border: OutlineInputBorder(),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      dropdownColor: darkBlack,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightYellow),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightYellow, width: 2),
        ),
      ),
      value: value,
      items: items
          .map((item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
