local UITorchRelayCheerSelectMember = {
  Name = UIWindowNames.UITorchRelayCheerSelectMember,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWTorchRelay.Activity.CheerMemberSelect.Ctrl.UITorchRelayCheerSelectMemberCtrl"),
  View = require("UI.LWTorchRelay.Activity.CheerMemberSelect.View.UITorchRelayCheerSelectMemberView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/TorchRelay/Main/UITorchRelayCheerSelectMember.prefab"
}
return {UITorchRelayCheerSelectMember = UITorchRelayCheerSelectMember}
