local UILWSingleActivityContainer = {
  Name = UIWindowNames.UILWSingleActivityContainer,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.UILWSingleActivityContainer.Controller.UILWSingleActivityContainerCtrl"),
  View = require("UI.LWSeason.UILWSingleActivityContainer.View.UILWSingleActivityContainerView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/SingleActivityContainer.prefab",
  CustomKeyCodeEscape = true,
  HideBack = true
}
return {UILWSingleActivityContainer = UILWSingleActivityContainer}
