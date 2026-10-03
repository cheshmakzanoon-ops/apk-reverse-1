local ActMeteoriteBattleManager = BaseClass("ActMeteoriteBattleManager")
local MeteoriteActInfoData = require("DataCenter.MeteoriteBattle.MeteoriteActInfoData")
local MeteoriteBattleWorldInfo = require("DataCenter.MeteoriteBattle.MeteoriteBattleWorldInfo")
local ResourceManager = CS.GameEntry.Resource
local MeteoriteWorldEffectPlayer = CS.MeteoriteWorldEffectPlayer
local Localization = CS.GameEntry.Localization
local NEWS_FLAG = "_ACT_METEORITE_FIRST"

function ActMeteoriteBattleManager:__init()
  self.actInfo = nil
  self.rankAlliance = {}
  self.rankPerson = {}
  self.configStages = nil
  self.configBoxes = nil
  self.entityTabCache = {}
  self.templateGuides = nil
  self.templateServerGroup = nil
  self.stageTimes = nil
  self.rewardsListCache = nil
  self.flyMailId = nil
  self.battleWorldInfo = nil
  self.timeLastRequestBattleInfo = nil
  self.timeLastUpdateBattleInfo = nil
  self.autoMeteoriteTipsInfo = {}
  self:AddListener()
  self:RequestMeteoriteWorldInfo()
end

function ActMeteoriteBattleManager:__delete()
  self:ClearWorldMeteorite()
  self:RemoveListener()
  self.actInfo = nil
  self.rankAlliance = nil
  self.rankPerson = nil
  self.configStages = nil
  self.configBoxes = nil
  self.entityTabCache = nil
  self.templateGuides = nil
  self.templateServerGroup = nil
  self.stageTimes = nil
  self.rewardsListCache = nil
  self.flyMailId = nil
  self.battleWorldInfo = nil
  self.autoMeteoriteTipsInfo = nil
  self.timeLastRequestBattleInfo = nil
  self.timeLastUpdateBattleInfo = nil
  self.meteoriteDestroyAllFlag = nil
  self.cachedBattleState = nil
end

function ActMeteoriteBattleManager:AddListener()
  function self._OnEnterWorld()
    DataCenter.ActMeteoriteBattleManager:OnEnterWorld()
  end
  
  function self._OnEnterCity()
    self:RequestMeteoriteWorldInfo()
    DataCenter.ActMeteoriteBattleManager:ExitWorld()
  end
  
  function self._RefreshMeteoriteBattleState()
    DataCenter.ActMeteoriteBattleManager:RequestMeteoriteWorldInfo()
  end
  
  function self._EnterDragonWorld()
    self:OnBattleWorldInfoUpdate()
  end
  
  function self._OnCrossServer()
    self:OnCrossServer()
  end
  
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self._OnEnterWorld)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self._OnEnterCity)
  EventManager:GetInstance():AddListener(EventId.EnterDragonWorld, self._EnterDragonWorld)
  EventManager:GetInstance():AddListener(EventId.QuitDragonWorld, self._RefreshMeteoriteBattleState)
  EventManager:GetInstance():AddListener(EventId.MeteoriteBattlePlayerStateChanged, self.OnPlayerStateChanged)
  EventManager:GetInstance():AddListener(EventId.OnSetCrossID, self._OnCrossServer)
end

function ActMeteoriteBattleManager:RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self._OnEnterWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self._OnEnterCity)
  EventManager:GetInstance():RemoveListener(EventId.EnterDragonWorld, self._EnterDragonWorld)
  EventManager:GetInstance():RemoveListener(EventId.QuitDragonWorld, self._RefreshMeteoriteBattleState)
  EventManager:GetInstance():RemoveListener(EventId.MeteoriteBattlePlayerStateChanged, self._RefreshMeteoriteBattleState)
  EventManager:GetInstance():RemoveListener(EventId.OnSetCrossID, self._OnCrossServer)
  self._OnEnterWorld = nil
  self._OnEnterCity = nil
end

function ActMeteoriteBattleManager:GetStages()
  if self.configStages == nil then
    local str = LuaEntry.DataConfig:TryGetStr("yunshi_para", "k3")
    local myInsert = table.insert
    local mySplit = string.split
    local myInt = toInt
    local infos = mySplit(str, ";")
    local stages = {}
    for _, v in ipairs(infos) do
      local group = mySplit(v, ",")
      local stage = myInt(group[1])
      if stage ~ 1 then
        local time = mySplit(group[3], ":")
        myInsert(stages, {
          stage = stage,
          week = myInt(group[2]),
          hour = myInt(time[1]),
          min = myInt(time[2])
        })
      end
    end
    table.sort(stages, function(a, b)
      if a.week ~= b.week then
        return a.week < b.week
      end
      return a.hour < b.hour
    end)
    self.configStages = stages
  end
  return self.configStages
end

function ActMeteoriteBattleManager:GetRewardBoxes(type, season)
  if self.configBoxes == nil then
    local curSeason = season == nil and DataCenter.SeasonDataManager:GetSeason() or season
    if curSeason == -1 then
      curSeason = 1
    end
    local myInsert = table.insert
    local boxes = {}
    LocalController:instance():visitTable(TableName.MeteoriteBattleReward, function(id, lineData)
      local sNum = lineData:getIntValue("season")
      if sNum ~= curSeason then
        return
      end
      local _type = lineData:getIntValue("type")
      local boxesType = boxes[_type]
      if boxesType == nil then
        boxesType = {}
        boxes[_type] = boxesType
      end
      myInsert(boxesType, {
        id = lineData:getIntValue("id"),
        para = lineData:getValue("para"),
        reward = lineData:getIntValue("reward"),
        value = lineData:getIntValue("value"),
        icon = lineData:getIntValue("icon"),
        season = sNum
      })
    end)
    if season ~= -1 and table.IsNullOrEmpty(boxes) then
      return self:GetRewardBoxes(type, -1)
    end
    self.configBoxes = boxes
  end
  return self.configBoxes[type] or {}
end

function ActMeteoriteBattleManager:ShowRewardTips(target, config, index, isLeft, offset)
  local x = target.transform.position.x
  local y = target.transform.position.y
  local width = target.rectTransform.rect.width
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRewardTip, Localization:GetString("370101", config.value), EnumActivity.ActMeteorite.Type, x, y, isLeft, index, width, offset)
end

function ActMeteoriteBattleManager:GetTemplateGuideByPage(page)
  if self.templateGuides then
    return self.templateGuides[page]
  end
  local guides = {}
  local myInsert = table.insert
  LocalController:instance():visitTable(TableName.MeteoriteBattleGuide, function(_, lineData)
    local tPage = lineData:getIntValue("page")
    local data = {
      id = lineData:getIntValue("id"),
      type = lineData:getIntValue("type"),
      page = lineData:getIntValue("page"),
      order = lineData:getIntValue("order"),
      pic = lineData:getValue("pic"),
      desc = lineData:getValue("desc"),
      tittle = lineData:getValue("tittle")
    }
    local group = guides[tPage]
    if not group then
      group = {}
      guides[tPage] = group
    end
    myInsert(group, data)
  end)
  
  local function _sortGuides(a, b)
    if a.order ~= b.order then
      return a.order < b.order
    end
    return false
  end
  
  for _, tb in pairs(guides) do
    table.sort(tb, _sortGuides)
  end
  self.templateGuides = guides
  return guides[page]
end

