local InvasionAisillaCtrlManager = BaseClass("InvasionAisillaCtrlManager")
local InvasionAisillaCtrl = require("Scene.InvasionAisilla.InvasionAisillaCtrl")
local pairs = _ENV.pairs
local DataCenter = _ENV.DataCenter

local function __init(self, owner)
  self.allAisilaCtrls = {}
  self.movingModelCtrl = nil
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
  self:Destroy()
end

local function Destroy(self)
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
  for _, v in pairs(self.allAisilaCtrls) do
    v:Delete()
  end
  self.allAisilaCtrls = nil
end

local function Dispose(self)
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
  for _, v in pairs(self.allAisilaCtrls) do
    v:Delete()
  end
  self.allAisilaCtrls = {}
end

local function EnterWorld(self)
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

local function ExitWorld(self)
  self:Dispose()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.OnAisillaAttack, self.OnAisillaAttack)
  EventManager:GetInstance():AddListener(EventId.MonsterInvasionBossHpLost, self.OnMonsterInvasionBossHpLost)
  EventManager:GetInstance():AddListener(EventId.MonsterInvasionAisillaDead, self.OnMonsterInvasionAisillaDead)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.OnAisillaAttack, self.OnAisillaAttack)
  EventManager:GetInstance():RemoveListener(EventId.MonsterInvasionBossHpLost, self.OnMonsterInvasionBossHpLost)
  EventManager:GetInstance():RemoveListener(EventId.MonsterInvasionAisillaDead, self.OnMonsterInvasionAisillaDead)
end

local function OnUpdateSec(self)
  if self.allAisilaCtrls then
    for _, v in pairs(self.allAisilaCtrls) do
      v:OnUpdateSec()
    end
  end
end

function InvasionAisillaCtrlManager:OnUpdate()
  if self.allAisilaCtrls then
    for _, v in pairs(self.allAisilaCtrls) do
      v:OnUpdate()
    end
  end
end

local function CreateAisillaCtrl(self, march, transform)
  if march and transform and self.allAisilaCtrls then
    local uuid = march.uuid
    local ctrl = self.allAisilaCtrls[uuid]
    if ctrl then
      ctrl:Refresh(march, transform)
    else
      self.allAisilaCtrls[uuid] = InvasionAisillaCtrl.New(march, transform)
    end
  end
end

local function RemoveAisillaCtrl(self, uuid)
  if uuid and self.allAisilaCtrls then
    local ctrl = self.allAisilaCtrls[uuid]
    if ctrl then
      ctrl:Delete()
      self.allAisilaCtrls[uuid] = nil
    end
  end
end

local function RefreshAisilaCtrl(self, march)
  if march and self.allAisilaCtrls then
    local ctrl = self.allAisilaCtrls[march.uuid]
    if ctrl then
      ctrl:RefreshBossInfo(march.invasionBossInfo)
    end
  end
end

local function GetAisilaCtrl(self, uuid)
  return uuid and self.allAisilaCtrls[uuid]
end

local function CreateMovingModel(self, transform)
  self:RemoveMovingModel()
  self.movingModelCtrl = InvasionAisillaCtrl.New(nil, transform)
  self.movingModelCtrl:SetDragEffect(true)
end

local function RemoveMovingModel(self)
  if self.movingModelCtrl then
    self.movingModelCtrl:Destroy()
    self.movingModelCtrl = nil
  end
end

local function OnAisillaAttack(uuid)
  local ctrl = DataCenter.InvasionAisillaCtrlManager:GetAisilaCtrl(uuid)
  if ctrl then
    ctrl:ChangeAttackState()
  end
end

local function OnMonsterInvasionBossHpLost(t)
  if t then
    local ctrl = DataCenter.InvasionAisillaCtrlManager:GetAisilaCtrl(t.uuid)
    if ctrl then
      local dmg = t.lostHp or 0
      ctrl:OnHurt(dmg, 1)
    end
  end
end

local function OnMonsterInvasionAisillaDead(param)
  if param and param.uuid and param.status then
    local ctrl = DataCenter.InvasionAisillaCtrlManager:GetAisilaCtrl(param.uuid)
    if ctrl then
      ctrl:ChangeDeadState(param.status)
    end
  end
end

InvasionAisillaCtrlManager.__init = __init
InvasionAisillaCtrlManager.__delete = __delete
InvasionAisillaCtrlManager.Destroy = Destroy
InvasionAisillaCtrlManager.Dispose = Dispose
InvasionAisillaCtrlManager.EnterWorld = EnterWorld
InvasionAisillaCtrlManager.ExitWorld = ExitWorld
InvasionAisillaCtrlManager.AddListener = AddListener
InvasionAisillaCtrlManager.RemoveListener = RemoveListener
InvasionAisillaCtrlManager.OnUpdateSec = OnUpdateSec
InvasionAisillaCtrlManager.CreateAisillaCtrl = CreateAisillaCtrl
InvasionAisillaCtrlManager.RemoveAisillaCtrl = RemoveAisillaCtrl
InvasionAisillaCtrlManager.RefreshAisilaCtrl = RefreshAisilaCtrl
InvasionAisillaCtrlManager.GetAisilaCtrl = GetAisilaCtrl
InvasionAisillaCtrlManager.CreateMovingModel = CreateMovingModel
InvasionAisillaCtrlManager.RemoveMovingModel = RemoveMovingModel
InvasionAisillaCtrlManager.OnAisillaAttack = OnAisillaAttack
InvasionAisillaCtrlManager.OnMonsterInvasionBossHpLost = OnMonsterInvasionBossHpLost
InvasionAisillaCtrlManager.OnMonsterInvasionAisillaDead = OnMonsterInvasionAisillaDead
return InvasionAisillaCtrlManager
