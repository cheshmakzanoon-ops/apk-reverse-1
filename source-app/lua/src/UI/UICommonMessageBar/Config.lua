local UICommonMessageBar = {
  Name = UIWindowNames.UICommonMessageBar,
  Layer = UILayer.Info,
  Ctrl = require("UI.UICommonMessageBar.Controller.UICommonMessageBarCtrl"),
  View = require("UI.UICommonMessageBar.View.UICommonMessageBarView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonMessageBar.prefab",
  HideInBattle = true,
  HidePveType = {
    [PVEType.Surfing] = true,
    [PVEType.GhostParkour] = true
  }
}
return {UICommonMessageBar = UICommonMessageBar}
