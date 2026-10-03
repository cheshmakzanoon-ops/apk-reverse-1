local base = UIBaseView
local UIActSevenDayV2RewardView = BaseClass("UIActSevenDayV2RewardView", base)
local UIActSevenDayV2RewardItem = require("UI/LWUIActSevenDayV2/Reward/Component/UIActSevenDayV2RewardItem")
local TitleText_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local CloseBtn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local Content_path = "Root/Content/ContentHolder/ScrollView/Viewport/Content"
local Slider_path = "Root/Content/ContentHolder/ScrollView/Slider"
local RewardItem1_path = "Root/Content/ContentHolder/ScrollView/Viewport/Content/RewardItem1"
local RewardItem2_path = "Root/Content/ContentHolder/ScrollView/Viewport/Content/RewardItem2"
local RewardItem3_path = "Root/Content/ContentHolder/ScrollView/Viewport/Content/RewardItem3"
local RewardItem4_path = "Root/Content/ContentHolder/ScrollView/Viewport/Content/RewardItem4"
local RewardItem5_path = "Root/Content/ContentHolder/ScrollView/Viewport/Content/RewardItem5"
local LineContent_path = "Root/Content/ContentHolder/ScrollView/Slider/LineContent"
local Point1_path = "Root/Content/ContentHolder/ScrollView/Slider/LineContent/Point1"
local Point2_path = "Root/Content/ContentHolder/ScrollView/Slider/LineContent/Point2"
local Point3_path = "Root/Content/ContentHolder/ScrollView/Slider/LineContent/Point3"
local Point4_path = "Root/Content/ContentHolder/ScrollView/Slider/LineContent/Point4"
local Point5_path = "Root/Content/ContentHolder/ScrollView/Slider/LineContent/Point5"
local ClosePanel_path = "Panel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.TitleText = self:AddComponent(UIText, TitleText_path)
  self.CloseBtn = self:AddComponent(UIButton, CloseBtn_path)
  self.Content = self:AddComponent(UIBaseContainer, Content_path)
  self.Slider = self:AddComponent(UISlider, Slider_path)
  self.RewardItem1 = self:AddComponent(UIActSevenDayV2RewardItem, RewardItem1_path)
  self.RewardItem2 = self:AddComponent(UIActSevenDayV2RewardItem, RewardItem2_path)
  self.RewardItem3 = self:AddComponent(UIActSevenDayV2RewardItem, RewardItem3_path)
  self.RewardItem4 = self:AddComponent(UIActSevenDayV2RewardItem, RewardItem4_path)
  self.RewardItem5 = self:AddComponent(UIActSevenDayV2RewardItem, RewardItem5_path)
  self.LineContent = self:AddComponent(UIBaseContainer, LineContent_path)
  self.Point1 = self:AddComponent(UIBaseContainer, Point1_path)
  self.Point2 = self:AddComponent(UIBaseContainer, Point2_path)
  self.Point3 = self:AddComponent(UIBaseContainer, Point3_path)
  self.Point4 = self:AddComponent(UIBaseContainer, Point4_path)
  self.Point5 = self:AddComponent(UIBaseContainer, Point5_path)
  self.ClosePanel = self:AddComponent(UIButton, ClosePanel_path)
  self.CloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.ClosePanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.TitleText = nil
  self.CloseBtn = nil
  self.Content = nil
  self.Slider = nil
  self.RewardItem1 = nil
  self.RewardItem2 = nil
  self.RewardItem3 = nil
  self.RewardItem4 = nil
  self.RewardItem5 = nil
  self.LineContent = nil
  self.Point1 = nil
  self.Point2 = nil
  self.Point3 = nil
  self.Point4 = nil
  self.Point5 = nil
  self.ClosePanel = nil
end

local function DataDefine(self)
  local sevenDayInfo, activityId = self:GetUserData()
  self.activityId = activityId
  self:ReInit(sevenDayInfo)
  self:InitSliderData()
end

local function DataDestroy(self)
  self.sevenDayInfo = nil
  self.activityId = nil
  self.sliderFullLen = nil
  self.sliderNodeLens = nil
end

local function OnAddListener(self)
  self:AddUIListener(EventId.ActRewardState, self.RefreshUI)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActRewardState, self.RefreshUI)
end

local function InitSliderData(self)
  self.sliderFullLen = self.LineContent:GetSizeDelta().y
  self.sliderNodeLens = {}
  for i = 1, 5 do
    local posY = self["Point" .. i]:GetAnchoredPositionY()
    table.insert(self.sliderNodeLens, -posY)
  end
  self.Slider:SetValue(self:GetNowSliderValue())
end

local function GetNowSliderValue(self)
  local nowIndex = 0
  local nowScore = self.sevenDayInfo.score
  local score = nowScore
  for i = 1, #self.sevenDayInfo.scoreReward do
    local needScore = self.sevenDayInfo.scoreReward[i].needScore
    if nowScore >= needScore then
      nowIndex = i
    else
      if 1 < i then
        score = nowScore - self.sevenDayInfo.scoreReward[i - 1].needScore
      end
      break
    end
  end
  local value = 0
  if nowIndex == #self.sevenDayInfo.scoreReward then
    value = 1
  else
    local preScore = 0
    if 0 < nowIndex then
      preScore = self.sevenDayInfo.scoreReward[nowIndex].needScore
    end
    local nodeRatio = score / (self.sevenDayInfo.scoreReward[nowIndex + 1].needScore - preScore)
    local prePosY = 0
    if 0 < nowIndex then
      prePosY = self.sliderNodeLens[nowIndex]
    end
    value = (prePosY + (self.sliderNodeLens[nowIndex + 1] - prePosY) * nodeRatio) / self.sliderFullLen
  end
  return value
end

local function ReInit(self, data)
  if data and data.scoreReward and self.activityId then
    self.sevenDayInfo = data
    for i = 1, 5 do
      local item = self["RewardItem" .. i]
      item:ReInit(self.sevenDayInfo.scoreReward[i], self.sevenDayInfo, self.activityId)
    end
  end
end

local function RefreshUI(self)
  local sevenDayInfo = DataCenter.ActSevenDayV2Data:GetInfoByActId(tonumber(self.activityId))
  self:ReInit(sevenDayInfo)
end

UIActSevenDayV2RewardView.OnCreate = OnCreate
UIActSevenDayV2RewardView.OnDestroy = OnDestroy
UIActSevenDayV2RewardView.OnEnable = OnEnable
UIActSevenDayV2RewardView.OnDisable = OnDisable
UIActSevenDayV2RewardView.ComponentDefine = ComponentDefine
UIActSevenDayV2RewardView.ComponentDestroy = ComponentDestroy
UIActSevenDayV2RewardView.DataDefine = DataDefine
UIActSevenDayV2RewardView.DataDestroy = DataDestroy
UIActSevenDayV2RewardView.InitSliderData = InitSliderData
UIActSevenDayV2RewardView.GetNowSliderValue = GetNowSliderValue
UIActSevenDayV2RewardView.ReInit = ReInit
UIActSevenDayV2RewardView.OnAddListener = OnAddListener
UIActSevenDayV2RewardView.OnRemoveListener = OnRemoveListener
UIActSevenDayV2RewardView.RefreshUI = RefreshUI
return UIActSevenDayV2RewardView
