local MasteryManager = BaseClass("MasteryManager")
local LWMasteryTemplate = require("DataCenter.Mastery.LWMasteryTemplate")
local LWMasteryShowTemplate = require("DataCenter.Mastery.LWMasteryShowTemplate")
local MasterySkillTemplate = require("DataCenter.Mastery.MasterySkillTemplate")
local MasteryData = require("DataCenter.Mastery.MasteryData")
local Localization = CS.GameEntry.Localization
local state2Order = {
  [MasterySkillState.Effect] = 1,
  [MasterySkillState.Normal] = 2,
  [MasterySkillState.CD] = 3,
  [MasterySkillState.NoUse] = 4,
  [MasterySkillState.Locked] = 5
}
local defaultMasteryGroup = "10000"

function MasteryManager:__init()
  self.data = MasteryData.New()
  self.skillTemplateDict = {}
  self.levelMaxExpDict = {}
  self.lwMasteryShowDict = {}
  self.lwMasteryDict = {}
  self.lwMasteryIdDict = {}
  self.lwMasteryHomeDict = {}
  self.initSeasonId = -1
  self.inited = false
  self.fortifyDailyCountMap = {}
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnPassDay, self.OnPassDay, self)
end

function MasteryManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.OnPassDay)
  self.data:Delete()
end

function MasteryManager:Enabled()
  local buildSwitchOn = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_MASTERY_OPEN) > 0
  return buildSwitchOn
end

function MasteryManager:GetData()
  self:InitMeta()
  return self.data
end

function MasteryManager:GetItemUseCount(itemId)
  self:InitMeta()
  if self.data and self.data.seasonItemCount and self.data.seasonItemCount[itemId] then
    return self.data.seasonItemCount[itemId]
  end
  return 0
end

function MasteryManager:InitCurSeasonMasteryMeta()
  local seasonID = SeasonUtil.GetSeason()
  if self.initSeasonId == seasonID then
    return
  end
  self.initSeasonId = seasonID
  local userSeasonInfo = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  local seasonConfig = userSeasonInfo:GetCurrentSeasonConfig()
  local masteryGroup = seasonConfig and seasonConfig.mastery_group
  if seasonConfig and string.IsNullOrEmpty(masteryGroup) then
    masteryGroup = defaultMasteryGroup
  end
  if LocalController:instance():getTable(TableName.LW_MASTERY) ~= nil then
    local nextsDict = {}
    LocalController:instance():visitTable(TableName.LW_MASTERY, function(id, line)
      local range = line:getValue("season_step")
      if range ~= nil then
        if #range == 1 then
          if range[1] ~= seasonID then
            return
          end
        elseif #range == 2 and (seasonID < range[1] or seasonID > range[2]) then
          return
        end
      end
      if line:getValue("season_only") == 1 and masteryGroup then
        local masteryGroupTarget = line:getValue("mastery_group")
        if string.IsNullOrEmpty(masteryGroupTarget) then
          masteryGroupTarget = defaultMasteryGroup
        end
        if masteryGroup ~= masteryGroupTarget then
          return
        end
      end
      local template = LWMasteryTemplate.New()
      template:InitData(line)
      self.lwMasteryDict[id] = template
      if template.mastery_id ~= 0 then
        if self.lwMasteryIdDict[template.mastery_id] == nil then
          self.lwMasteryIdDict[template.mastery_id] = {}
          if self.lwMasteryHomeDict[template.home] == nil then
            self.lwMasteryHomeDict[template.home] = {}
          end
          table.insert(self.lwMasteryHomeDict[template.home], template.mastery_id)
        end
        self.lwMasteryIdDict[template.mastery_id][template.lv] = template
      end
      if template.lv == 1 then
        for _, prior in ipairs(template.priors) do
          nextsDict[prior] = nextsDict[prior] or {}
          table.insert(nextsDict[prior], template.mastery_id)
        end
      end
    end)
    for _, template in pairs(self.lwMasteryDict) do
      template.nexts = nextsDict[template.mastery_id] or {}
    end
  end
end

function MasteryManager:InitMeta()
  self:InitCurSeasonMasteryMeta()
  if self.inited then
    return
  end
  self.inited = true
  if LocalController:instance():getTable(TableName.LW_MASTERY_EXP) ~= nil then
    LocalController:instance():visitTable(TableName.LW_MASTERY_EXP, function(_, line)
      local level = tonumber(line:getValue("level"))
      local maxExp = tonumber(line:getValue("Exp"))
      self.levelMaxExpDict[level] = maxExp
    end)
  end
  if LocalController:instance():getTable(TableName.LW_MASTERY_SHOW) ~= nil then
    LocalController:instance():visitTable(TableName.LW_MASTERY_SHOW, function(_, line)
      local id = tonumber(line:getValue("id"))
      local temp = LWMasteryShowTemplate.New()
      temp:InitData(line)
      self.lwMasteryShowDict[id] = temp
    end)
  end
  if LocalController:instance():getTable(TableName.MasterySkill) ~= nil then
    LocalController:instance():visitTable(TableName.MasterySkill, function(skillId, line)
      local template = MasterySkillTemplate.New()
      template:InitData(line)
      self.skillTemplateDict[skillId] = template
    end)
  end
end

