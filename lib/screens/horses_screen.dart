import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../services/storage_service.dart';
import '../models/horse.dart';
import '../models/analysis_result.dart';
import '../widgets/horse_card.dart';
import 'analysis_result_screen.dart';

class HorsesScreen extends StatefulWidget {
  const HorsesScreen({super.key});

  @override
  State<HorsesScreen> createState() => _HorsesScreenState();
}

class _HorsesScreenState extends State<HorsesScreen> {
  List<Horse> _horses = [];
  Map<String, List<AnalysisResult>> _horseAnalyses = {};
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadHorses();
  }

  Future<void> _loadHorses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final horses = await StorageService.instance.getHorses();
      final Map<String, List<AnalysisResult>> analyses = {};

      for (final horse in horses) {
        final horseAnalyses = await StorageService.instance
            .getAnalysisResultsForHorse(horse.id);
        analyses[horse.id] = horseAnalyses;
      }

      if (mounted) {
        setState(() {
          _horses = horses;
          _horseAnalyses = analyses;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load horses: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _showAddHorseDialog([Horse? horse]) async {
    final result = await showDialog<Horse>(
      context: context,
      builder: (context) => AddEditHorseDialog(horse: horse),
    );

    if (result != null) {
      try {
        await StorageService.instance.saveHorse(result);
        await _loadHorses();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.successHorseSaved),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save horse: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteHorse(Horse horse) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Horse'),
        content: Text('Are you sure you want to delete ${horse.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await StorageService.instance.deleteHorse(horse.id);
        await _loadHorses();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${horse.name} has been deleted'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete horse: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  List<Horse> get _filteredHorses {
    if (_searchQuery.isEmpty) return _horses;
    return _horses.where((horse) =>
        horse.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        horse.breed.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        horse.color.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('My Horses'),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddHorseDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search horses...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _filteredHorses.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadHorses,
                        color: AppColors.primary,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredHorses.length,
                          itemBuilder: (context, index) {
                            final horse = _filteredHorses[index];
                            final analyses = _horseAnalyses[horse.id] ?? [];
                            
                            return HorseCard(
                              horse: horse,
                              analyses: analyses,
                              onTap: () => _showHorseDetails(horse, analyses),
                              onEdit: () => _showAddHorseDialog(horse),
                              onDelete: () => _deleteHorse(horse),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHorseDialog(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.pets,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No horses yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your first horse to start tracking their dental health',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddHorseDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Add Horse'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHorseDetails(Horse horse, List<AnalysisResult> analyses) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => HorseDetailsSheet(
        horse: horse,
        analyses: analyses,
        onEdit: () {
          Navigator.pop(context);
          _showAddHorseDialog(horse);
        },
        onDelete: () {
          Navigator.pop(context);
          _deleteHorse(horse);
        },
      ),
    );
  }
}

class AddEditHorseDialog extends StatefulWidget {
  final Horse? horse;

  const AddEditHorseDialog({super.key, this.horse});

  @override
  State<AddEditHorseDialog> createState() => _AddEditHorseDialogState();
}

class _AddEditHorseDialogState extends State<AddEditHorseDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _breedController;
  late final TextEditingController _ageController;
  late final TextEditingController _colorController;
  late final TextEditingController _notesController;

  final List<String> _commonBreeds = [
    'Arabian', 'Thoroughbred', 'Quarter Horse', 'Paint Horse', 'Appaloosa',
    'Morgan', 'Standardbred', 'Tennessee Walking Horse', 'Mustang', 'Clydesdale',
    'Friesian', 'Andalusian', 'Haflinger', 'Welsh Pony', 'Shetland Pony',
    'Mixed Breed', 'Other'
  ];

  final List<String> _commonColors = [
    'Bay', 'Chestnut', 'Black', 'Brown', 'Gray', 'White', 'Palomino',
    'Buckskin', 'Dun', 'Roan', 'Pinto', 'Appaloosa', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.horse?.name ?? '');
    _breedController = TextEditingController(text: widget.horse?.breed ?? '');
    _ageController = TextEditingController(
      text: widget.horse?.knownAge?.toString() ?? '',
    );
    _colorController = TextEditingController(text: widget.horse?.color ?? '');
    _notesController = TextEditingController(text: widget.horse?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _colorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveHorse() {
    if (!_formKey.currentState!.validate()) return;

    final horse = widget.horse?.copyWith(
      name: _nameController.text.trim(),
      breed: _breedController.text.trim(),
      knownAge: int.tryParse(_ageController.text.trim()),
      color: _colorController.text.trim(),
      notes: _notesController.text.trim(),
      updatedAt: DateTime.now(),
    ) ?? Horse.createNew(
      name: _nameController.text.trim(),
      breed: _breedController.text.trim(),
      knownAge: int.tryParse(_ageController.text.trim()),
      color: _colorController.text.trim(),
      notes: _notesController.text.trim(),
    );

    Navigator.of(context).pop(horse);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.horse == null ? AppStrings.addHorse : AppStrings.editHorse,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Horse name is required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: AppStrings.horseNameLabel,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.pets),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      DropdownButtonFormField<String>(
                        value: _commonBreeds.contains(_breedController.text)
                            ? _breedController.text
                            : null,
                        decoration: const InputDecoration(
                          labelText: AppStrings.breedLabel,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        items: _commonBreeds.map((breed) {
                          return DropdownMenuItem(value: breed, child: Text(breed));
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _breedController.text = value;
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: AppStrings.ageLabel,
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.access_time),
                                suffixText: 'years',
                              ),
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final age = int.tryParse(value);
                                  if (age == null || age < 0 || age > 50) {
                                    return 'Enter valid age (0-50)';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _commonColors.contains(_colorController.text)
                                  ? _colorController.text
                                  : null,
                              decoration: const InputDecoration(
                                labelText: AppStrings.colorLabel,
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.palette),
                              ),
                              items: _commonColors.map((color) {
                                return DropdownMenuItem(value: color, child: Text(color));
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  _colorController.text = value;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: AppStrings.notesLabel,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.note),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveHorse,
                      child: const Text(AppStrings.saveHorse),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HorseDetailsSheet extends StatelessWidget {
  final Horse horse;
  final List<AnalysisResult> analyses;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HorseDetailsSheet({
    super.key,
    required this.horse,
    required this.analyses,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      horse.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      '${horse.breed} • ${horse.color}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: const Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 12),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: const Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: AppColors.error),
                        SizedBox(width: 12),
                        Text('Delete', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Horse Info
          if (horse.knownAge != null) ...[
            _buildInfoRow('Known Age', '${horse.knownAge} years'),
            const SizedBox(height: 12),
          ],
          if (horse.notes.isNotEmpty) ...[
            _buildInfoRow('Notes', horse.notes),
            const SizedBox(height: 24),
          ],

          // Analysis History
          Text(
            'Analysis History (${analyses.length})',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: analyses.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No analyses yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: analyses.length,
                    itemBuilder: (context, index) {
                      final analysis = analyses[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: const Icon(
                              Icons.analytics,
                              color: AppColors.primary,
                            ),
                          ),
                          title: Text('Age: ${analysis.estimatedAge} years'),
                          subtitle: Text(
                            'Confidence: ${analysis.confidencePercentage}\n${_formatDate(analysis.analysisDate)}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AnalysisResultScreen(
                                  result: analysis,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: AppColors.text),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
