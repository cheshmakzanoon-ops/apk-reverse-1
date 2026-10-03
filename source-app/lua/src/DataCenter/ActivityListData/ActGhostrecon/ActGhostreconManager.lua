local ActGhostreconManager = BaseClass("ActGhostreconManager")
local ActGhostreconTaskInfo = require("DataCenter.ActivityListData.ActGhostrecon.ActGhostreconTaskInfo")
local ActGhostreconMemberInfo = require("DataCenter.ActivityListData.ActGhostrecon.ActGhostreconMemberInfo")
local ActGhostreconTaskTemplate = require("DataCenter.ActivityListData.ActGhostrecon.ActGhostreconTaskTemplate")
local ActGhostreconSettingTemplate = require("DataCenter.ActivityListData.ActGhostrecon.ActGhostreconSettingTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.teamworkRewardTimes = 0
  self.stealTimes = 0
  self.dispatchBeginTime = 0
  self.dispatchEndTime = 0
  self.allianceTeamRedPoint = 0
  self.taskList = nil
  self.templates = {}
  self.openTime = nil
  self.settingList = nil
  self.isTriggerGuide = nil
  self.autoStart = nil
  self.dispatchStealRange = nil
  EventManager:GetInstance():AddListener(EventId.OnPassWeek, self.OnPassWeek)
end

local function __delete(self)
  self.teamworkRewardTimes = nil
  self.stealTimes = nil
  self.dispatchBeginTime = nil
  self.dispatchEndTime = nil
  self.allianceTeamRedPoint = nil
  self.taskList = nil
  self.templates = nil
  self.openTime = nil
  self.settingList = nil
  self.isTriggerGuide = nil
  self.autoStart = nil
  self.dispatchStealRange = nil
  EventManager:GetInstance():RemoveListener(EventId.OnPassWeek, self.OnPassWeek)
end

local function OnPassWeek()
  SFSNetwork.SendMessage(MsgDefines.GetServerStealRangeList)
end

function ActGhostreconManager:OnStealRangeUpdate(payload)
  if payload == nil then
    return
  end
  self.dispatchStealRange = {}
  if payload.dispatchStealRange then
    for _, v in ipairs(payload.dispatchStealRange) do
      self.dispatchStealRange[v] = true
    end
  end
  EventManager:GetInstance():Broadcast(EventId.DispatchStealRangeUpdate)
end

local function InitData(self, msg)
  self.teamworkRewardTimes = msg.teamworkRewardTimes or 0
  self.stealTimes = msg.stealTimes or 0
  self.dispatchStealRange = {}
  if msg.dispatchStealRange then
    for _, v in ipairs(msg.dispatchStealRange) do
      self.dispatchStealRange[v] = true
    end
  end
end

local function GhostreconGetTaskListHandler(self, msg)
  if msg == nil then
    return
  end
  if msg.openTime then
    self.dispatchBeginTime = msg.dispatchBeginTime
    self.dispatchEndTime = msg.dispatchEndTime
    self.openTime = msg.openTime
    self.allianceTeamRedPoint = msg.allianceTeamRedPoint
    self:GhostReconSetAutoStartHandler(msg.autoStart)
    if msg.taskList then
      self.taskList = {}
      for index, value in ipairs(msg.taskList) do
        local taskInfo = ActGhostreconTaskInfo.New()
        taskInfo:ParseData(value, true)
        table.insert(self.taskList, taskInfo)
      end
    else
      self.taskList = nil
    end
    self:InitBubblePosInfos()
    EventManager:GetInstance():Broadcast(EventId.GhostreconTaskRefreshAll)
    EventManager:GetInstance():Broadcast(EventId.GhostreconRefreshRedPoint)
  end
end

local function GhostReconPutPointInWorldHandler(self, msg)
  if msg == nil then
    return
  end
  local taskInfo = self:GetTaskInfoByUUid(msg.uuid)
  if taskInfo then
    taskInfo:ParseData(msg)
    EventManager:GetInstance():Broadcast(EventId.GhostreconTaskPutPointInWorld, msg.uuid)
  end
end

local function GhostReconJoinTeamHandler(self, msg)
  if msg == nil then
    return
  end
  if msg.type == 1 then
    local taskInfo = self:GetTaskInfoByUUid(msg.info.uuid)
    if taskInfo then
      taskInfo:ParseData(msg.info)
    end
    self:ShareOwnGhostreconTask(taskInfo.uuid)
  elseif msg.type == 2 or msg.type == 3 then
    if self.taskList == nil then
      self.taskList = {}
    end
    local taskInfo = ActGhostreconTaskInfo.New()
    taskInfo:ParseData(msg.info)
    table.insert(self.taskList, taskInfo)
    DataCenter.ActGhostreconBubblePosManager:AddPointByUUid(taskInfo.uuid)
    DataCenter.ActGhostreconBubblePosManager:SaveBubblePosInfos()
    local poolIndex, bubbleIndex = DataCenter.ActGhostreconBubblePosManager:GetPointByUUid(taskInfo.uuid)
    local data = {}
    data.uuid = msg.info.uuid
    data.type = 1
    data.poolIndex = poolIndex
    data.bubbleIndex = bubbleIndex
    EventManager:GetInstance():Broadcast(EventId.GhostreconRefreshOneTask, data)
  end
  if msg.teamworkRewardTimes then
    self.teamworkRewardTimes = msg.teamworkRewardTimes
  end
end

local function GhostReconHandleSendChatHandler(self, msg)
  if msg == nil then
    return
  end
  local taskInfo = self:GetTaskInfoByUUid(msg.uuid)
  if taskInfo and msg.sendChatTime then
    taskInfo.sendChatTime = msg.sendChatTime
  end
end

local function GhostReconRemindStartTeamHandler(self, msg)
  if msg == nil then
    return
  end
  local taskInfo = self:GetTaskInfoByUUid(msg.uuid)
  if taskInfo and msg.remindTime then
    taskInfo.remindTime = msg.remindTime
  end
end

local function GhostReconStartTeamMessageHandler(self, msg)
  local taskInfo = self:GetTaskInfoByUUid(msg.uuid)
  if taskInfo then
    taskInfo:ParseData(msg)
    local poolIndex, bubbleIndex = DataCenter.ActGhostreconBubblePosManager:GetPointByUUid(taskInfo.uuid)
    local data = {}
    data.uuid = taskInfo.uuid
    data.type = 2
    data.poolIndex = poolIndex
    data.bubbleIndex = bubbleIndex
    EventManager:GetInstance():Broadcast(EventId.GhostreconRefreshOneTask, data)
    local memberList = {}
    for index, value in ipairs(taskInfo.memberList) do
      table.insert(memberList, value.memberInfo)
    end
    DataCenter.ActGhostreconAnimManager:ShowPointAnim(taskInfo.uuid, memberList, true, taskInfo.ownerServer)
  end
end

local function GhostReconDisbandTeamHandler(self, msg)
  if msg == nil then
    return
  end
  local taskInfo = self:GetTaskInfoByUUid(msg.uuid)
  if taskInfo then
    taskInfo:ParseData(msg)
    local poolIndex, bubbleIndex = DataCenter.ActGhostreconBubblePosManager:GetPointByUUid(taskInfo.uuid)
    local data = {}
    data.uuid = taskInfo.uuid
    data.type = 2
    data.poolIndex = poolIndex
    data.bubbleIndex = bubbleIndex
    EventManager:GetInstance():Broadcast(EventId.GhostreconRefreshOneTask, data)
  end
end

local function GhostReconStealHandler(self, msg)
  if msg == nil then
    return
  end
  if msg.stealTimes then
    self.stealTimes = msg.stealTimes
  end
  if msg.reward then
    self:ShowReward(msg)
  end
end

local function GhostReconRewardHandler(self, msg)
  if msg.memberList == nil or table.count(msg.memberList) == 0 then
    if msg.reward == nil or table.count(msg.reward) == 0 then
      UIUtil.ShowTipsId("ghostrecon_033")
    end
    EventManager:GetInstance():Broadcast(EventId.GhostreconRefreshRedPoint)
    return
  end
  if msg.reward == nil or table.count(msg.reward) == 0 then
    UIUtil.ShowTipsId("ghostrecon_033")
  else
    self:ShowReward(msg)
  end
  EventManager:GetInstance():Broadcast(EventId.GhostreconRefreshRedPoint)
end

local function PushGhostReconTaskToTeamMemberHandler(self, msg)
  if msg == nil then
    return
  end
  local taskInfo = self:GetTaskInfoByUUid(msg.info.uuid)
  if taskInfo then
    taskInfo:ParseData(msg.info)
    local poolIndex, bubbleIndex = DataCenter.ActGhostreconBubblePosManager:GetPointByUUid(taskInfo.uuid)
    local data = {}
    data.uuid = taskInfo.uuid
    data.type = 2
    data.poolIndex = poolIndex
    data.bubbleIndex = bubbleIndex
    EventManager:GetInstance():Broadcast(EventId.GhostreconRefreshOneTask, data)
    if not string.IsNullOrEmpty(msg.action) and msg.action == "start" then
      local memberList = {}
      for index, value in ipairs(taskInfo.memberList) do
        table.insert(memberList, value.memberInfo)
      end
      DataCenter.ActGhostreconAnimManager:ShowPointAnim(taskInfo.uuid, memberList, true, taskInfo.ownerServer)
    end
  end
end

local function PushGhostReconBeKickedHandler(self, msg)
  if msg == nil then
    return
  end
  for index, value in ipairs(msg.uuidList) do
    local index = self:GetTaskIndexByUUid(value)
    local removeInfo
    if index then
      removeInfo = table.remove(self.taskList, index)
    end
    local poolIndex, bubbleIndex = DataCenter.ActGhostreconBubblePosManager:GetPointByUUid(value)
    DataCenter.ActGhostreconBubblePosManager:RemovePointByUUid(value)
    local data = {}
    data.uuid = value
    data.type = 3
    data.poolIndex = poolIndex
    data.bubbleIndex = bubbleIndex
    EventManager:GetInstance():Broadcast(EventId.GhostreconRefreshOneTask, data)
    if removeInfo and msg.type == 4 then
      UIUtil.ShowTips(Localization:GetString("ghostrecon_062", removeInfo:GetLeaderMemberInfo().memberInfo.name))
    end
  end
  DataCenter.ActGhostreconBubblePosManager:SaveBubblePosInfos()
  if msg.teamworkRewardTimes then
    self.teamworkRewardTimes = msg.teamworkRewardTimes
  end
  EventManager:GetInstance():Broadcast(EventId.GhostreconRefreshRedPoint)
  if not self:IsOpenDay() and #self.taskList == 0 then
    EventManager:GetInstance():Broadcast(EventId.GhostreconTaskRefreshAll)
  end
end

local function PushGhostReconDayRefreshHandler(self, msg)
  self.teamworkRewardTimes = msg.teamworkRewardTimes or 0
  self.stealTimes = msg.stealTimes or 0
  EventManager:GetInstance():Broadcast(EventId.GhostreconTaskDayRefresh)
end

local function GhostReconKickMemberHandler(self, msg)
  local taskInfo = self:GetTaskInfoByUUid(msg.uuid)
  if taskInfo then
    taskInfo:ParseData(msg)
    local poolIndex, bubbleIndex = DataCenter.ActGhostreconBubblePosManager:GetPointByUUid(taskInfo.uuid)
    local data = {}
    data.uuid = taskInfo.uuid
    data.type = 2
    data.poolIndex = poolIndex
    data.bubbleIndex = bubbleIndex
    EventManager:GetInstance():Broadcast(EventId.GhostreconRefreshOneTask, data)
  end
end

local function PushGhostReconBroadcastRewardHandler(self, msg)
  local memberList = {}
  table.insert(memberList, msg.memberInfo)
  DataCenter.ActGhostreconAnimManager:ShowPointAnim(msg.uuid, memberList, false, msg.ownerServer)
end

local function GhostReconSetAutoStartHandler(self, autoStart)
  if autoStart then
    self.autoStart = autoStart == 1
  else
    self.autoStart = nil
  end
  EventManager:GetInstance():Broadcast(EventId.GhostReconSetAutoStart)
end

local function GetTaskInfoByUUid(self, uuid)
  local taskInfo
  if self.taskList then
    for index, value in ipairs(self.taskList) do
      if value.uuid == uuid then
        taskInfo = value
        break
      end
    end
  end
  return taskInfo
end

local function GetTaskIndexByUUid(self, uuid)
  local taskIndex
  if self.taskList then
    for index, value in ipairs(self.taskList) do
      if value.uuid == uuid then
        taskIndex = index
        break
      end
    end
  end
  return taskIndex
end

local function ShowReward(self, msg)
  if msg.reward then
    local list = {}
    list = DataCenter.RewardManager:ReturnRewardParamForMessage(msg.reward) or {}
    table.sort(list, function(a, b)
      if a.rewardType ~= b.rewardType then
        return a.rewardType == RewardType.HERO and true or false
      else
        return a.sortOrder < b.sortOrder
      end
    end)
    local golloesList = DataCenter.RewardManager:GetGolloesRewards(msg)
    for i, v in ipairs(golloesList) do
      table.insert(list, v)
    end
    local superRewardList = {}
    if msg.superReward then
      superRewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(msg.superReward) or {}
      table.sort(list, function(a, b)
        if a.rewardType ~= b.rewardType then
          return a.rewardType == RewardType.HERO and true or false
        else
          return a.sortOrder < b.sortOrder
        end
      end)
      local golloesList = DataCenter.RewardManager:GetGolloesRewards(msg)
      for i, v in ipairs(golloesList) do
        table.insert(superRewardList, v)
      end
      for index, value in ipairs(superRewardList) do
        value.superReward = true
      end
    end
    local memberList = {}
    if msg.memberList then
      for _, member in ipairs(msg.memberList) do
        if member.uid ~= LuaEntry.Player.uid then
          table.insert(memberList, member)
        end
      end
    end
    table.insertto(superRewardList, list)
    local param = {}
    param.rewardList = superRewardList
    param.memberList = memberList
    param.stealList = msg.stealList
    param.data = msg.data
    param.fromGhostreconStealMessage = msg.fromGhostreconStealMessage
    param.ownerInfo = msg.ownerInfo
    param.recordUuid = msg.recordUuid
    param.completeByHelper = msg.completeByHelper
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
    
    local function openRewardWindow()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconReward, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, param)
    end
    
    if not table.IsNullOrEmpty(list) then
      for i, v in pairs(list) do
        if v and v.rewardType == RewardType.HERO and v.heroUuid and DataCenter.HeroDataManager:NeedShowNewHeroWindow(v.heroUuid) then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, v.heroUuid, {
            v.heroUuid
          }, openRewardWindow, true)
          return
        end
      end
    end
    openRewardWindow()
  end
