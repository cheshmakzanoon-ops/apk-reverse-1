local UILWSingleMomentDetailView = {
  Name = UIWindowNames.UILWSingleMomentDetailView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWSingleMomentDetailView.Controller.UILWSingleMomentDetailCtrl"),
  View = require("UI.LWPlayerInfo.UILWSingleMomentDetailView.View.UILWSingleMomentDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/MomentDetail/SingleMomentDetailView.prefab",
  HideBack = true
}
return {UILWSingleMomentDetailView = UILWSingleMomentDetailView}
