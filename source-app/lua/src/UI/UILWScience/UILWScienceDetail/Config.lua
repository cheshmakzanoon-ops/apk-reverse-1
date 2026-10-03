local UILWScienceDetail = {
  Name = UIWindowNames.UILWScienceDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWScience.UILWScienceDetail.Controller.UILWScienceDetailCtrl"),
  View = require("UI.UILWScience.UILWScienceDetail.View.UILWScienceDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWScience/UILWScienceDetail.prefab"
}
return {UILWScienceDetail = UILWScienceDetail}
