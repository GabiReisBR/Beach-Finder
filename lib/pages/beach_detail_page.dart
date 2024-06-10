import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/beach.dart';
import '../beach_provider.dart';

class BeachDetailPage extends StatefulWidget {
  final Beach beach;

  BeachDetailPage({required this.beach});

  @override
  _BeachDetailPageState createState() => _BeachDetailPageState();
}

class _BeachDetailPageState extends State<BeachDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _location;
  late String _description;
  late String _imagePath;
  late double _rating;
  late int _priceLevel;
  late bool _childrenFriendly;
  late bool _surferFriendly;

  final ImagePicker _picker = ImagePicker();
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _name = widget.beach.name;
    _location = widget.beach.location;
    _description = widget.beach.description;
    _imagePath = widget.beach.imagePath;
    _rating = widget.beach.rating;
    _priceLevel = widget.beach.priceLevel;
    _childrenFriendly = widget.beach.childrenFriendly;
    _surferFriendly = widget.beach.surferFriendly;
    _locationController = TextEditingController(text: _location);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _saveBeach() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Beach updatedBeach = Beach(
        id: widget.beach.id,
        name: _name,
        location: _location,
        description: _description,
        imagePath: _imagePath,
        rating: _rating,
        priceLevel: _priceLevel,
        childrenFriendly: _childrenFriendly,
        surferFriendly: _surferFriendly,
      );
      Provider.of<BeachProvider>(context, listen: false)
          .updateBeach(updatedBeach);
      Navigator.pop(context);
    }
  }

  void _deleteBeach() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Você tem certeza que deseja excluir esta praia?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed) {
      Provider.of<BeachProvider>(context, listen: false)
          .deleteBeach(widget.beach.id!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Praia'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteBeach,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                    prefixIcon:
                        Icon(Icons.beach_access, color: Color(0xFFFD6A16)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o nome';
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value!,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Localização',
                    border: OutlineInputBorder(),
                    prefixIcon:
                        Icon(Icons.location_on, color: Color(0xFFFD6A16)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira a localização';
                    }
                    return null;
                  },
                  onSaved: (value) => _location = value!,
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                    prefixIcon:
                        Icon(Icons.description, color: Color(0xFFFD6A16)),
                  ),
                  maxLines: 3,
                  onSaved: (value) => _description = value!,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _imagePath.isEmpty
                          ? Text(
                              'Nenhuma imagem selecionada',
                              style: TextStyle(color: Colors.red),
                            )
                          : Image.file(File(_imagePath), height: 150),
                    ),
                    IconButton(
                      icon: Icon(Icons.photo_library, color: Color(0xFFFD6A16)),
                      onPressed: _pickImage,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text('Avaliação'),
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.orange,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                SizedBox(height: 16),
                Text('Preço Médio'),
                DropdownButtonFormField<int>(
                  value: _priceLevel,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon:
                        Icon(Icons.attach_money, color: Color(0xFFFD6A16)),
                  ),
                  items: [1, 2, 3, 4, 5]
                      .map((level) => DropdownMenuItem(
                            value: level,
                            child: Text(level.toString()),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() {
                    _priceLevel = value!;
                  }),
                ),
                SizedBox(height: 16),
                CheckboxListTile(
                  title: Text('Apropriado para crianças'),
                  value: _childrenFriendly,
                  activeColor: Color(0xFFFD6A16),
                  onChanged: (value) {
                    setState(() {
                      _childrenFriendly = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Apropriado para surfistas'),
                  value: _surferFriendly,
                  activeColor: Color(0xFFFD6A16),
                  onChanged: (value) {
                    setState(() {
                      _surferFriendly = value!;
                    });
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFFFD6A16), // Cor de fundo laranja
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _saveBeach,
                    child:
                        Text('Salvar', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
