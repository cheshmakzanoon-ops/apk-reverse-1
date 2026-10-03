local UIMain = {
  Name = UIWindowNames.LWActivityPop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWGift.LWActivityPop.Controller.LWActivityPopCtrl"),
  View = require("UI.LWGift.LWActivityPop.View.LWActivityPopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGift/ActivityPopPanel.prefab"
}
return {UIMain = UIMain}
