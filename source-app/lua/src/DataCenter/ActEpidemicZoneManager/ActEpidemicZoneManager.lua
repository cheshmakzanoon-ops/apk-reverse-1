local ActEpidemicZoneManager = BaseClass("ActEpidemicZoneManager", BattlefieldManagerBase)
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local ActEpidemicZoneActivityInfo = require("DataCenter.ActEpidemicZoneManager.ActEpidemicZoneActivityInfo")
local ActEpidemicZoneBattleInfo = require("DataCenter.ActEpidemicZoneManager.ActEpidemicZoneBattleInfo")
local ActEpidemicZoneActivityPlayerList = require("DataCenter.ActEpidemicZoneManager.ActEpidemicZoneActivityPlayerList")
local ActEpidemicZoneActivityBattleHistory = require("DataCenter.ActEpidemicZoneManager.ActEpidemicZoneActivityBattleHistory")
local ActEpidemicZoneActivityMyScoreRankInfoInfo = require("DataCenter.ActEpidemicZoneManager.ActEpidemicZoneActivityMyScoreRankInfo")

function ActEpidemicZoneManager:OnInit()
  self.bfType = BattleFieldType.EpidemicZone
  self.battleInfo = ActEpidemicZoneBattleInfo.New()
  self:ResetData()
end

function ActEpidemicZoneManager:OnDelete()
  self:ResetData()
end

function ActEpidemicZoneManager:ResetData()
  self.actInfo = nil
  self.playerList = nil
  self.battleInfo:ResetData()
  self.templateSkills = nil
  self.templateBuffs = nil
  self.templatePingList = nil
  self.templateScoreTypes = nil
  self.rankRewardCache = nil
  self.winnerRewardCache = nil
  self.lordSkillPassive = nil
  self.lordSkillArbiter = nil
  self.battleMemberLimit = nil
  self.battleTimeRange = nil
  self.scoreRewardsCache = nil
  self.battleHistory = nil
  self._useSkillPointId = nil
  self.beAttackedBySkills = {}
end

function ActEpidemicZoneManager:GetActInfo()
  return self.actInfo
end

function ActEpidemicZoneManager:GetBGM(bUp)
  local soundCheckTime = -1
  if bUp == nil then
    local detailInfo = BattleFieldUtil.GetDetailInfoByCfgId(10401)
    if detailInfo and detailInfo.State == EpidemicBuildState.Normal then
      local curSec = UITimeManager:GetInstance():GetServerSeconds()
      if curSec < detailInfo.OpenTime then
        soundCheckTime = detailInfo.OpenTime
      else
        bUp = true
      end
    end
  end
  local bgmId
  local skillActiveEndTime = self:GetSkillActiveEndTime()
  if 0 < skillActiveEndTime then
    bgmId = 93007
  else
    bgmId = bUp and 93006 or 93005
  end
  return bgmId, soundCheckTime
end

function ActEpidemicZoneManager:UpdateAreaMaterial(mapHandle)
  if mapHandle == nil then
    return
  end
  local role = self:GetCurRole()
  local bLord = role == EpidemicZoneRole.Lord
  for i = 0, 3 do
    local colorIdx = (bLord and i < 2 or not bLord and 2 <= i) and 1 or 0
    local renderer = mapHandle:GetRenderer(i)
    if IsNotNull(renderer) then
      renderer.sharedMaterial = mapHandle:GetMaterial(colorIdx)
    end
  end
end

function ActEpidemicZoneManager:GetCfgValue(key, season)
  return BattleFieldUtil.GetBattleFieldCfgValue(BattleFieldType.EpidemicZone, key, season)
end

function ActEpidemicZoneManager:InitSkills()
  self.lordSkillPassive = -1
  self.lordSkillArbiter = -1
  local dic = {}
  local mySplit = string.split
  local mySplitI = string.string2array_i_oneSep
  local mySplitNum = string.string2array_num_oneSep
  local myInsert = table.insert
  local tbName = self:GetCfgValue(BattleFieldTableKey.P_SKILL)
  LocalController.instance():visitTable(tbName, function(id, lineData)
    local data = {}
    data.id = id
    data.season_days = lineData:getIntValue("season_days")
    local _type = lineData:getValue("type")
    data.types = mySplitI(_type, ",")
    data.tag = lineData:getIntValue("tag")
    data.name = lineData:getValue("name")
    data.desc = lineData:getValue("desc")
    data.descArray = mySplit(data.desc, "|")
    data.model = lineData:getValue("model")
    data.brief = lineData:getValue("brief")
    data.icon = string.format(LoadPath.LWBattleFieldEpidemicPath, lineData:getValue("icon"))
    data.map_icon = string.format(LoadPath.LWBattleFieldEpidemicPath, lineData:getValue("map_icon"))
    data.example = lineData:getValue("example")
    data.example_preview = lineData:getValue("example_preview")
    data.points_required = lineData:getIntValue("points_required")
    data.active_time = lineData:getIntValue("activite_time")
    data.skill_CD = lineData:getIntValue("skill_CD")
    data.sound_born = lineData:getIntValue("battlefield_skill_sound")
    data.sound_attack = lineData:getIntValue("battlefield_attack_sound")
    data.sound_hit = lineData:getIntValue("battlefield_hit_sound")
    data.lordRandomPassive = _type == "2"
    local iType = toInt(_type)
    data.iType = iType
    if id == EpidemicSkillId.Quake then
      data.range = lineData:getIntValue("para2")
      data.damageHole = lineData:getIntValue("para6")
      data.damageSolider = lineData:getIntValue("para7")
      data.effPartTime = lineData:getIntValue("para5")
      data.damageHoleBorn = lineData:getIntValue("para3")
    elseif id == EpidemicSkillId.Hospital then
      data.range = lineData:getIntValue("para3")
      data.cureHole = lineData:getIntValue("para5")
      data.cureSolider = lineData:getIntValue("para4")
      data.effPartTime = lineData:getIntValue("para2")
    elseif id == EpidemicSkillId.Turret then
      data.range = lineData:getIntValue("para3")
      data.attack_duration = lineData:getIntValue("para5")
      data.damageHole = lineData:getIntValue("para4")
      data.damageSolider = lineData:getIntValue("para6")
      data.effPartTime = lineData:getIntValue("para2")
    elseif id == EpidemicSkillId.Judgment then
      data.range = lineData:getIntValue("para5")
      data.mvCDAdd = lineData:getIntValue("para4")
      data.mvCDMin = lineData:getIntValue("para3")
      data.damageHoleBorn = lineData:getIntValue("para2")
      data.effPartTime = 1
    end
    if iType == EpidemicZoneSkillType.LordReactiveDefault or iType == EpidemicZoneSkillType.LordReactiveRandom then
      local effects = {}
      local list = mySplit(lineData:getValue("para1"), "|")
      if 0 < #list then
        for _, v in ipairs(list) do
          local tmp = mySplitNum(v, ";")
          myInsert(effects, {
            lordEffectId = tmp[1] or 0,
            lordEffectVal = tmp[2] or 0
          })
        end
      end
      data.effects = effects
    else
      local paramIds = mySplit(lineData:getValue("skill_para_show_map", ""), ",") or nil
      if paramIds ~= nil then
        local descValues = {}
        for _, i in ipairs(paramIds) do
          myInsert(descValues, lineData:getIntValue("para" .. i))
        end
        data.descValues = descValues
      end
    end
    if iType == EpidemicZoneSkillType.LordReactiveDefault then
      self.lordSkillPassive = data.id
    elseif iType == EpidemicZoneSkillType.GodOfWar then
      self.lordSkillArbiter = data.id
    end
    
    function data.getDesc()
      return DataCenter.ActEpidemicZoneManager:GetSkillDesc(data)
    end
    
    dic[id] = data
  end)
  self.templateSkills = dic
end

function ActEpidemicZoneManager:GetSkillDesc(template, bList)
  if template == nil then
    return
  end
  local effectArray = template.effects
  if table.IsNullOrEmpty(effectArray) then
    local str
    if table.IsNullOrEmpty(template.descValues) then
      str = Localization:GetString(template.desc)
    else
      str = Localization:GetString(template.desc, table.unpack(template.descValues))
    end
    if bList then
      return {str}
    end
    return str
  else
    local descArray = template.descArray
    if table.IsNullOrEmpty(descArray) then
      if bList then
        return {}
      end
      return
    end
    local strList = {}
    local sb = StringBuilder.New()
    for i = 1, #descArray do
      local key = descArray[i]
      local eff = effectArray[i]
      if eff then
        local effId = eff and eff.lordEffectId
        local effVal = eff and eff.lordEffectVal or 0
        local type = toInt(GetTableData(TableName.LW_Effect_Number, tonumber(effId), "type"))
        if type ~= 0 then
          effVal = effVal * 1.0E-4
        end
        local showVal = UIUtil.ParseEffectValue(effId, effVal)
        if key then
          local str = Localization:GetString(key, showVal)
          table.insert(strList, str)
          sb:AppendLine(str)
        end
      else
        local str = Localization:GetString(key)
        table.insert(strList, str)
        sb:AppendLine(str)
      end
    end
    if bList then
      return strList
    end
    return sb:ToString()
  end
end

function ActEpidemicZoneManager:GetTemplateSkills()
  if self.templateSkills == nil then
    self:InitSkills()
  end
  return self.templateSkills
end

function ActEpidemicZoneManager:GetLordSkillPassive()
  if not self.lordSkillPassive then
    self:InitSkills()
  end
  return self.lordSkillPassive
end

function ActEpidemicZoneManager:GetLordSkillArbiter()
  if not self.lordSkillArbiter then
    self:InitSkills()
  end
  return self.lordSkillArbiter
end

function ActEpidemicZoneManager:GetTemplateSkillIds(types)
  local checkFunc = table.hasvalue
  local tInsert = table.insert
  local have
  local list = {}
  local skills = self:GetTemplateSkills()
  for id, v in pairs(skills) do
    have = false
    for _, t in pairs(types) do
      if checkFunc(v.types, t) then
        have = true
        break
      end
    end
    if have then
      tInsert(list, id)
    end
  end
  return list
end

function ActEpidemicZoneManager:GetTemplateSkillById(id)
  local skills = self:GetTemplateSkills()
  return skills[id]
