local UILWAllianceList = {
  Name = UIWindowNames.UILWAllianceList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAllianceList.Controller.UILWAllianceListCtrl"),
  View = require("UI.UILWAlliance.UILWAllianceList.View.UILWAllianceListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAllianceList.prefab"
}
return {UILWAllianceList = UILWAllianceList}
