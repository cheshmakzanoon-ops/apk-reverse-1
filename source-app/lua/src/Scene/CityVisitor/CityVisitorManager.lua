local CityVisitorManager = BaseClass("CityVisitorManager", Singleton)
local CallerRecruitWorker = require("Scene.CityVisitor.Visitors.VisitorRecruitWorker")
local VisitorGift = require("Scene.CityVisitor.Visitors.VisitorGift")
local VisitorNotify = require("Scene.CityVisitor.Visitors.VisitorNotify")
local VisitorAllianceInviteMoveCity = require("Scene.CityVisitor.Visitors.VisitorAllianceInviteMoveCity")
local VisitorMerchant = require("Scene.CityVisitor.Visitors.VisitorMerchant")
local VisitorWorkerLottery = require("Scene.CityVisitor.Visitors.VisitorWorkerLottery")
local VisitorOpenPanel = require("Scene.CityVisitor.Visitors.VisitorOpenPanel")
local VisitorData = require("Scene.CityVisitor.VisitorData")
local Const = require("Scene.CityVisitor.Const")
local RewardUtil = require("Util.RewardUtil")
local VisitorActivity = require("Scene.CityVisitor.Visitors.VisitorActivity")
local VisitorAllianceInvite = require("Scene.CityVisitor.Visitors.VisitorAllianceInvite")
local VisitorAllianceCongratulation = require("Scene.CityVisitor.Visitors.VisitorAllianceCongratulation")
local VisitorAdReminder = require("Scene.CityVisitor.Visitors.VisitorAdReminder")
local VisitorS0AllianceBossVisitor = require("Scene.CityVisitor.Visitors.VisitorS0AllianceBossVisitor")
local VisitorProtectCoverNotify = require("Scene.CityVisitor.Visitors.VisitorProtectCoverNotify")
local CallerQueueList = {}
local DeleteList = {}

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.BeforeReleaseCity, self.BeforeReleaseCity)
  EventManager:GetInstance():AddListener(EventId.LOAD_COMPLETE, self.OnEnterCity)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
  EventManager:GetInstance():AddListener(EventId.WorkericRecruitmentData, self.CheckWorkerLotteryVisitorShow)
  EventManager:GetInstance():AddListener(EventId.ChatPinUpdate, self.OnChatPinUpdate)
  EventManager:GetInstance():AddListener(ChatEventEnum.CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess)
  EventManager:GetInstance():AddListener(EventId.OnUnDelayPassDay, self.OnPassDay)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.BeforeReleaseCity, self.BeforeReleaseCity)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
  EventManager:GetInstance():RemoveListener(EventId.LOAD_COMPLETE, self.OnEnterCity)
  EventManager:GetInstance():RemoveListener(EventId.WorkericRecruitmentData, self.CheckWorkerLotteryVisitorShow)
  EventManager:GetInstance():RemoveListener(EventId.ChatPinUpdate, self.OnChatPinUpdate)
  EventManager:GetInstance():RemoveListener(ChatEventEnum.CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess)
  EventManager:GetInstance():RemoveListener(EventId.OnUnDelayPassDay, self.OnPassDay)
end

local function BeforeReleaseCity()
  DataCenter.CityVisitorManager:DeleteAllVisitorModel()
  DataCenter.CityVisitorManager:ReleaseData()
end

local function OnEnterCity()
  if not SceneUtils.GetIsInCity() then
    return
  end
  DataCenter.CityVisitorManager:StartCreateVisitor()
  DataCenter.InnerCityMapManager:GetCityDoorManager():ClearCount()
  DataCenter.CityVisitorManager:CheckProtectCoverVisitorShow()
end

local function OnScienceQueueFinishSignal()
  DataCenter.CityVisitorManager:StartCreateVisitor()
end

local function OnPassDay()
  local self = DataCenter.CityVisitorManager
  local visitorUid = self:GetProtectCoverVisitorUid()
  if visitorUid == nil then
    return
  end
  self:FinishVisitorByUid(visitorUid)
end

