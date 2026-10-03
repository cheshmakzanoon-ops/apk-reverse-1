local UILWArena3V3PlayerInfo = {
  Name = UIWindowNames.UILWArena3V3PlayerInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWArena3V3PlayerInfo.Controller.UILWArena3V3PlayerInfoCtrl"),
  View = require("UI.UILWArena3V3PlayerInfo.View.UILWArena3V3PlayerInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/LWUIArena3V3PlayerInfo.prefab"
}
return {UILWArena3V3PlayerInfo = UILWArena3V3PlayerInfo}
