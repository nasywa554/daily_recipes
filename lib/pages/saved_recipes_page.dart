import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'recipe_detail_page.dart'; // Pastikan untuk mengimpor halaman detail resep

class SavedRecipesPage extends StatefulWidget {
  @override
  _SavedRecipesPageState createState() => _SavedRecipesPageState();
}

class _SavedRecipesPageState extends State<SavedRecipesPage> {
  List<Map<String, dynamic>> savedRecipes = [];

  @override
  void initState() {
    super.initState();
    _fetchSavedRecipes(); // Ambil data resep yang disimpan saat halaman dibuka
  }

  Future<void> _fetchSavedRecipes() async {
    final response = await Supabase.instance.client
        .from('saved_recipes') // Ganti dengan nama tabel Anda
        .select('id_recipe, id_user');

    // if (response.error == null) {
    final List<dynamic> savedRecipeData = response; // Ambil data dari response
    for (var item in savedRecipeData) {
      final recipeResponse = await Supabase.instance.client
          .from('recipes') // Ganti dengan nama tabel resep Anda
          .select('*') // Ambil semua kolom
          .eq('id', item['id_recipe']);

      // if (recipeResponse.error == null && recipeResponse.data.isNotEmpty) {
      savedRecipes.add(recipeResponse[0]); // Tambahkan resep ke list
      // }
    }
    setState(() {}); // Memperbarui UI setelah data diambil
    // } else {
    //   print('Error fetching saved recipes: ${response.error!.message}');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Recipes'),
      ),
      body: savedRecipes.isEmpty
          ? Center(
              child: Text(
                  'No saved recipes found.')) // Menampilkan pesan jika tidak ada resep yang disimpan
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Jumlah kolom
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: savedRecipes.length,
              itemBuilder: (context, index) {
                final recipe = savedRecipes[index];
                return GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman detail resep saat resep tersimpan diklik
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(
                          title: recipe['title'],
                          imageUrl: recipe['image_url'],
                          cookingTime: recipe['cooking_time'],
                          servings: recipe['servings'],
                          ingredients: recipe['ingredients'],
                          instructions: recipe['instructions'],
                          recipeId: recipe['id'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.network(
                            recipe['image_url'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe['title'],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Cooking Time: ${recipe['cooking_time']} mins',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Servings: ${recipe['servings']}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