function MasteryManager:GetLevelMaxExp(level)
  self:InitMeta()
  return self.levelMaxExpDict[level + 1] or LongMaxValue
end

function MasteryManager:GetMaxLevel()
  local seasonConfig = DataCenter.SeasonDataManager:GetServerCurrentSeasonConfig()
  if seasonConfig then
    return seasonConfig.max_mastery_level
  end
  return 30
end

function MasteryManager:GetDataInfoMsgHandle(message)
  self.data:ParseServerData(message)
  self:CalculateRecommend()
end

function MasteryManager:SetSkillCdAndEffectTime(message)
  self.data:SetSkillCdAndEffectTime(message)
end

function MasteryManager:GetHomeDict(homeId)
  self:InitMeta()
  return self.lwMasteryHomeDict[homeId]
end

function MasteryManager:GetTempById(id)
  self:InitMeta()
  local temp = self.lwMasteryDict[id]
  if not temp then
    local seasonId = SeasonUtil.GetSeason()
    local loginServerId = "-1"
    if LuaEntry and LuaEntry.Player then
      loginServerId = LuaEntry.Player:GetSelfServerId()
    end
    Logger.LogError("mastery id is nil : " .. id .. ", curSeasonId\239\188\154" .. seasonId .. ", seasonId\239\188\154" .. self.initSeasonId .. ", loginServerId: " .. loginServerId)
  end
  return temp
end

function MasteryManager:GetMasteryTempsDictByGroupId(groupId)
  self:InitMeta()
  local tempsDict = self.lwMasteryIdDict[groupId]
  if not tempsDict then
    local seasonId = SeasonUtil.GetSeason()
    local loginServerId = "-1"
    if LuaEntry and LuaEntry.Player then
      loginServerId = LuaEntry.Player:GetSelfServerId()
    end
    Logger.LogError("mastery masteryId is nil : " .. groupId .. ", curSeasonId\239\188\154" .. seasonId .. ", seasonId\239\188\154" .. self.initSeasonId .. ", loginServerId: " .. loginServerId)
  end
  return tempsDict
end

function MasteryManager:GetTempByGroupIdAndLevel(groupId, level)
  self:InitMeta()
  local temp
  local tempDict = self:GetMasteryTempsDictByGroupId(groupId)
  if tempDict and tempDict[level] then
    temp = tempDict[level]
  else
    local seasonId = SeasonUtil.GetSeason()
    local loginServerId = "-1"
    if LuaEntry and LuaEntry.Player then
      loginServerId = LuaEntry.Player:GetSelfServerId()
    end
    Logger.LogError("mastery (masteryId level) is nil : " .. groupId .. " " .. level .. ", curSeasonId\239\188\154" .. seasonId .. ", seasonId\239\188\154" .. self.initSeasonId .. ", loginServerId: " .. loginServerId)
  end
  return temp
end

function MasteryManager:GetTempLevelOneByMasteryGroupId(groupId)
  self:InitMeta()
  return self:GetTempByGroupIdAndLevel(groupId, 1)
end

function MasteryManager:GetHomeShowTempByHomeId(homeId)
  self:InitMeta()
  return self.lwMasteryShowDict[homeId]
end

function MasteryManager:GetCurSkillIdByMasteryId(masteryId)
  self:InitMeta()
  local masteryData = DataCenter.MasteryManager:GetData()
  local curLv = masteryData:GetCurLvByMasteryId(masteryId)
  if curLv <= 0 then
    return nil
  end
  local temp = self:GetTempByGroupIdAndLevel(masteryId, curLv)
  return temp.skill
end

function MasteryManager:IsSkillCanUpByMasteryId(groupId)
  self:InitMeta()
  local masteryData = DataCenter.MasteryManager:GetData()
  local lvOneTemp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(groupId)
  if lvOneTemp.season_only == 1 and not SeasonUtil.IsInSeason(true) then
    return MasterySkillCannotUpResaon.seasonDisable
  end
  local maxLv = lvOneTemp.max_lv
  local homeId = lvOneTemp.home
  local selfHomeId = masteryData.home_id
  if selfHomeId ~= homeId then
    return MasterySkillCannotUpResaon.homeDiff
  end
  local curLv = masteryData:GetCurLvByMasteryId(groupId)
  if maxLv <= curLv then
    return MasterySkillCannotUpResaon.MaxLv
  end
  if lvOneTemp.extra_condition then
    local cond = lvOneTemp.extra_condition
    if cond[1] == "1" then
      local level = DataCenter.BuildManager:GetMaxBuildingLevel(tonumber(cond[2]))
      if level < tonumber(cond[3]) then
        return MasterySkillCannotUpResaon.ExtraLock
      end
    elseif cond[1] == "2" and lvOneTemp.season_step then
      local seasonNum = SeasonUtil.GetSeason()
      local seasonDay = SeasonUtil.GetSeasonDay()
      local seasonNumCond = lvOneTemp.season_step[1]
      local seasonDayCond = tonumber(cond[2])
      if seasonNum < seasonNumCond or seasonNumCond == seasonNum and seasonDay < seasonDayCond then
        return MasterySkillCannotUpResaon.ExtraLock
      end
    end
  end
  local targetLv = curLv + 1
  local targetTemp = DataCenter.MasteryManager:GetTempByGroupIdAndLevel(groupId, targetLv)
  if targetTemp.mastery_lock then
    return MasterySkillCannotUpResaon.DesignerLock
  end
  local curHomeLv = masteryData.level
  if curHomeLv < targetTemp.need_home_lv then
    return MasterySkillCannotUpResaon.needHomeLv
  end
  local preMastery = targetTemp.need_mastery
  if 0 < preMastery then
    local needMasteryTemp = DataCenter.MasteryManager:GetTempById(preMastery)
    local preMasteryId = needMasteryTemp.mastery_id
    local preMasteryLv = needMasteryTemp.lv
    local preMasteryCurLv = masteryData:GetCurLvByMasteryId(preMasteryId)
    if preMasteryLv > preMasteryCurLv then
      return MasterySkillCannotUpResaon.needSkillLv
    end
  end
  local needCost = 1
  local idlepoint = masteryData:GetCurPlanIdlePoint()
  if needCost > idlepoint then
    return MasterySkillCannotUpResaon.needCost
  end
  return MasterySkillCannotUpResaon.None
