local ActivityKillZombieManager = BaseClass("ActivityKillZombieManager", CEventable)
local AlChallengeKirovInfo = require("DataCenter.ActivityListData.ActKillZombie.AlChallengeKirovInfo")
local ADVANCE_LEVEL_SPAN = 1000
local AL_NEW_DIFFICULT_INTERNAL = 1000

function ActivityKillZombieManager:__init()
  self.templateDic = nil
  self.activityId = nil
  self.isNewFuncOpen = nil
  self.selectedConfigId = nil
  self.newAlData = nil
  self.newAllianceChallengeDonateInfo = nil
  self.maxAlOpenDifficulty = nil
  self.maxOpenLevel = nil
  self.maxReachLevel = nil
  self.selectMaxPersonalDamage = 0
  self.selectMaxAllianceDamage = 0
  self:AddListeners()
end

function ActivityKillZombieManager:__delete()
  self.templateDic = nil
  self.activityId = nil
  self.isNewFuncOpen = nil
  self.selectedConfigId = nil
  self.newAlData = nil
  self.newAllianceChallengeDonateInfo = nil
  self.maxAlOpenDifficulty = nil
  self.maxOpenLevel = nil
  self.maxReachLevel = nil
  self.selectMaxPersonalDamage = nil
  self.selectMaxAllianceDamage = nil
  self:RemoveListeners()
end

local function AddListeners(self)
  self:RegisterEvent(EventId.ChallengeZombieGetLaunchStationPoint, self.OnPutPointGot)
  self:RegisterEvent(EventId.OnEnterCity, self.ExitWorld)
  self:RegisterEvent(EventId.OnEnterWorld, self.EnterWorld)
end

local function RemoveListeners(self)
  self:UnregisterEvent(EventId.ChallengeZombieGetLaunchStationPoint)
  self:UnregisterEvent(EventId.OnEnterCity)
  self:UnregisterEvent(EventId.OnEnterWorld)
end

local function GetDifficultyLevel(difficulty)
  if not difficulty then
    return 0
  end
  if difficulty < 0 then
    return 0
  end
  local difficultyLevel = difficulty // ADVANCE_LEVEL_SPAN
  return difficultyLevel
end

local function GetRelDifficultyInLevel(difficulty)
  if not difficulty then
    return 0
  end
  if difficulty < 0 then
    return 0
  end
  local realDifficultyInLevel = difficulty % ADVANCE_LEVEL_SPAN
  return realDifficultyInLevel
end

local function parseLine(dataAll, id, lineData)
  local vType = lineData:getIntValue("type", 0)
  local data = {}
  data.id = id
  data.ui_type = vType
  local difficulty = lineData:getIntValue("difficulty", 0)
  data.difficulty = difficulty
  if vType == 2 then
    if DataCenter.ActivityKillZombieManager.isNewFuncOpen then
      if difficulty < AL_NEW_DIFFICULT_INTERNAL then
        return
      else
        data.difficulty = difficulty % ADVANCE_LEVEL_SPAN
      end
    elseif difficulty > AL_NEW_DIFFICULT_INTERNAL then
      return
    end
  end
  dataAll[tostring(id)] = data
  data.difficultyLevel = GetDifficultyLevel(data.difficulty)
  data.relDifficultyInLevel = GetRelDifficultyInLevel(data.difficulty)
  data.power_requirement = lineData:getIntValue("power_requirement", 0)
  if (data.ui_type == 1 or data.ui_type == 2) and data.difficulty ~= nil and type(data.difficulty) == "number" and 0 < data.difficulty then
    local monster_list = lineData:getValue("monster_list")
    local monsterList = {}
    local firstMonster
    for monsterId in string.gmatch(monster_list, "([^,]+)|?") do
      if monsterId ~= nil and monsterId ~= "" then
        if firstMonster == nil then
          firstMonster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
        end
        table.insert(monsterList, monsterId)
      end
    end
    data.monsterList = monsterList
    data.firstMonster = firstMonster
    local finish_reward = lineData:getValue("finish_reward")
    local rewardList = {}
    for item in string.gmatch(finish_reward, "([^|]+)|?") do
      if item ~= nil and item ~= "" then
        local level, rewardId = string.match(item, "(%d+)[:,;](%d+)")
        if level ~= nil and rewardId ~= nil then
          local monsterLevel = tonumber(level)
          table.insert(rewardList, {
            monsterId = monsterList[monsterLevel],
            rewardId = rewardId,
            monsterLevel = monsterLevel
          })
        end
      end
    end
    data.rewardList = rewardList
    data.displayRallyReward = DataCenter.RewardManager:ParseRewardsStr(lineData:getValue("call_rally_reward_display"))
    data.displayJoinReward = DataCenter.RewardManager:ParseRewardsStr(lineData:getValue("rally_participation_reward_display"))
    data.condition = lineData:getValue("condition")
    data.open_time = lineData:getValue("open_time")
    data.advanced_challenge_boss = lineData:getValue("advanced_challenge_boss")
    return data
  end
  return nil
