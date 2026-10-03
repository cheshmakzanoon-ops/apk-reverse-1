local UIActValentineMatch = {
  Name = UIWindowNames.UIActValentineMatch,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActValentineMatch.Ctrl.UIActValentineMatchCtrl"),
  View = require("UI.LWUIActValentineMatch.View.UIActValentineMatchView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/UIActValentineMatch.prefab",
  CustomKeyCodeEscape = true
}
return {UIActValentineMatch = UIActValentineMatch}