end

local function GetTaskTemplate(self, cfgId)
  if self.templates[cfgId] then
    return self.templates[cfgId]
  end
  local cfg = LocalController:instance():getLine(TableName.LwGhostreconTask, cfgId)
  local template = ActGhostreconTaskTemplate.New()
  template:InitData(cfg)
  self.templates[cfgId] = template
  return template
end

local function InitBubblePosInfos(self)
  local taskUUids = {}
  if self.taskList then
    for index, value in ipairs(self.taskList) do
      taskUUids[value.uuid] = 1
    end
  end
  DataCenter.ActGhostreconBubblePosManager:LoadBubblePosInfos(taskUUids)
end

local function GetTeamworkRewardTimesFull(self)
  return self.teamworkRewardTimes >= self:GetNowSettingCfg().teamworkCount
end

local function GetTeamworkRewardTimesText(self)
  return Localization:GetString("ghostrecon_002") .. " " .. DataCenter.ActGhostreconManager.teamworkRewardTimes .. "/" .. self:GetNowSettingCfg().teamworkCount
end

local function GetStealTimesFull(self)
  return self.stealTimes >= self:GetNowSettingCfg().stealCount
end

local function GetPointStealType(self, cfgId, completionTime, stealList)
  local cfg = self:GetTaskTemplate(cfgId)
  local stealType = GhostreconPointStealType.UnShow
  local stealTimes = table.length(stealList)
  local ownStealed = false
  if 0 < stealTimes then
    for index, value in ipairs(stealList) do
      if value.uuid == LuaEntry.player.uuid then
        ownStealed = true
        break
      end
    end
  end
  if cfg:CheckCanSteal(completionTime) then
    if stealTimes >= cfg.stealMaxtimes or self:GetStealTimesFull() or ownStealed then
      stealType = GhostreconPointStealType.UnSteal
    else
      stealType = GhostreconPointStealType.CanSteal
    end
  elseif cfg:CheckCanShow(completionTime) then
    stealType = GhostreconPointStealType.Preview
  else
    stealType = GhostreconPointStealType.UnShow
  end
  return stealType