function ActMeteoriteBattleManager:InitTemplateServerGroupOpenTime()
  local serverGroup = {}
  local myInsert = table.insert
  local mySplit = string.split
  local tbName = "yuntie_battle_server_group_new"
  local KEY_PATTERN = "(%d+)/(%d+)/(%d+)"
  LocalController:instance():visitTable(tbName, function(id, lineData)
    local season = lineData:getIntValue("season")
    local open_time = lineData:getValue("open_time")
    local close_time = lineData:getValue("close_time")
    local extInfo = string.format("%s-%s", tbName, id)
    local sTime, eTime = 0, 0
    if not string.IsNullOrEmpty(open_time) then
      sTime = RaceEntranceUtil.TransformTime(open_time, KEY_PATTERN, extInfo)
    end
    if not string.IsNullOrEmpty(close_time) then
      eTime = RaceEntranceUtil.TransformTime(close_time, KEY_PATTERN, extInfo)
    end
    local groups = mySplit(lineData:getValue("group_list"), ";")
    for _, sgV in ipairs(groups) do
      local sg = mySplit(sgV, "|")
      for _, v in ipairs(sg) do
        local ss = mySplit(v, "-")
        local s1 = toInt(ss[1])
        local s2 = toInt(ss[2])
        if s2 ~= nil and s1 ~= nil then
          myInsert(serverGroup, {
            id = id,
            season = season,
            sTime = sTime,
            eTime = eTime,
            s1 = s1,
            s2 = s2
          })
        elseif s1 ~= nil then
          myInsert(serverGroup, {
            id = id,
            season = season,
            sTime = sTime,
            eTime = eTime,
            s1 = s1,
            s2 = s1
          })
        end
      end
    end
  end)
  self.templateServerGroup = serverGroup
end

function ActMeteoriteBattleManager:GetCurTemplateServerGroupOpenTime(curSeason, serverId)
  if self.templateServerGroup == nil then
    self:InitTemplateServerGroupOpenTime()
  end
  local sId = serverId or LuaEntry.Player:GetSourceServerId()
  for _, v in ipairs(self.templateServerGroup) do
    if v.season == curSeason and sId >= v.s1 and sId <= v.s2 then
      return v.sTime, v.eTime
    end
  end
  return 0, 0
end

function ActMeteoriteBattleManager:GetStageTime(stageId, beginTime)
  local stages = self:GetStages()
  local actInfo = self:GetActInfo()
  local sTime = beginTime == nil and (actInfo ~= nil and actInfo.beginTime or 0) or beginTime
  local fInfo = stages[2]
  local min = math.min(stageId, #stages - 1)
  local curInfo = stages[min]
  sTime = sTime + (curInfo.week - fInfo.week) * OneDayTime + (curInfo.hour - fInfo.hour) * OneHourTime + (curInfo.min - fInfo.min) * 60
  local eInfo = stages[min + 1]
  local eTime = sTime + (eInfo.week - curInfo.week) * OneDayTime + (eInfo.hour - curInfo.hour) * OneHourTime + (eInfo.min - curInfo.min) * 60
  return sTime, eTime
end

function ActMeteoriteBattleManager:GetRewardsById(rewardId)
  local cache = self.rewardsListCache or {}
  local list = cache[rewardId]
  if list then
    return list
  end
  list = DataCenter.ChampionDuelManager:GetRewardsById(rewardId)
  cache[rewardId] = list
  self.rewardsListCache = cache
  return list
end

function ActMeteoriteBattleManager:CheckShowNews()
  local actInfo = self:GetActInfo()
  if actInfo == nil then
    return false
  end
  local signTime = CommonUtil.PlayerPrefsGetInt(NEWS_FLAG, 0)
  return signTime < actInfo.beginTime
end

function ActMeteoriteBattleManager:SignNewFlag()
  CommonUtil.PlayerPrefsSetInt(NEWS_FLAG, UITimeManager:GetInstance():GetServerSeconds())
end

function ActMeteoriteBattleManager:CheckIfActOpen()
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.ActMeteorite.ActId)
  if actInfo == nil then
    return false
  end
  local isValid = actInfo:IsValid()
  if not isValid then
    return false
  end
  local inGroup = DataCenter.ActMeteoriteBattleManager:IsInMeteoriteBattleServerGroup()
  return inGroup
end

function ActMeteoriteBattleManager:SignMeteoriteDestroyAll()
  self.meteoriteDestroyAllFlag = true
  self:CheckIsNeedPop(true)
end

function ActMeteoriteBattleManager:TryShowFlyTip(mailId, bLogin)
  self.flyMailId = mailId
  if bLogin then
    self:CheckIsNeedPop()
  elseif self.meteoriteDestroyAllFlag then
    self:CheckIsNeedPop(true)
  end
end

function ActMeteoriteBattleManager:CheckIsNeedPop(bOpen)
  local mailId = self.flyMailId
  if string.IsNullOrEmpty(mailId) then
    return
  end
  local mailInfo = DataCenter.MailDataManager:GetMailInfoById(self.flyMailId)
  if mailInfo == nil then
    return
  end
  if bOpen then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWActMeteoriteFlyTip, {anim = true}, mailId)
  else
    local isFunctionOn = DataCenter.LWPopupManager:IsFunctionOnNewPopupStyle()
    if not isFunctionOn then
      DataCenter.UIPopWindowManager:Push(UIWindowNames.LWActMeteoriteFlyTip, {anim = true}, mailId)
    else
      DataCenter.LWPopupManager:TryAddPopupNotification(PopupNotificationType.ActMeteoriteBattle, mailId)
    end
  end
  self.meteoriteDestroyAllFlag = false
  self.flyMailId = nil
end

function ActMeteoriteBattleManager:ReqGetActInfo()
  if self.lastReqActTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.lastReqActTime - curTime < 3000 then
      return
    end
    self.lastReqActTime = curTime
  end
  SFSNetwork.SendMessage(MsgDefines.MeteoriteActInfo)
end

function ActMeteoriteBattleManager:OnHandleActInfo(t)
  if t.stage == nil then
    return
  end
  local actInfo = self.actInfo
  if actInfo == nil then
    actInfo = MeteoriteActInfoData.New()
  end
  local scoreFlag = false
  if actInfo.stage == t.stage and actInfo.stageEndTime == t.stageEndTime then
    scoreFlag = true
  end
  actInfo:ParseData(t)
  self.actInfo = actInfo
  if scoreFlag then
    EventManager:GetInstance():Broadcast(EventId.MeteoriteBattleScoreUpdate)
  else
    EventManager:GetInstance():Broadcast(EventId.MeteoriteBattleInfoRefresh)
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshRaceEntrance)
  if SceneUtils.GetIsInWorld() then
    self:RequestMeteoriteWorldInfo()
  end
end

function ActMeteoriteBattleManager:ReqScoreCount()
  SFSNetwork.SendMessage(MsgDefines.MeteoriteScoreCount)
end

function ActMeteoriteBattleManager:OnUpdateMoveCityFreeEndTime(endTime)
  if not self.actInfo then
    return
  end
  self.actInfo:UpdateMoveCityFreeEndTime(endTime)
  EventManager:GetInstance():Broadcast(EventId.MeteoriteFreeMvRefresh)
end

function ActMeteoriteBattleManager:GetMoveCityFreeTime()
  if not self.actInfo then
    return -1
  end
  return self.actInfo.meteoriteFreeMoveCdEndTime or -1
end

function ActMeteoriteBattleManager:CanShowRankChange()
  if CommonUtil.IsDebug() then
    return true
  end
  local server = LuaEntry.Player:GetCurServerId() or 0
  if 197 <= server and server <= 292 then
    return true
  elseif 3 <= server and server <= 68 then
    return true
  end
  return false
end

function ActMeteoriteBattleManager:OnPlayerRankChanged(msg)
  if not self:CanShowRankChange() then
    return
  end
  local player = {}
  player.lastRank = msg.lastRank
  player.rank = msg.rank
  player.score = msg.score
  player.pic = msg.pic
  player.picVer = msg.picVer
  local target
  if msg.target then
    target = {}
    target.rank = msg.target.rank or 0
    target.score = msg.target.score or 0
    target.pic = msg.target.pic
    target.picVer = msg.target.picVer
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActMeteoriteRankChangedNotice, {anim = true}, {
    type = 0,
    player = player,
    target = target
  })
