local AllianceGovernmentSkillManager = BaseClass("AllianceGovernmentSkillManager")
local AllianceGovernmentSkillConfig = require("DataCenter.AllianceData.AllianceGovernmentSkillConfig")

function AllianceGovernmentSkillManager:__init()
  self.initialized = false
  self.curSeasonDic = {}
  self.allTemplateDic = {}
  self.theUsedSkillState = nil
  self.allianceOfficialArr = {}
  self.activityData = {}
end

function AllianceGovernmentSkillManager:__delete()
  self.initialized = false
  self.curSeasonDic = {}
  self.allTemplateDic = {}
  self.theUsedSkillState = nil
  self.allianceOfficialArr = {}
  self.activityData = {}
end

function AllianceGovernmentSkillManager:InitTemplates(force)
  if not force and self.initialized then
    return
  end
  local ConfigCache = CS.GameEntry.ConfigCache
  local idList = {}
  local config = DataCenter.SeasonDataManager:GetSeasonConfig()
  if config and config.alliance_government_skill ~= nil and type(config.alliance_government_skill) == "string" then
    for configId in string.gmatch(config.alliance_government_skill, "([^|]+)|?") do
      idList[toInt(configId)] = true
    end
  end
  self.curSeasonDic = {}
  self.allTemplateDic = {}
  LocalController:instance():visitTable(TableName.AllianceGovernmentSkill, function(configId, line)
    local data = AllianceGovernmentSkillConfig.New()
    data:InitData(line)
    self.allTemplateDic[data.id] = data
    if idList[toInt(configId)] then
      self.curSeasonDic[data.id] = data
    end
    local dictRow = {
      type = line.type,
      skill_flag = line.skill_flag,
      effect_scope = line.effect_scope,
      activity_type = line.activity_type,
      unity_config = line.UnityConfigPath,
      skill_icon = line.skill_icon
    }
    ConfigCache:UpdateTemplateData(TableName.AllianceGovernmentSkill, configId, dictRow)
  end)
  self.initialized = true
end

function AllianceGovernmentSkillManager:GetTemplatesByType(officialType)
  local ret = {}
  if not self.initialized then
    self:InitTemplates()
  end
  for k, v in pairs(self.curSeasonDic) do
    if v.type == officialType then
      table.insert(ret, v)
    end
  end
  return ret
end

function AllianceGovernmentSkillManager:GetTemplatesById(skillId)
  if not self.initialized then
    self:InitTemplates()
  end
  return self.allTemplateDic[toInt(skillId)]
end

function AllianceGovernmentSkillManager:GetTemplatesByAnnounceId(announceId)
  if not self.initialized then
    self:InitTemplates()
  end
  for _, v in pairs(self.allTemplateDic) do
    if v.announce_success == announceId then
      return v
    elseif v.announce_prepare == announceId then
      return v
    elseif v.announce_fail == announceId then
      return v
    end
  end
end

function AllianceGovernmentSkillManager:ExistUsefulSkill()
  if not self.initialized then
    self:InitTemplates()
  end
  if self.curSeasonDic then
    for k, v in pairs(self.curSeasonDic) do
      if v and v:IsLinkedActivityOpen() then
        return true
      end
    end
  end
  return false
end

function AllianceGovernmentSkillManager:GetUsableConfigsByOfficial(officialType)
  if not self.initialized then
    self:InitTemplates()
  end
  local skillList = {}
  if self.curSeasonDic then
    for k, v in pairs(self.curSeasonDic) do
      if v and v.type == officialType and v:IsLinkedActivityOpen() then
        table.insert(skillList, v)
      end
    end
  end
  return skillList
end

function AllianceGovernmentSkillManager:CheckHasUsableSkillByOfficial(officialType)
  return not table.IsNullOrEmpty(self:GetUsableConfigsByOfficial(officialType))
end

function AllianceGovernmentSkillManager:GetUsableConfigBySkillType(skillType)
  if not self.initialized then
    self:InitTemplates()
  end
  if self.curSeasonDic then
    for k, v in pairs(self.curSeasonDic) do
      if v and v.skill_flag == skillType and v:IsLinkedActivityOpen() then
        return v
      end
    end
  end
  if self.allTemplateDic then
    for k, v in pairs(self.allTemplateDic) do
      if v and v.skill_flag == skillType and v:IsLinkedActivityOpen() then
        return v
      end
    end
  end
  return nil
end

