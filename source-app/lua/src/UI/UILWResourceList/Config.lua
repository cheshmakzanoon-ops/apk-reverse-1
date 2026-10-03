local UILWResourceList = {
  Name = UIWindowNames.UILWResourceList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWResourceList.Ctrl.LWResourceListCtrl"),
  View = require("UI.UILWResourceList.View.LWResourceListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWResource/LWResourceList.prefab"
}
return {UILWResourceList = UILWResourceList}
