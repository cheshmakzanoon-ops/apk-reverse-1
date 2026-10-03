local UILWSquadEquipEffect = {
  Name = UIWindowNames.UILWSquadEquipEffect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWSquadEquipEffect.Controller.UILWSquadEquipEffectCtrl"),
  View = require("UI.UILWSquadEquipEffect.View.UILWSquadEquipEffectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWSquadEquip/UILWSquadEquipEffect.prefab"
}
return {UILWSquadEquipEffect = UILWSquadEquipEffect}