end

function ActivityKillZombieManager:InitAllTemplate()
  local ListPerson = {
    data = {},
    min = 1,
    max = 1,
    difficultLevelGroup = {}
  }
  local ListAL = {
    data = {},
    min = 1,
    max = 1,
    difficultLevelGroup = {}
  }
  local dataAll = {}
  LocalController:instance():visitTable(TableName.activity_challenge_zombie, function(id, lineData)
    local data = parseLine(dataAll, id, lineData)
    if data ~= nil then
      if data.ui_type == 1 then
        ListPerson.data[data.difficulty] = data
        ListPerson.min = math.min(ListPerson.min, data.difficulty)
        ListPerson.max = math.max(ListPerson.max, data.difficulty)
        local curDifficultLevel = ListPerson.difficultLevelGroup[data.difficultyLevel]
        if curDifficultLevel == nil then
          curDifficultLevel = {
            min = data.difficulty,
            max = data.difficulty
          }
          ListPerson.difficultLevelGroup[data.difficultyLevel] = curDifficultLevel
        end
        curDifficultLevel.min = math.min(curDifficultLevel.min, data.difficulty)
        curDifficultLevel.max = math.max(curDifficultLevel.max, data.difficulty)
      elseif data.ui_type == 2 then
        ListAL.data[data.difficulty] = data
        ListAL.min = math.min(ListAL.min, data.difficulty)
        ListAL.max = math.max(ListAL.max, data.difficulty)
        local curDifficultLevel = ListAL.difficultLevelGroup[data.difficultyLevel]
        if curDifficultLevel == nil then
          curDifficultLevel = {
            min = data.difficulty,
            max = data.difficulty
          }
          ListAL.difficultLevelGroup[data.difficultyLevel] = curDifficultLevel
        end
        curDifficultLevel.min = math.min(curDifficultLevel.min, data.difficulty)
        curDifficultLevel.max = math.max(curDifficultLevel.max, data.difficulty)
      end
    end
  end)
  self.templateDic = {}
  self.templateDic[1] = ListPerson
  self.templateDic[2] = ListAL
  self.templateDic.ALL = dataAll
  for id, data in pairs(dataAll) do
    if not string.IsNullOrEmpty(data.condition) then
      for item in string.gmatch(data.condition, "([^;]+);?") do
        if item ~= nil and item ~= "" then
          local params = string.split(item, ",")
          local dataId = params[1]
          local level = params[2]
          local count = params[3]
          if dataId ~= nil and level ~= nil and count ~= nil then
            local tmp = dataAll[dataId]
            if tmp ~= nil then
              if data.conditionList == nil then
                data.conditionList = {}
              end
              table.insert(data.conditionList, {
                count = count,
                data = tmp,
                level = level
              })
            end
          end
        end
      end
    end
    if data.openTime == nil then
      data.openTime = {}
      data.openTime.season = 0
      data.openTime.seasonDay = 0
    end
    if not string.IsNullOrEmpty(data.open_time) then
      local dayStrs = string.split(data.open_time, ";")
      if dayStrs[1] then
        local season = tonumber(dayStrs[1]) or 0
        data.openTime.season = season == -1 and math.maxinteger or season
      end
      if dayStrs[2] then
        local seasonDay = tonumber(dayStrs[2]) or 0
        data.openTime.seasonDay = seasonDay
      end
    end
  end
end

function ActivityKillZombieManager:IsDifficultyLevelOpenedBySeasonTime(type, difficultyLevel)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  local data = self.templateDic[type]
  if data == nil then
    return false
  end
  local difficultyLevelGroup = data.difficultLevelGroup[difficultyLevel]
  if difficultyLevelGroup == nil then
    return false
  end
  local minDifficultyInCurLevel = difficultyLevelGroup.min
  return self:IsDifficultyOpenedBySeasonTime(type, minDifficultyInCurLevel)
end

function ActivityKillZombieManager:IsDifficultyOpenedBySeasonTime(type, difficulty)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  local data = self.templateDic[type]
  if data == nil then
    return false
  end
  local difficultyData = data.data[difficulty]
  if not difficultyData then
    return false
  end
  local minOpenSeason = difficultyData.openTime.season
  local minOpenSeasonDay = difficultyData.openTime.seasonDay
  local season, seasonDay = DataCenter.SeasonDataManager:GetNowSeasonAndSeasonDay()
  if minOpenSeason > season or minOpenSeason == season and minOpenSeasonDay > seasonDay then
    return false
  end
  return true