end

function ActEpidemicZoneManager:GetSkillTagInfo(tag)
  if tag == 1 then
    if self.skillColor1 == nil then
      self.skillColor1 = UIUtil.HexToColor("eb4646")
    end
    return self.skillColor1, "YiBianJinQu_active_skill_tag_1"
  elseif tag == 2 then
    if self.skillColor2 == nil then
      self.skillColor2 = UIUtil.HexToColor("099b4a")
    end
    return self.skillColor2, "YiBianJinQu_active_skill_tag_2"
  else
    if self.skillColor3 == nil then
      self.skillColor3 = UIUtil.HexToColor("eb9146")
    end
    return self.skillColor3, "YiBianJinQu_active_skill_tag_3"
  end
end

function ActEpidemicZoneManager:GetTemplateBuffById(id)
  if self.templateBuffs == nil then
    self.templateBuffs = {}
  end
  local template = self.templateBuffs[id]
  if self.templateBuffs[id] == nil then
    local tbName = self:GetCfgValue(BattleFieldTableKey.PARAM)
    local lineData = LocalController.instance():getLine(tbName, id)
    if lineData ~= nil then
      template = {}
      template.id = id
      template.name = lineData:getValue("name")
      template.desc = lineData:getValue("desc")
      template.icon = string.format(LoadPath.LWBattleFieldPath, lineData:getValue("map_icon"))
      template.probability = lineData:getIntValue("probability")
      template.duration_time = lineData:getIntValue("duration_time")
      template.active_effect = lineData:getValue("active_effect")
      local effects = {}
      local mySplit = string.split
      local list = mySplit(lineData:getValue("effect_number"), "|")
      if 0 < #list then
        for _, v in ipairs(list) do
          local tmp = mySplit(v, ";")
          table.insert(effects, {
            lordEffectId = tmp[1] or 0,
            lordEffectVal = tmp[2] or 0
          })
        end
      end
      template.effects = effects
      template.buffShowMap = string.string2array_num_oneSep(lineData:getValue("buff_para_show_map"), ",")
      
      function template.getDesc()
        return DataCenter.ActEpidemicZoneManager:GetBuffDesc(template)
      end
      
      self.templateBuffs[id] = template
    end
  end
  return template
end

function ActEpidemicZoneManager:GetBuffDesc(template)
  if template == nil then
    return
  end
  local buffShowMap = template.buffShowMap
  if table.IsNullOrEmpty(buffShowMap) then
    return Localization:GetString(template.desc)
  end
  local effects = template.effects or {}
  local values = {}
  for _, v in ipairs(buffShowMap) do
    if v == 99 then
      table.insert(values, template.duration_time)
    else
      local eff = effects[v]
      local effVal = eff ~= nil and eff.lordEffectVal or 0
      local effId = eff.lordEffectId
      local type = toInt(GetTableData(TableName.LW_Effect_Number, tonumber(effId), "type"))
      if type ~= 0 then
        effVal = effVal * 1.0E-4
      end
      local value = UIUtil.ParseEffectValue(effId, effVal)
      table.insert(values, value)
    end
  end
  return Localization:GetString(template.desc, table.unpack(values))
end

function ActEpidemicZoneManager:GetTemplateScoreTypes(role)
  if self.templateScoreTypes == nil then
    local dic = {}
    local mySplitI = string.string2array_i_oneSep
    local tbName = self:GetCfgValue(BattleFieldTableKey.P_POINT_TYPE)
    LocalController.instance():visitTable(tbName, function(id, lineData)
      local data = {}
      data.id = id
      data.name = lineData:getValue("name")
      data.icon = lineData:getValue("icon")
      data.types = mySplitI(lineData:getValue("sub_type"), ",")
      data.camps = mySplitI(lineData:getValue("active_camp"), ",")
      data.showIds = mySplitI(lineData:getValue("show_id"), ",")
      dic[id] = data
    end)
    self.templateScoreTypes = dic
  end
  local list = {}
  for k, v in pairs(self.templateScoreTypes) do
    if role == EpidemicZoneRole.Default or table.hasvalue(v.camps, role) then
      table.insert(list, v)
    end
  end
  return list
end

function ActEpidemicZoneManager:InitPing()
  if self.templatePingList == nil then
    local curGroup = tonumber(self:GetCfgValue(BattleFieldTableKey.PING))
    self.templatePingList = BattleFieldUtil.InitPingGroup(curGroup)
  end
  return self.templatePingList
end

function ActEpidemicZoneManager:GetPingTemplate(id)
  self:InitPing()
  return self.templatePingList[id]
end

function ActEpidemicZoneManager:BuildOpenCheckWithTime(openTime)
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  if curSec < (openTime or 0) then
    UIUtil.ShowTipsId(458279)
    return false
  end
  return self:BattleStartCheck()
end

function ActEpidemicZoneManager:CheckBattleStart()
  return self:BattleStartCheck()
end

function ActEpidemicZoneManager:BattleStartCheck(groupIdx)
  local fixStage = self:FixStage(groupIdx)
  return fixStage == EpidemicZoneStage.Battle
end

function ActEpidemicZoneManager:FixStage(groupIdx)
  local actInfo = self:GetActInfo()
  local stage = actInfo ~= nil and actInfo:GetStage() or EpidemicZoneStage.None
  local et = actInfo ~= nil and actInfo.stageEndTime or 0
  if stage == EpidemicZoneStage.MatchEnd or stage == EpidemicZoneStage.Prepare or stage == EpidemicZoneStage.Battle or stage == EpidemicZoneStage.Show then
    local idx = groupIdx
    if (idx or 0) == 0 then
      idx = self:GetCurGroupIdx()
    end
    if idx == ActEpidemicUtils.Group2 then
      local bState = ActEpidemicUtils.GetTeamBState()
      if bState == EpidemicZoneSignState.StateSignNone or bState == EpidemicZoneSignState.StateBan or bState == EpidemicZoneSignState.StateMatchFailed then
        return EpidemicZoneStage.Show, et
      end
    end
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    local group = self:GetGroup(idx)
    local rTime = group ~= nil and group.readyTime or 0
    local sTime = group ~= nil and group.startTime or 0
    local eTime = group ~= nil and group.endTime or 0
    if curSec < rTime then
      stage = EpidemicZoneStage.MatchEnd
      et = rTime
    elseif curSec < sTime then
      stage = EpidemicZoneStage.Prepare
      et = sTime
    elseif curSec < eTime then
      stage = EpidemicZoneStage.Battle
      et = eTime
    else
      stage = EpidemicZoneStage.Show
    end
  end
  return stage, et
end

function ActEpidemicZoneManager:TodayEnterBattleWorld()
  local time = CommonUtil.PlayerPrefsGetString(EnterDragonWorld .. BattleFieldType.EpidemicZone, "")
  if time ~= nil and time ~= "" then
    local now = UITimeManager:GetInstance():GetServerSeconds()
    return UITimeManager:GetInstance():IsSameDayForServer(tonumber(time) or 0, now)
  end
  return false
end

function ActEpidemicZoneManager:GetLeaveCDTime()
  local actInfo = self:GetActInfo()
  return actInfo ~= nil and actInfo.leaveCDTime or 0
end

function ActEpidemicZoneManager:GetLeaveCDLeft()
  local cdTime = self:GetLeaveCDTime()
  return cdTime - UITimeManager:GetInstance():GetServerSeconds()
end

function ActEpidemicZoneManager:GetGroup(idx)
  local actInfo = self:GetActInfo()
  return actInfo ~= nil and actInfo:GetGroup(idx) or nil
end

function ActEpidemicZoneManager:GetMyGroupIdx()
  local actInfo = self:GetActInfo()
  return actInfo ~= nil and actInfo:GetMyGroupIdx() or 0
end

function ActEpidemicZoneManager:GetMyGroup()
  local idx = self:GetMyGroupIdx()
  return self:GetGroup(idx)
end

function ActEpidemicZoneManager:GetCurGroupIdx()
  local watchIdx = BattleFieldUtil.ObserveIdx()
  if BattleFieldUtil.isObserve and watchIdx ~= 0 then
    return watchIdx
  end
  return self:GetMyGroupIdx()
end

function ActEpidemicZoneManager:GetCurGroup()
  local idx = self:GetCurGroupIdx()
  return self:GetGroup(idx)
end

function ActEpidemicZoneManager:GetCurSide()
  local idx = self:GetCurGroupIdx()
  local actInfo = self:GetActInfo()
  return actInfo ~= nil and actInfo:GetSideByGroup(idx) or EpidemicBattleSide.Default
end

function ActEpidemicZoneManager:GetCurRole()
  local idx = self:GetCurGroupIdx()
  local actInfo = self:GetActInfo()
  return actInfo ~= nil and actInfo:GetRoleByGroup(idx) or EpidemicZoneRole.Default
end

function ActEpidemicZoneManager:BCurSelfArbiter()
  local idx = self:GetCurGroupIdx()
  local actInfo = self:GetActInfo()
  return actInfo ~= nil and actInfo:BSelfArbiter(idx)
end

function ActEpidemicZoneManager:GetCurRoleInfo()
  local idx = self:GetCurGroupIdx()
  local actInfo = self:GetActInfo()
  return actInfo ~= nil and actInfo:GetRoleInfoByGroup(idx) or nil
end

function ActEpidemicZoneManager:GetWorldCamp(param)
  return self:GetWorldCampInEpidemic(param)
end

function ActEpidemicZoneManager:GetWorldCampInEpidemic(param)
  local curRole = self:GetCurRole()
  if type(param) == "number" then
    if curRole ~= EpidemicZoneRole.Default and curRole == param then
      return WorldCamp.Ally
    end
  elseif type(param) == "string" then
    local role
    local curGroup = self:GetCurGroup()
    if curGroup and #curGroup.roles > 0 then
      for _, v in ipairs(curGroup.roles) do
        if v.allianceId == param then
          role = v.role
          break
        end
      end
    end
    if curRole ~= EpidemicZoneRole.Default and curRole == role then
      return WorldCamp.Ally
    end
  end
  return WorldCamp.Enemy
end

function ActEpidemicZoneManager:UpdateAllianceMemberList(allianceId, list)
  self.battleInfo:UpdateAllianceMemberList(allianceId, list)
