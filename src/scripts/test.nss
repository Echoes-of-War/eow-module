/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrAnvilPublic
//
//  Desc:  Recipe initialization.
//
//  Author: David Bobeck 15May03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

////////////////////////////////////////////////////////////////////////
// NOTE: This file has been formatted to be compatible with RecipeMaker.
////////////////////////////////////////////////////////////////////////


void ProcessMenuWeaponsBron(string sMenuWeaponsBron);
void ProcessMenuWeaponsIron(string sMenuWeaponsIron);
void ProcessMenuWeaponsSteel(string sMenuWeaponsSteel);

void main()
{
  PrintString("cnrAnvilPublic init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrAnvilPublic
  /////////////////////////////////////////////////////////

  CnrRecipeSetDevicePreCraftingScript("cnrAnvilPublic", "cnr_anvil_anim");
  CnrRecipeSetDeviceEquippedTool("cnrAnvilPublic", "cnrSmithsHammer", CNR_FLOAT_SMITH_HAMMER_BREAKAGE_PERCENTAGE);
  CnrRecipeSetDeviceTradeskillType("cnrAnvilPublic", CNR_TRADESKILL_WEAPON_CRAFTING);


  string sMenuWeaponsBron = CnrRecipeAddSubMenu("cnrAnvilPublic", "Bronze Weapons");
  string sMenuWeaponsIron = CnrRecipeAddSubMenu("cnrAnvilPublic", "Iron Weapons");
  string sMenuWeaponsSteel = CnrRecipeAddSubMenu("cnrAnvilPublic", "Steel Weapons");

  CnrIncrementStackCount(OBJECT_SELF);
  AssignCommand(OBJECT_SELF, ProcessMenuWeaponsBron(sMenuWeaponsBron));

  CnrIncrementStackCount(OBJECT_SELF);
  AssignCommand(OBJECT_SELF, ProcessMenuWeaponsIron(sMenuWeaponsIron));

  CnrIncrementStackCount(OBJECT_SELF);
  AssignCommand(OBJECT_SELF, ProcessMenuWeaponsSteel(sMenuWeaponsSteel));
}

void ProcessMenuWeaponsBron(string sMenuWeaponsBron)
{
  string sKeyToRecipe;

  string sMenuBronAmmo = CnrRecipeAddSubMenu(sMenuWeaponsBron, "Bronze Ammo");
  string sMenuBronAxes = CnrRecipeAddSubMenu(sMenuWeaponsBron, "Bronze Axes");
  string sMenuBronBladed = CnrRecipeAddSubMenu(sMenuWeaponsBron, "Bronze Bladed");
  string sMenuBronBlunts = CnrRecipeAddSubMenu(sMenuWeaponsBron, "Bronze Blunts");
  string sMenuBronExotic = CnrRecipeAddSubMenu(sMenuWeaponsBron, "Bronze Exotic");
  string sMenuBronDouble = CnrRecipeAddSubMenu(sMenuWeaponsBron, "Bronze Double-Sided");
  string sMenuBronPolearms = CnrRecipeAddSubMenu(sMenuWeaponsBron, "Bronze Polearms");
  string sMenuBronThrowing = CnrRecipeAddSubMenu(sMenuWeaponsBron, "Bronze Throwing");

  /////////////// Bronze Weapons ///////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronAmmo, "Bronze Bullet", "cnrBulletBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronThrowing, "Bronze Dart", "cnrDartBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrFeatherRaven", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronThrowing, "Bronze Shuriken", "cnrShurikenBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronThrowing, "Bronze Throwing Axes", "cnrTAxeBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronExotic, "Bronze Kukri", "cnrKukriBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronExotic, "Bronze Sickle", "cnrSickleBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronPolearms, "Bronze Spear", "cnrSpearBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBladed, "Bronze Dagger", "cnrDaggerBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBlunts, "Light Bronze Hammer", "cnrLtHammerBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronExotic, "Bronze Kama", "cnrKamaBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronAxes, "Bronze Handaxe", "cnrHandAxeBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBlunts, "Light Bronze Flail", "cnrLtFlailBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronPolearms, "Bronze Scythe", "cnrScytheBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBladed, "Bronze Scimitar", "cnrScimitarBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBlunts, "Bronze Mace", "cnrMaceBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBlunts, "Bronze Morningstar", "cnrMstarBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronPolearms, "Bronze Halberd", "cnrHalberdBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBladed, "Bronze Shortsword", "cnrShSwordBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronAxes, "Bronze Battleaxe", "cnrBattleAxeBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBlunts, "Bronze Warhammer", "cnrWarHammerBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBladed, "Bronze Rapier", "cnrRapierBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBlunts, "Bronze Heavy Flail", "cnrHyFlailBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronExotic, "Bronze Katana", "cnrKatanaBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronDouble, "Bronze Dire Mace", "cnrDireMaceBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBladed, "Bronze Longsword", "cnrLgSwordBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronAxes, "Bronze Greataxe", "cnrGreatAxeBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronDouble, "Bronze Double Axe", "cnrDoubleAxeBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBladed, "Bronze Bastard Sword", "cnrBaSwordBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 7);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronDouble, "Bronze Two-Bladed Sword", "cnrDSwordBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 12);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuBronBladed, "Bronze Greatsword", "cnrGrSwordBron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotBron", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  CnrDecrementStackCount(OBJECT_SELF);
}

void ProcessMenuWeaponsIron(string sMenuWeaponsIron)
{
  string sKeyToRecipe;

  string sMenuIronAmmo = CnrRecipeAddSubMenu(sMenuWeaponsIron, "Iron Ammo");
  string sMenuIronAxes = CnrRecipeAddSubMenu(sMenuWeaponsIron, "Iron Axes");
  string sMenuIronBladed = CnrRecipeAddSubMenu(sMenuWeaponsIron, "Iron Bladed");
  string sMenuIronBlunts = CnrRecipeAddSubMenu(sMenuWeaponsIron, "Iron Blunts");
  string sMenuIronExotic = CnrRecipeAddSubMenu(sMenuWeaponsIron, "Iron Exotic");
  string sMenuIronDouble = CnrRecipeAddSubMenu(sMenuWeaponsIron, "Iron Double-Sided");
  string sMenuIronPolearms = CnrRecipeAddSubMenu(sMenuWeaponsIron, "Iron Polearms");
  string sMenuIronThrowing = CnrRecipeAddSubMenu(sMenuWeaponsIron, "Iron Throwing");

  /////////////// Iron Weapons ///////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronAmmo, "Iron Bullet", "cnrBulletIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronThrowing, "Iron Dart", "cnrDartIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrFeatherRaven", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledCopp", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronThrowing, "Iron Throwing Axes", "cnrTAxeIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronThrowing, "Iron Shuriken", "cnrShurikenIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronExotic, "Iron Kukri", "cnrKukriIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronExotic, "Iron Sickle", "cnrSickleIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 9);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronPolearms, "Iron Spear", "cnrSpearIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBladed, "Iron Dagger", "cnrDaggerIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 2);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBlunts, "Light Iron Hammer", "cnrLtHammerIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftMahog", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronExotic, "Iron Kama", "cnrKamaIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 2);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronAxes, "Iron Handaxe", "cnrHandAxeIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBlunts, "Light Iron Flail", "cnrLtFlailIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronPolearms, "Iron Scythe", "cnrScytheIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBladed, "Iron Scimitar", "cnrScimitarIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBlunts, "Iron Mace", "cnrMaceIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBlunts, "Iron Morningstar", "cnrMstarIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronPolearms, "Iron Halberd", "cnrHalberdIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBladed, "Iron Shortsword", "cnrShSwordIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 4);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronAxes, "Iron Battleaxe", "cnrBattleAxeIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBlunts, "Iron Warhammer", "cnrWarHammerIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldMedium", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBladed, "Iron Rapier", "cnrRapierIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBlunts, "Heavy Iron Flail", "cnrHyFlailIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronExotic, "Iron Katana", "cnrKatanaIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 7);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 70, 70);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronDouble, "Iron Dire Mace", "cnrDireMaceIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBladed, "Iron Longsword", "cnrLgSwordIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronAxes, "Iron Greataxe", "cnrGreatAxeIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronDouble, "Iron Double Axe", "cnrDoubleAxeIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 6);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBladed, "Iron Bastard Sword", "cnrBaSwordIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 7);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronDouble, "Iron Two-Bladed Sword", "cnrDSwordIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 12);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrShaftOak", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuIronBladed, "Iron Greatsword", "cnrGrSwordIron", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 8);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldLarge", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledIron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  CnrDecrementStackCount(OBJECT_SELF);
}

void ProcessMenuWeaponsSteel(string sMenuWeaponsSteel)
{
  string sKeyToRecipe;

  string sMenuSteelAmmo = CnrRecipeAddSubMenu(sMenuWeaponsSteel, "Steel Ammo");
  string sMenuSteelAxes = CnrRecipeAddSubMenu(sMenuWeaponsSteel, "Steel Axes");
  string sMenuSteelBladed = CnrRecipeAddSubMenu(sMenuWeaponsSteel, "Steel Bladed");
  string sMenuSteelBlunts = CnrRecipeAddSubMenu(sMenuWeaponsSteel, "Steel Blunts");
  string sMenuSteelExotic = CnrRecipeAddSubMenu(sMenuWeaponsSteel, "Steel Exotic");
  string sMenuSteelDouble = CnrRecipeAddSubMenu(sMenuWeaponsSteel, "Steel Double-Sided");
  string sMenuSteelPolearms = CnrRecipeAddSubMenu(sMenuWeaponsSteel, "Steel Polearms");
  string sMenuSteelThrowing = CnrRecipeAddSubMenu(sMenuWeaponsSteel, "Steel Throwing");

  /////////////// Steel Weapons ///////////////

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuSteelAmmo, "Steel Bullet", "cnrBulletSteel", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotSteel", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrMoldSmall", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  CnrRecipeSetRecipeBiproduct(sKeyToRecipe, "cnrMangledBron", 0, 1);
  CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 70, 30, 0, 0, 0, 0);

  CnrDecrementStackCount(OBJECT_SELF);
}
