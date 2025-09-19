import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';

/// Model for a story. A story has a title and a list of pages.
class Story {
  final String title;
  final List<String> pages;
  Story(this.title, this.pages);
}

/// Sample stories based on public domain fairy tales. In a real
/// application these would be loaded from a content pack and could
/// include audio narration and karaoke timing data.
final stories = [
  Story(
    'Scufița Roșie',
    [
      'Odată ca niciodată, într-un sătuc la marginea pădurii, trăia o fetiță pe care toți o numeau Scufița Roșie, pentru că purta mereu o pelerină roșie.',
      'Într-o zi, mama ei i-a dat un coșuleț cu bunătăți și i-a spus: "Du-te la bunica și du-i aceste bunătăți. Nu vorbi cu străinii și nu părăsi poteca!"',
      'Pe drum, Scufița Roșie s-a întâlnit cu lupul. Acesta, prefăcându-se prietenos, a aflat unde merge fetița și a pornit înainte spre casa bunicii.',
      'Lupul a ajuns primul, a mâncat bunica și s-a deghizat în ea. Când Scufița Roșie a sosit, a observat că bunica arată ciudat...',
      'Povestea continuă cu lupul și vânătorul și bineînțeles se termină cu un final fericit, dar asta o veți afla citind până la capăt!',
    ],
  ),
  Story(
    'Alba ca Zăpada',
    [
      'Alba ca Zăpada era o prințesă cu pielea albă ca zăpada, cu buzele roșii ca sângele și cu părul negru ca abanosul.',
      'Mama ei vitregă, regina, era geloasă pe frumusețea fetei și a ordonat unui vânător să o ducă în pădure și să o omoare.',
      'Vânătorul a lăsat-o să plece, iar Alba ca Zăpada a găsit o căsuță în pădure unde locuiau șapte pitici muncitori.',
      'Regina, aflând că Alba ca Zăpada trăiește, s-a deghizat și i-a oferit un măr otrăvit. Prințesa a căzut într-un somn adânc.',
      'Un prinț a găsit-o și, impresionat de frumusețea ei, i-a dat un sărut care a trezit-o. Au trăit fericiți până la adânci bătrâneți.',
    ],
  ),
];

/// Displays a list of stories and allows reading through each page.
class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<Story> _stories = stories;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _stories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForestBackground(
        child: Column(
          children: [
            RibbonBar(
              onHome: () => Navigator.popUntil(context, ModalRoute.withName('/')),
              onXylophone: () => Navigator.pushReplacementNamed(context, '/xylophone'),
              onDrums: () => Navigator.pushReplacementNamed(context, '/drums'),
              onSounds: () => Navigator.pushNamed(context, '/sounds'),
              onParents: () => Navigator.pushNamed(context, '/parents'),
            ),
            const SizedBox(height: 8),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.textDark,
              indicatorColor: AppColors.green,
              tabs: [for (var s in _stories) Tab(text: s.title)],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [for (var s in _stories) _StoryReader(story: s)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays pages of a story one at a time with navigation buttons.
class _StoryReader extends StatefulWidget {
  const _StoryReader({required this.story});
  final Story story;

  @override
  State<_StoryReader> createState() => _StoryReaderState();
}

class _StoryReaderState extends State<_StoryReader> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = widget.story.pages;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                pages[_pageIndex],
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _pageIndex > 0
                    ? () => setState(() => _pageIndex--)
                    : null,
              ),
              Text('Pagina ${_pageIndex + 1} / ${pages.length}'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _pageIndex < pages.length - 1
                    ? () => setState(() => _pageIndex++)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // TODO: play narration audio in future
            },
            child: const Text('Redă audio (neimplementat)'),
          ),
        ],
      ),
    );
  }
}