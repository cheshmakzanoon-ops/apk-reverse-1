local UITrainVIPInviteList = {
  Name = UIWindowNames.UITrainVIPInviteList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UITrainPrepareVIPInviteList.Controller.UITrainVIPInviteListCtrl"),
  View = require("UI.UILWRailway.UITrainPrepareVIPInviteList.View.UITrainVIPInviteListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/Scene/UITrainVIPInviteList.prefab"
}
return {UITrainVIPInviteList = UITrainVIPInviteList}
