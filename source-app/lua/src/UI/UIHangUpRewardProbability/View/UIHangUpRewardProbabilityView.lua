local UIHangUpRewardProbabilityView = BaseClass("UIHangUpRewardProbabilityView", UIBaseView)
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
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.textTitle:SetLocalText(320475)
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.recruitRateDetailInfo = self:AddComponent(UIHeroRecruitTipRateDetailInfo, "Root/Common_bg/recruitRateDetailInfo")
end

local function ComponentDestroy(self)
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.recruitRateDetailInfo = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnOpen(self)
  local tRewardProbability = self:GetUserData()
  self.recruitRateDetailInfo:SetDataForRewardProbability(tRewardProbability)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

UIHangUpRewardProbabilityView.OnCreate = OnCreate
UIHangUpRewardProbabilityView.OnDestroy = OnDestroy
UIHangUpRewardProbabilityView.OnEnable = OnEnable
UIHangUpRewardProbabilityView.OnDisable = OnDisable
UIHangUpRewardProbabilityView.ComponentDefine = ComponentDefine
UIHangUpRewardProbabilityView.ComponentDestroy = ComponentDestroy
UIHangUpRewardProbabilityView.DataDefine = DataDefine
UIHangUpRewardProbabilityView.DataDestroy = DataDestroy
UIHangUpRewardProbabilityView.OnAddListener = OnAddListener
UIHangUpRewardProbabilityView.OnRemoveListener = OnRemoveListener
UIHangUpRewardProbabilityView.OnOpen = OnOpen
return UIHangUpRewardProbabilityView
