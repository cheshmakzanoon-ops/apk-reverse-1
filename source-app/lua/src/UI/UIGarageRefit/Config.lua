local UIGarageRefit = {
  Name = UIWindowNames.UIGarageRefit,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIGarageRefit.Controller.UIGarageRefitCtrl"),
  View = require("UI.UIGarageRefit.View.UIGarageRefitView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGarageRefit/UIGarageRefit.prefab"
}
return {UIGarageRefit = UIGarageRefit}
