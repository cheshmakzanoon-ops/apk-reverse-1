local UILWActConcertList = {
  Name = UIWindowNames.UILWActConcertList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWActConcertList.Controller.UILWActConcertListCtrl"),
  View = require("UI.UILWActConcertList.View.UILWActConcertListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActMusicFestival2025/ActConcertList/UILWActConcertList.prefab"
}
return {UILWActConcertList = UILWActConcertList}
