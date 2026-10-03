local UILWFactionWarGroup = {
  Name = UIWindowNames.UILWFactionWarGroup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.UILWFactionWarGroup.Controller.UILWFactionWarGroupCtrl"),
  View = require("UI.LWSeason4.UILWFactionWarGroup.View.UILWFactionWarGroupView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/FactionDeclareWar/UILWFactionWarGroup.prefab"
}
return {UILWFactionWarGroup = UILWFactionWarGroup}
