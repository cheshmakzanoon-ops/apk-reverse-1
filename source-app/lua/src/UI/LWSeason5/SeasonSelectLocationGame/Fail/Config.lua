local SeasonSelectLocationGameFail = {
  Name = UIWindowNames.SeasonSelectLocationGameFail,
  Layer = UILayer.Normal,
  Ctrl = require("UI/LWSeason5/SeasonSelectLocationGame/Fail/Ctrl/SeasonSelectLocationGameCtrl"),
  View = require("UI/LWSeason5/SeasonSelectLocationGame/Fail/View/SeasonSelectLocationGameFailView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Activity/SeasonSelectLocationGame/SeasonSelectLocationGameFail.prefab",
  CustomKeyCodeEscape = true
}
return {SeasonSelectLocationGameFail = SeasonSelectLocationGameFail}