end

function ActivityKillZombieManager:GetMinMaxDifficultyWithTypeAndDifficultyLevel(type, difficultyLevel)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  local data = self.templateDic[type]
  if data == nil or data.difficultLevelGroup[difficultyLevel] == nil then
    return 0, 0
  end
  local difficultyLevelGroup = data.difficultLevelGroup[difficultyLevel]
  return difficultyLevelGroup.min, difficultyLevelGroup.max
end

function ActivityKillZombieManager:GetDatasWithTypeAndDifficultyLevel(type, difficultyLevel)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  local data = self.templateDic[type]
  if data == nil then
    return nil
  end
  local typeDatas = data.data
  local levelData
  for difficulty, typeData in pairs(typeDatas) do
    if typeData.difficultyLevel == difficultyLevel then
      levelData = levelData or {
        data = {},
        min = difficulty,
        max = difficulty
      }
      levelData.data[difficulty] = typeData
      levelData.min = math.min(levelData.min, difficulty)
      levelData.max = math.max(levelData.max, difficulty)
    end
  end
  return levelData
end

function ActivityKillZombieManager:GetDataWithTypeAndLevel(type, difficulty)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  local data = self.templateDic[type]
  if data == nil then
    return nil
  end
  return data.data[difficulty]
end

function ActivityKillZombieManager:GetListByType(type)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  return self.templateDic[type]
end

function ActivityKillZombieManager:GetPersonRewardList()
  local dataList = DataCenter.ActivityKillZombieManager:GetListByType(1)
  local now_difficulty = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 1)
  local now_data = dataList.data[now_difficulty]
  if now_data == nil then
    now_data = dataList.data[1]
  end
  if now_data.rewardListServer.allRewards == nil then
    now_data.rewardListServer.allRewards = DataCenter.RewardManager:ParseRewardsStr(now_data.rewardListServer.all)
  end
  return now_data.rewardListServer.allRewards
end

function ActivityKillZombieManager:GetAllianceRewardNow(now_difficulty)
  local dataList = DataCenter.ActivityKillZombieManager:GetListByType(2)
  local now_data = dataList.data[now_difficulty]
  if now_data == nil then
    now_data = dataList.data[1]
  end
  local rewardListServer = now_data.rewardListServer
  local levelList = rewardListServer.levelList
  for _, level in ipairs(levelList) do
    return rewardListServer[tostring(level)]
  end
  return nil
end

function ActivityKillZombieManager:IsOver(difficulty)
  local kill_zombie_AL = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
  if kill_zombie_AL == nil then
    return false
  end
  local dataStatus = kill_zombie_AL[tostring(difficulty)]
  if dataStatus == nil or dataStatus.status > 0 then
    return true
  end
  return false
end

function ActivityKillZombieManager:CanInvokeBossZombie(difficulty)
  local kill_zombie_AL = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
  if kill_zombie_AL == nil then
    return false
  end
  if difficulty == 0 then
    return false
  end
  local dataStatus = kill_zombie_AL[tostring(difficulty)]
  if dataStatus == nil then
    return false
  end
  if dataStatus ~= nil and dataStatus.monster ~= nil then
    return true
  end
  local finish_count = dataStatus.progress or 0
  local dataList = DataCenter.ActivityKillZombieManager:GetListByType(2)
  local data = dataList.data[tonumber(difficulty)]
  local conditionList = data.conditionList
  if conditionList ~= nil then
    for _, v in ipairs(conditionList) do
      if v.data.ui_type == 1 and kill_zombie_AL ~= nil and finish_count >= tonumber(v.count) then
        return true
      end
    end
    return false
  else
    return true
  end
end

function ActivityKillZombieManager:CanInvokeBossZombieAndProgress(difficulty)
  local kill_zombie_AL = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
  if kill_zombie_AL == nil then
    return false, 0
  end
  if difficulty == 0 then
    return false, 0
  end
  local dataStatus = kill_zombie_AL[tostring(difficulty)]
  if dataStatus == nil then
    return false, 0
  end
  if dataStatus ~= nil and dataStatus.monster ~= nil then
    return true, 1
  end
  local finish_count = dataStatus.progress or 0
  local dataList = DataCenter.ActivityKillZombieManager:GetListByType(2)
  local data = dataList.data[tonumber(difficulty)]
  local conditionList = data.conditionList
  local maxProgress = 0
  if conditionList ~= nil then
    for _, v in ipairs(conditionList) do
      if v.data.ui_type == 1 then
        local totalCount = tonumber(v.count)
        if finish_count >= totalCount then
          return true, 1
        else
          local progresss = finish_count / math.max(totalCount, 1)
          maxProgress = math.max(maxProgress, progresss)
        end
      end
    end
    return false, maxProgress
  else
    return true
  end
