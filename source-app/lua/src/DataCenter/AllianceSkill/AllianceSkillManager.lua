local AllianceSkillManager = BaseClass("AllianceSkillManager")
local ResourceManager = CS.GameEntry.Resource
local prefab_attack = "Assets/Main/SeasonRes/S4/Prefabs/AllianceBuilding/WarningEff_s4_GuardianTower_attack.prefab"
local prefab_defence = "Assets/Main/SeasonRes/S4/Prefabs/AllianceBuilding/WarningEff_s4_GuardianTower_defence.prefab"
local prefab_helper = "Assets/Main/SeasonRes/S4/Prefabs/AllianceBuilding/WarningEff_s4_GuardianTower_helper.prefab"
local prefab_other = "Assets/Main/SeasonRes/S4/Prefabs/AllianceBuilding/WarningEff_s4_GuardianTower_other.prefab"
local AllianceUnityConfig = require("DataCenter.AllianceSkill.AllianceUnityConfig")
local SkillEffectClassDic = {
  [1] = require("DataCenter.AllianceSkill.AresMissileSkillTarget"),
  [2] = require("DataCenter.AllianceSkill.GoddessMummySkillAlertEff"),
  [3] = require("DataCenter.AllianceSkill.AresMissileSkillTarget"),
  [4] = require("DataCenter.AllianceSkill.GuardianTowerSkillTarget")
}
local BuildingEffectClassDic = {
  [AlOfficialSkillType.AresMissile] = require("DataCenter.AllianceSkill.AresMissileSkill"),
  [AlOfficialSkillType.GoddessMummy] = require("DataCenter.AllianceSkill.GoddessMummySummoner"),
  [AlOfficialSkillType.MissileFactory] = require("DataCenter.AllianceSkill.AresMissileSkill")
}

function AllianceSkillManager:__init()
  self.theLod = 1
  self.allData = {}
  self.allEffectAlert = {}
  self.aosBuildingScripts = {}
  self.allSkillTargets = {}
  self.aUnityConfigs = {}
  self:AddUpdateTimer()
  self:AddListener()
end

function AllianceSkillManager:__delete()
  self:RemoveUpdateTimer()
  self:RemoveListener()
  self:ClearAll()
end

function AllianceSkillManager:ClearAll()
  for k, v in pairs(self.aosBuildingScripts) do
    if v and v.uuid then
      v:OnDestroy()
    end
  end
  self.aosBuildingScripts = {}
  for k, v in pairs(self.allSkillTargets) do
    if v then
      v:OnDestroy()
      if v.request then
        v.request:Destroy()
      end
    end
  end
  self.allSkillTargets = {}
  for _, v in pairs(self.aUnityConfigs) do
    v:Release()
  end
  self.aUnityConfigs = {}
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local activeData = {}
  for uuid, v in pairs(self.allData) do
    if v and v.uuid and v.pointId and curTime < v.overTime then
      activeData[uuid] = v
    end
  end
  self.allData = activeData
end

function AllianceSkillManager:AddListener()
  if not self.setEventListener then
    self.setEventListener = true
    EventManager:GetInstance():AddListenerWithSelf(EventId.PveLevelEnter, self.ClearAll, self)
    EventManager:GetInstance():AddListenerWithSelf(EventId.PveLevelExit, self.ClearAll, self)
    EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterWorld, self.OnEnterWorld, self)
    EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterCity, self.OnEnterCity, self)
    EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterCrossServer, self.ClearAllAndNotInBigMap, self)
    EventManager:GetInstance():AddListenerWithSelf(EventId.OnQuitCrossServer, self.OnEnterWorld, self)
    EventManager:GetInstance():AddListenerWithSelf(EventId.WORLD_BUILD_IN_VIEW, self.BuildInViewSignal, self)
    EventManager:GetInstance():AddListenerWithSelf(EventId.WORLD_BUILD_OUT_VIEW, self.BuildOutViewSignal, self)
    EventManager:GetInstance():AddListenerWithSelf(EventId.UPDATE_POINTS_DATA, self.OnUpdatePoint, self)
    EventManager:GetInstance():AddListenerWithSelf(EventId.ChangeCameraLod, self.OnLodChange, self)
    EventManager:GetInstance():AddListenerWithSelf(EventId.WorldMarchUpdateDisplayMode, self.OnUpdateDisplayMode, self)
  end
