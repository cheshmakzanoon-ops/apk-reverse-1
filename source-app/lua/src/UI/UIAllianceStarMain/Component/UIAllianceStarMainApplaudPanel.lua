local UIAllianceStarMainApplaudPanel = BaseClass("UIAllianceStarMainApplaudPanel", UIBaseContainer)
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

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
  self.level = nil
  if UIManager:GetInstance():GetWindow(UIWindowNames.UIPersonalArmsRewardTip) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPersonalArmsRewardTip)
  end
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textTip = self:AddComponent(UIText, "TipText")
  self.sliderProgress = self:AddComponent(UISlider, "Progress")
  self.textNum = self:AddComponent(UIText, "Progress/NumText")
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
  self.textName = self:AddComponent(UIText, "NameText")
  self.imgHand = self:AddComponent(UIImage, "HandImg")
  self.btnReward = self:AddComponent(UIButton, "RewardBtn")
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textCD = self:AddComponent(UIText, "CDText")
  self.anim = self:AddComponent(UISimpleAnimation, "")
end

local function ComponentDestroy(self)
  self.textTip = nil
  self.sliderProgress = nil
  self.textNum = nil
  self.compUIPlayerHead = nil
  self.textName = nil
  self.imgHand = nil
  self.btnReward = nil
  self.textCD = nil
  self.anim = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.previousNum = nil
  self.level = nil
  self.previewRewardId = nil
  self.template = nil
  self.interactionType = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceStarCeremonyRewardInfoPush, self.OnAllianceStarCeremonyRewardInfoPush)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceStarCeremonyRewardInfoPush, self.OnAllianceStarCeremonyRewardInfoPush)
  base.OnRemoveListener(self)
end

local function OnBtnRewardClick(self)
  if self.previewRewardId then
    local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
    param.position = self.btnReward:GetPosition()
    param.deltaX = -30
    param.dir = UIPersonalArmsRewardTipView.Direction.RIGHT
    param.rewardList = DataCenter.RewardTemplateManager:GetList(self.previewRewardId)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
  end
end

local function Refresh(self, param)
  self.textTip:SetText(param.tipText)
  if param.playerInfo then
    self.textName:SetText(param.playerInfo.name)
    self.compUIPlayerHead:ParseHeadInfo(param.playerInfo)
  end
  self.template = param.template
  if self.template then
    self.interactionType = self.template:GetInteractionType()
    self:RefreshProgress()
  end
  if param.showInAnim then
    self.anim:SampleAnimationAtTime("in", 0)
    self.anim:Play("in")
  elseif param.showOutAnim then
    self.anim:SampleAnimationAtTime("out", 0)
    self.anim:Play("out")
  elseif param.showOutAnim == false then
    self.anim:SampleAnimationAtTime("out", 1)
  else
    self.anim:SampleAnimationAtTime("out", 0)
  end
  if param.endDeltaTime then
    self.textCD:SetActive(true)
    self.endTimeStamp = param.endDeltaTime + UITimeManager:GetInstance():GetServerTime()
  else
    self.textCD:SetActive(false)
  end
  self:Update1000MS()
end

local function RefreshProgress(self)
  if self.interactionType then
    local num = 0
    local info = DataCenter.AllianceStarManager:GetCeremonyInteractionInfo(self.interactionType)
    if info then
      num = info.interactionNumber
    end
    local level, rewardInfo = self.template:GetLevelByInteractionNum(num)
    if rewardInfo then
      self.previewRewardId = rewardInfo.rewardId
      local maxValue = rewardInfo.maxValue
      local minValue = rewardInfo.minValue
      local progress = (num - minValue) / (maxValue - minValue)
      self.textNum:SetText(num .. "/" .. maxValue)
      self.sliderProgress:SetValue(progress)
      if num == maxValue then
        self.btnReward:SetActive(false)
        if self.previousNum and self.previousNum ~= num then
          UIUtil.DoFly(nil, 1, AlStarRewardBoxImg[rewardInfo.boxType], self.btnReward:GetPosition(), self.view:GetRewardIconPos(), nil, nil, function()
            if self then
              self.view:DoRewardBoxScaleVX()
            end
          end)
          if level == #self.template.rewardInfoList then
            self.view:PlayCaidaiEffect()
          end
        end
      else
        self.btnReward:SetActive(DataCenter.AllianceStarManager:ShowReward())
        self.btnReward:LoadSprite(AlStarRewardBoxImg[rewardInfo.boxType])
      end
      self.previousNum = num
    else
      self.textNum:SetText(num)
      self.sliderProgress:SetValue(1)
      self.btnReward:SetActive(false)
    end
  end
end

local function OnAllianceStarCeremonyRewardInfoPush(self)
  self:RefreshProgress()
end

local function Update1000MS(self)
  if self.endTimeStamp then
    local now = UITimeManager:GetInstance():GetServerTime()
    local diff = self.endTimeStamp - now
    if 0 < diff then
      self.textCD:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(diff))
    else
      self.textCD:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(0))
    end
  end
end

UIAllianceStarMainApplaudPanel.OnCreate = OnCreate
UIAllianceStarMainApplaudPanel.OnDestroy = OnDestroy
UIAllianceStarMainApplaudPanel.OnEnable = OnEnable
UIAllianceStarMainApplaudPanel.OnDisable = OnDisable
UIAllianceStarMainApplaudPanel.ComponentDefine = ComponentDefine
UIAllianceStarMainApplaudPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainApplaudPanel.DataDefine = DataDefine
UIAllianceStarMainApplaudPanel.DataDestroy = DataDestroy
UIAllianceStarMainApplaudPanel.OnAddListener = OnAddListener
UIAllianceStarMainApplaudPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainApplaudPanel.OnBtnRewardClick = OnBtnRewardClick
UIAllianceStarMainApplaudPanel.Refresh = Refresh
UIAllianceStarMainApplaudPanel.RefreshProgress = RefreshProgress
UIAllianceStarMainApplaudPanel.OnAllianceStarCeremonyRewardInfoPush = OnAllianceStarCeremonyRewardInfoPush
UIAllianceStarMainApplaudPanel.Update1000MS = Update1000MS
return UIAllianceStarMainApplaudPanel
