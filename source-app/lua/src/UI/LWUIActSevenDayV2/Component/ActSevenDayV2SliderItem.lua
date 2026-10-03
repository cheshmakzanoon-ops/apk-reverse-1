local ActSevenDayV2SliderItem = BaseClass("ActSevenDayV2SliderItem", UIBaseContainer)
local base = UIBaseContainer
local NumText_path = "NumText"
local SuoImg_path = "SuoImg"
local RewardImg_path = "RewardImg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
  self.NumText = self:AddComponent(UIText, NumText_path)
  self.SuoBtn = self:AddComponent(UIButton, SuoImg_path)
  self.RewardBtn = self:AddComponent(UIButton, RewardImg_path)
  self.SuoBtn:SetOnClick(function()
    local sevenDayInfo = self.sevenDayInfo
    local activityId = self.acId
    if sevenDayInfo and activityId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActSevenDayV2Reward, {anim = true}, sevenDayInfo, activityId)
    end
  end)
  self.RewardBtn:SetOnClick(function()
    local sevenDayInfo = self.sevenDayInfo
    local activityId = self.acId
    if sevenDayInfo and activityId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActSevenDayV2Reward, {anim = true}, sevenDayInfo, activityId)
    end
  end)
end

local function DataDefine(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDestroy(self)
  self.NumText = nil
  self.SuoImg = nil
end

local function DataDestroy(self)
  self.sevenDayInfo = nil
  self.acId = nil
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ReInit(self, data, dayInfo, acId)
  self.sevenDayInfo = dayInfo
  self.acId = acId
  self.NumText:SetText(data.needScore)
  self.SuoBtn:SetActive(false)
  self.RewardBtn:SetActive(false)
  if self.sevenDayInfo.score >= data.needScore then
    if data.rewardFlag == 0 then
      self.RewardBtn:SetActive(true)
    elseif data.vipRewardFlag == 0 then
      local vipInfo = DataCenter.VIPManager:GetVipData()
      if vipInfo.level < data.needVipLevel then
        self.SuoBtn:SetActive(true)
      else
        self.RewardBtn:SetActive(true)
      end
    end
  end
end

ActSevenDayV2SliderItem.OnCreate = OnCreate
ActSevenDayV2SliderItem.OnEnable = OnEnable
ActSevenDayV2SliderItem.OnAddListener = OnAddListener
ActSevenDayV2SliderItem.OnRemoveListener = OnRemoveListener
ActSevenDayV2SliderItem.OnDisable = OnDisable
ActSevenDayV2SliderItem.ComponentDefine = ComponentDefine
ActSevenDayV2SliderItem.ComponentDestroy = ComponentDestroy
ActSevenDayV2SliderItem.ComponentDestroy = ComponentDestroy
ActSevenDayV2SliderItem.DataDefine = DataDefine
ActSevenDayV2SliderItem.DataDestroy = DataDestroy
ActSevenDayV2SliderItem.OnDestroy = OnDestroy
ActSevenDayV2SliderItem.ReInit = ReInit
return ActSevenDayV2SliderItem
