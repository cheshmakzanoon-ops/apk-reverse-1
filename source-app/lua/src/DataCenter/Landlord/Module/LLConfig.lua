local _CLASS = {}
local AllianceCityTemplate = require("DataCenter.AllianceCity.AllianceCityTemplate")
local RewardUtil = require("Util.RewardUtil")
local BFTimeCtrlTemplate = require("Scene.Battlefield.Common.BattlefieldTimeCtrlTemplate")

function _CLASS:InitConfig()
end

function _CLASS:DeleteConfig()
  self.baseConfig = nil
  self.guideDic = nil
  self.nineBoxList = nil
  self.rewardDic = nil
  self.newsDic = nil
  self.buffDic = nil
  self.battleTable = nil
  self.scoreDic = nil
  self.cityTypeDic = nil
  self.cityTypeIds = nil
  self.destroyScoreMax = nil
  self.cityDic = nil
  self.cityPidDic = nil
  self.citySubDic = nil
  self.templateServerGroup = nil
  self.timeCtrlDic = nil
end

function _CLASS:InitBaseConfig()
  local actData = self:GetActData()
  local configId = 1001
  if actData ~= nil and actData.configId > 0 then
    configId = actData.configId
  end
  if not table.IsNullOrEmpty(self.baseConfig) and self.curUseConfigId == configId then
    return
  end
  self:RefreshBaseConfigById(configId)
end

function _CLASS:IsBaseConfigInit()
  return not table.IsNullOrEmpty(self.baseConfig)
end

function _CLASS:RefreshBaseConfigById(configId)
  self:DeleteConfig()
  self.curUseConfigId = configId
  local isHasLine = LocalController.instance():hasLine("zonewar_landlord_config", configId)
  if isHasLine then
    local lineData = LocalController.instance():getLine("zonewar_landlord_config", configId)
    self.baseConfig = {
      center_map_city = lineData:getValue("center_map_city"),
      reward_group = lineData:getIntValue("reward_group"),
      box_reward = lineData:getIntValue("box_reward"),
      guide_group = lineData:getIntValue("guide_group"),
      news_group = lineData:getIntValue("news_group"),
      buff_group = lineData:getIntValue("buff_group"),
      battle_table = lineData:getIntValue("battle_table"),
      skill_table = lineData:getValue("skill_table"),
      personal_point_id = lineData:getValue("personal_point_id"),
      personal_point_type = lineData:getValue("personal_point_type"),
      city_type = lineData:getValue("city_type")
    }
  else
    self.baseConfig = {}
  end
end

function _CLASS:GetBaseConfig(key)
  self:InitBaseConfig()
  return self.baseConfig[key]
end

function _CLASS:GetNieBoxConfig()
  if self.nineBoxList == nil then
    local list = {}
    local boxRewardId = self:GetBaseConfig("box_reward")
    local lineData = LocalController:instance():getLine(TableName.HERO_EVENT, boxRewardId)
    if lineData then
      local target = string.string2array_i_oneSep(lineData:getValue("target"), ";")
      local reward = string.string2array_i_oneSep(lineData:getValue("reward"), ";")
      local value = string.string2array_i_oneSep(lineData:getValue("value"), ";")
      local l = #target
      for i = 1, l do
        list[i] = {
          target = target[i],
          reward = reward[i],
          value = value[i]
        }
      end
    else
      Logger.LogError("[LandlordMgr] baseConfig box_reward is null : " .. (boxRewardId or ""))
    end
    self.nineBoxList = list
  end
  return self.nineBoxList
end

function _CLASS:InitRewardData()
  if self.rewardDic ~= nil then
    return
  end
  local reward_group = self:GetBaseConfig("reward_group")
  local dic = {}
  LocalController.instance():visitTable("zonewar_landlord_reward", function(xmlId, lineData)
    local group = lineData:getIntValue("group")
    if group ~= reward_group then
      return
    end
    local type = lineData:getIntValue("type")
    local typeDic = dic[type]
    if typeDic == nil then
      typeDic = {}
      dic[type] = typeDic
    end
    local camp = lineData:getIntValue("camp")
    local list = typeDic[camp]
    if list == nil then
      list = {}
      typeDic[camp] = list
    end
    table.insert(list, {
      id = xmlId,
      type = type,
      camp = camp,
      para = lineData:getValue("para"),
      reward = lineData:getIntValue("reward")
    })
  end)
  self.rewardDic = dic
end

function _CLASS:GetReward(type, camp)
  self:InitRewardData()
  local dic = self.rewardDic ~= nil and self.rewardDic[type] or {}
  return dic[camp] or {}
end

