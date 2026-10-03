local WorldActBossDes = BaseClass("WorldActBossDes", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "BuildInfo/Image"
local slider_path = "BuildInfo/Slider"
local rest_num_path = "BuildInfo/restNum"
local rest_des_path = "BuildInfo/restDes"
local reset_time_path = "BuildInfo/resetTime"

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
  self:DeleteTimer()
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.rest_des = self:AddComponent(UIText, rest_des_path)
  self.rest_num = self:AddComponent(UIText, rest_num_path)
  self.reset_time = self:AddComponent(UIText, reset_time_path)
end

local function ComponentDestroy(self)
  self.icon = nil
end

local function DataDefine(self)
  self.param = nil
  self.isUpdate = false
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
end

local function DataDestroy(self)
  self.param = nil
end

local function RefreshData(self, param)
  self.data = param
  self.isUpdate = false
  self.reset_time:SetText("")
  self.rest_des:SetLocalText(self.data.des)
  self:SetBloodSlider(self.data.curBlood, self.data.maxBlood)
  self:CheckShowTime()
end

local function CheckShowTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.finishTime = 0
  self.isUpdate = false
  if curTime < self.data.startTime then
    self.finishTime = self.data.startTime
    self.isUpdate = true
    self.dialogId = 302178
    self:AddTimer()
    self:RefreshTime()
  elseif curTime < self.data.endTime then
    self.finishTime = self.data.endTime
    self.isUpdate = true
    self.dialogId = 302177
    self:AddTimer()
    self:RefreshTime()
  else
    self:DeleteTimer()
    self.dialogId = 302190
    self.reset_time:SetText(Localization:GetString(self.dialogId))
  end
end

local function SetBloodSlider(self, curBlood, maxBlood)
  local tempValue = math.min(curBlood / math.max(maxBlood, 1), 1)
  self.slider:SetValue(tempValue)
  self.rest_num:SetText(string.GetFormattedPercentStr(tempValue))
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = self.finishTime - curTime
  if 0 < deltaTime then
    local cdTime = Localization:GetString(self.dialogId, UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    if self.data.isPuzzleMonster ~= true then
      local times = DataCenter.ActBossDataManager:GetRestTransNum()
      local maxNum = DataCenter.ActBossDataManager.attackMaxNum
      local remainTimes = Localization:GetString("372286") .. times .. "/" .. maxNum
      self.reset_time:SetText(cdTime .. "\n" .. remainTimes)
    else
      self.reset_time:SetText(cdTime)
    end
  else
    self:CheckShowTime()
  end
end

WorldActBossDes.OnCreate = OnCreate
WorldActBossDes.OnDestroy = OnDestroy
WorldActBossDes.OnEnable = OnEnable
WorldActBossDes.OnDisable = OnDisable
WorldActBossDes.ComponentDefine = ComponentDefine
WorldActBossDes.ComponentDestroy = ComponentDestroy
WorldActBossDes.DataDefine = DataDefine
WorldActBossDes.DataDestroy = DataDestroy
WorldActBossDes.RefreshData = RefreshData
WorldActBossDes.RefreshTime = RefreshTime
WorldActBossDes.AddTimer = AddTimer
WorldActBossDes.DeleteTimer = DeleteTimer
WorldActBossDes.SetBloodSlider = SetBloodSlider
WorldActBossDes.CheckShowTime = CheckShowTime
return WorldActBossDes
