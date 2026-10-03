local SeasonFactionWarDataManager = BaseClass("SeasonFactionWarDataManager")
local Localization = CS.GameEntry.Localization

function SeasonFactionWarDataManager:__init()
  self.StepText = {
    "season_s2_faction_war_07",
    "season_s2_faction_war_08",
    "season_s2_faction_war_09",
    "season_s2_faction_war_10",
    "season_s2_faction_war_11",
    "season_s2_faction_war_12"
  }
  self.lastRequestServerDataTime = 0
  self.currStep = nil
  self.stepEndTime = nil
  self.attackCampId = 0
  self.defenceCampId = 0
  self.myCampId = 0
  self.warInfo = {}
  self.theDefenderList = {}
  self.theAttackerList = {}
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterWorld, self.OnEnterWorld, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterCity, self.OnEnterCity, self)
end

function SeasonFactionWarDataManager:__delete()
  EventManager:GetInstance():RemoveListener2(EventId.OnEnterWorld, self.OnEnterWorld, self)
  EventManager:GetInstance():RemoveListener2(EventId.OnEnterCity, self.OnEnterCity, self)
end

function SeasonFactionWarDataManager:GetPlunderRatio()
  local seasonType = SeasonUtil.GetSeasonType()
  local factionWarActivityType = SeasonUtil.GetFactionWarActivityType(seasonType)
  if SeasonUtil.SeasonHasMilitaryCenterAttachment(seasonType) then
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(factionWarActivityType)
    local actData = dataList[1]
    if actData and actData.para_3 then
      local num1, num2 = string.split_ii(actData.para_3, "|")
      return (toInt(num1) + toInt(num2) * 4) / 100
    end
  elseif seasonType == SeasonMapType.Snow then
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonFactionBigWarActivity.Type)
    local actData = dataList[1]
    if actData ~= nil then
      local num = toInt(actData.para_1)
      if 0 < num then
        return num / 100
      end
    end
    dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonFactionDeclareWarActivity.Type)
    actData = dataList[1]
    if actData and actData.para_3 then
      return toInt(actData.para_3) / 100
    end
  end
  return 0
end

function SeasonFactionWarDataManager:InitData()
  local seasonType = SeasonUtil.GetSeasonType(true, true)
  if seasonType == SeasonMapType.NineNationRainforest then
    SFSNetwork.SendMessage(MsgDefines.GetSeasonFactionInfo)
    self.lastRequestServerDataTime = UITimeManager:GetInstance():GetServerTime()
  elseif SeasonUtil.SeasonHasFactionWar(seasonType) and SeasonUtil.IsInSeason() then
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionVsInfo)
    SFSNetwork.SendMessage(MsgDefines.GetSeasonFactionInfo)
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareWarInfo)
    self.lastRequestServerDataTime = UITimeManager:GetInstance():GetServerTime()
  end
end

function SeasonFactionWarDataManager:OnEnterWorld()
  local seasonType = SeasonUtil.GetSeasonType(true, true)
  if seasonType == SeasonMapType.NineNationRainforest then
    if self.myCampId == 0 then
      SFSNetwork.SendMessage(MsgDefines.GetSeasonFactionInfo)
    end
  elseif SeasonUtil.SeasonHasFactionWar(seasonType) then
    if DataCenter.SeasonFactionWarDataManager.currStep == nil then
      DataCenter.SeasonFactionWarDataManager:InitData()
    else
      DataCenter.SeasonFactionWarDataManager:CalcStepAndStepTime()
    end
  end
end

function SeasonFactionWarDataManager:OnEnterCity()
  local seasonType = SeasonUtil.GetSeasonType(true, true)
  if seasonType == SeasonMapType.NineNationRainforest then
    if self.myCampId == 0 then
      SFSNetwork.SendMessage(MsgDefines.GetSeasonFactionInfo)
    end
  elseif SeasonUtil.SeasonHasFactionWar(seasonType) then
    if DataCenter.SeasonFactionWarDataManager.currStep == nil then
      DataCenter.SeasonFactionWarDataManager:InitData()
    else
      DataCenter.SeasonFactionWarDataManager:CalcStepAndStepTime()
    end
  end
