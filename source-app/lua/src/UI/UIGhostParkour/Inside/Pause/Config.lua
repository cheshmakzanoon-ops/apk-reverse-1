local UIGhostParkourPause = {
  Name = UIWindowNames.UIGhostParkourPause,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGhostParkour.Inside.Pause.Controller.UIGhostParkourPauseCtrl"),
  View = require("UI.UIGhostParkour.Inside.Pause.View.UIGhostParkourPauseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GhostParkourBattle/Inside/UIGhostParkourPause.prefab"
}
return {UIGhostParkourPause = UIGhostParkourPause}
