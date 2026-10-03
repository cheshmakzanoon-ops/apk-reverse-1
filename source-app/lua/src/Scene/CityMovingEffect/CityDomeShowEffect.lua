local CityDomeShowEffect = BaseClass("CityDomeShowEffect")

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.isUpdate = false
  self.param = nil
  self.curPosition = nil
end

local function DataDestroy(self)
  self.param = nil
  self.curPosition = nil
  self.timer_action = nil
  self:DeleteTimer()
end

local function DeleteTimer(self)
  self.isUpdate = false
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  self.isUpdate = true
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function CheckIsFinish(self)
  if self.isUpdate == true and self.param ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if curTime > self.param.endTime then
      self.isUpdate = false
      CityMovingEffectManager:GetInstance():RemoveCityDomeShowEffect(self.param.bUuid)
    end
  end
end

local function ReInit(self, param)
  self.timer = nil
  
  function self.timer_action(temp)
    self:CheckIsFinish()
  end
  
  self:AddTimer()
  self.param = param
  self:ShowPanel()
end

local function ShowPanel(self)
  local serverId = self.param.serverId or LuaEntry.Player:GetCurServerId()
  self.gameObject.transform.position = SceneUtils.TileIndexToWorld(self.param.posIndex, ForceChangeScene.World, serverId)
end

CityDomeShowEffect.OnCreate = OnCreate
CityDomeShowEffect.OnDestroy = OnDestroy
CityDomeShowEffect.ComponentDefine = ComponentDefine
CityDomeShowEffect.ComponentDestroy = ComponentDestroy
CityDomeShowEffect.DataDefine = DataDefine
CityDomeShowEffect.DataDestroy = DataDestroy
CityDomeShowEffect.ReInit = ReInit
CityDomeShowEffect.ShowPanel = ShowPanel
CityDomeShowEffect.CheckIsFinish = CheckIsFinish
CityDomeShowEffect.AddTimer = AddTimer
CityDomeShowEffect.DeleteTimer = DeleteTimer
return CityDomeShowEffect