end

function ActivityKillZombieManager:Get(difficulty)
  local dataList = self:GetListByType(2)
  local data = dataList.data[difficulty]
  return data and data.conditionList or nil
end

function ActivityKillZombieManager:GetALChallengeConditionList(difficulty)
  local dataList = self:GetListByType(2)
  local data = dataList.data[difficulty]
  return data and data.conditionList or nil
end

function ActivityKillZombieManager:JumpToPersonMonster()
  if not SceneUtils.CheckCanGotoWorld() then
    return
  end
  if LuaEntry.Player:GetMainWorldPos() < 0 then
    SFSNetwork.SendMessage(MsgDefines.MoveCityToWorld)
  end
  local kill_zombie_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO)
  if kill_zombie_data.monsters ~= nil then
    local monsterIndex = 1
    for index, v in ipairs(kill_zombie_data.monsters) do
      if v.activeAttack then
        monsterIndex = index + 1
        v.activeAttack = false
      end
    end
    local v = kill_zombie_data.monsters[monsterIndex]
    if v == nil then
      v = kill_zombie_data.monsters[1]
    end
    if v == nil then
      SFSNetwork.SendMessage(MsgDefines.KillZombiePersonMonster)
    else
      v.activeAttack = true
      local pointId = v.pointId
      local monsterUid = v.monsterUid
      if CS.SceneManager.World then
        local marchInfo = CS.SceneManager.World:GetMarch(monsterUid)
        if marchInfo == nil then
          SFSNetwork.SendMessage(MsgDefines.KillZombiePersonMonster)
        else
          GoToUtil.CloseAllWindows()
          GoToUtil.MoveToWorldPointAndOpen(pointId, nil, monsterUid)
        end
      end
    end
  elseif kill_zombie_data.monster ~= nil and kill_zombie_data.monster.pointId ~= nil then
    if CS.SceneManager.World then
      local monsterUid = kill_zombie_data.monster.monsterUid
      local marchInfo = CS.SceneManager.World:GetMarch(monsterUid)
      if marchInfo == nil then
        SFSNetwork.SendMessage(MsgDefines.KillZombiePersonMonster)
      else
        GoToUtil.CloseAllWindows()
        GoToUtil.MoveToWorldPointAndOpen(kill_zombie_data.monster.pointId, nil, kill_zombie_data.monster.monsterUid)
      end
    end
  else
    SFSNetwork.SendMessage(MsgDefines.KillZombiePersonMonster)
  end
end

function ActivityKillZombieManager:HasPersonMonsterReward()
  local kill_zombie_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO)
  if kill_zombie_data ~= nil then
    local kill_count = kill_zombie_data.count or 0
    local difficulty_select = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
    local dataList = DataCenter.ActivityKillZombieManager:GetListByType(1)
    if dataList and dataList.data then
      local now_data = dataList.data[difficulty_select]
      if now_data and now_data.rewardListServer then
        local levelList = now_data.rewardListServer.levelList
        for _, needCount in ipairs(levelList) do
          if needCount <= kill_count and not string.contains(kill_zombie_data.rewardInfo .. ",", needCount .. ",") then
            return true
          end
        end
      end
    end
  end
  return false
end

function ActivityKillZombieManager:GetDifficultyByMonsterId(monsterId)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  local dic = self.templateDic.ALL
  if dic then
    for k, v in pairs(dic) do
      if table.hasvalue(v.monsterList, tostring(monsterId)) then
        return v.difficulty
      end
    end
  end
end

local function InitNewChallengeInfo(self, allianceNew)
  if allianceNew ~= nil and allianceNew.isChallengeNew then
    if self.isNewFuncOpen ~= allianceNew.isChallengeNew and self.templateDic ~= nil then
      self.templateDic = nil
    end
    self.isNewFuncOpen = allianceNew.isChallengeNew
    if self.newAlData == nil then
      self.newAlData = AlChallengeKirovInfo.New()
    end
    self.newAlData:ParseData(allianceNew)
    self.newAllianceChallengeDonateInfo = allianceNew.donateInfo
  else
    self.isNewFuncOpen = nil
    if self.newAlData then
      self.newAlData:Delete()
      self.newAlData = nil
    end
    self.newAllianceChallengeDonateInfo = nil
  end
  EventManager:GetInstance():Broadcast(EventId.ChallengeZombieNewAlDataChanged)
  SFSNetwork.SendMessage(MsgDefines.KillZombieGetRewardList)
end

