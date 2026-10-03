local LWUIGiftPrivilege = {
  Name = UIWindowNames.LWUIGiftPrivilege,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWGiftSystem.GiftPrivilege.Controller.LWUIGiftPrivilegeCtrl"),
  View = require("UI.LWPlayerInfo.UILWGiftSystem.GiftPrivilege.View.LWUIGiftPrivilegeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/LWUIGiftPrivilege.prefab"
}
return {LWUIGiftPrivilege = LWUIGiftPrivilege}
