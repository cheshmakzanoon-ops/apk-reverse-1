local UIGovernmentOfficialBuff = {
  Name = UIWindowNames.UIGovernmentOfficialBuff,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.OfficialBuff.Controller.OfficialBuffCtrl"),
  View = require("UI.UIGovernment.OfficialBuff.View.OfficialBuffView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/OfficialBuff.prefab"
}
return {UIGovernmentOfficialBuff = UIGovernmentOfficialBuff}
