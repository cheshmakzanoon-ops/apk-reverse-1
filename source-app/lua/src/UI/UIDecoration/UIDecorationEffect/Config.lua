local UIDecorationEffect = {
  Name = UIWindowNames.UIDecorationEffect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDecoration.UIDecorationEffect.Controller.UIDecorationEffectCtrl"),
  View = require("UI.UIDecoration.UIDecorationEffect.View.UIDecorationEffectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIDecoration/UIDecorationEffect.prefab"
}
return {UIDecorationEffect = UIDecorationEffect}