end

function AllianceSkillManager:RemoveListener()
  if self.setEventListener then
    EventManager:GetInstance():RemoveListener2(EventId.PveLevelEnter, self.ClearAll, self)
    EventManager:GetInstance():RemoveListener2(EventId.PveLevelExit, self.ClearAll, self)
    EventManager:GetInstance():RemoveListener2(EventId.OnEnterWorld, self.OnEnterWorld, self)
    EventManager:GetInstance():RemoveListener2(EventId.OnEnterCity, self.OnEnterCity, self)
    EventManager:GetInstance():RemoveListener2(EventId.OnEnterCrossServer, self.ClearAllAndNotInBigMap, self)
    EventManager:GetInstance():RemoveListener2(EventId.OnQuitCrossServer, self.OnEnterWorld, self)
    EventManager:GetInstance():RemoveListener2(EventId.WORLD_BUILD_IN_VIEW, self.BuildInViewSignal, self)
    EventManager:GetInstance():RemoveListener2(EventId.WORLD_BUILD_OUT_VIEW, self.BuildOutViewSignal, self)
    EventManager:GetInstance():RemoveListener2(EventId.UPDATE_POINTS_DATA, self.OnUpdatePoint, self)
    EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.OnLodChange)
    EventManager:GetInstance():RemoveListener(EventId.WorldMarchUpdateDisplayMode, self.OnUpdateDisplayMode, self)
    self.setEventListener = false
  end
end

function AllianceSkillManager:CreateWarEffect(warEffectList, oneEffect, serverId, worldId)
  if LuaEntry == nil or LuaEntry.Player == nil or BattleFieldUtil.InBattleField() then
    return
  end
  if warEffectList and warEffectList.list then
    for k, v in pairs(warEffectList.list) do
      if v and v.uuid then
        self.allData[v.uuid] = v
        self:CreateOneWarEffect(v, serverId, worldId)
      end
    end
  end
  if oneEffect and oneEffect.uuid then
    self.allData[oneEffect.uuid] = oneEffect
    self:CreateOneWarEffect(oneEffect, serverId, worldId)
  end
end

