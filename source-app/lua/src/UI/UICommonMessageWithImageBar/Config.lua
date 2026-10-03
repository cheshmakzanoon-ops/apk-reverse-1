local UICommonMessageWithImageBar = {
  Name = UIWindowNames.UICommonMessageWithImageBar,
  Layer = UILayer.Info,
  Ctrl = require("UI.UICommonMessageWithImageBar.Controller.UICommonMessageWithImageBarCtrl"),
  View = require("UI.UICommonMessageWithImageBar.View.UICommonMessageWithImageBarView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonMessageWithImageBar.prefab",
  HideInBattle = true,
  HidePveType = {
    [PVEType.Surfing] = true,
    [PVEType.GhostParkour] = true
  }
}
return {UICommonMessageWithImageBar = UICommonMessageWithImageBar}