end

function ActMeteoriteBattleManager:OnAllianceRankChanged(msg)
  if not self:CanShowRankChange() then
    return
  end
  local player = {}
  player.lastRank = msg.lastRank
  player.rank = msg.rank
  player.score = msg.score
  player.abbr = msg.abbr
  player.icon = msg.icon
  local target
  if msg.target then
    target = {}
    target.rank = msg.target.rank or 0
    target.score = msg.target.score or 0
    target.abbr = msg.target.abbr
    target.icon = msg.target.icon
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActMeteoriteRankChangedNotice, {anim = true}, {
    type = 1,
    player = player,
    target = target
  })
end

function ActMeteoriteBattleManager:OnScoreUpdate(t)
  local score = t.score
  if score == nil then
    return
  end
  local actInfo = self:GetActInfo()
  if actInfo == nil then
    return
  end
  local oldScore = actInfo.count
  actInfo.count = score
  EventManager:GetInstance():Broadcast(EventId.MeteoriteBattleScoreUpdate, score - oldScore)
  EventManager:GetInstance():Broadcast(EventId.RefreshRaceEntrance)
end

function ActMeteoriteBattleManager:GetActInfo()
  return self.actInfo
end

function ActMeteoriteBattleManager:GetTotalRedCount()
  local cnt = 0
  local boxesConfig = self:GetRewardBoxes(1)
  for _, v in ipairs(boxesConfig) do
    if self:GetBoxStateByCfg(v) == 2 then
      cnt = cnt + 1
    end
  end
  return cnt
end

function ActMeteoriteBattleManager:GetCurStageId()
  local actInfo = self:GetActInfo()
  if actInfo == nil then
    return 0
  end
  local stages = self:GetStages()
  local curStage = actInfo.stage
  local grabTimes = actInfo.grabTimes
  local cnt = 0
  for i, v in ipairs(stages) do
    local stage = v.stage
    if stage == curStage then
      if stage == MeteoriteState.GRAB or stage == MeteoriteState.REST then
        if cnt == grabTimes then
          return i
        end
      else
        return i
      end
    end
    if stage == MeteoriteState.GRAB then
      cnt = cnt + 1
    end
  end
  return 0
end

function ActMeteoriteBattleManager:GetCurMeteoriteInfo()
  local actInfo = self:GetActInfo() or {}
  local curTimes = (actInfo.grabTimes or -1) + 1
  local meteorites = actInfo.meteorites or {}
  for i, v in ipairs(meteorites) do
    if i == curTimes then
      return v
    end
  end
  return nil
end

function ActMeteoriteBattleManager:IsRewardOpened(configId)
  local actInfo = self:GetActInfo()
  if actInfo == nil then
    return false
  end
  local rewards = actInfo.rewards or {}
  return rewards[configId] == true
end

function ActMeteoriteBattleManager:GetBoxStateByCfg(config)
  local state = 1
  local rewarded = self:IsRewardOpened(config.id)
  if rewarded then
    state = 3
  else
    local actInfo = self:GetActInfo() or {}
    local curScore = actInfo.count or 0
    if curScore >= toInt(config.para) then
      state = 2
    end
  end
  return state
end

function ActMeteoriteBattleManager:GetBoxState(index)
  local boxesConfig = self:GetRewardBoxes(1)
  local config = boxesConfig[index] or {}
  return self:GetBoxStateByCfg(config)
end

function ActMeteoriteBattleManager:ReqRankInfo(grabTimes, bPerson)
  local group
  if bPerson then
    group = self.rankPerson[grabTimes]
  else
    group = self.rankAlliance[grabTimes]
  end
  if group ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if curTime - group.time < 10 then
      EventManager:GetInstance():Broadcast(EventId.MeteoriteBattleRankRefresh, group)
      return
    end
  end
  local msg = bPerson and MsgDefines.MeteoriteRankPersonInfo or MsgDefines.MeteoriteRankAllianceInfo
  SFSNetwork.SendMessage(msg, grabTimes)
end

function ActMeteoriteBattleManager:OnHandleRankInfo(t, bPerson)
  local group = DeepCopy(t)
  group.bPerson = bPerson
  group.time = UITimeManager:GetInstance():GetServerSeconds()
  local rankList = bPerson and self.rankPerson or self.rankAlliance
  rankList[group.grabTimes] = group
  EventManager:GetInstance():Broadcast(EventId.MeteoriteBattleRankRefresh, group)
end

function ActMeteoriteBattleManager:GetRanksByGroup(grabTimes, bPerson)
  local rankList = bPerson and self.rankPerson or self.rankAlliance
  return rankList[grabTimes]
end

function ActMeteoriteBattleManager:ReqGetReward(rewardId)
  SFSNetwork.SendMessage(MsgDefines.MeteoriteGetReward, rewardId)
end

function ActMeteoriteBattleManager:OnHandleGetReward(t)
  local reward = t ~= nil and t.reward or nil
  if reward == nil then
    return
  end
  DataCenter.RewardManager:AddRewards(reward)
  DataCenter.RewardManager:ShowCommonReward(t)
  local rewardIds = t.rewardIds
  if rewardIds ~= nil then
    local actInfo = self:GetActInfo()
    local rewards = actInfo ~= nil and actInfo.rewards or nil
    if rewards ~= nil then
      for i, id in pairs(rewardIds) do
        rewards[id] = true
      end
    end
    EventManager:GetInstance():Broadcast(EventId.MeteoriteBattleRewardsRefresh)
  end
end

function ActMeteoriteBattleManager:ReqRandomPoint(id)
  local actInfo = self:GetActInfo()
  if actInfo == nil then
    UIUtil.ShowTipsId("yuntieBattle_tips_1002")
    return
  end
  if actInfo.stage == MeteoriteState.SHOW then
    UIUtil.ShowTipsId("370100")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.MeteoriteRandomPoint, id)
end

function ActMeteoriteBattleManager:OnHandleRandomPoint(t)
  self:DoPointJump(t.pointId, false)
end

function ActMeteoriteBattleManager:IsInCrossTimeWindow()
  local actInfo = self:GetActInfo()
  if not actInfo then
    return false
  end
  local stage = actInfo.stage
  if stage == MeteoriteState.GRAB then
    return true
  end
  if stage == MeteoriteState.PREVIEW or stage == MeteoriteState.REST then
    local uiTimeMgr = UITimeManager:GetInstance()
    local canMoveStartSec = uiTimeMgr:GetTodayZeroServerTime(actInfo.stageEndTime) + 300
    local curSec = uiTimeMgr:GetServerSeconds()
    if canMoveStartSec <= curSec then
      canMoveStartSec = actInfo.stageEndTime - 300
      if curSec >= canMoveStartSec then
        return true
      else
        return false, canMoveStartSec
      end
      return true
    else
      return false, canMoveStartSec
    end
  end
  return false
end

