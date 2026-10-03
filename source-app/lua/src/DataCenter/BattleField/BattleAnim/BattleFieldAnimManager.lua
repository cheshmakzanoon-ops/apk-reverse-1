local BattleFieldAnimManager = BaseClass("BattleFieldAnimManager", CEventable)
local BattleObjBuild = require("DataCenter.BattleField.BattleAnim.BattleObjBuild")
local BattleObjWinterDrop = require("DataCenter.BattleField.BattleAnim.BattleObjWinterDrop")
local EffectObjManager = require("Scene.LWBattle.EffectObj.EffectObjManager")

function BattleFieldAnimManager:__init()
  self.objs = {}
  self.skillParam = {}
  self.dropPreSign = {}
  self.skillBornSign = {}
  self.effParam = {}
  self.effectObjMgr = EffectObjManager.New(self)
  self:RegisterEvent(EventId.QuitDragonWorld, self.ClearAll)
end

function BattleFieldAnimManager:__delete()
  self:UnregisterEvent(EventId.QuitDragonWorld, self.ClearAll)
  self:ClearAll()
  if self.effectObjMgr then
    self.effectObjMgr:Delete()
    self.effectObjMgr = nil
  end
end

function BattleFieldAnimManager:ClearAll()
  if self.effectObjMgr then
    self.effectObjMgr:ClearTask()
    self.effectObjMgr:ResetData()
  end
  for _, v in pairs(self.objs) do
    v:OnDestroy()
    v:Delete()
  end
  self.objs = {}
  self.skillParam = {}
  self.dropPreSign = {}
  self.skillBornSign = {}
  self.effParam = {}
end

function BattleFieldAnimManager:OnUpdate()
  if self.effectObjMgr then
    self.effectObjMgr:OnUpdate()
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for _, v in pairs(self.objs) do
    v:Update(curTime)
  end
end

function BattleFieldAnimManager:PlayDrop(pointIndex)
  local obj = self.objs[pointIndex]
  if obj ~= nil and type(obj.InitDrop) == "function" then
    obj:InitDrop()
  else
    self.dropPreSign[pointIndex] = true
  end
end

function BattleFieldAnimManager:DeleteObj(pointIndex)
  local obj = self.objs[pointIndex]
  if obj ~= nil then
    obj:OnDestroy()
    obj:Delete()
    self.objs[pointIndex] = nil
  end
  self.dropPreSign[pointIndex] = nil
  self.skillBornSign[pointIndex] = nil
end

function BattleFieldAnimManager:UpdateObjAnim(pointIndex, bfType)
  local obj = self.objs[pointIndex]
  if obj ~= nil then
    obj:UpdateDetail()
    obj:ReInit()
    return
  end
  local info = CS.SceneManager.World:GetPointInfo(pointIndex)
  local detailInfo = info ~= nil and info.detail or nil
  local buildId = detailInfo ~= nil and detailInfo.BuildId or 0
  if bfType == BattleFieldType.WinterStorm then
    local config = BattleFieldUtil.GetBuildTemplate(buildId, bfType)
    if config ~= nil then
      if config:IsDefence() then
        obj = BattleObjBuild.New()
      elseif config:IsDrop() then
        obj = BattleObjWinterDrop.New()
      end
    end
  elseif bfType == BattleFieldType.EpidemicZone then
    local config = BattleFieldUtil.GetBuildTemplate(buildId, bfType)
    if config ~= nil and config:IsDefence() then
      obj = BattleObjBuild.New()
    end
  end
  if obj == nil then
    return
  end
  self.objs[pointIndex] = obj
  obj:OnCreate(pointIndex, bfType)
  obj:ReInit()
  if self.dropPreSign[pointIndex] then
    self.dropPreSign[pointIndex] = nil
    self:PlayDrop(pointIndex)
  end
end

function BattleFieldAnimManager:UpdateObjSkill(ownerUid, skillId, pointIndex, go)
  if skillId == nil then
    self:DeleteObj(ownerUid)
    return
  end
  local obj = self.objs[ownerUid]
  if obj ~= nil then
    obj:UpdateSkillInfo(skillId, pointIndex, go)
    obj:ReInit()
    local info = self.skillBornSign[ownerUid]
    if info ~= nil and go ~= nil then
      obj:PlayAnim(info[1], info[2])
      self.skillBornSign[ownerUid] = nil
    end
    return
  end
  obj = BattleObjBuild.New()
  self.objs[ownerUid] = obj
  obj:OnCreateSkill(ownerUid, skillId, pointIndex, go)
  obj:ReInit()
  local info = self.skillBornSign[ownerUid]
  if info ~= nil and go ~= nil then
    obj:PlayAnim(info[1], info[2])
    self.skillBornSign[ownerUid] = nil
  end
