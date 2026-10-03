local DailyActivityManager = BaseClass("DailyActivityManager")
local ActivityOverviewTemplate = require("DataCenter.TaskData.ActivityOverviewTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.cacheDisplayedLv = nil
  self.activityOverviewList = {}
  self.newUnlockedOverviewList = nil
  self:InitActivityOverviewList()
  self:InitNewUnlockedOverview()
  self:AddListener()
end

local function __delete(self)
  self.cacheDisplayedLv = nil
  self.activityOverviewList = nil
  self.newUnlockedOverviewList = nil
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.BuildLevelUp, self.TryUpdateNewUnlockedOverview)
  EventManager:GetInstance():AddListener(EventId.OnUnlockActivityViewClose, self.TryOpenDailyActivity)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.BuildLevelUp, self.TryUpdateNewUnlockedOverview)
  EventManager:GetInstance():RemoveListener(EventId.OnUnlockActivityViewClose, self.TryOpenDailyActivity)
end

local function Startup(self)
end

local function InitActivityOverviewList(self)
  self.activityOverviewList = {}
  LocalController:instance():visitTable(TableName.ActivityOverview, function(id, lineData)
    local template = ActivityOverviewTemplate.New()
    template:InitData(lineData)
    table.insert(self.activityOverviewList, template)
  end)
  table.sort(self.activityOverviewList, function(a, b)
    if a.order ~= b.order then
      return a.order < b.order
    else
      return false
    end
  end)
  if not self.cacheDisplayedLv then
    local strK = "DailyActivityUnlockDisplay_" .. LuaEntry.Player.uid
    self.cacheDisplayedLv = CS.GameEntry.Setting:GetInt(strK, 0)
  end
end

local function GetActivityOverviewList(self)
  return self.activityOverviewList
end

local function CheckIfShowActivityOverview(self)
  local isSwitchOn = LuaEntry.DataConfig:CheckSwitch("activity_daily_showlist")
  if not isSwitchOn then
    return false
  end
  for i, v in ipairs(self.activityOverviewList) do
    if self:CheckIfActIsOpen(v) then
      return true
    end
  end
end

local function CheckIfActIsOpen(self, overviewInfo)
  if DataCenter.BuildManager.MainLv ~= nil and DataCenter.BuildManager.MainLv < overviewInfo.unlockLv then
    local lockDesc = Localization:GetString("372224", overviewInfo.unlockLv)
    return false, lockDesc
  end
  return true
end

local function GetOverviewTotalRedCount(self)
  local total = 0
  for i, v in ipairs(self.activityOverviewList) do
    if self:CheckIfActIsOpen(v) then
      local tempCount = self:GetOverviewRedCount(v)
      total = total + tempCount
    end
  end
  return total
end

local function GetOverviewRedCount(self, overviewInfo)
  local hasRed = self:GetOverviewDesc(overviewInfo)
  if not hasRed then
    return 0
  else
    return 1
  end
end

local function JumpToActOverview(self, type)
  if OverviewToActType[type] then
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(OverviewToActType[type])
    if actList and 0 < #actList then
      local tempId = tonumber(actList[1].id)
      if OverviewTypeToDailyActivity[type] then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDailyActivity, {anim = true, hideTop = true}, type)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide,
          hideTop = true
        }, tempId)
      end
      DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.OpenActivityPanel, tostring(tempId))
    end
  elseif type == 1 then
    local info = DataCenter.EarthOrderDataManager:GetOneEarthOrder()
    if info then
      if DataCenter.EarthOrderDataManager:IsPreviewStatus() then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UINoEarthOrder, NextBusinessComeType.EARTH_ORDER)
      else
        GoToUtil.OpenInCity(function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIEarthOrder, {
            anim = true,
            UIMainAnim = UIMainAnimType.AllHide,
            hideTop = true
          }, info.uuid)
        end, BuildingTypes.FUN_BUILD_TRADING_CENTER)
      end
    else
      DataCenter.DailyActivityManager:UpdateActViewHistory(1)
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_TRADING_CENTER)
    end
  elseif type == 4 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionBattleMain, {anim = true, hideTop = true})
  elseif type == 9 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAdventureIntro, {anim = true, hideTop = true})
  elseif type == 10 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceEveryDayTask, {anim = true, hideTop = true})
  end
