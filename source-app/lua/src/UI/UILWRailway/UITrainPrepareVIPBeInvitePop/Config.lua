local UITrainVIPBeInvitedPop = {
  Name = UIWindowNames.UITrainVIPBeInvitedPop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UITrainPrepareVIPBeInvitePop.Controller.UITrainVIPInviteListCtrl"),
  View = require("UI.UILWRailway.UITrainPrepareVIPBeInvitePop.View.UITrainVIPBeInvitedPopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/Scene/UITrainVIPBeInvitedPop.prefab"
}
return {UITrainVIPBeInvitedPop = UITrainVIPBeInvitedPop}
