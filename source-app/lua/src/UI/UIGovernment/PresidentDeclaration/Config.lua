local UIGovernmentPresidentDeclaration = {
  Name = UIWindowNames.UIGovernmentPresidentDeclaration,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.PresidentDeclaration.Controller.PresidentDeclarationCtrl"),
  View = require("UI.UIGovernment.PresidentDeclaration.View.PresidentDeclarationView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/PresidentDeclaration.prefab"
}
return {UIGovernmentPresidentDeclaration = UIGovernmentPresidentDeclaration}
