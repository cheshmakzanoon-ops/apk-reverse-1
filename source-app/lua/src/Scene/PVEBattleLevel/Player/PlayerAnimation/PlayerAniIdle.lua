local base = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniBase")
local PlayerAniIdle = BaseClass("PlayerAniIdle", base)
local Rigidbody = typeof(CS.UnityEngine.Rigidbody)
local ExitDis = 0.2

function PlayerAniIdle:__init(spaceman)
  local obj = self.m_citySpaceMan:GetInstantiateObj()
  if obj ~= nil then
    self.m_rigidbody = obj:GetComponent(Rigidbody)
  end
end

function PlayerAniIdle:OnEnter()
  base.OnEnter(self)
  if self.m_rigidbody then
    self.m_rigidbody.velocity = Vector3.New(0, 0, 0)
  end
  self.needCheck = not self.m_citySpaceMan.param.isMain and not self.m_citySpaceMan.param.isNoGain
  self.curTime = 0
  self.checkTime = self.m_citySpaceMan.param.index
end

function PlayerAniIdle:OnExit()
  self.needCheck = false
end

function PlayerAniIdle:OnUpdate()
  if self.needCheck then
    self.curTime = self.curTime + 1
    if self.curTime >= self.checkTime then
      self.curTime = 0
      local finalRotation = self.m_citySpaceMan.battleLevel:GetRotation()
      local nowRotation = self.m_citySpaceMan:GetRotation()
      if nowRotation ~= finalRotation then
        self.m_citySpaceMan:SetRotation(finalRotation)
      end
      self:CheckFollow()
    end
  end
end

function PlayerAniIdle:CheckFollow()
  local finalPos = self.m_citySpaceMan:GetPosWithExtra()
  local nowPos = self.m_citySpaceMan:GetPosition()
  local dis = Vector3.Distance(nowPos, finalPos)
  if self.m_citySpaceMan:IsCuttingObject() then
    return
  end
  local leaderPlayer = self.m_citySpaceMan:GetLeader()
  if leaderPlayer ~= nil and leaderPlayer:IsCuttingObject() then
    local objId = self.m_citySpaceMan:GetNearestTriggerId()
    if objId ~= nil then
      self.m_citySpaceMan:ChangeSubPlayerToAdjustToAttack(objId)
    end
  elseif dis > ExitDis then
    self.m_citySpaceMan:ChangeSubPlayerToFollow()
  end
end

function PlayerAniIdle:RefreshBuff()
end

return PlayerAniIdle
