import 'package:material_ui/material_ui.dart';

const red = Color(0xFFB91F35);
const wine = Color(0xFF590E20);
const ink = Color(0xFF2F1820);
const muted = Color(0xFF765C62);
const blush = Color(0xFFFFF1F2);
const paper = Color(0xFFFFF9F7);

void main() => runApp(const GroceryApp());

class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: red).copyWith(
          primary: red,
          onPrimary: Colors.white,
          secondaryContainer: blush,
          onSecondaryContainer: wine,
          surface: Colors.white,
          onSurface: ink,
        ),
        scaffoldBackgroundColor: paper,
        useMaterial3: true,
      ),
      home: const Pantry(),
    );
  }
}

class Grocery {
  const Grocery(this.name, this.category, this.unit, this.symbol, this.color);
  final String name;
  final String category;
  final String unit;
  final String symbol;
  final Color color;
}

const groceries = [
  Grocery('Strawberries', 'Produce', '1 punnet', '🍓', Color(0xFFFFE5E8)),
  Grocery('Avocados', 'Produce', '2 pieces', '🥑', Color(0xFFE8F1DC)),
  Grocery('Whole milk', 'Dairy & eggs', '1 litre', '🥛', Color(0xFFE8F0F8)),
  Grocery('Sourdough', 'Bakery', '1 loaf', '🍞', Color(0xFFFFEFD7)),
  Grocery('Carrots', 'Produce', '1 bunch', '🥕', Color(0xFFFFE6D5)),
  Grocery('Free-range eggs', 'Dairy & eggs', '6 eggs', '🥚', Color(0xFFFFEEDC)),
  Grocery('Basmati rice', 'Pantry', '1 bag', '🍚', Color(0xFFF4EDE3)),
  Grocery('Honey', 'Pantry', '1 jar', '🍯', Color(0xFFFFEDC6)),
];

const sections = ['Overview', 'Groceries', 'Shopping list'];
const destinations = [
  Icons.space_dashboard_outlined,
  Icons.grid_view_rounded,
  Icons.checklist_rounded,
];
const categories = ['All', 'Produce', 'Dairy & eggs', 'Bakery', 'Pantry'];

class Pantry extends StatefulWidget {
  const Pantry({super.key});

  @override
  State<Pantry> createState() => _PantryState();
}

class _PantryState extends State<Pantry> {
  int section = 0;
  String category = 'All';
  final search = TextEditingController();
  final shopping = <Grocery>{groceries[0], groceries[2], groceries[3]};
  final pickedUp = <Grocery>{};

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  void toggleItem(Grocery item) {
    setState(() {
      if (shopping.remove(item)) {
        pickedUp.remove(item);
      } else {
        shopping.add(item);
      }
    });
  }

