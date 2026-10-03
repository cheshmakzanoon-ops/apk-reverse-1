local UILWPlayerDetail = {
  Name = UIWindowNames.UILWPlayerDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWPlayerDetail.Controller.UILWPlayerDetailCtrl"),
  View = require("UI.LWPlayerInfo.UILWPlayerDetail.View.UILWPlayerDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/PlayerDetailMain_new.prefab"
}
return {UILWPlayerDetail = UILWPlayerDetail}
