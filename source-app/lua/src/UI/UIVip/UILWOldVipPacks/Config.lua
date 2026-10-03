local UILWOldVipPacks = {
  Name = UIWindowNames.UILWOldVipPacks,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIVip.UILWOldVipPacks.Controller.UILWOldVipPacksCtrl"),
  View = require("UI.UIVip.UILWOldVipPacks.View.UILWOldVipPacksView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWVIPPanel/UILWOldPacks.prefab"
}
return {WorldDesUI = UILWOldVipPacks}
