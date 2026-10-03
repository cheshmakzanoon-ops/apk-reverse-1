local UILWRapid = {
  Name = UIWindowNames.UILWRapid,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRapid.Controller.UILWRapidCtrl"),
  View = require("UI.UILWRapid.View.UILWRapidView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRapid/UILWRapid.prefab"
}
return {UILWRapid = UILWRapid}
