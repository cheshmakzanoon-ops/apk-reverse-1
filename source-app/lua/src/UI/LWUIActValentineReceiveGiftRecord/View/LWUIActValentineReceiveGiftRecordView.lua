local LWUIActValentineReceiveGiftRecordView = BaseClass("LWUIActValentineReceiveGiftRecordView", UIBaseView)
local ValentineReceiveGiftRecordTipContent = require("UI.LWUIActValentineReceiveGiftRecord.Component.TipContent")
local RecordContent = require("UI.LWUIActValentineReceiveGiftRecord.Component.RecordContent")
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local record_content_path = "RecordContent"
local tip_content_path = "TipContent"
LWUIActValentineReceiveGiftRecordView.TabType = {Tip = 1, Record = 2}

function LWUIActValentineReceiveGiftRecordView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.commonActivityPopUpBgPart:InitByActivityId(self.activityId)
  self.curSelectTab = self.TabType.Tip
  self:UpdateContent()
end

function LWUIActValentineReceiveGiftRecordView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActValentineReceiveGiftRecordView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.record_content = self:AddComponent(RecordContent, record_content_path)
  self.tip_content = self:AddComponent(ValentineReceiveGiftRecordTipContent, tip_content_path)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, "CommonActivityPopUpBgPart")
  self.commonActivityPopUpBgPart:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.commonActivityPopUpBgPart:SetToggleText(self.TabType.Tip, Localization:GetString("activity_99136_75"))
  self.commonActivityPopUpBgPart:SetToggleText(self.TabType.Record, Localization:GetString("activity_99136_74"))
  self.commonActivityPopUpBgPart:SetTitle("activity_99136_73")
  self.commonActivityPopUpBgPart:SetSelectCallback(function(index)
    self:OnSelectTab(index)
  end)
  self.commonActivityPopUpBgPart:SetSelectIndex(self.TabType.Tip)
end

function LWUIActValentineReceiveGiftRecordView:ComponentDestroy()
  self.btnPanel = nil
  self.compTabLayout = nil
  self.record_content = nil
  self.tip_content = nil
end

function LWUIActValentineReceiveGiftRecordView:DataDefine()
  self.hasInitTab = {}
  self.activityId = self:GetUserData()
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
end

function LWUIActValentineReceiveGiftRecordView:DataDestroy()
  self.hasInitTab = nil
end

function LWUIActValentineReceiveGiftRecordView:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActValentineReceiveGiftRecordView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActValentineReceiveGiftRecordView:UpdateContent()
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

function LWUIActValentineReceiveGiftRecordView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function LWUIActValentineReceiveGiftRecordView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function LWUIActValentineReceiveGiftRecordView:GetTabLocalText(tab)
  local name = ""
  if tab == self.TabType.Tip then
    name = Localization:GetString("activity_99136_75")
  elseif tab == self.TabType.Record then
    name = Localization:GetString("activity_99136_74")
  end
  return name
end

function LWUIActValentineReceiveGiftRecordView:OnSelectTab(tabType)
  if tabType == self.curSelectTab then
    return
  end
  self.curSelectTab = tabType
  self:UpdateContent()
end

return LWUIActValentineReceiveGiftRecordView
