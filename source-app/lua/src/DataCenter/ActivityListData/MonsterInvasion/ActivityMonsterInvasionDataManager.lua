local ActivityMonsterInvasionDataManager = BaseClass("ActivityMonsterInvasionDataManager")
local MonsterInvasionData = require("DataCenter.ActivityListData.MonsterInvasion.MonsterInvasionData")
local CS = _ENV.CS
local Localization = CS.GameEntry.Localization
local SceneManager = CS.SceneManager
local UIManager = _ENV.UIManager
local UIWindowNames = _ENV.UIWindowNames
local EventManager = _ENV.EventManager
local EventId = _ENV.EventId
local SFSNetwork = _ENV.SFSNetwork
local MsgDefines = _ENV.MsgDefines
local GoToUtil = _ENV.GoToUtil
local InvasionAisillaActStatus = _ENV.InvasionAisillaActStatus
local DataCenter = _ENV.DataCenter

function ActivityMonsterInvasionDataManager:__init()
  self.actShopData = {}
  self.exchangeTemplates = {}
  self.recordData = {}
  self.rankList = {}
  self.rewards = {}
  self.invasionId = 0
  self.monsterInvasionData = nil
  self.activityId = nil
  self.actData = nil
  self.progress = 0
  self.summon_score = 0
  self.cacheUIProgress = nil
  self.point = 0
  self.invasionBossInfo = nil
  self.aisillaActStatus = InvasionAisillaActStatus.NONE
  self.bossTroopSpeakMarks = {}
  self.resourcePathList = {}
  self.rewardPopConfig = nil
  self.rewardInfoCanDisplayList = nil
  self:AddListeners()
end

function ActivityMonsterInvasionDataManager:__delete()
  self:RemoveListeners()
  DataCenter.InvasionAisillaCtrlManager:Delete()
  self.actShopData = nil
  self.exchangeTemplates = nil
  self.recordData = nil
  self.rankList = nil
  self.rewards = nil
  self.invasionId = nil
  if self.monsterInvasionData then
    self.monsterInvasionData:Delete()
  end
  self.monsterInvasionData = nil
  self.activityId = nil
  self.actData = nil
  self.progress = nil
  self.summon_score = nil
  self.cacheUIProgress = nil
  self.point = nil
  self.invasionBossInfo = nil
  self.aisillaActStatus = nil
  self.bossTroopSpeakMarks = nil
  self.resourcePathList = nil
  self.rewardPopConfig = nil
  self.rewardInfoCanDisplayList = nil
end

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.OnMonsterInvasionBossProgressChanged, self.OnInvasionBossProgressChanged)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.ExitWorld)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.EnterWorld)
end

local function RemoveListeners(self)
  EventManager:GetInstance():RemoveListener(EventId.OnMonsterInvasionBossProgressChanged, self.OnInvasionBossProgressChanged)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.ExitWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.EnterWorld)
end

function ActivityMonsterInvasionDataManager:SetActivityId(activityId)
  self.activityId = activityId
end

function ActivityMonsterInvasionDataManager:UpdateActData(message)
  if message == nil then
    return
  end
  local activityId = message.id
  if self.monsterInvasionData == nil then
    self.monsterInvasionData = MonsterInvasionData.New()
  end
  self.monsterInvasionData:ParseData(message)
  self.aisillaActStatus = InvasionAisillaActStatus.NONE
  if not self.isPlanTimeFuncOpen then
    self.isPlanTimeFuncOpen = LuaEntry.DataConfig:CheckSwitch("appointment_monster_invasion")
  end
  local invasionId = message.invasionId
  if activityId then
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
    if actData and actData.type == EnumActivity.MonsterInvasion.Type then
      self.invasionId = invasionId
      if invasionId and 0 < invasionId then
        DataCenter.ActivityMonsterInvasionDataManager.ParseActNewData(self, invasionId, actData)
        self.actData = actData
        self.progress = message.progress or 0
        self.planTime = message.planTime
        self.lastPlanTime = message.lastPlanTime
        local summon_score = actData.summonBossScore
        if summon_score then
          self.summon_score = summon_score
        end
        DataCenter.ActivityMonsterInvasionDataManager.CheckIsInInvasionChallenge(self, message.aliMonsters)
        if self.progress == 0 then
          DataCenter.ActivityMonsterInvasionDataManager:ResetCacheUIProgress()
        end
        self.aisillaActStatus = message.bossStatus
      end
    end
  end
