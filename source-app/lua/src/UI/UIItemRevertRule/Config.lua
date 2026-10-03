local UIItemRevertRule = {
  Name = UIWindowNames.UIItemRevertRule,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIItemRevertRule.Controller.UIItemRevertRuleCtrl"),
  View = require("UI.UIItemRevertRule.View.UIItemRevertRuleView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIItemRevert/UIItemRevertRule.prefab",
  HideBack = false,
  CustomKeyCodeEscape = false
}
return {UIItemRevertRule = UIItemRevertRule}
