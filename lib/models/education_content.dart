import 'package:flutter/material.dart';

class EducationCategory {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<EducationItem> items;

  EducationCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.items,
  });
}

enum ContentType {
  article,
  video
}

class EducationItem {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String? imageUrl;
  final List<String> tags;
  final DateTime publishDate;
  final ContentType contentType;
  final String? videoUrl; // URL for video content

  EducationItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    this.imageUrl,
    this.tags = const [],
    required this.publishDate,
    this.contentType = ContentType.article,
    this.videoUrl,
  });
}

// Sample data for educational content
List<EducationCategory> educationCategories = [
  EducationCategory(
    id: 'menstrual-health',
    title: 'Menstrual Health',
    description: 'Learn about your menstrual cycle, period health, and common concerns.',
    icon: Icons.favorite,
    color: Colors.red.shade400,
    items: [
      EducationItem(
        id: 'menstrual-cycle-basics',
        title: 'Understanding Your Menstrual Cycle',
        summary: 'Learn about the four phases of the menstrual cycle and what happens in your body.',
        content: '''
# Understanding Your Menstrual Cycle

The menstrual cycle is a natural process that occurs in the female reproductive system. It prepares the body for potential pregnancy each month. A typical cycle lasts about 28 days, but can range from 21 to 35 days.

## The Four Phases of the Menstrual Cycle

### 1. Menstrual Phase (Days 1-5)
- The uterine lining sheds, resulting in menstrual bleeding
- Hormone levels are at their lowest
- Common symptoms: cramping, fatigue, mood changes

### 2. Follicular Phase (Days 1-13)
- Overlaps with the menstrual phase
- Follicle-stimulating hormone (FSH) stimulates follicle growth in the ovaries
- Estrogen levels begin to rise
- The uterine lining starts to thicken

### 3. Ovulation Phase (Day 14, approximately)
- A mature egg is released from the ovary
- Triggered by a surge in luteinizing hormone (LH)
- Most fertile time of the cycle
- Some women experience mild pain or spotting

### 4. Luteal Phase (Days 15-28)
- The empty follicle forms the corpus luteum
- Progesterone levels rise to prepare the uterus for potential pregnancy
- If no pregnancy occurs, hormone levels drop
- Common symptoms: PMS, bloating, mood changes

Understanding your unique cycle can help you track symptoms, plan for your period, and identify potential health concerns.
''',
        imageUrl: 'assets/images/education/menstrual_cycle.png',
        tags: ['Menstrual Cycle', 'Period', 'Women\'s Health'],
        publishDate: DateTime(2023, 5, 15),
      ),
      EducationItem(
        id: 'period-products',
        title: 'Guide to Period Products',
        summary: 'Explore different period products and find what works best for you.',
        content: '''
# Guide to Period Products

There are many options available for managing your period. Finding the right products for your body, lifestyle, and flow can make your period more comfortable.

## Disposable Products

### Pads
- External protection that sticks to underwear
- Various sizes for different flows
- Good for overnight use
- Need to be changed every 4-8 hours

### Tampons
- Internal protection inserted into the vagina
- Various absorbency levels
- Can be worn while swimming
- Should be changed every 4-8 hours
- Small risk of Toxic Shock Syndrome (TSS)

## Reusable Products

### Menstrual Cups
- Silicone or rubber cups inserted into the vagina
- Can be worn for up to 12 hours
- Reusable for several years
- Eco-friendly option
- Initial learning curve for insertion

### Period Underwear
- Absorbent underwear that replaces pads
- Can be worn alone or as backup protection
- Washable and reusable
- Various styles and absorbency levels

### Reusable Cloth Pads
- Fabric pads that attach to underwear
- Washable and reusable
- Eco-friendly option
- Various sizes and absorbency levels

Consider trying different products to find what works best for your body and lifestyle. Many people use a combination of products depending on their flow and activities.
''',
        imageUrl: 'assets/images/education/period_products.png',
        tags: ['Period Products', 'Menstrual Health', 'Sustainability'],
        publishDate: DateTime(2023, 6, 10),
      ),
    ],
  ),
  EducationCategory(
    id: 'fertility',
    title: 'Fertility Education',
    description: 'Information about fertility, conception, and reproductive health.',
    icon: Icons.child_friendly,
    color: Colors.green.shade400,
    items: [
      EducationItem(
        id: 'fertility-awareness',
        title: 'Fertility Awareness Methods',
        summary: 'Learn how to track your fertility signs to understand your fertile window.',
        content: '''
# Fertility Awareness Methods

Fertility awareness methods (FAMs) involve tracking your body's natural signs to identify your fertile window. These methods can be used to either avoid or achieve pregnancy.

## Common Fertility Signs to Track

### Basal Body Temperature (BBT)
- Take your temperature first thing in the morning before getting out of bed
- Temperature rises slightly (0.2-0.5°F) after ovulation
- Requires consistent timing for accuracy

### Cervical Mucus
- Changes throughout your cycle in response to hormones
- Becomes clear, stretchy, and slippery during your fertile window
- Dry or sticky mucus indicates less fertile times

### Cervical Position
- The cervix moves higher, becomes softer, and opens slightly during fertile days
- Requires practice to accurately assess changes

## Tracking Methods

### Symptothermal Method
- Combines BBT and cervical mucus observations
- More effective than using a single sign
- Requires daily tracking

### Calendar Method
- Predicts fertile days based on previous cycle lengths
- Less reliable for women with irregular cycles
- Should be used with other methods for better accuracy

### Ovulation Predictor Kits
- Detect luteinizing hormone (LH) surge before ovulation
- Can confirm when ovulation is approaching
- Complement other tracking methods

Fertility awareness requires consistent tracking and education. Consider working with a trained instructor when learning these methods.
''',
        imageUrl: 'assets/images/education/fertility_awareness.png',
        tags: ['Fertility', 'Natural Family Planning', 'Ovulation'],
        publishDate: DateTime(2023, 7, 5),
      ),
      EducationItem(
        id: 'optimizing-fertility',
        title: 'Tips for Optimizing Fertility',
        summary: 'Lifestyle factors that can impact fertility and conception.',
        content: '''
# Tips for Optimizing Fertility

Various lifestyle factors can influence your fertility. Making healthy choices can support your reproductive health whether you're trying to conceive now or in the future.

## Nutrition and Diet

- Maintain a balanced diet rich in fruits, vegetables, whole grains, and lean proteins
- Include foods with folate (leafy greens, citrus fruits, beans)
- Consider a prenatal vitamin with folic acid
- Limit caffeine to 200mg per day (about one 12oz cup of coffee)
- Reduce or eliminate alcohol consumption

## Physical Activity

- Engage in moderate exercise regularly (30 minutes most days)
- Avoid excessive, intense exercise which can impact ovulation
- Maintain a healthy weight (both underweight and overweight can affect fertility)

## Stress Management

- Practice stress reduction techniques like meditation, yoga, or deep breathing
- Prioritize adequate sleep (7-9 hours per night)
- Consider counseling if experiencing significant stress or anxiety

## Timing and Frequency

- Have sex every 1-2 days during your fertile window
- Your fertile window is typically the 5 days before ovulation and ovulation day
- Use fertility awareness methods to identify your fertile window

## Environmental Factors

- Avoid smoking and secondhand smoke
- Limit exposure to environmental toxins when possible
- Be aware of occupational hazards that might affect fertility

Remember that fertility is complex and influenced by many factors. If you've been trying to conceive for 12 months (or 6 months if over 35) without success, consider consulting a healthcare provider.
''',
        imageUrl: 'assets/images/education/fertility_tips.png',
        tags: ['Fertility', 'Conception', 'Reproductive Health'],
        publishDate: DateTime(2023, 8, 12),
      ),
    ],
  ),
  EducationCategory(
    id: 'pregnancy-tips',
    title: 'Pregnancy Tips',
    description: 'Helpful tips and advice for a healthy pregnancy journey.',
    icon: Icons.pregnant_woman,
    color: Colors.purple.shade300,
    items: [
      EducationItem(
        id: 'early-pregnancy',
        title: 'Early Pregnancy Signs and Symptoms',
        summary: 'Common signs and symptoms of early pregnancy and when to see a doctor.',
        content: '''
# Early Pregnancy Signs and Symptoms

Early pregnancy symptoms can vary widely from person to person and even between pregnancies. Some women experience many symptoms, while others notice very few changes.

## Common Early Pregnancy Symptoms

### Missed Period
- Often the first sign that prompts a pregnancy test
- Some women may experience light spotting (implantation bleeding) around the time of their expected period

### Breast Changes
- Tenderness, swelling, or tingling
- Darkening of the areolas
- More visible veins

### Fatigue
- Extreme tiredness, especially in the first trimester
- Related to hormonal changes and increased blood production

### Nausea and Vomiting
- Often called "morning sickness" but can occur at any time
- Typically begins around 6 weeks
- May be triggered by certain smells or foods

### Frequent Urination
- Increased blood flow to the kidneys and pressure on the bladder
- Begins early and continues throughout pregnancy

### Food Aversions or Cravings
- Sensitivity to certain tastes or smells
- Strong desires for specific foods
- Changes in food preferences

## When to See a Healthcare Provider

- After a positive home pregnancy test to confirm pregnancy
- If experiencing severe nausea and vomiting that prevents keeping food down
- If experiencing vaginal bleeding or severe abdominal pain
- If you have a chronic health condition that may affect pregnancy

Early prenatal care is important for a healthy pregnancy. Most providers will schedule the first appointment for around 8 weeks after your last menstrual period.
''',
        imageUrl: 'assets/images/education/early_pregnancy.png',
        tags: ['Pregnancy', 'Prenatal Care', 'Women\'s Health'],
        publishDate: DateTime(2023, 9, 8),
      ),
      EducationItem(
        id: 'prenatal-nutrition',
        title: 'Prenatal Nutrition Guide',
        summary: 'Essential nutrients and dietary recommendations during pregnancy.',
        content: '''
# Prenatal Nutrition Guide

Proper nutrition during pregnancy is crucial for both maternal health and fetal development. Your nutritional needs change during pregnancy to support your baby's growth.

## Key Nutrients for Pregnancy

### Folate/Folic Acid
- Helps prevent neural tube defects
- Sources: leafy greens, citrus fruits, beans, fortified grains
- Recommended: 600 mcg daily (usually from a combination of food and prenatal vitamins)

### Iron
- Supports increased blood volume and prevents anemia
- Sources: lean red meat, poultry, fish, beans, fortified cereals
- Recommended: 27 mg daily

### Calcium
- Builds baby's bones and teeth
- Sources: dairy products, fortified plant milks, leafy greens
- Recommended: 1,000 mg daily

### Protein
- Essential for baby's growth, especially in the second and third trimesters
- Sources: meat, poultry, fish, eggs, dairy, legumes, nuts
- Recommended: 75-100 g daily

### Omega-3 Fatty Acids
- Support baby's brain and eye development
- Sources: fatty fish (salmon, trout), walnuts, flaxseeds, chia seeds
- Recommended: At least 200 mg DHA daily

## Foods to Limit or Avoid

### Mercury-Containing Fish
- Avoid high-mercury fish: shark, swordfish, king mackerel, tilefish
- Limit albacore tuna to 6 oz per week
- Low-mercury options (12 oz per week): salmon, shrimp, pollock, catfish

### Unpasteurized Foods
- Avoid unpasteurized milk, cheese, and juices
- Avoid raw sprouts

### Undercooked Meats and Eggs
- Cook all meats thoroughly
- Avoid raw or runny eggs
- Avoid raw fish and shellfish

### Caffeine
- Limit to 200 mg per day (about one 12 oz cup of coffee)

### Alcohol
- No amount of alcohol has been proven safe during pregnancy
- Avoid all alcoholic beverages

Consult with your healthcare provider about your specific nutritional needs, as they may vary based on your health status and pregnancy.
''',
        imageUrl: 'assets/images/education/prenatal_nutrition.png',
        tags: ['Pregnancy', 'Nutrition', 'Prenatal Care'],
        publishDate: DateTime(2023, 10, 15),
      ),
    ],
  ),
  EducationCategory(
    id: 'nutrition',
    title: 'Nutrition Guidelines',
    description: 'Healthy eating tips for menstrual health, fertility, and pregnancy.',
    icon: Icons.restaurant,
    color: Colors.orange.shade400,
    items: [
      EducationItem(
        id: 'nutrition-menstrual-health',
        title: 'Nutrition for Menstrual Health',
        summary: 'Foods that can help manage period symptoms and support hormonal balance.',
        content: '''
# Nutrition for Menstrual Health

What you eat can significantly impact your menstrual health and symptoms. Certain nutrients and dietary patterns may help manage period discomfort and support hormonal balance.

## Nutrients That Support Menstrual Health

### Iron
- Replaces iron lost during menstruation
- Helps prevent anemia and fatigue
- Sources: lean red meat, spinach, lentils, fortified cereals
- Pair with vitamin C foods to enhance absorption

### Omega-3 Fatty Acids
- May reduce inflammation and period pain
- Can help regulate menstrual cycles
- Sources: fatty fish (salmon, sardines), walnuts, flaxseeds, chia seeds

### Magnesium
- May reduce menstrual cramps and PMS symptoms
- Helps regulate mood and sleep
- Sources: dark chocolate, avocados, nuts, seeds, whole grains

### Calcium and Vitamin D
- May reduce PMS symptoms
- Support bone health
- Sources: dairy products, fortified plant milks, leafy greens, sunlight exposure (vitamin D)

### B Vitamins
- Support energy levels and mood regulation
- Help manage stress
- Sources: whole grains, eggs, leafy greens, nutritional yeast

## Foods to Emphasize

- Anti-inflammatory foods: fruits, vegetables, whole grains, fatty fish
- Fiber-rich foods: help eliminate excess estrogen
- Water: stays hydrated to reduce bloating
- Ginger and turmeric: may help reduce inflammation and pain

## Foods to Limit

- Highly processed foods: can increase inflammation
- Added sugars: may worsen mood swings and energy crashes
- Alcohol: can disrupt hormonal balance
- Caffeine: may increase breast tenderness and anxiety
- Salt: can increase water retention and bloating

## Eating Patterns Throughout Your Cycle

### Menstrual Phase (Days 1-5)
- Focus on iron-rich foods
- Warm, comforting foods may feel better
- Stay well-hydrated

### Follicular Phase (Days 6-14)
- Emphasize fresh fruits and vegetables
- Include protein for sustained energy
- Support estrogen metabolism with cruciferous vegetables

### Luteal Phase (Days 15-28)
- Include complex carbohydrates to support serotonin production
- Focus on calcium-rich foods
- Limit salt, sugar, and caffeine to reduce PMS symptoms

Remember that individual responses to foods vary. Pay attention to how different foods affect your symptoms and adjust accordingly.
''',
        imageUrl: 'assets/images/education/menstrual_nutrition.png',
        tags: ['Nutrition', 'Menstrual Health', 'PMS'],
        publishDate: DateTime(2023, 11, 5),
      ),
      EducationItem(
        id: 'hydration-womens-health',
        title: 'The Importance of Hydration for Women\'s Health',
        summary: 'How proper hydration affects hormonal balance, energy levels, and overall well-being.',
        content: '''
# The Importance of Hydration for Women's Health

Proper hydration is essential for overall health and has specific benefits for women's reproductive health. Water plays a crucial role in hormonal balance, energy levels, and managing menstrual symptoms.

## Benefits of Proper Hydration

### Hormonal Balance
- Supports liver function for hormone metabolism
- Helps flush excess hormones from the body
- May help reduce hormonal acne

### Menstrual Health
- Can reduce bloating during your period
- May help alleviate menstrual cramps
- Supports overall comfort during menstruation

### Fertility
- Helps create fertile cervical mucus
- Supports egg health and implantation
- Improves blood flow to reproductive organs

### Pregnancy
- Supports increased blood volume
- Helps prevent constipation and hemorrhoids
- Reduces risk of urinary tract infections
- Helps form amniotic fluid

### Overall Well-being
- Improves energy levels and reduces fatigue
- Supports cognitive function
- Helps regulate body temperature
- Promotes healthy skin

## How Much to Drink

The general recommendation is about 8-10 cups (64-80 ounces) of fluid daily for women, with additional needs during:
- Exercise
- Hot weather
- Pregnancy and breastfeeding
- Illness with fever, vomiting, or diarrhea

## Hydration Tips

- Carry a reusable water bottle throughout the day
- Set reminders to drink regularly
- Infuse water with fruit, cucumber, or herbs for flavor
- Include hydrating foods like watermelon, cucumber, and oranges
- Limit dehydrating beverages like alcohol and excessive caffeine
- Drink a glass of water before meals

## Signs of Dehydration

- Thirst (already a sign of mild dehydration)
- Dark yellow urine
- Dry mouth and lips
- Headache
- Fatigue
- Dizziness
- Reduced urination

Remember that individual hydration needs vary based on activity level, climate, and personal health factors. Listen to your body and adjust your fluid intake accordingly.
''',
        imageUrl: 'assets/images/education/hydration.png',
        tags: ['Hydration', 'Women\'s Health', 'Nutrition'],
        publishDate: DateTime(2023, 12, 10),
      ),
    ],
  ),
  EducationCategory(
    id: 'exercise',
    title: 'Exercise Recommendations',
    description: 'Physical activity guidelines for different phases of your cycle and during pregnancy.',
    icon: Icons.fitness_center,
    color: Colors.blue.shade400,
    items: [
      EducationItem(
        id: 'cycle-synced-fitness',
        title: 'Cycle-Synced Fitness: Exercising with Your Menstrual Cycle',
        summary: 'How to adapt your workouts to each phase of your menstrual cycle for optimal results.',
        content: '''
# Cycle-Synced Fitness: Exercising with Your Menstrual Cycle

Your hormones fluctuate throughout your menstrual cycle, affecting your energy levels, strength, endurance, and recovery. Adapting your workouts to each phase can help you optimize performance and feel your best.

## Menstrual Phase (Days 1-5)

**Hormones:** Low estrogen and progesterone
**Energy levels:** Typically lower, especially on heavy flow days
**Best activities:**
- Gentle yoga or stretching
- Walking
- Light swimming
- Restorative exercises
- Short, low-intensity workouts

**Tips:**
- Listen to your body and rest if needed
- Focus on proper form rather than intensity
- Stay hydrated and warm
- Iron-rich foods can help combat fatigue

## Follicular Phase (Days 6-14)

**Hormones:** Rising estrogen
**Energy levels:** Increasing, often highest right before ovulation
**Best activities:**
- High-intensity interval training (HIIT)
- Strength training with progressive overload
- Challenging cardio workouts
- Try new fitness classes or activities
- Team sports

**Tips:**
- Take advantage of increased energy and strength
- Push yourself with new challenges
- Your pain tolerance is higher during this phase
- Recovery tends to be faster

## Ovulation (Around Day 14)

**Hormones:** Peak estrogen, rising progesterone
**Energy levels:** Often at their highest
**Best activities:**
- High-intensity workouts
- Strength training
- Sprints or speed work
- Competitive activities

**Tips:**
- This is often when you'll achieve personal bests
- Great time for fitness tests or competitions
- Stay extra hydrated as body temperature is higher

## Luteal Phase (Days 15-28)

**Hormones:** High progesterone, then all hormones drop if no pregnancy
**Energy levels:** Initially stable, then declining
**Early luteal (Days 15-21):**
- Moderate strength training
- Steady-state cardio
- Pilates
- Moderate-intensity activities

**Late luteal (Days 22-28):**
- Yoga
- Walking
- Swimming
- Lower-intensity strength training
- Mind-body exercises

**Tips:**
- Focus on maintenance rather than progression
- Be mindful of potential coordination changes
- You may need more recovery time between workouts
- Pay attention to hunger and fuel properly
- Relaxation exercises can help manage PMS symptoms

Remember that every body is different, and these are general guidelines. Track your energy levels and symptoms to personalize your approach to cycle-synced fitness.
''',
        imageUrl: 'assets/images/education/cycle_fitness.png',
        tags: ['Exercise', 'Menstrual Cycle', 'Fitness'],
        publishDate: DateTime(2024, 1, 8),
      ),
      EducationItem(
        id: 'pregnancy-exercise',
        title: 'Safe Exercise During Pregnancy',
        summary: 'Guidelines for staying active during pregnancy and exercises to avoid.',
        content: '''
# Safe Exercise During Pregnancy

Regular physical activity during pregnancy offers numerous benefits, including improved mood, energy levels, sleep quality, and preparation for labor. Always consult your healthcare provider before starting or continuing an exercise program during pregnancy.

## Benefits of Prenatal Exercise

- Reduces back pain and constipation
- May decrease risk of gestational diabetes and preeclampsia
- Promotes healthy weight gain
- Improves fitness and strength for labor and delivery
- Supports faster postpartum recovery
- Reduces stress and improves mood

## General Guidelines

### First Trimester (Weeks 1-13)
- Continue your pre-pregnancy routine if you feel well
- Modify intensity if experiencing fatigue or nausea
- Focus on establishing good form and body awareness
- Stay well-hydrated and avoid overheating

### Second Trimester (Weeks 14-26)
- Modify exercises as your center of gravity changes
- Avoid exercises that require lying flat on your back after week 16
- Begin to incorporate more pregnancy-specific exercises
- Listen to your body and adjust intensity as needed

### Third Trimester (Weeks 27-40)
- Lower intensity as your body prepares for birth
- Focus on pelvic floor exercises and birth preparation
- Maintain activity but prioritize comfort and safety
- Be mindful of balance as your center of gravity continues to shift

## Recommended Activities

- Walking
- Swimming and water exercises
- Stationary cycling
- Modified yoga and Pilates (prenatal classes recommended)
- Low-impact aerobics
- Strength training with appropriate modifications
- Pelvic floor exercises (Kegels)

## Activities to Avoid

- Contact sports or activities with fall risk
- High-impact activities or those requiring rapid direction changes
- Hot yoga or exercise in hot, humid environments
- Scuba diving
- Activities at high altitude (if not acclimatized)
- Heavy lifting or straining
- Exercises lying flat on your back after the first trimester

## Warning Signs to Stop Exercise

- Vaginal bleeding
- Regular painful contractions
- Amniotic fluid leakage
- Shortness of breath before exertion
- Dizziness or feeling faint
- Headache
- Chest pain
- Muscle weakness
- Calf pain or swelling

Remember that pregnancy is not the time to focus on personal records or significant fitness gains. The goal is to maintain fitness, support your changing body, and prepare for birth and recovery.
''',
        imageUrl: 'assets/images/education/pregnancy_exercise.png',
        tags: ['Pregnancy', 'Exercise', 'Prenatal Health'],
        publishDate: DateTime(2024, 2, 15),
      ),
    ],
  ),
  EducationCategory(
    id: 'cycle-faqs',
    title: 'Cycle FAQs',
    description: 'Answers to common questions about menstrual cycles and reproductive health.',
    icon: Icons.help_outline,
    color: Colors.amber.shade600,
    items: [
      EducationItem(
        id: 'irregular-periods',
        title: 'Why Are My Periods Irregular?',
        summary: 'Common causes of irregular periods and when to see a doctor.',
        content: 'Content about irregular periods',
        tags: ['Irregular Periods', 'Menstrual Health', 'FAQs'],
        publishDate: DateTime(2023, 9, 20),
      ),
      EducationItem(
        id: 'period-pain',
        title: 'How Can I Manage Period Pain?',
        summary: 'Effective strategies for managing menstrual cramps and discomfort.',
        content: 'Content about managing period pain',
        tags: ['Period Pain', 'Menstrual Cramps', 'Pain Management', 'FAQs'],
        publishDate: DateTime(2023, 10, 5),
      ),
      EducationItem(
        id: 'cycle-tracking-benefits',
        title: 'Why Should I Track My Cycle?',
        summary: 'The benefits of tracking your menstrual cycle and how to do it effectively.',
        contentType: ContentType.video,
        videoUrl: 'https://example.com/videos/cycle-tracking-benefits',
        content: 'Content about cycle tracking benefits',
        tags: ['Cycle Tracking', 'Menstrual Health', 'FAQs'],
        publishDate: DateTime(2023, 11, 15),
      ),
    ],
  ),
  EducationCategory(
    id: 'mental-health',
    title: 'Mental Health Resources',
    description: 'Support for emotional wellbeing related to menstrual health, fertility, and pregnancy.',
    icon: Icons.psychology,
    color: Colors.teal.shade400,
    items: [
      EducationItem(
        id: 'hormones-mood',
        title: 'Understanding Hormones and Mood',
        summary: 'How hormonal fluctuations affect your emotional wellbeing throughout your cycle.',
        content: '''
# Understanding Hormones and Mood

Hormonal fluctuations throughout your menstrual cycle can significantly impact your mood, energy levels, and emotional wellbeing. Understanding these patterns can help you better manage your mental health.

## Hormonal Influences on Mood

### Estrogen
- Generally associated with positive mood effects
- Increases serotonin (mood-regulating neurotransmitter)
- Boosts endorphins (natural feel-good chemicals)
- Improves cognitive function and verbal memory
- Fluctuations can trigger mood changes

### Progesterone
- Has a calming, sedative-like effect
- Can cause fatigue and low energy when elevated
- May contribute to irritability and anxiety in some women
- Affects GABA receptors in the brain (similar to anti-anxiety medications)

### Testosterone
- Small amounts present in women
- Peaks around ovulation
- Associated with increased libido and confidence
- Can enhance motivation and energy

## Mood Patterns Throughout the Cycle

### Menstrual Phase (Days 1-5)
- Hormone levels are low
- Common feelings: relief, fatigue, or mild depression
- PMS symptoms typically resolve by day 3-4
- Energy often returns as bleeding lightens

### Follicular Phase (Days 6-14)
- Rising estrogen levels
- Common feelings: increased energy, optimism, confidence
- Often experience better concentration and creativity
- Social energy typically increases

### Ovulation (Around Day 14)
- Peak estrogen and testosterone
- Common feelings: heightened energy, increased confidence
- May experience increased sociability and verbal fluency
- Some women feel mild pain or mood shifts with LH surge

### Luteal Phase (Days 15-28)
- High progesterone, then all hormones drop
- Early luteal: often stable mood and energy
- Late luteal: may experience PMS symptoms
- Common PMS feelings: irritability, anxiety, mood swings, fatigue

## Premenstrual Syndrome (PMS) and PMDD

### PMS
- Affects up to 85% of menstruating women
- Physical and emotional symptoms in the week before menstruation
- Common symptoms: irritability, anxiety, mood swings, fatigue, food cravings
- Typically resolves within a few days of period starting

### Premenstrual Dysphoric Disorder (PMDD)
- More severe form affecting 3-8% of women
- Significant impact on daily functioning
- Symptoms include severe depression, anxiety, or irritability
- Requires medical attention and treatment

## Managing Hormone-Related Mood Changes

- Track your cycle and mood patterns to identify personal trends
- Practice stress-reduction techniques like meditation, yoga, or deep breathing
- Prioritize regular sleep and exercise
- Consider dietary adjustments (reduce caffeine, alcohol, and sugar)
- Plan important events or decisions during your typically stable mood phases
- Communicate with loved ones about your patterns
- Seek professional help if mood changes significantly impact your life

Remember that while hormones influence mood, they don't control it entirely. If you experience persistent or severe mood issues, consult a healthcare provider.
''',
        imageUrl: 'assets/images/education/hormones_mood.png',
        tags: ['Mental Health', 'Hormones', 'Emotional Wellbeing'],
        publishDate: DateTime(2024, 3, 10),
      ),
      EducationItem(
        id: 'stress-fertility',
        title: 'Managing Stress While Trying to Conceive',
        summary: 'Strategies for reducing stress and supporting your mental health during the conception journey.',
        content: '''
# Managing Stress While Trying to Conceive

The journey to conception can be emotionally challenging, especially when it takes longer than expected. While moderate stress doesn't typically prevent pregnancy, chronic stress may impact fertility through hormonal pathways and lifestyle factors.

## How Stress Affects Fertility

- May disrupt GnRH (gonadotropin-releasing hormone) pulsatility
- Can affect ovulation in some women
- May reduce sperm quality in men
- Often leads to behaviors that impact fertility (poor sleep, unhealthy eating, increased alcohol)
- Can strain relationships and reduce sexual frequency

## Signs of Fertility-Related Stress

- Persistent worry about conception
- Feeling sad or anxious when seeing pregnancy announcements
- Strained relationship with your partner
- Loss of enjoyment in sex
- Difficulty concentrating on other aspects of life
- Sleep disturbances
- Physical symptoms like headaches or muscle tension

## Effective Stress Management Strategies

### Mind-Body Practices
- Meditation and mindfulness
- Deep breathing exercises
- Progressive muscle relaxation
- Yoga or tai chi
- Guided imagery

### Lifestyle Approaches
- Regular physical activity (moderate intensity)
- Adequate sleep (7-9 hours)
- Balanced nutrition
- Time in nature
- Creative outlets and hobbies
- Setting boundaries with work

### Social Support
- Join a support group (in-person or online)
- Connect with others on similar journeys
- Be selective about who you share your journey with
- Communicate openly with your partner
- Consider couples counseling if needed

### Professional Support
- Fertility counselors
- Therapists specializing in reproductive issues
- Reproductive psychiatrists if needed
- Acupuncture or massage therapy

## When to Seek Additional Help

- If you feel overwhelmed by sadness or anxiety
- If stress is significantly impacting your daily functioning
- If you're experiencing relationship difficulties
- If you're having trouble coping with fertility treatments
- If you have a history of anxiety, depression, or trauma

## Reframing the Journey

- Focus on what you can control
- Practice self-compassion
- Acknowledge that fertility challenges are not your fault
- Maintain perspective and other life interests
- Set realistic expectations and boundaries
- Consider taking breaks from trying when needed

Remember that seeking support for your mental health while trying to conceive is not a sign of weakness but a proactive step toward overall wellbeing.
''',
        imageUrl: 'assets/images/education/fertility_stress.png',
        tags: ['Mental Health', 'Fertility', 'Stress Management'],
        publishDate: DateTime(2024, 4, 5),
      ),
    ],
  ),
];
