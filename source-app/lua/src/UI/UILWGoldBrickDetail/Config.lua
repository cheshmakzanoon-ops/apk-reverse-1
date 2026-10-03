local UILWGoldBrickDetail = {
  Name = UIWindowNames.UILWGoldBrickDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWGoldBrickDetail.Control.UILWGoldBrickDetailCtrl"),
  View = require("UI.UILWGoldBrickDetail.View.UILWGoldBrickDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/UILWGoldBrickDetail.prefab"
}
return {UILWGoldBrickDetail = UILWGoldBrickDetail}
