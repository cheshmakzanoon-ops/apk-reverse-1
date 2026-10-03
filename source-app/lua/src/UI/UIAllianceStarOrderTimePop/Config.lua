local UIAllianceStarOrderTimePop = {
  Name = UIWindowNames.UIAllianceStarOrderTimePop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllianceStarOrderTimePop.Controller.UIAllianceStarOrderTimePopCtrl"),
  View = require("UI.UIAllianceStarOrderTimePop.View.UIAllianceStarOrderTimePopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllianceStar/UIAllianceStarOrderTimePop.prefab"
}
return {UIAllianceStarOrderTimePop = UIAllianceStarOrderTimePop}