end

function ActEpidemicZoneManager:GetBattleInfo()
  return self.battleInfo
end

function ActEpidemicZoneManager:CleanBattleInfo()
  self.battleInfo:ResetData()
end

function ActEpidemicZoneManager:GetVsInfo(role)
  return self.battleInfo:GetVsInfo(role)
end

function ActEpidemicZoneManager:GetBuildInfo(buildUUID)
  return self.battleInfo:GetBuildInfo(buildUUID)
end

function ActEpidemicZoneManager:ReqBattleWatchExit()
  local idx = self:GetCurGroupIdx()
  if idx == 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneBattleWatchExit, idx)
end

function ActEpidemicZoneManager:CheckTargetInSafeArea(pointId)
  local t = BattleFieldUtil.GetBlockRangeValue(pointId, BattleFieldType.EpidemicZone)
  local curSide = self:GetCurSide()
  if curSide == EpidemicBattleSide.Lord then
    return t == 4 or t == 5
  end
  if curSide ~= EpidemicBattleSide.FarmerL and curSide ~= EpidemicBattleSide.FarmerR then
    return false
  end
  if t == 2 then
    return true
  end
  if t == 3 then
    local detailInfo = BattleFieldUtil.GetDetailInfoByCfgId(10301)
    if detailInfo and detailInfo.Role == EpidemicZoneRole.Lord then
      return true
    end
  end
  return false
end

function ActEpidemicZoneManager:ReqBattleScore(groupIndex)
  local idx = groupIndex or self:GetCurGroupIdx()
  if idx == 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneBattleScore, idx)
  self.lastSyncTime = UITimeManager:GetInstance():GetServerSeconds()
end

function ActEpidemicZoneManager:HandleBattleScore(t)
  local data = t.data
  if data then
    for _, v in pairs(data) do
      self.battleInfo:ParseVsInfo(v)
    end
    EventManager:GetInstance():Broadcast(EventId.EpidemicBattleScoreUpdate)
  end
  local extra = t.extra
  if extra ~= nil then
    local skillPoint = extra.skillPoint
    if skillPoint ~= nil then
      local old = self.battleInfo.skillPoint
      self.battleInfo.skillPoint = skillPoint
      EventManager:GetInstance():Broadcast(EventId.EpidemicBattleSkillUpdate)
      EventManager:GetInstance():Broadcast(EventId.EpidemicBattleSkillPointChange, skillPoint - old)
    end
  end
  if self.actInfo then
    self.actInfo:UpdateBattleScore(t.group, data)
    EventManager:GetInstance():Broadcast(EventId.EpidemicActBattleScoreUpdate)
  end
end

function ActEpidemicZoneManager:ReqBattleEffect()
  local idx = self:GetCurGroupIdx()
  if idx == 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneBattleEffect, BattleFieldType.EpidemicZone, idx)
end

function ActEpidemicZoneManager:HandleEffects(t)
  return self.battleInfo:ParseEffects(t)
end

function ActEpidemicZoneManager:ReqBattlePlayerInfo()
  local idx = self:GetCurGroupIdx()
  if idx == 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneBattlePlayerInfo, idx)
end

function ActEpidemicZoneManager:HandleBattlePlayerInfo(t)
  if t.userList then
    self.battleInfo.playerInfo = {}
    for _, v in pairs(t.userList) do
      self.battleInfo:ParsePlayerInfo(v, v.role)
    end
    EventManager:GetInstance():Broadcast(EventId.EpidemicBattlePlayerInfoUpdate)
  end
end

function ActEpidemicZoneManager:ReqBattleFreeSpeed(uuid)
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneBattleFreeSpeedMarch, uuid)
end

function ActEpidemicZoneManager:HandleBattleFreeSpeed(t)
  self.battleInfo.speedCount = t.remain
  EventManager:GetInstance():Broadcast(EventId.EpidemicBattleSpeedUpdate)
end

function ActEpidemicZoneManager:ReqBattleFreeSpeedInfo()
  local idx = self:GetMyGroupIdx()
  if idx == 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneBattleFreeSpeedMarchInfo, idx)
end

function ActEpidemicZoneManager:HandleBattleFreeSpeedInfo(t)
  self.battleInfo.speedMaxCount = t.maxCount or 0
  self.battleInfo.speedCount = t.count or 0
  self.battleInfo.speedCdTime = t.cdTime or 0
  EventManager:GetInstance():Broadcast(EventId.EpidemicBattleSpeedUpdate)
end

function ActEpidemicZoneManager:ReqBattleCureSolider()
  local idx = self:GetMyGroupIdx()
  if idx == 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneBattleCureSolider, idx)
end

function ActEpidemicZoneManager:HandleBattleCureSolider(t)
  self.battleInfo.cureCdTime = t.cdEndTime
  local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.DragonHospital)
  if queue ~= nil then
    DataCenter.QueueDataManager:DeleteQueueByUuid(queue.uuid)
  end
  EventManager:GetInstance():Broadcast(EventId.EpidemicBattleCureUpdate)
end

function ActEpidemicZoneManager:GeCureCDEndTime()
  return self.battleInfo.cureCdTime or 0
end

function ActEpidemicZoneManager:CheckCureRed()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local cdTime = self:GeCureCDEndTime()
  if curTime < cdTime then
    return false
  end
  local info = BattleFieldUtil.GetSoldiersInfo()
  local curNum = (info.heal or 0) + (info.dead or 0)
  local checkNum = LuaEntry.DataConfig:TryGetNum("YiBianJinQu_battle", "k6", 0)
  if curNum > checkNum then
    return true
  end
  return false
end

function ActEpidemicZoneManager:ReqBattleLeave()
  local idx = self:GetMyGroupIdx()
  if idx == 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneBattleLeave, idx)
end

function ActEpidemicZoneManager:HandleBattleLeave(t)
  if t.nextEnterTime ~= nil then
    local actInfo = self:GetActInfo()
    if actInfo then
      actInfo.leaveCDTime = t.nextEnterTime
    end
  end
end

function ActEpidemicZoneManager:FixSkillCost(template)
  local maxNum = template ~= nil and template.points_required or 1
  local costEff1 = BattleFieldUtil.GetEffectById(EffectDefine.LW_EFF_EPIDEMIC_SKILL_COST_41015) or 0
  local costEff2 = BattleFieldUtil.GetEffectById(EffectDefine.LW_EFF_EPIDEMIC_SKILL_COST_41022) or 0
  local costEff = costEff1 + costEff2
  if 0 < costEff then
    maxNum = math.floor(maxNum * (1 - costEff * 1.0E-4))
  end
  return maxNum
end

function ActEpidemicZoneManager:CheckUseSkill(showTip, ignorePlaying)
  if BattleFieldUtil.BTestJump() then
    return true
  end
  if BattleFieldUtil.isObserve then
    return false
  end
  if not BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = (self.battleInfo.skillCdTime or 0) - curTime
  if 0 < remainTime then
    if showTip then
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
      UIUtil.ShowTips(Localization:GetString("120397", timeStr))
    end
    return false
  end
  remainTime = (self.battleInfo.activeEndTime or 0) - curTime
  if 0 < remainTime then
    if ignorePlaying then
      return true
    end
    if showTip then
      UIUtil.ShowTipsId("YiBianJinQu_errorcode_12")
    end
    return false
  end
  local curNum = self.battleInfo.skillPoint or 0
  local template = self:GetTemplateSkillById(self.battleInfo.skillId)
  local maxNum = self:FixSkillCost(template)
  if curNum < maxNum then
    if showTip then
      UIUtil.ShowTipsId("YiBianJinQu_errorcode_11")
    end
    return false
  end
  return true
end

function ActEpidemicZoneManager:PreviewSkill(skillId)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIEpidemicBattleSkillPreview, {anim = true}, skillId)
end

function ActEpidemicZoneManager:CheckCntInSkillRange(pointId, mainRange, pointsInRange)
  local points = {}
  local cnt = 0
  local theWorld = CS.SceneManager.World
  if theWorld ~= nil and CS.SceneManager:IsInWorld() then
    local cityList = theWorld:GetAllMainBaseList()
    if cityList == nil then
      return cnt, points
    end
    local myUid = LuaEntry.Player:GetUid()
    local skillId = self:GetCurSkillId()
    local distance = math.huge
    local targetUid, targetIndex
    for _, v in pairs(cityList) do
      local bEnemy = v.ownerUid ~= myUid and BattleFieldUtil.IsBattleFieldEnemy(v.quarantineRole, BattleFieldType.EpidemicZone)
      if bEnemy then
        if skillId == EpidemicSkillId.Hospital or self:CheckTargetInSafeArea(v.mainIndex) then
          goto lbl_92
        end
      else
      end
      if skillId == EpidemicSkillId.Hospital and v.ownerUid ~= myUid and BattleFieldUtil.CheckBuildInSkillRange(v.mainIndex, mainRange, pointsInRange) then
        if skillId == EpidemicSkillId.Turret then
          local dist = BattleFieldUtil.GetDistanceByIndex(v.mainIndex, pointId)
          if distance > dist then
            distance = dist
            targetUid = v.ownerUid
            targetIndex = v.mainIndex
          end
        else
          points[v.ownerUid] = v.mainIndex
          cnt = cnt + 1
        end
      end
      ::lbl_92::
    end
    if skillId == EpidemicSkillId.Turret and targetUid ~= nil then
      points[targetUid] = targetIndex
      cnt = cnt + 1
    end
  end
  return cnt, points
end

function ActEpidemicZoneManager:CheckMainCanPut(pointId, buildUuid)
  if pointId == LuaEntry.Player:GetMainWorldPos() then
    return true
  end
  local putState = BuildingUtils.IsCanPutDownByBuild(BuildingTypes.FUN_BUILD_MAIN, pointId, buildUuid)
  return putState == BuildPutState.Ok
end

