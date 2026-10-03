local UIGolloesCamp = {
  Name = UIWindowNames.UIGolloesCamp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGolloesCamp.Controller.UIGolloesCampCtrl"),
  View = require("UI.UIGolloesCamp.View.UIGolloesCampView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGolloesCamp/UIGolloesCamp.prefab"
}
return {UIGolloesCamp = UIGolloesCamp}
