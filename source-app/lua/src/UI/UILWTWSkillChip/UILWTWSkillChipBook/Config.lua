local UILWTWSkillChipBook = {
  Name = UIWindowNames.UILWTWSkillChipBook,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTWSkillChip.UILWTWSkillChipBook.Controller.UILWTWSkillChipBookCtrl"),
  View = require("UI.UILWTWSkillChip.UILWTWSkillChipBook.View.UILWTWSkillChipBookView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UILWTWSkillChipBook.prefab"
}
return {UILWTWSkillChipBook = UILWTWSkillChipBook}