end

local function UpdateActViewHistory(self, type)
  local serverSec = UITimeManager:GetInstance():GetServerSeconds()
  local strK = LuaEntry.Player.uid .. "ActivityOverviewTime_" .. type
  self:TryInitActViewTimeDic()
  self.actViewTimeDic[type] = serverSec
  CS.GameEntry.Setting:SetInt(strK, serverSec)
  EventManager:GetInstance():Broadcast(EventId.OnOneActivityOverviewRedChange, type)
end

local function TryInitActViewTimeDic(self)
  if not self.actViewTimeDic then
    self.actViewTimeDic = {}
    for i, v in ipairs(self.activityOverviewList) do
      local strK = LuaEntry.Player.uid .. "ActivityOverviewTime_" .. v.type
      local lastTimeS = CS.GameEntry.Setting:GetInt(strK, 0)
      self.actViewTimeDic[v.type] = lastTimeS
    end
  end
end

local function GetOverviewDesc(self, overviewInfo)
  if OverviewToActType[overviewInfo.type] then
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(OverviewToActType[overviewInfo.type])
    local data
    if 0 < #actList then
      local tempId = actList[1].id
      if OverviewToActType[overviewInfo.type] == EnumActivity.RallyBossAct.Type then
        tempId = EnumActivity.RallyBossAct.ActId
      end
      data = DataCenter.ActivityListDataManager:GetActivityDataById(tempId)
    end
    if not data then
      return false, 0, 0, "", ""
    elseif overviewInfo.type == 2 then
      local maxTimes = tonumber(data.para1 or 0)
      local killedNum = DataCenter.MonsterManager:GetKillBossNum()
      local killAddNum = LuaEntry.Effect:GetGameEffect(EffectDefine.AUTO_RALLY_REWARD_NUM_ADD)
      local redCount = DataCenter.AllianceBaseDataManager:CheckIfShowAutoRallyRed()
      maxTimes = math.floor(maxTimes + killAddNum)
      local killed = math.floor(math.max(0, killedNum))
      killed = math.min(maxTimes, killedNum)
      return 0 < redCount, killed, maxTimes, Localization:GetString("372368")
    elseif overviewInfo.type == 3 then
      local orderInfo = DataCenter.ActIndividualOrderManager.orderInfo
      local unfinished = 0
      local showRed = false
      if orderInfo and orderInfo.orderList then
        local extraRed = DataCenter.ActIndividualOrderManager:GetRedDotCount()
        showRed = showRed or 0 < extraRed
        for i, v in ipairs(orderInfo.orderList) do
          if v.state ~= 1 then
            unfinished = unfinished + 1
            local orderTemplate = DataCenter.ActIndividualOrderManager:GetOrderTemplate(v.orderId)
            local resData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(orderTemplate.product_id)
            local haveCount = resData and resData.number or 0
            local canFinish = haveCount >= orderTemplate.product_num
            showRed = showRed or canFinish
          end
        end
        return showRed, #orderInfo.orderList - unfinished, #orderInfo.orderList, Localization:GetString("372367")
      else
        return false, 0, 0, "", ""
      end
    elseif overviewInfo.type == 5 then
      local caveInfo = DataCenter.MineCaveManager:GetMineCaveInfo()
      local tempTimes = 0
      if caveInfo then
        tempTimes = caveInfo.fightNum
      end
      local maxTimes = LuaEntry.DataConfig:TryGetNum("mine_cave", "k3")
      local addNum = LuaEntry.Effect:GetGameEffect(EffectDefine.REFRESH_MINE_CAVE_REFRESH_TIME_ADD)
      maxTimes = math.floor(maxTimes + addNum)
      local remainTimes = math.floor(math.max(0, maxTimes - tempTimes))
      local canAttack, redCount = DataCenter.MineCaveManager:CheckIfCanAttack()
      local canClaim, claimCount = DataCenter.MineCaveManager:CheckIfHasReward()
      local hasRed = canAttack or canClaim
      return hasRed, tempTimes, maxTimes, Localization:GetString("372372")
    elseif overviewInfo.type == 6 then
      local puzzleData = DataCenter.ActivityPuzzleDataManager:GetPuzzleData()
      if puzzleData == nil then
        return false, 0, 0
      end
      local redCount = DataCenter.ActivityListDataManager:GetActivityRedDotCount(data.id)
      return 0 < redCount, puzzleData.taskMaxNum - puzzleData.taskNum, puzzleData.taskMaxNum, Localization:GetString("372371")
    elseif overviewInfo.type == 7 then
      local orderInfo = DataCenter.ActAllianceOrderManager.orderInfo
      if orderInfo then
        return 0 < orderInfo.token, Localization:GetString("372223") .. " " .. orderInfo.token .. "/" .. orderInfo.tokenMax
      else
        return false, "", ""
      end
    elseif overviewInfo.type == 8 then
      local freeTimes = DataCenter.ArenaManager:GetChallengeRedCount()
      local maxChallengeTimes = LuaEntry.DataConfig:TryGetNum("arena", "k2")
      return 0 < freeTimes, maxChallengeTimes - freeTimes, maxChallengeTimes, Localization:GetString("372370")
    end
  elseif overviewInfo.type == 1 then
    local info = DataCenter.EarthOrderDataManager:GetOneEarthOrder()
    if info and not DataCenter.EarthOrderDataManager:IsPreviewStatus() then
      local order = DataCenter.EarthOrderDataManager:GetEarthOrderByUuid(info.uuid)
      local serverTime = UITimeManager:GetInstance():GetServerTime()
      local vipEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_VIP)
      if serverTime >= order.expTime and vipEffect <= 0 then
        return true, 0, 0, "", nil, Localization:GetString("129073")
      else
        local unfinished, canSubmit = DataCenter.EarthOrderDataManager:GetUnfinishedOrderCount()
        return 0 < canSubmit, 9 - unfinished, 9, Localization:GetString("372367")
      end
    elseif DataCenter.BuildManager:HasBuildByIdAndLevel(BuildingTypes.FUN_BUILD_TRADING_CENTER, 1) then
      return false, 9, 9, "", Localization:GetString("372219")
    else
      return false, 0, 0, "", nil, Localization:GetString("372348")
    end
  elseif overviewInfo.type == 4 then
    local isOpenByServer = DataCenter.ActChampionBattleManager:GetEntranceOpenState()
    local championBattleInfo = DataCenter.ActChampionBattleManager:GetChampionBattleInfo()
    if not isOpenByServer then
      return false, 0, 0, "", Localization:GetString("302037")
    elseif championBattleInfo then
      local curIndexState = championBattleInfo:GetCurState()
      if curIndexState == Activity_ChampionBattle_Stage_State.SingUp then
        if championBattleInfo.hasSingUp == 1 then
          return false, 0, 0, "", Localization:GetString("302039")
        elseif championBattleInfo.hasSingUp == 0 then
          return true, 0, 0, "", Localization:GetString("302038")
        elseif championBattleInfo.hasSingUp == -1 then
          return false, 0, 0, "", Localization:GetString("302037")
        end
      elseif championBattleInfo.hasSingUp == 1 then
        return false, 0, 0, "", Localization:GetString("302039")
      else
        return false, 0, 0, "", Localization:GetString("302037")
      end
    end
  elseif overviewInfo.type == 9 then
    local tempState = DataCenter.AdventureManager:GetAdventureState()
    local curNum = (tempState == AdventureState.Won or tempState == AdventureState.Lost) and 1 or 0
    local showRed = curNum == 0
    return showRed, curNum, 1, Localization:GetString("372370")
  elseif overviewInfo.type == 10 then
    local dailyNum = DataCenter.DailyTaskManager:GetRedNum()
    local showRed = 0 < dailyNum
    local curValue = DataCenter.DailyTaskManager:GetCurValue()
    local maxValue = DataCenter.DailyTaskManager:GetDailyMaxValue()
    return showRed, curValue, maxValue, Localization:GetString("372366")
  end
  return false, 0, 0, "", ""
