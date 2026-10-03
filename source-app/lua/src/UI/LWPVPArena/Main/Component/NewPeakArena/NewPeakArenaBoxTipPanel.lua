local NewPeakArenaBoxTipPanel = BaseClass("NewPeakArenaBoxTipPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local AutoCloseTime = 5
local NewPeakArenaTipBoxItem = require("UI.LWPVPArena.Main.Component.NewPeakArena.NewPeakArenaTipBoxItem")
local ProgressAddSpeed = 0.4

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
  self.slider = self:AddComponent(UISlider, "ImgBg/Slider")
  self.boxItem1 = self:AddComponent(NewPeakArenaTipBoxItem, "ImgBg/Slider/BoxList/BoxItem1")
  self.boxItem2 = self:AddComponent(NewPeakArenaTipBoxItem, "ImgBg/Slider/BoxList/BoxItem2")
  self.boxItem3 = self:AddComponent(NewPeakArenaTipBoxItem, "ImgBg/Slider/BoxList/BoxItem3")
  self.textTip = self:AddComponent(UIText, "ImgBg/TipText")
  self.textChallenge = self:AddComponent(UIText, "ImgBg/ChallengeText")
  self.effect = self:AddComponent(UIBaseContainer, "ImgBg/Slider/FillArea/Fill/Effect")
  self.simpleAnim = self:AddComponent(UISimpleAnimation, "")
  self.closePanel = self:AddComponent(UIButton, "")
  self.closePanel:SetOnClick(function()
    self:ShowCloseAnim()
  end)
  self.sliderFullLen = self.slider:GetSizeDelta().x
  self.sliderNodeProgress = {}
  self.curTargetScores = {}
  for i = 1, 3 do
    table.insert(self.sliderNodeProgress, self["boxItem" .. i]:GetAnchoredPositionX() / self.sliderFullLen)
  end
  self.textTip:SetLocalText("new_arena_tips_36")
end

local function ComponentDestroy(self)
  self.slider = nil
  self.boxItem1 = nil
  self.boxItem2 = nil
  self.boxItem3 = nil
  self.textTip = nil
  self.textChallenge = nil
  self.effect = nil
  self.closePanel = nil
  self.simpleAnim = nil
end

local function DataDefine(self)
  self.nowProgress = 0
  self.targetProgress = 0
end

local function DataDestroy(self)
  self.sliderFullLen = nil
  self.sliderNodeProgress = nil
  self.nowProgress = 0
  self.targetProgress = 0
  if self.openTimer then
    self.openTimer:Stop()
    self.openTimer = nil
  end
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self, data, oldScore, newScore, battleCount, pvpType)
  self.pvpType = pvpType
  local fullCount = data[#data].needCount
  self.textChallenge:SetLocalText("new_arena_tips_37", battleCount, fullCount)
  if self.openTimer then
    self.openTimer:Stop()
    self.openTimer = nil
  end
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
  local _, time = self.simpleAnim:PlayAnimationReturnTime("in")
  self.openTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.curTargetScores = {}
    for index, value in ipairs(data) do
      self["boxItem" .. index]:Refresh(index, value, newScore)
      table.insert(self.curTargetScores, value.needCount)
    end
    if oldScore == newScore then
      self.nowProgress = self:GetScoreProgress(oldScore, 0)
      self.targetProgress = self.nowProgress
    else
      self.nowProgress = self:GetScoreProgress(oldScore, 0)
      self.targetProgress = self:GetScoreProgress(newScore, 0)
      self.deltaTime = 0
    end
    self.slider:SetValue(self.nowProgress)
    self.openTime = AutoCloseTime
  end, time)
end

local function GetScoreProgress(self, checkScore, zeroScore)
  local nowIndex = 0
  local score = checkScore - zeroScore
  for i = 1, #self.curTargetScores do
    local needScore = self.curTargetScores[i]
    if checkScore >= needScore then
      nowIndex = i
    else
      if 1 < i then
        score = checkScore - self.curTargetScores[i - 1]
      end
      break
    end
  end
  local value = 0
  if nowIndex == #self.curTargetScores then
    value = self.sliderNodeProgress[#self.sliderNodeProgress]
  else
    local preScore = zeroScore
    if 0 < nowIndex then
      preScore = self.curTargetScores[nowIndex]
    end
    local nodeRatio = score / (self.curTargetScores[nowIndex + 1] - preScore)
    local preProgress = 0
    if 0 < nowIndex then
      preProgress = self.sliderNodeProgress[nowIndex]
    end
    value = preProgress + nodeRatio * (self.sliderNodeProgress[nowIndex + 1] - preProgress)
  end
  return value
end

local function Update(self)
  if self.targetProgress > self.nowProgress then
    self.nowProgress = math.min(self.nowProgress + self.deltaTime * ProgressAddSpeed, self.targetProgress)
    self.slider:SetValue(self.nowProgress)
    self.deltaTime = self.deltaTime + Time.deltaTime
    self.effect:SetActive(true)
  else
    self.effect:SetActive(false)
  end
  if self.openTime then
    if self.openTime <= 0 then
      self:ShowCloseAnim()
      self.openTime = nil
    else
      self.openTime = self.openTime - Time.deltaTime
    end
  end
end

local function ShowCloseAnim(self)
  if self.closeTimer and not self.closeTimer:IsOver() then
    return
  end
  if UIManager:GetInstance():GetWindow(UIWindowNames.UIPersonalArmsRewardTip) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPersonalArmsRewardTip)
  end
  local _, time = self.simpleAnim:PlayAnimationReturnTime("out")
  self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:SetActive(false)
  end, time)
end

NewPeakArenaBoxTipPanel.OnCreate = OnCreate
NewPeakArenaBoxTipPanel.OnDestroy = OnDestroy
NewPeakArenaBoxTipPanel.OnEnable = OnEnable
NewPeakArenaBoxTipPanel.OnDisable = OnDisable
NewPeakArenaBoxTipPanel.ComponentDefine = ComponentDefine
NewPeakArenaBoxTipPanel.ComponentDestroy = ComponentDestroy
NewPeakArenaBoxTipPanel.DataDefine = DataDefine
NewPeakArenaBoxTipPanel.DataDestroy = DataDestroy
NewPeakArenaBoxTipPanel.OnAddListener = OnAddListener
NewPeakArenaBoxTipPanel.OnRemoveListener = OnRemoveListener
NewPeakArenaBoxTipPanel.Refresh = Refresh
NewPeakArenaBoxTipPanel.GetScoreProgress = GetScoreProgress
NewPeakArenaBoxTipPanel.Update = Update
NewPeakArenaBoxTipPanel.ShowCloseAnim = ShowCloseAnim
return NewPeakArenaBoxTipPanel
