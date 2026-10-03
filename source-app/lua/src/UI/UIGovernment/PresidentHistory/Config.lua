local UIGovernmentPresidentHistory = {
  Name = UIWindowNames.UIGovernmentPresidentHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.PresidentHistory.Controller.PresidentHistoryCtrl"),
  View = require("UI.UIGovernment.PresidentHistory.View.PresidentHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/PresidentHistory.prefab"
}
return {UIGovernmentPresidentHistory = UIGovernmentPresidentHistory}