end

local function InitNewUnlockedOverview(self)
  self.newUnlockedOverviewList = {}
  local mainLv = DataCenter.BuildManager.MainLv
  for i, v in ipairs(self.activityOverviewList) do
    if v.unlockLv == mainLv and v.unlockLv > self.cacheDisplayedLv then
      self:AddOneNewUnlockedOverview(v)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.OnDailyActivityNewStatusChange)
end

local function TryUpdateNewUnlockedOverview(buildInfo)
  local self = DataCenter.DailyActivityManager
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildInfo.uuid)
  if buildData and buildData.itemId == BuildingTypes.FUN_BUILD_MAIN and self.cacheDisplayedLv < buildInfo.newLevel then
    self:UpdateNewOverviewList(buildInfo.newLevel)
  end
end

local function UpdateNewOverviewList(self, mainLv)
  mainLv = mainLv or DataCenter.BuildManager.MainLv
  for i, v in ipairs(self.activityOverviewList) do
    if v.unlockLv == mainLv then
      self:AddOneNewUnlockedOverview(v)
      self:TryRequestActivityInfo(v)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.OnDailyActivityNewStatusChange)
end

local function AddOneNewUnlockedOverview(self, overviewTemplate)
  for i, v in ipairs(self.newUnlockedOverviewList) do
    if v.id == overviewTemplate.id then
      return
    end
  end
  table.insert(self.newUnlockedOverviewList, overviewTemplate)