function ActMeteoriteBattleManager:CanCrossServer()
  local actInfo = self:GetActInfo()
  if not actInfo then
    return Localization:GetString("370100")
  end
  local meteorite = self:GetCurMeteoriteInfo()
  if meteorite == nil then
    return Localization:GetString("yuntieBattle_tips_1002")
  end
  local stage = actInfo.stage
  if stage == MeteoriteState.MATCH then
    return Localization:GetString("120632")
  elseif stage == MeteoriteState.PREVIEW then
    local canMove, time = self:IsInCrossTimeWindow()
    if canMove then
      return nil
    elseif time then
      local lTimeStr = uiTimeMgr:ConvertServerTimeToLocalTime(time * 1000, false, true)
      return Localization:GetString("yuntieBattle_tips_1034", lTimeStr)
    end
  elseif stage == MeteoriteState.GRAB then
    return nil
  elseif stage == MeteoriteState.REST then
    local canMove, time = self:IsInCrossTimeWindow()
    if canMove then
      return nil
    elseif time then
      local uiTimeMgr = UITimeManager:GetInstance()
      local lTimeStr = uiTimeMgr:ConvertServerTimeToLocalTime(time * 1000, false, true)
      return Localization:GetString("yuntieBattle_tips_1034", lTimeStr)
    end
    return Localization:GetString("yuntieBattle_tips_1035")
  elseif stage == MeteoriteState.SHOW then
    return Localization:GetString("370100")
  elseif stage == MeteoriteState.END then
    return Localization:GetString("370100")
  end
  return Localization:GetString("120632")
end

function ActMeteoriteBattleManager:DoPointJump(pId, bMoveCity)
  local actInfo = self:GetActInfo()
  if actInfo == nil then
    UIUtil.ShowTipsId("yuntieBattle_tips_1002")
    return
  end
  local stage = actInfo.stage
  if stage == MeteoriteState.SHOW then
    UIUtil.ShowTipsId("370100")
    return
  end
  local meteorite = self:GetCurMeteoriteInfo()
  if meteorite == nil then
    UIUtil.ShowTipsId("yuntieBattle_tips_1002")
    return
  end
  local meteoriteServerId = meteorite.serverId
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  local selfServerId = LuaEntry.Player:GetSelfServerId()
  if meteoriteServerId ~= sourceServerId and not LuaEntry.Player:IsInSelfServer() and CrossServerUtil.IsCrossMoveCD(true, meteoriteServerId) then
    return
  end
  local meteoriteInSourceServer = meteoriteServerId == sourceServerId
  if (pId == nil or pId == 0) and bMoveCity == nil then
  elseif stage ~= MeteoriteState.GRAB and not meteoriteInSourceServer then
    local canMove, sec = self:IsInCrossTimeWindow()
    if not canMove then
      if sec then
        local uiTimeMgr = UITimeManager:GetInstance()
        local lTimeStr = uiTimeMgr:ConvertServerTimeToLocalTime(sec * 1000, false, true)
        UIUtil.ShowTips(Localization:GetString("yuntieBattle_tips_1034", lTimeStr))
      else
        UIUtil.ShowTipsId("yuntieBattle_tips_1035")
      end
      return
    end
  end
  if pId == nil or pId == 0 then
    pId = meteorite.pointId
  end
  if pId == nil or pId == 0 then
    UIUtil.ShowTipsId("yuntieBattle_tips_1002")
    return
  end
  local cb
  if bMoveCity then
    if meteoriteServerId == selfServerId then
      local selfMarchCount = UIUtil.GetSelfMarchCountExceptGolloes()
      if 0 < selfMarchCount then
        UIUtil.ShowMessage(CS.GameEntry.Localization:GetString(GameDialogDefine.PLEASE_BACK_MARCH), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        end, function()
        end)
        return
      end
      if self.battleWorldInfo then
        local inHigh, inLow = self.battleWorldInfo:CheckPointIndex(LuaEntry.Player:GetMainWorldPos())
        if inHigh or inLow then
          local item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_MOVE_CITY)
          local need = 1
          if item == nil or need > item.count then
            LWResourceLackUtil:GotoGoodsItemLack(SpecialItemId.ITEM_MOVE_CITY, need)
            return
          end
        end
      end
    end
    
    function cb()
      MoveCityUtil.TryMoveCity(pId)
    end
  end
  local willPos = SceneUtils.TileIndexToWorld(pId, ForceChangeScene.World)
  GoToUtil.CloseAllWindows()
  SceneUtils.ChangeToWorld(function()
    GoToUtil.GotoWorldPos(willPos, 235 or CS.SceneManager.World.InitZoom, LookAtFocusTime, cb, meteorite.serverId, 0)
    self:TryCreateFakeMeteoriteFragment(pId)
  end)
end

function ActMeteoriteBattleManager:OnEnterWorld()
  self:RequestMeteoriteWorldInfo()
end

function ActMeteoriteBattleManager:ExitWorld()
  self:ClearWorldMeteorite()
end

function ActMeteoriteBattleManager:RequestMeteoriteWorldInfo()
  if BattleFieldUtil.InBattleField() then
    return
  end
  self.timeLastRequestBattleInfo = UITimeManager:GetInstance():GetServerTime()
  SFSNetwork.SendMessage(MsgDefines.MeteoriteEnterWorld, LuaEntry.Player:GetCurServerId())
end

function ActMeteoriteBattleManager:GetMinLevel()
  if self.activityMinLevel then
    return self.activityMinLevel
  end
  local tabData = LocalController:instance():getLine(TableName.Activity, EnumActivity.ActMeteorite.ActId)
  if tabData then
    self.activityMinLevel = tonumber(tabData.needMainCityLevel) or 1
  else
    self.activityMinLevel = 1
  end
  return self.activityMinLevel
end

function ActMeteoriteBattleManager:OnHandleEnterWorldMessage(msg)
  local serverId = msg.serverId or 0
  local pointId = msg.pointId or 0
  local grabBeginTime = msg.grabBeginTime or 0
  local grabEndTime = msg.grabEndTime or 0
  local blackLandSize = msg.blackLandSize or 0
  local yellowLandSize = msg.yellowLandSize or 0
  self.timeLastUpdateBattleInfo = UITimeManager:GetInstance():GetServerTime()
  local groupServer = msg.groupServer
  local state = msg.stage or 0
  if grabBeginTime <= 0 then
    self.battleWorldInfo = nil
  else
    self.battleWorldInfo = MeteoriteBattleWorldInfo.New()
    self.battleWorldInfo:Init(serverId, pointId, blackLandSize, yellowLandSize, grabBeginTime, grabEndTime, groupServer)
    self.battleWorldInfo:RefreshByMsg(msg)
  end
  self:OnBattleWorldInfoUpdate()
  if SceneUtils.GetIsInWorld() then
    local currentIsInBattleState = MeteoriteBattleUtils.IsInBattleState()
    if not currentIsInBattleState then
      if self.cachedBattleState then
        self.cachedBattleState = nil
        CS.SceneManager.World:CleanAllianceCacheData()
      end
    elseif not self.cachedBattleState then
      self.cachedBattleState = true
      CS.SceneManager.World:CleanAllianceCacheData()
    end
    EventManager:GetInstance():Broadcast(EventId.MeteoriteFuckIReceivedEnterWorldMessage)
  end
end

local lastKillScore = {
  [101] = 1,
  [102] = 1
}

function ActMeteoriteBattleManager:OnHandleCollectFinish(t)
  local pointId = t.pointId or 0
  local playerInfo = t.playerInfo
  local rId = t.id or 0
  if 0 < pointId and 0 < rId and playerInfo and self.worldMeteoriteEffectComp then
    local entityConfig = self:GetEntityConfigById(rId)
    if not entityConfig then
      return
    end
    local lastPoint = entityConfig.point_last or 0
    if 0 < lastPoint then
      self.worldMeteoriteEffectComp:PlayLastKillNotice(pointId, playerInfo.uid, playerInfo.headPic, playerInfo.headPicVer, string.format(LoadPath.ItemPath, "lrb_zhouliuhuodong_jifen"), lastPoint, entityConfig.pic, lastKillScore[rId] or 0)
    else
      self.worldMeteoriteEffectComp:PlayLastKillNotice(pointId, playerInfo.uid, playerInfo.headPic, playerInfo.headPicVer, entityConfig.pic, lastKillScore[rId] or 0, "", 0)
    end
  end
