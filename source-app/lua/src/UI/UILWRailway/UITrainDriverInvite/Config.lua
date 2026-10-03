local UITrainDriverInvite = {
  Name = UIWindowNames.UITrainDriverInvite,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UITrainDriverInvite.Controller.UITrainDriverInviteCtrl"),
  View = require("UI.UILWRailway.UITrainDriverInvite.View.UITrainDriverInviteView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UITrainDriverInvite.prefab"
}
return {UITrainDriverInvite = UITrainDriverInvite}
