local UILWDecorationBookDetail = {
  Name = UIWindowNames.LWDecorationBookDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWDecorationBookDetail.Controller.LWDecorationBookDetailCtrl"),
  View = require("UI.LWDecorationBookDetail.View.LWDecorationBookDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIDecorationBook/UIDecorationBookDetail.prefab"
}
return {UILWDecorationBookDetail = UILWDecorationBookDetail}
