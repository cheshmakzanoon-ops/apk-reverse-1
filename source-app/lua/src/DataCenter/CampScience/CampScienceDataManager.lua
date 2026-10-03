local CampSelfScienceInfo = require("DataCenter.CampScience.CampSelfScienceInfo")
local CampScienceBuffInfo = require("DataCenter.CampScience.CampScienceBuffInfo")
local CampScienceDataManager = BaseClass("CampScienceDataManager", CEventable)

function CampScienceDataManager:__init()
  self.scienceList = nil
  self.selfCampScienceInfo = CampSelfScienceInfo.New()
  self.campScienceBuffInfo = nil
  self.scienceEffectDic = {}
  self.recommendScienceId = nil
  self.firstForceAlliance = nil
  self:RegisterEvent(EventId.MoveCitySuccess, self.UpdateCampScienceEffect)
  self:RegisterEvent(EventId.LWSeasonFactionInfoUpdate, self.InitData)
  self:RegisterEvent(EventId.SetMainWorldPointId, self.UpdateCampScienceEffect)
end

function CampScienceDataManager:__delete()
  self.scienceList = nil
  self.selfCampScienceInfo = nil
  self.campScienceBuffInfo = nil
  self.scienceEffectDic = nil
  self.recommendScienceId = nil
  self.firstForceAlliance = nil
  self:UnregisterEvent(EventId.MoveCitySuccess, self.MoveCitySuccessHandle)
  self:UnregisterEvent(EventId.LWSeasonFactionInfoUpdate, self.InitData)
  self:UnregisterEvent(EventId.SetMainWorldPointId, self.UpdateCampScienceEffect)
end

function CampScienceDataManager:InitData()
  if self:IsOpenCampScience() then
    self:InitAllScience()
  end
end

function CampScienceDataManager:InitActivity(data)
  if self:IsOpenCampScience() then
    self:InitAllScience()
  end
end

function CampScienceDataManager:IsOpenCampScience()
  local data = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.CampScience.Type)
  if data == nil or table.count(data) == 0 then
    return false
  end
  local inSeason = SeasonUtil.IsInSeason()
  if inSeason then
    local campId = DataCenter.SeasonFactionWarDataManager.myCampId
    local campScienceGroupId = self:GetCampScienceGroupId()
    if string.IsNullOrEmpty(campScienceGroupId) or campId == nil or campId == 0 then
      return false
    end
    return true, campScienceGroupId, campId
  end
  return false
end

function CampScienceDataManager:InitAllScience()
  if self.scienceList ~= nil then
    return
  end
  self.scienceList = self.scienceList or {}
  local scienceList = self:GetCampScienceRowList()
  for _, listData in pairs(scienceList) do
    for _, data in pairs(listData) do
      local campData = CampScienceData.New()
      campData:ParseConfig(data)
      self.scienceList[campData.scienceId] = campData
    end
  end
  SFSNetwork.SendMessage(MsgDefines.CampScienceView)
end

function CampScienceDataManager:GetCampScienceGroupId()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local info = SeasonUtil.GetSeasonInfo(mySourceServerId)
  if info then
    local seasonConfig = info:GetCurrentSeasonConfig()
    if seasonConfig then
      return seasonConfig.camp_science_group
    end
  end
end

function CampScienceDataManager:GetCampScienceGroupTemplate()
  local groupId = self:GetCampScienceGroupId()
  if groupId then
    return DataCenter.CampScienceTemplateManager:GetCampScienceGroup(groupId)
  end
end

function CampScienceDataManager:GetCampScienceTabList()
  local isOpen, curCampScienceGroupId, campId = self:IsOpenCampScience()
  if not isOpen then
    return {}
  end
  local campScienceGroupConfig = DataCenter.CampScienceTemplateManager:GetCampScienceGroup(curCampScienceGroupId)
  if not campScienceGroupConfig then
    Logger.LogError("lw_camp_science_group config not id" .. tostring(curCampScienceGroupId))
    return {}
  end
  return DataCenter.CampScienceTemplateManager:GetCampScienceTabTemplate(campScienceGroupConfig.lw_camp_science_tab, campId)
end

