local ValentineChampionDisplay = {
  Name = UIWindowNames.ValentineChampionDisplay,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActValentineChampionDisplay.Ctrl.UIActValentineChampionDisplayCtrl"),
  View = require("UI.LWUIActValentineChampionDisplay.View.UIActValentineChampionDisplayView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/UIActValentineChampionDisplay.prefab"
}
return {ValentineChampionDisplay = ValentineChampionDisplay}
