local UIGovernmentPresidentBuff = {
  Name = UIWindowNames.UIGovernmentPresidentBuff,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.PresidentBuff.Controller.PresidentBuffCtrl"),
  View = require("UI.UIGovernment.PresidentBuff.View.PresidentBuffView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/PresidentBuff.prefab"
}
return {UIGovernmentPresidentBuff = UIGovernmentPresidentBuff}
