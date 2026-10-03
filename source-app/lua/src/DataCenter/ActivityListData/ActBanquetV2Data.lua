local ActBanquetV2Data = BaseClass("ActBanquetV2Data")
local ActivityFreeRewardData = require("DataCenter.ActivityFreeRewardData.ActivityFreeRewardData")
local ActivityPartynewDropshowTemplate = require("DataCenter/ActBanquetAttackMonster/ActivityPartynewDropshowTemplate")

local function __init(self)
  self.activityId = 0
  self.actBanquetId = 0
  self.banquetLevel = 0
  self.score = 0
  self.rankScore = 0
  self.contribution = 0
  self.levelReward = {}
  self.receiveReward = {}
  self.activityFreeRewardData = ActivityFreeRewardData.New()
  self.selfRank = {}
  self.selfAllyRank = {}
  self.personRankList = {}
  self.allyRankList = {}
  self.selfRankReward = -1
  self.selfAllyRankReward = -1
  self.personRankReward = {}
  self.allyRankReward = {}
  self.taskArr = {}
  self.taskArrData = {}
  self.index = 1
  self.state = 0
  self.blood = 0
  self.actBanquetTemplate = nil
  self.isTriggerPress = false
  self.itemDropProbCfg = nil
  self.extraReward = {}
  self.battleLogList = {}
  self.historyRewardList = {}
  self.costItems = 0
end

local function __delete(self)
  self.activityId = nil
  self.actBanquetId = nil
  self.banquetLevel = nil
  self.score = nil
  self.rankScore = nil
  self.contribution = nil
  self.levelReward = nil
  self.receiveReward = nil
  self.activityFreeRewardData = nil
  self.selfRank = nil
  self.selfAllyRank = nil
  self.personRankList = nil
  self.allyRankList = nil
  self.selfRankReward = nil
  self.selfAllyRankReward = nil
  self.personRankReward = nil
  self.allyRankReward = nil
  self.taskArr = nil
  self.taskArrData = nil
  self.index = nil
  self.state = nil
  self.blood = nil
  self.actBanquetTemplate = nil
  self.isTriggerPress = nil
  self.itemDropProbCfg = nil
  self.extraReward = nil
  self.battleLogList = nil
  self.historyRewardList = nil
  self.costItems = nil
end

local function ParseInfo(self, message)
  if message == nil then
    return
  end
  if message.id then
    self.actBanquetId = message.id
    self.actBanquetTemplate = DataCenter.ActivityPartyNewTemplateManager:GetActBanquetTemplate(self.actBanquetId)
  end
  if message.score then
    self.score = message.score
  end
  if message.rankScore then
    self.rankScore = message.rankScore
  end
  if message.level then
    self.banquetLevel = message.level
  end
  table.clear(self.levelReward)
  if message.level_reward then
    for i = 1, table.count(message.level_reward) do
      table.insert(self.levelReward, message.level_reward[i].rewards)
    end
  end
  table.clear(self.receiveReward)
  if message.levels then
    local strArray = string.split(message.levels, ",")
    if not string.IsNullOrEmpty(strArray) then
      for i = 1, table.count(strArray) do
        table.insert(self.receiveReward, tonumber(strArray[i]))
      end
    end
  end
  if message.index then
    self.index = message.index
  end
  if message.monsterGroupId then
    self.monsterGroupId = message.monsterGroupId
  end
  if message.state then
    self.state = message.state
  end
  if message.blood then
    self.blood = message.blood
  end
  if message.extraReward then
    self.extraReward = message.extraReward
  end
  if message.nextResetTime then
    self.nextResetTime = message.nextResetTime
  end
  if message.remainAttackNum then
    self.remainAttackNum = message.remainAttackNum
  end
  self.activityFreeRewardData:ParseData(message)
end

local function ParseTaskDataInfo(self, message)
  if message.taskArr ~= nil then
    self.taskArr = message.taskArr
    self.taskArrData = {}
    for k, v in pairs(self.taskArr) do
      local taskTemp = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(v.taskId)
      local taskData = {data = v, temp = taskTemp}
      table.insert(self.taskArrData, taskData)
    end
    table.sort(self.taskArrData, function(a, b)
      if a.temp.order ~= b.temp.order then
        return a.temp.order < b.temp.order
      end
      return a.temp.id < b.temp.id
    end)
  end