function CampScienceDataManager:GetCampScienceRowList()
  local showList = {}
  local rowList = self:GetCampScienceTabList()
  if rowList ~= nil then
    table.walk(rowList, function(k, v)
      local position = v.position
      local position_vec = string.split_ss_array(position, ";")
      if #position_vec == 2 then
        local column = tonumber(position_vec[1])
        if showList[column] == nil then
          showList[column] = {}
        end
        table.insert(showList[column], v)
      end
    end)
  end
  return showList
end

function CampScienceDataManager:GetOneCampScienceById(id)
  return self.scienceList[id]
end

function CampScienceDataManager:RepCampScienceServer(message, notNeedEvent)
  if message.userCampScienceInfo ~= nil then
    self.selfCampScienceInfo:ParseServer(message.userCampScienceInfo)
    EventManager:GetInstance():Broadcast(EventId.UpdateSelfCampScienceInfo)
  end
  if message.campScienceArr ~= nil then
    table.walk(message.campScienceArr, function(k, v)
      local scienceId = v.scienceId
      if 0 < scienceId then
        local campScienceCell = self:GetOneCampScienceById(scienceId)
        if campScienceCell then
          campScienceCell:ParseData(v)
        end
      end
    end)
    if not notNeedEvent then
      EventManager:GetInstance():Broadcast(EventId.UpdateCampScienceList)
    end
  end
  if message.recommendScienceId then
    self.recommendScienceId = message.recommendScienceId
    EventManager:GetInstance():Broadcast(EventId.UpdateCampRecommendScience, self.recommendScienceId)
  end
  if message.firstForceAlliance then
    self.firstForceAlliance = message.firstForceAlliance
  end
  self:UpdateCampScienceEffect()
  if self:IsOpenCampBuff() then
    SFSNetwork.SendMessage(MsgDefines.CampBuffView)
  end
  if self:IsOpenCampProduce() then
    DataCenter.CampProduceDataManager:InitData()
  end
end

function CampScienceDataManager:UpdateOneCampScience(message)
  if message.scienceId ~= nil then
    local id = message.scienceId
    if self.scienceList[id] ~= nil then
      self.scienceList[id]:ParseData(message)
      self:UpdateCampScienceEffect()
    end
    EventManager:GetInstance():Broadcast(EventId.UpdateCampScienceList)
  end
end

function CampScienceDataManager:UpdateCampScienceEffect()
  self.scienceEffectDic = {}
  if self.scienceList ~= nil then
    for _, oneData in pairs(self.scienceList) do
      local effectKey = oneData.para1
      if not string.IsNullOrEmpty(effectKey) then
        self:AddScienceEffectDic(effectKey, oneData.para2)
      end
      effectKey = oneData.camp_map_effect
      if not string.IsNullOrEmpty(effectKey) and self:IsInCampArena() then
        self:AddScienceEffectDic(effectKey, oneData.camp_map_effect_num)
      end
    end
  end
  if self.campScienceBuffInfo ~= nil then
    for _, oneData in pairs(self.campScienceBuffInfo) do
      if oneData.config ~= nil then
        local effectKey = oneData.config.para1
        if not string.IsNullOrEmpty(effectKey) then
          self:AddScienceEffectDic(effectKey, oneData.config.para2)
        end
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshCampScienceEffects)
end

function CampScienceDataManager:AddScienceEffectDic(effectKey, effectValue)
  local effectKey_arr = string.split_ii_array(effectKey, ";")
  local effectValue_arr = string.split_ss_array(effectValue, ";")
  for i = 1, table.count(effectKey_arr) do
    local eK = effectKey_arr[i]
    local eV = 0
    if effectValue_arr[i] ~= nil then
      eV = tonumber(effectValue_arr[i])
    end
    if self.scienceEffectDic[eK] ~= nil then
      eV = self.scienceEffectDic[eK] + eV
    end
    self.scienceEffectDic[eK] = eV
  end
end

function CampScienceDataManager:GetCampScienceEffectById(effect)
  if effect == EffectDefine.LW_71000 and BattleFieldUtil.InBattleField() then
    return 0
  end
  local effectValue = 0
  if self.scienceEffectDic[effect] ~= nil then
    effectValue = self.scienceEffectDic[effect]
  end
  return effectValue
end

function CampScienceDataManager:GetSelfCampScienceInfo()
  return self.selfCampScienceInfo
end

function CampScienceDataManager:GetAllLockScienceInfoToDes()
  local scienceDesList = {}
  for k, v in pairs(self.scienceList) do
    scienceDesList[v.buff_type] = scienceDesList[v.buff_type] or {}
    if v.curLevel > 0 then
      table.insert(scienceDesList[v.buff_type], v)
    end
  end
  return scienceDesList