end

function ActMeteoriteBattleManager:OnHandleAttackCityFinish(t)
  local pointId = t.pointId or 0
  local playerInfo = t.playerInfo
  local rId = t.id or 0
  local count = t.count
  if 0 < pointId and 0 < rId and playerInfo and 0 < count and self.worldMeteoriteEffectComp then
    local entityConfig = self:GetEntityConfigById(rId)
    if not entityConfig then
      return
    end
    local pic = entityConfig.pic
    self.worldMeteoriteEffectComp:PlayLastKillNotice(pointId, playerInfo.uid, playerInfo.headPic, playerInfo.headPicVer, pic, count, "", 0)
  end
end

function ActMeteoriteBattleManager:OnCrossServer()
  self:RequestMeteoriteWorldInfo()
end

function ActMeteoriteBattleManager:OnBattleWorldInfoUpdate()
  local delay = false
  if not self.battleWorldInfo then
    MeteoriteBattleUtils.Log("\229\183\178\231\187\143\230\178\161\230\156\137\233\153\168\233\147\129\228\186\137\229\164\186\230\136\152\228\186\134...")
    if self.worldMeteoriteEffectComp then
      local curState = self.worldMeteoriteEffectComp.CurrentState
      if curState == 7 then
        delay = true
      else
        self:ClearWorldMeteorite()
      end
    else
      self:ClearWorldMeteorite()
    end
  else
    self:RestartAutoNotifications()
    local loadPlayer = SceneUtils.GetIsInWorld() and self.battleWorldInfo.serverId == LuaEntry.Player:GetCurServerId() and not BattleFieldUtil.InBattleField()
    if loadPlayer then
      if not self.worldMeteoriteEffect then
        MeteoriteBattleUtils.Log("\229\138\160\232\189\189\233\153\168\233\147\129\230\146\173\230\148\190\229\153\168")
        self:LoadWorldMeteoriteEffectPlayer()
      elseif IsNotNull(self.worldMeteoriteEffectComp) then
        MeteoriteBattleUtils.Log("\230\155\180\230\150\176\233\153\168\233\147\129\230\146\173\230\148\190\229\153\168\230\149\176\230\141\174")
        self.worldMeteoriteEffectComp:UpdateInfo(self.battleWorldInfo.serverId or 0, self.battleWorldInfo.pointIndex, self.battleWorldInfo.hSize, self.battleWorldInfo.lSize, self.battleWorldInfo.startTime, self.battleWorldInfo.endTime)
      end
    elseif not loadPlayer and IsNotNull(self.worldMeteoriteEffectComp) then
      local curState = self.worldMeteoriteEffectComp.CurrentState
      MeteoriteBattleUtils.Log("\228\184\141\229\134\141\233\156\128\232\166\129\233\153\168\233\147\129\230\146\173\230\148\190\229\153\168\239\188\140\229\189\147\229\137\141\231\138\182\230\128\129:%s", curState)
      if curState == 7 then
        delay = true
      else
        self:ClearWorldMeteorite()
      end
    end
  end
  if delay then
    self:ClearDelayRequest()
    MeteoriteBattleUtils.Log("\229\188\128\229\144\175\229\187\182\232\191\159\232\175\183\230\177\130")
    self.delayRequestTimer = TimerManager:GetInstance():DelayInvoke(function()
      MeteoriteBattleUtils.Log("\229\187\182\232\191\159\229\136\183\230\150\176\230\136\152\229\156\186")
      DataCenter.ActMeteoriteBattleManager:RequestMeteoriteWorldInfo()
    end, 5)
  end
end

function ActMeteoriteBattleManager:ClearDelayRequest()
  if self.delayRequestTimer then
    self.delayRequestTimer:Stop()
    self.delayRequestTimer = nil
  end
end

function ActMeteoriteBattleManager:LoadWorldMeteoriteEffectPlayer()
  if not self.worldMeteoriteEffect and self.battleWorldInfo then
    Logger.LogInfo("[Meteorite] LoadWorldMeteoriteEffectPlayer")
    local path = "Assets/Main/Prefabs/World/Meteorite/MeteoriteWorldEffectPlayer.prefab"
    self.worldMeteoriteEffect = ResourceManager:InstantiateAsync(path)
    self.worldMeteoriteEffect:completed("+", function(req)
      if req.isError then
        self:DestroyEffectPlayer()
        return
      end
      local isValid = SceneUtils.GetIsInWorld() and self.battleWorldInfo and self.battleWorldInfo.serverId == LuaEntry.Player:GetCurServerId() and not BattleFieldUtil.InBattleField()
      if not isValid then
        self:DestroyEffectPlayer()
        return
      end
      self.worldMeteoriteEffectComp = req.gameObject:GetComponent(typeof(MeteoriteWorldEffectPlayer))
      if self.worldMeteoriteEffectComp then
        self.worldMeteoriteEffectComp:UpdateInfo(self.battleWorldInfo.serverId or 0, self.battleWorldInfo.pointIndex, self.battleWorldInfo.hSize, self.battleWorldInfo.lSize, self.battleWorldInfo.startTime, self.battleWorldInfo.endTime)
        if self.fakeMeteorite then
          EventManager:GetInstance():Broadcast(EventId.MeteoriteFakeFragment, self.fakeMeteorite)
          self.fakeMeteorite = nil
        end
      end
    end)
  end
end

function ActMeteoriteBattleManager:TryCreateFakeMeteoriteFragment(pid)
  if IsNotNull(self.worldMeteoriteEffectComp) then
    EventManager:GetInstance():Broadcast(EventId.MeteoriteFakeFragment, pid)
  else
    self.fakeMeteorite = pid
  end
end

function ActMeteoriteBattleManager:ManualStart(pointIndex, hSize, lSize, startTime, endTime)
  UIUtil.ShowTips("[Editor]\230\137\139\229\138\168\229\144\175\229\138\168\233\153\168\233\147\129\228\186\137\229\164\186\230\136\152\230\146\173\230\148\190\229\153\168!")
  self:ClearWorldMeteorite()
  self.battleWorldInfo = MeteoriteBattleWorldInfo.New()
  self.battleWorldInfo:Init(LuaEntry.Player:GetCurServerId(), pointIndex, hSize, lSize, startTime, endTime)
  self:OnBattleWorldInfoUpdate()
end

function ActMeteoriteBattleManager:DestroyEffectPlayer()
  Logger.LogInfo("[Meteorite] DestroyEffectPlayer")
  if IsNotNull(self.worldMeteoriteEffectComp) then
    self.worldMeteoriteEffectComp:Dispose()
  end
  self.worldMeteoriteEffectComp = nil
  if self.worldMeteoriteEffect then
    self.worldMeteoriteEffect:Destroy()
    self.worldMeteoriteEffect = nil
  end
end

function ActMeteoriteBattleManager:DelayDestroyPlayer(request, player)
  if not request then
    return
  end
  if not self.delayDestroy then
    self.delayDestroy = {}
  end
  if self.delayDestroy[request] then
    return
  end
  self.delayDestroy[request] = {request = request, player = player}
  self:ClearDelayDestroyTimer()
  self.delayDestroyTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:DelayDestroyImpl()
  end, 5)
  MeteoriteBattleUtils.Log("\232\167\166\229\143\145\229\187\182\232\191\159\233\135\138\230\148\190\239\188\129")
end

function ActMeteoriteBattleManager:ClearWorldMeteorite()
  MeteoriteBattleUtils.Log("\233\135\138\230\148\190\233\153\168\233\147\129\230\146\173\230\148\190\229\153\168")
  self:DestroyEffectPlayer()
  self:ClearNextTipsTimer()
  self:ClearNotificationTimer()
  self:ClearCurrentTipsTimer()
  self:ClearDelayRequest()
  self.currentTips = nil
  self.nextTips = nil
  self.fakeMeteorite = nil
