local LWCityFightCountTimeToGo = {
  Name = UIWindowNames.LWCityFightCountTimeToGo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWCityFightCountTimeToGo.LWCityFightCountTimeToGoCtrl"),
  View = require("UI.LWCityFightCountTimeToGo.LWCityFightCountTimeToGoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICityEvent/LWCityFightCountTimeToGo.prefab",
  DontPushWindowStack = true
}
return {LWCityFightCountTimeToGo = LWCityFightCountTimeToGo}
