local UITacticalWeaponChipSquad = {
  Name = UIWindowNames.UITacticalWeaponChipSquad,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeaponChip.Squad.UITacticalWeaponChipSquadCtrl"),
  View = require("UI.UILWTacticalWeaponChip.Squad.UITacticalWeaponChipSquadView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/UITacticalWeaponChipSquad.prefab"
}
return {UITacticalWeaponChipSquad = UITacticalWeaponChipSquad}