end

local function SetActivityId(self, id)
  self.activityId = tonumber(id)
end

function ActBanquetV2Data:GetActivityId()
  return self.activityId
end

local function GetActScore(self)
  return self.score
end

function ActBanquetV2Data:GetActRankScore()
  return self.rankScore
end

function ActBanquetV2Data:GetMonsterGroupId()
  return self.monsterGroupId
end

function ActBanquetV2Data:GetNewMonsterId()
  if self.monsterGroupId == nil then
    return
  end
  local cfgRowData = LocalController:instance():getLine(TableName.LW_Activity_Party_Group, tostring(self.monsterGroupId))
  if cfgRowData == nil then
    Logger.LogError("\230\156\141\229\138\161\229\153\168\228\184\139\229\143\145\231\154\132\230\128\170\231\137\169GroupId\228\184\141\229\156\168\233\133\141\231\189\174\232\161\168\228\184\173\239\188\129")
    return
  end
  return cfgRowData.monster_id
end

function ActBanquetV2Data:GetMonsterTypeIdList()
  local monsterTypeIdDic = {}
  LocalController:instance():visitTable(TableName.LW_Activity_Party_Group, function(id, lineData)
    if lineData ~= nil then
      local monster_id = lineData:getIntValue("monster_id")
      monsterTypeIdDic[monster_id] = monster_id
    end
  end)
  local monsterTypeIdList = {}
  for k, v in pairs(monsterTypeIdDic) do
    table.insert(monsterTypeIdList, v)
  end
  return monsterTypeIdList
end

function ActBanquetV2Data:GetNextResetTime()
  return self.nextResetTime
end

function ActBanquetV2Data:GetRemainAttackNum()
  return self.remainAttackNum
end

local function GetCurBanquetLevel(self)
  return self.banquetLevel
end

local function GetBanquetMaxLevel(self)
  if self.actBanquetTemplate then
    return self.actBanquetTemplate.level_max
  end
end

local function GetBanquetAddScore(self)
  if self.actBanquetTemplate then
    return self.actBanquetTemplate.add_score
  end
end

local function GetBanquetAddGoodId(self)
  if self.actBanquetTemplate then
    return self.actBanquetTemplate.add_good_id
  end
end

local function GetBanquetAddGoodNum(self)
  if self.actBanquetTemplate then
    return self.actBanquetTemplate.add_good_num
  end
end

local function GetBanquetDonateItemId(self)
  if self.actBanquetTemplate then
    return self.actBanquetTemplate.donate_item_id
  end
end

local function GetActNextTargetScore(self)
  if self.actBanquetTemplate and not table.IsNullOrEmpty(self.actBanquetTemplate) then
    return self.actBanquetTemplate.level_dic[self.banquetLevel + 1]
  end
end

local function GetActScoreList(self)
  local ret = {}
  if self.actBanquetTemplate then
    for i = 1, self.actBanquetTemplate.level_max or 0 do
      local oneData = {}
      oneData.selfLevel = self.banquetLevel
      oneData.targetScore = self.actBanquetTemplate.level_dic[i]
      oneData.targetLevel = i
      oneData.state = table.hasvalue(self.receiveReward, i) and 1 or 0
      oneData.reward = self.levelReward[i]
      table.insert(ret, oneData)
    end
  end
  return ret
end

local function CanGotoPackShop(self)
  return self.activityFreeRewardData:CanGotoPackShop()
end

local function CanGetFreePack(self)
  return false
end

local function GetGiftPackId(self)
  return self.activityFreeRewardData:GetGiftPackId()
end

