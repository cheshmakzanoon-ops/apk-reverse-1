local UICommonMessageBarOld = {
  Name = UIWindowNames.UICommonMessageBarOld,
  Layer = UILayer.Info,
  Ctrl = require("UI/UICommonMessageBarOld/Controller/UICommonMessageBarOldCtrl"),
  View = require("UI/UICommonMessageBarOld/View/UICommonMessageBarOldView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonMessageBarOld.prefab",
  HideInBattle = true,
  HidePveType = {
    [PVEType.Surfing] = true,
    [PVEType.GhostParkour] = true
  }
}
return {UICommonMessageBarOld = UICommonMessageBarOld}
