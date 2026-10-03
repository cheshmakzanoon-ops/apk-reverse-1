local KillZombieCtrlManager = BaseClass("KillZombieCtrlManager", CEventable)
local KillZombieActionCtrl = require("Scene.KillZombieActivity.KillZombieALBoss.KillZombieActionCtrl")
local DataCenter = _ENV.DataCenter

local function __init(self, owner)
  self.bossActionCtrls = {}
  self.updateTimer = nil
  self.updateSecTimer = nil
  self.markCreate = nil
  self:AddListeners()
end

local function __delete(self)
  self:RemoveListeners()
  self:Dispose()
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
  if self.bossActionCtrls then
    for _, v in pairs(self.bossActionCtrls) do
      if v then
        v:Destroy()
      end
    end
    self.bossActionCtrls = nil
  end
  self.markCreate = nil
end

local function EnterWorld(self)
  self.bossActionCtrls = {}
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

local function AddListeners(self)
  self:RegisterEvent(EventId.OnMonsterCommonCastSkill, self.OnBossAttack)
  self:RegisterEvent(EventId.ChallengeZombieBossHpLost, self.OnBossHpLost)
  self:RegisterEvent(EventId.OnNewAllianceSkillAttacked, self.OnAllianceSkillAttacked)
end

local function RemoveListeners(self)
  self:UnregisterEvent(EventId.OnMonsterCommonCastSkill)
  self:UnregisterEvent(EventId.ChallengeZombieBossHpLost)
  self:UnregisterEvent(EventId.OnNewAllianceSkillAttacked)
end

local function OnUpdateSec(self)
  for _, v in pairs(self.bossActionCtrls) do
    if v then
      v:OnUpdateSec()
    end
  end
end

local function OnUpdate(self)
  for _, v in pairs(self.bossActionCtrls) do
    if v then
      v:OnUpdate()
    end
  end
end

local function CreateBossActionCtrl(self, march, transform)
  if march and transform then
    local uuid = march.uuid
    local ctrl = self.bossActionCtrls[uuid]
    if ctrl then
      ctrl:Destroy()
    end
    self.bossActionCtrls[uuid] = KillZombieActionCtrl.New(march, transform)
  end
end

local function RemoveBossActionCtrl(self, uuid)
  if uuid then
    local ctrl = self.bossActionCtrls[uuid]
    if ctrl then
      ctrl:Destroy()
      self.bossActionCtrls[uuid] = nil
    end
  end
end

function KillZombieCtrlManager:DelayRemoveKillZombieKirovActionCtrl(uuid, time)
  if uuid then
    local ctrl = self.bossActionCtrls[uuid]
    if ctrl then
      ctrl:DelayDestroy(time)
    end
  end
end

local function RefreshBossActionCtrl(self, march)
  if march then
    local ctrl = self.bossActionCtrls[march.uuid]
    if ctrl then
      ctrl:RefreshMarchInfo(march)
      EventManager:GetInstance():Broadcast(EventId.ChallengeZombieBossMarchInfoRefresh, march.uuid)
    end
  end
end

local function GetBossActionCtrl(self, uuid)
  if self.bossActionCtrls and uuid then
    return self.bossActionCtrls[uuid]
  end
end

local function OnBossAttack(self, msg)
  local uuid = msg and msg.monsterUid
  local ctrl = self:GetBossActionCtrl(uuid)
  if ctrl then
    ctrl:ChangeAttackState()
  end
end

local function OnBossHpLost(self, t)
  local uuid = t and t.uuid
  local ctrl = self:GetBossActionCtrl(uuid)
  if ctrl then
    ctrl:OnHurt(t)
  end
end

local function OnBossEscape(self, t)
  local uuid = t and t.uuid
  local ctrl = self:GetBossActionCtrl(uuid)
  if ctrl then
    ctrl:OnBossEscape()
  end
end

local function OnAllianceSkillAttacked(self, t)
  local uuid = t and t.bossUid
  local ctrl = self:GetBossActionCtrl(uuid)
  if ctrl then
    ctrl:PlayEffect(ctrl.EffectFlag.DizzinessHit, 10)
  end
end

KillZombieCtrlManager.__init = __init
KillZombieCtrlManager.__delete = __delete
KillZombieCtrlManager.Dispose = Dispose
KillZombieCtrlManager.EnterWorld = EnterWorld
KillZombieCtrlManager.ExitWorld = ExitWorld
KillZombieCtrlManager.AddListeners = AddListeners
KillZombieCtrlManager.RemoveListeners = RemoveListeners
KillZombieCtrlManager.OnUpdateSec = OnUpdateSec
KillZombieCtrlManager.OnUpdate = OnUpdate
KillZombieCtrlManager.CreateBossActionCtrl = CreateBossActionCtrl
KillZombieCtrlManager.RemoveBossActionCtrl = RemoveBossActionCtrl
KillZombieCtrlManager.RefreshBossActionCtrl = RefreshBossActionCtrl
KillZombieCtrlManager.GetBossActionCtrl = GetBossActionCtrl
KillZombieCtrlManager.OnBossAttack = OnBossAttack
KillZombieCtrlManager.OnBossHpLost = OnBossHpLost
KillZombieCtrlManager.OnBossEscape = OnBossEscape
KillZombieCtrlManager.OnAllianceSkillAttacked = OnAllianceSkillAttacked
return KillZombieCtrlManager
