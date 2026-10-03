local UIOfficialAppointApplyList = {
  Name = UIWindowNames.UIOfficialAppointApplyList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.OfficialApplyList.Controller.UIOfficialAppointApplyListCtrl"),
  View = require("UI.UIGovernment.OfficialApplyList.View.UIOfficialAppointApplyListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/OfficialApply/UIOfficialAppointApplyList.prefab"
}
return {UIOfficialAppointApplyList = UIOfficialAppointApplyList}
