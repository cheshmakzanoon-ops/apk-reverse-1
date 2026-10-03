local ValentineSendGiftList = {
  Name = UIWindowNames.ValentineSendGiftList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActValentineSendGiftList.Ctrl.ValentineSendGiftListCtrl"),
  View = require("UI.LWUIActValentineSendGiftList.View.ValentineSendGiftListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/UIActValentineSendGiftList.prefab"
}
return {ValentineSendGiftList = ValentineSendGiftList}
