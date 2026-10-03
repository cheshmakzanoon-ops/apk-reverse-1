local UIProbabilityNoticeView = BaseClass("UIProbabilityNoticeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroRecruitTipRateDetailInfo = require("UI.UIHero2.UIHeroRecruitTipNew.Component.UIHeroRecruitTipRateDetailInfo")

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
  self.btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.allianceGiftText = self:AddComponent(UIText, "Root/GiftTitleText")
  self.allianceGiftText:SetActive(false)
  self.textTitle:SetLocalText(320475)
  self.recruitRateDetailInfo = self:AddComponent(UIHeroRecruitTipRateDetailInfo, "Root/Common_bg/recruitRateDetailInfo")
end

local function ComponentDestroy(self)
  self.btnPanel = nil
  self.closeBtn = nil
  self.textTitle = nil
  self.tabList = nil
  self.recruitRateInfo = nil
  self.recruitRateDetailInfo = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnOpen(self)
  local dropInfoId, titleKey = self:GetUserData()
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
end

UIProbabilityNoticeView.OnCreate = OnCreate
UIProbabilityNoticeView.OnDestroy = OnDestroy
UIProbabilityNoticeView.ComponentDefine = ComponentDefine
UIProbabilityNoticeView.ComponentDestroy = ComponentDestroy
UIProbabilityNoticeView.DataDefine = DataDefine
UIProbabilityNoticeView.DataDestroy = DataDestroy
UIProbabilityNoticeView.OnOpen = OnOpen
return UIProbabilityNoticeView
