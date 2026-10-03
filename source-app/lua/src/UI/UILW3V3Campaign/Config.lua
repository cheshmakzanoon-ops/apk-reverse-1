local UILW3V3Campaign = {
  Name = UIWindowNames.UILW3V3Campaign,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILW3V3Campaign.Controller.UILW3V3CampaignCtrl"),
  View = require("UI.UILW3V3Campaign.View.UILW3V3CampaignView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/LWUI3V3Campaign.prefab",
  CustomKeyCodeEscape = true
}
return {UILW3V3Campaign = UILW3V3Campaign}
