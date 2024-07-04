//------------------------------------------------------------------------------
//   q_inc_switches::   Interface for switching subsystem functionality
//------------------------------------------------------------------------------
/*
    Added functionality for Project Q propriety subsystems.

    Note this library includes x2_inc_switches.
*/
//------------------------------------------------------------------------------
// Created By: Pstemarie
// Created On: 3 April 2011
//------------------------------------------------------------------------------
/*

    Updated 5/19/13 by pstemarie Q v1.7 - added a module switch that enables Builders to limit the unarmed styles to monks. Default is OFF.

*/


#include "x2_inc_switches"

//------------------------------------------------------------------------------
//                         M O D U L E  SWITCHES
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// * Force Use DLA Dynamic Quivers, Default = FALSE
// * If switched to TRUE, whenever a character equips arrows or bolts, a quiver
// * appears on the character's back.
//------------------------------------------------------------------------------
const string MODULE_SWITCH_ENABLE_DLA_DYNAMIC_QUIVERS = "Q_SWITCH_ENABLE_DLA_DYNAMIC_QUIVERS";

//------------------------------------------------------------------------------
// * Item Crafting - Lock Out Heraldic Robes, Default = FALSE
// * If switched to TRUE, a character will not be able to add a heraldic robe
// * when using the craft skills dialog.
//------------------------------------------------------------------------------
const string MODULE_SWITCH_ENABLE_LOCK_HERALDIC_ROBE_CRAFTING = "Q_SWITCH_ENABLE_LOCK_HERALDIC_ROBE_CRAFTING";

//------------------------------------------------------------------------------
// * Animations - Require two equipped weapons to use ACP Demonblade Style
// * If switched to TRUE, a character will not be able to use the demonblade
// * fighting style unless they have two melee weapons equipped. This switch is
// * enabled by default.
// *
// * This switch is included as a work-around for the known animation issue
// * when robes are equipped on a model using the ACP Demonblade phenotype.
// * When in melee combat and the secondary weapon is unequipped, the robe
// * appears to "swallow" the head. The animation remains "broken" until the
// * model is reset to the Normal phenotype.
// *
// * A variable has been included so that Builders can override the behavior
// * for individual creatures by setting the local variable
// * Q_FLAG_DEMONBLADE_MULTIWEAPON_OVERRIDE to TRUE (or "1") on the creature.
//------------------------------------------------------------------------------
const string MODULE_SWITCH_ENABLE_REQUIRE_DEMONBLADE_MULTIWEAPON = "Q_SWITCH_ENABLE_REQUIRE_DEMONBLADE_MULTIWEAPON";
const string CREATURE_FLAG_DEMONBLADE_MULTIWEAPON_OVERRIDE = "Q_FLAG_DEMONBLADE_MULTIWEAPON_OVERRIDE";

//------------------------------------------------------------------------------
// * Animations - Enabling this switch will only make the Hung, Muay, Shao, and
// * Shoto ACP Fighting Styles available to characters that have one or more
// * levels in the Monk class. This switch is disabled by default.
//------------------------------------------------------------------------------
const string MODULE_SWITCH_ENABLE_UNARMED_STYLES_LIMITATION = "Q_SWITCH_ENABLE_UNARMED_STYLES_LIMITATION";