function _CLASS:InitGuideData()
  if self.guideDic ~= nil then
    return
  end
  local guide_group = self:GetBaseConfig("guide_group")
  local dic = {}
  LocalController.instance():visitTable("zonewar_landlord_guide", function(xmlId, lineData)
    local group_id = lineData:getIntValue("group_id")
    if group_id ~= guide_group then
      return
    end
    local type = lineData:getIntValue("type")
    local list = dic[type]
    if list == nil then
      list = {}
      dic[type] = list
    end
    table.insert(list, {
      id = xmlId,
      type = type,
      subtype = lineData:getIntValue("subtype"),
      sequence = lineData:getIntValue("sequence"),
      tittle = lineData:getValue("tittle"),
      pic = lineData:getValue("pic"),
      desc = lineData:getValue("desc"),
      button = lineData:getValue("button"),
      jump = lineData:getIntValue("jump")
    })
  end)
  
  local function sortFunc(a, b)
    return a.sequence < b.sequence
  end
  
  for _, v in pairs(dic) do
    table.sort(v, sortFunc)
  end
  self.guideDic = dic
end

function _CLASS:GetGuide(type)
  self:InitGuideData()
  return self.guideDic ~= nil and self.guideDic[type] or {}
end

function _CLASS:InitNews()
  if self.newsDic ~= nil then
    return
  end
  local news_group = self:GetBaseConfig("news_group")
  local dic = {}
  LocalController.instance():visitTable("zonewar_landlord_news", function(xmlId, lineData)
    local group = lineData:getIntValue("group")
    if group ~= news_group then
      return
    end
    local phase = lineData:getIntValue("phase")
    local list = dic[phase]
    if list == nil then
      list = {}
      dic[phase] = list
    end
    table.insert(list, {
      id = xmlId,
      phase = phase,
      pic = lineData:getValue("pic"),
      dialog = lineData:getValue("dialog"),
      dialog_title = lineData:getValue("dialog_title"),
      breaking_news = lineData:getValue("breaking_news")
    })
  end)
  
  local function sortFunc(a, b)
    return a.id < b.id
  end
  
  for _, v in pairs(dic) do
    table.sort(v, sortFunc)
  end
  self.newsDic = dic
end

function _CLASS:GetNews(phase)
  self:InitNews()
  return self.newsDic ~= nil and self.newsDic[phase] or {}
end

function _CLASS:InitBuff()
  if self.buffDic ~= nil then
    return
  end
  local buff_group = self:GetBaseConfig("buff_group")
  local dic = {}
  LocalController.instance():visitTable("zonewar_landlord_buff", function(xmlId, lineData)
    local group = lineData:getIntValue("group")
    if group ~= buff_group then
      return
    end
    dic[xmlId] = {
      id = xmlId,
      type = lineData:getIntValue("type"),
      condition = lineData:getValue("condition"),
      condition_desc = lineData:getValue("condition_desc"),
      status = lineData:getIntValue("status"),
      sequence = lineData:getIntValue("sequence")
    }
  end)
  self.buffDic = dic
end

function _CLASS:GetBuff(id)
  self:InitBuff()
  return self.buffDic[id]
end

function _CLASS:GetBuffIcon(id)
  local buff = self:GetBuff(id)
  if buff then
    if string.IsNullOrEmpty(buff.icon) then
      buff.icon = LocalController:instance():getValue(TableName.StatusTab, buff.status, "icon")
    end
    return buff.icon
  end
end

function _CLASS:GetBuffDesc(id)
  local buff = self:GetBuff(id)
  if buff then
    if string.IsNullOrEmpty(buff.desc) then
      buff.desc = self:GetStatusDesc(buff.status)
    end
    return buff.desc
  end
end

function _CLASS:GetStatusDesc(id)
  local statusTemplate = LocalController:instance():getLine(TableName.StatusTab, id)
  if statusTemplate and not string.IsNullOrEmpty(statusTemplate.description) then
    local keyDesc = statusTemplate ~= nil and statusTemplate:getValue("description") or ""
    local effVal = statusTemplate ~= nil and statusTemplate:getValue("effect_num") or ""
    local list = {}
    for segment in string.gmatch(effVal, "([^|]+)") do
      table.insert(list, string.format("%.1f", (tonumber(segment) or 0) * 100))
    end
    return CS.GameEntry.Localization:GetString(keyDesc, table.unpack(list))
  end
  return ""
end

local function SortBuff(a, b)
  if a.active ~= b.active then
    return a.active
  end
  if a.sequence ~= b.sequence then
    return a.sequence < b.sequence
  end
  return a.id < b.id
end

function _CLASS:GetBuffsByType(camp)
  self:InitBuff()
  local ret = {}
  for id, v in pairs(self.buffDic) do
    if v.type == camp then
      v.active = self:CheckBuffActive(id, camp)
      table.insert(ret, v)
    end
  end
  table.sort(ret, SortBuff)
  return ret
end

