local UICityMainProgress = BaseClass("UICityMainProgress", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local item_icon_path = "UIMainTip/iconName"
local des_txt_Path = "Text_des"
local time_txt_Path = "Text_time"
local slider_path = "Slider"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.time_txt = self:AddComponent(UIText, time_txt_Path)
  self.des_txt = self:AddComponent(UIText, des_txt_Path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.showTimer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
end

local function ComponentDestroy(self)
  self.item_icon = nil
  self.time_txt = nil
  self.des_txt = nil
  if self.showTimer ~= nil then
    self.showTimer:Stop()
    self.showTimer = nil
  end
  self.timer_action = nil
  self:DeleteTimer()
end

local function ReInit(self, param)
  self.param = param
  if self.param ~= nil then
    self.des_txt:SetLocalText(self.param.description)
    self.item_icon:LoadSprite(string.format(LoadPath.ItemPath, self.param.icon))
    self:AddTimer()
    self:RefreshTime()
  end
end

local function RefreshTime(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.param.endTime ~= nil then
    local leftTime = self.param.endTime - now
    if self.param.lastTime ~= leftTime and self.time_txt ~= nil then
      self.param.lastTime = leftTime
      if leftTime <= 0 then
        self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
        self.slider:SetValue(1)
      else
        self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
        local percent = 1 - leftTime / math.max(1, self.param.totalTime)
        self.slider:SetValue(percent)
      end
    end
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

UICityMainProgress.OnCreate = OnCreate
UICityMainProgress.OnDestroy = OnDestroy
UICityMainProgress.ComponentDefine = ComponentDefine
UICityMainProgress.ComponentDestroy = ComponentDestroy
UICityMainProgress.ReInit = ReInit
UICityMainProgress.RefreshTime = RefreshTime
UICityMainProgress.AddTimer = AddTimer
UICityMainProgress.DeleteTimer = DeleteTimer
return UICityMainProgress
