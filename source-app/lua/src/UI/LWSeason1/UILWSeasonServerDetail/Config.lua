local UILWSeasonServerDetail = {
  Name = UIWindowNames.UILWSeasonServerDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.UILWSeasonServerDetail.Controller.UILWSeasonServerDetailCtrl"),
  View = require("UI.LWSeason1.UILWSeasonServerDetail.View.UILWSeasonServerDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/UIServerDetail.prefab"
}
return {UILWSeasonServerDetail = UILWSeasonServerDetail}