function ActEpidemicZoneManager:TryFixUseSkillPoint(pointId, buildUuid)
  local skillId = self:GetCurSkillId()
  local template = self:GetTemplateSkillById(skillId)
  local skillRange = template ~= nil and template.range or 0
  local targetCnt = 0
  local newP, nearP
  local mainRange = BattleFieldUtil.GetMainRange()
  if self:CheckMainCanPut(pointId, buildUuid) then
    nearP = pointId
    local pointsInRange = BattleFieldUtil.GetRangePoints(pointId, skillRange)
    targetCnt = self:CheckCntInSkillRange(pointId, mainRange, pointsInRange)
    if 0 < targetCnt then
      newP = pointId
    end
  end
  if skillId == EpidemicSkillId.Turret and newP ~= nil and 0 < targetCnt then
    return newP
  end
  local v2 = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  local range = 6
  for layer = 1, range do
    for y = v2.y - layer, v2.y + layer do
      for x = v2.x - layer, v2.x + layer do
        if x == v2.x - layer or x == v2.x + layer or y == v2.y - layer or y == v2.y + layer then
          local tmpIndex = SceneUtils.TileXYToIndex(x, y, ForceChangeScene.World)
          if self:CheckMainCanPut(tmpIndex, buildUuid) then
            if nearP == nil then
              nearP = tmpIndex
            end
            local pointsInRange = BattleFieldUtil.GetRangePoints(tmpIndex, skillRange)
            local tmpCnt = self:CheckCntInSkillRange(tmpIndex, mainRange, pointsInRange)
            if targetCnt < tmpCnt then
              newP = tmpIndex
              targetCnt = tmpCnt
              if skillId == EpidemicSkillId.Turret then
                return newP
              end
            end
          end
        end
      end
    end
  end
  return newP or nearP or pointId
end

function ActEpidemicZoneManager:TryUseSkill(point, ignoreFix)
  if not self:CheckUseSkill(true) then
    return
  end
  local theWorld = CS.SceneManager.World
  if theWorld == nil then
    return
  end
  local mainBuild
  if BattleFieldUtil.InBattleField() then
    mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
  end
  if mainBuild == nil or mainBuild.uuid == nil then
    mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  end
  if mainBuild ~= nil then
    local city = theWorld:GetWorldBuildingByUuid(mainBuild.uuid)
    if city ~= nil then
      city:SetMoveState(true)
    end
    local mainBuildModelPath = BuildingUtils.GetWorldBuildingModelName(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
    local pointId = point or SceneUtils.WorldToTileIndex(theWorld.CurTarget)
    if not ignoreFix then
      pointId = self:TryFixUseSkillPoint(pointId, mainBuild.uuid)
    end
    theWorld:UICreateBuildingModelPath(BuildingTypes.FUN_BUILD_MAIN, mainBuild.uuid, pointId, PlaceBuildType.EpidemicSkill, mainBuildModelPath)
  end
end

function ActEpidemicZoneManager:HandleBattleSkill(t)
  self.battleInfo:ParseSkillInfo(t)
  EventManager:GetInstance():Broadcast(EventId.EpidemicBattleSkillUpdate)
end

function ActEpidemicZoneManager:GetCurSkillId()
  if BattleFieldUtil.BTestJump() then
    return EpidemicSkillId.Judgment
  end
  return self.battleInfo.skillId
end

function ActEpidemicZoneManager:ReqBattleUseSkill(pointId)
  if not self:CheckUseSkill(true) then
    return
  end
  local idx = self:GetMyGroupIdx()
  if idx == 0 then
    return
  end
  self._useSkillPointId = pointId
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneBattleUseSkill, pointId, idx)
end

function ActEpidemicZoneManager:HandleBattleUseSkill(t)
  self.battleInfo:ParseSkillInfo(t)
  EventManager:GetInstance():Broadcast(EventId.EpidemicBattleSkillUpdate)
  if t.worldMainPointId then
    LuaEntry.Player:SetBattleFieldPointId(t.worldMainPointId)
  end
  self:PrepareBGM(true)
end

function ActEpidemicZoneManager:GetSkillActiveEndTime()
  if not BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    return 0
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local sTime = self.battleInfo.activeStartTime or 0
  local eTime = self.battleInfo.activeEndTime or 0
  local skillPlaying = curTime >= sTime and curTime < eTime
  return skillPlaying and eTime or 0
end

function ActEpidemicZoneManager:GetSkillModelPath(skillId)
  local template = self:GetTemplateSkillById(skillId)
  return template ~= nil and template.model or ""
end

function ActEpidemicZoneManager:GetEpidemicCurSkillInfo()
  local skillId = self:GetCurSkillId()
  local oneData = {}
  oneData.skillId = skillId
  oneData.prefab = self:GetSkillModelPath(skillId)
  local leftTime = self:EpidemicSkillLeftTime()
  if 0 < leftTime then
    oneData.eTime = leftTime
  end
  return oneData
end

function ActEpidemicZoneManager:EpidemicSkillLeftTime()
  if not BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    return 0
  end
  local sTime = self.battleInfo.activeStartTime or 0
  local eTime = self.battleInfo.activeEndTime or 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local skillPlaying = sTime <= curTime and eTime > curTime
  if skillPlaying then
    return eTime - curTime
  end
  return 0
end

function ActEpidemicZoneManager:HandleBattleSkillMVBorn(t)
  local uid = t.uid
  if uid == ActEpidemicUtils.DEV_TEST_SKILL_UID then
    return
  end
  local pointId = t.pointId
  local allianceId = self.battleInfo:GetAlMemberByPlayerUid(uid)
  local bEnemy = self:GetWorldCampInEpidemic(allianceId) == WorldCamp.Enemy
  local effName = bEnemy and "Eff_yibianBattle_qiancheng_red.prefab" or "Eff_yibianBattle_qiancheng_bule.prefab"
  local data = string.format("%s;%d;%d;%s", uid, pointId, 0, string.format(LoadPath.LWBattleFieldEpidemicEffectPath, effName))
  EventManager:GetInstance():Broadcast(EventId.ShowDomeShowEffect, data)
  local bfAnimMgr = DataCenter.BattleFieldAnimManager
  local skillId = t.skillId
  local param = bfAnimMgr:GetSkillParam()
  param.uid = uid
  param.anim = BattleFieldObjActType.BORN
  param.skillId = skillId
  param.pointIndex = pointId
  bfAnimMgr:SetSkillObjAnim(param)
  self:PlaySkillSoundByType(uid, 0, skillId)
end

function ActEpidemicZoneManager:TryShowHoleChange(pointId, beforeHole, currHole)
  if currHole == nil or beforeHole == nil or currHole == beforeHole then
    return
  end
  local theWorld = CS.SceneManager.World
  if not SceneUtils.GetIsInWorld() or theWorld == nil then
    return
  end
  local pointInfo = theWorld:GetPointInfo(pointId)
  if pointInfo == nil then
    return
  end
  local uuid = pointInfo.uuid
  local maxHole = 0
  if pointInfo.curMaxHp and 0 < pointInfo.curMaxHp then
    maxHole = pointInfo.curMaxHp
  else
    maxHole = BattleFieldUtil.GetPlayerMaxHp(BattleFieldUtil.GetCurBattleFieldType())
  end
  local serverId = LuaEntry.Player:GetCurServerId()
  local itemId = BuildingTypes.FUN_BUILD_MAIN
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(itemId)
  if buildTemplate ~= nil then
    local nodeGo = theWorld.BuildBubbleNode and theWorld.BuildBubbleNode.gameObject or nil
    if nodeGo and nodeGo.activeSelf ~= true then
      DataCenter.WorldBuildBubbleManager:UpdateLod(theWorld.CurrentLodLevel)
    end
    BuildBloodManager:GetInstance():ShowOneBloodEffect(serverId, uuid, pointId, beforeHole, currHole, maxHole, buildTemplate.tileX, buildTemplate.tileY, itemId, true)
  end
end