end

function SeasonFactionWarDataManager:UpdateAttackGroupInfo(defender, attacker)
  if defender and attacker then
    self.theDefenderList = {}
    self.theAttackerList = {}
    for i, aid in ipairs(defender) do
      if i == 1 then
        self.defenderAllianceId = aid
      end
      self.theDefenderList[aid] = aid
    end
    for _, aid in ipairs(attacker) do
      self.theAttackerList[aid] = aid
    end
  end
end

function SeasonFactionWarDataManager:CanJoinAttack(allianceId)
  if self.dataList1 and self.dataList2 then
    for k, v in ipairs(self.dataList1) do
      if v and v.allianceId == allianceId then
        return true
      end
    end
    for k, v in ipairs(self.dataList2) do
      if v and v.allianceId == allianceId then
        return true
      end
    end
    return false
  else
    return true
  end
end

function SeasonFactionWarDataManager:CanAttackAllianceBuild(buildId, buildAllianceId)
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  if myAllianceId == buildAllianceId then
    return false
  end
  self:CalcStepAndStepTime()
  if SeasonUtil.IsSeasonMilitaryCenterCarrier(buildId) then
    return true
  end
  if SeasonUtil.IsSeasonMilitaryCenterOrPlugin(buildId) then
    if self.currStep ~= SeasonFactionDeclareWarStep.battle then
      return false
    end
    return self.theDefenderList[buildAllianceId] ~= nil and self.theAttackerList[myAllianceId] ~= nil
  end
  return myAllianceId ~= buildAllianceId
end

function SeasonFactionWarDataManager:CanAssistAllianceBuild(buildId, buildAllianceId)
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  if myAllianceId == buildAllianceId then
    return true
  end
  if SeasonUtil.IsSeasonMilitaryCenterOrPlugin(buildId) then
    self:CalcStepAndStepTime()
    if self.currStep ~= SeasonFactionDeclareWarStep.battle_before and self.currStep ~= SeasonFactionDeclareWarStep.battle then
      return myAllianceId == buildAllianceId
    end
    return self.theDefenderList[buildAllianceId] and self.theDefenderList[myAllianceId]
  end
  return myAllianceId == buildAllianceId
end

function SeasonFactionWarDataManager:CanMoveCityTo(serverId)
  self:CalcStepAndStepTime()
  if self.currStep == SeasonFactionDeclareWarStep.battle_before or self.currStep == SeasonFactionDeclareWarStep.battle then
    return not self:ServerIsAttacker(serverId)
  end
  return false
end

function SeasonFactionWarDataManager:GetDeclareWarActInfo()
  return self.declareWarActObj
end

function SeasonFactionWarDataManager:GetCurrStep()
  self:CalcStepAndStepTime()
  return self.currStep
end

function SeasonFactionWarDataManager:UpdateStepAndStepTime(currStep, stepEndTime)
  if currStep and stepEndTime then
    self.currStep = currStep
    self.stepEndTime = stepEndTime
    EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionBattleInfoUpdate)
  end
end

