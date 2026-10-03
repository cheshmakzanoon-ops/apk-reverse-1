local UILLGroupChoose = {
  Name = UIWindowNames.UILLGroupChoose,
  Layer = UILayer.Normal,
  Ctrl = require("UI.Landlord.GroupChoose.Ctrl.UILLGroupChooseCtrl"),
  View = require("UI.Landlord.GroupChoose.View.UILLGroupChooseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Landlord/LLGroupChoosePanel.prefab"
}
return {UILLGroupChoose = UILLGroupChoose}