local function InitData(self)
  self.isCreteaIng = false
  self.maxNum = nil
  self.requestLists = {}
  self.lastShowTime = 0
  for i, type in pairs(Const.VisitorQueueType) do
    CallerQueueList[type] = {}
    CallerQueueList[type].isCreateing = false
    CallerQueueList[type].list = {}
  end
  self.workerLotteryVisitorCheckTimer = nil
end

local function __init(self)
  InitData(self)
  AddListeners(self)
end

local function __delete(self)
  if self.delay then
    self.delay:Stop()
  end
  DataCenter.CityVisitorManager:DeleteAllVisitorModel()
  CallerQueueList = nil
  self.isCreteaIng = nil
  self.maxNum = nil
  self.delay = nil
  self.requestLists = nil
  self.allianceCongratulations = nil
  self.allianceCongratulationsCount = nil
  self.lastShowTime = nil
  self.playMap = nil
  self:ClearProtectCoverVisitorData()
  RemoveListener(self)
end

local function GetVisitorClass(type)
  local classType = tonumber(type)
  if classType == VisitorType.RECRUITMENT or classType == VisitorType.DOMINATOR_COCKATRICE then
    return CallerRecruitWorker
  elseif classType == VisitorType.MERCHANT then
    return VisitorMerchant
  elseif classType == VisitorType.GIFT or classType == VisitorType.DOMINATOR or classType == VisitorType.SeasonDayGift or classType == VisitorType.SKY_BATTLE or classType == VisitorType.PLANE_FEATURE or classType == VisitorType.SURVIVOR_PACK_GiFT then
    return VisitorGift
  elseif classType == VisitorType.WORKER_LOTTERY then
    return VisitorWorkerLottery
  elseif classType == VisitorType.OPEN_PANEL then
    return VisitorOpenPanel
  elseif classType == VisitorType.NOTIFY then
    return VisitorNotify
  elseif classType == VisitorType.ALLIANCE_INVITE_MOVE_CITY then
    return VisitorAllianceInviteMoveCity
  elseif classType == VisitorType.VisitorActivity then
    return VisitorActivity
  elseif classType == VisitorType.ALLIANCE_INVITE then
    return VisitorAllianceInvite
  elseif classType == VisitorType.AllianceCongratulation then
    return VisitorAllianceCongratulation
  elseif classType == VisitorType.AD_REMINDER then
    return VisitorAdReminder
  elseif classType == VisitorType.S0_ALLIANCE_BOSS then
    return VisitorS0AllianceBossVisitor
  elseif classType == VisitorType.ProtectCoverVisitor then
    return VisitorProtectCoverNotify
  end
end

local function GeteVisitorByUid(uid, type)
  local visitors = CallerQueueList[Const.VisitorTypeToQueue[type]].list
  if 0 < #visitors then
    for i = 1, #visitors do
      if visitors[i].data.uid == uid then
        return visitors[i]
      end
    end
  end
end

local function GetVisitorByEventId(eventId, type)
  local visitors = CallerQueueList[Const.VisitorTypeToQueue[type]].list
  if 0 < #visitors then
    for i = 1, #visitors do
      if visitors[i].data.eventId == eventId then
        return visitors[i]
      end
    end
  end
end

local function GetAllVisitorCount()
  local sum = 0
  for i, type in pairs(Const.VisitorQueueType) do
    local visitors = CallerQueueList[type].list
    for j, visitor in pairs(visitors) do
      if visitor and visitor.model and visitor.model.isFinish == false and visitor.data.eventType ~= VisitorType.WORKER_LOTTERY then
        sum = sum + 1
      end
    end
  end
  return sum
end

local function GetFrontCount(uid, type)
  local visitors = CallerQueueList[Const.VisitorTypeToQueue[type]].list
  if 0 < #visitors then
    for i = 1, #visitors do
      if visitors[i].data.uid == uid then
        return i - 1
      end
    end
  end
end