local function InitActivity(self, activityId)
  self.activityId = activityId
  SFSNetwork.SendMessage(MsgDefines.KillZombieDataPull)
  self.isPlanTimeFuncOpen = LuaEntry.DataConfig:CheckSwitch("appointment_advanced_challenge")
end

local function OnPutPointGot(self, message)
  if message then
    local errorCode = message.errorCode
    if errorCode ~= nil then
      return
    end
    local selectedConfigId = message.configId
    self.selectedConfigId = selectedConfigId
    local point = message.pointId
    self:GotoWorldPos(point, function()
      self:PutBossModel(point, selectedConfigId)
    end)
  end
end

local function GotoWorldPos(self, point, callback, serverId)
  if point and 0 < point then
    local pos = SceneUtils.TileIndexToWorld(point, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(pos, nil, nil, function()
      if callback then
        callback(point)
      end
    end, serverId)
  end
end

local function PutBossModel(self, point, configId)
  if point and 0 < point and configId then
    local bossId = GetTableData(TableName.activity_challenge_zombie, configId, "advanced_challenge_boss")
    if bossId then
      local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(bossId)
      if template then
        local monsterId = template.world_monster
        local modelPath = template.boss_put_model
        if monsterId then
          local size = GetTableData(TableName.Monster, tonumber(monsterId), "size")
          if not string.IsNullOrEmpty(modelPath) and size and 0 < size then
            GoToUtil.CloseAllWindows()
            UIUtil.UICreateWorldMovingModel(modelPath, FakeMovingModelFlag.KirovLaunchStation, point, size)
          end
        end
      end
    end
  end
end

function ActivityKillZombieManager:RequestPutNewBuildPoint(selectedConfigId)
  local line = LocalController:instance():getLine(TableName.activity_challenge_zombie, selectedConfigId)
  if line then
    local bossId = line.advanced_challenge_boss
    if bossId == nil or bossId == 0 then
      return
    end
    local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(bossId)
    local dmgProgress = template and template.alliance_progress
    local maxDmg = 0
    if dmgProgress then
      maxDmg = string.GetFormattedStr0(dmgProgress and dmgProgress[#dmgProgress] or 0)
    end
    local str1, str2, lastLine
    if self.newAlData and self.newAlData.lastDamage == 0 then
      str1 = "challenge_zombie_start_confirmation_popup_low_new"
      str2 = "challenge_zombie_start_confirmation_popup_top_new"
    else
      str1 = "challenge_confirmation_popup_low_new_damage"
      str2 = "challenge_confirmation_popup_top_new_damage"
    end
    local lastDamage = string.GetFormattedStr0(self.newAlData.lastDamage)
    if self.newAlData and self.newAlData.lastConfigId and self.newAlData.lastConfigId ~= 0 then
      lastLine = LocalController:instance():getLine(TableName.activity_challenge_zombie, self.newAlData.lastConfigId)
    end
    local difficulty = line.difficulty % ADVANCE_LEVEL_SPAN
    local dialogId = difficulty < self.maxAlOpenDifficulty and str1 or str2
    local lastDiff = 0
    if lastLine then
      lastDiff = lastLine.difficulty % ADVANCE_LEVEL_SPAN
    end
    local context = CS.GameEntry.Localization:GetString(dialogId, difficulty, self.maxAlOpenDifficulty, lastDiff, lastDamage, maxDmg)
    local param = {
      contentText = context,
      btnNum = 2,
      confirmBtnParam = {
        action = function()
          SFSNetwork.SendMessage(MsgDefines.AllianceChallengeNewBuildPoint, selectedConfigId)
        end
      }
    }
    UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.KillZombieAlBossChallenge, param)
  end
end

local function RequestPutKirov(self, point, callback)
  if self.selectedConfigId and point and 0 < point then
    local line = LocalController:instance():getLine(TableName.activity_challenge_zombie, self.selectedConfigId)
    if line then
      local bossId = line.advanced_challenge_boss
      if bossId == nil or bossId == 0 then
        return
      end
      local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(bossId)
      if template == nil then
        return
      end
      local dmgProgress = template.alliance_progress
      local maxDmg = 0
      if dmgProgress then
        maxDmg = string.GetFormattedStr0(dmgProgress and dmgProgress[#dmgProgress] or 0)
      end
      local str1, str2
      if self.newAlData and self.newAlData.lastDamage == 0 then
        str1 = "challenge_zombie_start_confirmation_popup_low"
        str2 = "challenge_zombie_start_confirmation_popup_top"
      else
        str1 = "challenge_confirmation_popup_low_damage"
        str2 = "challenge_confirmation_popup_top_damage"
      end
      local lastDamage = string.GetFormattedStr0(self.newAlData.lastDamage)
      local lastLine
      if self.newAlData and self.newAlData.lastConfigId and self.newAlData.lastConfigId ~= 0 then
        lastLine = LocalController:instance():getLine(TableName.activity_challenge_zombie, self.newAlData.lastConfigId)
      end
      local challengeTime = template.challenge_time
      if challengeTime and 0 < challengeTime then
        local difficulty = line.difficulty % ADVANCE_LEVEL_SPAN
        local dialogId = difficulty < self.maxAlOpenDifficulty and str1 or str2
        local lastDiff = 0
        if lastLine then
          lastDiff = lastLine.difficulty % ADVANCE_LEVEL_SPAN
        end
        local context = CS.GameEntry.Localization:GetString(dialogId, challengeTime / 60, difficulty, self.maxAlOpenDifficulty, lastDiff, lastDamage, maxDmg)
        local configId = self.selectedConfigId
        local param = {
          contentText = context,
          btnNum = 2,
          confirmBtnParam = {
            action = function()
              SFSNetwork.SendMessage(MsgDefines.AllianceChallengeNewBuildToWorld, configId, point, self.planeTimeCache)
              CS.SceneManager.World:SetTouchInputControllerEnable(true)
              if callback then
                callback()
              end
            end
          },
          cancelBtnParam = {
            action = function()
              CS.SceneManager.World:SetTouchInputControllerEnable(true)
            end
          },
          closeAction = function()
            CS.SceneManager.World:SetTouchInputControllerEnable(true)
          end
        }
        CS.SceneManager.World:SetTouchInputControllerEnable(false)
        if self.isPlanTimeFuncOpen then
          param.confirmBtnParam.action()
        else
          UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.KillZombieAlBossChallenge, param)
        end
      end
    end
  end
end

local function EnterWorld(self)
  DataCenter.KillZombieCtrlManager:EnterWorld()
end

local function ExitWorld(self)
  DataCenter.KillZombieCtrlManager:ExitWorld()
end

local function GetNewChallengeRedPoint(self)
  if self.isNewFuncOpen and self.newAlData then
    local oldAllianceId = self.newAlData.oldAllianceId
    if oldAllianceId ~= nil and oldAllianceId ~= "" and oldAllianceId ~= LuaEntry.Player:GetAllianceUid() then
      return false
    elseif self.newAlData.keyNum == 0 then
      return false
    end
    return self.newAlData.stage == ChallengeZombieAlBossStage.Settlement and not self.newAlData.isRewarded
  end
end

local function GetBoxPointData(self, uuid)
  if uuid then
    local oneData = {}
    oneData.uuid = uuid
    oneData.name = "challenge_zombie_box_title"
    oneData.shareName = "challenge_zombie_box_title"
    return oneData
  end
end

local function TryShowBoxView(self, point)
  if not self.newAlData then
    UIUtil.ShowTipsId("challenge_zombie_box_level_unable")
    return
  end
  local activityId = DataCenter.ActivityKillZombieManager.activityId
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if actData == nil then
    UIUtil.ShowTipsId("challenge_zombie_box_level_unable")
    return
  end
  local oldAllianceId = self.newAlData.oldAllianceId
  if oldAllianceId ~= nil and oldAllianceId ~= "" and oldAllianceId ~= LuaEntry.Player:GetAllianceUid() then
    UIUtil.ShowTipsId("challenge_zombie_reward_mismatch_alliance")
    return
  end
  if self.newAlData.keyNum == 0 then
    UIUtil.ShowTipsId("challenge_zombie_reward_fail_alliance")
    return
  end
  if not point then
    return
  end
  local info = CS.SceneManager.World:GetPointInfo(point)
  if not info or not info.treasurePointInfo then
    return
  end
  local param
  local treasurePointInfo = info.treasurePointInfo
  if treasurePointInfo and treasurePointInfo.allianceId == LuaEntry.Player:GetAllianceUid() then
    if self.newAlData.isRewarded then
      param = {
        bossId = self.newAlData.bossId,
        uid = LuaEntry.Player:GetUid()
      }
    else
      param = {
        panelType = 1,
        bossId = self.newAlData.bossId,
        uid = LuaEntry.Player:GetUid()
      }
    end
  end
  if not param then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.KillZombieBoxUpgrade, {anim = true}, param)
end

local function TryShowHowToPlay(self, actData)
  if actData ~= nil and actData ~= nil then
    local key = {}
    local story = ""
    local keyStr = LuaEntry.DataConfig:TryGetStr("advanced_challenge", "k2")
    if keyStr ~= nil and keyStr ~= "" then
      local allArr = string.split(keyStr, ";")
      if allArr and 0 < #allArr then
        for i, v in ipairs(allArr) do
          if v then
            local arr = string.split(v, "|")
            if arr and 4 <= #arr and self:CheckShowOpenCondition(tonumber(arr[1]), tonumber(arr[2])) then
              local keys = arr[3]
              key = keys and string.split(keys, ",")
              story = arr[4]
            end
          end
        end
      end
    end
    if key ~= nil and key ~= "" then
      local param = {}
      param.howToPlayList = key
      param.story = story
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
      return true
    end
  end
end

local function CheckShowOpenCondition(self, season, days)
  return season < self.season or self.season == season and days <= self:GetSeasonDays()
end

local function GetSeason(self)
  self.season = DataCenter.SeasonDataManager:GetSeason()
  return self.season
end

local function GetSeasonDays(self)
  local _, seasonDays = DataCenter.SeasonDataManager:GetNowSeasonAndSeasonDay()
  return seasonDays
end

local function OnBossAttacked(self, message)
  if message and message.targetList then
    if not UIManager:GetInstance():CheckIfIsMainUIOpenOnly(true) then
      return
    end
    UIUtil.ShowAttackUnitsTips(AttackerBossType.ZoneMobilizationBoss, message.targetList)
  end
end

function ActivityKillZombieManager:OnPushNewAllianceChallengeDonateInfo(message)
  self.newAllianceChallengeDonateInfo = message
  EventManager:GetInstance():Broadcast(EventId.OnNewAllianceChallengeDonateInfoRefresh)
end

function ActivityKillZombieManager:CheckNewAllianceChallengeDonateInfoShow()
  if self.isNewFuncOpen then
    local newAlData = self.newAlData
    if newAlData and newAlData.bossUuid > 0 and newAlData.stage > ChallengeZombieAlBossStage.None and newAlData.stage < ChallengeZombieAlBossStage.Settlement then
      local donateInfo = self.newAllianceChallengeDonateInfo
      if donateInfo and donateInfo.configId and donateInfo.endTimeStamp and 0 < donateInfo.endTimeStamp then
        local now = UITimeManager:GetInstance():GetServerTime()
        if now < donateInfo.endTimeStamp then
          return true
        end
      end
    end
  end
  return false
end

local function GetDifficultyRemindSwitchOn(self)
  return LuaEntry.DataConfig:CheckSwitch("challenge_person_check")
end

local function GetAlMaxOpenDifficulty()
  local self = DataCenter.ActivityKillZombieManager
  local dataList = self:GetListByType(2)
  if table.IsNullOrEmpty(dataList) then
    self.maxAlOpenDifficulty = 0
    return self.maxAlOpenDifficulty
  end
  local max = 0
  for difficulty = dataList.min, dataList.max do
    local cfgData = dataList.data[difficulty]
    if cfgData and self:CheckShowOpenCondition(cfgData.openTime.season, cfgData.openTime.seasonDay) then
      max = difficulty
    end
  end
  self.maxAlOpenDifficulty = max
  return self.maxAlOpenDifficulty
end

local function GetMaxOpenDifficulty(self)
  local self = DataCenter.ActivityKillZombieManager
  local dataList = self:GetDatasWithTypeAndDifficultyLevel(1, 1)
  if dataList == nil then
    self.maxOpenLevel = 0
    return self.maxOpenLevel
  end
  local maxOpenLevel = 0
  for dif = dataList.min, dataList.max do
    local data = dataList.data[dif]
    if data ~= nil then
      local isSeasonOpen = self:IsDifficultyOpenedBySeasonTime(1, dif)
      if isSeasonOpen then
        maxOpenLevel = dif
      end
    end
  end
  self.maxOpenLevel = maxOpenLevel
  return self.maxOpenLevel
end

local function GetMaxReachDifficulty(self)
  local curMaxSelectableDifficulty = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_MAX, 0)
  local curMaxSelectableDifficultyLevel = self.GetDifficultyLevel(curMaxSelectableDifficulty)
  local _, curDifficultyLevelMax = self:GetMinMaxDifficultyWithTypeAndDifficultyLevel(1, curMaxSelectableDifficultyLevel)
  if curMaxSelectableDifficulty > curDifficultyLevelMax then
    local nextDifficultyLevel = curMaxSelectableDifficultyLevel + 1
    local nextDifficultyLevelMin, _ = self:GetMinMaxDifficultyWithTypeAndDifficultyLevel(1, nextDifficultyLevel)
    if 0 < nextDifficultyLevelMin then
      curMaxSelectableDifficulty = nextDifficultyLevelMin
    end
  end
  self.maxReachLevel = math.min(curMaxSelectableDifficulty, self.maxOpenLevel)
  return self.maxReachLevel
end

function ActivityKillZombieManager:SetBossPlanTime(timeStamp)
  self.planeTimeCache = timeStamp
  local tDate = UITimeManager:GetInstance():TimeStampToServerDate(timeStamp)
  self.tDate = tDate
end

function ActivityKillZombieManager:GetBossPlanTimeFromServer()
  return self.newAlData and self.newAlData.planTime or nil
end

function ActivityKillZombieManager:IsOverPlanTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local planTime = self:GetBossPlanTimeFromServer()
  if not planTime then
    return false
  end
  return curTime > planTime
end

function ActivityKillZombieManager:GetLastPlanTime()
  return self.newAlData and self.newAlData.lastPlanTime or 0
end

function ActivityKillZombieManager:GetLastConfigId()
  return self.newAlData and self.newAlData.lastConfigId or nil
end

function ActivityKillZombieManager:GetLastDamage()
  return self.newAlData and self.newAlData.lastDamage or 0
end

function ActivityKillZombieManager:GetIsPlanTimeFuncOpen()
  return self.isPlanTimeFuncOpen
end

function ActivityKillZombieManager:GetSelectMaxPersonalDamage()
  if self.selectMaxPersonalDamage and self.selectMaxPersonalDamage ~= 0 then
    return self.selectMaxPersonalDamage
  end
  local lastDmg = 0
  if self.newAlData == nil or self.newAlData.bossId == nil then
    return lastDmg
  end
  local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(self.newAlData.bossId)
  if template then
    local progressData = template.player_progress
    if progressData then
      lastDmg = progressData[#progressData]
    end
  end
  self.selectMaxPersonalDamage = lastDmg
  return self.selectMaxPersonalDamage
end

function ActivityKillZombieManager:GetSelectMaxAllianceDamage()
  if self.selectMaxAllianceDamage and self.selectMaxAllianceDamage ~= 0 then
    return self.selectMaxAllianceDamage
  end
  local lastDmg = 0
  if self.newAlData == nil or self.newAlData.bossId == nil then
    return lastDmg
  end
  local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(self.newAlData.bossId)
  if template then
    local progressData = template.alliance_progress
    if progressData then
      lastDmg = progressData[#progressData]
    end
  end
  self.selectMaxAllianceDamage = lastDmg
  return self.selectMaxAllianceDamage
end

function ActivityKillZombieManager:GetActivityData()
  if self.newAlData then
    local activityId = DataCenter.ActivityKillZombieManager.activityId
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
    return actData
  end
  return nil
end

function ActivityKillZombieManager:CheckAllChallengeDmgNewFunctionOn()
  if self.allChallengeDmgSwitch == nil then
    self.allChallengeDmgSwitch = LuaEntry.DataConfig:CheckSwitch("rank_advanced_challenge")
  end
  return self.allChallengeDmgSwitch
end

ActivityKillZombieManager.AddListeners = AddListeners
ActivityKillZombieManager.RemoveListeners = RemoveListeners
ActivityKillZombieManager.GetDifficultyLevel = GetDifficultyLevel
ActivityKillZombieManager.GetRelDifficultyInLevel = GetRelDifficultyInLevel
ActivityKillZombieManager.InitNewChallengeInfo = InitNewChallengeInfo
ActivityKillZombieManager.InitActivity = InitActivity
ActivityKillZombieManager.OnPutPointGot = OnPutPointGot
ActivityKillZombieManager.GotoWorldPos = GotoWorldPos
ActivityKillZombieManager.PutBossModel = PutBossModel
ActivityKillZombieManager.RequestPutKirov = RequestPutKirov
ActivityKillZombieManager.EnterWorld = EnterWorld
ActivityKillZombieManager.ExitWorld = ExitWorld
ActivityKillZombieManager.GetNewChallengeRedPoint = GetNewChallengeRedPoint
ActivityKillZombieManager.TryShowBoxView = TryShowBoxView
ActivityKillZombieManager.GetBoxPointData = GetBoxPointData
ActivityKillZombieManager.TryShowHowToPlay = TryShowHowToPlay
ActivityKillZombieManager.CheckShowOpenCondition = CheckShowOpenCondition
ActivityKillZombieManager.getters.season = GetSeason
ActivityKillZombieManager.GetSeasonDays = GetSeasonDays
ActivityKillZombieManager.OnBossAttacked = OnBossAttacked
ActivityKillZombieManager.GetDifficultyRemindSwitchOn = GetDifficultyRemindSwitchOn
ActivityKillZombieManager.getters.maxAlOpenDifficulty = GetAlMaxOpenDifficulty
ActivityKillZombieManager.getters.maxOpenLevel = GetMaxOpenDifficulty
ActivityKillZombieManager.getters.maxReachLevel = GetMaxReachDifficulty
return ActivityKillZombieManager