end

function ActMeteoriteBattleManager:GetCityMeteoriteCount()
  local myPointInfo = CS.SceneManager.World:GetMyPointInfo()
  if IsNotNull(myPointInfo) then
    return myPointInfo.crystal or 0, myPointInfo.nucleus or 0
  end
  if not self.battleWorldInfo then
    return 0, 0
  end
  return self.battleWorldInfo.crystal or 0, self.battleWorldInfo.nucleus or 0
end

function ActMeteoriteBattleManager:GetMarchMeteoriteCount()
  if not self:IsInMeteoriteBattle() then
    return 0, 0
  end
  local crystal = 0
  local nucleus = 0
  local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
  for _, march in pairs(selfMarch) do
    local _c = march.crystal or 0
    local _n = march.nucleus or 0
    crystal = crystal + _c
    nucleus = nucleus + _n
  end
  return crystal, nucleus
end

function ActMeteoriteBattleManager:GetWorldEffectPlayer()
  return self.worldMeteoriteEffectComp
end

function ActMeteoriteBattleManager:GetMeteoriteCenterPointIndex()
  if self.battleWorldInfo then
    return self.battleWorldInfo.pointIndex
  end
  return 500500
end

function ActMeteoriteBattleManager:TriggerFreeMoveCity(targetPointIndex, fromServer)
  if not self:IsInMeteoriteBattle() then
    return false
  end
  if not self:IsInMeteoriteBattleServerGroup() then
    return false
  end
  if LuaEntry.Player:GetSelfServerId() == LuaEntry.Player:GetCurServerId() then
    local freeEndTime = self:GetMoveCityFreeTime()
    if 0 <= freeEndTime then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if freeEndTime <= curTime then
        local playerCurPointIdx = LuaEntry.Player:GetMainWorldPos()
        local a1, a2 = self:CheckPointIndexInActArea(playerCurPointIdx)
        if a1 or a2 then
          a1, a2 = self:CheckPointIndexInActArea(targetPointIndex)
          if a1 or a2 then
            return true
          end
        end
      end
    end
    if not self:IsInHighArea() and not self:IsInLowArea() then
      local a1, a2 = self:CheckPointIndexInActArea(targetPointIndex)
      if a1 or a2 then
        return true
      end
    end
  end
  return false
end

function ActMeteoriteBattleManager:HaveMeteoriteMine()
  local crystal, nucleus = self:GetCityMeteoriteCount()
  return 0 < crystal or 0 < nucleus
end

function ActMeteoriteBattleManager:IsInMeteoriteBattle()
  if not self.battleWorldInfo then
    return false
  end
  if not SceneUtils.GetIsInWorld() then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if curTime > self.battleWorldInfo.endTime or curTime < self.battleWorldInfo.startTime then
    return false
  end
  return self.battleWorldInfo.serverId == LuaEntry.Player:GetCurServerId()
end

function ActMeteoriteBattleManager:IsInMeteoriteBattleServerGroup()
  local selfServer = LuaEntry.Player:GetSourceServerId()
  return self:CheckServerInGroup(selfServer)
end

function ActMeteoriteBattleManager:CheckServerInGroup(serverId)
  if self.actInfo then
    return self.actInfo:CheckServerInGroup(serverId)
  end
  if self.battleWorldInfo then
    return self.battleWorldInfo:CheckServerInGroup(serverId)
  end
  return false
end

function ActMeteoriteBattleManager:GetMeteoriteServerId()
  return self.battleWorldInfo and self.battleWorldInfo.serverId
end

function ActMeteoriteBattleManager:GetEntityConfigById(id)
  if self.entityTabCache[id] then
    return self.entityTabCache[id]
  end
  self.entityTabCache[id] = LocalController:instance():getLine(TableName.MeteoriteBattleEntity, id)
  return self.entityTabCache[id]
end

local _iconResPath = {
  [100] = "Assets/Main/Sprites/LodIcon/zyf_yuntiesuipian_wujisuofang_bai.png",
  [101] = "Assets/Main/Sprites/LodIcon/zyf_yuntiejiejing_wujisuofang_bai.png",
  [102] = "Assets/Main/Sprites/LodIcon/zyf_yuntiejingti_wujisuofang_bai.png"
}

function ActMeteoriteBattleManager:GetEntityLocIconById(id)
  id = tonumber(id) or 100
  return _iconResPath[id] or _iconResPath[100]
end

function ActMeteoriteBattleManager:GetMeteoriteEffectPlayerState()
  if IsNull(self.worldMeteoriteEffectComp) then
    return -1
  end
  return self.worldMeteoriteEffectComp.CurrentState or -1
end

function ActMeteoriteBattleManager:IsInHighArea()
  if not self.battleWorldInfo then
    return false
  end
  return self.battleWorldInfo:CheckHighArea()
end

function ActMeteoriteBattleManager:IsInLowArea()
  if not self.battleWorldInfo then
    return false
  end
  return self.battleWorldInfo:CheckLowArea()
end

function ActMeteoriteBattleManager:GetBattleWorldInfo()
  return self.battleWorldInfo
end

function ActMeteoriteBattleManager:IsInArea()
  return self:IsInHighArea() or self:IsInLowArea()
end

function ActMeteoriteBattleManager:NeedNoticeShield()
  if not self:IsInMeteoriteBattle() then
    return false
  end
  local ignoreNotice = CommonUtil.PlayerPrefsGetBool(SettingKeys.NO_METEORITE_DROP_PROMPT, false)
  if ignoreNotice then
    return false
  end
  local m1, m2 = self:GetCityMeteoriteCount()
  if 0 < m1 or 0 < m2 then
    return true
  end
  m1, m2 = self:GetMarchMeteoriteCount()
  if 0 < m1 or 0 < m2 then
    return true
  end
  return false
end

function ActMeteoriteBattleManager:NeedNoticeManualDrop()
  return not CommonUtil.PlayerPrefsGetBool(SettingKeys.NO_METEORITE_DROP_PROMPT2, false)
end

function ActMeteoriteBattleManager:CheckServerPointIndexInActArea(server, targetPointIndex)
  if not self:IsInMeteoriteBattle() then
    return false, false
  end
  return self.battleWorldInfo:CheckServerPointIndex(server, targetPointIndex)
end

function ActMeteoriteBattleManager:CheckPointIndexInActArea(targetPointIndex)
  if not self:IsInMeteoriteBattle() then
    return false, false
  end
  return self.battleWorldInfo:CheckPointIndex(targetPointIndex)
end

function ActMeteoriteBattleManager:CheckMoveInHotArea(targetPointIndex)
  if not self:IsInMeteoriteBattle() then
    return false
  end
  local inHigh, inLow = self.battleWorldInfo:CheckPointIndex(targetPointIndex)
  if inHigh or inLow then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local startTime = self.battleWorldInfo.startTime
    local gap = curTime - startTime
    if gap <= 10 and 0 < gap then
      return true
    else
      return false
    end
  else
    return false
  end
end

function ActMeteoriteBattleManager:NeedNoticeMoveCity(targetPointIndex)
  local ignoreNotice = CommonUtil.PlayerPrefsGetBool(SettingKeys.NO_METEORITE_DROP_PROMPT, false)
  if ignoreNotice then
    return false
  end
  if not self:HaveMeteoriteMine() then
    return false
  end
  if not self:IsInMeteoriteBattle() then
    return true
  end
  if self.battleWorldInfo then
    local inHigh, inLow = self.battleWorldInfo:CheckPointIndex(targetPointIndex)
    if inHigh or inLow then
      return false
    end
  else
    return false
  end
  return true
end