local function GetNewVisitorInfo(self)
  local visitorIsOpen = true
  local isLastShow
  local visitors = CallerQueueList[Const.VisitorTypeToQueue[Const.VisitorType.GEN_BY_TIME]].list
  if 0 < #visitors then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= visitors[#visitors].data.startTime then
      isLastShow = true
    end
  else
    isLastShow = true
  end
  if not self.maxNum then
    return
  end
  if visitorIsOpen and #visitors < self.maxNum and isLastShow and LuaEntry.Effect:GetGameEffect(EffectDefine.VISITOR_EVENT_FUNCTION_OPEN) >= 1 then
    SFSNetwork.SendMessage(MsgDefines.VisitorFreshMessage)
  end
end

local function GetCreateState(type, index)
  local list = CallerQueueList[Const.VisitorTypeToQueue[type]]
  if 1 < #list and list[#list].model and list[1].model and list[#list].model.isCreate and list[1].model.isCreate then
    return false
  else
    return true
  end
end

local function StartCreateVisitorByType(self, type, index)
  if not SceneUtils.GetIsInCity() then
    return
  end
  if self.isDelete then
    return
  end
  index = index and index or 0
  local visitors = CallerQueueList[Const.VisitorTypeToQueue[type]].list
  if index < #visitors then
    CallerQueueList[Const.VisitorTypeToQueue[type]].isCreateing = true
    index = index + 1
    local randomTime = math.random(1, 2)
    if not visitors[index].model then
      local Class = GetVisitorClass(visitors[index].data.eventType)
      if Class then
        local visitorModel = Class.New()
        visitorModel:UpdateVisitorData(visitors[index].data)
        visitors[index].model = visitorModel
        visitors[index].model:StartCaller(function()
          EventManager:GetInstance():Broadcast(EventId.RefreshVisitorBtnState, true)
          local delay = TimerManager:GetInstance():DelayInvoke(function()
            if CallerQueueList[Const.VisitorTypeToQueue[type]].isCreateing then
              StartCreateVisitorByType(self, type, index)
            end
          end, randomTime)
          self.delay = delay
        end)
      end
    else
      StartCreateVisitorByType(self, type, index)
    end
  else
    CallerQueueList[Const.VisitorTypeToQueue[type]].isCreateing = false
    if type == Const.VisitorType.GEN_BY_TIME then
      GetNewVisitorInfo(self)
    end
  end
end

local function AddVisitor(self, message, isInit, targetInsertPos)
  if message.uid then
    local visitor
    local data = GeteVisitorByUid(message.uid, message.type)
    if data and data.data then
      data.data:UpdateInfo(message)
    else
      local visitorData = VisitorData.New()
      visitorData:UpdateInfo(message)
      if not visitorData.line then
        return
      end
      if visitorData.eventType == VisitorType.AllianceCongratulation then
        DataCenter.CityVisitorManager:AddAllianceCongratulationVisitorList(message.uid)
        if DataCenter.CityVisitorManager:GetAllianceCongratulationVisitorListCount() > 5 then
          return
        end
      end
      local visitors = CallerQueueList[Const.VisitorTypeToQueue[visitorData.type]]
      visitor = {data = visitorData}
      if targetInsertPos then
        table.insert(visitors.list, targetInsertPos, visitor)
      else
        table.insert(visitors.list, visitor)
      end
      if visitorData.type == Const.VisitorType.GEN_BY_TIME then
      end
      if not isInit and not visitors.isCreateing and CS.SceneManager:IsInCity() then
        StartCreateVisitorByType(self, visitorData.type)
      end
    end
  end
end

local function CreateClientVisitor(eventId, uuid)
  local startTime = UITimeManager:GetInstance():GetServerTime()
  return {
    uid = uuid and uuid or eventId + 100000000,
    eventId = eventId,
    startTime = startTime,
    visitorId = eventId + 100000000,
    type = Const.VisitorType.GEN_BY_TIME
  }
end

local function GetNotifyVisitor()
  if CS.GameEntry.Sdk:GetIsNotifyOpen() then
    return
  end
  if DataCenter.BuildManager.MainLv < 6 then
    return
  end
  local lastClickTime = CommonUtil.PlayerPrefsGetLong("LATEST_NOTIFY_TIME_KEY", 0)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime - lastClickTime < 601200000 then
    return
  end
  return CreateClientVisitor(6001)