end

function ActivityMonsterInvasionDataManager:GetActData()
  return self.monsterInvasionData
end

function ActivityMonsterInvasionDataManager:UpdateActShopData(message)
  if message == nil then
    return
  end
  local activityId = message.activityId
  self.actShopData[activityId] = {}
  local buyRecordListData = {}
  local msgData = message.buyRecords
  if msgData ~= nil and 0 < #msgData then
    for k, v in pairs(msgData) do
      local data = {
        id = v.id,
        count = v.count
      }
      buyRecordListData[data.id] = data
    end
  end
  self.actShopData[activityId] = buyRecordListData
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActivityMonsterInvasionDataManager:UpdateActShopDataByBuy(message)
  if message == nil then
    return
  end
  local activityId = message.activityId
  if self.actShopData[activityId] == nil then
    self.actShopData[activityId] = {}
  end
  local id = message.id
  local data = {
    id = message.id,
    count = message.count
  }
  self.actShopData[activityId][id] = data
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActivityMonsterInvasionDataManager:GetActShopData(activityId)
  local shopData = {}
  if self.actShopData[activityId] then
    shopData = self.actShopData[activityId]
  end
  return shopData
end

function ActivityMonsterInvasionDataManager:GetActShopDataById(activityId, id)
  local data
  if self.actShopData[activityId] then
    data = self.actShopData[activityId][id]
  end
  return data
end

function ActivityMonsterInvasionDataManager:GetExchangeTempalte(id)
  if self.exchangeTemplates[id] then
    return self.exchangeTemplates[id]
  end
  local line = LocalController:instance():getLine(TableName.MONSTER_SHOP, id)
  local template
  if line then
    template = {}
    template.id = line.id
    template.shop_id = line.shop_id
    template.currency_id = line.currency_id
    template.cost = line.cost
    template.commodity = line.commodity
    template.commodity_num = line.commodity_num
    template.cycle_times = line.cycle_times
    template.order = line.order
  end
  self.exchangeTemplates[id] = template
  return template
end

function ActivityMonsterInvasionDataManager:UpdateRecordData(message)
  if message == nil then
    return
  end
  local activityId = message.activityId
  self.recordData[activityId] = message.records
end

function ActivityMonsterInvasionDataManager:GetRecordData(activityId)
  local data = self.recordData[activityId]
  return data
end

function ActivityMonsterInvasionDataManager:ParseRankingData(message)
  if not message then
    return
  end
  local actId = message.activityId
  local rankingInfo = self.rankList[actId]
  if rankingInfo == nil then
    rankingInfo = {}
  end
  local playerRankingInfoMsg = message.owner
  if playerRankingInfoMsg then
    local selfPlayerData = BasePlayerInfo.New()
    selfPlayerData:ParseData(playerRankingInfoMsg)
    selfPlayerData.score = playerRankingInfoMsg.score
    selfPlayerData.ranking = playerRankingInfoMsg.rank
    rankingInfo.selfRankData = selfPlayerData
  end
  rankingInfo.rankList = {}
  local rankingList = message.list
  if rankingList then
    for _, v in pairs(rankingList) do
      local playerData = BasePlayerInfo.New()
      playerData:ParseData(v)
      playerData.score = v.score
      playerData.ranking = v.rank
      table.insert(rankingInfo.rankList, playerData)
    end
  end
  self.rankList[actId] = rankingInfo
  EventManager:GetInstance():Broadcast(EventId.MonsterInvasionGetRank)
