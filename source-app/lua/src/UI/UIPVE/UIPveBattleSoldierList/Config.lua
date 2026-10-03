local UIPveBattleSoldierList = {
  Name = UIWindowNames.UIPveBattleSoldierList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPveBattleSoldierList.Controller.UIPveBattleSoldierListCtrl"),
  View = require("UI.UIPVE.UIPveBattleSoldierList.View.UIPveBattleSoldierListView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIPveBattleSoliderList.prefab"
}
return {UIPveBattleSoldierList = UIPveBattleSoldierList}
