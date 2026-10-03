local SeasonSelectLocationGameSuccess = {
  Name = UIWindowNames.SeasonSelectLocationGameSuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI/LWSeason5/SeasonSelectLocationGame/Success/Ctrl/SeasonSelectLocationGameSuccessCtrl"),
  View = require("UI/LWSeason5/SeasonSelectLocationGame/Success/View/SeasonSelectLocationGameSuccessView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Activity/SeasonSelectLocationGame/SeasonSelectLocationGameSuccess.prefab",
  CustomKeyCodeEscape = true
}
return {SeasonSelectLocationGameSuccess = SeasonSelectLocationGameSuccess}
