local UILWWorldTip = {
  Name = UIWindowNames.UILWWorldTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWWorldTip.Controller.UILWWorldTipCtrl"),
  View = require("UI.UILWWorldTip.View.UILWWorldTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWWorldTip/UILWWorldTipPanel.prefab"
}
return {UILWWorldTip = UILWWorldTip}
