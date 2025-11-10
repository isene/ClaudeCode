# Amar RPG Game System

## Three-Tier Hierarchy

The system organizes abilities into three ascending levels:
1. **Characteristics** (Tier 1) - Foundation
2. **Attributes** (Tier 2) - Build upon characteristics
3. **Skills** (Tier 3) - Specific trained abilities

## Characteristics (Tier 1)

Three core attributes define a character:

### BODY
Physical qualities including strength, endurance, and agility.

**Rating Range**: 0-3 (1 is average for humans)

### MIND
Mental capabilities encompassing intelligence, knowledge, awareness, and willpower.

**Rating Range**: 0-3 (1 is average for humans)

### SPIRIT
Magical and spiritual nature involving spellcasting and divine connection.

**Rating Range**: 0-3 (1 is average for humans)

## Attributes (Tier 2)

Grouped abilities under each characteristic.

**Rating Range**: 0-5 (2 is typical for adult humans)

### BODY Attributes
- **Strength** - Physical power and carrying capacity
  - Skills: Carrying, Weight lifting, Wield weapon
- **Endurance** - Stamina and resilience
  - Skills: Fortitude, Combat Tenacity, Running, Poison Resistance
- **Athletics** - Physical coordination and movement
  - Skills: Hide, Move Quietly, Climb, Swim, Ride, Jump, Balance, Tumble
- **Melee Combat** - Close-quarters fighting
  - Skills: Various weapon skills (Sword, Club, Dagger, etc.)
- **Missile Combat** - Ranged combat
  - Skills: Various ranged weapons (Bow, Sling, Throwing, etc.)
- **Sleight** - Manual dexterity and precision
  - Skills: Pick pockets, Stage Magic, Disarm Traps

### MIND Attributes
- **Intelligence** - Mental capacity and reasoning
  - Skills: Innovation, Problem Solving
- **Nature Knowledge** - Understanding of natural world
  - Skills: Medical lore, Plant Lore, Animal Lore, Animal Handling, Magick Rituals, Alchemy
- **Social Knowledge** - Cultural and linguistic understanding
  - Skills: Social lore, Spoken Language, Literacy, Mythology, Legend Lore
- **Practical Knowledge** - Survival and tactical skills
  - Skills: Survival Lore, Set traps, Ambush
- **Awareness** - Perception and reaction
  - Skills: Reaction speed, Tracking, Detect Traps, Sense Emotions, Sense Ambush, Sense of Direction, Sense Magick, Listening
- **Willpower** - Mental fortitude and determination
  - Skills: Pain Tolerance, Courage, Hold Breath, Mental Fortitude

### SPIRIT Attributes
- **Casting** - Spell casting ability
  - Skills: Range, Duration, Area of Effect, Weight, Number of targets
- **Attunement** - Magical affinity and connection
  - Skills: Fire, Water, Air, Earth, Life, Death, Mind, Body, Self
- **Innate** - Natural magical abilities
  - Skills: Flying, Camouflage, Shape Shifting
- **Worship** - Divine connection
  - Skills: Various gods/entities

## Skills (Tier 3)

Specific trained abilities under each attribute.

**Rating Range**: 0-8+ (no strict upper limit for highly trained individuals)

**Special Note**: All characters begin with **2 in Spoken Language** as a foundation.

## Total Skill Value

Final skill totals combine three components:
1. The skill rating
2. Its parent attribute rating
3. Its parent characteristic rating

**Formula**: Total = Characteristic + Attribute + Skill

**Example**:
- BODY: 2
- Strength: 3
- Carrying: 4
- **Total Carrying skill: 2 + 3 + 4 = 9**

Only total values are used for rolls.

## Character Creation Steps

### Step 1: Choose Starting Characteristics
- Choose **1** in two characteristics
- Choose **0** in the third characteristic

### Step 2: Distribute Attributes
Allocate values of **3, 2, 2, 1, 1, 1** among attributes under chosen characteristics.

Attributes under the 0-rated characteristic remain at 0.

### Step 3: Allocate Skills
Distribute **3, 2, 2, 2, 1, 1, 1, 1, 1** among skills.

Remember: All characters automatically have **Spoken Language: 2**.

## NPC Generation Guidelines

For NPCs in adventures, use simplified stat blocks:

### Basic NPC Format
```
Name (Gender, Age) - Race: Type [Level X]
SIZE:X  BODY:X  Str:X  End:X | MIND:X  Awr:X  RS:X
BP:X DB:X MD:X Reaction:X Dodge:X Armor:Type(AP)
Skills: Skill1:X Skill2:X Skill3:X
Weapons: Weapon (total) I:X O:X D:X d:X
Missile: Weapon [ammo] (total) O:X R:Xm d:X
Equip: Items... | $: Money
```

### Derived Stats
- **SIZE**: Body size rating (typically 3 for humans, can be 3½ for large individuals)
- **BP** (Body Points): SIZE × 2 + Fortitude/3
- **DB** (Damage Bonus): (SIZE + Wield weapon)/3
- **MD** (Mental Defense): (Mental Fortitude + Attunement Self)/3
- **Reaction**: Based on Awareness and Reaction speed skill
- **Dodge**: Dodge skill total