end

local function CheckIfAlreadyDisplayed(self, lv)
  if not self.cacheDisplayedLv then
    local strK = "DailyActivityUnlockDisplay_" .. LuaEntry.Player.uid
    self.cacheDisplayedLv = CS.GameEntry.Setting:GetInt(strK, 0)
  end
  return lv <= self.cacheDisplayedLv
end

local function RemoveOneOverviewFromNew(self, id)
  for i, v in ipairs(self.newUnlockedOverviewList) do
    if v.id == id then
      table.remove(self.newUnlockedOverviewList, i)
      break
    end
  end
end

local function ResetNewStatus(self)
  local lv = DataCenter.BuildManager.MainLv
  local strK = "DailyActivityUnlockDisplay_" .. LuaEntry.Player.uid
  CS.GameEntry.Setting:SetInt(strK, lv)
  self.cacheDisplayedLv = lv
  self.newUnlockedOverviewList = {}
  EventManager:GetInstance():Broadcast(EventId.OnDailyActivityNewStatusChange)
end

local function GetOverviewNewStatus(self)
  if not self.newUnlockedOverviewList then
    self:InitNewUnlockedOverview()
  end
  if #self.newUnlockedOverviewList > 0 then
    return true, self.newUnlockedOverviewList
  else
    return false
  end
end

local function CheckIfOverviewHasNew(self, id)
  if not self.newUnlockedOverviewList then
    return false
  end
  for i, v in ipairs(self.newUnlockedOverviewList) do
    if v.id == id then
      return true
    end
  end
  return false
end

