local UILWGoldDetail = {
  Name = UIWindowNames.UILWGoldDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWGoldDetail.Control.UILWGoldDetailCtrl"),
  View = require("UI.UILWGoldDetail.View.UILWGoldDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/UILWGoldDetail.prefab"
}
return {UILWGoldDetail = UILWGoldDetail}
