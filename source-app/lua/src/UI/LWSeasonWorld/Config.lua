local LWSeasonWorld = {
  Name = UIWindowNames.LWSeasonWorld,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonWorld.Controller.LWSeasonWorldCtrl"),
  View = require("UI.LWSeasonWorld.View.LWSeasonWorldView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeasonWorld/LWSeasonWorld.prefab",
  HideBack = true
}
if Config.IsPC() then
  LWSeasonWorld.HideBack = false
end
return {LWSeasonWorld = LWSeasonWorld}
