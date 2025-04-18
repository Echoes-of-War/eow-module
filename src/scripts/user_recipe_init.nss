#include "cnr_recipe_utils"

void main()
{
  string sKeyToRecipe;

 ///string sMenuForgePublic = CnrRecipeAddSubMenu("cnrForgePublic", "Mod Items");
 /////////////////////////////////////////////////////////////////////////////////////
 //             ingots
 /////////////////////////////////////////////////////////////////////////////////////

 sKeyToRecipe = CnrRecipeCreateRecipe("cnrForgePublic", "Copper Ingot(s)", "cnrIngotCopp", 1);
 CnrRecipeAddComponent(sKeyToRecipe, "cnrNuggetCopp", 1);
 CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
 CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
 CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 75, 25, 0, 0, 0, 0);

 sKeyToRecipe = CnrRecipeCreateRecipe("cnrForgePublic", "Tin Ingot(s)", "cnrIngotTin", 1);
 CnrRecipeAddComponent(sKeyToRecipe, "cnrNuggetTin", 1);
 CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
 CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
 CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 25, 75, 0, 0, 0, 0);

 sKeyToRecipe = CnrRecipeCreateRecipe("cnrForgePublic", "Bronze Ingot(s)", "cnrIngotBron", 1);
 CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotTin", 1);
 CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotCopp", 1);
 CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
 CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);
 CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 25, 75, 0, 0, 0, 0);

 sKeyToRecipe = CnrRecipeCreateRecipe("cnrForgePublic", "Iron Ingot(s)", "cnrIngotIron", 1);
 CnrRecipeAddComponent(sKeyToRecipe, "cnrNuggetIron", 1);
 CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
 CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
 CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 25, 75, 0, 0, 0, 0);

 sKeyToRecipe = CnrRecipeCreateRecipe("cnrForgePublic", "Steel Ingot", "cnrIngotSteel", 1);
 CnrRecipeAddComponent(sKeyToRecipe, "cnrIngotIron", 4, 0);
 CnrRecipeAddComponent(sKeyToRecipe, "cnrCharcoal", 1, 0);
 CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
 CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
 CnrRecipeSetRecipeAbilityPercentages(sKeyToRecipe, 75, 25, 0, 0, 0, 0);


 string sMenuForgePublic = CnrRecipeAddSubMenu("cnrAlchemyTable", "Mod Items");
 /////////////////////////////////////////////////////////////////////////////////////
 //             potions
 /////////////////////////////////////////////////////////////////////////////////////
}