### Level Guidance
- **Level 1-2**: Novice adventurers, guards, common folk
- **Level 3-4**: Experienced warriors, skilled craftspeople
- **Level 5-6**: Veterans, master craftspeople
- **Level 7-8**: Heroes, legendary warriors
- **Level 9+**: Epic heroes, legendary figures

## Magic System

Only **1 in 50 humans** has Magical Aptitude (MA).

### Requirements for Magic Use
1. Possess Magical Aptitude (MA)
2. Develop a Womp (magical focus) - only 1/3 with MA
3. Learn spells - only 1/2 of those with Womp

### Spell Casting
Uses the **Casting** attribute and its skills:
- Range
- Duration
- Area of Effect
- Weight
- Number of targets

### Magical Attunement
Uses the **Attunement** attribute and element skills:
- Fire
- Water
- Air
- Earth
- Life
- Death
- Mind
- Body
- Self

## Combat Basics

### Initiative
Based on weapon speed and character's initiative modifier.

### Attack Roll
Roll under total weapon skill value.

### Defense Roll
Attacker's OFF vs. Defender's DEF.

### Damage
Weapon damage + damage bonus (d:) if attack succeeds.

### Armor
Reduces incoming damage by Armor Points (AP).

## Weapon Tables

### Melee Weapons

| Weapon | STR | INI | OFF | DEF | DAM | HP |
|--------|-----|-----|-----|-----|-----|-----|
| Unarmed | 0 | 1 | -2 | -4 | -4 | N/A |
| Knife | 1 | 2 | -2 | -3 | -2 | 8 |
| Short sword | 2 | 3 | -1 | -1 | -2 | 12 |
| Hatchet | 3 | 3 | -2 | -3 | -1 | 8 |
| Light mace | 3 | 3 | -1 | -2 | -2 | 8 |
| Staff | 3 | 6 | 0 | +2 | -2 | 7 |
| Rapier | 2 | 4 | 0 | -1 | -2 | 7 |
| Broad axe | 5 | 4 | -1 | -2 | 0 | 8 |
| Club | 4 | 4 | -1 | -2 | -2 | 8 |
| Heavy mace 1H | 6 | 4 | 0 | -1 | -1 | 8 |
| Heavy mace 2H | 4 | 4 | 0 | 0 | 0 | 8 |
| Longsword | 4 | 5 | 0 | 0 | -1 | 12 |
| Battle axe 1H | 9 | 5 | -1 | -1 | 1 | 8 |
| Battle axe 2H | 5 | 5 | -1 | 0 | 2 | 8 |
| Bastard sword 1H | 6 | 6 | 0 | 0 | -1 | 14 |
| Bastard sword 2H | 4 | 6 | 0 | +1 | 0 | 14 |
| Spear 1H | 4 | 6 | -1 | -4 | -2 | 7 |
| Great axe | 7 | 6 | 0 | +1 | 3 | 10 |
| Spear 2H | 4 | 7 | 0 | +2 | -1 | 7 |
| Halberd | 7 | 7 | 0 | +2 | 1 | 7 |
| Great sword | 6 | 7 | +1 | +1 | 1 | 16 |
| Hercules club | 6 | 7 | 0 | +1 | 2 | 10 |
| Buckler | 2 | — | N/A | +1 | N/A | 8 |
| Round shield | 4 | — | N/A | +2 | N/A | 10 |
| Kite shield | 6 | — | N/A | +3 | N/A | 12 |
| Dodge | 0 | — | N/A | -2 | N/A | N/A |

### Missile Weapons

| Weapon | STR | OFF | DAM | Range | Max Range |
|--------|-----|-----|-----|-------|-----------|
| Rock | 1 | -2 | -2 | 15m | 40m |
| Throwing knife | 1 | -1 | -3 | 15m | 25m |
| Sling | 2 | -3 | -2 | 40m | 120m |
| Bow (light) | 2 | 0 | 0 | 30m | 130m |
| Crossbow (light) | 2 | +2 | 1 | 20m | 100m |
| Javelin | 3 | -2 | 0 | 20m | 40m |
| Crossbow (medium) | 3 | +2 | 2 | 30m | 175m |
| Bow (medium) | 4 | 0 | 1 | 35m | 160m |
| Crossbow (heavy) | 4 | +2 | 3 | 40m | 250m |
| Bow (heavy) | 6 | 0 | 2 | 40m | 190m |
| Bow (very heavy) | 10 | 0 | 4 | 50m | 240m |
| Bow (giant's) | 15 | 0 | 6 | 60m | 300m |
| Pointing | 0 | +4 | X | 30m | 200m |

### Weapon Stat Format in NPC Blocks

**Melee Format**: Weapon (skill_total) I:ini O:off D:def d:dam HP:hp

**Melee Calculations:**
- I (Initiative) = weapon INI + Reaction Speed
- O (Offensive) = weapon OFF + weapon skill total
- D (Defensive) = weapon DEF + weapon skill total + (Dodge total / 5)
- d (Damage) = weapon DAM + character DB
- HP (Hit Points) = weapon HP

**Missile Format**: Weapon [ammo] (skill_total) O:off R:range d:dam

**Missile Calculations:**
- O (Offensive) = weapon OFF + weapon skill total
- d (Damage) = weapon DAM + character DB
- R (Range) = weapon range in meters
