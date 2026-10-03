local base = UIBaseView
local UILWTWChipFunctionUnlockTipView = BaseClass("UILWTWChipFunctionUnlockTipView", base)
local clickBg_path = "Panel"
local descText_path = "Root/ImgBg/DescText"
local dayText_path = "Root/ImgBg/CountDownTime/Day/DayText"
local hourText_path = "Root/ImgBg/CountDownTime/Hour/HourText"
local minuteText_path = "Root/ImgBg/CountDownTime/Minute/MinuteText"
local secondText_path = "Root/ImgBg/CountDownTime/Second/SecondText"
local imgBg_path = "Root/ImgBg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local x, y, z = self:GetUserData()
  self.imgBg:SetPositionXYZ(x, y, z)
  self.endTime = DataCenter.TWSkillChipManager:GetChipOpenTime()
  self:RefreshCountDownTime()
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
  self.clickBg = self:AddComponent(UIButton, clickBg_path)
  self.descText = self:AddComponent(UIText, descText_path)
  self.dayText = self:AddComponent(UIText, dayText_path)
  self.hourText = self:AddComponent(UIText, hourText_path)
  self.minuteText = self:AddComponent(UIText, minuteText_path)
  self.secondText = self:AddComponent(UIText, secondText_path)
  self.imgBg = self:AddComponent(UIBaseContainer, imgBg_path)
  self.clickBg:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.clickBg = nil
  self.descText = nil
  self.dayText = nil
  self.hourText = nil
  self.minuteText = nil
  self.secondText = nil
  self.imgBg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshCountDownTime(self)
  local curSeconds = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = self.endTime - curSeconds
  if remainTime < 0 then
    remainTime = 0
    self.ctrl:CloseSelf()
  end
  local day = math.floor(remainTime / 86400)
  local hour = math.floor(remainTime % 86400 / 3600)
  local minute = math.floor(remainTime % 3600 / 60)
  local second = math.floor(remainTime % 60)
  self.dayText:SetText(day)
  self.hourText:SetText(hour)
  self.minuteText:SetText(minute)
  self.secondText:SetText(second)
end

local function Update100MS(self)
  self:RefreshCountDownTime()
end

UILWTWChipFunctionUnlockTipView.OnCreate = OnCreate
UILWTWChipFunctionUnlockTipView.OnDestroy = OnDestroy
UILWTWChipFunctionUnlockTipView.OnEnable = OnEnable
UILWTWChipFunctionUnlockTipView.OnDisable = OnDisable
UILWTWChipFunctionUnlockTipView.ComponentDefine = ComponentDefine
UILWTWChipFunctionUnlockTipView.ComponentDestroy = ComponentDestroy
UILWTWChipFunctionUnlockTipView.DataDefine = DataDefine
UILWTWChipFunctionUnlockTipView.DataDestroy = DataDestroy
UILWTWChipFunctionUnlockTipView.RefreshCountDownTime = RefreshCountDownTime
UILWTWChipFunctionUnlockTipView.Update100MS = Update100MS
return UILWTWChipFunctionUnlockTipView