function AllianceSkillManager:CreateOneWarEffect(data, _serverId, _worldId)
  if BattleFieldUtil.InBattleField() or data == nil then
    return
  end
  local canShow = SeasonUtil.InSeasonBigMapMode(LuaEntry.Player:GetCurServerId()) and SeasonUtil.IsInSameMap(data.serverId, ServerEnum.View)
  if not canShow and data.serverId ~= LuaEntry.Player:GetCurServerId() then
    return
  end
  local bUuid = data.uuid
  if data and bUuid then
    local seasonType = SeasonUtil.GetSeasonType()
    local now = UITimeManager:GetInstance():GetServerTime()
    if now >= data.overTime then
      self.allData[bUuid] = nil
      self:RemoveOneWarEffect(bUuid)
      return
    end
    local effect = self.allSkillTargets[bUuid]
    if effect ~= nil and effect.request ~= nil then
      return
    end
    if effect ~= nil then
      effect:OnDestroy()
    end
    local useNewSkill = false
    local unitySkillConfig
    if data.id then
      unitySkillConfig = self:GetAllianceUnityConfigBySkillId(data.id)
      useNewSkill = unitySkillConfig ~= nil
    end
    if useNewSkill then
      self:DoNewWarEffect(unitySkillConfig, data, _serverId)
      return
    end
    local skillEffectClass = SkillEffectClassDic[data.type]
    effect = skillEffectClass and skillEffectClass.New(data)
    if not effect then
      Logger.LogError("CreateOneWarEffect effect is nil, type = " .. data.type)
      return
    end
    effect.drawBlackArea = SeasonUtil.IsInSeasonMummyMode(true)
    self.allSkillTargets[bUuid] = effect
    local modelPath
    local pointData = CS.SceneManager.World:GetPointInfo(data.pointId)
    if data.type == 1 then
      if now >= data.activeTime - 1000 then
        if seasonType == SeasonMapType.Darkness then
          modelPath = "Assets/Main/SeasonRes/S4/Prefabs/AllianceBuilding/allianceBuilding_s4_ares_missile_black.prefab"
        else
          modelPath = "Assets/Main/Prefabs/AllianceBuilding/allianceBuilding_s2_ares_missile_black.prefab"
        end
      elseif seasonType == SeasonMapType.Darkness then
        modelPath = "Assets/Main/SeasonRes/S4/Prefabs/AllianceBuilding/allianceBuilding_s4_zhanshenfeidan.prefab"
      else
        modelPath = "Assets/Main/Prefabs/AllianceBuilding/allianceBuilding_s2_zhanshenfeidan.prefab"
      end
    elseif data.type == 3 then
      if now >= data.activeTime - 1000 then
        if seasonType == SeasonMapType.Darkness then
          modelPath = "Assets/Main/SeasonRes/S4/Prefabs/AllianceBuilding/allianceBuilding_s4_ares_missile_black.prefab"
        else
          modelPath = "Assets/Main/Prefabs/AllianceBuilding/allianceBuilding_s2_ares_missile_black.prefab"
        end
      elseif seasonType == SeasonMapType.Darkness then
        modelPath = "Assets/Main/SeasonRes/S4/Prefabs/AllianceBuilding/allianceBuilding_s4_zhanshenfeidan.prefab"
      else
        modelPath = "Assets/Main/SeasonRes/S3/Prefabs/AllianceBuilding/allianceBuilding_S3_zhanshenfeidan.prefab"
      end
    elseif data.type == 2 then
      if seasonType == SeasonMapType.Darkness then
        modelPath = "Assets/Main/SeasonRes/S4/Prefabs/AllianceBuilding/WarningEff_s4_GoddessMummy.prefab"
      else
        modelPath = "Assets/Main/SeasonRes/S3/Prefabs/Effect/WarningEff_s3_GoddessMummy.prefab"
      end
    elseif data.type == 4 then
      if pointData ~= nil and pointData.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
        if LuaEntry.Player:IsInAlliance() and pointData.allianceId == LuaEntry.Player.allianceId then
          modelPath = prefab_defence
        else
          local factionMgr = DataCenter.SeasonFactionWarDataManager
          if factionMgr:CanAttackAllianceBuild(pointData.buildId, pointData.allianceId) then
            modelPath = prefab_attack
          elseif factionMgr:CanAssistAllianceBuild(pointData.buildId, pointData.allianceId) then
            modelPath = prefab_helper
          else
            modelPath = prefab_other
          end
        end
      else
        modelPath = prefab_attack
      end
    end
    local serverId = data.serverId or _serverId
    local request = ResourceManager:InstantiateAsync(modelPath)
    effect.request = request
    request:completed("+", function()
      if CS.SceneManager.World == nil then
        return
      end
      if request.isError and self.allSkillTargets[bUuid] ~= nil then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      request.gameObject.transform.position = SceneUtils.TileIndexToWorld(data.pointId, ForceChangeScene.World, serverId)
      effect:OnCreate(request.gameObject)
      effect:ReInit(bUuid, data)
      effect:OnLodChange(toInt(self.theLod))
    end)
  end
end

