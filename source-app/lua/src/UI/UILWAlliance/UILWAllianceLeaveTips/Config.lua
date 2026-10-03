local UILWAllianceLeaveTips = {
  Name = UIWindowNames.UILWAllianceLeaveTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAllianceLeaveTips.Controller.UILWAllianceLeaveTipsCtrl"),
  View = require("UI.UILWAlliance.UILWAllianceLeaveTips.View.UILWAllianceLeaveTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAllianceLeaveTipsPanel.prefab"
}
return {UILWAllianceLeaveTips = UILWAllianceLeaveTips}