function _CLASS:InitBattleTable()
  if self.battleTable ~= nil then
    return
  end
  local battle_table = self:GetBaseConfig("battle_table")
  local dic = {}
  LocalController.instance():visitTable("zonewar_landlord_battle_table", function(xmlId, lineData)
    local group = lineData:getIntValue("group")
    if group ~= battle_table then
      return
    end
    local template = {
      id = xmlId,
      city_id = lineData:getIntValue("city_id"),
      icon = lineData:getValue("icon"),
      destroy_icon = lineData:getValue("destroy_icon"),
      name = lineData:getValue("name"),
      position = lineData:getValue("position"),
      show_hp = lineData:getIntValue("show_hp")
    }
    dic[xmlId] = template
  end)
  self.battleTable = dic
end

function _CLASS:GetBattleTable()
  self:InitBattleTable()
  return self.battleTable
end

function _CLASS:InitScoreTypes()
  if self.scoreDic ~= nil then
    return
  end
  local pointTypeConfig = self:GetBaseConfig("personal_point_type")
  local pointIdConfig = self:GetBaseConfig("personal_point_id")
  local dic = {}
  LocalController.instance():visitTable(pointTypeConfig, function(xmlId, lineData)
    local show_id = lineData:getValue("show_id")
    local ids = {}
    for _, id in ipairs(show_id) do
      local idLine = LocalController.instance():getLine(pointIdConfig, id)
      table.insert(ids, {
        id = id,
        name = idLine:getValue("name"),
        icon = idLine:getValue("icon"),
        score_detail = idLine:getValue("score_detail")
      })
    end
    dic[xmlId] = {
      id = xmlId,
      name = lineData:getValue("name"),
      icon = lineData:getValue("icon"),
      active_camp = lineData:getValue("active_camp"),
      ids = ids
    }
  end)
  self.scoreDic = dic
end

function _CLASS:GetScoreTypes(camp)
  self:InitScoreTypes()
  local list = {}
  for _, v in pairs(self.scoreDic) do
    if table.hasvalue(v.active_camp, camp) then
      table.insert(list, v)
    end
  end
  return list
end

function _CLASS:InitScoreShow()
  if self.scoreShowList ~= nil then
    return
  end
  local list = {}
  LocalController.instance():visitTable("zonewar_landlord_score_show_s5", function(xmlId, lineData)
    local score_detail = lineData:getValue("score_detail")
    local scoreMin, scoreMax = 0, 0
    for _, v in ipairs(score_detail) do
      local scoreCfg = LocalController:instance():getLine(TableName.Score, v)
      if scoreCfg ~= nil then
        local score = scoreCfg:getIntValue("points")
        if scoreMin == 0 or scoreMin > score then
          scoreMin = score
        end
        if scoreMax == 0 or scoreMax < score then
          scoreMax = score
        end
      end
    end
    local info = {
      id = xmlId,
      name = lineData:getValue("name"),
      icon = lineData:getValue("icon"),
      scoreMin = scoreMin,
      scoreMax = scoreMax,
      score_detail = score_detail
    }
    table.insert(list, info)
  end)
  table.sort(list, function(a, b)
    return a.id < b.id
  end)
  self.scoreShowList = list
end

function _CLASS:GetScoreShowList()
  self:InitScoreShow()
  return self.scoreShowList or {}
end

function _CLASS:InitCityTypes()
  if self.cityTypeDic ~= nil then
    return
  end
  local cityTypeConfig = self:GetBaseConfig("city_type")
  local dic = {}
  local list = {}
  LocalController.instance():visitTable(cityTypeConfig, function(xmlId, lineData)
    dic[xmlId] = {
      id = xmlId,
      name = lineData:getValue("name"),
      defend_reward = lineData:getIntValue("defend_reward"),
      defend_reward_unlock_week = lineData:getIntValue("defend_reward_unlock_week"),
      destroy_reward = lineData:getIntValue("destroy_reward"),
      desc = lineData:getValue("desc"),
      city_id = lineData:getIntValue("city_id"),
      belong_building = lineData:getValue("belong_building")
    }
    table.insert(list, xmlId)
  end)
  self.cityTypeDic = dic
  self.cityTypeIds = list
end

function _CLASS:GetCityTypeConfig(id)
  self:InitCityTypes()
  return self.cityTypeDic[id]
end

function _CLASS:GetCityTypeIdList()
  self:InitCityTypes()
  table.sort(self.cityTypeIds, function(a, b)
    local cfgA = self:GetCityTypeConfig(a)
    local cfgB = self:GetCityTypeConfig(b)
    if cfgA.defend_reward_unlock_week ~= cfgB.defend_reward_unlock_week then
      return cfgA.defend_reward_unlock_week < cfgB.defend_reward_unlock_week
    end
    return a < b
  end)
  return self.cityTypeIds
end