end

function ActivityMonsterInvasionDataManager:GetRankDataByActId(actId)
  return self.rankList[actId]
end

function ActivityMonsterInvasionDataManager:UpdateRankRewardData(message)
  if not message then
    return
  end
  local actId = message.activityId
  if self.rewards[actId] == nil then
    self.rewards[actId] = {}
  end
  local rewardData = message.rewardList
  local rewardsInfo = {}
  if not table.IsNullOrEmpty(rewardData) then
    for _, v in pairs(rewardData) do
      local rewardInfo = {}
      rewardInfo.minRanking = v.minLv
      rewardInfo.maxRanking = v.maxLv
      rewardInfo.rewards = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
      table.insert(rewardsInfo, rewardInfo)
    end
  end
  self.rewards[actId] = rewardsInfo
end

function ActivityMonsterInvasionDataManager:GetRewardsDataByActId(actId)
  local dataList = {}
  if self.rewards[actId] then
    dataList = self.rewards[actId]
  end
  return dataList
end

function ActivityMonsterInvasionDataManager:GetActRedNum()
  local activityId = tonumber(self.activityId)
  if not activityId or not self.actShopData[activityId] then
    return 0
  end
  if not self:IsShopRedOn() then
    return 0
  end
  local shopData = self.actShopData[activityId]
  for id, data in pairs(shopData) do
    local template = self:GetExchangeTempalte(id)
    if template then
      local maxCount = template.cycle_times or 0
      local currentCount = data.count or 0
      if maxCount > currentCount then
        local currencyId = template.currency_id
        local costCount = template.cost or 0
        if currencyId and 0 < costCount then
          local haveCount = DataCenter.ItemData:GetItemCount(currencyId)
          if costCount <= haveCount then
            return 1
          end
        end
      end
    end
  end
  return 0
end

