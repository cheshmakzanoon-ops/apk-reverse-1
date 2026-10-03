local LWUIActBountyHunterEventInfoTip = {
  Name = UIWindowNames.LWUIActBountyHunterEventInfoTip,
  Layer = UILayer.Info,
  Ctrl = require("UI/LWUIActBountyHunter/LWUIActBountyHunterEventInfoTip/Controller/LWUIActBountyHunterEventInfoTipCtrl"),
  View = require("UI/LWUIActBountyHunter/LWUIActBountyHunterEventInfoTip/View/LWUIActBountyHunterEventInfoTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterRules/UIActBountyHunterEventInfoTips.prefab"
}
return {LWUIActBountyHunterEventInfoTip = LWUIActBountyHunterEventInfoTip}
