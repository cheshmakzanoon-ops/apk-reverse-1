local PveFlyResManager = BaseClass("PveFlyResManager")
local CitySpaceManFlyWithBloodText = require("Scene.PVEBattleLevel.CitySpaceManFlyWithBloodText")
local CitySpaceManFlyBloodText = require("Scene.PVEBattleLevel.CitySpaceManFlyBloodText")
local ShowFlyDuringTime = 0.5

function PveFlyResManager:__init()
  self.model = {}
  self.flyResList = {}
  self.flyWaitTimer = nil
  
  function self.fly_wait_timer_call_back()
    self:ShowOneFlyRes()
  end
  
  self.freeFlyBlood = {}
end

function PveFlyResManager:__delete()
  self.model = {}
  self.flyResList = {}
  self.flyWaitTimer = nil
end

function PveFlyResManager:AddOneFlyRes(resType, num, pos)
  local param = {}
  param.resType = resType
  param.num = num
  param.pos = pos
  table.insert(self.flyResList, param)
  self:ShowOneFlyRes()
end

function PveFlyResManager:RemoveOneFlyRes(id)
  if self.model[id] ~= nil then
    self.model[id]:Destroy()
    self.model[id] = nil
  end
end

function PveFlyResManager:ShowOneFlyRes()
  self:RemoveFlyWaitTimer()
  if self.flyResList[1] ~= nil then
    local paramPara = table.remove(self.flyResList, 1)
    if self.model == nil then
      self.model = {}
    end
    local id = tostring(NameCount)
    NameCount = NameCount + 1
    local param = {}
    param.id = id
    param.resType = paramPara.resType
    param.num = paramPara.num
    param.pos = paramPara.pos
    self.model[id] = CitySpaceManFlyWithBloodText.New(param)
    self:AddFlyWaitTimer()
  end
end

function PveFlyResManager:RemoveFlyWaitTimer()
  if self.flyWaitTimer ~= nil then
    self.flyWaitTimer:Stop()
    self.flyWaitTimer = nil
  end
end

function PveFlyResManager:AddFlyWaitTimer()
  self:RemoveFlyWaitTimer()
  self.flyWaitTimer = TimerManager:GetInstance():GetTimer(ShowFlyDuringTime, self.fly_wait_timer_call_back, self, true, false, false)
  self.flyWaitTimer:Start()
end

function PveFlyResManager:RemoveAll()
  self:RemoveFlyWaitTimer()
  for k, v in pairs(self.model) do
    v:Destroy()
  end
  for k, v in pairs(self.freeFlyBlood) do
    v:Destroy()
  end
  self.model = {}
  self.flyResList = {}
  self.flyWaitTimer = nil
end

function PveFlyResManager:AddOneFlyBlood(attack, pos)
  local id = tostring(NameCount)
  NameCount = NameCount + 1
  local param = {}
  param.attack = attack
  param.pos = pos
  param.id = id
  if table.count(self.freeFlyBlood) > 0 then
    self.model[id] = table.remove(self.freeFlyBlood)
    self.model[id]:ReInit(param)
  else
    self.model[id] = CitySpaceManFlyBloodText.New(param)
  end
end

function PveFlyResManager:RemoveOneFlyBlood(id)
  if self.model[id] ~= nil then
    self.model[id]:SetVisible(false)
    table.insert(self.freeFlyBlood, self.model[id])
    self.model[id] = nil
  end
end

function PveFlyResManager:OnUpdate(curTime)
  for k, v in pairs(self.model) do
    v:OnUpdate(curTime)
  end
end

return PveFlyResManager