function ActEpidemicZoneManager:HandleBattleSkillEffect(t)
  local bfAnimMgr = DataCenter.BattleFieldAnimManager
  local uid = t.uid
  local skillId = t.skillId
  local pointId = t.point
  local rangeEff = t.rangeEff
  local selfUid = LuaEntry.Player:GetUid()
  local bTargetMe = false
  local bBorn = rangeEff ~= nil and rangeEff.bornType == 1
  if rangeEff ~= nil then
    if not bBorn then
      local param = bfAnimMgr:GetSkillParam()
      param.uid = uid
      param.anim = BattleFieldObjActType.ATK
      param.skillId = skillId
      param.pointIndex = pointId
      bfAnimMgr:SetSkillObjAnim(param)
    end
    local damageInfo = rangeEff.damageInfo
    if not table.IsNullOrEmpty(damageInfo) then
      for _, v in ipairs(damageInfo) do
        local bEnemy = false
        if selfUid == v.uid then
          bTargetMe = true
        else
          local tAlId = self.battleInfo:GetAlMemberByPlayerUid(v.uid)
          if tAlId ~= nil then
            bEnemy = self:GetWorldCampInEpidemic(tAlId) == WorldCamp.bEnemy
          else
            bEnemy = true
          end
        end
        if v.cureSolider or v.cureHole then
          if v.cureSolider then
            BattleFieldUtil.PlaySoliderNumChange(bEnemy, v.pointId, v.cureSolider)
          end
          self:PlaySkillEff(v.pointId, "Eff_zhiliaozhan_dzz_jiaxue_loop.prefab")
        end
        if v.damageSolider then
          BattleFieldUtil.PlaySoliderNumChange(bEnemy, v.pointId, -v.damageSolider)
        end
        if v.damageHole then
          local info = CS.SceneManager.World:GetPointInfo(v.pointId)
          if info ~= nil then
            EventManager:GetInstance():Broadcast(EventId.PlayerHPChanged, info.uuid)
          end
        end
        self:TryShowHoleChange(v.pointId, v.beforeHole, v.currHole)
      end
      if skillId == EpidemicSkillId.Quake or skillId == EpidemicSkillId.Hospital then
        self:PlaySkillSoundByType(uid, 2, skillId)
      end
    end
  end
  if skillId == EpidemicSkillId.Quake then
    local name = bBorn and "Eff_yulinBattle_dzt_skill01.prefab" or "Eff_yulinBattle_dzt_skill02.prefab"
    self:PlaySkillSoundByType(uid, 1, skillId)
    self:PlaySkillEff(pointId, name)
  elseif skillId == EpidemicSkillId.Hospital then
    self:PlaySkillSoundByType(uid, 1, skillId)
    self:PlaySkillEff(pointId, "Eff_yulinBattle_ylz_skill01.prefab")
  elseif skillId == EpidemicSkillId.Judgment then
    self:PlaySkillEff(pointId, "Eff_yulinBattle_dcmct_skill.prefab")
  elseif skillId == EpidemicSkillId.Turret then
    local fire = t.fire
    if fire then
      local targetPoint = fire.targetPoint or 0
      if 0 < targetPoint then
        do
          local fireSec = math.floor(fire.fireTime / 1000)
          local curSec = UITimeManager:GetInstance():GetServerSeconds()
          local remainSec = fireSec - curSec
          local param = bfAnimMgr:GetSkillParam()
          param.uid = uid
          param.anim = BattleFieldObjActType.IDLE
          param.skillId = skillId
          param.pointIndex = pointId
          bfAnimMgr:SetSkillObjTargetPid(uid, targetPoint, fireSec, param)
          if 0 < remainSec then
            TimerManager:GetInstance():DelayInvoke(function()
              self:PlaySkillSoundByType(uid, 1, skillId)
              bfAnimMgr:SetSkillObjTargetPid(uid, targetPoint, fireSec)
              bfAnimMgr:CleanSkillAim(uid)
            end, remainSec)
          else
            self:PlaySkillSoundByType(uid, 1, skillId)
            bfAnimMgr:ShowSkillAim(uid)
          end
        end
      end
    end
    local fa = t.fireArrive
    if fa then
      local targetPoint = fa.targetPoint
      local bEnemy = false
      if selfUid == fa.targetUid then
        bTargetMe = true
      else
        self:PlaySkillSoundByType(uid, 2, skillId)
        local tAlId = self.battleInfo:GetAlMemberByPlayerUid(fa.targetUid)
        if tAlId ~= nil then
          bEnemy = self:GetWorldCampInEpidemic(tAlId) == WorldCamp.bEnemy
        else
          bEnemy = true
        end
      end
      if fa.damageSolider then
        BattleFieldUtil.PlaySoliderNumChange(bEnemy, targetPoint, -fa.damageSolider)
      end
      if fa.damageHole then
        local pointInfo = CS.SceneManager.World:GetPointInfo(targetPoint)
        cast(pointInfo, typeof(CS.BuildPointInfo))
        if pointInfo ~= nil then
          EventManager:GetInstance():Broadcast(EventId.PlayerHPChanged, pointInfo.uuid)
        end
      end
      self:TryShowHoleChange(targetPoint, fa.beforeHole, fa.currHole)
    end
  end
  if bTargetMe then
    t.lastSignTime = UITimeManager:GetInstance():GetServerTime()
    self.beAttackedBySkills[uid] = t
    EventManager:GetInstance():Broadcast(EventId.EpidemicBattleBeAttackedBySkill, t)
  end
end

function ActEpidemicZoneManager:GetBeAttackedBySkillList()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local list = {}
  local redCnt = 0
  for k, v in pairs(self.beAttackedBySkills) do
    if v then
      if v.endTime and curTime >= v.endTime then
        self.beAttackedBySkills[k] = nil
      else
        local template = self:GetTemplateSkillById(v.skillId)
        local checkTime = ((template.effPartTime or 3) + 1) * 1000
        if v.lastSignTime and curTime >= v.lastSignTime + checkTime then
          self.beAttackedBySkills[k] = nil
        else
          if v.skillId ~= EpidemicSkillId.Hospital then
            redCnt = redCnt + 1
          end
          table.insert(list, v)
        end
      end
    end
  end
  return redCnt, list
end

function ActEpidemicZoneManager:PlaySkillSoundByType(uid, playType, skillId)
  if uid ~= LuaEntry.Player:GetUid() and uid ~= ActEpidemicUtils.DEV_TEST_SKILL_UID then
    return
  end
  local _id = skillId or self:GetCurSkillId()
  local template = self:GetTemplateSkillById(_id)
  if template == nil then
    return
  end
  local soundId = 0
  if playType == 0 then
    soundId = template.sound_born
  elseif playType == 1 then
    soundId = template.sound_attack
  elseif playType == 2 then
    soundId = template.sound_hit
  end
  if soundId ~= 0 then
    DataCenter.LWSoundManager:PlaySound(soundId, false)
  end
end

function ActEpidemicZoneManager:HandleBattleArbiterBreakCity(t)
  local template = self:GetTemplateSkillById(EpidemicSkillId.Judgment)
  local attUid = t.attUid
  local bfAnimMgr = DataCenter.BattleFieldAnimManager
  local param = bfAnimMgr:GetSkillParam()
  param.uid = attUid
  param.anim = BattleFieldObjActType.ATK
  param.skillId = EpidemicSkillId.Judgment
  param.bRewind = true
  param.pointIndex = t.attPointId
  local firePointObj = bfAnimMgr:SetSkillObjAnim(param)
  if t.attPointId ~= nil then
    local attPId = t.attPointId
    local prefab = "Eff_diancimaichong_attack_sf.prefab"
    if firePointObj ~= nil then
      TimerManager:GetInstance():DelayInvoke(function()
        self:PlaySkillEff(nil, prefab, firePointObj)
      end, 0.2)
    else
      self:PlaySkillEff(attPId, prefab)
    end
    local minNum = template ~= nil and template.mvCDMin or 0
    BattleFieldUtil.PlayMvCDNumChange(t.attPointId, -minNum)
  end
  local addNum = template ~= nil and template.mvCDAdd or 0
  if t.defPointId ~= nil then
    self:PlaySkillEff(t.defPointId, "Eff_diancimaichong_attack_hit.prefab")
    if attUid == LuaEntry.Player:GetUid() or attUid == ActEpidemicUtils.DEV_TEST_SKILL_UID then
      DataCenter.LWSoundManager:PlaySound(93011, false)
    end
    BattleFieldUtil.PlayMvCDNumChange(t.defPointId, addNum)
  end
  if t.defNewPoint ~= nil then
    BattleFieldUtil.PlayMvCDNumChange(t.defNewPoint, addNum)
  end
end

function ActEpidemicZoneManager:PlaySkillEff(pointId, prefab, parent, time)
  local bfAnimMgr = DataCenter.BattleFieldAnimManager
  local effParam = bfAnimMgr:GetEffParam()
  effParam.pointId = pointId
  effParam.prefab = prefab
  effParam.pathPrefix = LoadPath.LWBattleFieldEpidemicEffectPath
  effParam.parent = parent
  effParam.time = time
  if CommonUtil.IsDebug() and ActEpidemicUtils.GetTestSkillId() ~= nil then
    effParam.checkInView = false
  end
  bfAnimMgr:ShowEffectObj(effParam)
end

function ActEpidemicZoneManager:GetClosestPos(target, ignoreBuild)
  local ret = target
  local findBestPos = false
  local boxIndex, resIndex
  local list = CS.SceneManager.World:GetAllDragonPointList()
  local cityList = CS.SceneManager.World:GetAllMainBaseList()
  local tmpMgr = DataCenter.EpidemicBuildTemplateMgr
  local TileIndexToWorld = SceneUtils.TileIndexToWorld
  for bestLen = 10, 20 do
    if cityList ~= nil then
      for _, v in pairs(cityList) do
        local pos = TileIndexToWorld(v.mainIndex, ForceChangeScene.World)
        if bestLen > math.abs(pos.x - target.x) and bestLen > math.abs(pos.z - target.z) then
          ret = pos
          findBestPos = true
          break
        end
      end
    end
    if not findBestPos and list then
      for _, v in pairs(list) do
        local detailInfo = v.detail
        if detailInfo ~= nil then
          local buildId = detailInfo.BuildId
          if tmpMgr:IsScoreBox(buildId) then
            if boxIndex == nil then
              boxIndex = v.mainIndex
            end
          elseif tmpMgr:IsRes(buildId) then
            if resIndex == nil then
              resIndex = v.mainIndex
            end
          elseif not ignoreBuild then
            local pos = TileIndexToWorld(v.mainIndex, ForceChangeScene.World)
            if bestLen > math.abs(pos.x - target.x) and bestLen > math.abs(pos.z - target.z) then
              ret = pos
              findBestPos = true
              break
            end
          end
        end
      end
      if not findBestPos and boxIndex then
        local pos = TileIndexToWorld(boxIndex, ForceChangeScene.World)
        if bestLen > math.abs(pos.x - target.x) and bestLen > math.abs(pos.z - target.z) then
          ret = pos
          findBestPos = true
          break
        end
      end
      if not findBestPos and resIndex then
        local pos = TileIndexToWorld(resIndex, ForceChangeScene.World)
        if bestLen > math.abs(pos.x - target.x) and bestLen > math.abs(pos.z - target.z) then
          ret = pos
          findBestPos = true
          break
        end
      end
    end
    if findBestPos then
      break
    end
  end
  return ret
end

function ActEpidemicZoneManager:HandleBattleSkillStatisticsInfo(t)
  local tmpSkillId = t.skillId
  t.skillId = nil
  t.activeEndTime = nil
  self.battleInfo:ParseSkillInfo(t)
  t.skillId = tmpSkillId
  EventManager:GetInstance():Broadcast(EventId.EpidemicBattleSkillStatistics, t)
  if t.isEnd then
    self:PrepareBGM(true)
  end
end

function ActEpidemicZoneManager:HandleBattleArbiterActiveState(t)
  self.battleInfo:ParseArbiterSkillState(t.uid, t.endTime)
  EventManager:GetInstance():Broadcast(EventId.EpidemicBattleSkillArbiter)
end

function ActEpidemicZoneManager:ReqBattleSkillRecords()
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneBattleSkillEffectRecords)
end

function ActEpidemicZoneManager:HandleBattleSkillEffectRecords(t)
  local records = t.records or {}
  EventManager:GetInstance():Broadcast(EventId.EpidemicBattleSkillEffectRecords, records)
end

function ActEpidemicZoneManager:ReqCommanderList(group)
  if not LuaEntry.Player:IsInAlliance() then
    return
  end
  if group == nil then
    self.commanderList = {}
    SFSNetwork.SendMessage(MsgDefines.EpidemicZoneCommanderList, 1)
    SFSNetwork.SendMessage(MsgDefines.EpidemicZoneCommanderList, 2)
    return
  end
  self.commanderList = self.commanderList or {}
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneCommanderList, group)
end