end

function MasteryManager:GetCurPlanIdlePoint()
  return self.data:GetCurPlanIdlePoint()
end

function MasteryManager:GetHomeExpAddMsgHandle(message)
  self.data:GetHomeExpAddMsgHandle(message)
end

function MasteryManager:GetUnlockedSkillTemplateByType(skillType)
  local data = self:GetData()
  local allSkillChargeDatas = data:GetAllSkillChargeData()
  for skillId, _ in pairs(allSkillChargeDatas) do
    local skillTemp = self.skillTemplateDict[skillId]
    if skillTemp and skillTemp.type == skillType then
      return skillTemp
    end
  end
end

function MasteryManager:GetStorageSkillCountByType(skillType)
  local template = self:GetUnlockedSkillTemplateByType(skillType)
  if template then
    return self:GetStorageSkillCount(template.id)
  end
  return 0, 0
end

function MasteryManager:GetSkillTemplate(skillId)
  self:InitMeta()
  return self.skillTemplateDict[skillId]
end

function MasteryManager:GetSkillTemplateByType(type)
  self:InitMeta()
  for _, v in pairs(self.skillTemplateDict) do
    if v.type == type then
      return v
    end
  end
end

function MasteryManager:GetStorageSkillCount(skillId)
  local data = self:GetData()
  return data:GetStorageSkillCount(skillId)
end

function MasteryManager:GetMasteryGroupSkillState(masteryGroup)
  self:InitMeta()
  local plan = self:GetCurPlan()
  local level = plan:GetGroupLevel(masteryGroup)
  local masteryTemp = self:GetTempByGroupIdAndLevel(masteryGroup, level <= 0 and 1 or level)
  if masteryTemp == nil then
    return MasterySkillState.None, 0, nil, nil
  end
  local skill = masteryTemp.skill
  if skill == nil or skill <= 0 then
    return MasterySkillState.None, 0, masteryTemp, nil
  end
  return self:GetSkillState(skill, level, masteryTemp)
end

function MasteryManager:GetSkillState(skill, level, parentTemp)
  local skillTemp = self:GetSkillTemplate(skill)
  if level <= 0 then
    return MasterySkillState.Locked, 0, parentTemp, skillTemp
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local data = self:GetData()
  if not data:GetSkillChargeData(skill) then
    return MasterySkillState.Covered, 0, parentTemp, skillTemp
  end
  local effTime = data:GetSkillEffectTime(skill)
  if curTime < effTime then
    return MasterySkillState.Effect, effTime, parentTemp, skillTemp
  end
  local cdOverTime = data:GetSkillAvailableTime(skill)
  if curTime < cdOverTime then
    return MasterySkillState.CD, cdOverTime, parentTemp, skillTemp
  end
  return MasterySkillState.Normal, 0, parentTemp, skillTemp
end

function MasteryManager:SendUseSkillMsg(skillTemp, param, msgId)
  if not skillTemp then
    return
  end
  msgId = msgId or MsgDefines.MasteryUseSkill
  if skillTemp and skillTemp.active_skill_confirm_popup_key then
    UIUtil.ShowSecondMessage(nil, Localization:GetString(skillTemp.active_skill_confirm_popup_key), 2, "", "", function()
      SFSNetwork.SendMessage(msgId, skillTemp.id, param)
    end, nil, nil, nil, nil, nil, nil, nil, nil, false)
  else
    SFSNetwork.SendMessage(msgId, skillTemp.id, param)
  end
end