function SeasonFactionWarDataManager:CalcStepAndStepTime()
  if self.currStep and self.stepEndTime then
    if self.cfgStepDuration == nil then
      local theSeasonType = SeasonUtil.GetSeasonType()
      local dataList
      local factionWarActivityType = SeasonUtil.GetFactionWarActivityType(theSeasonType)
      if factionWarActivityType ~= 0 then
        dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(factionWarActivityType)
      end
      if dataList ~= nil and 0 < #dataList then
        local data = dataList[1]
        if data then
          local stepDeclare, stepInvite, stepPreparation, stepBattle1v1, stepBattle1v2, stepBattle1v3
          local tmp = string.split(data.para_1, "|")
          if tmp and #tmp == 3 then
            stepDeclare, stepInvite, stepPreparation = toInt(tmp[1]), toInt(tmp[2]), toInt(tmp[3])
          end
          tmp = string.split(data.para_2, "|")
          if tmp and #tmp == 3 then
            stepBattle1v1, stepBattle1v2, stepBattle1v3 = toInt(tmp[1]), toInt(tmp[2]), toInt(tmp[3])
          end
          self.cfgStepDuration = {
            stepDeclare,
            stepInvite,
            stepPreparation,
            stepBattle1v1,
            stepBattle1v2,
            stepBattle1v3
          }
        end
      end
    end
    if self.cfgStepDuration ~= nil then
      local now = UITimeManager:GetInstance():GetServerTime()
      if now >= self.stepEndTime then
        if self.currStep == SeasonFactionDeclareWarStep.declare_before then
          self.currStep = SeasonFactionDeclareWarStep.declare
          self.stepEndTime = self.stepEndTime + toInt(self.cfgStepDuration[1]) * 1000
        elseif self.currStep == SeasonFactionDeclareWarStep.declare then
          self.currStep = SeasonFactionDeclareWarStep.invite
          self.stepEndTime = self.stepEndTime + toInt(self.cfgStepDuration[2]) * 1000
        elseif self.currStep == SeasonFactionDeclareWarStep.invite then
          self.currStep = SeasonFactionDeclareWarStep.battle_before
          self.stepEndTime = self.stepEndTime + toInt(self.cfgStepDuration[3]) * 1000
        elseif self.currStep == SeasonFactionDeclareWarStep.battle_before then
          self.currStep = SeasonFactionDeclareWarStep.battle
          local theDefenderCount = table.count(self.theDefenderList)
          local theAttackerCount = table.count(self.theAttackerList)
          local diff = theAttackerCount - theDefenderCount
          if diff == 0 then
            self.stepEndTime = self.stepEndTime + toInt(self.cfgStepDuration[4]) * 1000
          elseif diff == 1 then
            self.stepEndTime = self.stepEndTime + toInt(self.cfgStepDuration[5]) * 1000
          elseif diff == 2 then
            self.stepEndTime = self.stepEndTime + toInt(self.cfgStepDuration[6]) * 1000
          end
        end
        if now - toInt(self.lastRequestServerDataTime) > OneHourTime then
          self:InitData()
        end
      end
    end
  end
end

function SeasonFactionWarDataManager:GetGroupingActInfo()
  return self.groupingActInfo
end

function SeasonFactionWarDataManager:GetGroupingData()
  if self.seasonFactionInfo == nil then
    local data = {}
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local seasonInfo = SeasonUtil.GetSeasonInfo(mySourceServerId)
    if seasonInfo and seasonInfo.campInfo and seasonInfo:GetServerSubdivisionType(false) == SeasonMapType.NineNationRainforest then
      for _, v in ipairs(seasonInfo.campInfo) do
        if v.campId == SeasonFactionType.Rebels or v.campId == SeasonFactionType.Gendarmerie then
          table.insert(data, v)
          local kingInfo = DataCenter.GovernmentManager:GetCrossServerKingInfo(v.serverId)
          if kingInfo and kingInfo.badges then
            v.cfgId = kingInfo.badges.cfgId
          end
        end
      end
    end
    self.seasonFactionInfo = data
  end
  return self.seasonFactionInfo
end

function SeasonFactionWarDataManager:GetMyGroupingServer()
  local serverList = {}
  if self.seasonFactionInfo then
    local myCampId = self.myCampId
    for _, v in pairs(self.seasonFactionInfo) do
      if v.campId == myCampId then
        table.insert(serverList, v.serverId)
      end
    end
  else
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    table.insert(serverList, mySourceServerId)
  end
  table.sort(serverList)
  return serverList
end

function SeasonFactionWarDataManager:IsGroupingShownMode()
  if self.groupingMode == true then
    return false
  end
  local campInfo = self.seasonFactionInfo
  local groupingActInfo = self.groupingActInfo
  local seasonType = SeasonUtil.GetSeasonType()
  if SeasonUtil.SeasonHasCampMasterServer(seasonType) then
    if groupingActInfo then
      if groupingActInfo.hasSubStep then
        if groupingActInfo.subStep == 0 then
          return false
        else
          return false
        end
      else
        return groupingActInfo.step == 1
      end
    elseif campInfo then
    end
  end
  if campInfo ~= nil and campInfo[1] and toInt(campInfo[1].campId) ~= 0 and (groupingActInfo == nil or groupingActInfo.step == 1) then
    return true
  end
  return false
