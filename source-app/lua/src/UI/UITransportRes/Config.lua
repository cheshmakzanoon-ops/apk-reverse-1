local UITransportRes = {
  Name = UIWindowNames.UITransportRes,
  Layer = UILayer.Background,
  Ctrl = require("UI.UITransportRes.Controller.UITransportResCtrl"),
  View = require("UI.UITransportRes.View.UITransportResView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UITransportRes/UITransportRes.prefab"
}
return {UITransportRes = UITransportRes}