end

local function GetAllianceInviteMoveCityVisitor(self)
  local _chatRoomManager = ChatInterface.getRoomMgr()
  if _chatRoomManager:HasAllianceRoom() then
    local allianceRoomData = _chatRoomManager:GetAllianceRoomData()
    local pinDatas = DataCenter.LWChatPinManager:GetAllPinData(allianceRoomData)
    for k, v in pairs(pinDatas) do
      if v.type == ChatPinMessageType.AllianceGatherMember then
        return CreateClientVisitor(8001, v.uuid)
      end
    end
  end
end

local function GetClientVistors()
  local list = {}
  local notifyVisitor = GetNotifyVisitor()
  if notifyVisitor then
    table.insert(list, notifyVisitor)
  end
  return list
end

local function InitData(self, message)
  self.RemoveNotExistVisitor(self, message)
  local serverVistors = {}
  local clientVistors = GetClientVistors()
  if message.visitor then
    local data = message.visitor
    self.maxNum = data.maxNum
    serverVistors = data.list or {}
  end
  table.insertto(serverVistors, clientVistors)
  table.sort(serverVistors, function(a, b)
    return a.startTime < b.startTime
  end)
  for i, v in pairs(serverVistors) do
    AddVisitor(self, v, true)
  end
end

local function RemoveNotExistVisitor(self, message)
  local curVisitorsFromServer = {}
  local allNeedDeleteVisitors = {}
  if message.visitor then
    local data = message.visitor
    for i, vData in pairs(data.list) do
      if vData.uid then
        table.insert(curVisitorsFromServer, vData.uid)
      end
    end
  end
  local clientVistors = GetClientVistors()
  for i, vData in pairs(clientVistors) do
    if vData.uid then
      table.insert(curVisitorsFromServer, vData.uid)
    end
  end
  if self.showProtectCoverVisitorUid then
    table.insert(curVisitorsFromServer, self.showProtectCoverVisitorUid)
  end
  for i, type in pairs(Const.VisitorQueueType) do
    local visitorFromClient = CallerQueueList[type].list
    for j, visitor in pairs(visitorFromClient) do
      if visitor ~= nil and visitor.data ~= nil and visitor.data.uid then
        local isExist4Server = table.hasvalue(curVisitorsFromServer, visitor.data.uid)
        if not isExist4Server then
          table.insert(allNeedDeleteVisitors, visitor)
        end
      end
    end
  end
  if 0 < #allNeedDeleteVisitors then
    for i, visitor in pairs(allNeedDeleteVisitors) do
      local uid = visitor.data.uid
      local type = visitor.data.type
      self.PlayVisitorFinishAni(self, uid, type)
    end
  end
end

local function ShowReward(info)
  local model, data
  local visitors = CallerQueueList[Const.VisitorTypeToQueue[info.visitorType]].list
  if 0 < #visitors then
    for i = 1, #visitors do
      if visitors[i].data.uid == info.uid then
        model = visitors[i].model
        data = visitors[i].data
      end
    end
  end
  if model == nil then
    return
  end
  if data and data.eventType == VisitorType.SeasonDayGift then
    DataCenter.RewardManager:ShowCommonReward(info)
  end
  local showPos = CS.CSUtils.WorldPositionToUISpacePosition(model.transform.position)
  local rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(info.reward) or {}
  for i, v in ipairs(rewardList) do
    local rewardType = v.rewardType
    local itemId = v.itemId
    local count = 3
    if v.count and 0 < v.count then
      count = math.min(count, v.count)
    end
    local pic = RewardUtil.GetPic(rewardType, itemId)
    if pic ~= "" then
      UIUtil.DoFly(tonumber(rewardType), count, pic, showPos, Vector3.New(0, 0, 0), nil, nil, nil, nil, 1)
    end
  end
end

local function FinishVisitor(self, info)
  if info.operate == 1 and info.reward then
    ShowReward(info)
  end
  local uid = info.uid
  local visitorType = info.visitorType
  local operate = info.operate
  self.PlayVisitorFinishAni(self, uid, visitorType, operate)
