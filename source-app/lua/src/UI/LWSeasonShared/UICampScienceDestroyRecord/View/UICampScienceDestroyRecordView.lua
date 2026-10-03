local base = UIBaseView
local UICampScienceDestroyRecordView = BaseClass("UICampScienceDestroyRecordView", base)
local UILoopListViewSimple = require("Framework.UI.Component.UILoopListViewSimple")
local UICampScienceDestroyRecordItem = require("UI.LWSeasonShared.UICampScienceDestroyRecord.Component.UICampScienceDestroyRecordItem")
local sr_Content_path = "Content"
local txt_TitleText_path = "UICommonPopUpPanel_NoToggle/Content/UICommonPopUpTop/TitleText"
local btn_Mask_path = "UICommonPopUpPanel_NoToggle/Mask"
local btn_CloseBtn_path = "UICommonPopUpPanel_NoToggle/Content/UICommonPopUpTop/CloseBtn"
local btn_CommonButton_path = "UICommonPopUpPanel_NoToggle/Content/BottomGroup/ButtonScaleNode/CommonButton"
local go_Tips_path = "Content/Tips"

function UICampScienceDestroyRecordView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshView()
end

function UICampScienceDestroyRecordView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICampScienceDestroyRecordView:ComponentDefine()
  self.txt_TitleText = self:AddComponent(UIText, txt_TitleText_path)
  self.btn_Mask = self:AddComponent(UIButton, btn_Mask_path)
  self.btn_CloseBtn = self:AddComponent(UIButton, btn_CloseBtn_path)
  self.btn_CommonButton = self:AddComponent(UIButton, btn_CommonButton_path)
  self.go_Tips = self:AddComponent(UIBaseContainer, go_Tips_path)
  self.sr_Content = self:AddComponent(UILoopListViewSimple, sr_Content_path)
  self.btn_Mask:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.btn_CloseBtn:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.btn_CommonButton:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.sr_Content:Init(UICampScienceDestroyRecordItem)
end

function UICampScienceDestroyRecordView:ComponentDestroy()
  self.sr_Content = nil
  self.txt_TitleText = nil
  self.btn_Mask = nil
  self.btn_CloseBtn = nil
  self.btn_CommonButton = nil
  self.go_Tips = nil
end

function UICampScienceDestroyRecordView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetCampDestroyCityList, self.RefreshView)
end

function UICampScienceDestroyRecordView:OnRemoveListener()
  self:RemoveUIListener(EventId.GetCampDestroyCityList, self.RefreshView)
  base.OnRemoveListener(self)
end

function UICampScienceDestroyRecordView:RefreshView()
  local showData = DataCenter.CampProduceDataManager:GetShowOccDestroyRecordData()
  local showDataList = {}
  for _, v in pairs(showData) do
    table.insert(showDataList, v)
  end
  table.sort(showDataList, function(a, b)
    return a.destroyTime < b.destroyTime
  end)
  self.go_Tips:SetActive(table.count(showDataList) <= 0)
  self.sr_Content:Clear()
  for _, v in ipairs(showDataList) do
    self.sr_Content:AddData(v)
  end
  self.sr_Content:Show()
end

return UICampScienceDestroyRecordView
