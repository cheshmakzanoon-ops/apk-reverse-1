local LWMainEpidemicZoneUI = {
  Name = UIWindowNames.LWMainEpidemicZoneUI,
  Layer = UILayer.UIResource,
  Ctrl = require("UI.BattleFieldBase.BattleFieldBaseCtrl"),
  View = require("UI.LWMainEpidemicZoneUI.View.LWMainEpidemicZoneUIView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/Common/LWMainEpidemicZoneUI.prefab"
}
return {LWMainEpidemicZoneUI = LWMainEpidemicZoneUI}
