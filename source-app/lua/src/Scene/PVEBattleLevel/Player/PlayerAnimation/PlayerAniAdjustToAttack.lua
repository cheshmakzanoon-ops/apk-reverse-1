local base = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniBase")
local PlayerAniAdjustToAttack = BaseClass("PlayerAniAdjustToAttack", base)
local AutoMoveDelta = 6
local ExitDis = 0.2
local AdjustMax = 6
local EndTime = 0.5
local speed = 0.08

function PlayerAniAdjustToAttack:__init(spaceman)
  self.m_tmpV = Vector3.New(0, 0, 0)
  self.adjustTime = 0
end

function PlayerAniAdjustToAttack:OnEnter()
  base.OnEnter(self)
  self.startEndTime = false
  if self.objTransform == nil then
    self.objTransform = self.m_citySpaceMan:GetTransform()
  end
  self:SetSpeed()
  self.adjustTime = 0
  local cpData = self.m_citySpaceMan.battleLevel:GetObj(self.m_citySpaceMan:GetAdjustAttackObjId())
  if cpData then
    self.finalPos = cpData:GetPosition()
    local velocity = Vector3.Normalize(self.finalPos - self.m_citySpaceMan:GetPosition())
    self.vx = velocity.x * AutoMoveDelta
    self.vz = velocity.z * AutoMoveDelta
    self:CheckEnd()
  else
    self.m_citySpaceMan:LeaveAdjustToAttack()
  end
end

function PlayerAniAdjustToAttack:OnExit()
  self.startEndTime = false
end

function PlayerAniAdjustToAttack:OnUpdate()
  self:SetVelocity(self.vx, self.vz)
end

function PlayerAniAdjustToAttack:SetVelocity(vx, vz)
  if vx == 0 and vz == 0 then
    self:CheckEnd()
    return
  end
  if self.m_tmpV.x ~= vx or self.m_tmpV.z ~= vz then
    self.m_tmpV:Set(vx, 0, vz)
    local _targetQuaternion = Quaternion.LookRotation(self.m_tmpV, Vector3.up)
    self.m_citySpaceMan:SetRotation(_targetQuaternion)
  end
  local ret, hitInfo = CS.CSUtils.Hit(self.objTransform, 0.4, self.speed)
  if self.m_citySpaceMan.param.isMain and ret == true then
    self.nowPos = self.m_citySpaceMan:GetPosition() + hitInfo * self.speed
  else
    self.nowPos = self.m_citySpaceMan:GetPosition() + self.objTransform.forward * self.speed
  end
  self.m_citySpaceMan:SetPosition(self.nowPos)
  self:CheckEnd()
end

function PlayerAniAdjustToAttack:CheckEnd()
  self.nowPos = self.m_citySpaceMan:GetPosition()
  self.dis = Vector3.Distance(self.nowPos, self.finalPos)
  if self.dis <= ExitDis then
    if not self.startEndTime then
      self.startEndTime = true
      self.adjustTime = 0
    end
  elseif self.m_citySpaceMan.battleLevel:GetPlayerActionState() ~= self.m_citySpaceMan.ActionState.Attack and not self.startEndTime then
    self.startEndTime = true
    self.adjustTime = 0
  end
  if self.m_citySpaceMan:GetCurActionState() == self.m_citySpaceMan.ActionState.Attack then
    self.vx = 0
    self.vz = 0
    self.m_citySpaceMan:LeaveAdjustToAttack()
  end
  local cpData = self.m_citySpaceMan.battleLevel:GetObj(self.m_citySpaceMan:GetAdjustAttackObjId())
  if cpData == nil and 0 >= cpData:GetCurBlood() then
    self.m_citySpaceMan:LeaveAdjustToAttack()
  elseif self.startEndTime then
    self.adjustTime = self.adjustTime + Time.deltaTime
    if self.adjustTime > EndTime then
      if self.dis <= ExitDis then
        self.m_citySpaceMan:LeaveAdjustToAttack()
      elseif self.m_citySpaceMan.battleLevel:GetPlayerActionState() ~= self.m_citySpaceMan.ActionState.Attack then
        self.m_citySpaceMan:LeaveAdjustToAttack()
      else
        self.startEndTime = false
        self.adjustTime = 0
      end
    end
  end
end

function PlayerAniAdjustToAttack:SetSpeed()
  self.speed = speed
  local buffValue = self.m_citySpaceMan.battleLevel:GetBuffEffectValueByType(PveBuffType.Speed)
  if 0 < buffValue then
    self.speed = self.speed * buffValue
  end
  local speedMulti = self.m_citySpaceMan.battleLevel:GetSpeedMulti()
  self.speed = self.speed * speedMulti
end

function PlayerAniAdjustToAttack:RefreshBuff()
  self:SetSpeed()
end

return PlayerAniAdjustToAttack