end

local function FinishVisitorByUid(self, uid)
  local visitorType
  for i, v in pairs(Const.VisitorType) do
    local visitor = GeteVisitorByUid(uid, v)
    if visitor then
      visitorType = v
      break
    end
  end
  if visitorType then
    self.PlayVisitorFinishAni(self, uid, visitorType, 1)
  end
end

local function PlayVisitorFinishAni(self, uid, visitorType, operate)
  if not CS.SceneManager:IsInCity() then
    self:DeleteVisitor(uid, visitorType)
    return
  end
  local findTarget = false
  local visitors = CallerQueueList[Const.VisitorTypeToQueue[visitorType]].list
  local index = #visitors
  for i = 1, #visitors do
    if visitors[i] and visitors[i].data.uid == uid then
      index = i
      findTarget = true
    end
    if i > index and visitors[i].model and visitors[i].model.endPos then
      local sendpos = Vector3.New(tonumber(visitors[i].model.curendPos.x), visitors[i].model.curendPos.y, visitors[i].model.curendPos.z + Const.queueDistance)
      visitors[i].model:SetTargetEndPos({
        [1] = sendpos
      })
    end
  end
  if findTarget and visitors[index] and visitors[index].model then
    visitors[index].model:OnVisitorFinishTrigger()
    visitors[index].model:FinishVisitor(operate)
  end
  if findTarget and visitors[index] and visitors[index].model == nil and visitorType == Const.VisitorType.ProtectCoverVisitor then
    self:DeleteVisitor(uid, visitorType)
  end
end

local function DeleteAllVisitorModel(self)
  self.isDelete = true
  for i, v in pairs(CallerQueueList) do
    for i = 1, #v.list do
      if v.list[i].model then
        v.list[i].model:Delete()
        v.list[i].model = nil
      end
    end
  end
  for i, v in pairs(DeleteList) do
    v:Delete()
  end
  DeleteList = {}
  if self.delay then
    self.delay:Stop()
  end
  self.isCreteaIng = false
  EventManager:GetInstance():Broadcast(EventId.RefreshVisitorBtnState, false)
end

local function DeleteVisitor(self, uid, type)
  local visitors = CallerQueueList[Const.VisitorTypeToQueue[type]].list
  local index = GetFrontCount(uid, type)
  DeleteList[uid] = visitors[index + 1].model
  visitors[index + 1].data:Delete()
  table.remove(visitors, index + 1)
  if visitors[1] == nil or visitors[1].model == nil or visitors[1].model.isCreate == nil then
    EventManager:GetInstance():Broadcast(EventId.RefreshVisitorBtnState, false)
  end
  if type == Const.VisitorType.ProtectCoverVisitor and uid == self.showProtectCoverVisitorUid then
    self.showProtectCoverVisitorUid = nil
  end
  GetNewVisitorInfo(self)
  return #DeleteList
end

local function GetFristVisitorData(self, type)
  if type then
    local quque = Const.VisitorTypeToQueue[type]
    local visitors = CallerQueueList[quque].list
    if 0 < #visitors then
      if quque == 1 then
        local data
        for i = 1, #visitors do
          data = v.list[i].data
          if data and not self:JudgeVisitorsIsWaiting(data) then
            return visitors[i].data
          end
        end
      end
      return visitors[1].data
    end
  else
    for i, v in pairs(CallerQueueList) do
      if i == 1 then
        local data
        for i = 1, #v.list do
          data = v.list[i].data
          if data and not self:JudgeVisitorsIsWaiting(data) then
            return v.list[i].data
          end
        end
      elseif v.list[1] then
        return v.list[1].data
      end
    end
  end
end

local function JudgeVisitorsIsWaiting(self, data)
  if data then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local delay = data.startTime - curTime
    return 0 < delay
  end
end

local function RemoveDeleteCacheListToUid(uid)
  if DeleteList[uid] then
    DeleteList[uid]:Delete()
    DeleteList[uid] = nil
  end
end