local function GetMonsterDialogContent(self, type)
  local content = ""
  if self.actData == nil then
    return content
  end
  local arr
  if type == 1 then
    arr = self.actData.smallOs
  elseif type == 2 then
    arr = self.actData.mediumBirthOs
  elseif type == 3 then
    arr = self.actData.mediumDieOs
  end
  if arr then
    local r = math.random(1, #arr)
    local id = arr[r]
    content = Localization:GetString(id)
  end
  return content
end

local function ParseActNewData(self, invasionId, actData)
  if invasionId == nil or invasionId < 1 or actData == nil then
    return
  end
  local row = LocalController:instance():getLine(TableName.AdvancedMonsterInvasion, invasionId)
  if row == nil then
    return
  end
  if row.id ~= nil then
    actData.actInvasionId = row.id
  end
  if row.small_os then
    local smallOsStr = row.small_os
    if smallOsStr then
      local arr = string.split(smallOsStr, "|")
      if arr and 0 < #arr then
        actData.smallOs = arr
      end
    end
  end
  if row.medium_birth_os ~= nil then
    local mediumBirthOsStr = row.medium_birth_os
    if mediumBirthOsStr then
      local arr = string.split(mediumBirthOsStr, "|")
      if arr and 0 < #arr then
        actData.mediumBirthOs = arr
      end
    end
  end
  if row.medium_die_os ~= nil then
    local mediumDieOsStr = row.medium_die_os
    if mediumDieOsStr then
      local arr = string.split(mediumDieOsStr, "|")
      if arr and 0 < #arr then
        actData.mediumDieOs = arr
      end
    end
  end
  if row.summon_boss_score ~= nil then
    actData.summonBossScore = row.summon_boss_score
  end
  if row.summon_boss_id ~= nil then
    actData.summonBossId = row.summon_boss_id
  end
  if row.light_num ~= nil then
    actData.lightNum = row.light_num
  end
  if row.prep_time ~= nil then
    actData.prepTime = row.prep_time
  end
  if row.birth_time ~= nil then
    actData.birthTime = row.birth_time
  end
  if row.challenge_time ~= nil then
    actData.challengeTime = row.challenge_time
  end
  if row.icon ~= nil then
    actData.list_icon = row.icon
  end
  if row.banner ~= nil then
    actData.activity_pic = row.banner
  end
  if row.bannerTittle ~= nil then
    actData.bannerTittle = row.bannerTittle
  end
  if row.bannerDes ~= nil then
    actData.desc_info = row.bannerDes
  end
  if row.desc ~= nil then
    actData.story = row.desc
  end
  if row.count_down_hour ~= nil then
    actData.countDownHour = row.count_down_hour
  end
  if row.boss_reduce_hp ~= nil then
    actData.bossReduceHp = row.boss_reduce_hp
  end
  if row.progress_icon ~= nil then
    local iconStr = row.progress_icon
    if iconStr then
      local arr = string.split(iconStr, "|")
      if arr and 0 < #arr then
        actData.iconArr = arr
      end
    end
  end
  if row.chat_icon ~= nil then
    actData.chatIcon = row.chat_icon
  end
  if row.attack_max_num ~= nil then
    actData.attackMaxNum = row.attack_max_num
  end
  if row.challenge_icon ~= nil then
    actData.challengeIcon = row.challenge_icon
  end
end

local function OnInvasionBossProgressChanged(progress)
  local self = DataCenter.ActivityMonsterInvasionDataManager
  if progress and self.progress ~= progress then
    if progress > self.progress then
      local param = {
        curProgress = self.progress,
        targetProgress = progress
      }
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIInvasionSummonProgress) then
        EventManager:GetInstance():Broadcast(EventId.RefreshInvasionProgressPanel, param)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIInvasionSummonProgress, {anim = false}, param)
      end
    end
    self.progress = progress
    if self.progress <= 0 then
      DataCenter.ActivityMonsterInvasionDataManager:ResetCacheUIProgress()
    end
  end
end

local function OnAisillaMarchCreated(marchUuid)
  if marchUuid and SceneManager.World then
    local marchInfo = SceneManager.World:GetMarch(marchUuid)
    if marchInfo and marchInfo.invasionBossInfo then
      local invasionBossInfo = marchInfo.invasionBossInfo
      DataCenter.ActivityMonsterInvasionDataManager.invasionBossInfo = invasionBossInfo
      if invasionBossInfo then
        SFSNetwork.SendMessage(MsgDefines.MonsterInvasionActInfo, self.activityId)
      end
      DataCenter.InvasionAisillaCtrlManager:CreateAisillaCtrl(marchInfo, transform)
    end
  end
end

local function EnterWorld(self)
  DataCenter.InvasionAisillaCtrlManager:EnterWorld()
end

local function ExitWorld(self)
  DataCenter.InvasionAisillaCtrlManager:ExitWorld()
end

local function ReqMonsterInvasionActInfoMsg(self, activityId, needTotal)
  if string.IsNullOrEmpty(activityId) then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.MonsterInvasionActInfo, activityId, needTotal)
end

local function PlayPlotBubble3D(self, type, marchInfo, transform, duration)
  if self.invasionId <= 0 then
    return
  end
  if type and transform and duration then
    if marchInfo then
      local bubbleParams = {}
      local content = DataCenter.ActivityMonsterInvasionDataManager.GetMonsterDialogContent(self, type)
      bubbleParams.fakePlotMeta = {duration = duration, contentString = content}
      bubbleParams.followTarget = transform
      local targetPos = transform.position
      local pic = marchInfo.pic
      if string.IsNullOrEmpty(pic) then
        local monsterId = marchInfo.monsterId
        if 0 < monsterId then
          local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
          if monster ~= nil then
            pic = monster.pic
          end
        end
      end
      pic = "Assets/Main/Sprites/HeroIconsSmall/" .. pic .. ".png"
      local playerInfo = {
        uid = marchInfo.ownerUid,
        pic = pic,
        picVer = marchInfo.picVer
      }
      bubbleParams.anchor = Vector3.New(targetPos.x, targetPos.y + 3.7, targetPos.z)
      bubbleParams.mode = "3D"
      bubbleParams.playerInfo = playerInfo
      bubbleParams.headType = 1
      EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
    else
      Logger.LogWarning("cannot get marchInfo")
    end
  end
