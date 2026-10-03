local BasePlatoon = BaseClass("BasePlatoon")
local Captain = require("Scene.LWBattle.Skirmish.Unit.Captain")
local Minion = require("Scene.LWBattle.Skirmish.Unit.Minion")
local GameObject = CS.UnityEngine.GameObject

function BasePlatoon:__init(logic, army, index, captainInitShowState, param)
  self.index = index
  self.army = army
  self.logic = logic
  self.sceneData = self.logic.sceneData
  self.battleData = self.logic.battleData
  local go = GameObject("PlatoonRoot")
  self.gameObject = go
  self.transform = go.transform
  self.transform:SetParent(army.transform)
  self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  self.curWorldPos = Vector3.zero
  self.localPosition = self.sceneData.platoonLocalPos[index]
  self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)
  self.dirMultiplier = self.army.dirMultiplier
  self.isMoving = true
  self.captainInitShowState = captainInitShowState
  if self.captainInitShowState == nil then
    self.captainInitShowState = true
  end
end

function BasePlatoon:__delete()
  self:Destroy()
end

function BasePlatoon:Destroy()
  if self.gameObject then
    CS.UnityEngine.GameObject.Destroy(self.gameObject)
    self.gameObject = nil
    self.transform = nil
  end
  self.logic = nil
  self.index = nil
  self.army = nil
  self.sceneData = nil
  self.battleData = nil
  self.curPos = nil
end

function BasePlatoon:GetPosition()
  if self.transform then
    self.curWorldPos.x, self.curWorldPos.y, self.curWorldPos.z = self.transform:Get_position()
    return self.curWorldPos
  else
    return self.army:GetPosition() + self.localPosition * self.dirMultiplier
  end
end

function BasePlatoon:ChangeStage(stage)
end

function BasePlatoon:GetMoveVelocity()
  return self.army:GetMoveVelocity()
end

function BasePlatoon:OnCaptainTakeDamage(curHp)
end

function BasePlatoon:OnCaptainHeal(curHp)
end

function BasePlatoon:StopMoving()
  self.isMoving = false
end

function BasePlatoon:GetTeamZeroWorldPos()
  if self.army then
    return self.army:GetZeroWorldPos()
  end
  if not IsNull(self.transform) then
    if not self._cachePos then
      self._cachePos = Vector3.New()
    end
    self._cachePos.x, self._cachePos.y, self._cachePos.z = self.transform:Get_position()
    return self._cachePos
  end
  return Vector3.zero
end

function BasePlatoon:GetCapatinPosition()
  return Vector3.zero
end

function BasePlatoon:GetTeamRootTransform()
  if self.army and self.army.GetRootTransform then
    return self.army:GetRootTransform()
  end
end

return BasePlatoon
