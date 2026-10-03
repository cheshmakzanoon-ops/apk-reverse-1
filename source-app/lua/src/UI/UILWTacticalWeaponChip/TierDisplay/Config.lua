local UITacticalChipTierDisplay = {
  Name = UIWindowNames.UITacticalChipTierDisplay,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeaponChip.TierDisplay.Controller.UITacticalChipTierDisplayCtrl"),
  View = require("UI.UILWTacticalWeaponChip.TierDisplay.View.UITacticalChipTierDisplayView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/UITacticalChipTierDisplay.prefab"
}
return {UITacticalChipTierDisplay = UITacticalChipTierDisplay}
