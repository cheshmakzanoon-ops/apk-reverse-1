local BountyHunterRules = {
  Name = UIWindowNames.BountyHunterRules,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActBountyHunter.LWUIActBountyHunterRules.Ctrl.UIActBountyHunterRulesCtrl"),
  View = require("UI.LWUIActBountyHunter.LWUIActBountyHunterRules.View.UIActBountyHunterRulesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterRules/UIActBountyHunterRules.prefab"
}
return {BountyHunterRules = BountyHunterRules}
