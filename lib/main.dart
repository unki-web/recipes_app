import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const RecipesApp());

// ───────────────────────── Модель и данные ─────────────────────────

class Recipe {
  final String id, title, category, emoji;
  final int minutes;
  final Color color;
  final String? imageUrl; // необязательно: ссылка на фото
  final List<String> ingredients, steps;
  const Recipe(this.id, this.title, this.category, this.minutes, this.emoji,
      this.color, this.ingredients, this.steps,
      {this.imageUrl});
}

const categories = ['Завтрак', 'Обед', 'Десерты'];

const recipes = <Recipe>[
  Recipe('1', 'Сырники', 'Завтрак', 25, '🥞', Color(0xFFF2C14E), [
    '500 г творога', '2 яйца', '4 ст. л. сахара', '5 ст. л. муки', 'Щепотка соли', 'Масло для жарки'
  ], [
    'Разомните творог вилкой, добавьте яйца, сахар и соль.',
    'Всыпьте муку и замесите густое тесто.',
    'Сформируйте небольшие лепёшки и обваляйте в муке.',
    'Обжарьте на среднем огне по 3 минуты с каждой стороны.'
  ]),
  Recipe('2', 'Овсянка с ягодами', 'Завтрак', 10, '🥣', Color(0xFFB784A7), [
    '60 г хлопьев', '200 мл молока', 'Горсть ягод', '1 ч. л. мёда'
  ], [
    'Доведите молоко до кипения и всыпьте хлопья.',
    'Варите 5 минут, помешивая.',
    'Добавьте ягоды и мёд.'
  ]),
  Recipe('3', 'Омлет с помидорами', 'Завтрак', 12, '🍳', Color(0xFFE76F51), [
    '3 яйца', '1 помидор', '50 мл молока', 'Зелень', 'Соль, перец'
  ], [
    'Взбейте яйца с молоком, солью и перцем.',
    'Нарежьте помидор кубиками и обжарьте минуту.',
    'Залейте яичной смесью и готовьте под крышкой 5 минут.',
    'Посыпьте зеленью.'
  ]),
  Recipe('4', 'Борщ', 'Обед', 90, '🍲', Color(0xFFC1121F), [
    '400 г говядины', '2 свеклы', '3 картофелины', '1/4 капусты', '1 морковь', '1 луковица', '2 ст. л. томатной пасты', 'Сметана'
  ], [
    'Сварите бульон из говядины около часа.',
    'Обжарьте лук, морковь и свёклу, добавьте томатную пасту.',
    'Положите в бульон картофель, через 10 минут — капусту.',
    'Добавьте зажарку и варите ещё 10 минут.',
    'Подавайте со сметаной.'
  ]),
  Recipe('5', 'Паста карбонара', 'Обед', 25, '🍝', Color(0xFFE9A23B), [
    '200 г спагетти', '100 г бекона', '2 желтка', '50 г пармезана', 'Чёрный перец'
  ], [
    'Отварите спагетти до состояния аль денте.',
    'Обжарьте бекон до хруста.',
    'Смешайте желтки с тёртым пармезаном и перцем.',
    'Соедините горячую пасту с беконом, снимите с огня и перемешайте с соусом.'
  ]),
  Recipe('6', 'Куриный суп с лапшой', 'Обед', 45, '🍜', Color(0xFFF4A261), [
    '500 г куриных бёдер', '100 г лапши', '1 морковь', '1 луковица', '2 картофелины', 'Лавровый лист'
  ], [
    'Сварите курицу с луком и лавровым листом 30 минут.',
    'Добавьте нарезанные морковь и картофель.',
    'За 5 минут до готовности положите лапшу.'
  ]),
  Recipe('7', 'Шоколадный брауни', 'Десерты', 40, '🍫', Color(0xFF6F4E37), [
    '150 г тёмного шоколада', '120 г сливочного масла', '150 г сахара', '3 яйца', '80 г муки', 'Щепотка соли'
  ], [
    'Растопите шоколад с маслом и слегка остудите.',
    'Взбейте яйца с сахаром и соедините с шоколадной массой.',
    'Добавьте муку и соль, перемешайте.',
    'Выпекайте при 180 °C около 25 минут.'
  ]),
  Recipe('8', 'Панна котта', 'Десерты', 20, '🍮', Color(0xFFE56B8A), [
    '400 мл сливок', '60 г сахара', '1 ч. л. ванили', '8 г желатина', 'Ягодный соус'
  ], [
    'Замочите желатин в холодной воде на 10 минут.',
    'Прогрейте сливки с сахаром и ванилью, не доводя до кипения.',
    'Добавьте желатин и разлейте по формам.',
    'Охлаждайте минимум 4 часа, подавайте с ягодным соусом.'
  ]),
];

// ───────────────────────── Приложение ─────────────────────────

class RecipesApp extends StatefulWidget {
  const RecipesApp({super.key});
  @override
  State<RecipesApp> createState() => _RecipesAppState();
}