function MasteryManager:UseSkill(skillId, pointId, msgId, serverId)
  local skillTemp = self:GetSkillTemplate(skillId)
  if not skillTemp then
    return
  end
  msgId = msgId or MsgDefines.MasteryUseSkill
  local errorTips
  if skillTemp:CheckUsePosition(MasterySkillUsePosType.Building) or skillTemp:CheckUsePosition(MasterySkillUsePosType.AllianceCity) then
    local info = CS.SceneManager.World:GetPointInfo(pointId)
    if info then
      if skillTemp.type == MasterySkill.CreateFakeMarch then
        if LuaEntry.Player:IsMeOrMyAlly(info.ownerUid, info.allianceId) then
          UIUtil.ShowTipsId("season_mastery_s3_tips_18")
          return
        end
        MarchUtil.OnClickStartMarch(MarchTargetType.FAKE_ATTACK, pointId, info.uuid, -1, 1)
        return
      elseif skillTemp.type == MasterySkill.AllyCityPoisoning then
        MarchUtil.LaunchScout(MarchTargetType.SKILL_SPREAD_VIRUS, pointId, info.uuid)
        return
      elseif skillTemp.type == MasterySkill.CreateMummyRunningBoss then
        if WorldBuildUtil.HasShield(pointId, 120899) then
          return
        end
        if DataCenter.SeasonFactionWarDataManager:IsSameCampOrSameAllianceOrMe(info.srcServerId, info.allianceId, info.ownerUid) then
          UIUtil.ShowTipsId("season_mastery_s3_tips_12")
          return
        end
        local param = {
          pointId = pointId,
          targetUuid = info.uuid,
          serverId = serverId
        }
        self:SendUseSkillMsg(skillTemp, param, msgId)
        return
      elseif skillTemp.type == MasterySkill.BloodyHunter then
        DataCenter.SeasonHunterManager:JoinBattle()
        return
      elseif skillTemp.type == MasterySkill.SummonWeather then
        local flag, tips = DataCenter.SeasonWeatherManager:CanSummonWeather(skillTemp)
        if flag then
          self:SendUseSkillMsg(skillTemp, {
            otherUid = info.ownerUid,
            serverId = serverId
          }, msgId)
        elseif tips then
          UIUtil.ShowTips(tips)
        end
        return
      else
        local param = {
          otherUid = info.ownerUid,
          serverId = serverId
        }
        self:SendUseSkillMsg(skillTemp, param, msgId)
        return
      end
    end
    errorTips = "season_mastery_tips_1"
  end
  if skillTemp:CheckUsePosition(MasterySkillUsePosType.Field) or skillTemp:CheckUsePosition(MasterySkillUsePosType.MyDesert) then
    if skillTemp:IsLandMineSkill() then
      if LuaEntry.Player:GetSourceServerId() == serverId then
        local landmineMeta = DataCenter.WorldTriggerTemplateManager:GetMeta(skillTemp.values[1])
        CS.SceneManager.World:UICreateWorldTrigger(landmineMeta.prefab, landmineMeta.id, pointId, skillTemp.id, serverId)
      else
        UIUtil.ShowTipsId("season_s2_landmine_01")
      end
      return
    elseif skillTemp:IsWarFlagSkill() then
      local warFlagMeta = DataCenter.WarFlagDataManager:GetMeta(skillTemp.values[1])
      if warFlagMeta then
        CS.SceneManager.World:UICreateWorldAnything(FakeMovingModelFlag.WarFlag, warFlagMeta.prefab, serverId, pointId, 1, warFlagMeta.id, skillTemp.id)
      end
      return
    elseif skillTemp.type == MasterySkill.TouchOfNature then
      if not DataCenter.SeasonGreenManager:CanGreen(pointId, true, true) then
        UIUtil.CheckEventTrigger(OpMode.ClickBtnWorldGreen, 1)
        return
      end
      local param = {pointId = pointId, serverId = serverId}
      self:SendUseSkillMsg(skillTemp, param, msgId)
      return
    elseif skillTemp.type == MasterySkill.SummonWeather then
      local flag, tips = DataCenter.SeasonWeatherManager:CanSummonWeather(skillTemp)
      if flag then
        self:SendUseSkillMsg(skillTemp, {
          otherUid = LuaEntry.Player.uid,
          serverId = serverId
        }, msgId)
      elseif tips then
        UIUtil.ShowTips(tips)
      end
      return
    else
      local desertInfo = SeasonUtil.GetDesertIfoByPointId(pointId)
      local dUuid = desertInfo and desertInfo.uuid
      local param = {
        dUuid = dUuid,
        pointId = pointId,
        serverId = serverId
      }
      self:SendUseSkillMsg(skillTemp, param, msgId)
      return
    end
    errorTips = "season_mastery_tips_2"
  end
  if skillTemp:CheckUsePosition(MasterySkillUsePosType.SkillView) then
    self:SendUseSkillMsg(skillTemp, nil, msgId)
    return
  end
  if skillTemp:CheckUsePosition(MasterySkillUsePosType.Monster) then
    self:SendUseSkillMsg(skillTemp, nil, msgId)
    return
  end
  UIUtil.ShowTipsId(errorTips or "season_mastery_167")
end

function MasteryManager:GetTitleShowSkillList(titleList, pointId, usePos_, checkView_)
  local list = {}
  if table.IsNullOrEmpty(titleList) then
    return list
  end
  for _, v in ipairs(titleList) do
    local skillState, endTime, titleTemp, skillTemp = DataCenter.MasteryManager:GetTitleSkillState(v.cfgId)
    if titleTemp and skillTemp and skillTemp.active_skills and skillState ~= MasterySkillState.Covered and (not checkView_ or not skillTemp:CheckUsePosition(MasterySkillUsePosType.SkillView)) then
      local tempState = skillState
      if tempState == MasterySkillState.Normal then
        if usePos_ == MasterySkillUsePosType.Field and skillTemp:CheckUsePosition(MasterySkillUsePosType.MyDesert) then
          local desertInfo = SeasonUtil.GetDesertIfoByPointId(pointId)
          if not desertInfo or desertInfo.ownerUid ~= LuaEntry.Player.uid then
            tempState = MasterySkillState.NoUse
          end
        elseif usePos_ and not skillTemp:CheckUsePosition(usePos_) then
          tempState = MasterySkillState.NoUse
        elseif skillTemp.use_target == 1 and (pointId ~= LuaEntry.Player:GetMainWorldPos() or not tempState) then
          tempState = MasterySkillState.NoUse
        end
      end
      local showData = {
        titleTemp = titleTemp,
        skillTemp = skillTemp,
        endTime = endTime,
        pointId = pointId,
        tempState = tempState
      }
      table.insert(list, showData)
    end
  end
  table.sort(list, function(a, b)
    local orderA = state2Order[a.tempState]
    local orderB = state2Order[b.tempState]
    if orderA ~= orderB then
      return orderA < orderB
    else
      return a.skillTemp.id < b.skillTemp.id
    end
  end)
  return list
