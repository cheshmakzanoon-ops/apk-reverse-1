local UITrainPrepareMemberList = {
  Name = UIWindowNames.UITrainPrepareMemberList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UITrainPrepareMemberList.Controller.UITrainPrepareMemberListCtrl"),
  View = require("UI.UILWRailway.UITrainPrepareMemberList.View.UITrainPrepareMemberListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/Scene/UITrainPrepareMemberList.prefab"
}
return {UITrainPrepareMemberList = UITrainPrepareMemberList}