local function GetDonateHandle(self, message)
  if message == nil or message.id ~= self.actBanquetId or message.aid ~= self.activityId then
    return
  end
  if message.score then
    self.score = self.score + message.score
  end
  if message.contribution then
    self.contribution = message.contribution
  end
  if message.level then
    self.banquetLevel = message.level
  end
  local rewards = message.add_goods
  if rewards then
    DataCenter.RewardManager:AddRewards(rewards)
  end
  EventManager:GetInstance():Broadcast(EventId.OnBanquetDonate, message.add_goods)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetRankRewardHandle(self, message)
  if message == nil or message.id ~= self.actBanquetId then
    return
  end
  if message.type then
    local type = message.type
    if type == 0 then
      if message.self_rank then
        self.selfRankReward = message.self_rank
      end
      table.clear(self.personRankReward)
      if message.rewards then
        for i = 1, table.count(message.rewards) do
          local key = message.rewards[i].key
          local str = string.split(key, "-")
          if 1 < #str then
            local oneData = {}
            oneData.startN = tonumber(str[1])
            oneData.endN = tonumber(str[2])
            oneData.reward = message.rewards[i].rewards
            table.insert(self.personRankReward, oneData)
          end
        end
      end
    elseif type == 1 then
      if message.self_rank then
        self.selfAllyRankReward = message.self_rank
      end
      table.clear(self.allyRankReward)
      if message.rewards then
        for i = 1, table.count(message.rewards) do
          local key = message.rewards[i].key
          local str = string.split(key, "-")
          if 1 < #str then
            local oneData = {}
            oneData.startN = tonumber(str[1])
            oneData.endN = tonumber(str[2])
            oneData.reward = message.rewards[i].rewards
            table.insert(self.allyRankReward, oneData)
          end
        end
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ActBanquetRankRewardUpdate)
end

local function ParseRankingData(self, message)
  if not message or self.actBanquetId ~= message.id then
    return
  end
  local type = message.type
  local playerRankingInfoMsg = message.self
  if playerRankingInfoMsg then
    local selfPlayerData = BasePlayerInfo.New()
    selfPlayerData:ParseData(playerRankingInfoMsg)
    selfPlayerData.score = playerRankingInfoMsg.score
    selfPlayerData.ranking = playerRankingInfoMsg.rank
    if type == BanquetRankType.Personal then
      self.selfRank = selfPlayerData
    elseif type == BanquetRankType.Ally then
      self.selfAllyRank = selfPlayerData
    end
  end
  local rankingList = message.ranks
  if rankingList then
    for _, v in pairs(rankingList) do
      local playerData = BasePlayerInfo.New()
      playerData:ParseData(v)
      playerData.score = v.score
      playerData.ranking = v.rank
      if type == BanquetRankType.Personal then
        playerData.picVer = v.picver
        self.personRankList[playerData.ranking] = playerData
      elseif type == BanquetRankType.Ally then
        playerData.icon = v.icon
        playerData.aid = v.aid
        playerData.name = v.name
        self.allyRankList[playerData.ranking] = playerData
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ActBanquetRankUpdate)
end

local function GetFreeRewardHandle(self, message)
  if message == nil then
    return
  end
  local rewards = message.rewards
  if rewards then
    DataCenter.RewardManager:AddRewards(rewards)
    DataCenter.RewardManager:ShowCommonReward({reward = rewards})
  end
  self.activityFreeRewardData:OnReceiveFreeReward()
  EventManager:GetInstance():Broadcast(EventId.ActFreeRewardReceive)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetLevelRewardHandle(self, message)
  if message == nil then
    return
  end
  local rewards = message.rewards
  if rewards then
    DataCenter.RewardManager:AddRewards(rewards)
    DataCenter.RewardManager:ShowCommonReward({reward = rewards})
  end
  table.clear(self.receiveReward)
  if message.levels then
    local strArray = string.split(message.levels, ",")
    if not string.IsNullOrEmpty(strArray) then
      for i = 1, table.count(strArray) do
        table.insert(self.receiveReward, tonumber(strArray[i]))
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ActBanquetScoreRewardReceive)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetActLevelRewardRed(self, id)
  local ret = 0
  local curLevel = self.banquetLevel
  local boxDataList = self:GetActScoreList()
  if boxDataList then
    for i = 1, #boxDataList do
      local boxData = boxDataList[i]
      if curLevel >= boxData.targetLevel then
        if boxData.state ~= 1 then
          ret = ret + 1
        end
      else
        break
      end
    end
  end
  return ret
end

