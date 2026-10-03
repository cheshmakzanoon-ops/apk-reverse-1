local UITacticalWeaponChipChooseFeed = {
  Name = UIWindowNames.UITacticalWeaponChipChooseFeed,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeaponChip.ChooseFeed.Controller.UITacticalWeaponChipChooseFeedCtrl"),
  View = require("UI.UILWTacticalWeaponChip.ChooseFeed.View.UITacticalWeaponChipChooseFeedView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/UITacticalWeaponChipChooseFeed.prefab"
}
return {UITacticalWeaponChipChooseFeed = UITacticalWeaponChipChooseFeed}
