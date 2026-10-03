local ThanksLetter = {
  Name = UIWindowNames.ThanksLetter,
  Layer = UILayer.Normal,
  Ctrl = require("UI.ThanksLetter.Ctrl.ThanksLetterCtrl"),
  View = require("UI.ThanksLetter.View.ThanksLetterView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ThanksLetter2024/ThanksLetterView.prefab"
}
return {ThanksLetter = ThanksLetter}
