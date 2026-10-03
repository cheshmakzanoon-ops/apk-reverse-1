local UIItemTips = {
  Name = UIWindowNames.UIItemTips,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIItemTips.Controller.UIItemTipsController"),
  View = require("UI.UIItemTips.View.UIItemTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UIItemTips.prefab"
}
return {UIItemTips = UIItemTips}
