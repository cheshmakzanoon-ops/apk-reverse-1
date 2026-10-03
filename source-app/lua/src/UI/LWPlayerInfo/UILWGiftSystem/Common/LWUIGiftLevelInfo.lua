local base = UIBaseContainer
local LWUIGiftLevelInfo = BaseClass("LWUIGiftLevelInfo", base)
local levelText_path = "LevelText"
local slider_path = "Slider"
local descText_path = "DescText"
local expText_path = "Slider/ExpText"

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
  self.levelText = self:AddComponent(UIText, levelText_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.descText = self:AddComponent(UIText, descText_path)
  self.expText = self:AddComponent(UIText, expText_path)
end

local function ComponentDestroy(self)
  self.levelText = nil
  self.slider = nil
  self.descText = nil
  self.expText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function LWUIGiftLevelInfo:SetData(data)
  local giftLevel = DataCenter.GiftSystemManager:GetGiftLevel()
  local giftExp = DataCenter.GiftSystemManager:GetGiftExp()
  local maxExp = DataCenter.GiftSystemManager:GetNeedExpByLevel(giftLevel + 1)
  self.levelText:SetLocalText(140002, giftLevel)
  if giftExp > maxExp then
    self.descText:SetActive(false)
  else
    self.descText:SetActive(true)
    self.descText:SetLocalText("gift_privilege_des", maxExp - giftExp)
  end
  self.slider:SetValue(giftExp / maxExp)
  self.expText:SetText(string.format("%d/%d", giftExp, maxExp))
end

LWUIGiftLevelInfo.OnCreate = OnCreate
LWUIGiftLevelInfo.OnDestroy = OnDestroy
LWUIGiftLevelInfo.OnEnable = OnEnable
LWUIGiftLevelInfo.OnDisable = OnDisable
LWUIGiftLevelInfo.ComponentDefine = ComponentDefine
LWUIGiftLevelInfo.ComponentDestroy = ComponentDestroy
LWUIGiftLevelInfo.DataDefine = DataDefine
LWUIGiftLevelInfo.DataDestroy = DataDestroy
return LWUIGiftLevelInfo
