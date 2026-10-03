local UITalentChoose = {
  Name = UIWindowNames.UITalentChoose,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UITalent.UITalentChoose.Controller.UITalentChooseCtrl"),
  View = require("UI.UITalent.UITalentChoose.View.UITalentChooseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UITalent/UITalentChoose.prefab"
}
return {UITalentChoose = UITalentChoose}
