import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/beach.dart';
import '../widgets/beach_card.dart';
import 'add_beach_page.dart';
import '../beach_provider.dart';
import 'beach_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchText = "";
  String _selectedRatingFilter = "Nenhum";
  String _selectedPriceFilter = "Nenhum";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beach Finder'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Pesquisar praias...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedRatingFilter,
                        decoration: InputDecoration(
                          labelText: 'Avaliação',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                              value: "Nenhum", child: Text("Nenhum")),
                          DropdownMenuItem(
                              value: "Maior avaliação",
                              child: Text("Maior avaliação")),
                          DropdownMenuItem(
                              value: "Menor avaliação",
                              child: Text("Menor avaliação")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedRatingFilter = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedPriceFilter,
                        decoration: InputDecoration(
                          labelText: 'Preço',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                              value: "Nenhum", child: Text("Nenhum")),
                          DropdownMenuItem(
                              value: "Mais caro", child: Text("Mais caro")),
                          DropdownMenuItem(
                              value: "Mais barato", child: Text("Mais barato")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedPriceFilter = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<BeachProvider>(
              builder: (context, beachProvider, child) {
                var beaches = beachProvider.beaches.where((beach) {
                  return beach.name
                      .toLowerCase()
                      .contains(_searchText.toLowerCase());
                }).toList();

                if (_selectedRatingFilter == "Maior avaliação") {
                  beaches.sort((a, b) => b.rating.compareTo(a.rating));
                } else if (_selectedRatingFilter == "Menor avaliação") {
                  beaches.sort((a, b) => a.rating.compareTo(b.rating));
                }

                if (_selectedPriceFilter == "Mais caro") {
                  beaches.sort((a, b) => b.priceLevel.compareTo(a.priceLevel));
                } else if (_selectedPriceFilter == "Mais barato") {
                  beaches.sort((a, b) => a.priceLevel.compareTo(b.priceLevel));
                }

                if (beaches.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhuma praia cadastrada',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: beaches.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Stack(
                        children: [
                          BeachCard(beach: beaches[index]),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirmed = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Confirmar Exclusão'),
                                    content: Text(
                                        'Você tem certeza que deseja excluir esta praia?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text('Excluir'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmed) {
                                  Provider.of<BeachProvider>(context,
                                          listen: false)
                                      .deleteBeach(beaches[index].id!);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? beachAdded = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBeachPage()),
          );
          if (beachAdded == true) {
            Provider.of<BeachProvider>(context, listen: false).loadBeaches();
          }
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFFFD6A16), // Cor de fundo laranja
      ),
    );
  }
}