local function GetActCost1Red(self, id)
  local ret = 0
  if self.actBanquetTemplate then
    local costData = self.actBanquetTemplate.cost_item
    local onceNeedNum = self.actBanquetTemplate.unit_num
    local curNum = 0
    local maxCanBulletNum = 0
    if costData[1] == BanquetAttackMonsterCostType.Resource then
      curNum = LuaEntry.Resource:GetCntByResType(costData[2])
      maxCanBulletNum = math.floor(curNum / onceNeedNum)
    else
      curNum = DataCenter.ItemData:GetItemCount(costData[2])
      maxCanBulletNum = math.floor(curNum / onceNeedNum)
    end
    if 0 < maxCanBulletNum then
      ret = 1
    end
  end
  return ret
end

local function GetActCost2Red(self, id)
  local ret = 0
  if self.actBanquetTemplate then
    if self.actBanquetTemplate.support_isopen == 0 then
      return ret
    end
    local costData = self.actBanquetTemplate.cost_item2
    local onceNeedNum = self.actBanquetTemplate.unit_num2
    local curNum = 0
    local maxCanBulletNum = 0
    if costData[1] == BanquetAttackMonsterCostType.Resource then
      curNum = LuaEntry.Resource:GetCntByResType(costData[2])
      maxCanBulletNum = math.floor(curNum / onceNeedNum)
    else
      curNum = DataCenter.ItemData:GetItemCount(costData[2])
      maxCanBulletNum = math.floor(curNum / onceNeedNum)
    end
    if 0 < maxCanBulletNum then
      ret = 1
    end
  end
  return ret
end

local function GetActTaskRed(self, id)
  local ret = 0
  local taskShowData = self.taskArrData
  if taskShowData then
    local taskGetNum = 0
    for k, v in ipairs(taskShowData) do
      if v.data.state ~= TaskState.Received then
        if v.data.state == TaskState.CanReceive then
          taskGetNum = taskGetNum + 1
        end
        break
      end
    end
    ret = taskGetNum
  end
  return ret
end

local function JumpActRedNum(self, id)
  local ret = 0
  local actBanquetTemplate = DataCenter.ActBanquetV2Data.actBanquetTemplate
  if actBanquetTemplate and actBanquetTemplate.is_show_convert == 0 then
    return ret
  end
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityInfo then
    local jumpTo = activityInfo:GetFirstActiveJumpTo()
    local changeNum = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(EnumActivity.CitySkinExchange.Type, jumpTo)
    ret = changeNum
  end
  return ret
end

local function GetRewardBoxRedNum(self, id)
  local ret = 0
  if self.extraReward and 0 < #self.extraReward then
    ret = 1
  end
  return ret
end

local function GetActRed(self, id)
  local ret = 0
  local rewardNum = 0
  local levelRewardRed = self:GetActLevelRewardRed()
  rewardNum = rewardNum + levelRewardRed
  local cost1Red = self:GetActCost1Red()
  ret = ret + cost1Red
  local cost2Red = self:GetActCost2Red()
  ret = ret + cost2Red
  local taskRed = self:GetActTaskRed()
  rewardNum = rewardNum + taskRed
  local jumpNum = self:JumpActRedNum()
  ret = ret + jumpNum
  local rewardBoxNum = self:GetRewardBoxRedNum()
  rewardNum = rewardNum + rewardBoxNum
  return ret + rewardNum, rewardNum, ret
end

local function GetRewardArr(self, type)
  if type == BanquetRankType.Personal then
    return self.personRankReward
  elseif type == BanquetRankType.Ally then
    return self.allyRankReward
  end
end

local function GetRankArr(self, type)
  if type == BanquetRankType.Personal then
    return self.personRankList
  elseif type == BanquetRankType.Ally then
    return self.allyRankList
  end
end

local function IsRankRewardDataReach(self)
  return self.selfRankReward ~= -1
end

local function IsAllianceRankRewardDataReach(self)
  return self.selfAllyRankReward ~= -1
end

local function IsRankDataReach(self)
  return not table.IsNullOrEmpty(self.selfRank)
end

