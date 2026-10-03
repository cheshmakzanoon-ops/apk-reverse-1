local UILWInfoPop = {
  Name = UIWindowNames.UILWInfoPop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWInfoPop.Controller.UILWInfoPopCtrl"),
  View = require("UI.UILWInfoPop.View.UILWInfoPopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWInfoPop/UILWInfoPop.prefab"
}
return {UILWInfoPop = UILWInfoPop}