function ActEpidemicZoneManager:HandleCommanderList(t)
  local data = t.data
  if data then
    local group = t.group
    self.commanderList = self.commanderList or {}
    local groupList = {}
    for _, uid in ipairs(data) do
      groupList[uid] = true
    end
    self.commanderList[group] = groupList
  end
  self:RefreshLittleRed()
  EventManager:GetInstance():Broadcast(EventId.EpidemicActPlayerListRefresh)
end

function ActEpidemicZoneManager:IsCommander(uid, group)
  if self.commanderList == nil then
    return false
  end
  for _g, groupList in pairs(self.commanderList) do
    for _uid, state in pairs(groupList) do
      if state and _uid == uid and (group == nil or group == _g) then
        return true
      end
    end
  end
  return false
end

function ActEpidemicZoneManager:IsSelfCommander()
  if BattleFieldUtil.BTestJump() then
    return true
  end
  if BattleFieldUtil.isObserve then
    return false
  end
  if not BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    return false
  end
  return self:IsCommander(LuaEntry.Player:GetUid())
end

function ActEpidemicZoneManager:ReqCommanderOpt(group, opt, uid)
  self.lastOptGroup = group
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneCommanderOpt, group, opt, uid)
end

function ActEpidemicZoneManager:HandleCommanderOpt(t)
  local group = t.group or self.lastOptGroup
  self.commanderList = self.commanderList or {}
  local groupList = self.commanderList[group] or {}
  groupList[t.uid] = t.opt == 1
  self.commanderList[group] = groupList
  EventManager:GetInstance():Broadcast(EventId.EpidemicActPlayerListRefresh)
end

function ActEpidemicZoneManager:HandleCommanderOptPush(t)
  local group = t.group or self:GetCurGroupIdx()
  self.commanderList = self.commanderList or {}
  local groupList = self.commanderList[group] or {}
  groupList[t.uid] = t.opt == 1
  self.commanderList[group] = groupList
  EventManager:GetInstance():Broadcast(EventId.EpidemicActPlayerListRefresh)
end

function ActEpidemicZoneManager:ReqCommanderOrderAdd(cfgId, pid)
  local groupIdx = self:GetCurGroupIdx()
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneCommanderOrderAdd, groupIdx, cfgId, pid)
end

function ActEpidemicZoneManager:CheckOrderMarkPopCanShow(pingCfg)
  local linkSkill = pingCfg.link_skill
  if linkSkill == nil or linkSkill == 0 then
    return true
  end
  if linkSkill ~= self:GetCurSkillId() then
    return false
  end
  return self:CheckUseSkill(false, true)
end

function ActEpidemicZoneManager:GetTeammateByAllianceId(allianceId)
  local groupInfo = self:GetCurGroup()
  local roles = groupInfo ~= nil and groupInfo.roles or nil
  if table.IsNullOrEmpty(roles) then
    return
  end
  local role = EpidemicZoneRole.Default
  for _, v in pairs(roles) do
    if v.allianceId == allianceId then
      role = v.role
      break
    end
  end
  if role ~= EpidemicZoneRole.Default then
    for _, v in pairs(roles) do
      if v.role == role and v.allianceId ~= allianceId then
        return v.allianceId
      end
    end
  end
end

function ActEpidemicZoneManager:GetGuideList()
  if self.theGuideList == nil then
    self.theGuideList = BattleFieldUtil.GetGuideList(BattleFieldType.EpidemicZone)
  end
  return self.theGuideList
end

local _emptyTab = {}

function ActEpidemicZoneManager:GetOperateLog()
  return self.operateLog or _emptyTab
end

function ActEpidemicZoneManager:GetPlayerList()
  return self.playerList
end

function ActEpidemicZoneManager:GetCurNumByState(state, group)
  local num = 0
  local players = self.playerList ~= nil and self.playerList:GetPlayersByGroup(group) or nil
  if players then
    for _, v in pairs(players) do
      if v.state == state then
        num = num + 1
      end
    end
  end
  return num
end

function ActEpidemicZoneManager:GetCommanderNum(group, rank)
  local num = 0
  local players = self.playerList ~= nil and self.playerList:GetPlayersByGroup(group) or nil
  if players then
    for _, v in pairs(players) do
      if v.state ~= EpidemicZonePlayerState.None and self:IsCommander(v.uid, group) and (rank == nil or rank == v.rank) then
        num = num + 1
      end
    end
  end
  return num
end

function ActEpidemicZoneManager:EditorFakeAct()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local act = {
    type = 344,
    id = "40041",
    activityid = "40041",
    endTime = serverTime + 3600000,
    name = "epidemic",
    readyTime = serverTime - 60000,
    startTime = serverTime - 60000
  }
  DataCenter.ActivityListDataManager:AddOneActivity(nil, act)
end

function ActEpidemicZoneManager:EditorFakeActDetail()
  local serverTime = UITimeManager:GetInstance():GetServerSeconds()
  local serverAllianceID = LuaEntry.Player:GetAllianceUid()
  local msg = {
    stage = EpidemicZoneStage.SignIn,
    stageEndTime = serverTime + 3600,
    allianceIcon = "",
    group = {
      {
        state = 0,
        roleInfo = {
          {role = 1},
          {},
          {}
        }
      },
      {
        state = 0,
        roleInfo = {
          {},
          {},
          {}
        }
      }
    }
  }
  self:HandleActivityInfoMessage(msg)
end

function ActEpidemicZoneManager:RequestActivityApply(group, chooseTimeList)
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneActApply, group, chooseTimeList)
end

function ActEpidemicZoneManager:HandleActivityApplyMessage(msg)
  if self.playerList then
    self.playerList:UpdateMyApply(msg.group)
  end
end

function ActEpidemicZoneManager:RequestActivityArbiter(group, targetUid)
  if not ActEpidemicUtils.CanAssignArbiter() then
    return
  end
  local aribiter = ActEpidemicUtils.GetArbiterByGroupId(group)
  if aribiter then
    if aribiter.uid == targetUid then
      return
    end
    local cd = aribiter.arbiterCdTime or 0
    local gap = cd - UITimeManager:GetInstance():GetServerSeconds()
    if 0 < gap then
      local tips = Localization:GetString("YiBianJinQu_trivial_tips_36", gap)
      UIUtil.ShowTips(tips)
      return
    end
  end
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneActArbiter, group, targetUid)
end

function ActEpidemicZoneManager:HandleActivityArbiterMessage(msg)
  self:RequestActivityInfo()
end

function ActEpidemicZoneManager:RequestActivityAssign(group, targetUid, state)
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneActAssign, group, targetUid, state)
end

function ActEpidemicZoneManager:HandleActivityAssignMessage(msg)
  if not self.playerList then
    ActEpidemicUtils.Error("HandleActivityAssignMessage exception! Playerlist is null.")
    return
  end
  self.playerList:UpdatePlayer(msg.group, msg.targetUid, msg.state)
  if msg.targetUid == LuaEntry.Player:GetUid() then
    self:RequestActivityInfo()
  end
end

function ActEpidemicZoneManager:OnAssignError(errorCode, errParam)
  UIUtil.ShowTips(Localization:GetString(errorCode, table.unpack(errParam or {})))
  EventManager:GetInstance():Broadcast(EventId.EpidemicActPlayerListRefresh)
end

function ActEpidemicZoneManager:RequestActivityInfo(bRandomDelay)
  self:ReqActInfo(bRandomDelay)
end

function ActEpidemicZoneManager:HandleActivityInfoMessage(msg)
  self.actInfo = ActEpidemicZoneActivityInfo.New()
  self.actInfo:Refresh(msg)
  self:RequestActivityPlayerList()
  EventManager:GetInstance():Broadcast(EventId.EpidemicActInfoUpdate)
  self:RefreshLittleRed()
end

function ActEpidemicZoneManager:GetRedKey(key, groupIdx)
  if not (key and self.actInfo) or not self.actInfo.actId then
    return ""
  end
  local idx = groupIdx or 0
  local eTime = 0
  if idx ~= 0 then
    local groupInfo = self:GetGroup(idx)
    eTime = groupInfo ~= nil and groupInfo.endTime or 0
    if eTime == 0 then
      eTime = self.actInfo.stageEndTime
    end
  end
  return string.format("%s_%s_%s", key, idx, eTime)
end

function ActEpidemicZoneManager:GetRedState(key, groupIdx)
  key = self:GetRedKey(key, groupIdx)
  return CommonUtil.PlayerPrefsGetBool(key, false)
end

function ActEpidemicZoneManager:SetRedState(key, groupIdx, state)
  key = self:GetRedKey(key, groupIdx)
  CommonUtil.PlayerPrefsSetBool(key, state)
end

function ActEpidemicZoneManager:MarkRed(root, name, groupIdx, cnt)
  local markCnt = cnt or 0
  local changed = LittleRedUtils.SetCount(root, name .. groupIdx, markCnt)
  if not changed or markCnt ~= 0 then
    return
  end
  self:SetRedState(name, groupIdx, true)
end

function ActEpidemicZoneManager:CheckRedShow(root, name, groupIdx)
  local cnt = LittleRedUtils.GetCount(root, name .. groupIdx)
  return 0 < cnt
end

function ActEpidemicZoneManager:ClearRedKeys()
  for i = 1, 2 do
    self:SetRedState(LittleRedConst.NameActEpidemicMainApply, i, false)
    self:SetRedState(LittleRedConst.NameActEpidemicMainContact, i, false)
    self:SetRedState(LittleRedConst.NameActEpidemicMainFight, i, false)
    self:SetRedState(LittleRedConst.NameActEpidemicMainLordSkill, i, false)
    self:SetRedState(LittleRedConst.NameActEpidemicMainArbiterNotSet, i, false)
    self:SetRedState(LittleRedConst.NameActEpidemicMainCommanderNotSet, i, false)
  end
end

