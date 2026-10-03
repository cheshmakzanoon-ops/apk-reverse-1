local LWUITCExpGet = {
  Name = UIWindowNames.LWUITCExpGet,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWUITCExpGet.Controller.LWUITCExpGetCtrl"),
  View = require("UI.LWUITCExpGet.View.LWUITCExpGetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/LWUITCExpGet.prefab"
}
return {LWUITCExpGet = LWUITCExpGet}