local function HasWorkerToRecuit()
  for i, infoList in pairs(CallerQueueList) do
    if infoList and infoList.list and infoList.list[2] and infoList.list[2].model and infoList.list[2].model.isCreate and infoList.list[2].data.workerData and infoList.list[2].data.workerData.source == "VISITOR_RECRUIT" then
      return true
    end
  end
end

local function GetIsCreateVisitorModel()
  for i, infoList in pairs(CallerQueueList) do
    if infoList and infoList.list and infoList.list[1] and infoList.list[1].model and infoList.list[1].model.isCreate then
      return true
    end
  end
end

local function StartCreateVisitor(self)
  if CS.SceneManager:IsInCity() then
    self.isDelete = false
    for i, v in pairs(Const.VisitorType) do
      StartCreateVisitorByType(self, v)
    end
  end
end

local function GetNextVisitor(self, visitorData)
  local visitors = CallerQueueList[Const.VisitorTypeToQueue[visitorData.type]].list
  if 1 < #visitors then
    for i = 1, #visitors do
      if visitors[i].data.uid == visitorData.uid and visitors[i + 1] and visitors[i + 1].model and visitors[i + 1].model.isCreate then
        return visitors[i + 1].model
      end
    end
  end
end

function CityVisitorManager:OnEnterGame()
  self:GetNewVisitorInfo()
  DataCenter.ClientCityVisitorManager:ShowAllianceInviteVisitor()
end

function CityVisitorManager:GetQueueAllVisitorData(queueType)
  local visitors = CallerQueueList[queueType].list
  return visitors
end

local function GetQueueVisitorCount(self, queueType)
  local sum = 0
  local visitors = CallerQueueList[queueType].list
  sum = #visitors
  return sum
end

function CityVisitorManager.OnChatLoginSuccess()
  SFSNetwork.SendMessage(MsgDefines.ChatAskAllianceGatherMessage)
end

function CityVisitorManager.OnChatPinUpdate()
  local visitor = DataCenter.CityVisitorManager:GetAllianceInviteMoveCityVisitor()
  if visitor and not GetVisitorByEventId(8001, visitor.type) then
    DataCenter.CityVisitorManager:AddVisitor(visitor, false)
  end
end

function CityVisitorManager.CheckWorkerLotteryVisitorShow()
  if not CS.SceneManager:IsInCity() then
    return
  end
  local self = DataCenter.CityVisitorManager
  if self.workerLotteryVisitorCheckTimer == nil then
    self.workerLotteryVisitorCheckTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.workerLotteryVisitorCheckTimer = nil
      local oldItemId = LuaEntry.DataConfig:TryGetNum("worker_recruit_1", "k3", 0)
      local itemId = DataCenter.LotteryDataManager:GetOnlyWorkerLotteryCostItemId() or oldItemId
      if 0 < itemId then
        local curNum = DataCenter.ItemData:GetItemCount(itemId)
        local allVisitorData = self:GetQueueAllVisitorData(Const.VisitorTypeToQueue[Const.VisitorType.WORKER_LOTTERY])
        if curNum <= 0 then
          for k, v in ipairs(allVisitorData) do
            if v.data.type == Const.VisitorType.WORKER_LOTTERY then
              SFSNetwork.SendMessage(MsgDefines.VisitorOperateMessage, v.data.uid, 1)
              break
            end
          end
        else
        end
      end
    end, 3)
  end
end

function CityVisitorManager:CreateOneFakeVisitorDataByEventId(eventId, fakeUid)
  if not fakeUid then
    return nil
  end
  local line = LocalController:instance():getLine(TableName.City_Visitor, eventId)
  if not line then
    return nil
  end
  local fakeData = {}
  fakeData.uid = fakeUid
  fakeData.type = line.type
  fakeData.eventId = eventId
  fakeData.startTime = UITimeManager:GetInstance():GetServerTime()
  return fakeData
end

local function ReGenVisitors()
  if SceneUtils.GetIsInCity() then
    DataCenter.CityVisitorManager:DeleteAllVisitorModel()
    DataCenter.CityVisitorManager:StartCreateVisitor()
    DataCenter.InnerCityMapManager:GetCityDoorManager():ClearCount()
  end
end