function ActEpidemicZoneManager:RefreshLittleRed()
  local red, isNew = LittleRedUtils.Get(LittleRedConst.NameActEpidemicMain)
  if isNew and red then
    for i = 1, 2 do
      LittleRedUtils.Get(LittleRedConst.NameActEpidemicMainApply .. i, red)
      LittleRedUtils.Get(LittleRedConst.NameActEpidemicMainFight .. i, red)
      LittleRedUtils.Get(LittleRedConst.NameActEpidemicMainArbiterNotSet .. i, red)
    end
  end
  red, isNew = LittleRedUtils.Get(LittleRedConst.NameActEpidemicOther)
  if isNew and red then
    for i = 1, 2 do
      LittleRedUtils.Get(LittleRedConst.NameActEpidemicMainCommanderNotSet .. i, red)
      LittleRedUtils.Get(LittleRedConst.NameActEpidemicMainContact .. i, red)
      LittleRedUtils.Get(LittleRedConst.NameActEpidemicMainLordSkill .. i, red)
    end
  end
  for i = 1, 2 do
    local signCnt = 0
    local contactCnt = 0
    local enterCnt = 0
    local arbiterCnt = 0
    local commanderCnt = 0
    if self.actInfo and self.actInfo.actId then
      local signState = self.actInfo:GetGroupSignState(i)
      local myPlayerState = ActEpidemicUtils.GetMyPlayerState()
      local roleGroup = self.actInfo:GetRoleByGroup(i)
      local fixStage = self:FixStage(i)
      local showSign = self.actInfo.currentStage == EpidemicZoneStage.SignIn and signState == EpidemicZoneSignState.StateSignNone and not self:GetRedState(LittleRedConst.NameActEpidemicMainApply, i) and ActEpidemicUtils.CanChangeBattlePlayer()
      if showSign then
        signCnt = 1
      end
      local showContactRed = signState == EpidemicZoneSignState.StateMatchSuc and roleGroup == EpidemicZoneRole.Farmer and myPlayerState ~= EpidemicZonePlayerState.None and not self:GetRedState(LittleRedConst.NameActEpidemicMainContact, i)
      if showContactRed then
        contactCnt = 1
      end
      local showEnterRed = false
      if myPlayerState ~= EpidemicZonePlayerState.None then
        if fixStage == EpidemicZoneStage.Prepare then
          showEnterRed = myPlayerState == EpidemicZonePlayerState.Main and not self:GetRedState(LittleRedConst.NameActEpidemicMainFight, i)
        elseif fixStage == EpidemicZoneStage.Battle then
          showEnterRed = not self:GetRedState(LittleRedConst.NameActEpidemicMainFight, i)
        end
      end
      if showEnterRed then
        enterCnt = 1
      end
      local showArbiter = signState == EpidemicZoneSignState.StateMatchSuc and roleGroup == EpidemicZoneRole.Lord and ActEpidemicUtils.GetArbiterByGroupId(i) == nil and (fixStage == EpidemicZoneStage.MatchEnd or fixStage == EpidemicZoneStage.Prepare or fixStage == EpidemicZoneStage.Battle) and ActEpidemicUtils.CanAssignArbiter()
      if showArbiter then
        arbiterCnt = 1
      end
      local comCount = DataCenter.ActEpidemicZoneManager:GetCommanderNum(i)
      local showCommander = (signState == EpidemicZoneSignState.StateMatchSuc or signState == EpidemicZoneSignState.StateSignSuc) and fixStage < EpidemicZoneStage.Show and comCount == 0 and ActEpidemicUtils.CanChangeBattlePlayer() and not self:GetRedState(LittleRedConst.NameActEpidemicMainCommanderNotSet, i)
      if showCommander then
        commanderCnt = commanderCnt + 1
      end
    end
    self:MarkRed(LittleRedConst.NameActEpidemicMain, LittleRedConst.NameActEpidemicMainApply, i, signCnt)
    self:MarkRed(LittleRedConst.NameActEpidemicMain, LittleRedConst.NameActEpidemicMainFight, i, enterCnt)
    self:MarkRed(LittleRedConst.NameActEpidemicMain, LittleRedConst.NameActEpidemicMainArbiterNotSet, i, arbiterCnt)
    self:MarkRed(LittleRedConst.NameActEpidemicOther, LittleRedConst.NameActEpidemicMainCommanderNotSet, i, commanderCnt)
    self:MarkRed(LittleRedConst.NameActEpidemicOther, LittleRedConst.NameActEpidemicMainContact, i, contactCnt)
  end
end

function ActEpidemicZoneManager:RequestActivityModifyTeamState(open)
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneActModifyTeamState, open)
end

function ActEpidemicZoneManager:HandleActivityModifyTeamStateMessage(msg)
  self:RequestActivityInfo()
  EventManager:GetInstance():Broadcast(EventId.EpidemicActTeamBStateChanged)
end

function ActEpidemicZoneManager:RequestActivityBattleHistory()
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneActBattleHistory, self.battleHistory and self.battleHistory:GetLastCreateTime() or 0)
end

function ActEpidemicZoneManager:HandleActivityBattleHistory(msg)
  self.battleHistory = self.battleHistory or ActEpidemicZoneActivityBattleHistory.New()
  self.battleHistory:Update(msg)
  EventManager:GetInstance():Broadcast(EventId.EpidemicActBattleHistoryList)
end

function ActEpidemicZoneManager:RequestActivityOperateLogList()
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneActOperateLogList)
end

function ActEpidemicZoneManager:HandleActivityOperateLogListMessage(msg)
  local dataList = msg.data
  if not dataList then
    self.operateLog = nil
    EventManager:GetInstance():Broadcast(EventId.EpidemicActOnGetOperateList)
    return
  end
  if not self.operateLog then
    self.operateLog = {}
  end
  local temp = {}
  local count = math.max(#self.operateLog, #dataList)
  for i = 1, count do
    local _data = dataList[i]
    local log = self.operateLog[i]
    if _data and _data.type ~= EpidemicOperateLogType.ArbiterRemove then
      log = log or {}
      log.type = _data.type
      log.time = _data.time
      log.params = _data.params
      table.insert(temp, log)
    else
      break
    end
  end
  self.operateLog = temp
  EventManager:GetInstance():Broadcast(EventId.EpidemicActOnGetOperateList)
end

function ActEpidemicZoneManager:RequestActivityPlayerList()
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneActPlayerList)
  self:ReqCommanderList()
end

function ActEpidemicZoneManager:HandleActivityPlayerListMessage(msg)
  if not self.playerList then
    self.playerList = ActEpidemicZoneActivityPlayerList.New()
  end
  self.playerList:UpdateAll(msg)
end

function ActEpidemicZoneManager:RequestActivityChangeBattleTime(group, battlePeriod)
  if not self.actInfo then
    ActEpidemicUtils.Error("\230\180\187\229\138\168\228\191\161\230\129\175\230\156\170\229\176\177\231\187\170\239\188\129")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneActChangeBattleTime, group, battlePeriod)
end

function ActEpidemicZoneManager:HandleActChangeBattleTimeMessage(msg)
  self.actInfo:UpdateSignUpState(msg.group, nil, msg.battlePeriod)
  self:RequestActivityInfo()
end

function ActEpidemicZoneManager:RequestActivitySignUp(group, role, battlePeriod)
  if not self.actInfo then
    ActEpidemicUtils.Error("\230\180\187\229\138\168\228\191\161\230\129\175\230\156\170\229\176\177\231\187\170\239\188\129")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneActSignUp, group, role, battlePeriod)
end

function ActEpidemicZoneManager:HandleActivitySignUpMessage(msg)
  self.actInfo:UpdateSignUpState(msg.group, msg.role, msg.battlePeriod)
  EventManager:GetInstance():Broadcast(EventId.EpidemicActChangeRoleSuccess, {
    group = msg.group,
    role = msg.role
  })
  self:RequestActivityInfo()
end

function ActEpidemicZoneManager:RequestActivityPlayerInfo()
  if not self.actInfo then
    ActEpidemicUtils.Error("\230\180\187\229\138\168\228\191\161\230\129\175\230\156\170\229\176\177\231\187\170\239\188\129")
    return
  end
  local groupIdx = self:GetMyGroupIdx()
  if groupIdx == 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.EpidemicZoneActPlayerInfo, groupIdx)
end

function ActEpidemicZoneManager:HandleActivityPlayerInfoMessage(msg)
  if not self.myScoreRankInfo then
    self.myScoreRankInfo = ActEpidemicZoneActivityMyScoreRankInfoInfo.New()
  end
  self.myScoreRankInfo:Update(msg)
  EventManager:GetInstance():Broadcast(EventId.EpidemicActBattleMyScoreRankChanged)
end

function ActEpidemicZoneManager:GetMyScoreRankInfo()
  return self.myScoreRankInfo
end

local rewardType2prop = {
  [EpidemicRankRewardType.TotalScore] = "total_score_ranking_reward",
  [EpidemicRankRewardType.BattleScore] = "battle_score_ranking_reward",
  [EpidemicRankRewardType.Cooperation] = "cooperation_score_ranking_reward",
  [EpidemicRankRewardType.Tactics] = "tactics_score_ranking_reward"
}
local roleReward2prop = {
  [EpidemicZoneRole.Farmer] = 101,
  [EpidemicZoneRole.Lord] = 201
}

function ActEpidemicZoneManager:GetRankBattleReward(role, rewardType)
  local id = roleReward2prop[role]
  local name = rewardType2prop[rewardType]
  if not id or not name then
    ActEpidemicUtils.LogError("Get rank battle reward failed. Role:%s, rewardType:%s", role, rewardType)
    return {}
  end
  if not self.rankRewardCache then
    self.rankRewardCache = {}
  end
  local _targetKey = role * 1000 + rewardType
  if not self.rankRewardCache[_targetKey] then
    local _ = {}
    local tbName = self:GetCfgValue(BattleFieldTableKey.REWARD)
    local line = LocalController:instance():getLine(tbName, id)
    if not line then
      ActEpidemicUtils.LogError("Get rank battle reward line failed. Role:%s, rewardType:%s", role, rewardType)
      self.rankRewardCache[_targetKey] = _
      return _
    end
    local _key
    for k, v in pairs(rewardType2prop) do
      _key = role * 1000 + k
      local ranks = {}
      self.rankRewardCache[_key] = ranks
      local _str = line[v]
      local _line1 = string.split_ss_array(_str, "|")
      for _, rankAndReward in ipairs(_line1) do
        local rankItem = {}
        local rankAndRewardArray = string.split_ss_array(rankAndReward, ";")
        if 2 <= #rankAndRewardArray then
          rankItem.rewardId = tonumber(rankAndRewardArray[2])
          local _lvs = string.split_ii_array(rankAndRewardArray[1], "-")
          rankItem.from = _lvs and _lvs[1] or 0
          rankItem.to = _lvs and _lvs[2] or rankItem.from
        end
        table.insert(ranks, rankItem)
      end
    end
  end
  if not self.rankRewardCache[_targetKey] then
    self.rankRewardCache[_targetKey] = {}
    ActEpidemicUtils.LogError("Get rank battle reward data failed. Role:%s, rewardType:%s", role, rewardType)
  end
  return self.rankRewardCache[_targetKey]
