local UIGhostParkourRecordPopView = {
  Name = UIWindowNames.UIGhostParkourRecordPopView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGhostParkour.Outside.RecordPop.Ctrl.UIGhostParkourRecordPopCtrl"),
  View = require("UI.UIGhostParkour.Outside.RecordPop.View.UIGhostParkourRecordPopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GhostParkourBattle/OutsideUI/UIGhostParkourRecordPop.prefab"
}
return {UIGhostParkourRecordPopView = UIGhostParkourRecordPopView}
