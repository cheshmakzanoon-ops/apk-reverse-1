local UIVipExtend = {
  Name = UIWindowNames.UIVipExtend,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIVipExtend.Controller.UIVipExtendMainCtrl"),
  View = require("UI.UIVipExtend.View.UIVipExtendMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIVipExtend/UIVipExtendMain.prefab"
}
return {UIVipExtend = UIVipExtend}