class _RecipesAppState extends State<RecipesApp> {
  static const _key = 'favorites';
  final Set<String> favorites = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => favorites.addAll(prefs.getStringList(_key) ?? []));
  }

  Future<void> toggleFavorite(String id) async {
    setState(() => favorites.contains(id) ? favorites.remove(id) : favorites.add(id));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, favorites.toList());
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2F6B4F);
    return MaterialApp(
      title: 'Рецепты',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        scaffoldBackgroundColor: const Color(0xFFF7F8F6),
      ),
      home: HomeScreen(favorites: favorites, onToggle: toggleFavorite),
    );
  }
}

// ───────────────────────── Главный экран ─────────────────────────

class HomeScreen extends StatefulWidget {
  final Set<String> favorites;
  final void Function(String) onToggle;
  const HomeScreen({super.key, required this.favorites, required this.onToggle});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = '';
  String? category; // null — все
  bool onlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    final list = recipes.where((r) {
      final q = query.trim().toLowerCase();
      return (category == null || r.category == category) &&
          (!onlyFavorites || widget.favorites.contains(r.id)) &&
          (q.isEmpty || r.title.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Что приготовим?',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (v) => setState(() => query = v),
                  decoration: InputDecoration(
                    hintText: 'Название блюда',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
                ),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _chip('Все', category == null && !onlyFavorites, () => setState(() {
                        category = null;
                        onlyFavorites = false;
                      })),
                  for (final c in categories)
                    _chip(c, category == c, () => setState(() => category = category == c ? null : c)),
                  _chip('♥ Избранное', onlyFavorites, () => setState(() => onlyFavorites = !onlyFavorites)),
                ],
              ),
            ),
          ),
          if (list.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  onlyFavorites ? 'Нажмите на сердечко у рецепта,\nчтобы добавить его сюда' : 'Ничего не найдено.\nПопробуйте другое название или категорию',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 240,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.78,
                ),
                itemCount: list.length,
                itemBuilder: (_, i) => _RecipeCard(
                  recipe: list[i],
                  isFav: widget.favorites.contains(list[i].id),
                  onFav: () {
                    widget.onToggle(list[i].id);
                    setState(() {});
                  },
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(
                        recipe: list[i],
                        isFav: () => widget.favorites.contains(list[i].id),
                        onToggle: () => widget.onToggle(list[i].id),
                      ),
                    ),
                  ).then((_) => setState(() {})),
                ),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ChoiceChip(label: Text(label), selected: selected, onSelected: (_) => onTap()),
      );
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isFav;
  final VoidCallback onFav, onTap;
  const _RecipeCard({required this.recipe, required this.isFav, required this.onFav, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Stack(fit: StackFit.expand, children: [
              Hero(tag: 'cover-${recipe.id}', child: Cover(recipe: recipe, emojiSize: 56)),
              Positioned(
                top: 6,
                right: 6,
                child: IconButton.filledTonal(
                  onPressed: onFav,
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : null),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(recipe.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.schedule, size: 15),
                const SizedBox(width: 4),
                Text('${recipe.minutes} мин'),
                const Spacer(),
                Text(recipe.category, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// Обложка: фото по ссылке, а если ссылки нет или она не загрузилась — цвет и эмодзи.
class Cover extends StatelessWidget {
  final Recipe recipe;
  final double emojiSize;
  const Cover({super.key, required this.recipe, required this.emojiSize});

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: recipe.color.withOpacity(0.28),
      alignment: Alignment.center,
      child: Text(recipe.emoji, style: TextStyle(fontSize: emojiSize)),
    );
    if (recipe.imageUrl == null) return fallback;
    return Image.network(recipe.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => fallback);
  }
}

// ───────────────────────── Детальный экран ─────────────────────────

class DetailScreen extends StatefulWidget {
  final Recipe recipe;
  final bool Function() isFav;
  final VoidCallback onToggle;
  const DetailScreen({super.key, required this.recipe, required this.isFav, required this.onToggle});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final Set<int> checked = {};

  @override
  Widget build(BuildContext context) {
    final r = widget.recipe;
    final fav = widget.isFav();
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 280,
          actions: [
            IconButton(
              icon: Icon(fav ? Icons.favorite : Icons.favorite_border, color: fav ? Colors.red : null),
              onPressed: () {
                widget.onToggle();
                setState(() {});
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(tag: 'cover-${r.id}', child: Cover(recipe: r, emojiSize: 110)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(r.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, children: [
                Chip(avatar: const Icon(Icons.schedule, size: 18), label: Text('${r.minutes} мин')),
                Chip(label: Text(r.category)),
              ]),
              const SizedBox(height: 16),
              Text('Ингредиенты', style: Theme.of(context).textTheme.titleLarge),
              for (var i = 0; i < r.ingredients.length; i++)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: checked.contains(i),
                  onChanged: (v) => setState(() => v! ? checked.add(i) : checked.remove(i)),
                  title: Text(
                    r.ingredients[i],
                    style: TextStyle(
                      decoration: checked.contains(i) ? TextDecoration.lineThrough : null,
                      color: checked.contains(i) ? Colors.grey : null,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Text('Приготовление', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              for (var i = 0; i < r.steps.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    CircleAvatar(radius: 14, child: Text('${i + 1}', style: const TextStyle(fontSize: 13))),
                    const SizedBox(width: 12),
                    Expanded(child: Text(r.steps[i], style: const TextStyle(fontSize: 16, height: 1.4))),
                  ]),
                ),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ]),
    );
  }
}