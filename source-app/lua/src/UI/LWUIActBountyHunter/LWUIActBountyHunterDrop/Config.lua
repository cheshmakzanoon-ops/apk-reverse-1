local UIActBountyHunterDrop = {
  Name = UIWindowNames.UIActBountyHunterDrop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActBountyHunter.LWUIActBountyHunterDrop.Ctrl.UIActBountyHunterDropCtrl"),
  View = require("UI.LWUIActBountyHunter.LWUIActBountyHunterDrop.View.UIActBountyHunterDropView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterRules/UIActBountyHunterDrop.prefab"
}
return {UIActBountyHunterDrop = UIActBountyHunterDrop}
