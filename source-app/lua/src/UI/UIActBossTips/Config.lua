local UIActBossTips = {
  Name = UIWindowNames.UIActBossTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActBossTips.Controller.UIActBossTipsCtrl"),
  View = require("UI.UIActBossTips.View.UIActBossTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIWorldBossTip.prefab"
}
return {UIActBossTips = UIActBossTips}