local function OpenDailyActivityView(self)
  local hasNew, overviewList = DataCenter.DailyActivityManager:GetOverviewNewStatus()
  if hasNew then
    for i, v in ipairs(overviewList) do
      local tempIcon = string.format(LoadPath.DailyActivityUnlock, v.unlock_image)
      UIUtil.ShowUnlockWindow(Localization:GetString("372459"), tempIcon, Localization:GetString(v.activityName), UnlockWindowType.Activity)
    end
  else
    self:TryOpenDailyActivity()
  end
end

local function TryOpenDailyActivity(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityOverview, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  })
end

local function TryRequestActivityInfo(self, overviewTemplate)
  if overviewTemplate.type == ActivityOverviewType.EarthOrder then
  elseif overviewTemplate.type == ActivityOverviewType.RallyBossAct then
  elseif overviewTemplate.type == ActivityOverviewType.IndividualOrder then
  elseif overviewTemplate.type == ActivityOverviewType.ChampionBattle then
    SFSNetwork.SendMessage(MsgDefines.ACT_CHAMPIONBATTLE_DATA_REFRESH)
  elseif overviewTemplate.type == ActivityOverviewType.MineCave then
    SFSNetwork.SendMessage(MsgDefines.GetMineCaveInfo)
  elseif overviewTemplate.type == ActivityOverviewType.Puzzle then
    local puzzleList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.Puzzle.Type)
    if puzzleList and 0 < #puzzleList then
      DataCenter.ActivityPuzzleDataManager:SendMessageGetInfo(tostring(puzzleList[1].id))
    end
  elseif overviewTemplate.type == ActivityOverviewType.Arena then
    SFSNetwork.SendMessage(MsgDefines.GetArenaInfo, 0)
  elseif overviewTemplate.type == ActivityOverviewType.Adventure then
  elseif overviewTemplate.type == ActivityOverviewType.EverydayTask then
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

DailyActivityManager.__init = __init
DailyActivityManager.__delete = __delete
DailyActivityManager.AddListener = AddListener
DailyActivityManager.RemoveListener = RemoveListener
DailyActivityManager.InitActivityOverviewList = InitActivityOverviewList
DailyActivityManager.TryUpdateNewUnlockedOverview = TryUpdateNewUnlockedOverview
DailyActivityManager.InitNewUnlockedOverview = InitNewUnlockedOverview
DailyActivityManager.UpdateNewOverviewList = UpdateNewOverviewList
DailyActivityManager.AddOneNewUnlockedOverview = AddOneNewUnlockedOverview
DailyActivityManager.CheckIfAlreadyDisplayed = CheckIfAlreadyDisplayed
DailyActivityManager.ResetNewStatus = ResetNewStatus
DailyActivityManager.GetOverviewNewStatus = GetOverviewNewStatus
DailyActivityManager.CheckIfOverviewHasNew = CheckIfOverviewHasNew
DailyActivityManager.RemoveOneOverviewFromNew = RemoveOneOverviewFromNew
DailyActivityManager.Startup = Startup
DailyActivityManager.OpenDailyActivityView = OpenDailyActivityView
DailyActivityManager.TryRequestActivityInfo = TryRequestActivityInfo
DailyActivityManager.TryOpenDailyActivity = TryOpenDailyActivity
DailyActivityManager.GetActivityOverviewList = GetActivityOverviewList
DailyActivityManager.CheckIfShowActivityOverview = CheckIfShowActivityOverview
DailyActivityManager.CheckIfActIsOpen = CheckIfActIsOpen
DailyActivityManager.GetOverviewTotalRedCount = GetOverviewTotalRedCount
DailyActivityManager.GetOverviewRedCount = GetOverviewRedCount
DailyActivityManager.JumpToActOverview = JumpToActOverview
DailyActivityManager.UpdateActViewHistory = UpdateActViewHistory
DailyActivityManager.TryInitActViewTimeDic = TryInitActViewTimeDic
DailyActivityManager.GetOverviewDesc = GetOverviewDesc
return DailyActivityManager