end

local function GetNowSettingCfg(self)
  if self.settingList == nil then
    self.settingList = {}
    LocalController:instance():visitTable(TableName.LwGhostreconSetting, function(id, lineData)
      local template = ActGhostreconSettingTemplate.New()
      template:InitData(lineData)
      table.insert(self.settingList, template)
    end)
  end
  local settingCfg
  for index, value in ipairs(self.settingList) do
    if value:CheckInInterval() then
      settingCfg = value
      break
    end
  end
  return settingCfg
end

local function IsOpenDay(self)
  local isOpneDay = false
  if self.openTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    isOpneDay = UITimeManager:GetInstance():IsSameDayForServer(now // 1000, self.openTime // 1000)
  end
  return isOpneDay
end

local function OpenWindowByTaskData(self, taskInfo)
  local cfg = self:GetTaskTemplate(taskInfo.cfgId)
  if taskInfo.bubbleType == GhostreconTaskType.Own_NotExecuted then
    local now = UITimeManager:GetInstance():GetServerTime()
    local diffTime = self.dispatchBeginTime - now
    if 0 < diffTime then
      UIUtil.ShowSecondMessage("", Localization:GetString("ghostrecon_036", UITimeManager:GetInstance():MilliSecondToFmtString(diffTime)), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, nil, nil, nil, nil, nil, nil, nil, nil, nil, false)
    elseif cfg:HaveSuperReward() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconTaskSpecialBegin, {anim = true}, taskInfo.uuid)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconTaskNormalBegin, {anim = true}, taskInfo.uuid)
    end
  elseif taskInfo.bubbleType == GhostreconTaskType.Own_TeamingUp or taskInfo.bubbleType == GhostreconTaskType.Alliance_TeamingUp then
    if cfg:HaveSuperReward() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconTeamUpSpecial, {anim = true}, taskInfo.uuid)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconTeamUpNormal, {anim = true}, taskInfo.uuid)
    end
  elseif taskInfo.bubbleType == GhostreconTaskType.Own_Runing or taskInfo.bubbleType == GhostreconTaskType.Alliance_Runing then
    if cfg:HaveSuperReward() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconTaskSpecialRuning, {anim = true}, taskInfo.uuid)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconTaskNormalRuning, {anim = true}, taskInfo.uuid)
    end
  elseif taskInfo.bubbleType == GhostreconTaskType.Own_WaitClaim or taskInfo.bubbleType == GhostreconTaskType.Alliance_WaitClaim then
    local uuidList = {}
    for index, value in ipairs(self.taskList) do
      if value.bubbleType == GhostreconTaskType.Own_WaitClaim or value.bubbleType == GhostreconTaskType.Alliance_WaitClaim then
        table.insert(uuidList, value.uuid)
      end
    end
    if 0 < #uuidList then
      SFSNetwork.SendMessage(MsgDefines.GhostReconBatchReward, uuidList, LuaEntry.Player:GetSourceServerId())
    end
  end