end

function SeasonFactionWarDataManager:GetCampIdByServerId(theServerId)
  local campInfo = self.seasonFactionInfo
  if campInfo then
    local serverId = toInt(theServerId)
    if serverId ~= 0 then
      for _, v in ipairs(campInfo) do
        if serverId == v.serverId then
          return v.campId or 0
        end
      end
    end
  end
  return 0
end

function SeasonFactionWarDataManager:GetCampIdByServerId_Pro(theServerId)
  local seasonInfo = SeasonUtil.GetSeasonInfo(theServerId)
  if seasonInfo then
    return seasonInfo:GetCampIdByServerId(theServerId)
  end
  return 0
end

function SeasonFactionWarDataManager:GetServerIdListByCampId(campId)
  local ret = {}
  local campInfo = self.seasonFactionInfo
  if campInfo then
    for _, v in pairs(campInfo) do
      if campId == v.campId then
        table.insert(ret, v.serverId)
      end
    end
    table.sort(ret, function(a, b)
      return a < b
    end)
  end
  return ret
end

function SeasonFactionWarDataManager:IsInSameCampByServer(serverIdA, serverIdB)
  serverIdB = serverIdB or LuaEntry.Player:GetSourceServerId()
  if serverIdA == serverIdB then
    return true
  end
  local campIdA = self:GetCampIdByServerId(serverIdA)
  local campIdB = self:GetCampIdByServerId(serverIdB)
  return campIdA ~= 0 and campIdA == campIdB
end

function SeasonFactionWarDataManager:IsSameCampOrSameAllianceOrMe(serverId, allianceId, uid)
  if LuaEntry.Player:GetUid() == uid then
    return true
  end
  if LuaEntry.Player:IsInAlliance() and LuaEntry.Player:GetAllianceUid() == allianceId then
    return true
  end
  if self:IsInSameCampByServer(serverId) then
    return true
  end
  return false
end

function SeasonFactionWarDataManager:CampInfoToString()
  local ret = ""
  local campInfo = self.seasonFactionInfo
  if campInfo then
    for _, v in ipairs(campInfo) do
      ret = ret .. string.format(",%s-%s", v.serverId, v.campId)
    end
  end
  return ret
end

function SeasonFactionWarDataManager:ServerIsAttacker(theServerId)
  if self.attackCampId ~= 0 then
    local serverId = toInt(theServerId)
    if self.myCampId ~= 0 and serverId == LuaEntry.Player:GetSourceServerId() then
      return self.myCampId == self.attackCampId
    end
    local campId = self:GetCampIdByServerId(theServerId)
    if campId ~= 0 then
      return self.attackCampId == campId
    end
  end
  return false
end

function SeasonFactionWarDataManager:CampIsAttacker(campId)
  if self.attackCampId ~= 0 then
    return self.attackCampId == toInt(campId)
  end
  return false
end

