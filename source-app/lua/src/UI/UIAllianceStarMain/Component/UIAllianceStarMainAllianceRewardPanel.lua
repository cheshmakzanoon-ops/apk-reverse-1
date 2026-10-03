local UIAllianceStarMainAllianceRewardPanel = BaseClass("UIAllianceStarMainAllianceRewardPanel", UIBaseContainer)
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.textTitle = self:AddComponent(UIText, "TitleText")
  self.textLv = self:AddComponent(UIText, "LvText")
  self.textNone = self:AddComponent(UIText, "NoneText")
  self.textTip = self:AddComponent(UIText, "TipText")
  self.sliderProgress = self:AddComponent(UISlider, "Progress")
  self.textNum = self:AddComponent(UIText, "Progress/NumText")
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textLv = nil
  self.textNone = nil
  self.textTip = nil
  self.sliderProgress = nil
  self.textNum = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnRewardClick(self)
  if self.previewRewardId then
    local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
    param.position = self.btnReward:GetPosition()
    param.deltaX = -30
    param.dir = UIPersonalArmsRewardTipView.Direction.RIGHT
  end
end

local function Refresh(self, param)
  self.textTitle:SetText(param.titleText)
  self.textLv:SetText(param.level or 1)
  if param.progressParam then
    self:RefreshProgress(param.progressParam)
  else
    self.textTip:SetActive(false)
    self.sliderProgress:SetActive(false)
  end
end

local function RefreshProgress(self, progressParam)
  self.textTip:SetActive(true)
  self.sliderProgress:SetActive(true)
  local num = progressParam.value
end

UIAllianceStarMainAllianceRewardPanel.OnCreate = OnCreate
UIAllianceStarMainAllianceRewardPanel.OnDestroy = OnDestroy
UIAllianceStarMainAllianceRewardPanel.OnEnable = OnEnable
UIAllianceStarMainAllianceRewardPanel.OnDisable = OnDisable
UIAllianceStarMainAllianceRewardPanel.ComponentDefine = ComponentDefine
UIAllianceStarMainAllianceRewardPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainAllianceRewardPanel.DataDefine = DataDefine
UIAllianceStarMainAllianceRewardPanel.DataDestroy = DataDestroy
UIAllianceStarMainAllianceRewardPanel.OnAddListener = OnAddListener
UIAllianceStarMainAllianceRewardPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainAllianceRewardPanel.OnBtnRewardClick = OnBtnRewardClick
UIAllianceStarMainAllianceRewardPanel.Refresh = Refresh
UIAllianceStarMainAllianceRewardPanel.RefreshProgress = RefreshProgress
return UIAllianceStarMainAllianceRewardPanel
