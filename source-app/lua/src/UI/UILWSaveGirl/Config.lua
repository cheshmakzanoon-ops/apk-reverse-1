local UILWSaveGirl = {
  Name = UIWindowNames.UILWSaveGirl,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWSaveGirl.Controller.UILWSaveGirlCtrl"),
  View = require("UI.UILWSaveGirl.View.UILWSaveGirlView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSaveGirl/UILWSaveGirl.prefab",
  HideBack = true,
  CustomKeyCodeEscape = true
}
return {UILWSaveGirl = UILWSaveGirl}
