local WorldTroopAttackBuildIcon = BaseClass("WorldTroopAttackBuildIcon")
local time_text_path = "PosGo/TimeText"

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:RemoveTimer()
  self:ComponentDestroy()
end

local function ComponentDefine(self)
  self.time_text = self.transform:Find(time_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.slider = self.transform:GetComponent(typeof(CS.ChangeSceneCircleSlider))
  self.isDoAnim = false
  
  function self.timer_action()
    self:UpdateTime()
  end
  
  self:AddTimer()
end

local function ComponentDestroy(self)
  self.time_text = nil
  self.slider = nil
end

local function RemoveTimer(self)
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

local function SetShowTime(self, startTime, endTime)
  self.startTime = startTime
  self.endTime = endTime
  self.slider:Init(self.startTime, self.endTime)
  self.isDoAnim = true
  self:UpdateTime()
end

local function UpdateTime(self)
  if self.isDoAnim then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local timeLeft = self.endTime - curTime
    if 0 < timeLeft then
      self.time_text.text = UITimeManager:GetInstance():MilliSecondToFmtString(timeLeft)
    else
      self.time_text.text = "00:00:00"
      self.isDoAnim = false
    end
  end
end

WorldTroopAttackBuildIcon.OnCreate = OnCreate
WorldTroopAttackBuildIcon.OnDestroy = OnDestroy
WorldTroopAttackBuildIcon.ComponentDefine = ComponentDefine
WorldTroopAttackBuildIcon.ComponentDestroy = ComponentDestroy
WorldTroopAttackBuildIcon.AddTimer = AddTimer
WorldTroopAttackBuildIcon.SetShowTime = SetShowTime
WorldTroopAttackBuildIcon.UpdateTime = UpdateTime
WorldTroopAttackBuildIcon.RemoveTimer = RemoveTimer
return WorldTroopAttackBuildIcon
