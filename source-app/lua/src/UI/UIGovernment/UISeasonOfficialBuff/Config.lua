local UISeasonOfficialBuff = {
  Name = UIWindowNames.UISeasonOfficialBuff,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UISeasonOfficialBuff.UISeasonOfficialBuffCtrl"),
  View = require("UI.UIGovernment.UISeasonOfficialBuff.UISeasonOfficialBuffView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/UISeasonOfficialBuff.prefab"
}
return {UISeasonOfficialBuff = UISeasonOfficialBuff}
