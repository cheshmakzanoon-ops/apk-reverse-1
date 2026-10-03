local WorldUnit = BaseClass("WorldUnit")
local SkillManager = require("Scene.LWBattle.Skill.SkillManager")

function WorldUnit:Init(battleMgr, guid, meta)
  if not self.curWorldPos then
    self.curWorldPos = Vector3.zero
  end
  self.logic = battleMgr
  self.battleMgr = battleMgr
  self.guid = guid
  self.unitType = nil
  self.searchType = nil
  self.meta = meta
  self.isVisible = true
  self.skillManager = SkillManager.New(self.battleMgr, self)
end

function WorldUnit:DestroyView()
  if self.skillManager then
    self.skillManager:DestroyView()
  end
end

function WorldUnit:DestroyData()
  self.logic = nil
  self.meta = nil
  self.heroEffectMeta = nil
  self.curAnimName = nil
  self.name = nil
  self.guid = nil
  self.unitType = nil
  self.searchType = BattleSearchType.None
  if self.skillManager then
    self.skillManager:DestroyData()
    self.skillManager = nil
  end
  self.battleMgr = nil
end

function WorldUnit:ComponentDefine()
end

function WorldUnit:GetProperty()
  return 0
end

function WorldUnit:OnUpdate()
  if self.skillManager then
    self.skillManager:OnUpdate(Time.deltaTime)
  end
end

local function RealSetCacheWorldPos(self, x, y, z)
  if not self.curWorldPos then
    self.curWorldPos = Vector3.zero
  end
  self.curWorldPos.x = x
  self.curWorldPos.y = y
  self.curWorldPos.z = z
end

local function RealSetCacheLocalPos(self, x, y, z)
  if not self.localPosition then
    self.localPosition = Vector3.zero
  end
  self.localPosition.x = x
  self.localPosition.y = y
  self.localPosition.z = z
end

function WorldUnit:GetPosition()
  local curFrame = Time.frameCount
  if self.getPosCurFrame == curFrame then
    return self.curWorldPos
  end
  self.getPosCurFrame = curFrame
  if self.transform then
    local x, y, z = self.transform:Get_position()
    RealSetCacheWorldPos(self, x, y, z)
  end
  return self.curWorldPos
end

function WorldUnit:SetPosition(worldPos)
  if self.transform then
    self.transform:Set_position(worldPos.x, worldPos.y, worldPos.z)
    RealSetCacheWorldPos(self, worldPos.x, worldPos.y, worldPos.z)
    local localPosX, localPosY, localPosZ = self.transform:Get_localPosition()
    RealSetCacheLocalPos(self, localPosX, localPosY, localPosZ)
  end
end

function WorldUnit:GetLocalPosition()
  if not self.localPosition and self.transform then
    local x, y, z = self.transform:Get_localPosition()
    RealSetCacheLocalPos(self, x, y, z)
  end
  return self.localPosition or Vector3.zero
end

function WorldUnit:SetLocalPosition(localPos)
  if self.transform then
    self.transform:Set_localPosition(localPos.x, localPos.y, localPos.z)
    RealSetCacheLocalPos(self, localPos.x, localPos.y, localPos.z)
    local worldPosX, worldPosY, worldPosZ = self.transform:Get_position()
    RealSetCacheWorldPos(self, worldPosX, worldPosY, worldPosZ)
  end
end

function WorldUnit:SetVisible(visible)
  self.isVisible = visible
  if self.gameObject then
    self.gameObject:SetActive(visible)
  end
end

function WorldUnit:GetTeamZeroWorldPos()
  if self.squad then
    return self.squad:GetZeroWorldPos()
  end
  return Vector3.zero
end

local function CheckAnimName(anim, name)
  if anim == nil or name == nil then
    return nil
  end
  local state = anim:GetState(name)
  if state ~= nil then
    return name
  end
  if name == "death" then
    state = anim:GetState("dead")
    if state ~= nil then
      return "dead"
    end
  end
  if name == "dead" then
    state = anim:GetState("death")
    if state ~= nil then
      return "death"
    end
  end
  return nil
end

function WorldUnit:PlaySimpleAnim(name, speed)
  if self.anim then
    local theAnimName = CheckAnimName(self.anim, name)
    if theAnimName == nil then
      return
    end
    self.curAnimName = theAnimName
    self.anim:Play(theAnimName)
    if speed then
      self.anim:SetStateSpeed(theAnimName, speed)
    end
  end
end

function WorldUnit:GetState(name)
  if self.anim then
    return self.anim:GetState(name)
  end
end

function WorldUnit:RewindAndPlaySimpleAnim(name, speed)
  if self.anim then
    local theAnimName = CheckAnimName(self.anim, name)
    if theAnimName == nil then
      return
    end
    self.curAnimName = theAnimName
    self.anim:Rewind(theAnimName)
    self.anim:Play(theAnimName)
    if speed then
      self.anim:SetStateSpeed(theAnimName, speed)
    end
  end
end

function WorldUnit:CrossFadeSimpleAnim(name, speed, fadeTime)
  if self.anim then
    self.curAnimName = name
    self.anim:CrossFade(name, fadeTime)
    if speed then
      self.anim:SetStateSpeed(name, speed)
    end
  end
end

function WorldUnit:RewindSimpleAnim(name)
  if self.anim then
    local theAnimName = CheckAnimName(self.anim, name)
    if theAnimName == nil then
      return
    end
    self.anim:Rewind(theAnimName)
  end
end

function WorldUnit:GetCurAnimName()
  return self.curAnimName
end

function WorldUnit:GetAnimLength(name)
  if self.anim then
    self.anim:SetStateSpeed(name, 1)
    return self.anim:GetClipLength(name)
  else
    return 0
  end
end

function WorldUnit:ShowOrHide(isShow)
  if self.gameObject then
    self.gameObject:SetActive(isShow)
  end
end

function WorldUnit:GetTransform()
  return self.transform
end

function WorldUnit:GetGameObject()
  return self.gameObject
end

function WorldUnit:GetLocationType()
  return LocationType.None
end

function WorldUnit:GetGuid()
  return self.guid
end

function WorldUnit:GetMoveVelocity()
  return Vector3.zero
end

function WorldUnit:GetSearchType()
  return self.searchType
end

function WorldUnit:GetTeamZeroWorldPos()
  return Vector3.zero
end

function WorldUnit:GetUnitPositionInTeam()
  return Vector3.zero
end

function WorldUnit:GetHeroCamp()
  return HeroType.None
end

function WorldUnit:GetUnitType()
  return self.unitType
end

function WorldUnit:GetCurBlood()
  return self.curBlood or 0
end

return WorldUnit
