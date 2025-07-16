import 'package:flutter/material.dart';

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
  bool isFavorite = false;

  final genres = ['Action', 'Romance', 'Comedy', 'Fantasy', 'Horror', 'Sci-Fi'];
  final statuses = ['Ongoing', 'Completed', 'Hiatus'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Add Book', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.yellow),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                label: 'Title',
                onSaved: (value) => title = value ?? '',
                validator: (value) =>
                value!.isEmpty ? 'Please enter the title' : null,
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
                onSaved: (value) =>
                chapters = int.tryParse(value ?? '0') ?? 0,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: Text(
                  'Mark as Favorite',
                  style: TextStyle(color: Colors.white),
                ),
                value: isFavorite,
                activeColor: Colors.yellow,
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
                      side: BorderSide(color: Colors.yellow),
                      foregroundColor: Colors.yellow,
                    ),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print('Book Added: $title by $author');
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
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
          borderSide: BorderSide(color: Colors.yellow),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow, width: 2),
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
      dropdownColor: Colors.grey[900],
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow, width: 2),
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