function AllianceGovernmentSkillManager:GetMyUsableOfficialSkillType()
  local officialType = self:GetOfficialPosByUid(LuaEntry.Player.uid)
  if officialType == LWAlMemberOffcialType.War_Commander and self:GetUsableConfigBySkillType(AlOfficialSkillType.GoddessMummy) then
    return AlOfficialSkillType.GoddessMummy
  end
  if self:GetUsableConfigBySkillType(AlOfficialSkillType.AresMissile) then
    return AlOfficialSkillType.AresMissile
  end
  return AlOfficialSkillType.None
end

function AllianceGovernmentSkillManager:SetAllianceOfficialArr(allianceOfficialArr)
  self.allianceOfficialArr = allianceOfficialArr
  EventManager:GetInstance():Broadcast(EventId.AllianceMember)
end

function AllianceGovernmentSkillManager:GetMemberInfoByOfficialPos(allianceOfficialType)
  local memberInfo = DataCenter.AllianceMemberDataManager:GetMemberInfoByOfficialPos(allianceOfficialType)
  if memberInfo == nil and self.allianceOfficialArr ~= nil then
    for k, v in ipairs(self.allianceOfficialArr) do
      if v.type == allianceOfficialType then
        memberInfo = v.user
      end
    end
  end
  return memberInfo
end

function AllianceGovernmentSkillManager:GetOfficialPosByUid(uid)
  local officialPos = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(uid)
  if officialPos == nil and self.allianceOfficialArr then
    for k, v in ipairs(self.allianceOfficialArr) do
      if v.user and v.user.uid == uid then
        officialPos = v.type
      end
    end
  end
  return officialPos
end

function AllianceGovernmentSkillManager:SetSkillTimeList(timeList)
  self.skillTimeList = timeList
  EventManager:GetInstance():Broadcast(EventId.UpdateGovernmentSkillCount)
end

function AllianceGovernmentSkillManager:SetUsedSkillStateData(data)
  self.theUsedSkillState = data
  EventManager:GetInstance():Broadcast(EventId.UpdateGovernmentSkillUsedState)
end

function AllianceGovernmentSkillManager:GetUsedSkillStateDataByType(skill_flag)
  if self.theUsedSkillState then
    local now = UITimeManager:GetInstance():GetServerTime()
    for _, v in ipairs(self.theUsedSkillState) do
      if v and v.skillId then
        local cfg = self:GetTemplatesById(v.skillId)
        if cfg and cfg.skill_flag == skill_flag then
          local activity_type_list = cfg.activity_type
          if activity_type_list ~= nil and 0 < #activity_type_list then
            local exist_act = false
            for _, activity_type in ipairs(activity_type_list) do
              local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(activity_type)
              if actList ~= nil and 0 < #actList then
                exist_act = true
                break
              end
            end
            if exist_act then
              if now < v.effectOverTime then
                return v, v.coolOverTime
              else
                return nil, v.coolOverTime
              end
            end
          elseif now < v.effectOverTime then
            return v, v.coolOverTime
          else
            return nil, v.coolOverTime
          end
        end
      end
    end
  end
  return nil, nil
end

function AllianceGovernmentSkillManager:GetAresMissileSkillConfig()
  local cfg_ares_missile_skill
  local skillList = self:GetUsableConfigsByOfficial(LWAlMemberOffcialType.Deputy_Al_Leader)
  if skillList then
    for _, v in ipairs(skillList) do
      if v and v.skill_flag == AlOfficialSkillType.AresMissile then
        cfg_ares_missile_skill = v
      end
    end
  end
  return cfg_ares_missile_skill
end

function AllianceGovernmentSkillManager:GetAresMissileSkillData()
  return self:GetUsedSkillStateDataByType(AlOfficialSkillType.AresMissile)
end

function AllianceGovernmentSkillManager:IsInAresMissileBlackArea(pointIndex)
  local serverData = self:GetAresMissileSkillData()
  if serverData then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now < serverData.effectOverTime and now > serverData.chantOverTime then
      local cfg = self:GetTemplatesById(serverData.skillId)
      local targetPos = serverData.targetPos
      if cfg and targetPos and cfg.effect_scope then
        local effect_scope = toInt(cfg.effect_scope)
        local worldPosCenter = SceneUtils.IndexToTilePos(targetPos, ForceChangeScene.World)
        local worldPosCheck = SceneUtils.IndexToTilePos(pointIndex, ForceChangeScene.World)
        if effect_scope >= math.abs(worldPosCheck.x - worldPosCenter.x) and effect_scope >= math.abs(worldPosCheck.y - worldPosCenter.y) then
          return true
        end
      end
    end
  end
  return false