end

function BattleFieldAnimManager:ShowSkillAim(ownerUid)
  local obj = self.objs[ownerUid]
  if obj ~= nil and obj.ShowAllAimEff then
    obj:ShowAllAimEff()
  end
end

function BattleFieldAnimManager:CleanSkillAim(ownerUid)
  local obj = self.objs[ownerUid]
  if obj ~= nil and obj.HideAllAimEff then
    obj:HideAllAimEff()
  end
end

function BattleFieldAnimManager:SetSkillObjTargetPid(ownerUid, skillTargetPId, findAimTime, param)
  local obj = self.objs[ownerUid]
  if obj == nil and param ~= nil and param.skillId ~= nil and param.pointIndex ~= nil then
    self:UpdateObjSkill(ownerUid, param.skillId, param.pointIndex, param.go)
    obj = self.objs[ownerUid]
  end
  if obj ~= nil and skillTargetPId and 0 < skillTargetPId then
    obj:UpdateSkillDetail(skillTargetPId, findAimTime)
    obj:ReInit()
  end
end

function BattleFieldAnimManager:GetSkillParam()
  self.skillParam.uid = nil
  self.skillParam.anim = nil
  self.skillParam.bRewind = false
  self.skillParam.skillId = nil
  self.skillParam.pointIndex = nil
  self.skillParam.go = nil
  return self.skillParam
end

function BattleFieldAnimManager:SetSkillObjAnim(param)
  local ownerUid = param.uid
  local anim = param.anim
  local bRewind = param.bRewind
  local obj = self.objs[ownerUid]
  if obj == nil and param.skillId ~= nil and param.pointIndex ~= nil then
    local add = false
    if anim ~= BattleFieldObjActType.BORN then
      add = true
    elseif param.uid == ActEpidemicUtils.DEV_TEST_SKILL_UID then
      add = true
    end
    if add then
      self:UpdateObjSkill(ownerUid, param.skillId, param.pointIndex, param.go)
      obj = self.objs[ownerUid]
    end
  end
  if obj ~= nil then
    obj:PlayAnim(anim, bRewind)
    return obj:GetFirePointTF()
  elseif anim == BattleFieldObjActType.BORN and not self.skillBornSign[ownerUid] then
    self.skillBornSign[ownerUid] = {anim, bRewind}
  end
end

function BattleFieldAnimManager:GetEffParam()
  self.effParam.pointId = nil
  self.effParam.prefab = nil
  self.effParam.pathPrefix = false
  self.effParam.parent = nil
  self.effParam.time = nil
  self.effParam.rot = nil
  self.effParam.checkInView = true
  return self.effParam
end

function BattleFieldAnimManager:ShowEffectObj(param)
  local world = CS.SceneManager.World
  if not SceneUtils.GetIsInWorld() or world == nil or table.IsNullOrEmpty(param) or string.IsNullOrEmpty(param.prefab) or self.effectObjMgr == nil then
    return
  end
  local dynamicObjNode = world ~= nil and world.DynamicObjNode or nil
  local parent = param.parent or dynamicObjNode
  if parent == nil then
    return
  end
  local pointId = param.pointId
  if param.checkInView and pointId ~= nil then
    local pointInfo = world:GetPointInfo(pointId)
    local uuid = pointInfo ~= nil and pointInfo.uuid or nil
    if uuid == nil or not DataCenter.BuildManager:IsWorldBuildInView(uuid) then
      BattleFieldUtil.Log("PlayEff not in view, pointId=%s, uuid=%s", tostring(pointId), tostring(uuid))
      return
    end
  end
  local path = param.pathPrefix and string.format(param.pathPrefix, param.prefab) or param.prefab
  local time = param.time or 5
  local rot = param.rot
  local pos = pointId ~= nil and SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, LuaEntry.Player:GetCurServerId()) or nil
  return self.effectObjMgr:ShowEffectObj(path, pos, rot, time, parent, nil, true)
end

function BattleFieldAnimManager:RemoveEffectObj(id)
  if self.effectObjMgr then
    self.effectObjMgr:RemoveEffectObj(id)
  end
end

return BattleFieldAnimManager