end

function CampScienceDataManager:GetSeasonCampBuffs(campId)
  local isOpen, curCampScienceGroupId, _ = self:IsOpenCampScience()
  if not isOpen then
    return {}
  end
  local campScienceGroupConfig = DataCenter.CampScienceTemplateManager:GetCampScienceGroup(curCampScienceGroupId)
  if not campScienceGroupConfig then
    Logger.LogError("lw_camp_science_group config not id" .. tostring(curCampScienceGroupId))
    return {}
  end
  return DataCenter.CampScienceTemplateManager:GetCampBuffTemplatesByCampID(campScienceGroupConfig.lw_camp_science_tab, campId)
end

function CampScienceDataManager:GetSeasonCampBuffsByCampAndType(campId, type)
  local campBuffs = self:GetSeasonCampBuffs(campId)
  local buffInfo = {}
  if campBuffs ~= nil then
    for k, v in pairs(campBuffs) do
      if tonumber(v.type) == tonumber(type) then
        table.insert(buffInfo, v)
      end
    end
  end
  return buffInfo
end

function CampScienceDataManager:GetCampScienceBuffByType(type)
  if self.campScienceBuffInfo then
    return self.campScienceBuffInfo[type]
  end
end

function CampScienceDataManager:GetAllCampScienceBuff()
  if not SeasonUtil.IsInSameGroup(LuaEntry.Player:GetSelfServerId()) then
    return {}
  end
  return self.campScienceBuffInfo or {}
end

function CampScienceDataManager:GetCampScienceBuffData()
  local sort_buff = {}
  local campScienceBuff = DataCenter.CampScienceDataManager:GetAllCampScienceBuff()
  if campScienceBuff and table.count(campScienceBuff) > 0 then
    for k, v in pairs(campScienceBuff) do
      local buffViewData = {}
      local config = v.config
      buffViewData.order = toInt(config.type) + 1
      buffViewData.icon = config.icon
      buffViewData.name = CS.GameEntry.Localization:GetString(config.name, config.name_cfg)
      buffViewData.type = config.type
      local strArray = string.split_ss_array(config.description_cfg, "|")
      buffViewData.desc = CS.GameEntry.Localization:GetString(v.config.description, table.unpack(strArray))
      table.insert(sort_buff, buffViewData)
    end
    table.sort(sort_buff, function(a, b)
      return a.order < b.order
    end)
  end
  return sort_buff
end

function CampScienceDataManager:GetCampScienceBuffByCampId(campId, occScore, destroyScore)
  local showData = {}
  local score2ITypes = {
    [1] = -1,
    [2] = -1
  }
  local isOpen, curCampScienceGroupId, _ = self:IsOpenCampScience()
  if not isOpen then
    return showData
  end
  local campScienceGroupConfig = DataCenter.CampScienceTemplateManager:GetCampScienceGroup(curCampScienceGroupId)
  if not campScienceGroupConfig then
    return showData
  end
  LocalController:instance():visitTable(TableName.SEASON_CAMP_BUFF, function(id, lineData)
    if tonumber(lineData.camp) == campId and campScienceGroupConfig.lw_camp_science_tab == lineData.season_group then
      local type = tonumber(lineData.type)
      local maxScore = score2ITypes[type]
      local condition = tonumber(lineData.condition)
      if type == 1 then
        if condition <= occScore and maxScore < condition then
          local campBuff = showData[type]
          if campBuff == nil then
            campBuff = CampScienceBuffInfo.New()
            showData[type] = campBuff
          end
          campBuff:ParseServer({
            type = type,
            buffId = id,
            value = occScore
          })
          campBuff.campId = campId
          score2ITypes[type] = condition
        end
      elseif condition <= destroyScore and maxScore < condition then
        local campBuff = showData[type]
        if campBuff == nil then
          campBuff = CampScienceBuffInfo.New()
          showData[type] = campBuff
        end
        campBuff:ParseServer({
          type = type,
          buffId = id,
          value = destroyScore
        })
        campBuff.campId = campId
        score2ITypes[type] = condition
      end
    end
  end)
  return showData
end

