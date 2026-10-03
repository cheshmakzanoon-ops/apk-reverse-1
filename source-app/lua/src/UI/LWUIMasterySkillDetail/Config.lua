local LWUIMasterySkillDetail = {
  Name = UIWindowNames.LWUIMasterySkillDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMasterySkillDetail.Controller.LWUIMasterySkillDetailCtrl"),
  View = require("UI.LWUIMasterySkillDetail.View.LWUIMasterySkillDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMastery/LWUIMasterySkillDetail.prefab"
}
return {LWUIMasterySkillDetail = LWUIMasterySkillDetail}