end

function MasteryManager:GetTitleSkillState(titleId)
  self:InitMeta()
  local info = DataCenter.PlayerTitleTemplateManager:GetTitleInfo(titleId)
  local skillId = info and info.linkSkill
  if not skillId or skillId <= 0 then
    return MasterySkillState.None, 0, nil, nil
  end
  return self:GetSkillState(skillId, 1, info)
end

function MasteryManager:HandleInit(message)
  if message.desertTalent then
    self.data:ParseServerData(message.desertTalent)
  end
  if message.lwUserSkill then
    for type, list in pairs(message.lwUserSkill) do
      for _, v in ipairs(list) do
        self.data:SetSkillCdAndEffectTime(v)
      end
    end
  end
  if self:GetUnlockedSkillTemplateByType(MasterySkill.CreateWall) then
    DataCenter.DefenceWallDataManager:FetchWallBar()
  end
end

function MasteryManager:GetCurPlanIndex()
  return self.data.planIndex
end

function MasteryManager:GetCurPlan()
  return self.data:GetCurPlan()
end

function MasteryManager:HandleLearn(message)
  local data = self:GetData()
  local plan = self:GetCurPlan()
  if message.talentPoint then
    plan.restPoint = message.talentPoint
  end
  if message.learnPoints then
    for _, v in ipairs(message.learnPoints) do
      local group = tonumber(v.groupId)
      plan:SetGroupLevel(group, v.level)
    end
  end
  if message.talentSkill then
    data:CleanSkillCdAndEffectTime()
    for _, v in ipairs(message.talentSkill) do
      data:SetSkillCdAndEffectTime(v)
    end
  end
  self:CalculateRecommend()
end

function MasteryManager:HandleChangePlan(message)
end