function SeasonFactionWarDataManager:GetCampIcon(campId, big)
  local theCampId = toInt(campId)
  local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.Source)
  if big then
    if seasonType == SeasonMapType.NineNationRainforest then
      if theCampId == SeasonFactionType.Rebels then
        return "Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_icon_zhenying01_mid.png"
      end
      if theCampId == SeasonFactionType.Central then
        return "Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_icon_zhenying03_mid.png"
      end
      return "Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_icon_zhenying02_mid.png"
    end
    if seasonType == SeasonMapType.Darkness then
      if theCampId == 1 then
        return "Assets/Main/SeasonRes/S4/Sprites/Common/ljq_s4_zhenying_1_mid.png"
      end
      return "Assets/Main/SeasonRes/S4/Sprites/Common/ljq_s4_zhenying_2_mid.png"
    end
    if seasonType == SeasonMapType.Mummy then
      if theCampId == 1 then
        return "Assets/Main/SeasonRes/S3/Sprites/UI/FactionDeclareWar/ljq_s3_zhenying_huizhang_02.png"
      end
      return "Assets/Main/SeasonRes/S3/Sprites/UI/FactionDeclareWar/ljq_s3_zhenying_huizhang_01.png"
    end
    if theCampId == SeasonFactionType.Rebels then
      return "Assets/Main/Sprites/UI/UISeason/UISeason2/SeasonRank/ljq_s2_zhenying_huizhang_02.png"
    end
    return "Assets/Main/Sprites/UI/UISeason/UISeason2/SeasonRank/ljq_s2_zhenying_huizhang_01.png"
  end
  if seasonType == SeasonMapType.NineNationRainforest then
    if theCampId == SeasonFactionType.Rebels then
      return "Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_icon_zhenying01_icon.png"
    end
    if theCampId == SeasonFactionType.Central then
      return "Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_icon_zhenying03_icon.png"
    end
    return "Assets/Main/SeasonRes/S6/Sprites/CommonS6/ljq_s6_icon_zhenying02_icon.png"
  end
  if seasonType == SeasonMapType.Darkness then
    if theCampId == SeasonFactionType.Rebels then
      return "Assets/Main/SeasonRes/S4/Sprites/Common/ljq_s4_zhenying_1.png"
    end
    return "Assets/Main/SeasonRes/S4/Sprites/Common/ljq_s4_zhenying_2.png"
  end
  if seasonType == SeasonMapType.Mummy then
    if theCampId == SeasonFactionType.Rebels then
      return "Assets/Main/SeasonRes/S3/Sprites/UI/LWCommon/ljq_s3_zhenying_1.png"
    end
    return "Assets/Main/SeasonRes/S3/Sprites/UI/LWCommon/ljq_s3_zhenying_2.png"
  end
  if theCampId == SeasonFactionType.Rebels then
    return "Assets/Main/Sprites/UI/UISeason/UISeason2/Faction/mjc_s2_zhenying_fankangjun.png"
  end
  return "Assets/Main/Sprites/UI/UISeason/UISeason2/Faction/mjc_s2_zhenying_xianbingtuan.png"
end

function SeasonFactionWarDataManager:GetCampName(campId)
  local theCampId = toInt(campId)
  local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.Source)
  if seasonType == SeasonMapType.NineNationRainforest then
    if theCampId == SeasonFactionType.Rebels then
      return Localization:GetString("season_s6_activity_1200080_title03")
    end
    if theCampId == SeasonFactionType.Central then
      return Localization:GetString("s6_map_ui_07")
    end
    return Localization:GetString("season_s6_activity_1200080_title04")
  end
  if seasonType == SeasonMapType.Mummy then
    if theCampId == SeasonFactionType.Rebels then
      return Localization:GetString("season_s3_activity_1000063_desc10")
    end
    return Localization:GetString("season_s3_activity_1000063_desc11")
  end
  if theCampId == SeasonFactionType.Rebels then
    return Localization:GetString("season_s2_faction_war_03")
  end
  return Localization:GetString("season_s2_faction_war_04")
end

