local UILWResourceLack = {
  Name = UIWindowNames.UILWResourceLack,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWResourceLack.Res.Controller.LWUIResourceLackCtrl"),
  View = require("UI.LWResourceLack.Res.View.LWUIResourceLackView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWResource/LWResourceLack.prefab"
}
return {UILWResourceLack = UILWResourceLack}