function MasteryManager:HandleUseSkill(message)
  if message.skillId == nil or message.cdTime == nil then
    return
  end
  local data = self:GetData()
  local skillId = tonumber(message.skillId)
  local skillTemp = self:GetSkillTemplate(skillId)
  local skillType = skillTemp.type
  data:SetSkillCdAndEffectTime(message)
  UIUtil.ShowTipsId(120089)
  local rewardPopupDelay = 0
  local rewardList = {}
  local rewardListShow, rewardTip, OnceMorePopup
  if skillType == MasterySkill.CultivateVirus then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGetVirus, {anim = true}, skillTemp.values[1])
    return
  elseif skillType == MasterySkill.Whistle then
    if self.skillTargetUuid then
      GoToUtil.JumpToMarchByUuid(self.skillTargetUuid, LuaEntry.Player:GetCurServerId(), 0)
      self.skillTargetUuid = nil
    end
  elseif skillType == MasterySkill.BloodyHunter then
    local gotoPointIndex = LuaEntry.Player:GetMainWorldPos()
    local position = SceneUtils.TileIndexToWorld(gotoPointIndex, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(position, MoveCityCameraHeight, nil, nil, LuaEntry.Player:GetSelfServerId())
  elseif skillType == MasterySkill.CreateWall then
    DataCenter.DefenceWallDataManager:FetchWallBar()
  end
  if message.exeObj then
    local exeObj = message.exeObj
    if exeObj.lucky then
      function OnceMorePopup()
        TimerManager:GetInstance():DelayInvoke(function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuyOneGetOneFree, {anim = true}, skillId)
        end, 0.2)
      end
    end
    if exeObj.resArr then
      local resDict = {}
      for _, v in ipairs(exeObj.resArr) do
        resDict[v.t] = (resDict[v.t] or 0) + v.v
      end
      for resType, count in pairs(resDict) do
        local reward = {}
        reward.type = ResTypeToReward[resType]
        reward.value = count
        table.insert(rewardList, reward)
      end
    end
    if exeObj.resItemArr then
      local resItemDict = {}
      for _, v in ipairs(exeObj.resItemArr) do
        resItemDict[v.t] = (resItemDict[v.t] or 0) + v.v
      end
      for resItemId, count in pairs(resItemDict) do
        local reward = {}
        reward.type = RewardType.RESOURCE_ITEM
        reward.value = {itemId = resItemId, count = count}
        table.insert(rewardList, reward)
      end
    end
    if exeObj.reward then
      for _, v in pairs(exeObj.reward) do
        table.insert(rewardList, v)
      end
    end
    if skillType == MasterySkill.WarriorSpeedUpTogether then
      rewardTip = Localization:GetString("season_mastery_s3_tips_2")
    end
    if exeObj.statusId and skillType ~= MasterySkill.WarriorSpeedUpTogether then
      local template = DataCenter.StatusManager:GetTemplate(exeObj.statusId)
      if template ~= nil then
        local param = {
          title = Localization:GetString(template.name),
          icon = template.icon,
          desc = string.IsNullOrEmpty(template.description) and "" or Localization:GetString(template.description),
          closeFunc = OnceMorePopup
        }
        OnceMorePopup = nil
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIMasterySkillUseResultShow, {anim = true}, param)
      end
    end
    if exeObj.dUuid and skillType == MasterySkill.MopUp then
      local desertData = CS.SceneManager.World:GetDesertInfoByUuid(exeObj.dUuid)
      if desertData and desertData.pointIndex then
        local ts = DataCenter.FakeMopUpMarchManager:AddMarchIndex(desertData.pointIndex)
        local now = UITimeManager:GetInstance():GetServerTime()
        rewardPopupDelay = math.max(0, ts - now) / 1000
      end
    end
    if exeObj.pointId and skillType == MasterySkill.CreateMummyRunningBoss then
      local pos = SceneUtils.TileIndexToWorld(exeObj.pointId, ForceChangeScene.World)
      local marchUuid = exeObj.uuid
      GoToUtil.GotoWorldPos(pos, nil, 0, function()
        TimerManager:GetInstance():DelayInvoke(function()
          UIUtil.OnClickWorldTroop(marchUuid)
        end, 0.5)
      end, LuaEntry.Player:GetCurServerId())
    end
    if exeObj.treasure and skillType == MasterySkill.CallSupply then
      local pos = SceneUtils.TileIndexToWorld(exeObj.treasure.pointId, ForceChangeScene.World)
      GoToUtil.GotoWorldPos(pos, nil, 0.5, nil, LuaEntry.Player:GetSourceServerId())
      rewardPopupDelay = 1
    end
    if exeObj.hospitalArray and skillType == MasterySkill.RapidHeal then
      DataCenter.HospitalManager:HospitalCureHandle({
        hospitalArray = exeObj.hospitalArray
      })
      rewardListShow = {}
      local cureArr = exeObj.cureArr
      for key, value in pairs(cureArr) do
        local data = {}
        data.type = RewardType.RESOURCE_ITEM
        data.value = {}
        data.value.itemId = value.armyId
        data.value.add = value.num
        table.insert(rewardListShow, data)
      end
    end
    if exeObj.queueList then
      for i = 1, #exeObj.queueList do
        local msg = {}
        msg.queue = exeObj.queueList[i]
        DataCenter.QueueDataManager:QueueCcsMNewHandle(msg)
      end
    end
    if not string.IsNullOrEmpty(skillTemp.tips_after_use) then
      local count = self:ParseUseSkillData(exeObj, skillTemp)
      local param = {
        title = Localization:GetString(skillTemp.name),
        icon = skillTemp:GetIconFullPath(),
        desc = Localization:GetString(skillTemp.tips_after_use, count),
        closeFunc = OnceMorePopup
      }
      OnceMorePopup = nil
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIMasterySkillUseResultShow, {anim = true}, param)
    end
  end
  if 0 < #rewardList then
    local fakeMsg = {reward = rewardList}
    if 0 < rewardPopupDelay then
      TimerManager:GetInstance():DelayInvoke(function()
        DataCenter.RewardManager:AddRewardsAndRes(fakeMsg)
        DataCenter.RewardManager:ShowCommonReward(fakeMsg, nil, nil, nil, nil, nil, OnceMorePopup, rewardTip)
      end, rewardPopupDelay)
    else
      DataCenter.RewardManager:AddRewardsAndRes(fakeMsg)
      DataCenter.RewardManager:ShowCommonReward(fakeMsg, nil, nil, nil, nil, nil, OnceMorePopup, rewardTip)
    end
  elseif OnceMorePopup then
    OnceMorePopup()
  end
  if rewardListShow and #rewardListShow then
    local fakeMsg = {reward = rewardListShow}
    DataCenter.RewardManager:ShowCommonReward(fakeMsg)
  end
end

function MasteryManager:IsShowWorldMasteryBtn()
  local data = self:GetData()
  local isDragonWorld = BattleFieldUtil.InBattleField()
  local isOpen = data ~= nil and data.home_id > 0 and not isDragonWorld
  return isOpen
end

function MasteryManager:ClickWorldMasteryBtn(param, _serverId)
  local pointId = param.pointId
  local serverId = _serverId or param.serverId
  if SeasonUtil.InSeasonBigMapMode() then
    if not SeasonUtil.IsInSameGroup(serverId, ServerEnum.Login) then
      UIUtil.ShowTipsId("season_tips143")
      return
    end
  elseif CrossServerUtil:GetIsCrossServerNotDragonWorld() then
    UIUtil.ShowTipsId("season_tips143")
    return
  end
  if param.info and param.info.monsterTemplate then
    self.skillTargetUuid = param.info.uuid
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasterySkillUseInWorld, {anim = true}, MasterySkillUsePosType.Monster, pointId, nil, serverId)
    return
  end
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  if info == nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasterySkillUseInWorld, {anim = true}, MasterySkillUsePosType.Field, pointId, nil, serverId)
  elseif info.PointType == WorldPointType.WORLD_ALLIANCE_CITY or info.PointType == WorldPointType.WORLD_CITY_STRONGHOLD then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasterySkillUseInWorld, {anim = true}, MasterySkillUsePosType.AllianceCity, pointId, nil, serverId)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasterySkillUseInWorld, {anim = true}, MasterySkillUsePosType.Building, pointId, nil, serverId)
  end
