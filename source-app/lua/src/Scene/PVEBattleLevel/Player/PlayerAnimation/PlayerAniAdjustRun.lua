local base = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniBase")
local PlayerAniAdjustRun = BaseClass("PlayerAniAdjustRun", base)
local AutoMoveDelta = 6
local ExitDis = 0.2
local AdjustMax = 10
local speed = 0.08

function PlayerAniAdjustRun:__init(spaceman)
  self.m_tmpV = Vector3.New(0, 0, 0)
  self.adjustTime = 0
end

function PlayerAniAdjustRun:OnEnter()
  base.OnEnter(self)
  if self.objTransform == nil then
    self.objTransform = self.m_citySpaceMan:GetTransform()
  end
  self:SetSpeed()
  self.adjustTime = 0
  self:CheckEnd()
end

function PlayerAniAdjustRun:OnExit()
end

function PlayerAniAdjustRun:OnUpdate()
  self:SetVelocity(self.vx, self.vz)
end

function PlayerAniAdjustRun:SetVelocity(vx, vz)
  if vx == 0 and vz == 0 then
    self:CheckEnd()
    return
  end
  if self.m_tmpV.x ~= vx or self.m_tmpV.z ~= vz then
    self.m_tmpV:Set(vx, 0, vz)
    local _targetQuaternion = Quaternion.LookRotation(self.m_tmpV, Vector3.up)
    self.m_citySpaceMan:SetRotation(_targetQuaternion)
  end
  local moveVec
  local ret, hitInfo = CS.CSUtils.Hit(self.objTransform, 0.4, self.speed)
  if self.m_citySpaceMan.param.isMain and ret == true then
    moveVec = hitInfo * self.speed
  else
    moveVec = self.objTransform.forward * self.speed
  end
  local distToFinal = Vector3.Distance(self.m_citySpaceMan:GetPosition(), self.m_citySpaceMan:GetPosWithExtra())
  if distToFinal < moveVec.magnitude then
    moveVec = moveVec.normalized * distToFinal
  end
  local nowPos = self.m_citySpaceMan:GetPosition() + moveVec
  self.m_citySpaceMan:SetPosition(nowPos)
  self:CheckEnd()
end

function PlayerAniAdjustRun:CheckEnd()
  local finalPos = self.m_citySpaceMan:GetPosWithExtra()
  local nowPos = self.m_citySpaceMan:GetPosition()
  local velocity = Vector3.Normalize(finalPos - nowPos)
  self.vx = velocity.x * AutoMoveDelta
  self.vz = velocity.z * AutoMoveDelta
  local dis = Vector3.Distance(nowPos, finalPos)
  if dis <= ExitDis then
    self.m_citySpaceMan:LeaveAdjustRun()
  end
end

function PlayerAniAdjustRun:SetSpeed()
  self.speed = speed
  local buffValue = self.m_citySpaceMan.battleLevel:GetBuffEffectValueByType(PveBuffType.Speed)
  if 0 < buffValue then
    self.speed = self.speed * buffValue
  end
  local speedMulti = self.m_citySpaceMan.battleLevel:GetSpeedMulti()
  self.speed = self.speed * speedMulti
end

function PlayerAniAdjustRun:RefreshBuff()
  self:SetSpeed()
end

return PlayerAniAdjustRun
