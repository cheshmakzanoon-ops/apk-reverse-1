local UILWSeasonServerGroup = {
  Name = UIWindowNames.UILWSeasonServerGroup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonServerGroup.Controller.LWSeasonServerGroupCtrl"),
  View = require("UI.LWSeason.LWSeasonServerGroup.View.LWSeasonServerGroupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonServerGroup.prefab"
}
return {UILWSeasonServerGroup = UILWSeasonServerGroup}