  void openItem(Grocery item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Grocery details')),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 220,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: item.color,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Text(
                        item.symbol,
                        style: const TextStyle(fontSize: 92),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(item.category, style: const TextStyle(color: red)),
                    Heading(item.name, item.unit),
                    FilledButton.icon(
                      onPressed: () {
                        toggleItem(item);
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        shopping.contains(item) ? Icons.remove : Icons.add,
                      ),
                      label: Text(
                        shopping.contains(item)
                            ? 'Remove from shopping list'
                            : 'Add to shopping list',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 780;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (wide)
              NavigationRail(
                backgroundColor: Colors.white,
                extended: true,
                minExtendedWidth: 218,
                leading: const Padding(
                  padding: EdgeInsets.fromLTRB(18, 20, 18, 30),
                  child: Brand(),
                ),
                selectedIndex: section,
                onDestinationSelected: (value) =>
                    setState(() => section = value),
                destinations: [
                  for (var i = 0; i < sections.length; i++)
                    NavigationRailDestination(
                      icon: Icon(destinations[i]),
                      label: Text(sections[i]),
                    ),
                ],
              ),
            Expanded(
              child: SingleChildScrollView(
                key: PageStorageKey(section),
                padding: EdgeInsets.fromLTRB(
                  wide ? 40 : 20,
                  24,
                  wide ? 40 : 20,
                  32,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!wide) ...[
                          const Brand(),
                          const SizedBox(height: 28),
                        ],
                        ...switch (section) {
                          0 => overview(),
                          1 => catalog(),
                          _ => shoppingList(),
                        },
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: section,
              onDestinationSelected: (value) => setState(() => section = value),
              destinations: [
                for (var i = 0; i < sections.length; i++)
                  NavigationDestination(
                    icon: Icon(destinations[i]),
                    label: sections[i],
                  ),
              ],
            ),
    );
  }

  List<Widget> overview() => [
    const Heading(
      'Pantry overview',
      'See what’s in your grocery list and plan your next shop.',
    ),
    Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(colors: [wine, red]),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your next shop',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${shopping.length - pickedUp.length} items left to pick up',
                  style: const TextStyle(
                    color: Color(0xFFFFD8DC),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: wine,
                  ),
                  onPressed: () => setState(() => section = 2),
                  child: const Text('View shopping list'),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.shopping_basket_rounded,
            size: 76,
            color: Color(0xFFFFB7C2),
          ),
        ],
      ),
    ),
    const SizedBox(height: 24),
    Row(
      children: [
        Expanded(
          child: Stat(
            Icons.inventory_2_outlined,
            '${groceries.length}',
            'Grocery items',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Stat(
            Icons.check_circle_outline,
            '${pickedUp.length}',
            'Picked up',
          ),
        ),
      ],
    ),
    const SizedBox(height: 22),
    Row(
      children: [
        const Expanded(
          child: Text(
            'Browse groceries',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
          ),
        ),
        TextButton(
          onPressed: () => setState(() {
            section = 1;
            category = 'All';
            search.clear();
          }),
          child: const Text('View all'),
        ),
      ],
    ),
    for (final item in groceries.take(4)) groceryRow(item),
  ];

  List<Widget> catalog() {
    final query = search.text.trim().toLowerCase();
    final matches = groceries.where(
      (item) =>
          (category == 'All' || item.category == category) &&
          item.name.toLowerCase().contains(query),
    );
    return [
      const Heading(
        'Groceries',
        'Browse your grocery catalog and add items to your shopping list.',
      ),
      TextField(
        controller: search,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search groceries',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: search.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  onPressed: () => setState(search.clear),
                  icon: const Icon(Icons.close),
                ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFF0DDE0)),
          ),
        ),
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          for (final label in categories)
            ChoiceChip(
              label: Text(label),
              selected: category == label,
              onSelected: (_) => setState(() => category = label),
            ),
        ],
      ),
      const SizedBox(height: 18),
      if (matches.isEmpty)
        const EmptyState(
          Icons.search_off,
          'No matching groceries',
          'Try another search or category.',
        ),
      for (final item in matches) groceryRow(item),
    ];
  }

  List<Widget> shoppingList() {
    final total = shopping.length;
    final done = pickedUp.length;
    return [
      const Heading('Shopping list', 'Check off items as you pick them up.'),
      if (total == 0)
        const EmptyState(
          Icons.shopping_basket_outlined,
          'Your list is empty',
          'Add items from the Groceries screen.',
        )
      else ...[
        Surface(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$done of $total picked up',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: done / total,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (final item in shopping)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Surface(
              child: ListTile(
                leading: Checkbox(
                  semanticLabel: 'Picked up ${item.name}',
                  value: pickedUp.contains(item),
                  onChanged: (value) => setState(() {
                    if (value == true) {
                      pickedUp.add(item);
                    } else {
                      pickedUp.remove(item);
                    }
                  }),
                ),
                title: Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    decoration: pickedUp.contains(item)
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                subtitle: Text(item.unit),
                trailing: IconButton(
                  tooltip: 'Remove ${item.name}',
                  onPressed: () => toggleItem(item),
                  icon: const Icon(Icons.close),
                ),
                onTap: () => openItem(item),
              ),
            ),
          ),
      ],
    ];
  }

  Widget groceryRow(Grocery item) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Surface(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Text(item.symbol, style: const TextStyle(fontSize: 25)),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${item.category} · ${item.unit}',
          style: const TextStyle(color: muted),
        ),
        trailing: IconButton(
          tooltip: shopping.contains(item)
              ? 'Remove ${item.name}'
              : 'Add ${item.name}',
          onPressed: () => toggleItem(item),
          style: IconButton.styleFrom(
            backgroundColor: blush,
            foregroundColor: red,
          ),
          icon: Icon(shopping.contains(item) ? Icons.check : Icons.add),
        ),
        onTap: () => openItem(item),
      ),
    ),
  );
}

class Brand extends StatelessWidget {
  const Brand({super.key});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: wine,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.shopping_basket_outlined,
          color: Colors.white,
          size: 21,
        ),
      ),
      const SizedBox(width: 9),
      const Text(
        'Grocery Management',
        style: TextStyle(fontWeight: FontWeight.w800, color: wine),
      ),
    ],
  );
}

class Heading extends StatelessWidget {
  const Heading(this.title, this.description, {super.key});
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: wine,
          ),
        ),
        const SizedBox(height: 5),
        Text(description, style: const TextStyle(fontSize: 15, color: muted)),
      ],
    ),
  );
}

class Surface extends StatelessWidget {
  const Surface({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: Color(0xFFF0DDE0)),
    ),
    clipBehavior: Clip.antiAlias,
    child: child,
  );
}

class Stat extends StatelessWidget {
  const Stat(this.icon, this.value, this.label, {super.key});
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Surface(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: red),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          Text(label, style: const TextStyle(color: muted)),
        ],
      ),
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState(this.icon, this.title, this.message, {super.key});
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Surface(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(icon, color: red, size: 32),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: muted),
          ),
        ],
      ),
    ),
  );
}
