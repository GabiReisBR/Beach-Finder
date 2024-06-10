import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import '../models/beach.dart';
import '../beach_provider.dart';

const kGoogleApiKey = "AIzaSyDbRbLcJ26m3e-QL4Tuqlqug_DtyllxuBI";

class AddBeachPage extends StatefulWidget {
  @override
  _AddBeachPageState createState() => _AddBeachPageState();
}

class _AddBeachPageState extends State<AddBeachPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _location = '';
  String _description = '';
  String _imagePath = '';
  double _rating = 0;
  int _priceLevel = 1;
  bool _childrenFriendly = false;
  bool _surferFriendly = false;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _locationController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Praia'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detalhes da Praia',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nome da praia',
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
                GooglePlaceAutoCompleteTextField(
                  textEditingController: _locationController,
                  googleAPIKey: kGoogleApiKey,
                  inputDecoration: InputDecoration(
                    labelText: 'Localização',
                    border: OutlineInputBorder(),
                    prefixIcon:
                        Icon(Icons.location_on, color: Color(0xFFFD6A16)),
                    suffixIcon: Icon(Icons.search),
                  ),
                  debounceTime: 800,
                  countries: ["br"],
                  isLatLngRequired: true,
                  getPlaceDetailWithLatLng: (prediction) async {
                    final places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
                    final detail =
                        await places.getDetailsByPlaceId(prediction.placeId!);
                    final placeAddress = detail.result.formattedAddress;
                    setState(() {
                      _locationController.text = placeAddress!;
                      _location = placeAddress;
                    });
                  },
                  itemClick: (prediction) {
                    _locationController.text = prediction.description!;
                    _location = prediction.description!;
                    _locationController.selection = TextSelection.fromPosition(
                      TextPosition(offset: prediction.description!.length),
                    );
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Beach newBeach = Beach(
                          name: _name,
                          location: _location,
                          imagePath: _imagePath,
                          rating: _rating,
                          priceLevel: _priceLevel,
                          childrenFriendly: _childrenFriendly,
                          surferFriendly: _surferFriendly,
                          description: _description,
                        );
                        Provider.of<BeachProvider>(context, listen: false)
                            .addBeach(newBeach)
                            .then((_) {
                          Navigator.pop(context, true);
                        });
                      }
                    },
                    child: Text('Cadastrar',
                        style: TextStyle(color: Colors.white)),
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
