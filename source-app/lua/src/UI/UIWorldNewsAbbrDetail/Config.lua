local UIWorldNewsAbbrDetail = {
  Name = UIWindowNames.UIWorldNewsAbbrDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWorldNewsAbbrDetail.Controller.UIWorldNewsAbbrDetailCtrl"),
  View = require("UI.UIWorldNewsAbbrDetail.View.UIWorldNewsAbbrDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIWorldNewsAbbrDetail.prefab"
}
return {UIWorldNewsAbbrDetail = UIWorldNewsAbbrDetail}
