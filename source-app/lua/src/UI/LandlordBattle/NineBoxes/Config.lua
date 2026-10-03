local UILLNineBox = {
  Name = UIWindowNames.UILLNineBox,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LandlordBattle.NineBoxes.Controller.LLNineBoxCtrl"),
  View = require("UI.LandlordBattle.NineBoxes.View.LLNineBoxView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Landlord/World/LLNineBoxView.prefab"
}
return {UILLNineBox = UILLNineBox}
