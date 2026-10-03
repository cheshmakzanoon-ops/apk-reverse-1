local UIGhostParkourWaitLoading = {
  Name = UIWindowNames.UIGhostParkourWaitLoading,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGhostParkour.Inside.WaitLoading.Controller.UIGhostParkourWaitLoadingCtrl"),
  View = require("UI.UIGhostParkour.Inside.WaitLoading.View.UIGhostParkourWaitLoadingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GhostParkourBattle/Inside/UIGhostParkourWaitLoading.prefab"
}
return {UIGhostParkourWaitLoading = UIGhostParkourWaitLoading}
