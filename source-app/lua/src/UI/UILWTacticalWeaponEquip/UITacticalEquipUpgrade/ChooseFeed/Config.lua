local UITacticalEquipChooseFeed = {
  Name = UIWindowNames.UITacticalEquipChooseFeed,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.ChooseFeed.Ctrl.UITacticalEquipChooseFeedCtrl"),
  View = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.ChooseFeed.View.UITacticalEquipChooseFeedView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/EquipV2/UITacticalEquipChooseFeed.prefab"
}
return {UITacticalEquipChooseFeed = UITacticalEquipChooseFeed}
