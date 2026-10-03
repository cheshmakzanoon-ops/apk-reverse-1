local UIGhostParkourRecordListView = {
  Name = UIWindowNames.UIGhostParkourRecordListView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGhostParkour.Outside.RecordInMain.Ctrl.UIGhostParkourRecordListCtrl"),
  View = require("UI.UIGhostParkour.Outside.RecordInMain.View.UIGhostParkourRecordListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GhostParkourBattle/OutsideUI/UIGhostParkourRecordList.prefab"
}
return {UIGhostParkourRecordListView = UIGhostParkourRecordListView}