function AllianceSkillManager:RefreshOneWarEffect(data)
  if BattleFieldUtil.InBattleField() or data == nil then
    return
  end
  local canShow = SeasonUtil.InSeasonBigMapMode(LuaEntry.Player:GetCurServerId()) and SeasonUtil.IsInSameMap(data.serverId, ServerEnum.View)
  if not canShow and data.serverId ~= LuaEntry.Player:GetCurServerId() then
    return
  end
  local bUuid = data.uuid
  if data and bUuid then
    local curData = self.allData[bUuid]
    if curData == nil then
      return
    end
    if curData.overTime == data.overTime and curData.activeTime == data.activeTime then
      return
    end
    local now = UITimeManager:GetInstance():GetServerTime()
    if now >= curData.overTime then
      self.allData[bUuid] = nil
      self:RemoveOneWarEffect(bUuid)
      return
    end
    local effect = self.allSkillTargets[bUuid]
    if effect ~= nil and effect.request ~= nil and IsNotNull(effect.request.gameObject) then
      self.allData[bUuid] = data
      effect:ReInit(bUuid, data)
      return
    end
  end
end

function AllianceSkillManager:RemoveWarEffect(warEffectList, oneEffect)
  if warEffectList and warEffectList.list then
    for k, v in pairs(warEffectList.list) do
      if v and v.uuid then
        self:RemoveOneWarEffect(tonumber(v.uuid))
      end
    end
  end
  if oneEffect and oneEffect.uuid then
    self:RemoveOneWarEffect(tonumber(oneEffect.uuid))
  end
end

function AllianceSkillManager:RemoveOneWarEffect(uuid)
  local effect = self.allSkillTargets[uuid]
  if effect then
    effect:OnDestroy()
    if effect.request then
      effect.request:Destroy()
    end
    self.allSkillTargets[uuid] = nil
  end
  self.allData[uuid] = nil
  EventManager:GetInstance():Broadcast(EventId.AlOfficialSkillAlertEffect)
end

function AllianceSkillManager:BuildInViewSignal(data)
  if BattleFieldUtil.InBattleField() then
    return
  end
  self:CheckAOSState(tonumber(data))
end

function AllianceSkillManager:BuildOutViewSignal(data)
  if BattleFieldUtil.InBattleField() then
    return
  end
  self:DeleteAOSState(tonumber(data))
end

function AllianceSkillManager:OnEnterCity()
  self:ClearAll()
  self.allData = {}
  self.signCurServer = nil
end

function AllianceSkillManager:OnEnterWorld()
  self:ClearAllAndNotInBigMap()
end

function AllianceSkillManager:ClearAllAndNotInBigMap()
  local curServer = LuaEntry.Player:GetCurServerId()
  if not self.signCurServer then
    self:ClearAll()
    self.allData = {}
    self.signCurServer = curServer
    return
  end
  local noClear = SeasonUtil.InSeasonBigMapMode(curServer) and SeasonUtil.IsInSameMap(self.signCurServer, ServerEnum.View)
  if not noClear then
    self:ClearAll()
    self.allData = {}
  end
  self.signCurServer = LuaEntry.Player:GetCurServerId()
end

function AllianceSkillManager:OnUpdatePoint()
  ProfilerUtil.BeginSample("AllianceSkillManager.OnUpdatePoint")
  if self.aosBuildingScripts then
    for k, v in pairs(self.aosBuildingScripts) do
      if v and v.uuid and v.skillId and v.skillId == 20001 then
        self:CheckAOSState(v.uuid)
        v:OnUpdatePoint()
      end
      if v and v.uuid and v.data then
        v:OnUpdatePoint()
      end
    end
  end
  ProfilerUtil.EndSample()
end

