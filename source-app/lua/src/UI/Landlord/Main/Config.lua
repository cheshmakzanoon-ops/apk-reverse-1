local UILandlordMain = {
  Name = UIWindowNames.UILandlordMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.Landlord.Main.Ctrl.UILandlordMainCtrl"),
  View = require("UI.Landlord.Main.View.UILandlordMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Landlord/UILandlordMain.prefab",
  HideBack = true
}
return {UILandlordMain = UILandlordMain}
