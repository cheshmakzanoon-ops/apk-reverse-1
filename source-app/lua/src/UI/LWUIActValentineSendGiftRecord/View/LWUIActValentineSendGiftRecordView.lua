local LWUIActValentineSendGiftRecordView = BaseClass("LWUIActValentineSendGiftRecordView", UIBaseView)
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local ValentineSendGiftRecordTipContent = require("UI.LWUIActValentineSendGiftRecord.Component.TipContent")
local RecordContent = require("UI.LWUIActValentineSendGiftRecord.Component.RecordContent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local record_content_path = "RecordContent"
local tip_content_path = "TipContent"
LWUIActValentineSendGiftRecordView.TabType = {Tip = 1, Record = 2}

function LWUIActValentineSendGiftRecordView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.commonActivityPopUpBgPart:InitByActivityId(self.activityId)
  self.curSelectTab = self.TabType.Tip
  self:UpdateContent()
end

function LWUIActValentineSendGiftRecordView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActValentineSendGiftRecordView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compTabLayout = self:AddComponent(UIBaseContainer, "TabLayout")
  self.record_content = self:AddComponent(RecordContent, record_content_path)
  self.tip_content = self:AddComponent(ValentineSendGiftRecordTipContent, tip_content_path)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, "CommonActivityPopUpBgPart")
  self.commonActivityPopUpBgPart:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.commonActivityPopUpBgPart:SetToggleText(self.TabType.Tip, self:GetTabLocalText(self.TabType.Tip))
  self.commonActivityPopUpBgPart:SetToggleText(self.TabType.Record, self:GetTabLocalText(self.TabType.Record))
  self.commonActivityPopUpBgPart:SetTitle("activity_99136_14")
  self.commonActivityPopUpBgPart:SetSelectCallback(function(index)
    self:OnSelectTab(index)
  end)
  self.commonActivityPopUpBgPart:SetSelectIndex(self.TabType.Tip)
end

function LWUIActValentineSendGiftRecordView:ComponentDestroy()
  self.btnPanel = nil
  self.compTabLayout = nil
  self.record_content = nil
  self.tip_content = nil
  self.commonActivityPopUpBgPart = nil
end

function LWUIActValentineSendGiftRecordView:DataDefine()
  self.hasInitTab = {}
  self.activityId = self:GetUserData()
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
end

function LWUIActValentineSendGiftRecordView:DataDestroy()
  self.hasInitTab = nil
end

function LWUIActValentineSendGiftRecordView:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActValentineSendGiftRecordView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActValentineSendGiftRecordView:UpdateContent()
  if self.curSelectTab == nil or self.activityId == nil then
    return
  end
  if self.curSelectTab == self.TabType.Tip then
    self.tip_content:SetActive(true)
    self.record_content:SetActive(false)
    self.tip_content:SetData(self.activityId)
  elseif self.curSelectTab == self.TabType.Record then
    self.tip_content:SetActive(false)
    self.record_content:SetActive(true)
    self.record_content:SetData(self.activityId)
  end
  self.hasInitTab[self.curSelectTab] = true
end

function LWUIActValentineSendGiftRecordView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function LWUIActValentineSendGiftRecordView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function LWUIActValentineSendGiftRecordView:GetTabLocalText(tab)
  local name = ""
  if tab == self.TabType.Tip then
    name = Localization:GetString("activity_99136_15")
  elseif tab == self.TabType.Record then
    name = Localization:GetString("activity_99136_17")
  end
  return name
end

function LWUIActValentineSendGiftRecordView:OnSelectTab(tabType)
  if tabType == self.curSelectTab then
    return
  end
  self.curSelectTab = tabType
  self:UpdateContent()
end

return LWUIActValentineSendGiftRecordView
