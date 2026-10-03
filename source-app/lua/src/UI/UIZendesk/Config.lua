local UIZendesk = {
  Name = UIWindowNames.UIZendesk,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UIZendesk.Controller.UIZendeskCtrl"),
  View = require("UI.UIZendesk.View.UIZendeskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIZendesk/UIZendesk.prefab",
  CustomKeyCodeEscape = true
}
return {UIZendesk = UIZendesk}
