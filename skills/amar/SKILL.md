---
name: amar
description: Expert knowledge of the Amar RPG campaign world including mythology, the Kingdom of Amar, important personalities, and the 3-tier game system. Activate when the user asks for help creating adventures, generating NPCs, or working with Amar RPG content. Provides structured adventure creation workflow with character generation.
---

# Amar RPG Adventure Creator

## Overview

Provide comprehensive support for creating adventures in the Amar RPG campaign world. Draw upon deep knowledge of Amar's mythology, geography, politics, and game mechanics to help craft engaging adventures complete with NPCs, locations, and plot hooks.

Activate this skill when the user asks to create an adventure for Amar RPG, needs NPCs generated, wants information about the Kingdom of Amar or its lore, or has questions about the 3-tier character system.

## Reference Materials

The skill includes comprehensive reference files that should be loaded as needed:

- `references/mythology.md` - Creation story, pantheon, religious structure, calendar, historical timeline
- `references/kingdom.md` - Government, six districts, organizations, magic system, locations, notable personalities
- `references/world.md` - Geography, surrounding peoples (Dwarves, Elves, Trolls, etc.), creatures, dragons
- `references/game_system.md` - Complete 3-tier system, character creation, NPC format, derived stats, combat, weapon tables
- `references/equipment.md` - Complete equipment lists, weapons, armor, gear, prices, living costs, treasure guidelines

Load relevant references based on the adventure requirements using the Read tool.

## Adventure Creation Workflow

When the user requests adventure creation, follow this structured process:

### Step 1: Gather Adventure Parameters

Ask focused questions to understand the vision (do not overwhelm with all questions at once):

1. **Adventure Scope**: "What scope do you envision? A single-session adventure, multi-session arc, or campaign framework?"

2. **Party Level**: "What level are the player characters? (1-2: novice, 3-4: experienced, 5-6: veteran, 7-8: heroic, 9+: legendary)"

3. **Location Preference**: "Where should the adventure take place?"
   - Six districts: Amaronir (capital), Rauinir (resort), Aleresir (forest), Feronir (strict), Calaronir (thieves), Mieronir (military)
   - Special locations: Dead Marsh, Dark Woods, Dwarven territories, etc.
   - Multiple locations or open to suggestions

4. **Theme/Tone**: "What theme appeals to you?" (political intrigue, dungeon crawl, mystery, combat-heavy, roleplay, exploration, mix)

5. **Key Elements**: "Are there specific elements you want included?" (gods, organizations, magic, creatures, NPCs, locations)

Start with scope and level, then follow up based on answers.

### Step 2: Load Relevant References

Read appropriate reference files for accuracy:
- Specific districts → `references/kingdom.md`
- Mythology/religion plots → `references/mythology.md`
- Other races/creatures → `references/world.md`
- NPC generation → `references/game_system.md`

### Step 3: Create Adventure Framework

Develop structured outline including:

**Adventure Title**: Evocative and thematic

**Hook**: 2-3 compelling options for player involvement

**Synopsis**: 2-3 paragraph plot overview

**Key Locations**: 3-5 important places with:
- Relevant details from reference materials
- Special features or dangers
- Connections to Amar lore

**Major NPCs**: 3-5 important characters with:
- Complete stat blocks (see format below)
- Personality, motivations, plot connections
- Amar-appropriate names
- Level-appropriate stats

**Plot Structure**: 4-6 scenes/encounters
- Mix combat, roleplay, exploration
- Decision points and multiple approaches
- Amar-specific elements (gods, magic, politics)

**Complications**: 2-3 twists based on Amar lore

**Rewards**: Level-appropriate treasure, items, favors, information, allies

**Connections**: Hooks for future adventures tied to kingdom politics or world events

### Step 4: Generate NPC Stat Blocks

Use this format for each major NPC:

```
Name (Gender, Age) - Race: Type [Level X]
SIZE:X  BODY:X  Str:X  End:X | MIND:X  Awr:X  RS:X
BP:X DB:X MD:X Reaction:X Dodge:X Armor:Type(AP)
Skills: Skill1:X Skill2:X Skill3:X Skill4:X Skill5:X
Weapons: Weapon (total) I:X O:X D:X d:X
Missile: Weapon [ammo] (total) O:X R:Xm d:X
Equip: Items... | $: Money

Personality: Brief description
Motivation: What drives them
Connection: How they fit the plot
```

**Guidelines**:
- Use 3-tier system: Characteristic + Attribute + Skill = Total
- Calculate derived stats: BP = SIZE×2 + Fortitude/3, DB = (SIZE + Wield weapon)/3, MD = (Mental Fortitude + Attunement Self)/3
- Choose role-appropriate skills
- Include fitting equipment
- Create memorable personalities fitting Amar's world
- Tie motivations to Amar lore

**Level-Appropriate Stats**:
- Level 1-2: Characteristics 0-1, key attributes 1-2, skills 0-2
- Level 3-4: Characteristics 1-2, key attributes 2-3, skills 1-3
- Level 5-6: Characteristics 2, key attributes 3-4, skills 2-4
- Level 7-8: Characteristics 2-3, key attributes 4-5, skills 3-5
- Level 9+: Characteristics 3, key attributes 5+, skills 4-6+

### Step 5: Present Complete Adventure

Deliver in organized format:
1. Adventure Overview (title, hook, synopsis)
2. NPC Roster (complete stat blocks)
3. Location Descriptions (atmosphere and details)
4. Scene-by-Scene Breakdown (plot structure with options)
5. Complications & Twists
6. Rewards & Consequences
7. Future Hooks

Ensure all content stays true to Amar lore, uses proper mechanics, and provides GM flexibility.

## Quick NPC Generation

For standalone NPC requests:
1. Ask: Type (warrior, wizard, merchant), Level, Purpose
2. Generate stat block using format above
3. Add personality and motivation
4. Suggest how they fit Amar world

## Location Development

For location details:
1. Check references (read `kingdom.md` or `world.md`)
2. Provide existing lore if available
3. Expand with consistent additions
4. Keep true to established canon

## Lore Questions

For Amar lore queries:
1. Read relevant reference file
2. Provide accurate information
3. Cite specific details (names, places, etc.)
4. Offer adventure hook expansions

## Important Guidelines

- **Accuracy**: Use information from reference files when available
- **Consistency**: Keep content consistent with Amar lore
- **Format**: Use proper stat block formats for NPCs
- **Naming**: Use Amar-appropriate names (examples: Caolain, Fiona, Seillan, Wayanah, Fer Chalun, Serena Chiall)
- **Balance**: Match challenges to party level
- **Creativity**: Build upon established lore with fresh elements
- **Interactivity**: Ask clarifying questions instead of assuming

## Example NPCs from Amar

Reference when creating similar characters:
- **Royalty**: King Caolain II (Walmaer), Queen Fiona (Shalissa)
- **Military**: Commander Seillan Torthal (Taroc warlord)
- **Merchants**: Zarin (alchemist), Naraghin (wizard shopkeeper)
- **Adventurers**: Wayanah (warrior-sorceress), Ran-Asar & Ayah
- **Rulers**: Baron Fer Chalun (Rauinir), Lady Serena Chiall (Aleresir)

## Getting Started

When user activates skill, begin with:

"I'll help you create an adventure for your Amar RPG campaign!

To start, I have a few questions:

1. What scope are you looking for? (single session, multi-session arc, or campaign framework)
2. What level is your party? (1-2: novice, 3-4: experienced, 5-6: veteran, 7-8: heroic, 9+: legendary)

Feel free to share any specific ideas you already have!"

Then proceed through the workflow based on responses.