end

function AllianceGovernmentSkillManager:HandleSkillActivityData(msg)
  if not msg or not msg.skillId then
    return
  end
  local cfg = self:GetTemplatesById(msg.skillId)
  if cfg then
    local skill_flag = cfg.skill_flag
    self.activityData[skill_flag] = msg
    if skill_flag == AlOfficialSkillType.AresMissile then
      EventManager:GetInstance():Broadcast(EventId.UpdateAresMissileState)
    elseif skill_flag == AlOfficialSkillType.GoddessMummy then
      EventManager:GetInstance():Broadcast(EventId.UpdateGoddessMummyState)
    elseif skill_flag == AlOfficialSkillType.GuardianTower then
      EventManager:GetInstance():Broadcast(EventId.UpdateGuardianTowerSkillState)
    end
  end
end

function AllianceGovernmentSkillManager:GetSkillActivityData(skillType)
  return self.activityData[skillType]
end

function AllianceGovernmentSkillManager:GetAresMissileSkillTargetCity()
  local data = self.activityData[AlOfficialSkillType.AresMissile]
  if data and data.furnaceObj then
    return SceneUtils.GetZoneIdByPosId(toInt(data.furnaceObj.pointId), toInt(data.furnaceObj.serverId))
  end
  return 0
end

function AllianceGovernmentSkillManager:GetAresMissileSkillTargetIndex()
  local data = self.activityData[AlOfficialSkillType.AresMissile]
  if data and data.furnaceObj then
    return toInt(data.furnaceObj.pointId)
  end
  return 0
end

function AllianceGovernmentSkillManager:UseSkill(skillType, targetPointId, targetUuid)
  local cfg = self:GetUsableConfigBySkillType(skillType)
  local OffcialType, skillId
  if skillType == AlOfficialSkillType.AresMissile then
    skillId = cfg and cfg.id or 10001
    OffcialType = LWAlMemberOffcialType.Deputy_Al_Leader
    targetUuid = nil
  elseif skillType == AlOfficialSkillType.GoddessMummy then
    skillId = cfg and cfg.id or 10002
    OffcialType = LWAlMemberOffcialType.War_Commander
    targetUuid = nil
  elseif skillType == AlOfficialSkillType.MissileFactory then
    skillId = cfg and cfg.id or 10003
    OffcialType = LWAlMemberOffcialType.Deputy_Al_Leader
    targetUuid = nil
  elseif skillType == AlOfficialSkillType.GuardianTower then
    skillId = cfg and cfg.id or 10005
    OffcialType = LWAlMemberOffcialType.Al_Ambassadoe
  end
  local skillList = DataCenter.AllianceGovernmentSkillManager:GetUsableConfigsByOfficial(OffcialType)
  if skillList then
    for _, v in ipairs(skillList) do
      if v and v.id and v.skill_flag == skillType then
        skillId = v.id
        break
      end
    end
  end
  SFSNetwork.SendMessage(MsgDefines.UseAllianceOfficialSkill, skillId, targetPointId, 0, targetUuid)
end

function AllianceGovernmentSkillManager:GetSkillBigIconBySkillType(type)
  local buildId = BuildingTypes.SEASON_ARES_MISSILE
  if type == AlOfficialSkillType.GoddessMummy then
    buildId = BuildingTypes.GODDESS_MUMMY_TARGET
  elseif type == AlOfficialSkillType.AresMissile and SeasonUtil.GetSeasonType() == SeasonMapType.Darkness then
    buildId = BuildingTypes.SEASON_ARES_MISSILE_S4
  elseif type == AlOfficialSkillType.GuardianTower then
    return "Assets/Main/SeasonRes/S4/Sprites/AllianceBuilding/GuardianTower.png"
  end
  local allianceBuildTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
  if allianceBuildTemplate then
    return allianceBuildTemplate:GetIconPath()
  end
  return "Assets/Main/Sprites/UI/UIAllianceNew/zyf_zhanshenfeidan_jianzhuqietu.png"
end

function AllianceGovernmentSkillManager:CanUseGovernmentSkill(skill_id)
  if not self.initialized then
    self:InitTemplates()
  end
  if self.curSeasonDic then
    for k, v in pairs(self.curSeasonDic) do
      if v and v.id == skill_id and v:IsLinkedActivityOpen() then
        return true
      end
    end
  end
  return false
end

return AllianceGovernmentSkillManager
