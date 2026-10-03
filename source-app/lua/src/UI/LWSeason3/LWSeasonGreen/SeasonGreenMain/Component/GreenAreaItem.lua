local base = UIBaseContainer
local GreenAreaItem = BaseClass("GreenAreaItem", base)
local CountItem = require("UI.LWSeason3.LWSeasonGreen.SeasonGreenMain.Component.GreenAreaShowCountItem")
local Bg_path = "Bg"
local AreaName_path = "AreaName"
local Fill_path = "SliderRate/Fill Area/Fill"
local FillNext_path = "SliderRate/Fill Area/FillNext"
local FillEffect_path = "SliderRate/Fill Area/Fill/Fill_mask"
local GreenRate_path = "SliderRate/GreenRate"
local IntroBtn_path = "IntroBtn"
local Desc_path = "IntroBtn/Desc"
local Count_path = "IntroBtn/Count"
local Total_path = "IntroBtn/Count/Image/total"
local CountContent_path = "IntroBtn/Count/Image/CountContent"
local GreenAreaShowCountItem_path = "IntroBtn/Count/Image/CountContent/GreenAreaShowCountItem"
local closeTipBtn_path = "IntroBtn/Count/closeTipBtn"
local effectExplode_path = "SliderRate/EffectExplode"

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
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.Bg = self:AddComponent(UIImage, Bg_path)
  self.AreaName = self:AddComponent(UIText, AreaName_path)
  self.Fill = self:AddComponent(UIImage, Fill_path)
  self.FillNext = self:AddComponent(UIImage, FillNext_path)
  self.FillEffect = self:AddComponent(UIImage, FillEffect_path)
  self.GreenRate = self:AddComponent(UIText, GreenRate_path)
  self.IntroBtn = self:AddComponent(UIButton, IntroBtn_path)
  self.Desc = self:AddComponent(UIText, Desc_path)
  self.Count = self:AddComponent(UIBaseContainer, Count_path)
  self.Total = self:AddComponent(UIText, Total_path)
  self.CountContent = self:AddComponent(UIBaseContainer, CountContent_path)
  self.GreenAreaShowCountItem = self:AddComponent(UIBaseContainer, GreenAreaShowCountItem_path)
  self.closeTipBtn = self:AddComponent(UIButton, closeTipBtn_path)
  self.effectExplode = self:AddComponent(UIBaseContainer, effectExplode_path)
  self.IntroBtn:SetOnClick(function()
    self:ShowCount()
    self.Count:SetActive(true)
  end)
  self.closeTipBtn:SetOnClick(function()
    self.Count:SetActive(false)
  end)
  self.Count:SetActive(false)
  self.CountObj = self.GreenAreaShowCountItem.gameObject
  self.CountObj:GameObjectCreatePool()
  self.CountObj:SetActive(false)
  self.effectExplode = self:AddComponent(UIVfx, effectExplode_path, VfxAssets.GreeningFinishedEffect)
end

local function ComponentDestroy(self)
  self.CountContent:RemoveComponents(CountItem)
  self.CountObj:GameObjectRecycleAll()
  self.Bg = nil
  self.AreaName = nil
  self.Fill = nil
  self.FillNext = nil
  self.FillEffect = nil
  self.GreenRate = nil
  self.IntroBtn = nil
  self.Desc = nil
  self.Count = nil
  self.Total = nil
  self.CountContent = nil
  self.GreenAreaShowCountItem = nil
  self.closeTipBtn = nil
  self.effectExplode = nil
end

local function DataDefine(self)
  self.curShowValue = 0
  self.CountList = nil
end

local function DataDestroy(self)
  self.CountList = nil
end

function GreenAreaItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonGreenCityStage2LevelInfo, self.RefreshView)
end

function GreenAreaItem:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonGreenCityStage2LevelInfo, self.RefreshView)
  base.OnRemoveListener(self)
end

function GreenAreaItem:RefreshView()
  if not self.hasRequest then
    self.hasRequest = true
    SFSNetwork.SendMessage(MsgDefines.SeasonGreenCityStage2LevelInfo)
  end
  local curValue, hasNext = DataCenter.SeasonGreenManager:GetAreaLevelValue()
  if not curValue then
    self.gameObject:SetActive(false)
    return
  end
  local lastLevel = Setting:GetPrivateInt("GreenAreaItem.level", 1)
  local lastRate = Setting:GetPrivateFloat("GreenAreaItem.greenRate", 0)
  local greenLevel = curValue.level
  local greenRate = curValue.greenRate
  if lastLevel < greenLevel or math.abs(lastRate - greenRate) > 0.001 then
    self:ShowLevel(lastLevel, lastRate, hasNext)
    self:PlayAnim(lastLevel, lastRate, greenLevel, greenRate, hasNext)
  else
    self:ShowLevel(greenLevel, greenRate, hasNext)
    Setting:SetPrivateInt("GreenAreaItem.level", greenLevel)
    Setting:SetPrivateFloat("GreenAreaItem.greenRate", greenRate)
  end
  self.gameObject:SetActive(true)
end