function SeasonFactionWarDataManager:OnBattleFinish(t)
  self:InitData()
  local theWorld = CS.SceneManager.World
  if t == nil or t.vsInfo == nil or t.result == nil or t.result == 0 or t.startTime == nil or theWorld == nil or not SceneUtils.GetIsInWorld() then
    return
  end
  local seasonType = SeasonUtil.GetSeasonType()
  local pointId = 0
  local buildServerId = 0
  local hasEffect = false
  local buildId = SeasonUtil.GetSeasonMilitaryCenterId(seasonType)
  if self.s3BuildInfo and self.s3BuildInfo.buildList then
    for k, v in pairs(self.s3BuildInfo.buildList) do
      if v and v.buildId == buildId then
        pointId = v.pointId
        buildServerId = v.buildServerId
        break
      end
    end
  else
    local furnaceInfo = self.defenderFurnaceInfo
    if furnaceInfo == nil and self.warInfo and self.warInfo.furnaceInfo then
      furnaceInfo = self.warInfo.furnaceInfo
    end
    if furnaceInfo ~= nil then
      pointId = furnaceInfo.pointId
      buildServerId = furnaceInfo.buildServerId
    end
  end
  local curServerId = LuaEntry.Player:GetCurServerId()
  pcall(function()
    local boomStatus = 0
    if t.result == 2 and pointId ~= nil and pointId ~= 0 and buildServerId == curServerId then
      local modelPath = "Assets/Main/Prefabs/AllianceBuilding/allianceBuilding_s2_boom.prefab"
      local request = CS.GameEntry.Resource:InstantiateAsync(modelPath)
      request:completed("+", function()
        local world = CS.SceneManager.World
        if request.isError or world == nil then
          request:Destroy()
          return
        end
        request.gameObject:SetActive(true)
        request.gameObject.transform:SetParent(world.DynamicObjNode)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        request.gameObject.transform.position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, curServerId)
        TimerManager:GetInstance():DelayInvoke(function()
          request:Destroy()
        end, 7)
      end)
      hasEffect = true
      boomStatus = 1
    else
      boomStatus = 2
    end
    Logger.LogInfo(string.format("FactionWar BattleFinish result = %s , pointId = %s , s1 = %s , s2 = %s , boom = %s", tostring(t.result), tostring(pointId), tostring(buildServerId), tostring(curServerId), boomStatus))
  end)
  if t and (t.result == 1 or t.result == 2) then
    if seasonType == SeasonMapType.Snow then
      if hasEffect then
        local battleData = t
        TimerManager:GetInstance():DelayInvoke(function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarSuccess, {anim = true}, battleData)
        end, 3.33)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarSuccess, {anim = true}, t)
      end
    elseif seasonType == SeasonMapType.Mummy then
      if hasEffect then
        local battleData = t
        TimerManager:GetInstance():DelayInvoke(function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarSuccessS3, {anim = true}, battleData)
        end, 3.33)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarSuccessS3, {anim = true}, t)
      end
    elseif seasonType == SeasonMapType.Darkness then
      if hasEffect then
        local battleData = t
        TimerManager:GetInstance():DelayInvoke(function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarSuccessS4, {anim = true}, battleData)
        end, 3.33)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarSuccessS4, {anim = true}, t)
      end
    end
  else
    Logger.LogInfo("\230\136\152\230\150\151\230\178\161\230\156\137\232\131\156\232\180\159\231\187\147\230\158\156\239\188\140\230\151\160\233\156\128\229\188\185\231\170\151")
  end
end

function SeasonFactionWarDataManager:IsSameAsMineCamp(serverId)
  if self.myCampId ~= 0 and self.myCampId == self:GetCampIdByServerId(serverId) then
    return true
  end
  return false
end

function SeasonFactionWarDataManager:InitLevelGroup(para_7, para_8)
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Darkness then
    local seasonIndex, seasonWeek = DataCenter.SeasonDataManager:GetSeasonWeekInfo()
    local battleWeek = seasonWeek - 3
    local factionWarActivityType = SeasonUtil.GetFactionWarActivityType()
    local dataAct = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(factionWarActivityType)
    if dataAct and dataAct.startTime then
      local actStartTime = dataAct.startTime
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local elapsedTime = curTime - actStartTime
      if 0 <= elapsedTime then
        battleWeek = math.floor(elapsedTime / (7 * OneDayTime * 1000)) + 1
      end
    end
    local bestCountStr = LuaEntry.DataConfig:TryGetStr("s4_faction_war", "k9", "30|30|30|30")
    local itemMaxCountStr = LuaEntry.DataConfig:TryGetStr("s4_faction_war", "k10", "10|6|3|1")
    local maxCount = 100
    local groupCountSetting = LuaEntry.DataConfig:TryGetNum("s4_faction_war", "k11", "1-68;69-9999|50;100")
    local bestCountList = string.split_ii_array(bestCountStr, "|")
    local itemMaxCountList = string.split_ii_array(itemMaxCountStr, "|")
    local bestCount = math.max(1, bestCountList[battleWeek] or 30)
    local itemMaxCount = math.max(1, itemMaxCountList[battleWeek] or 10)
    if groupCountSetting then
      local t1, t2 = string.split_ss(groupCountSetting, "|")
      if t1 and t2 then
        local t3 = string.split_ss_array(t1, ";")
        local t4 = string.split_ss_array(t2, ";")
        if t3 and t4 and #t3 == #t4 then
          local serverId = LuaEntry.Player:GetCurServerId()
          for index, t5 in ipairs(t3) do
            if t5 then
              local t6, t7 = string.split_ss(t5, "-")
              if serverId >= toInt(t6) and serverId <= toInt(t7) then
                maxCount = math.max(toInt(t4[index]), 50)
                break
              end
            end
          end
        end
      end
    end
    local count = math.floor(bestCount / itemMaxCount)
    local level_group = {}
    for i = 1, count do
      table.insert(level_group, itemMaxCount * i)
    end
    if bestCount < maxCount then
      table.insert(level_group, maxCount)
    end
    self.level_group = level_group
    return
  end
  if para_7 and self.level_group == nil then
    if string.IsNullOrEmpty(para_8) then
      local level_group = {}
      for level in string.gmatch(para_7, "([^|]+)|?") do
        table.insert(level_group, toInt(level))
      end
      self.level_group = level_group
    else
      local serverId = LuaEntry.Player:GetSourceServerId()
      local para_7_list = string.split(para_7, ";")
      local para_8_list = string.split(para_8, ";")
      if #para_7_list == #para_8_list then
        for i, v in ipairs(para_8_list) do
          local strFrom, strTo = string.match(v, "([^-]+)-([^-]+)")
          if strFrom and strTo and serverId >= toInt(strFrom) and serverId <= toInt(strTo) then
            para_7 = para_7_list[i]
            if not string.IsNullOrEmpty(para_7) then
              local level_group = {}
              for level in string.gmatch(para_7, "([^|]+)|?") do
                table.insert(level_group, toInt(level))
              end
              self.level_group = level_group
            end
            break
          end
        end
      else
        para_7 = para_7_list[1]
        if not string.IsNullOrEmpty(para_7) then
          local level_group = {}
          for level in string.gmatch(para_7, "([^|]+)|?") do
            table.insert(level_group, toInt(level))
          end
          self.level_group = level_group
        end
      end
    end
  end