function AllianceSkillManager:CheckAOSState(uuid)
  local theWorld = CS.SceneManager.World
  if not theWorld then
    return
  end
  local info = theWorld:GetPointInfoByUuid(uuid)
  if info == nil or info.PointType ~= WorldPointType.PlayerBuilding then
    return
  end
  local cache = self.aosBuildingScripts[uuid]
  if cache and cache.uuid then
    cache.fireTime = info.aosEndTime or 0
    if cache.UpdateFireTime then
      cache:UpdateFireTime(info)
    end
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local aosEndTime = info.aosEndTime or 0
  if aosEndTime ~= 0 and curTime <= aosEndTime then
    local gameObject
    local aosType = info:GetAOSType()
    local skillId = IsNull(info.skillId) and 0 or info.skillId
    local obj = CS.SceneManager.World:GetObjectByUuid(uuid)
    if obj ~= nil then
      gameObject = obj:GetGameObject()
      if gameObject == nil then
        return
      end
    else
      return
    end
    local unitySkillConfig = self:GetAllianceUnityConfigBySkillId(skillId)
    if unitySkillConfig then
      self:DoNewAosEffect(unitySkillConfig, info, uuid, gameObject, aosEndTime)
      return
    end
    local class
    if aosType == AlOfficialSkillType.AresMissile then
      local seasonType = SeasonUtil.GetSeasonType()
      if seasonType == SeasonMapType.Darkness then
        class = require("DataCenter.AllianceSkill.AresMissileSkillAisila")
      end
    end
    if class == nil then
      class = BuildingEffectClassDic[aosType]
    end
    if class then
      local effect = class.New()
      self.aosBuildingScripts[uuid] = effect
      effect:OnCreate(gameObject)
      effect:ReInit(uuid, aosEndTime, info.skillId)
      effect:OnLodChange(toInt(self.theLod))
    end
  elseif aosEndTime ~= 0 and curTime > aosEndTime and self.aosBuildingScripts[uuid] == nil then
    self.aosBuildingScripts[uuid] = {}
    local obj = CS.SceneManager.World:GetObjectByUuid(uuid)
    if obj ~= nil then
      obj:UpdateGameObject()
    end
  end
end

function AllianceSkillManager:DeleteAOSState(uuid)
  if self.aosBuildingScripts and self.aosBuildingScripts[uuid] ~= nil then
    if self.aosBuildingScripts[uuid].uuid and self.aosBuildingScripts[uuid].fireTime then
      self.aosBuildingScripts[uuid]:OnDestroy()
    end
    self.aosBuildingScripts[uuid] = nil
  end
end

function AllianceSkillManager:AddUpdateTimer()
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

function AllianceSkillManager:RemoveUpdateTimer()
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function AllianceSkillManager:OnUpdateSec()
  local theWorld = CS.SceneManager.World
  if theWorld ~= nil then
    for uuid, v in pairs(self.allSkillTargets) do
      if v and v.uuid and v.data then
        v:Update(theWorld)
      end
    end
    for uuid, v in pairs(self.aosBuildingScripts) do
      if v and v.uuid and v.fireTime then
        v:Update(theWorld)
      end
    end
    local theAresMissileSkill = DataCenter.AllianceGovernmentSkillManager:GetAresMissileSkillData()
    if theAresMissileSkill ~= nil and theAresMissileSkill.Adsorption ~= true and theAresMissileSkill.state == 0 and theAresMissileSkill.sendUid == LuaEntry.Player.uid then
      local now = UITimeManager:GetInstance():GetServerTime()
      local remainTime = theAresMissileSkill.chantOverTime - now
      if 0 < remainTime and remainTime <= 4000 then
        theAresMissileSkill.Adsorption = true
        local mgr = UIManager:GetInstance()
        local open_count = mgr:GetStackWindowCount()
        if SceneUtils.GetIsInWorld() and LuaEntry.Player:IsInSelfServer() and (open_count == 0 or open_count == 1 and (mgr:IsWindowOpen(UIWindowNames.UIWorldSiegePointSeason) or mgr:IsWindowOpen(UIWindowNames.UIWorldPoint) or mgr:IsWindowOpen(UIWindowNames.UIMainMiniMap))) then
          local worldPointPos = SceneUtils.TileIndexToWorld(theAresMissileSkill.targetPos, ForceChangeScene.World)
          GoToUtil.CloseAllWindows()
          GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.Zoom, LookAtFocusTime, function()
          end, LuaEntry.Player:GetSelfServerId())
        end
      end
    end
  end
end

