local UIWorldDeclareList = {
  Name = UIWindowNames.UIWorldDeclareList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWorldDeclareList.Controller.UIWorldDeclareListCtrl"),
  View = require("UI.UIWorldDeclareList.View.UIWorldDeclareListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIWorldDeclareList.prefab"
}
return {UIWorldDeclareList = UIWorldDeclareList}
