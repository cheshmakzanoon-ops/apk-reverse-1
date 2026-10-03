local UILWCityBuff = {
  Name = UIWindowNames.UILWCityBuff,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWCityBuff.Controller.UILWCityBuffCtrl"),
  View = require("UI.UILWCityBuff.View.UILWCityBuffView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWCityBuff/UILWCityBuff.prefab"
}
return {UILWCityBuff = UILWCityBuff}