function ActMeteoriteBattleManager:NeedNoticeRandomMoveCity()
  local ignoreNotice = CommonUtil.PlayerPrefsGetBool(SettingKeys.NO_METEORITE_DROP_PROMPT, false)
  if ignoreNotice then
    return false
  end
  if not self:HaveMeteoriteMine() then
    return false
  end
  local inRange = self:IsInHighArea() or self:IsInLowArea()
  return inRange
end

function ActMeteoriteBattleManager:NeedNoticeAllianceMoveCityDropMine()
  local ignoreNotice = CommonUtil.PlayerPrefsGetBool(SettingKeys.NO_METEORITE_DROP_PROMPT, false)
  if ignoreNotice then
    return false
  end
  if not self:HaveMeteoriteMine() then
    return false
  end
  return true
end

function ActMeteoriteBattleManager:NeedNoticeAllianceMoveCityPosition()
  local markPoint = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint()
  if not markPoint then
    return false
  end
  local pointId = SceneUtils.BigIndexToStandardIndex(markPoint.pos)
  if self:CheckPointIndexInActArea(pointId) then
    return true
  end
  return false
end

local sheildChecker = {
  [100] = true,
  [101] = false,
  [102] = false
}

function ActMeteoriteBattleManager:CheckCanCollect(targetBuildId)
  if not self:IsInMeteoriteBattle() then
    return false, nil
  end
  local inRange = self:IsInHighArea() or self:IsInLowArea()
  local noSheild = sheildChecker[targetBuildId] or not DataCenter.DefenceWallDataManager:IsInShield()
  local inServerGroup = self:IsInMeteoriteBattleServerGroup()
  local lv = DataCenter.BuildManager:GetMainLevel() >= self:GetMinLevel()
  if inRange and noSheild and inServerGroup and lv then
    return true, nil
  else
    local conditions = {}
    table.insert(conditions, {
      label = Localization:GetString("yuntieBattle_interface_1035"),
      pic = "Assets/Main/TextureEx/LWActMeteorite/part4/meteoriteBattleCondition_01",
      ok = inRange,
      sort = 0
    })
    table.insert(conditions, {
      label = Localization:GetString("yuntieBattle_interface_1036"),
      ok = noSheild,
      sort = 1
    })
    table.insert(conditions, {
      label = Localization:GetString("yuntieBattle_tips_1028"),
      ok = inServerGroup,
      sort = 2
    })
    table.insert(conditions, {
      label = Localization:GetString("yuntieBattle_tips_1033", self:GetMinLevel()),
      ok = lv,
      sort = 3
    })
    return false, conditions
  end
end

function ActMeteoriteBattleManager:ShowMeteoriteTips(tips, icon)
  self:ShowGenMeteoriteNotice(Localization:GetString(tips), icon)
end

function ActMeteoriteBattleManager:OpenActWindowPls()
  if not self:IsInMeteoriteBattleServerGroup() then
    UIUtil.ShowTipsId("yuntieBattle_tips_1031")
    return
  end
  local lv = DataCenter.BuildManager:GetMainLevel()
  if lv < self:GetMinLevel() then
    UIUtil.ShowTipsId("yuntieBattle_tips_1033", self:GetMinLevel())
    return
  end
  if self.actInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWActMeteoriteMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  else
    UIUtil.ShowTipsId("120632")
  end
end

function ActMeteoriteBattleManager:GetCurrentNotice()
  return self.currentTips
end

function ActMeteoriteBattleManager:RestartAutoNotifications()
  self:ClearNextTipsTimer()
  self:ClearCurrentTipsTimer()
  self:ClearNotificationTimer()
  self.currentTips = nil
  self.nextTips = nil
  if not self.battleWorldInfo then
    return
  end
  if self.battleWorldInfo.serverId ~= LuaEntry.Player:GetCurServerId() then
    return
  end
  if BattleFieldUtil.InBattleField() then
    return
  end
  if #self.autoMeteoriteTipsInfo <= 0 then
    LocalController:instance():visitTable(TableName.MeteoriteBattleRefresh, function(id, line)
      local icon = line.icon
      if not string.IsNullOrEmpty(icon) then
        table.insert(self.autoMeteoriteTipsInfo, {
          trigger_time = tonumber(line.trigger_time),
          alert_time = tonumber(line.alert_time),
          icon = line.icon,
          alert_tips = line.alert_tips,
          id = id
        })
      end
    end)
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local startTime = self.battleWorldInfo.startTime
  if 0 < #self.autoMeteoriteTipsInfo then
    for i = 1, #self.autoMeteoriteTipsInfo do
      local info = self.autoMeteoriteTipsInfo[i]
      local _startTime = startTime + info.trigger_time - info.alert_time
      local _endTime = _startTime + info.alert_time
      if not self.currentTips and curTime >= _startTime and curTime < _endTime then
        self.currentTips = self.autoMeteoriteTipsInfo[i]
      end
      if curTime < _startTime then
        self.nextTips = self.autoMeteoriteTipsInfo[i]
        break
      end
    end
    if self.currentTips then
      local _startTime = startTime + self.currentTips.trigger_time - self.currentTips.alert_time
      local _endTime = _startTime + self.currentTips.alert_time
      local delaySec = _endTime - curTime
      if 0 < delaySec then
        self.currentTipsTimer = TimerManager:GetInstance():DelayInvoke(function()
          self:RestartAutoNotifications()
        end, delaySec + 0.1)
      end
    end
    if self.nextTips then
      local _startTime = startTime + self.nextTips.trigger_time - self.nextTips.alert_time
      local delaySec = _startTime - curTime
      self.nextTipsTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:RestartAutoNotifications()
        EventManager:GetInstance():Broadcast(EventId.MeteoriteBattleNotice)
      end, delaySec + 0.1)
      local _tips = self.nextTips.alert_tips
      local _icon = self.nextTips.icon
      self.notificationTimer = TimerManager:GetInstance():DelayInvoke(function()
        DataCenter.ActMeteoriteBattleManager:ShowMeteoriteTips(_tips, _icon)
      end, Mathf.Max(delaySec - 2.5, 0.1))
    end
  end
end

function ActMeteoriteBattleManager:ClearNextTipsTimer()
  if self.nextTipsTimer then
    self.nextTipsTimer:Stop()
    self.nextTipsTimer = nil
  end
end

function ActMeteoriteBattleManager:ClearNotificationTimer()
  if self.notificationTimer then
    self.notificationTimer:Stop()
    self.notificationTimer = nil
  end
end

function ActMeteoriteBattleManager:ClearCurrentTipsTimer()
  if self.currentTipsTimer then
    self.currentTipsTimer:Stop()
    self.currentTipsTimer = nil
  end
end

function ActMeteoriteBattleManager:HiDaddyIWantDropMeteorite(id)
  SFSNetwork.SendMessage(MsgDefines.MeteoriteDrop, id)
end

function ActMeteoriteBattleManager:PlayWorldDropMeteoriteEffect(from, to)
end

function ActMeteoriteBattleManager.OnPlayerStateChanged(battleState)
end

function ActMeteoriteBattleManager:OnDropMeteorite(t)
  local ret = t.ret
  local id = t.id
  if not (ret and id) or ret == 1 then
  else
    UIUtil.ShowTipsId("yuntieBattle_tips_1009")
  end
end

function ActMeteoriteBattleManager:ShowGenMeteoriteNotice(msg, pic)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMeteoriteGenNoticeNotice, {anim = false}, {msg = msg, pic = pic})
end

