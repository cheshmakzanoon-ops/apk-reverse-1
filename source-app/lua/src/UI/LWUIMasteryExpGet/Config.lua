local LWUIMasteryExpGet = {
  Name = UIWindowNames.LWUIMasteryExpGet,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWUIMasteryExpGet.Controller.LWUIMasteryExpGetCtrl"),
  View = require("UI.LWUIMasteryExpGet.View.LWUIMasteryExpGetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMastery/LWUIMasteryExpGet.prefab"
}
return {LWUIMasteryExpGet = LWUIMasteryExpGet}
