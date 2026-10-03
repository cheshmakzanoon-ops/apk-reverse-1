local UIForcesDetail = {
  Name = UIWindowNames.UIForcesDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIForcesDetail.Controller.UIForcesDetailCtrl"),
  View = require("UI.UIForcesDetail.View.UIForcesDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIForcesDetail/UIForcesDetail.prefab"
}
return {UIForcesDetail = UIForcesDetail}