function _CLASS:GetCityTypeRewards(cityType, group)
  local dic = self:GetCityTypeConfig(cityType)
  local checkGroup = group or self:GetMyGroup()
  local rewardId
  if dic ~= nil then
    rewardId = checkGroup == LLConst.LandLordGroup.LORD and dic.defend_reward or dic.destroy_reward
  end
  local rewards = RewardUtil.GetRewardsById(rewardId)
  return rewards, dic
end

function _CLASS:InitCityData()
  if not table.IsNullOrEmpty(self.cityDic) then
    return
  end
  local center_map_city = self:GetBaseConfig("center_map_city")
  local dic = {}
  local subDic = {}
  local pIdDic = {}
  local destroyScoreMax = {}
  LocalController.instance():visitTable(center_map_city, function(xmlId, lineData)
    local city = AllianceCityTemplate.New()
    city:InitData(lineData)
    local unlockWeek = city.unlock_week or 0
    if 0 < unlockWeek then
      local cur = destroyScoreMax[unlockWeek] or 0
      destroyScoreMax[unlockWeek] = cur + (city.ruins_points or 0)
    end
    dic[xmlId] = city
    pIdDic[city:GetPointId()] = city
    local belong_city_id = city.belong_city_id or 0
    if belong_city_id ~= 0 then
      local list = subDic[belong_city_id] or {}
      table.insert(list, xmlId)
      subDic[belong_city_id] = list
    end
  end)
  self.destroyScoreMax = destroyScoreMax
  self.cityDic = dic
  self.citySubDic = subDic
  self.cityPidDic = pIdDic
end

function _CLASS:GetCityTemplate(cityId)
  self:InitCityData()
  return self.cityDic[cityId]
end

function _CLASS:GetCityTemplateByPid(pid)
  self:InitCityData()
  return self.cityPidDic[pid]
end

function _CLASS:GetCityDestroyScoreMax(week)
  self:InitCityData()
  if self.destroyScoreMax then
    local s = 0
    local c = week or math.huge
    for i, v in pairs(self.destroyScoreMax) do
      if i <= c then
        s = s + v
      end
    end
    return s
  end
  return 1
end

function _CLASS:GetCityTemplateTableName()
  self:InitCityData()
  return self.baseConfig and self.baseConfig.center_map_city or ""
end

function _CLASS:GetSubCities(cityId)
  self:InitCityData()
  return self.citySubDic[cityId]
end

function _CLASS:GetCityTypeTemplateTableName()
  self:InitCityData()
  return self.baseConfig and self.baseConfig.city_type or ""
end

function _CLASS:InitTemplateServerGroupOpenTime()
  local serverGroup = {}
  local myInsert = table.insert
  local mySplit = string.split
  local tbName = "zonewar_landlord_open"
  local KEY_PATTERN = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  LocalController:instance():visitTable(tbName, function(id, lineData)
    local season = lineData:getIntValue("season")
    local start_time = lineData:getValue("start_time")
    local end_time = lineData:getValue("end_time")
    local extInfo = string.format("%s-%s", tbName, id)
    local sTime, eTime = 0, 0
    if not string.IsNullOrEmpty(start_time) then
      sTime = RaceEntranceUtil.TransformTime(start_time, KEY_PATTERN, extInfo)
    end
    if not string.IsNullOrEmpty(end_time) then
      eTime = RaceEntranceUtil.TransformTime(end_time, KEY_PATTERN, extInfo)
    end
    local idList = mySplit(lineData:getValue("server_list"), ";")
    local sDic = {}
    for _, v in ipairs(idList) do
      sDic[v] = true
    end
    myInsert(serverGroup, {
      id = id,
      season = season,
      sTime = sTime,
      eTime = eTime,
      sDic = sDic
    })
  end)
  self.templateServerGroup = serverGroup
end

function _CLASS:GetCurTemplateServerGroupOpenTime(curSeason, serverId)
  if self.templateServerGroup == nil then
    self:InitTemplateServerGroupOpenTime()
  end
  local curSeconds = UITimeManager:GetInstance():GetServerSeconds()
  local sId = tostring(serverId or LuaEntry.Player:GetSourceServerId())
  for _, v in ipairs(self.templateServerGroup) do
    if v.season == curSeason and v.sDic[sId] == true and curSeconds >= v.sTime and curSeconds < v.eTime then
      return v.sTime, v.eTime
    end
  end
  return 0, 0
end

function _CLASS:GetBattleTimeCtrlDic()
  if self.timeCtrlDic == nil then
    local templateDic = {}
    LocalController:instance():visitTable("battlefield_time_controller_s5", function(id, line)
      local template = BFTimeCtrlTemplate.New()
      template:InitData(line)
      if template.id ~= nil and template.id ~= 0 then
        templateDic[template.id] = template
      end
    end)
    self.timeCtrlDic = templateDic
  end
  return self.timeCtrlDic
end

return _CLASS