end

local function GetInvasionSummonProgress(self)
  return self.progress, self.summon_score
end

local function GetCacheUIProgress(self)
  if self.cacheUIProgress == nil then
    self.cacheUIProgress = self.progress
  end
  return self.cacheUIProgress
end

local function UpdateCacheUIProgress(self)
  self.cacheUIProgress = self.progress
  if self.monsterInvasionData then
    return self.monsterInvasionData:SetCachedMonsters()
  end
end

local function ResetCacheUIProgress(self)
  self.cacheUIProgress = nil
  if self.monsterInvasionData then
    return self.monsterInvasionData:ResetCachedMonsters()
  end
end

local function GetInvasionActivityId(self)
  return self.activityId
end

local function GetActivityData(self)
  return self.actData
end

local function RequestGetMonsterInvasionPoint(self)
  SFSNetwork.SendMessage(MsgDefines.MonsterInvasionBossFind)
end

local function CreateMovingModel(self, point)
  if self.actData then
    local monsterId = self.actData.summonBossId
    if monsterId then
      local row = LocalController:instance():tryGetLine(TableName.Monster, monsterId)
      if row then
        local modelPath = row.model_name
        local size = row.size
        UIUtil.UICreateWorldMovingModel(modelPath, FakeMovingModelFlag.Aisilla, point, size)
      end
    end
  end
end

