local ParkourBonusProgressPanel = BaseClass("ParkourBonusProgressPanel", UIBaseContainer)
local GameQualitySettings = require("Util.GameQualitySettings")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ParkourBonusProgressItem = require("UI.UIParkour.MainUI.Component.ParkourBonus.ParkourBonusProgressItem")

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
  self.slider = self:AddComponent(UISlider, "Slider")
  self.imgIcon = self:AddComponent(UIImage, "Icon")
  self.compSliderItem1 = self:AddComponent(ParkourBonusProgressItem, "Slider/SliderList/SliderItem1")
  self.compSliderItem2 = self:AddComponent(ParkourBonusProgressItem, "Slider/SliderList/SliderItem2")
  self.compSliderItem3 = self:AddComponent(ParkourBonusProgressItem, "Slider/SliderList/SliderItem3")
end

local function ComponentDestroy(self)
  self.slider = nil
  self.imgIcon = nil
  self.compSliderItem1 = nil
  self.compSliderItem2 = nil
  self.compSliderItem3 = nil
end

local function DataDefine(self)
  self.sliderFullLen = self.slider:GetSizeDelta().x
  self.sliderNodeProgress = {}
  self.scoreItemList = {}
  for i = 1, 3 do
    local comp = self["compSliderItem" .. i]
    table.insert(self.scoreItemList, comp)
    table.insert(self.sliderNodeProgress, comp:GetAnchoredPositionX() / self.sliderFullLen)
  end
end

local function DataDestroy(self)
  self.sliderFullLen = nil
  self.sliderNodeProgress = nil
  self.scoreItemList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, param)
  self.progressData = param
  self.nowScore = 0
  local maxNum = self.progressData[#self.progressData].progressNum
  for i, v in ipairs(self.scoreItemList) do
    v:SetData(self.progressData[i], maxNum)
  end
  self.slider:SetValue(0)
end

local function Refresh(self, param)
  local pic = DataCenter.ResourceManager:GetResourceIconByType(param.goodsId)
  local srcPos = CS.CSUtils.WorldPositionToUISpacePosition(param.worldPosition)
  local targetPos = self.imgIcon.transform.position
  local FlyParkourPath = "Assets/_Art/Effect/prefab/ui/Common/FlyParkour.prefab"
  if GameQualitySettings.IsLowGearQuality() then
    FlyParkourPath = "Assets/_Art/Effect/prefab/ui/Common/FlyParkourNoTrail.prefab"
  end
  local nowScore = self.nowScore + param.goodsCount
  self.nowScore = nowScore
  DataCenter.FlyController.DoFlyForLua(pic, nil, 1, srcPos, targetPos, 40, 40, function()
    if self.scoreItemList then
      for i, v in ipairs(self.scoreItemList) do
        v:Refresh(nowScore)
      end
      self.slider:SetValue(self:GetScoreProgress(nowScore))
    end
  end, FlyParkourPath, nil, -50, nil, nil)
end

local function GetScoreProgress(self, checkScore)
  local zeroScore = 0
  local nowIndex = 0
  local score = checkScore - zeroScore
  for i = 1, #self.progressData do
    local needScore = self.progressData[i].progressNum
    if checkScore >= needScore then
      nowIndex = i
    else
      if 1 < i then
        score = checkScore - self.progressData[i - 1].progressNum
      end
      break
    end
  end
  local value = 0
  if nowIndex == #self.progressData then
    value = self.sliderNodeProgress[#self.sliderNodeProgress]
  else
    local preScore = zeroScore
    if 0 < nowIndex then
      preScore = self.progressData[nowIndex].progressNum
    end
    local nodeRatio = score / (self.progressData[nowIndex + 1].progressNum - preScore)
    local preProgress = 0
    if 0 < nowIndex then
      preProgress = self.sliderNodeProgress[nowIndex]
    end
    value = preProgress + nodeRatio * (self.sliderNodeProgress[nowIndex + 1] - preProgress)
  end
  return value
end

ParkourBonusProgressPanel.OnCreate = OnCreate
ParkourBonusProgressPanel.OnDestroy = OnDestroy
ParkourBonusProgressPanel.OnEnable = OnEnable
ParkourBonusProgressPanel.OnDisable = OnDisable
ParkourBonusProgressPanel.ComponentDefine = ComponentDefine
ParkourBonusProgressPanel.ComponentDestroy = ComponentDestroy
ParkourBonusProgressPanel.DataDefine = DataDefine
ParkourBonusProgressPanel.DataDestroy = DataDestroy
ParkourBonusProgressPanel.OnAddListener = OnAddListener
ParkourBonusProgressPanel.OnRemoveListener = OnRemoveListener
ParkourBonusProgressPanel.Refresh = Refresh
ParkourBonusProgressPanel.SetData = SetData
ParkourBonusProgressPanel.GetScoreProgress = GetScoreProgress
return ParkourBonusProgressPanel