local function GetCanGetScoreBoxCount(self)
  local ret = 0
  for k, v in ipairs(self.levelReward) do
    if k <= self.banquetLevel and not table.hasvalue(self.receiveReward, k) then
      ret = ret + 1
    end
  end
  return ret
end

local function GetOneTaskReward(self, message)
  for k, v in ipairs(self.taskArrData) do
    if v.data.taskId == message.taskId then
      v.data.state = TaskState.Received
      break
    end
  end
end

local function UpdateActTasks(self, message)
  local updateTaskList = message.a_task
  if updateTaskList and 0 < #updateTaskList then
    for k, v in pairs(updateTaskList) do
      local taskId = v.id
      for taskIndex, taskData in ipairs(self.taskArrData) do
        if taskData.data.taskId == taskId then
          taskData.data.num = v.num
          taskData.data.state = v.state
          break
        end
      end
    end
  end
end

local function OnGetDamageDataMsg(self, message)
  if message.score then
    self.score = message.score
  end
  if message.level then
    self.banquetLevel = message.level
  end
  if message.index then
    self.index = message.index
  end
  if message.monsterGroupId then
    self.monsterGroupId = message.monsterGroupId
  end
  if message.nextResetTime then
    self.nextResetTime = message.nextResetTime
  end
  if message.remainAttackNum then
    self.remainAttackNum = message.remainAttackNum
  end
  if message.state then
    self.state = message.state
  end
  if message.blood then
    self.blood = message.blood
  end
  if message.extraReward then
    self.extraReward = message.extraReward
  end
end

local function GetMonsterFinRewardHandle(self, message)
  if message.index then
    self.index = message.index
  end
  if message.newMonsterId then
    self.monsterGroupId = message.newMonsterId
  end
  if message.state then
    self.state = message.state
  end
  if message.blood then
    self.blood = message.blood
  end
  if message.extraReward then
    self.extraReward = message.extraReward
  end
  if message.rewardLog then
    self.battleLogList = self.battleLogList or {}
    table.insert(self.battleLogList, 1, message.rewardLog)
  end
end

local function GetIsTriggerPress(self)
  return self.isTriggerPress
end

local function SetIsTriggerPress(self)
  self.isTriggerPress = true
end

function ActBanquetV2Data:GetIsOnAutoAttack(actId)
  local actStr = string.format("%s_%s", SettingKeys.BANQUET_COMMON1_AUTO_ATTACK_FLAG, actId)
  return CS.GameEntry.Setting:GetPrivateBool(actStr, false)
end

function ActBanquetV2Data:SetIsOnAutoAttack(actId, state)
  local actStr = string.format("%s_%s", SettingKeys.BANQUET_COMMON1_AUTO_ATTACK_FLAG, actId)
  CS.GameEntry.Setting:SetPrivateBool(actStr, state)
end

function ActBanquetV2Data:GetItemDropProbCfgByDropShowId(dropShowId)
  if self.itemDropProbCfgDic ~= nil and table.count(self.itemDropProbCfgDic) > 0 then
    return self.itemDropProbCfgDic
  end
  if dropShowId == nil or dropShowId == 0 then
    Logger.LogError("GetActivityItemDropProbCfgByActBanquetId \229\186\148\228\188\160\229\133\165\230\173\163\231\161\174\231\154\132 activity_partyenw id")
    return
  end
  self.itemDropProbCfgDic = {}
  LocalController:instance():visitTable(TableName.Activity_PartyNew_DropShow, function(id, lineData)
    if lineData ~= nil then
      local group_id = lineData:getIntValue("group_id")
      if group_id == dropShowId then
        local activityDropInfoTemplate = ActivityPartynewDropshowTemplate.New()
        activityDropInfoTemplate:UpdateData(lineData)
        if lineData.id ~= nil then
          self.itemDropProbCfgDic[lineData.id] = activityDropInfoTemplate
        end
      end
    end
  end)
  return self.itemDropProbCfgDic
end

function ActBanquetV2Data:ClearData()
  self.itemDropProbCfgDic = nil
end

