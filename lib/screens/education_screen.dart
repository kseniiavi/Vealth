import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(AppStrings.educationTitle),
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Age Guide'),
            Tab(text: 'Dental Care'),
            Tab(text: 'Problems'),
            Tab(text: 'Vet Care'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AgeGuideTab(),
          DentalCareTab(),
          CommonProblemsTab(),
          VetConsultationTab(),
        ],
      ),
    );
  }
}

class AgeGuideTab extends StatelessWidget {
  const AgeGuideTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EducationCard(
            title: 'Age Determination Basics',
            content: '''
Determining a horse's age through dental examination is a traditional veterinary practice that relies on predictable changes in tooth structure over time. While modern methods like microchipping provide exact ages, dental aging remains valuable for horses with unknown birth dates.

Key factors examined include:
• Tooth eruption patterns
• Wear patterns on occlusal surfaces
• Cup depth and disappearance
• Dental star appearance and development
• Galvayne's groove presence and progression
• Overall tooth angle and length
            ''',
            icon: Icons.access_time,
            color: AppColors.primary,
          ),

          const AgeRangeCard(
            ageRange: 'Birth to 5 Years',
            accuracy: 'Very High (±6 months)',
            keyIndicators: [
              'Deciduous (baby) teeth present',
              'Predictable eruption schedule',
              'Smooth, white enamel surfaces',
              'Deep infundibular cups',
              'Rectangular occlusal surfaces'
            ],
            description: 'Young horses show the most reliable aging indicators through tooth eruption patterns. Central incisors erupt at birth, lateral incisors at 4-6 weeks, and corner incisors at 6-9 months.',
            color: AppColors.success,
          ),

          const AgeRangeCard(
            ageRange: '6 to 15 Years',
            accuracy: 'High (±1-2 years)',
            keyIndicators: [
              'All permanent incisors erupted',
              'Cups progressively disappearing',
              'Dental stars beginning to appear',
              'Occlusal surfaces becoming oval',
              'Hook formation possible on corner incisors'
            ],
            description: 'Adult horses in their prime working years. The cups in the lower central incisors disappear around age 6, lateral incisors at 7, and corner incisors at 8.',
            color: AppColors.secondary,
          ),

          const AgeRangeCard(
            ageRange: '16 to 25 Years',
            accuracy: 'Moderate (±3-4 years)',
            keyIndicators: [
              'Galvayne\'s groove appearing (10+ years)',
              'Dental stars more prominent',
              'Triangular occlusal surfaces',
              'Increased tooth angulation',
              'Smooth mouth (cups gone by 15)'
            ],
            description: 'Senior horses require more careful examination. Galvayne\'s groove appears as a dark line on the upper corner incisor around age 10, extending down the tooth as the horse ages.',
            color: AppColors.warning,
          ),

          const AgeRangeCard(
            ageRange: '25+ Years',
            accuracy: 'Low (±5+ years)',
            keyIndicators: [
              'Extreme tooth angulation',
              'Triangular, worn teeth',
              'Galvayne\'s groove extends full length',
              'Possible tooth loss',
              'Irregular wear patterns'
            ],
            description: 'Geriatric horses present the most challenging cases for age determination. Individual variation increases significantly, and other health factors may affect dental appearance.',
            color: AppColors.error,
          ),
        ],
      ),
    );
  }
}

class DentalCareTab extends StatelessWidget {
  const DentalCareTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const EducationCard(
            title: 'Regular Dental Maintenance',
            content: '''
Proper dental care is essential for equine health and performance. Horses' teeth continuously erupt throughout their lives, requiring regular professional attention to maintain proper alignment and function.

Recommended Schedule:
• Young horses (2-5 years): Every 6 months
• Adult horses (6-15 years): Annually
• Senior horses (15+ years): Every 6 months
• Performance horses: Every 6-12 months

Signs requiring immediate attention:
• Difficulty chewing or dropping feed
• Head tilting while eating
• Excessive salivation
• Bad breath
• Weight loss despite adequate feed
• Behavioral changes under saddle
            ''',
            icon: Icons.medical_services,
            color: AppColors.secondary,
          ),

          const EducationCard(
            title: 'Professional Floating',
            content: '''
Floating is the process of filing down sharp enamel points that develop on horses' teeth due to their natural chewing motion. This procedure should only be performed by qualified veterinarians or certified equine dental technicians.

What happens during floating:
1. Sedation for safety and comfort
2. Examination of entire mouth
3. Removal of sharp points and hooks
4. Balancing of occlusal surfaces
5. Assessment of overall dental health

Benefits of regular floating:
• Improved feed efficiency
• Better bit acceptance
• Prevention of oral ulcers
• Enhanced comfort and performance
• Early detection of dental problems
            ''',
            icon: Icons.build,
            color: AppColors.accent,
          ),

