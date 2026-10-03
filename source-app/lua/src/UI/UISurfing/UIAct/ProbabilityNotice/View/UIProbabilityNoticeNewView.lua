local UIProbabilityNoticeNewView = BaseClass("UIProbabilityNoticeNewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroRecruitTipRateDetailInfo = require("UI.UISurfing.UIAct.ProbabilityNotice.Component.UICommonTipRateDetailInfo")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:BtnCloseClick()
  end)
  self.closeBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
  self.closeBtn:SetOnClick(function()
    self:BtnCloseClick()
  end)
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.allianceGiftText = self:AddComponent(UIText, "Root/GiftTitleText")
  self.allianceGiftText:SetActive(false)
  self.textTitle:SetLocalText(320475)
  self.recruitRateDetailInfo = self:AddComponent(UIHeroRecruitTipRateDetailInfo, "Root/Common_bg/recruitRateDetailInfo")
  self.descText = self:AddComponent(UIText, "Root/Common_bg/descText")
end

local function ComponentDestroy(self)
  self.btnPanel = nil
  self.closeBtn = nil
  self.textTitle = nil
  self.tabList = nil
  self.recruitRateInfo = nil
  self.recruitRateDetailInfo = nil
  self.descText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnOpen(self)
  local dropInfoId, titleKey, descKey = self:GetUserData()
  local dropInfoDetail = GetTableData(TableName.DropInfoDetail, dropInfoId, "dropInfoDetail")
  local allianceLevel = tonumber(GetTableData(TableName.DropInfoDetail, dropInfoId, "level")) or 0
  self.recruitRateDetailInfo:SetData(dropInfoDetail)
  self.allianceGiftText:SetActive(dropInfoDetail.isSpecial)
  self.allianceGiftText:SetActive(allianceLevel and 0 < allianceLevel)
  if allianceLevel and 0 < allianceLevel then
    self.allianceGiftText:SetLocalText("drop_info_desc5", allianceLevel)
  end
  if titleKey then
    self.textTitle:SetLocalText(titleKey)
  end
  if descKey then
    self.descText:SetLocalText(descKey)
  end
end

local function BtnCloseClick(self)
  self.ctrl:CloseSelf()
end

UIProbabilityNoticeNewView.OnCreate = OnCreate
UIProbabilityNoticeNewView.OnDestroy = OnDestroy
UIProbabilityNoticeNewView.ComponentDefine = ComponentDefine
UIProbabilityNoticeNewView.ComponentDestroy = ComponentDestroy
UIProbabilityNoticeNewView.DataDefine = DataDefine
UIProbabilityNoticeNewView.DataDestroy = DataDestroy
UIProbabilityNoticeNewView.OnOpen = OnOpen
UIProbabilityNoticeNewView.BtnCloseClick = BtnCloseClick
return UIProbabilityNoticeNewView