end

local function GetAllLogList(self)
  if self.recordList then
    table.sort(self.recordList, function(a, b)
      return a.time > b.time
    end)
    return self.recordList
  end
  return {}
end

local function HandleRecord(self, message)
  if message.array then
    self.recordList = message.array
  else
    self.recordList = {}
  end
  EventManager:GetInstance():Broadcast(EventId.GhostreconGetRecord)
end

local function GetAllUsedHeroList(self)
  local ret = {}
  local uuidRet = {}
  for k, v in pairs(self.taskList) do
    if v.teamStartTime > 0 and v:GetOwnMemberInfo() and v:GetOwnMemberInfo().rewarded == 0 then
      for index, value in ipairs(v:GetOwnMemberInfo().heroList) do
        table.insert(ret, value.heroId)
        table.insert(uuidRet, value.uuid)
      end
    end
  end
  return ret, uuidRet
end

local function GetTeamName(self, leaderName)
  return Localization:GetString("ghostrecon_024", leaderName)
end

local function ShareOwnGhostreconTask(self, uuid)
  if string.IsNullOrEmpty(LuaEntry.Player.allianceId) then
    UIUtil.ShowSecondMessage("", Localization:GetString("ghostrecon_050"), 2, "ghostrecon_btn10", "ghostrecon_btn11", function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {
        guide = false,
        tipStr = Localization:GetString("ghostrecon_050")
      })
    end, nil, nil, nil, nil, nil, nil, nil, nil, false)
  else
    local taskInfo = self:GetTaskInfoByUUid(uuid)
    local cdTime = LuaEntry.DataConfig:TryGetNum("ghostrecon_config", "k1", 5) * 1000 - UITimeManager:GetInstance():GetServerTime() - taskInfo.sendChatTime
    if cdTime <= 0 then
      local shareParam = {}
      shareParam.post = PostType.GHOST_RECON_TASK_TEAM
      shareParam.sid = LuaEntry.Player:GetSelfServerId()
      shareParam.taskUUid = uuid
      shareParam.closeTipText = Localization:GetString("ghostrecon_067")
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
    else
      UIUtil.ShowTips(Localization:GetString("ghostrecon_057", UITimeManager:GetInstance():MilliSecondToFmtString(cdTime)))
    end
  end