          const EducationCard(
            title: 'Home Dental Care',
            content: '''
While professional care is irreplaceable, horse owners can monitor dental health and provide supportive care at home.

Daily observations:
• Monitor eating habits and feed consumption
• Check for quidding (dropping partially chewed feed)
• Observe head position while eating
• Watch for excessive salivation

Monthly checks:
• Examine feed tubs for unusual amounts of unchewed grain
• Look for uneven wear on halters or bits
• Monitor body condition and weight
• Note any changes in behavior or performance

Warning signs to report:
• Difficulty eating or drinking
• Head shaking or tilting
• Foul odor from mouth
• Visible swelling of face or jaw
• Resistance to bridling
            ''',
            icon: Icons.home,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class CommonProblemsTab extends StatelessWidget {
  const CommonProblemsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const DentalProblemCard(
            title: 'Sharp Enamel Points',
            severity: 'Common',
            symptoms: [
              'Difficulty chewing',
              'Head tilting while eating',
              'Bit resistance',
              'Ulcers on cheeks or tongue'
            ],
            causes: 'Natural uneven wear due to circular chewing motion',
            treatment: 'Professional floating to smooth sharp edges',
            color: AppColors.warning,
          ),

          const DentalProblemCard(
            title: 'Hooks and Ramps',
            severity: 'Moderate',
            symptoms: [
              'Quidding (dropping feed)',
              'Weight loss',
              'Performance issues',
              'Difficulty with bit contact'
            ],
            causes: 'Uneven wear on first and last cheek teeth',
            treatment: 'Specialized floating techniques and regular maintenance',
            color: Colors.orange,
          ),

          const DentalProblemCard(
            title: 'Wave Mouth',
            severity: 'Serious',
            symptoms: [
              'Severe eating difficulties',
              'Rapid weight loss',
              'Impaction colic risk',
              'Poor feed conversion'
            ],
            causes: 'Uneven wear creating wave-like pattern across tooth row',
            treatment: 'Intensive corrective floating over multiple sessions',
            color: AppColors.error,
          ),

          const DentalProblemCard(
            title: 'Fractured Teeth',
            severity: 'Emergency',
            symptoms: [
              'Sudden onset pain',
              'Refusal to eat',
              'Excessive salivation',
              'Head shaking'
            ],
            causes: 'Trauma, age-related brittleness, or severe hooks',
            treatment: 'Immediate veterinary attention, possible extraction',
            color: Color(0xFFB71C1C),
          ),

          const DentalProblemCard(
            title: 'Periodontal Disease',
            severity: 'Progressive',
            symptoms: [
              'Bad breath',
              'Gum recession',
              'Loose teeth',
              'Food packing between teeth'
            ],
            causes: 'Poor dental hygiene, age, genetics',
            treatment: 'Professional cleaning, antibiotics, possible extractions',
            color: AppColors.error,
          ),
        ],
      ),
    );
  }
}

class VetConsultationTab extends StatelessWidget {
  const VetConsultationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const EducationCard(
            title: 'When to Call the Veterinarian',
            content: '''
Immediate veterinary attention is required for:

🚨 Emergency Signs:
• Complete refusal to eat or drink
• Severe facial swelling
• Bleeding from the mouth
• Obvious pain or distress
• Difficulty swallowing

⚠️ Urgent Signs (within 24-48 hours):
• Sudden onset of eating difficulties
• Dramatic behavioral changes
• Quidding (dropping partially chewed feed)
• Persistent head shaking or tilting
• Performance decline with no other cause

📅 Schedule Soon (within 1-2 weeks):
• Gradual weight loss despite adequate feed
• Changes in manure consistency
• Mild difficulty chewing
• Increased time spent eating
• Bad breath or foul odor
            ''',
            icon: Icons.emergency,
            color: AppColors.error,
          ),

          const EducationCard(
            title: 'Preparing for Dental Examination',
            content: '''
To help your veterinarian provide the best care:

Before the Visit:
• Fast your horse 2-4 hours beforehand
• Provide a complete feeding history
• Note any behavioral changes
• List all current medications
• Prepare a quiet, well-lit area

Information to Share:
• Last dental examination date
• Known dental problems
• Recent performance issues
• Changes in eating habits
• Any previous dental procedures

During the Exam:
• Sedation is typically necessary for safety
• Full mouth examination using speculum
• Detailed assessment of all teeth
• Discussion of findings and treatment plan
• Scheduling of follow-up if needed
            ''',
            icon: Icons.checklist,
            color: AppColors.secondary,
          ),

          const EducationCard(
            title: 'Questions to Ask Your Vet',
            content: '''
Make the most of your veterinary consultation:

About Your Horse's Condition:
• What specific problems were found?
• How severe are the issues?
• What caused these problems?
• How will this affect my horse's comfort?

About Treatment:
• What procedures are recommended?
• How long will treatment take?
• What are the risks and benefits?
• Are there alternative treatment options?

About Follow-up Care:
• How often should dental exams be performed?
• What signs should I watch for at home?
• When should I schedule the next visit?
• Are there management changes needed?

About Prevention:
• How can I prevent future problems?
• What feeding practices are recommended?
• Should I make any equipment changes?
• Are there supplements that might help?
            ''',
            icon: Icons.quiz,
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }
}

class EducationCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  const EducationCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.text,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AgeRangeCard extends StatelessWidget {
  final String ageRange;
  final String accuracy;
  final List<String> keyIndicators;
  final String description;
  final Color color;

  const AgeRangeCard({
    super.key,
    required this.ageRange,
    required this.accuracy,
    required this.keyIndicators,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ageRange,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  accuracy,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.text,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Key Indicators:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            ...keyIndicators.map((indicator) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 8, right: 12),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      indicator,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class DentalProblemCard extends StatelessWidget {
  final String title;
  final String severity;
  final List<String> symptoms;
  final String causes;
  final String treatment;
  final Color color;

  const DentalProblemCard({
    super.key,
    required this.title,
    required this.severity,
    required this.symptoms,
    required this.causes,
    required this.treatment,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    severity,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildSection('Symptoms', symptoms.join(' • ')),
            const SizedBox(height: 12),
            _buildSection('Causes', causes),
            const SizedBox(height: 12),
            _buildSection('Treatment', treatment),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