function GreenAreaItem:ShowLevel(greenLevel, greenRate, hasNext, conditionRate)
  conditionRate = conditionRate or DataCenter.SeasonGreenManager:GetAreaUnlockGreenRate(greenLevel)
  self.FillNext:SetFillAmount(conditionRate * 0.01)
  self.AreaName:SetLocalText("season_oasis_UI_6", greenLevel)
  self:SetRate(greenRate, true)
  local conditionRateStr = string.format("<color=#099b4a>%s</color>", conditionRate)
  self.Desc:SetLocalText(hasNext and "season_oasis_tips_3" or "season_oasis_tips_4", conditionRateStr)
end

function GreenAreaItem:SetRate(rate, setFillAmount)
  self.curShowValue = rate
  self.GreenRate:SetText(string.format("%0.1f%%", rate * 100))
  if setFillAmount then
    self.Fill:SetFillAmount(rate)
    self.FillEffect:SetFillAmount(rate)
  end
end

function GreenAreaItem:PlayAnim(lastLevel, lastRate, greenLevel, greenRate, hasNext)
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:AppendInterval(0.1)
  for level = lastLevel, greenLevel do
    local conditionRate = DataCenter.SeasonGreenManager:GetAreaUnlockGreenRate(level)
    conditionRate = conditionRate * 0.01
    local value, hasNextLevel = DataCenter.SeasonGreenManager:GetAreaLevelValue(level)
    local rate = value.greenRate
    local duration = 1
    if level == lastLevel then
      if lastRate == rate then
        duration = 0.1
      end
    else
      lastRate = 0
      self.tweenSeq:AppendCallback(function()
        self:ShowLevel(level, 0, hasNextLevel)
        self:SetRate(rate)
      end)
    end
    if 0 < duration then
      if conditionRate <= rate and conditionRate > lastRate then
        duration = duration * 0.5
        local tweenSeq = DOTween.Sequence()
        tweenSeq:Join(self.FillEffect.unity_image:DOFillAmount(conditionRate, duration):SetEase(CS.DG.Tweening.Ease.InOutQuad))
        tweenSeq:Join(self.Fill.unity_image:DOFillAmount(conditionRate, duration):SetEase(CS.DG.Tweening.Ease.InOutQuad):OnComplete(function()
          self:SetRate(conditionRate)
          self.effectExplode:Replay()
        end))
        tweenSeq:Join(DOTween.To(function()
          return self.curShowValue
        end, function(v)
          self:SetRate(v)
        end, conditionRate, duration):SetEase(CS.DG.Tweening.Ease.OutQuad))
        self.tweenSeq:Append(tweenSeq)
      end
      do
        local tweenSeq = DOTween.Sequence()
        tweenSeq:Join(self.FillEffect.unity_image:DOFillAmount(rate, duration):SetEase(CS.DG.Tweening.Ease.InOutQuad))
        tweenSeq:Join(self.Fill.unity_image:DOFillAmount(rate, duration):SetEase(CS.DG.Tweening.Ease.InOutQuad))
        tweenSeq:Join(DOTween.To(function()
          return self.curShowValue
        end, function(v)
          self:SetRate(v)
        end, rate, duration):SetEase(CS.DG.Tweening.Ease.OutQuad))
        self.tweenSeq:Append(tweenSeq)
      end
    end
  end
  self.tweenSeq:AppendCallback(function()
    self:ShowLevel(greenLevel, greenRate, hasNext)
    Setting:SetPrivateInt("GreenAreaItem.level", greenLevel)
    Setting:SetPrivateFloat("GreenAreaItem.greenRate", greenRate)
  end)
end

function GreenAreaItem:ShowCount()
  self.CountContent:RemoveComponents(CountItem)
  self.CountObj:GameObjectRecycleAll()
  self.CountList = {}
  local list = DataCenter.SeasonGreenManager.areaLevelInfo
  local listCount = list and #list or 0
  if listCount <= 0 then
    self.Total:SetLocalText("season_oasis_UI_11", "0%%")
    return
  end
  local goItem, theItem
  local curOpenLevel = DataCenter.SeasonGreenManager.curOpenLevel
  for i = 1, listCount do
    local value = list[i]
    goItem = self.CountObj:GameObjectSpawn(self.CountContent.transform)
    goItem.name = string.format("Count_%d", i)
    goItem:SetActive(true)
    theItem = self.CountContent:AddComponent(CountItem, goItem.name)
    theItem:ReInit(i, value, curOpenLevel)
    self.CountList[i] = theItem
  end
  local rate = DataCenter.SeasonGreenManager.areaTotalRate * 100
  rate = string.format("%.1f%%", rate)
  self.Total:SetLocalText("season_oasis_UI_11", rate)
end

GreenAreaItem.OnCreate = OnCreate
GreenAreaItem.OnDestroy = OnDestroy
GreenAreaItem.OnEnable = OnEnable
GreenAreaItem.OnDisable = OnDisable
GreenAreaItem.ComponentDefine = ComponentDefine
GreenAreaItem.ComponentDestroy = ComponentDestroy
GreenAreaItem.DataDefine = DataDefine
GreenAreaItem.DataDestroy = DataDestroy
return GreenAreaItem