local function JumpToBossPoint(self, point, callback)
  if point and 0 < point then
    local pos = SceneUtils.TileIndexToWorld(point, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(pos, nil, nil, callback, LuaEntry.Player:GetSourceServerId())
  end
end

local function OnInvasionBossPointGot(self, point, justJump)
  self.point = point
  DataCenter.ActivityMonsterInvasionDataManager.GotoInvasionAisillaPoint(self, justJump)
end

local function GotoInvasionAisillaPoint(self, justJump)
  local point = self.point
  if point == nil or point == 0 then
    self.point = self.invasionBossInfo and self.invasionBossInfo.pointId or 0
  end
  point = self.point
  if point and 0 < point then
    local pos = SceneUtils.TileIndexToWorld(point, ForceChangeScene.World)
    local callback
    if not justJump then
      function callback()
        DataCenter.ActivityMonsterInvasionDataManager.PutBigBossModel(self, point)
      end
    end
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(pos, nil, nil, callback)
  end
end

local function PutBigBossModel(self, point)
  GoToUtil.CloseAllWindows()
  DataCenter.ActivityMonsterInvasionDataManager:CreateMovingModel(point)
end

local function SetAisillaChallengeInfo(self, message)
  if message then
    local invasionBossInfo = message.invasionBossInfo
    if invasionBossInfo then
      self.point = invasionBossInfo.pointId
    end
    self.invasionBossInfo = invasionBossInfo
    self.aisillaActStatus = message.bossStatus
    if self.aisillaActStatus == InvasionAisillaActStatus.CREATE then
      EventManager:GetInstance():Broadcast(EventId.RefreshAisillaChallengeInfo, {
        status = self.aisillaActStatus,
        battleStartTime = self.invasionBossInfo.battleStartTime
      })
    else
      if self.aisillaActStatus ~= InvasionAisillaActStatus.NONE then
        EventManager:GetInstance():Broadcast(EventId.MonsterInvasionAisillaDead, {
          uuid = message.uuid,
          status = self.aisillaActStatus
        })
      end
      EventManager:GetInstance():Broadcast(EventId.RefreshAisillaChallengeInfo)
    end
  end
end

local function GetInvasionBossInfo(self)
  return self.invasionBossInfo
end

local function CheckIsInInvasionChallenge(self, aliMonsters)
  if aliMonsters then
    for _, v in pairs(aliMonsters) do
      if v and v.monsterId and self:IsMonsterAisilla(v.monsterId) then
        self.invasionBossInfo = v.invasionBossInfo
        break
      end
    end
  end
end

local function IsMonsterAisilla(self, monsterId)
  if monsterId then
    local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
    if monsterTemplate then
      return monsterTemplate.type == LWWorldMonsterType.Boss and monsterTemplate.special == WorldMonsterSpecialType.InvasionBigBoss
    end
  end
  return false
end

local function GetAisillaActStatus(self)
  return self.aisillaActStatus
end

local function OnMarkBossTroopSpeak(self, uuid)
  DataCenter.ActivityMonsterInvasionDataManager.bossTroopSpeakMarks[uuid] = true
end

local function GetBossTroopSpeak(self, uuid)
  local mgr = DataCenter.ActivityMonsterInvasionDataManager
  if mgr.bossTroopSpeakMarks[uuid] then
    mgr.bossTroopSpeakMarks[uuid] = nil
    return true
  end
  mgr.bossTroopSpeakMarks[uuid] = nil
  return false
end

local function GetAttackNumContext(self)
  if self.monsterInvasionData and self.actData then
    return Localization:GetString("attack_aisila_max_num", self.monsterInvasionData.attackNum, self.actData.attackMaxNum)
  end
end

local function UpdateAttackNum(self, message)
  if message and self.monsterInvasionData then
    self.monsterInvasionData.attackNum = message.attackNum
  end
end

local function GetMonstorRatityBgList(self, activityId)
  local bgStr = GetTableData(TableName.Activity, activityId, "para_1")
  local result = {}
  for segment in string.gmatch(bgStr, "([^;]+)") do
    local minLevel, maxLevel, resourcePath = string.match(segment, "(%d+)%-(%d+),([^;]+)")
    if minLevel and maxLevel and resourcePath then
      table.insert(result, {
        minLevel = tonumber(minLevel),
        maxLevel = tonumber(maxLevel),
        resourcePath = resourcePath
      })
    end
  end
  self.resourcePathList = result
  return result
end

local function GetRatityBgList(self)
  return self.resourcePathList
end

local function GetShowReward(self, rewardStr)
  local showRewardList = {}
  if rewardStr ~= nil then
    local regularArray = string.split(rewardStr, "|")
    if not string.IsNullOrEmpty(regularArray) then
      for i = 1, #regularArray do
        local rewardStr = regularArray[i]
        local rewardData = DataCenter.RewardManager:ParseOneRewardStr(rewardStr)
        if rewardData then
          table.insert(showRewardList, rewardData)
        end
      end
    end
  end
  return showRewardList
end

local function RequestPutAisilla(self, point, callback)
  if point and 0 < point and self.actData then
    local function confirmFunc()
      SFSNetwork.SendMessage(MsgDefines.MonsterInvasionBossCreate, point, self.planeTimeCache)
      
      if callback then
        callback()
      end
    end
    
    if self.isPlanTimeFuncOpen then
      confirmFunc()
      return
    end
    local challengeTime = self.actData.challengeTime
    if challengeTime and 0 < challengeTime then
      local context = CS.GameEntry.Localization:GetString("activity_godzilla_go_battle_tips", math.floor(challengeTime / 60))
      UIUtil.TryShowConfirm(TodayNoSecondConfirmType.MonsterInvasionSummonRemind, context, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, confirmFunc, function()
      end, nil, nil, false, nil, nil)
    end
  end
end

local function GetPlanTimeFuncOpen(self)
  return self.isPlanTimeFuncOpen
end

local function OnBossAttacked(self, message)
  if message and message.targetList then
    if not UIManager:GetInstance():CheckIfIsMainUIOpenOnly(true) then
      return
    end
    UIUtil.ShowAttackUnitsTips(AttackerBossType.Aisilla, message.targetList)
  end
end

function ActivityMonsterInvasionDataManager:SetBossPlanTime(timeStamp)
  self.planeTimeCache = timeStamp
  local tDate = UITimeManager:GetInstance():TimeStampToServerDate(timeStamp)
  self.tDate = tDate
end

function ActivityMonsterInvasionDataManager:GetBossPlanTimeFromServer()
  return self.planTime
end

function ActivityMonsterInvasionDataManager:UpdateBossPlanTime(timeStamp)
  self.planTime = timeStamp
end

function ActivityMonsterInvasionDataManager:IsOverPlanTime()
  local planTime = self.planTime
  if not planTime then
    return true
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return planTime < curTime
end

function ActivityMonsterInvasionDataManager:GetLastPlanTime()
  return self.lastPlanTime
end

function ActivityMonsterInvasionDataManager:CanChangePlanTime()
  local isCreate = self.aisillaActStatus == InvasionAisillaActStatus.CREATE
  local isNotOverPlanTime = not self:IsOverPlanTime()
  return isCreate and isNotOverPlanTime
end

function ActivityMonsterInvasionDataManager:GetRewardListData()
  if self.rewardPopConfig == nil then
    self.rewardPopConfig = {}
    for i = 13, 15 do
      local list = self:GetRewardData("k" .. i)
      if list then
        table.insert(self.rewardPopConfig, list)
      end
    end
    local list = self:GetRewardData("k24")
    if list then
      table.insert(self.rewardPopConfig, list)
    end
  end
  self.rewardInfoCanDisplayList = {}
  local seasonNum = SeasonUtil.GetSeason()
  local seasonDay = SeasonUtil.GetSeasonDay()
  for i, v in ipairs(self.rewardPopConfig) do
    if seasonNum > v.season then
      table.insert(self.rewardInfoCanDisplayList, v)
    elseif seasonNum == v.season and seasonDay >= v.days then
      table.insert(self.rewardInfoCanDisplayList, v)
    end
  end
  return self.rewardInfoCanDisplayList
end

function ActivityMonsterInvasionDataManager:GetRewardData(strK)
  local k13 = LuaEntry.DataConfig:TryGetStr("monster_invasion", strK)
  local result = {}
  local i_k13 = 1
  local season, days, iconName, minLevel, maxLevel, rewardStr, effectNum
  for segment in string.gmatch(k13, "([^,]+)") do
    if i_k13 == 1 then
      season, days = string.match(segment, "(%d+)%:(%d+)")
    elseif i_k13 == 2 then
      iconName = segment
    elseif i_k13 == 3 then
      minLevel, maxLevel = string.match(segment, "(%d+)%-(%d+)")
    elseif i_k13 == 4 then
      rewardStr = segment
    elseif i_k13 == 5 then
      effectNum = string.split(segment, ";")
    end
    i_k13 = i_k13 + 1
  end
  result.season = tonumber(season)
  result.days = tonumber(days)
  result.iconName = iconName
  result.minLevel = tonumber(minLevel)
  result.maxLevel = tonumber(maxLevel)
  result.rewardStr = rewardStr
  result.dayseffectNum = effectNum
  return result
end

function ActivityMonsterInvasionDataManager:IsShopRedOn()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if not activityInfo then
    return
  end
  return Setting:GetPrivateBool("MonsterInvasionShopShowRed_" .. tostring(activityInfo:GetShowStartTime()), true)
end

function ActivityMonsterInvasionDataManager:SetShopRedOn(value)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if not activityInfo then
    return
  end
  Setting:SetPrivateBool("MonsterInvasionShopShowRed_" .. tostring(activityInfo:GetShowStartTime()), value)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

ActivityMonsterInvasionDataManager.ReqMonsterInvasionActInfoMsg = ReqMonsterInvasionActInfoMsg
ActivityMonsterInvasionDataManager.GetMonsterDialogContent = GetMonsterDialogContent
ActivityMonsterInvasionDataManager.PlayPlotBubble3D = PlayPlotBubble3D
ActivityMonsterInvasionDataManager.ParseActNewData = ParseActNewData
ActivityMonsterInvasionDataManager.OnInvasionBossProgressChanged = OnInvasionBossProgressChanged
ActivityMonsterInvasionDataManager.AddListeners = AddListeners
ActivityMonsterInvasionDataManager.RemoveListeners = RemoveListeners
ActivityMonsterInvasionDataManager.GetInvasionSummonProgress = GetInvasionSummonProgress
ActivityMonsterInvasionDataManager.GetCacheUIProgress = GetCacheUIProgress
ActivityMonsterInvasionDataManager.UpdateCacheUIProgress = UpdateCacheUIProgress
ActivityMonsterInvasionDataManager.ResetCacheUIProgress = ResetCacheUIProgress
ActivityMonsterInvasionDataManager.GetInvasionActivityId = GetInvasionActivityId
ActivityMonsterInvasionDataManager.GetActivityData = GetActivityData
ActivityMonsterInvasionDataManager.RequestGetMonsterInvasionPoint = RequestGetMonsterInvasionPoint
ActivityMonsterInvasionDataManager.CreateMovingModel = CreateMovingModel
ActivityMonsterInvasionDataManager.JumpToBossPoint = JumpToBossPoint
ActivityMonsterInvasionDataManager.OnInvasionBossPointGot = OnInvasionBossPointGot
ActivityMonsterInvasionDataManager.SetAisillaChallengeInfo = SetAisillaChallengeInfo
ActivityMonsterInvasionDataManager.GotoInvasionAisillaPoint = GotoInvasionAisillaPoint
ActivityMonsterInvasionDataManager.PutBigBossModel = PutBigBossModel
ActivityMonsterInvasionDataManager.CheckIsInInvasionChallenge = CheckIsInInvasionChallenge
ActivityMonsterInvasionDataManager.IsMonsterAisilla = IsMonsterAisilla
ActivityMonsterInvasionDataManager.OnAisillaMarchCreated = OnAisillaMarchCreated
ActivityMonsterInvasionDataManager.GetInvasionBossInfo = GetInvasionBossInfo
ActivityMonsterInvasionDataManager.GetAisillaActStatus = GetAisillaActStatus
ActivityMonsterInvasionDataManager.OnMarkBossTroopSpeak = OnMarkBossTroopSpeak
ActivityMonsterInvasionDataManager.GetBossTroopSpeak = GetBossTroopSpeak
ActivityMonsterInvasionDataManager.GetAttackNumContext = GetAttackNumContext
ActivityMonsterInvasionDataManager.UpdateAttackNum = UpdateAttackNum
ActivityMonsterInvasionDataManager.GetMonstorRatityBgList = GetMonstorRatityBgList
ActivityMonsterInvasionDataManager.GetRatityBgList = GetRatityBgList
ActivityMonsterInvasionDataManager.GetShowReward = GetShowReward
ActivityMonsterInvasionDataManager.RequestPutAisilla = RequestPutAisilla
ActivityMonsterInvasionDataManager.OnBossAttacked = OnBossAttacked
ActivityMonsterInvasionDataManager.EnterWorld = EnterWorld
ActivityMonsterInvasionDataManager.ExitWorld = ExitWorld
ActivityMonsterInvasionDataManager.GetPlanTimeFuncOpen = GetPlanTimeFuncOpen
return ActivityMonsterInvasionDataManager