end

function MasteryManager:HaveSkillCanUse()
  self:InitMeta()
  if self.data == nil then
    return false
  end
  local homeDict = self:GetHomeDict(self.data.home_id)
  if homeDict then
    for _, masteryId in ipairs(homeDict) do
      local skillState, _, _, skillTemplate = self:GetMasteryGroupSkillState(masteryId)
      if skillTemplate and skillState == MasterySkillState.Normal and skillTemplate.red_point == 1 then
        return true
      end
    end
  end
  return false
end

function MasteryManager:HandleSkillUpdate(msg)
  if msg.list ~= nil then
    for i = 1, #msg.list do
      local updateInfo = msg.list[i]
      local data = self:GetData()
      local skillId = tonumber(updateInfo.skillId)
      data:SetSkillCdAndEffectTime(updateInfo)
      local skillTemp = self:GetSkillTemplate(skillId)
      if skillTemp and skillTemp.passive_skill_toast then
        local cur, max = DataCenter.MasteryManager:GetStorageSkillCount(skillId)
        local tips = Localization:GetString(skillTemp.passive_skill_toast, cur)
        UIUtil.ShowTips(tips)
      end
    end
  end
end

function MasteryManager:ParseUseSkillData(msg, configData)
  local type = configData.type
  if type == MasterySkill.AddSpecialExp then
    return msg.add and msg.add or 0
  elseif type == MasterySkill.BuildFinishImd or type == MasterySkill.ResearchFinishImd then
    local miliSecond = toInt(msg.helpReduceTime)
    return toInt(miliSecond / 60000)
  elseif type == MasterySkill.FriendshipShield then
    return configData.duration
  end
  return 0
end

function MasteryManager:HandleLandmineList(msg)
  self.landmineList = msg.ls
  EventManager:GetInstance():Broadcast(EventId.MyTriggerListRefresh)
end

function MasteryManager:GetUnlockedSkillTemplateByUsePos(usePos)
  local data = self:GetData()
  local allSkillChargeDatas = data:GetAllSkillChargeData()
  for skillId, _ in pairs(allSkillChargeDatas) do
    local skillTemp = self.skillTemplateDict[skillId]
    if skillTemp and skillTemp:CheckUsePosition(usePos) then
      return skillTemp
    end
  end
end

function MasteryManager:GetLandmineList()
  return self.landmineList or {}
end

function MasteryManager:CanUseTemplates(homeId)
  if self.data == nil or self.data.newDesertTalentTemplates == nil or self.data.newDesertTalentTemplates.homeTemplates == nil then
    return false
  end
  for _, data in pairs(self.data.newDesertTalentTemplates.homeTemplates) do
    if data.homeId == homeId then
      return data.canUse == 1, data
    end
  end
  return false
end

function MasteryManager:GetMasterySkillUseShowDataInChatView()
  local allShowData = {}
  local data = DataCenter.MasteryManager:GetData()
  if data == nil then
    return allShowData
  end
  local homeId = data.home_id
  local homeDict = DataCenter.MasteryManager:GetHomeDict(homeId)
  for _, masteryId in ipairs(homeDict) do
    local skillState, endTime, masteryTemp, skillTemp = DataCenter.MasteryManager:GetMasteryGroupSkillState(masteryId)
    local isShow = false
    if skillTemp then
      isShow = DataCenter.MasteryManager:CheckMasterySkillUseShowInChatView(skillTemp.type)
    end
    if isShow and masteryTemp and skillTemp and not skillTemp:CheckUsePosition(MasterySkillUsePosType.SkillView) and skillTemp.active_skills and skillState ~= MasterySkillState.Covered then
      local tempState = skillState
      local showData = {
        masteryTemp = masteryTemp,
        skillTemp = skillTemp,
        endTime = endTime,
        playerUuid = nil,
        tempState = tempState
      }
      table.insert(allShowData, showData)
    end
  end
  return allShowData
end

function MasteryManager:CheckMasterySkillUseShowInChatView(skillType)
  local isShow = false
  if skillType == MasterySkill.UpgradeDesert or skillType == MasterySkill.BuildSpeedUpTogether or skillType == MasterySkill.WarriorSpeedUpTogether or skillType == MasterySkill.FriendshipShield or skillType == MasterySkill.MedicalAssistance then
    isShow = true
  end
  return isShow
end

function MasteryManager:OnPassDay()
  self.fortifyDailyCountMap = {}
  local skillTemp = self:GetUnlockedSkillTemplateByType(MasterySkill.BloodyHunter)
  if not skillTemp then
    return
  end
  local data = self:GetData()
  if not data then
    return
  end
  local chargeData = data:GetSkillChargeData(skillTemp.id)
  if not chargeData then
    return
  end
  if DataCenter.SeasonDataManager:HasGlobalStatus(StatusId.BloodyNightHunterEnhance) then
    chargeData.duration = LuaEntry.DataConfig:TryGetNum("status_704716", "k1", 2850) * 60000
  else
    chargeData.duration = skillTemp.cd_time * 60000
  end