function CampScienceDataManager:RepCampBuffServer(message)
  local campBuffAttr = message.campBuffTypeArr
  self.campScienceBuffInfo = {}
  if campBuffAttr ~= nil then
    for _, v in pairs(campBuffAttr) do
      local campBuff = self:GetCampScienceBuffByType(v.type)
      if campBuff == nil then
        campBuff = CampScienceBuffInfo.New()
        self.campScienceBuffInfo[v.type] = campBuff
      end
      campBuff:ParseServer(v)
    end
  end
  self:UpdateCampScienceEffect()
end

function CampScienceDataManager:UpdateOneBuffServer(message)
  self.campScienceBuffInfo = self.campScienceBuffInfo or {}
  local campBuffTypeInfo = message.campBuffTypeInfo
  local campBuff = self:GetCampScienceBuffByType(campBuffTypeInfo.type)
  if campBuff == nil then
    campBuff = CampScienceBuffInfo.New()
    self.campScienceBuffInfo[campBuffTypeInfo.type] = campBuff
  end
  campBuff:ParseServer(campBuffTypeInfo)
  self:UpdateCampScienceEffect()
end

function CampScienceDataManager:ReqRecommendMessage(message)
  if message.recommendScienceId then
    self.recommendScienceId = message.recommendScienceId
    EventManager:GetInstance():Broadcast(EventId.UpdateCampRecommendScience, self.recommendScienceId)
  end
end

function CampScienceDataManager:GetRecommendScienceId()
  return self.recommendScienceId
end

function CampScienceDataManager:IsFirstCampAllianceR5()
  local r5 = DataCenter.AllianceBaseDataManager:IsR5()
  if r5 then
    local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceData == nil then
      return false
    end
    return self.firstForceAlliance == allianceData.uid
  end
  return false
end

function CampScienceDataManager:IsInCampArena()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local cityId = SceneUtils.GetZoneIdByPosId(LuaEntry.Player:GetMainWorldPos(), loginServerId)
  local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId, loginServerId)
  if cityInfo ~= nil then
    if cityInfo.occupyServerId ~= nil and cityInfo.occupyServerId ~= 0 then
      return DataCenter.WorldAllianceCityDataManager:IsMyCamp(loginServerId, cityId)
    end
    if cityInfo.destroyServerId ~= nil and cityInfo.destroyServerId ~= 0 then
      return DataCenter.WorldAllianceCityDataManager:IsDestroyByMyCamp(loginServerId, cityId)
    end
  end
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  if sourceServerId == loginServerId then
    return true
  end
  return false
end

function CampScienceDataManager:IsOpenCampProduce()
  return self:IsOpenByEffectId(EffectDefine.CAMP_SCIENCE_PRODUCE_FUNCTION)
end

function CampScienceDataManager:IsOpenCampDestroy()
  return self:IsOpenByEffectId(EffectDefine.CAMP_SCIENCE_DESTROY_FUNCTION)
end

function CampScienceDataManager:IsOpenCampBuff()
  return self:IsOpenByEffectId(EffectDefine.CAMP_SCIENCE_BUFF_FUNCTION)
end

function CampScienceDataManager:IsOpenCampScienceSkin()
  return self:IsOpenByEffectId(EffectDefine.CAMP_SCIENCE_SKIN_FUNCTION)
end

function CampScienceDataManager:IsOpenCampScienceSkill()
  return self:IsOpenByEffectId(EffectDefine.CAMP_SCIENCE_SKILL_FUNCTION)
end

function CampScienceDataManager:IsOpenMakeAllianceCampScience()
  return self:IsOpenByEffectId(EffectDefine.CAMP_SCIENCE_ALLIANCE_FUNCTION)
end

function CampScienceDataManager:IsOpenByEffectId(effectId)
  if not self:IsOpenCampScience() then
    return false
  end
  local effectValue = LuaEntry.Effect:GetGameEffect(effectId)
  return 0 < effectValue
end

function CampScienceDataManager:GetRedPointNum()
  if not DataCenter.CampScienceDataManager:IsOpenCampScience() then
    return 0
  end
  local canShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.CampScienceDayRed)
  if canShow then
    local max = self.selfCampScienceInfo:IsMaxDonateCount()
    if max then
      return 1
    end
  end
  return 0
end

function CampScienceDataManager:ClearRed()
  DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.CampScienceDayRed, false)
  EventManager:GetInstance():Broadcast(EventId.CampScienceRefreshRed)
end

return CampScienceDataManager
