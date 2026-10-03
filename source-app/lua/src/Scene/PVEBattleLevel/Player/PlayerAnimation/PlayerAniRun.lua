local base = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniBase")
local PlayerAniRun = BaseClass("PlayerAniRun", base)
local speed = 0.004
local InitMoveDeltaTime = 20

function PlayerAniRun:__init(spaceman)
  self.m_tmpV = Vector3.New(0, 0, 0)
end

function PlayerAniRun:__delete()
end

function PlayerAniRun:OnEnter()
  base.OnEnter(self)
  self.lastMoveTime = UITimeManager:GetInstance():GetServerTime() - InitMoveDeltaTime
  self.m_tmpV:Set(0, 0, 0)
  self.m_moveFoward = Vector3.foward
  self.targetRotation = Quaternion.identity
  if self.objTransform == nil then
    self.objTransform = self.m_citySpaceMan:GetTransform()
  end
  self:SetSpeed()
end

function PlayerAniRun:OnExit()
end

function PlayerAniRun:OnUpdate()
end

function PlayerAniRun:SetVelocity(vx, vz)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if vx == 0 and vz == 0 or self.objTransform == nil then
    self.lastMoveTime = curTime
    return
  end
  self.m_tmpV:Set(vx, 0, vz)
  self.targetRotation = Quaternion.LookRotation(self.m_tmpV, Vector3.up)
  self.m_moveFoward = self.targetRotation:MulVec3(Vector3.forward)
  self.m_citySpaceMan:TurnToRotation(self.targetRotation)
  local newForward
  local canChange = true
  local pos = self.m_citySpaceMan:GetPosition()
  local realDistance = (curTime - self.lastMoveTime) * self.speed
  self.lastMoveTime = curTime
  if self.m_citySpaceMan.param.isMain then
    local ret, hitInfo = CS.CSUtils.Hit(self.objTransform, 0.4, realDistance)
    if ret == true then
      if hitInfo.x == 0 and hitInfo.y == 0 and hitInfo.z == 0 then
        newForward = nil
      else
        canChange = false
        newForward = hitInfo
      end
    else
      newForward = self.m_moveFoward
    end
    if newForward ~= nil then
      local tempCanChange = canChange
      canChange, newForward = self.m_citySpaceMan.battleLevel.fog:CheckWalkPos(pos, newForward, realDistance, canChange)
      if newForward ~= nil then
        canChange, newForward = self.m_citySpaceMan.battleLevel.collectionMgr:CheckWalkPos(pos, newForward, realDistance, canChange)
        if newForward ~= nil and tempCanChange ~= canChange and CS.CSUtils.Hit2 ~= nil then
          ret, hitInfo = CS.CSUtils.Hit2(pos, newForward, 0.4, realDistance)
          if ret == true then
            newForward = nil
          end
        end
      end
    end
  else
    newForward = self.m_moveFoward
  end
  if newForward == nil then
  else
    pos = pos + newForward * realDistance
    pos.y = 0
    self.m_citySpaceMan:SetPosition(pos)
  end
end

function PlayerAniRun:SetSpeed()
  self.speed = speed
  local buffValue = self.m_citySpaceMan.battleLevel:GetBuffEffectValueByType(PveBuffType.Speed)
  if 0 < buffValue then
    self.speed = self.speed * buffValue
  end
  local speedMulti = self.m_citySpaceMan.battleLevel:GetSpeedMulti()
  self.speed = self.speed * speedMulti
end

function PlayerAniRun:RefreshBuff()
  self:SetSpeed()
end

return PlayerAniRun