end

local function GetTeamMaxMemberNum(self)
  return 5
end

local function JumpToPoint(self, pointId, uuid, targetServer)
  local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
  GoToUtil.CloseAllWindows()
  GoToUtil.GotoWorldPos(pos, nil, nil, function()
    local worldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, targetServer or LuaEntry.Player:GetSelfServerId())
    DataCenter.ActGhostreconAnimManager:ShowWorldFingerArrow(Vector3.New(worldPos.x + 1, worldPos.y, worldPos.z - 1), Vector3.New(0.7, 0.7, 0.7), 2, uuid)
  end, targetServer)
end

local function GetTotalRedCount(self)
  local count = 0
  if self.taskList then
    local now = UITimeManager:GetInstance():GetServerTime()
    for index, value in ipairs(self.taskList) do
      if value.bubbleType == GhostreconTaskType.Own_WaitClaim or value.bubbleType == GhostreconTaskType.Alliance_WaitClaim or (value.bubbleType == GhostreconTaskType.Own_NotExecuted or value.bubbleType == GhostreconTaskType.Own_TeamingUp) and now >= self.dispatchBeginTime and now < self.dispatchEndTime then
        count = count + 1
      end
    end
  end
  return count
end

local function GetMainBtnRedPoint(self)
  return self:GetTotalRedCount()
