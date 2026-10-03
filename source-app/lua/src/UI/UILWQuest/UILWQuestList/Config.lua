local UILWQuestList = {
  Name = UIWindowNames.UILWQuestList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWQuest.UILWQuestList.Controller.UILWQuestListCtrl"),
  View = require("UI.UILWQuest.UILWQuestList.View.UILWQuestListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWQuest/UILWQuestList.prefab"
}
return {UILWQuestList = UILWQuestList}
