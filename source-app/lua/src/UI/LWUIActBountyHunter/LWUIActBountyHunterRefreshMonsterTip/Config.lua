local LWUIActBountyHunterRefreshMonsterTip = {
  Name = UIWindowNames.LWUIActBountyHunterRefreshMonsterTip,
  Layer = UILayer.Info,
  Ctrl = require("UI/LWUIActBountyHunter/LWUIActBountyHunterRefreshMonsterTip/Controller/LWUIActBountyHunterRefreshMonsterTipCtrl"),
  View = require("UI/LWUIActBountyHunter/LWUIActBountyHunterRefreshMonsterTip/View/LWUIActBountyHunterRefreshMonsterTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/UIActBountyHunterRefreshMonsterTip.prefab"
}
return {LWUIActBountyHunterRefreshMonsterTip = LWUIActBountyHunterRefreshMonsterTip}