end

local function GetDayFirstIn(self)
  local needShow = false
  local now = UITimeManager:GetInstance():GetServerTime()
  if self:IsOpenDay() and now >= self.dispatchBeginTime and now < self.dispatchEndTime then
    needShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.NoClickGhostreconEnterTip)
  end
  return needShow
end

local function HaveOwnMemberFullTask(self)
  local have = false
  local now = UITimeManager:GetInstance():GetServerTime()
  if self:IsOpenDay() and now >= self.dispatchBeginTime and now < self.dispatchEndTime and self.taskList and #self.taskList > 0 then
    for index, value in ipairs(self.taskList) do
      if value.bubbleType == GhostreconTaskType.Own_TeamingUp and value:MemberIsFull() then
        have = true
        break
      end
    end
  end
  return have
end

local function GetTipShowState(self)
  local state = GhostreconEnterTipState.None
  if self:GetDayFirstIn() then
    state = GhostreconEnterTipState.FirstIn
  elseif self:HaveOwnMemberFullTask() then
    state = GhostreconEnterTipState.MemberFull
  end
  return state
end

local function GetNeedShowGuide(self)
  local actData = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.Ghostrecon.Type)
  local actId
  local isTrigger = false
  local now = UITimeManager:GetInstance():GetServerTime()
  if self:IsOpenDay() and now >= self.dispatchBeginTime and now < self.dispatchEndTime and actData and actData[1] then
    isTrigger = CommonUtil.PlayerPrefsGetBool(SettingKeys.TRIGGER_GHOSTRECON_GUIDE, true)
    actId = actData[1].activityId
  end
  return isTrigger, actId
end

local function SaveFinshedGuide(self)
  CommonUtil.PlayerPrefsSetBool(SettingKeys.TRIGGER_GHOSTRECON_GUIDE, false)
end

local function SetTriggerGuide(self, isTrigger)
  self.isTriggerGuide = isTrigger
end

local function GetPlotId(self, index)
  local plot
  local plotStr = LuaEntry.DataConfig:TryGetStr("ghostrecon_config", "k4")
  if not string.IsNullOrEmpty(plotStr) then
    local plots = string.split(plotStr, ";")
    if index == 1 then
      plot = tonumber(plots[1])
    elseif index == 2 then
      plot = tonumber(plots[2])
    end
  end
  return plot