function AllianceSkillManager:GetBlackAreaOverTime(pointId, serverId)
  local now = UITimeManager:GetInstance():GetServerTime()
  for uuid, v in pairs(self.allSkillTargets) do
    local skill_flag = AlOfficialSkillType.None
    if v and v.uuid and v.data and v.data.id then
      local skill_cfg = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(v.data.id)
      if skill_cfg ~= nil and skill_cfg.skill_flag ~= nil then
        skill_flag = skill_cfg.skill_flag
      end
    end
    if v and v.uuid and v.data and (skill_flag == AlOfficialSkillType.AresMissile or skill_flag == AlOfficialSkillType.MissileFactory) and now > v.data.activeTime and now < v.data.overTime then
      local theType = v.data.type
      local pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
      local posCenter = SceneUtils.IndexToTilePos(v.data.pointId, ForceChangeScene.World)
      local radius = v.data.radius
      if radius > math.abs(pos.x - posCenter.x) and radius > math.abs(pos.y - posCenter.y) then
        if skill_flag == AlOfficialSkillType.MissileFactory then
          theType = AlAlertType.MissileFactory
        end
        return v.data.overTime, theType
      end
    end
  end
  return 0
end

function AllianceSkillManager:OnLodChange(lod)
  self.theLod = toInt(lod)
  for uuid, v in pairs(self.allSkillTargets) do
    if v and v.uuid and v.data then
      v:OnLodChange(lod)
    end
  end
  for uuid, v in pairs(self.aosBuildingScripts) do
    if v and v.uuid and v.fireTime then
      v:OnLodChange(lod)
    end
  end
end

function AllianceSkillManager:OnEnterGame()
  self:RequestWorldEffectAlter()
end

function AllianceSkillManager:RequestWorldEffectAlter()
  local seasonType = SeasonUtil.CurServerTypeInSeason()
  self.allEffectAlert = {}
  if seasonType == SeasonMapType.Nothing or seasonType == SeasonMapType.Desert or seasonType == SeasonMapType.CityStronghold then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GetWorldEffectAlter, 0)
  SFSNetwork.SendMessage(MsgDefines.GetAllianceOfficialSkillList)
  EventManager:GetInstance():Broadcast(EventId.AlOfficialSkillAlertEffect)
end

function AllianceSkillManager:UpdateEffectAlter(eff_list)
  local dataList = {}
  local myLoginServer = LuaEntry.Player:GetSelfServerId()
  local now = UITimeManager:GetInstance():GetServerTime()
  local mgrSkill = DataCenter.AllianceGovernmentSkillManager
  local skill_cfg
  for _, v in ipairs(eff_list) do
    if v and v.serverId == myLoginServer then
      if v.skillId then
        skill_cfg = mgrSkill:GetTemplatesById(v.skillId)
        if skill_cfg ~= nil then
          v.skill_flag = skill_cfg.skill_flag
        end
        if skill_cfg ~= nil and (skill_cfg.skill_flag == AlOfficialSkillType.GuardianTower or skill_cfg.skill_flag == AlOfficialSkillType.TeslaCoil) then
          if v.overTime and now < v.overTime then
            dataList[v.uuid] = v
          end
        elseif v.activeTime and now < v.activeTime then
          dataList[v.uuid] = v
        end
      elseif v.activeTime and now < v.activeTime then
        dataList[v.uuid] = v
      end
    end
  end
  self.allEffectAlert = dataList
  EventManager:GetInstance():Broadcast(EventId.AlOfficialSkillAlertEffect)
end