end

function MasteryManager:CalculateRecommend()
  local plan = self:GetCurPlan()
  if plan.restPoint <= 0 then
    self.recommendMasteryTemplate = nil
    return nil
  end
  local recommendScore = 0
  local masteryTemplate
  local masteryIdList = self:GetHomeDict(self.data.home_id)
  if masteryIdList then
    for _, groupId in pairs(masteryIdList) do
      local lvOneTemp = self:GetTempLevelOneByMasteryGroupId(groupId)
      local curLv = self:GetData():GetCurLvByMasteryId(groupId)
      if curLv < lvOneTemp.max_lv then
        local temp = self:GetTempByGroupIdAndLevel(groupId, curLv + 1)
        if temp.recommend_weight and recommendScore < temp.recommend_weight and self:IsSkillCanUpByMasteryId(groupId) then
          recommendScore = temp.recommend_weight
          masteryTemplate = temp
        end
      end
    end
  end
  self.recommendMasteryTemplate = masteryTemplate
  return masteryTemplate
end

function MasteryManager:GetRecommendGroupId()
  if self.recommendMasteryTemplate then
    return self.recommendMasteryTemplate.mastery_id
  end
  return nil
end

function MasteryManager:HandleLwSeasonMasteryNewbieRewardClaimMessage()
  self.data.newbieRewardStatus = 2
  EventManager:GetInstance():Broadcast(EventId.MasteryNewbieRewardState)
end

function MasteryManager:GetNewbieRewardStatus()
  if self.data.newbieRewardStatus == 1 then
    local masteryLevel = self:GetData().level
    local k2 = LuaEntry.DataConfig:TryGetNum("mastery_newbie", "k2", 10)
    if masteryLevel >= k2 then
      return 1
    else
      return 2
    end
  end
  return 3
end

function MasteryManager:CheckCanUpgradeByGoods()
  local curLv = self:GetData().level
  if curLv >= self:GetMaxLevel() then
    return false
  end
  local curExp = self:GetData().exp
  local maxExp = self:GetLevelMaxExp(curLv)
  local need = maxExp - curExp
  local items = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_133)
  local have = 0
  if items then
    for _, v in pairs(items) do
      have = have + v.count * v.para1
    end
  end
  return need <= have
end

function MasteryManager:IsCardUnlock()
  local condition = LuaEntry.DataConfig:TryGetStr("battle_card_param", "k5")
  local conditionSeason = 4
  local conditionLv = 100
  if not string.IsNullOrEmpty(condition) then
    local list = string.split(condition, "|")
    if 2 <= #list then
      conditionLv = tonumber(list[1])
      conditionSeason = tonumber(list[2])
    end
  end
  return conditionLv <= self:GetData().level and conditionSeason <= SeasonUtil.GetSeason()
end

function MasteryManager:IsS5MakingCoffeeShowTip(groupId)
  local masteryData = self:GetData()
  local lvOneTemp = self:GetTempLevelOneByMasteryGroupId(groupId)
  if lvOneTemp.season_only == 1 and not SeasonUtil.IsInSeason(true) then
    return false
  end
  local maxLv = lvOneTemp.max_lv
  local homeId = lvOneTemp.home
  local selfHomeId = masteryData.home_id
  if selfHomeId ~= homeId then
    return false
  end
  local curLv = masteryData:GetCurLvByMasteryId(groupId)
  if maxLv <= curLv then
    return false
  end
  if lvOneTemp.extra_condition then
    local cond = lvOneTemp.extra_condition
    if cond[1] == "1" then
      local level = DataCenter.BuildManager:GetMaxBuildingLevel(tonumber(cond[2]))
      if level < tonumber(cond[3]) then
        return false
      end
    elseif cond[1] == "2" and lvOneTemp.season_step then
      local seasonNum = SeasonUtil.GetSeason()
      local seasonDay = SeasonUtil.GetSeasonDay()
      local seasonNumCond = lvOneTemp.season_step[1]
      local seasonDayCond = tonumber(cond[2])
      if seasonNum < seasonNumCond or seasonNumCond == seasonNum and seasonDay < seasonDayCond then
        return false
      end
    end
  end
  local targetLv = curLv + 1
  local targetTemp = DataCenter.MasteryManager:GetTempByGroupIdAndLevel(groupId, targetLv)
  if targetTemp.mastery_lock then
    return false
  end
  local curHomeLv = masteryData.level
  if curHomeLv < targetTemp.need_home_lv then
    return false
  end
  return true
end

function MasteryManager:GetFortifyDailyCount(targetUid)
  return self.fortifyDailyCountMap[targetUid]
end

function MasteryManager:ReqGetFortifyDailyCount(targetUid)
  SFSNetwork.SendMessage(MsgDefines.GetDesertTalentFortifyDailyCount, targetUid)
end

function MasteryManager:HandleFortifyDailyCount(message)
  local targetUid = message.targetUid
  if not targetUid then
    return
  end
  self.fortifyDailyCountMap[targetUid] = {
    usedCount = message.usedCount or 0,
    dailyLimit = message.dailyLimit or 0
  }
  EventManager:GetInstance():Broadcast(EventId.MasteryFortifyDailyCountUpdate, targetUid)
end

return MasteryManager