end

function ActEpidemicZoneManager:GetTeamWinnerRewards(teamType, roleType)
  local id = roleReward2prop[roleType]
  if not self.winnerRewardCache then
    self.winnerRewardCache = {}
  end
  if not self.winnerRewardCache[id] then
    local _id = roleReward2prop[EpidemicZoneRole.Farmer]
    self.winnerRewardCache[_id] = {}
    local tbName = self:GetCfgValue(BattleFieldTableKey.REWARD)
    local line = LocalController:instance():getLine(tbName, _id)
    if line then
      local _ = {}
      self.winnerRewardCache[_id][EpidemicTeamRewardType.AB] = _
      table.insert(_, {
        rewardId = line.win_alliance_reward,
        alliance = true,
        win = true
      })
      table.insert(_, {
        rewardId = line.lose_alliance_reward,
        alliance = true,
        win = false
      })
      _ = {}
      self.winnerRewardCache[_id][EpidemicTeamRewardType.A] = _
      table.insert(_, {
        rewardId = line.win_alliance_reward_abandonB,
        alliance = true,
        win = true
      })
      table.insert(_, {
        rewardId = line.lose_alliance_reward_abandonB,
        alliance = true,
        win = false
      })
    end
    _id = roleReward2prop[EpidemicZoneRole.Lord]
    self.winnerRewardCache[_id] = {}
    line = LocalController:instance():getLine(tbName, _id)
    if line then
      local _ = {}
      self.winnerRewardCache[_id][EpidemicTeamRewardType.AB] = _
      table.insert(_, {
        rewardId = line.win_alliance_reward,
        alliance = true,
        win = true
      })
      table.insert(_, {
        rewardId = line.lose_alliance_reward,
        alliance = true,
        win = false
      })
      _ = {}
      self.winnerRewardCache[_id][EpidemicTeamRewardType.A] = _
      table.insert(_, {
        rewardId = line.win_alliance_reward_abandonB,
        alliance = true,
        win = true
      })
      table.insert(_, {
        rewardId = line.lose_alliance_reward_abandonB,
        alliance = true,
        win = false
      })
    end
  end
  if not self.winnerRewardCache[id] then
    self.winnerRewardCache[id] = {}
  end
  return self.winnerRewardCache[id][teamType]
end

function ActEpidemicZoneManager:GetBattleHistory()
  return self.battleHistory
end

function ActEpidemicZoneManager:CheckAllianceIsValid()
  local groupInfo = self:GetCurGroup()
  if groupInfo and (groupInfo.state == EpidemicZoneSignState.StateSignSuc or groupInfo.state == EpidemicZoneSignState.StateMatchSuc) then
    return true
  end
end

function ActEpidemicZoneManager:CheckSelfAssigned()
  if self.actInfo then
    return self.actInfo.selfAssigned ~= EpidemicZonePlayerState.None
  end
end

function ActEpidemicZoneManager:GetScoreRewardsBySide(side)
  local role = ActEpidemicUtils.GetRole(side)
  local id = roleReward2prop[role]
  if not self.scoreRewardsCache then
    self.scoreRewardsCache = {}
  end
  if not self.scoreRewardsCache[id] then
    local tbName = self:GetCfgValue(BattleFieldTableKey.REWARD)
    local _id = roleReward2prop[EpidemicZoneRole.Farmer]
    local line = LocalController:instance():getLine(tbName, _id)
    if line then
      self.scoreRewardsCache[_id] = string.string2table_ii_toList(line.score_reward, ",", ";")
    end
    _id = roleReward2prop[EpidemicZoneRole.Lord]
    line = LocalController:instance():getLine(tbName, _id)
    if line then
      self.scoreRewardsCache[_id] = string.string2table_ii_toList(line.score_reward, ",", ";")
    end
  end
  if not self.scoreRewardsCache[id] then
    self.scoreRewardsCache[id] = {}
  end
  return self.scoreRewardsCache[id]
end

function ActEpidemicZoneManager:GetNextOperateTeamBSec()
  local info = self:GetActInfo()
  if not info then
    return 0
  end
  local curT = UITimeManager:GetInstance():GetServerSeconds()
  local gap = info.groupCloseEndTime - curT
  return 0 < gap and gap or 0
end

function ActEpidemicZoneManager:GetBattleMemberLimitCount()
  if not self.battleMemberLimit then
    local str = LuaEntry.DataConfig:TryGetStr("YiBianJinQu", "k6", "0,0,0")
    self.battleMemberLimit = string.string2array_i_oneSep(str, ",")
  end
  return self.battleMemberLimit[1], self.battleMemberLimit[2], self.battleMemberLimit[3]
end

function ActEpidemicZoneManager:OnLeaveAlliance()
  self:ResetData()
  self:RequestActivityInfo()
end

function ActEpidemicZoneManager:Description()
  local sb = StringBuilder.New()
  sb:AppendLine("--\230\150\176\229\134\160\230\136\152\229\156\186--")
  sb:AppendLine("--\230\180\187\229\138\168\228\191\161\230\129\175 (ActEpidemicZoneActivityInfo)--")
  if self.actInfo == nil then
    sb:AppendLine("[!!!] \230\178\161\230\156\137\230\180\187\229\138\168\228\191\161\230\129\175")
  else
    sb:AppendLine(self.actInfo:Description())
  end
  sb:AppendLine("--\230\180\187\229\138\168\230\136\144\229\145\152\228\191\161\230\129\175 (ActEpidemicZoneActivityPlayerList)--")
  if self.playerList == nil then
    sb:AppendLine("[!!!]\230\178\161\230\156\137\230\136\144\229\145\152\228\191\161\230\129\175")
  else
    sb:AppendLine(self.playerList:Description())
  end
  sb:AppendLine("---\230\136\145\231\154\132\228\191\161\230\129\175---")
  local myInfo = ActEpidemicUtils.GetMyInfo()
  if not myInfo then
    sb:AppendLine("\230\137\190\228\184\141\229\136\176\230\136\145\231\154\132\228\191\161\230\129\175")
  else
    sb:Append(myInfo:Description())
  end
  sb:AppendLine("---\230\136\145\231\154\132\230\142\146\229\144\141\229\146\140\231\167\175\229\136\134---")
  if not self.myScoreRankInfo then
    sb:AppendLine("\230\137\190\228\184\141\229\136\176\228\191\161\230\129\175")
  else
    sb:AppendFormatLine(self.myScoreRankInfo:Description())
  end
  sb:AppendLine("---\230\147\141\228\189\156\232\174\176\229\189\149---")
  if not self.operateLog then
    sb:AppendLine("\230\137\190\228\184\141\229\136\176\230\147\141\228\189\156\232\174\176\229\189\149")
  else
    sb:AppendFormatLine("\230\147\141\228\189\156\232\174\176\229\189\149\230\149\176\233\135\143:%s", #self.operateLog)
    for k, v in ipairs(self.operateLog) do
      sb:AppendFormatLine("[%s]type%s, time:%s, params:%s", k, v.type, UITimeManager:GetInstance():ConvertServerTimeToLocalTime(v.time * 1000), v.params)
    end
  end
  sb:AppendLine("\230\136\152\230\150\151\229\142\134\229\143\178")
  if not self.battleHistory then
    sb:AppendLine("\230\137\190\228\184\141\229\136\176\230\147\141\228\189\156\232\174\176\229\189\149")
  else
    sb:AppendFormatLine(PrettyPrintTable(self.battleHistory))
  end
  sb:AppendLine("\231\186\162\231\130\185Key")
  for i = 1, 2 do
    local group = i == 1 and "A" or "B"
    sb:AppendFormatLine("Apply%s:%s = %s", group, self:GetRedKey(LittleRedConst.NameActEpidemicMainApply, i), CommonUtil.PlayerPrefsGetBool(self:GetRedKey(LittleRedConst.NameActEpidemicMainApply, i)))
    sb:AppendFormatLine("Fight%s:%s = %s", group, self:GetRedKey(LittleRedConst.NameActEpidemicMainFight, i), CommonUtil.PlayerPrefsGetBool(self:GetRedKey(LittleRedConst.NameActEpidemicMainFight, i)))
    sb:AppendFormatLine("Content%s:%s = %s", group, self:GetRedKey(LittleRedConst.NameActEpidemicMainContact, i), CommonUtil.PlayerPrefsGetBool(self:GetRedKey(LittleRedConst.NameActEpidemicMainContact, i)))
    sb:AppendFormatLine("LordSkill%s:%s = %s", group, self:GetRedKey(LittleRedConst.NameActEpidemicMainLordSkill, i), CommonUtil.PlayerPrefsGetBool(self:GetRedKey(LittleRedConst.NameActEpidemicMainLordSkill, i)))
  end
  local farmRoomId = ActEpidemicUtils.TryGetFarmerRoom()
  if farmRoomId then
    sb:AppendFormatLine("\229\134\156\230\176\145\230\136\191:%s", farmRoomId)
  end
  return sb:ToString()
end

BattleFieldUtil.MergeFunctions(ActEpidemicZoneManager, "DataCenter.ActEpidemicZoneManager.Module.BuildInfo")
BattleFieldUtil.MergeFunctions(ActEpidemicZoneManager, "DataCenter.ActEpidemicZoneManager.Module.EnterBattle")
Implement(ActEpidemicZoneManager, InterfaceConfig.BattlefieldManager, InterfaceConfig.Describable, InterfaceConfig.BattlefieldEnterCheck)
return ActEpidemicZoneManager