function AllianceSkillManager:AddEffectAlter(eff)
  if eff == nil or eff.uuid == nil then
    return
  end
  local myLoginServer = LuaEntry.Player:GetSelfServerId()
  if eff.serverId ~= myLoginServer then
    return
  end
  local mgrSkill = DataCenter.AllianceGovernmentSkillManager
  local now = UITimeManager:GetInstance():GetServerTime()
  if eff.skillId then
    local skill_cfg = mgrSkill:GetTemplatesById(eff.skillId)
    if skill_cfg ~= nil then
      eff.skill_flag = skill_cfg.skill_flag
    end
    if skill_cfg ~= nil and (skill_cfg.skill_flag == AlOfficialSkillType.GuardianTower or skill_cfg.skill_flag == AlOfficialSkillType.TeslaCoil) then
      if eff.overTime and now < eff.overTime then
        self.allEffectAlert[eff.uuid] = eff
      end
    elseif eff.activeTime and now < eff.activeTime then
      self.allEffectAlert[eff.uuid] = eff
    end
  elseif eff.activeTime and now < eff.activeTime then
    self.allEffectAlert[eff.uuid] = eff
  end
  EventManager:GetInstance():Broadcast(EventId.AlOfficialSkillAlertEffect)
end

function AllianceSkillManager:RemoveEffectAlter(effect_uuid)
  local effect = self.allEffectAlert[effect_uuid]
  self.allEffectAlert[effect_uuid] = nil
  if effect then
    effect.mask_finish = true
  end
  EventManager:GetInstance():Broadcast(EventId.AlOfficialSkillAlertEffect)
end

function AllianceSkillManager:GetEffectAlert()
  return self.allEffectAlert
end

function AllianceSkillManager:GetActiveEffectAlert(any, exclude_skill_flag)
  if self.allEffectAlert == nil then
    return nil
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local pointId = LuaEntry.Player:GetMainWorldPos()
  local myPos = Vector2.zero
  if toInt(pointId) > 0 then
    myPos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  end
  local myLoginServer = LuaEntry.Player:GetSelfServerId()
  for uuid, effect in pairs(self.allEffectAlert) do
    if effect and effect.overTime ~= nil and now >= effect.overTime then
      effect.mask_finish = true
    end
    if effect and effect.mask_finish ~= true then
      if effect.skill_flag ~= AlOfficialSkillType.GuardianTower and effect.activeTime and now < effect.activeTime or effect.skill_flag == AlOfficialSkillType.GuardianTower and effect.overTime and now < effect.overTime or effect.skill_flag == AlOfficialSkillType.TeslaCoil and effect.overTime and now < effect.overTime then
        if effect.serverId == myLoginServer then
          if any or effect.skill_flag == AlOfficialSkillType.GuardianTower then
            if exclude_skill_flag == nil or effect.skill_flag == nil or effect.skill_flag ~= exclude_skill_flag then
              return effect
            end
          elseif effect.radius ~= nil and myPos.x ~= 0 and myPos.y ~= 0 then
            local targetPos = SceneUtils.IndexToTilePos(effect.targetPointId, ForceChangeScene.World)
            if math.abs(targetPos.x - myPos.x) <= effect.radius and math.abs(targetPos.y - myPos.y) <= effect.radius then
              if effect.effectType == AlAlertType.GoddessMummy then
                if effect.campId ~= DataCenter.SeasonFactionWarDataManager.myCampId and (exclude_skill_flag == nil or effect.skill_flag == nil or effect.skill_flag ~= exclude_skill_flag) then
                  return effect
                end
              elseif effect.effectType == AlAlertType.TeslaCoil then
                if effect.campId ~= DataCenter.SeasonFactionWarDataManager.myCampId and (exclude_skill_flag == nil or effect.skill_flag == nil or effect.skill_flag ~= exclude_skill_flag) then
                  return effect
                end
              elseif exclude_skill_flag == nil or effect.skill_flag == nil or effect.skill_flag ~= exclude_skill_flag then
                return effect
              end
            end
          end
        end
      else
        effect.mask_finish = true
      end
    end
  end
end

function AllianceSkillManager:GetNeedPlayBornAnim()
  if self.forcePlayBornAnim then
    self.forcePlayBornAnim = false
    return true
  end
  return false
end

function AllianceSkillManager:SetNeedPlayBornAnim(bool)
  self.forcePlayBornAnim = bool
end