local function TryAddVisitor(self, visitor, isInit)
  if visitor and not GetVisitorByEventId(visitor.eventId, visitor.type) then
    DataCenter.CityVisitorManager:AddVisitor(visitor, isInit)
    return true
  end
  return false
end

function CityVisitorManager:SaveAnimalTrigger(type, trigger)
  if self.playMap == nil then
    self.playMap = {}
  end
  if self.playMap[type] == nil then
    self.playMap[type] = {}
  end
  table.insert(self.playMap[type], trigger)
end

function CityVisitorManager:PlayAnimalTrigger(type)
  if self.playMap == nil or self.playMap[type] == nil then
    return
  end
  for i, value in ipairs(self.playMap[type]) do
    if value then
      value()
    end
  end
  self.playMap[type] = nil
end

function CityVisitorManager:RequestShow(child, time)
  self.requestLists = self.requestLists or {}
  table.insert(self.requestLists, child)
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.requestLists and #self.requestLists > 0 and now - self.lastShowTime > time * 1000 then
    local index = math.random(1, #self.requestLists)
    local fn = self.requestLists[index]
    if fn then
      fn()
    end
    self.requestLists = {}
    self.lastShowTime = UITimeManager:GetInstance():GetServerTime()
  end
end

function CityVisitorManager:ReleaseData()
  self.requestLists = nil
  self.playMap = nil
end

function CityVisitorManager:AddAllianceCongratulationVisitorList(uid)
  self.allianceCongratulations = self.allianceCongratulations or {}
  self.allianceCongratulationsCount = self.allianceCongratulationsCount or 0
  if not self.allianceCongratulations[uid] then
    self.allianceCongratulations[uid] = true
    self.allianceCongratulationsCount = self.allianceCongratulationsCount + 1
  end
end

function CityVisitorManager:RemoveAllianceCongratulationVisitorList(uid)
  if self.allianceCongratulations and self.allianceCongratulations[uid] and self.allianceCongratulationsCount then
    self.allianceCongratulations[uid] = nil
    self.allianceCongratulationsCount = self.allianceCongratulationsCount - 1
  end
end

function CityVisitorManager:GetAllianceCongratulationVisitorListCount()
  return self.allianceCongratulationsCount or 0
end

function CityVisitorManager:GetProtectCoverVisitorId()
  if self.protectCoverVisitorId == nil then
    self.protectCoverVisitorId = LuaEntry.DataConfig:TryGetNum("friday_popup", "k1")
  end
  return self.protectCoverVisitorId
end

function CityVisitorManager:GetProtectCoverVisitorUid()
  if self.protectCoverVisitorUid == nil then
    local visitorId = self:GetProtectCoverVisitorId()
    if visitorId then
      self.protectCoverVisitorUid = visitorId + 100000000
    end
  end
  return self.protectCoverVisitorUid
end

function CityVisitorManager:ClearProtectCoverVisitorData()
  self.protectCoverVisitorId = nil
  self.protectCoverVisitorUid = nil
  self.protectCoverShowStartDate = nil
  self.protectCoverShowEndDate = nil
  self.showProtectCoverVisitorUid = nil
end

function CityVisitorManager:CheckShowValidDate()
  if self.protectCoverShowStartDate == nil then
    self.protectCoverShowStartDate = {}
    local startStr = LuaEntry.DataConfig:TryGetStr("friday_popup", "k2")
    if not string.IsNullOrEmpty(startStr) then
      local strArr = string.split(startStr, "|")
      for i = 1, #strArr do
        table.insert(self.protectCoverShowStartDate, tonumber(strArr[i]))
      end
    end
  end
  if self.protectCoverShowEndDate == nil then
    self.protectCoverShowEndDate = {}
    local endStr = LuaEntry.DataConfig:TryGetStr("friday_popup", "k3")
    if not string.IsNullOrEmpty(endStr) then
      local strArr2 = string.split(endStr, "|")
      for i = 1, #strArr2 do
        table.insert(self.protectCoverShowEndDate, tonumber(strArr2[i]))
      end
    end
  end
  local curSeason = SeasonUtil.GetSeason()
  local curSeasonDay = SeasonUtil.GetSeasonDay()
  local isStart, isEnd = false, true
  if self.protectCoverShowStartDate and #self.protectCoverShowStartDate == 2 then
    isStart = curSeason > self.protectCoverShowStartDate[1] or self.protectCoverShowStartDate[1] == curSeason and curSeasonDay >= self.protectCoverShowStartDate[2]
  end
  if self.protectCoverShowEndDate and #self.protectCoverShowEndDate == 2 then
    isEnd = curSeason > self.protectCoverShowEndDate[1] or self.protectCoverShowEndDate[1] == curSeason and curSeasonDay > self.protectCoverShowEndDate[2]
  end
  return isStart and not isEnd
end

function CityVisitorManager:CheckProtectCoverVisitorShow()
  if not CS.SceneManager:IsInCity() then
    return
  end
  local isFunctionOnNewPopupStyle = DataCenter.LWPopupManager:IsFunctionOnNewPopupStyle()
  if not isFunctionOnNewPopupStyle then
    return
  end
  local isValidDate = self:CheckShowValidDate()
  if not isValidDate then
    return
  end
  if not DataCenter.AllianceCompeteDataManager:CheckShowProtectCoverPopup() then
    return
  end
  local visitorId = self:GetProtectCoverVisitorId()
  if visitorId == nil then
    return nil
  end
  local visitorUid = self:GetProtectCoverVisitorUid()
  if visitorUid == nil then
    return
  end
  local visitorData = self:CreateOneFakeVisitorDataByEventId(visitorId, visitorUid)
  if visitorData then
    self.showProtectCoverVisitorUid = visitorUid
    self:TryAddVisitor(visitorData, false)
  end
end

CityVisitorManager.__init = __init
CityVisitorManager.__delete = __delete
CityVisitorManager.InitData = InitData
CityVisitorManager.GetFrontCount = GetFrontCount
CityVisitorManager.AddVisitor = AddVisitor
CityVisitorManager.GetFristVisitorData = GetFristVisitorData
CityVisitorManager.FinishVisitor = FinishVisitor
CityVisitorManager.FinishVisitorByUid = FinishVisitorByUid
CityVisitorManager.StartCreateVisitorByType = StartCreateVisitorByType
CityVisitorManager.DeleteAllVisitorModel = DeleteAllVisitorModel
CityVisitorManager.DeleteVisitor = DeleteVisitor
CityVisitorManager.OnEnterCity = OnEnterCity
CityVisitorManager.GetIsCreateVisitorModel = GetIsCreateVisitorModel
CityVisitorManager.OnScienceQueueFinishSignal = OnScienceQueueFinishSignal
CityVisitorManager.JudgeVisitorsIsWaiting = JudgeVisitorsIsWaiting
CityVisitorManager.RemoveDeleteCacheListToUid = RemoveDeleteCacheListToUid
CityVisitorManager.BeforeReleaseCity = BeforeReleaseCity
CityVisitorManager.StartCreateVisitor = StartCreateVisitor
CityVisitorManager.GetNewVisitorInfo = GetNewVisitorInfo
CityVisitorManager.GetNextVisitor = GetNextVisitor
CityVisitorManager.GetAllVisitorCount = GetAllVisitorCount
CityVisitorManager.GetQueueVisitorCount = GetQueueVisitorCount
CityVisitorManager.RemoveNotExistVisitor = RemoveNotExistVisitor
CityVisitorManager.PlayVisitorFinishAni = PlayVisitorFinishAni
CityVisitorManager.ReGenVisitors = ReGenVisitors
CityVisitorManager.GetAllianceInviteMoveCityVisitor = GetAllianceInviteMoveCityVisitor
CityVisitorManager.TryAddVisitor = TryAddVisitor
CityVisitorManager.HasWorkerToRecuit = HasWorkerToRecuit
CityVisitorManager.GetVisitorByEventId = GetVisitorByEventId
CityVisitorManager.CreateClientVisitor = CreateClientVisitor
CityVisitorManager.OnPassDay = OnPassDay
return CityVisitorManager