function ActBanquetV2Data:PareseHistoryInfo(msg)
  if msg.curReward then
    self.extraReward = msg.curReward
  end
  if msg.historyReward then
    self.historyRewardList = msg.historyReward
  end
  if msg.rewardLogArr then
    self.battleLogList = msg.rewardLogArr
  end
  if msg.costItems then
    self.costItems = msg.costItems
  end
end

function ActBanquetV2Data:GetHistoryRewardList()
  return self.historyRewardList
end

function ActBanquetV2Data:GetBattleLogList()
  return self.battleLogList
end

function ActBanquetV2Data:GetExtraReward()
  return self.extraReward
end

function ActBanquetV2Data:ClearExtraReward()
  self.extraReward = {}
end

function ActBanquetV2Data:GetTemplate()
  return self.actBanquetTemplate
end

function ActBanquetV2Data:GetCostItems()
  return self.costItems
end

function ActBanquetV2Data:GetDropType()
  if self.actBanquetTemplate then
    return self.actBanquetTemplate.dropBoxType
  end
  return 0
end

ActBanquetV2Data.__init = __init
ActBanquetV2Data.__delete = __delete
ActBanquetV2Data.ParseInfo = ParseInfo
ActBanquetV2Data.ParseTaskDataInfo = ParseTaskDataInfo
ActBanquetV2Data.GetActScore = GetActScore
ActBanquetV2Data.GetActNextTargetScore = GetActNextTargetScore
ActBanquetV2Data.GetActScoreList = GetActScoreList
ActBanquetV2Data.CanGotoPackShop = CanGotoPackShop
ActBanquetV2Data.CanGetFreePack = CanGetFreePack
ActBanquetV2Data.GetGiftPackId = GetGiftPackId
ActBanquetV2Data.GetFreeRewardHandle = GetFreeRewardHandle
ActBanquetV2Data.ParseRankingData = ParseRankingData
ActBanquetV2Data.SetActivityId = SetActivityId
ActBanquetV2Data.GetActLevelRewardRed = GetActLevelRewardRed
ActBanquetV2Data.GetActCost1Red = GetActCost1Red
ActBanquetV2Data.GetActCost2Red = GetActCost2Red
ActBanquetV2Data.GetActTaskRed = GetActTaskRed
ActBanquetV2Data.JumpActRedNum = JumpActRedNum
ActBanquetV2Data.GetRewardBoxRedNum = GetRewardBoxRedNum
ActBanquetV2Data.GetActRed = GetActRed
ActBanquetV2Data.GetBanquetMaxLevel = GetBanquetMaxLevel
ActBanquetV2Data.GetCurBanquetLevel = GetCurBanquetLevel
ActBanquetV2Data.GetDonateHandle = GetDonateHandle
ActBanquetV2Data.GetRankRewardHandle = GetRankRewardHandle
ActBanquetV2Data.GetLevelRewardHandle = GetLevelRewardHandle
ActBanquetV2Data.GetRewardArr = GetRewardArr
ActBanquetV2Data.GetRankArr = GetRankArr
ActBanquetV2Data.IsRankRewardDataReach = IsRankRewardDataReach
ActBanquetV2Data.IsAllianceRankRewardDataReach = IsAllianceRankRewardDataReach
ActBanquetV2Data.IsRankDataReach = IsRankDataReach
ActBanquetV2Data.GetBanquetAddScore = GetBanquetAddScore
ActBanquetV2Data.GetBanquetAddGoodId = GetBanquetAddGoodId
ActBanquetV2Data.GetBanquetAddGoodNum = GetBanquetAddGoodNum
ActBanquetV2Data.GetBanquetDonateItemId = GetBanquetDonateItemId
ActBanquetV2Data.GetCanGetScoreBoxCount = GetCanGetScoreBoxCount
ActBanquetV2Data.GetOneTaskReward = GetOneTaskReward
ActBanquetV2Data.UpdateActTasks = UpdateActTasks
ActBanquetV2Data.OnGetDamageDataMsg = OnGetDamageDataMsg
ActBanquetV2Data.GetMonsterFinRewardHandle = GetMonsterFinRewardHandle
ActBanquetV2Data.GetIsTriggerPress = GetIsTriggerPress
ActBanquetV2Data.SetIsTriggerPress = SetIsTriggerPress
return ActBanquetV2Data