function AllianceSkillManager:OnUpdateDisplayMode()
  local displayLv = DisplaySettings.GetCurrentDisplayLevel()
  for _, v in pairs(self.allSkillTargets) do
    if v and v.uuid and v.data and v.OnDisplayLevelChange then
      v:OnDisplayLevelChange(displayLv)
    end
  end
  for _, v in pairs(self.aosBuildingScripts) do
    if v and v.uuid and v.fireTime and v.OnDisplayLevelChange then
      v:OnDisplayLevelChange(displayLv)
    end
  end
end

function AllianceSkillManager:SkillEmpCoilHurtEffect(message)
  if not SceneUtils.GetIsInWorld() then
    return
  end
  local pointId = message.pointId
  local skillId = message.skillId or 0
  local damageUserPoints = message.damageUserPoints
  if damageUserPoints and 0 < skillId then
    local unityConfig = DataCenter.AllianceSkillManager:GetAllianceUnityConfigBySkillId(skillId)
    if unityConfig then
      local hitEffect = unityConfig:GetSkillEffectByTags("hit")
      for _, v in pairs(damageUserPoints) do
        local pos = SceneUtils.TileIndexToWorld(v.pointId, ForceChangeScene.World, LuaEntry.Player:GetSelfServerId())
        DataCenter.WorldBattleManager:ShowEffectObj(hitEffect.Path, pos, nil, hitEffect.Duration, CS.SceneManager.World.DynamicObjNode)
      end
    end
  end
end

function AllianceSkillManager:DoNewAosEffect(unitySkillConfig, info, uuid, gameObject, aosEndTime)
  local class = require(unitySkillConfig.BaseScriptPath)
  local effect = class.New()
  self.aosBuildingScripts[uuid] = effect
  effect:OnCreate(gameObject)
  effect:ReInit(uuid, aosEndTime, info.skillId, unitySkillConfig)
  effect:OnLodChange(toInt(self.theLod))
end

function AllianceSkillManager:DoNewWarEffect(unitySkillConfig, data, serverId)
  local bUuid = data.uuid
  local aresEffectLua = require(unitySkillConfig.AresScriptPath)
  local aresEffect = aresEffectLua.New(data)
  if not aresEffect then
    Logger.LogError("CreateOneWarEffect effect is nil, type = " .. data.type)
    return
  end
  aresEffect.drawBlackArea = SeasonUtil.IsInSeasonMummyMode(true)
  self.allSkillTargets[bUuid] = aresEffect
  local serverId = data.serverId or serverId
  local modelPath = unitySkillConfig.AresModelPath
  if data.type == 1 then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now >= data.activeTime - 1000 then
      modelPath = unitySkillConfig.PreBlackModel
    end
  end
  local request = ResourceManager:InstantiateAsync(modelPath)
  aresEffect.request = request
  request:completed("+", function()
    if CS.SceneManager.World == nil then
      return
    end
    if request.isError and self.allSkillTargets[bUuid] ~= nil then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform.position = SceneUtils.TileIndexToWorld(data.pointId, ForceChangeScene.World, serverId)
    aresEffect:OnCreate(request.gameObject)
    aresEffect:ReInit(bUuid, data, unitySkillConfig)
    aresEffect:OnLodChange(toInt(self.theLod))
  end)
end

function AllianceSkillManager:GetAllianceUnityConfigBySkillId(skillId)
  local config = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(skillId)
  if not config or string.IsNullOrEmpty(config.unity_config) then
    Logger.LogInfo("[AllianceSkillManager] skillId" .. skillId .. " not UnityConfigPath")
    return
  end
  local aUnityConfig = self.aUnityConfigs[skillId]
  if aUnityConfig then
    return aUnityConfig
  else
    aUnityConfig = AllianceUnityConfig.New(skillId)
  end
  self.aUnityConfigs[skillId] = aUnityConfig
  aUnityConfig:Load(config.unity_config)
  return aUnityConfig
end

return AllianceSkillManager
