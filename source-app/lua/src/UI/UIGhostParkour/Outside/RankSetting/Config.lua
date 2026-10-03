local UIGhostParkourSettingView = {
  Name = UIWindowNames.UIGhostParkourSettingView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGhostParkour.Outside.RankSetting.Ctrl.UIGhostParkourSettingCtrl"),
  View = require("UI.UIGhostParkour.Outside.RankSetting.View.UIGhostParkourSettingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GhostParkourBattle/OutsideUI/UIGhostParkourSetting.prefab"
}
return {UIGhostParkourSettingView = UIGhostParkourSettingView}
