local UILWSpecialResLack = {
  Name = UIWindowNames.UILWSpecialResLack,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWResourceLack.SpecialRes.Controller.LWUISpecialResLackCtrl"),
  View = require("UI.LWResourceLack.SpecialRes.View.LWUISpecialResLackView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWResource/LWSpecialResLack.prefab"
}
return {UILWSpecialResLack = UILWSpecialResLack}
