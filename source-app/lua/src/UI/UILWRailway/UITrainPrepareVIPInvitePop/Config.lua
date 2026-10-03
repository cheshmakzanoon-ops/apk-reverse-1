local UITrainVIPInvitePopView = {
  Name = UIWindowNames.UITrainVIPInvitePopView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UITrainPrepareVIPInvitePop.Controller.UITrainVIPInvitePopCtrl"),
  View = require("UI.UILWRailway.UITrainPrepareVIPInvitePop.View.UITrainVIPInvitePopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/Scene/UITrainVIPInvitePop.prefab"
}
return {UITrainVIPInvitePopView = UITrainVIPInvitePopView}
