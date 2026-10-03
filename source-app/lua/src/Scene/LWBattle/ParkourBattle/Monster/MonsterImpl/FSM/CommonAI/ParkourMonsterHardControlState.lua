local ParkourMonsterHardControlState = BaseClass("ParkourMonsterHardControlState")

function ParkourMonsterHardControlState:Init(unit)
  self.unit = unit
  self.controlTime = 0
  self.isStiff = nil
  self.curType = -1
  self.timer = 0
  self.cacheTypeTime = {}
end

function ParkourMonsterHardControlState:__delete()
  self.unit = nil
  self.controlTime = 0
  self.cacheTypeTime = nil
  self.timer = 0
end

function ParkourMonsterHardControlState:OnEnter(type, time, data)
  self.controlTime = time
  self.curType = type
  self:EnterImp(type, time, data)
end

function ParkourMonsterHardControlState:CheckTypeValid(type)
  if type == HardControlType.TornadoDown then
    return true
  end
  local priority = PVEHardControlPriority
  for _, t in ipairs(priority) do
    if t == self.curType then
      return false
    end
    if t == type then
      return true
    end
  end
  return false
end

function ParkourMonsterHardControlState:EnterImp(type, time, data)
  if type == HardControlType.Tornado then
    if self.unit.RemoveDestination then
      self.unit:RemoveDestination()
    end
    self.unit:PlaySimpleAnim(AnimName.Stun, 1)
    if self.unit.StopHitBackMove then
      self.unit:StopHitBackMove()
    end
    self.cacheTypeTime[HardControlType.HitBack] = nil
  elseif type == HardControlType.TornadoDown then
    if self.unit.RemoveDestination then
      self.unit:RemoveDestination()
    end
    self.unit:PlaySimpleAnim(AnimName.Stun, 1)
    if self.unit.StopHitBackMove then
      self.unit:StopHitBackMove()
    end
    self.cacheTypeTime[HardControlType.HitBack] = nil
    self.tornadoDownTime = time
    self.tornadoDownFrom = 0
    if self.unit then
      local pos = self.unit:GetPosition()
      self.tornadoDownFrom = pos.y
    end
  elseif type == HardControlType.HitBack then
    if self.unit.StopAgent then
      self.unit:StopAgent()
    end
    if self.unit.HitBackMove then
      self.unit:HitBackMove(data, time)
    end
  elseif type == HardControlType.Frozen then
    if self.unit.StopAgent then
      self.unit:StopAgent()
    end
    if self.unit.anim then
      self.unit:PlaySimpleAnim(self.unit:GetCurAnimName(), 0)
    end
    if self.unit.ShowFrozen then
      self.unit:ShowFrozen()
    end
  elseif type == HardControlType.Stiff then
    if self.unit.StopAgent then
      self.unit:StopAgent()
    end
    if self.unit.anim then
      self.unit:PlaySimpleAnim(self.unit:GetCurAnimName(), 0)
    end
  elseif type == HardControlType.Imprison and self.unit.StopAgent then
    self.unit:StopAgent()
  end
end

function ParkourMonsterHardControlState:Reapply(fromType, type)
  self:ExitTypeImp(fromType, true, true)
  self:EnterImp(type, self.controlTime)
end

function ParkourMonsterHardControlState:OnTransToSelf(type, time, data)
  if type ~= self.curType then
    if 0 < time then
      self.cacheTypeTime[type] = time + self.timer
    else
      self.cacheTypeTime[type] = time
    end
    if not self:CheckTypeValid(type) then
      if type == HardControlType.HitBack then
        self.cacheTypeTime[type] = nil
      end
      return
    end
    self:ExitTypeImp(self.curType)
    self:OnEnter(type, time, data)
    return
  end
  if 0 < time then
    self.controlTime = math.max(self.controlTime, time)
    self.cacheTypeTime[type] = self.controlTime + self.timer
  else
    self.controlTime = time
    self.cacheTypeTime[type] = self.controlTime
  end
end

function ParkourMonsterHardControlState:ExitTypeImp(type, finish, reapply)
  if type == HardControlType.Tornado then
    if finish and not reapply and self.unit.ResetTornado then
      self.unit:ResetTornado()
    end
    self.unit:PlaySimpleAnim(AnimName.Idle, 1)
  elseif type == HardControlType.TornadoDown then
    if self.unit.ResetTornado then
      self.unit:ResetTornado()
    end
    self.unit:PlaySimpleAnim(AnimName.Idle, 1)
  elseif type == HardControlType.HitBack then
    if self.unit.StopHitBackMove then
      self.unit:StopHitBackMove()
    end
    self.cacheTypeTime[HardControlType.HitBack] = nil
  elseif type == HardControlType.Frozen then
    if finish and self.unit.HideFrozen then
      self.unit:HideFrozen()
    end
    if self.unit.anim then
      self.unit:PlaySimpleAnim(self.unit:GetCurAnimName(), 1)
    end
  elseif type == HardControlType.Stiff then
    if self.unit.anim then
      self.unit:PlaySimpleAnim(self.unit:GetCurAnimName(), 1)
    end
  elseif type == HardControlType.Imprison then
  end
end

function ParkourMonsterHardControlState:OnExit()
  self:ExitTypeImp(self.curType, true)
end

function ParkourMonsterHardControlState:OnCurTypeFinish()
  local fromType = self.curType
  self.cacheTypeTime[self.curType] = nil
  self.curType = -1
  local priority = PVEHardControlPriority
  for _, type in ipairs(priority) do
    local finishTime = self.cacheTypeTime[type]
    if finishTime then
      if finishTime > self.timer then
        self.controlTime = finishTime - self.timer
        self:Reapply(fromType, type)
        return
      end
      self.cacheTypeTime[type] = nil
    end
  end
  table.clear(self.cacheTypeTime)
  self.curType = fromType
  self.unit.fsm:ChangeState(ZombieState.Idle)
end

function ParkourMonsterHardControlState:OnUpdate(deltaTime)
  deltaTime = deltaTime or Time.deltaTime
  self.timer = self.timer + deltaTime
  if self.controlTime > 0 then
    self.controlTime = self.controlTime - deltaTime
    if self.controlTime <= 0 then
      self:OnCurTypeFinish()
      return
    end
  end
  if self.curType == HardControlType.Tornado then
    self.unit:UpdateTornado()
  elseif self.curType == HardControlType.TornadoDown then
    local delta = self.tornadoDownTime - self.controlTime
    delta = delta / self.tornadoDownTime
    delta = Mathf.Clamp01(delta)
    local y = Mathf.Lerp(self.tornadoDownFrom, 0, delta)
    if self.unit.SetTornadoDown then
      self.unit:SetTornadoDown(y)
    end
  end
end

return ParkourMonsterHardControlState