function ActMeteoriteBattleManager:Description()
  local sb = StringBuilder.New()
  local time = UITimeManager:GetInstance()
  sb:AppendLine("===\230\151\182\233\151\180===")
  sb:AppendLine(string.format("\229\189\147\229\137\141\230\151\182\233\151\180:%s", time:TimeStampToTimeForServer(time:GetServerTime())))
  sb:AppendLine()
  sb:AppendLine("===\229\159\186\231\161\128\228\191\161\230\129\175===")
  sb:AppendLine(LuaEntry.Player:Description())
  sb:AppendFormatLine("===\233\153\168\233\147\129\230\180\187\229\138\168\230\149\176\230\141\174===")
  sb:AppendFormatLine("\230\180\187\229\138\168\228\191\161\230\129\175(actInfo)[id:%s]\229\176\177\231\187\170: %s", EnumActivity.ActMeteorite.ActId, self.actInfo and " \226\136\154" or " \195\151")
  sb:AppendFormatLine("\229\189\147\229\137\141\233\153\168\233\147\129\230\180\187\229\138\168\230\152\175\229\144\166\229\188\128\230\148\190:%s", self:CheckIfActOpen())
  local meteorite = self:GetCurMeteoriteInfo()
  if meteorite then
    sb:AppendFormatLine("\230\180\187\229\138\168\229\176\134\229\143\145\231\148\159\229\156\168\230\156\141\229\138\161\229\153\168:%s", meteorite.serverId)
  else
    sb:AppendLine("\230\137\190\228\184\141\229\136\176\232\191\153\228\184\128\229\156\186\233\153\168\233\147\129\228\186\137\229\164\186\230\136\152\231\154\132\230\180\187\229\138\168\228\191\161\230\129\175...")
  end
  sb:AppendFormatLine("\230\156\128\229\176\143\229\143\130\229\138\160\231\173\137\231\186\167:%s, (\230\136\145\231\154\132\231\173\137\231\186\167:%s)", self:GetMinLevel(), DataCenter.BuildManager:GetMainLevel())
  if self.actInfo then
    sb:AppendFormatLine("---self.actInfo\232\175\166\230\131\133---")
    sb:AppendFormatLine(self.actInfo:Description())
  end
  sb:AppendLine()
  sb:AppendFormatLine("===\233\153\168\233\147\129\229\164\167\228\184\150\231\149\140\230\149\176\230\141\174===")
  sb:AppendFormatLine("\228\184\138\230\172\161\232\175\183\230\177\130(MeteoriteEnterWorld)\230\136\152\229\156\186\228\191\161\230\129\175\231\154\132\230\151\182\233\151\180\230\152\175:%s", time:TimeStampToTimeForServer(self.timeLastRequestBattleInfo or 0))
  sb:AppendFormatLine("\228\184\138\230\172\161\230\155\180\230\150\176\230\136\152\229\156\186\228\191\161\230\129\175\231\154\132\230\151\182\233\151\180\230\152\175:%s", time:TimeStampToTimeForServer(self.timeLastUpdateBattleInfo or 0))
  sb:AppendFormatLine("\230\136\152\229\156\186\228\191\161\230\129\175(battleWorldInfo)\229\176\177\231\187\170: %s", self.battleWorldInfo and " \226\136\154" or " \195\151")
  sb:AppendFormatLine("\229\189\147\229\137\141\230\152\175\229\144\166\229\156\168\230\136\152\229\156\186\228\184\173(IsInMeteoriteBattle):%s", self:IsInMeteoriteBattle() and " \226\136\154" or " \195\151")
  sb:AppendFormatLine("\230\152\175\229\144\166\229\156\168\230\136\152\230\150\151\231\138\182\230\128\129(MeteoriteBattleUtils.IsInBattleState):%s", MeteoriteBattleUtils.IsInBattleState() and " \226\136\154" or " \195\151")
  sb:AppendFormatLine("\230\136\145\229\156\168\228\184\141\229\156\168\230\180\187\229\138\168\230\156\141\229\138\161\229\153\168\232\140\131\229\155\180\229\134\133(IsInMeteoriteBattleServerGroup):%s", self:IsInMeteoriteBattleServerGroup() and " \226\136\154" or " \195\151")
  if self.battleWorldInfo then
    sb:AppendFormatLine("---self.battleWorldInfo\232\175\166\230\131\133---")
    sb:AppendFormatLine(self.battleWorldInfo:Description())
  end
  sb:AppendFormatLine("===\233\153\168\233\147\129\230\146\173\230\148\190\229\153\168\230\149\176\230\141\174===")
  sb:AppendFormatLine("\230\136\152\229\156\186\230\149\136\230\158\156\230\146\173\230\148\190\229\153\168\230\152\175\229\144\166\229\176\177\231\187\170(worldMeteoriteEffectComp): %s", self.worldMeteoriteEffectComp and " \226\136\154" or " \195\151")
  if self.worldMeteoriteEffectComp then
    sb:AppendFormatLine("---self.worldMeteoriteEffectComp\232\175\166\230\131\133---")
    sb:AppendFormatLine(self.worldMeteoriteEffectComp:Description())
  end
  sb:AppendLine()
  sb:AppendFormatLine("===\233\153\168\233\147\129\228\186\137\229\164\186\230\136\152\230\136\145\229\133\179\233\148\174\230\149\176\230\141\174===")
  local m1, m2 = self:GetCityMeteoriteCount()
  sb:AppendFormatLine("\228\184\187\229\160\161\231\187\147\230\153\182\230\149\176:%s\239\188\140 \230\153\182\230\160\184\230\149\176:%s", m1, m2)
  local m11, m22 = self:GetMarchMeteoriteCount()
  sb:AppendFormatLine("\232\161\140\229\134\155\231\187\147\230\153\182\230\149\176:%s\239\188\140 \230\153\182\230\160\184\230\149\176:%s", m11, m22)
  local m1total = m1 + m11
  local m2total = m2 + m22
  sb:AppendFormatLine("\230\128\187\231\187\147\230\153\182\230\149\176:%s\239\188\140 \230\153\182\230\160\184\230\149\176:%s", m1total, m2total)
  sb:AppendLine()
  sb:AppendFormatLine("===\229\133\182\228\187\150\228\191\161\230\129\175===")
  sb:AppendLine("---\233\153\168\233\147\129\229\136\183\231\159\191\233\128\154\231\159\165---")
  if self.currentTips then
    sb:AppendFormatLine("\229\189\147\229\137\141\233\128\154\231\159\165\231\154\132id\228\184\186:%s\239\188\140alert_time:%s", self.currentTips.id, self.currentTips.alert_time)
  else
    sb:AppendLine("\229\189\147\229\137\141\232\191\155\232\161\140\228\184\173\231\154\132\233\128\154\231\159\165\228\184\186 \231\169\186")
  end
  if self.currentTipsTimer then
    sb:AppendLine("\229\183\178\229\136\155\229\187\186\229\174\154\230\151\182\229\153\168[\229\189\147\229\137\141]")
  else
    sb:AppendLine("\230\156\170\229\136\155\229\187\186\229\174\154\230\151\182\229\153\168[\229\189\147\229\137\141]")
  end
  if self.nextTips then
    sb:AppendFormatLine("\228\184\139\228\184\128\230\172\161\233\128\154\231\159\165\231\154\132id\228\184\186:%s\239\188\140trigger_time:%s", self.nextTips.id, self.nextTips.trigger_time)
  else
    sb:AppendLine("\228\184\139\228\184\128\230\172\161\233\128\154\231\159\165\228\184\186 \231\169\186")
  end
  if self.nextTipsTimer then
    sb:AppendLine("\229\183\178\229\136\155\229\187\186\229\174\154\230\151\182\229\153\168[\228\184\139\228\184\128\230\172\161]")
  else
    sb:AppendLine("\230\156\170\229\136\155\229\187\186\229\174\154\230\151\182\229\153\168[\228\184\139\228\184\128\230\172\161]")
  end
  return sb:ToString()
end

return ActMeteoriteBattleManager
