local UIPlayerTitleDetail = {
  Name = UIWindowNames.UIPlayerTitleDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWTitle.UIPlayerTitleDetail.Controller.UIPlayerTitleDetailCtrl"),
  View = require("UI.LWTitle.UIPlayerTitleDetail.View.UIPlayerTitleDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWTitle/UIPlayerTitleDetail.prefab"
}
return {UIPlayerTitleDetail = UIPlayerTitleDetail}