end

function SeasonFactionWarDataManager:Description()
  local sb = StringBuilder.New()
  sb:AppendLine()
  sb:AppendLine("SeasonFactionWarDataManager")
  sb:AppendLine()
  sb:AppendLine("Season Base")
  sb:AppendLineFormat("  Season Type: %s", tostring(self.seasonType))
  sb:AppendLineFormat("  My Camp ID: %s", tostring(self.myCampId))
  sb:AppendLine()
  sb:AppendLine("War Status")
  sb:AppendLineFormat("  Current Step: %s", tostring(self.currStep))
  if self.stepEndTime then
    local timeStr = UITimeManager:GetInstance():TimeStampToTimeForLocal(self.stepEndTime)
    sb:AppendLineFormat("  Step End Time: %s (%s)", tostring(self.stepEndTime), timeStr)
  else
    sb:AppendLine("  Step End Time: NULL")
  end
  sb:AppendLineFormat("  Attack Camp ID: %s", tostring(self.attackCampId))
  sb:AppendLineFormat("  Defence Camp ID: %s", tostring(self.defenceCampId))
  sb:AppendLineFormat("  Defender Count: %s", table.count(self.theDefenderList))
  sb:AppendLineFormat("  Attacker Count: %s", table.count(self.theAttackerList))
  sb:AppendLine()
  sb:AppendLine("Faction Grouping")
  if self.seasonFactionInfo then
    sb:AppendLineFormat("  Server Count: %s", #self.seasonFactionInfo)
    for _, v in ipairs(self.seasonFactionInfo) do
      sb:AppendLineFormat("    Server %s -> Camp %s", tostring(v.serverId), tostring(v.campId))
    end
  else
    sb:AppendLine("  Season Faction Info: NULL")
  end
  if self.groupingActInfo then
    sb:AppendLineFormat("  Grouping Step: %s", tostring(self.groupingActInfo.step))
  end
  sb:AppendLine()
  sb:AppendLine("Declare War Activity")
  if self.declareWarActObj then
    sb:AppendLineFormat("  Round: %s", tostring(self.declareWarActObj.round))
    sb:AppendLineFormat("  Is End: %s", tostring(self.declareWarActObj.isEnd))
  else
    sb:AppendLine("  Declare War Act: NULL")
  end
  return sb:ToString()
end

return SeasonFactionWarDataManager
