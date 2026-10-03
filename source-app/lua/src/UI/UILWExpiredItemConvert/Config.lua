local UILWExpiredItemConvert = {
  Name = UIWindowNames.UILWExpiredItemConvert,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWExpiredItemConvert.Controller.UILWExpiredItemConvertCtrl"),
  View = require("UI.UILWExpiredItemConvert.View.UILWExpiredItemConvertView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWBag/UILWExpiredItemConvert.prefab"
}
return {UILWExpiredItemConvert = UILWExpiredItemConvert}