end

function ActGhostreconManager:IsCanGetTheReward(ownerServer)
  if not table.IsNullOrEmpty(self.dispatchStealRange) then
    return self.dispatchStealRange[ownerServer]
  end
  return false
end

ActGhostreconManager.__init = __init
ActGhostreconManager.__delete = __delete
ActGhostreconManager.InitData = InitData
ActGhostreconManager.GhostreconGetTaskListHandler = GhostreconGetTaskListHandler
ActGhostreconManager.GhostReconJoinTeamHandler = GhostReconJoinTeamHandler
ActGhostreconManager.GhostReconPutPointInWorldHandler = GhostReconPutPointInWorldHandler
ActGhostreconManager.GhostReconHandleSendChatHandler = GhostReconHandleSendChatHandler
ActGhostreconManager.GhostReconRemindStartTeamHandler = GhostReconRemindStartTeamHandler
ActGhostreconManager.GhostReconStartTeamMessageHandler = GhostReconStartTeamMessageHandler
ActGhostreconManager.GhostReconDisbandTeamHandler = GhostReconDisbandTeamHandler
ActGhostreconManager.GhostReconStealHandler = GhostReconStealHandler
ActGhostreconManager.GhostReconRewardHandler = GhostReconRewardHandler
ActGhostreconManager.PushGhostReconTaskToTeamMemberHandler = PushGhostReconTaskToTeamMemberHandler
ActGhostreconManager.PushGhostReconBeKickedHandler = PushGhostReconBeKickedHandler
ActGhostreconManager.PushGhostReconDayRefreshHandler = PushGhostReconDayRefreshHandler
ActGhostreconManager.GhostReconKickMemberHandler = GhostReconKickMemberHandler
ActGhostreconManager.PushGhostReconBroadcastRewardHandler = PushGhostReconBroadcastRewardHandler
ActGhostreconManager.GhostReconSetAutoStartHandler = GhostReconSetAutoStartHandler
ActGhostreconManager.GetTaskInfoByUUid = GetTaskInfoByUUid
ActGhostreconManager.GetTaskIndexByUUid = GetTaskIndexByUUid
ActGhostreconManager.ShowReward = ShowReward
ActGhostreconManager.GetTaskTemplate = GetTaskTemplate
ActGhostreconManager.InitBubblePosInfos = InitBubblePosInfos
ActGhostreconManager.GetTeamworkRewardTimesFull = GetTeamworkRewardTimesFull
ActGhostreconManager.GetStealTimesFull = GetStealTimesFull
ActGhostreconManager.GetTeamworkRewardTimesText = GetTeamworkRewardTimesText
ActGhostreconManager.GetNowSettingCfg = GetNowSettingCfg
ActGhostreconManager.IsOpenDay = IsOpenDay
ActGhostreconManager.OpenWindowByTaskData = OpenWindowByTaskData
ActGhostreconManager.GetPointStealType = GetPointStealType
ActGhostreconManager.GetAllLogList = GetAllLogList
ActGhostreconManager.HandleRecord = HandleRecord
ActGhostreconManager.GetAllUsedHeroList = GetAllUsedHeroList
ActGhostreconManager.GetTeamName = GetTeamName
ActGhostreconManager.ShareOwnGhostreconTask = ShareOwnGhostreconTask
ActGhostreconManager.GetTeamMaxMemberNum = GetTeamMaxMemberNum
ActGhostreconManager.JumpToPoint = JumpToPoint
ActGhostreconManager.GetTotalRedCount = GetTotalRedCount
ActGhostreconManager.GetMainBtnRedPoint = GetMainBtnRedPoint
ActGhostreconManager.GetDayFirstIn = GetDayFirstIn
ActGhostreconManager.GetNeedShowGuide = GetNeedShowGuide
ActGhostreconManager.SaveFinshedGuide = SaveFinshedGuide
ActGhostreconManager.SetTriggerGuide = SetTriggerGuide
ActGhostreconManager.GetPlotId = GetPlotId
ActGhostreconManager.HaveOwnMemberFullTask = HaveOwnMemberFullTask
ActGhostreconManager.GetTipShowState = GetTipShowState
ActGhostreconManager.OnPassWeek = OnPassWeek
return ActGhostreconManager
