local UILWSaveGirlWarning = {
  Name = UIWindowNames.UILWSaveGirlWarning,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWSaveGirlWarning.Controller.UILWSaveGirlWarningCtrl"),
  View = require("UI.UILWSaveGirlWarning.View.UILWSaveGirlWarningView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSaveGirlWarning/LWSaveGirlWarning.prefab"
}
return {UILWSaveGirlWarning = UILWSaveGirlWarning}
