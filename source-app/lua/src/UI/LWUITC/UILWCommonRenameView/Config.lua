local UILWCommonRenameView = {
  Name = UIWindowNames.UILWCommonRenameView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITC.UILWCommonRenameView.Ctrl.UILWCommonRenameViewCtrl"),
  View = require("UI.LWUITC.UILWCommonRenameView.View.UILWCommonRenameViewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWCommonRenameView/UILWCommonRenameView.prefab"
}
return {UILWCommonRenameView = UILWCommonRenameView}
