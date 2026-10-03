local WorldNoticeManager = BaseClass("WorldNoticeManager", Singleton)
local WorldNoticeDataInfo = require("DataCenter.WorldNoticeManager.WorldNoticeDataInfo")
local Localization = CS.GameEntry.Localization
local ThumbsUpItem = require("DataCenter.WorldNoticeManager.ThumbsUpItem")

function WorldNoticeManager:__init()
  self.dataList = {}
  self.curUuid = 0
  self:AddListener()
end

function WorldNoticeManager:__delete()
  self.dataList = nil
  self.curUuid = nil
  self:ClearThumbsUp()
  self:RemoveListener()
end

function WorldNoticeManager:InitData()
  SFSNetwork.SendMessage(MsgDefines.GetNoticeList)
end

function WorldNoticeManager:ParseNoticeList(message)
  if message and message.noticeList ~= nil then
    local list = message.noticeList
    for i = 1, table.count(list) do
      local tempData = WorldNoticeDataInfo.New()
      tempData:UpdateDataInfo(list[i])
      table.insert(self.dataList, tempData)
    end
  end
end

function WorldNoticeManager:NewNoticeHandle(message)
  if message then
    local data = message.notice
    local tempData = WorldNoticeDataInfo.New()
    tempData:UpdateDataInfo(data)
    if self.dataList then
      table.insert(self.dataList, tempData)
    else
      self.dataList = {}
      table.insert(self.dataList, tempData)
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshNotice)
  end
end

function WorldNoticeManager:DeleteNoticeHandle(message)
  if self.dataList then
    for i = 1, table.count(self.dataList) do
      if self.dataList[i].noticeId == message.noticeId then
        table.remove(self.dataList, i)
        break
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshNotice)
end

function WorldNoticeManager:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.BeforeLeaveWorld, self.BeforeLeaveWorld, self)
end

function WorldNoticeManager:RemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.BeforeLeaveWorld, self.BeforeLeaveWorld, self)
end

function WorldNoticeManager:PushWorldTrendBubble()
  EventManager:GetInstance():Broadcast(EventId.WorldTrendRedUpdate)
end

function WorldNoticeManager:GetDataInfo()
  return self.dataList
end

function WorldNoticeManager:GetNoticeInfoById(uuid)
  if self.dataList then
    for i = 1, table.count(self.dataList) do
      if self.dataList[i].uuid == uuid then
        return self.dataList[i]
      end
    end
  end
  return nil
end

function WorldNoticeManager:SendReadNotice(uuid)
  SFSNetwork.SendMessage(MsgDefines.ReadNotice, uuid)
end

function WorldNoticeManager:SetCurId(uid)
  self.curUuid = uid
end

function WorldNoticeManager:GetCurId()
  return self.curUuid
end

function WorldNoticeManager:ReadNoticeHandle(message)
  if message then
    for i = 1, table.count(self.dataList) do
      if self.dataList[i].uuid == message.uuid then
        self.dataList[i].status = message.status
      end
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshNotice)
  end
end

function WorldNoticeManager:SendReceiveReward(uuid)
  SFSNetwork.SendMessage(MsgDefines.ReceiceNoticeReward, uuid)
end

function WorldNoticeManager:ReceiveRewardHandle(message)
  if message.reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  for i = 1, table.count(self.dataList) do
    if self.dataList[i].uuid == message.uuid then
      self.dataList[i].rewardStatus = message.rewardStatus
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshNotice)
  EventManager:GetInstance():Broadcast(EventId.NoticeItemReward)
end

function WorldNoticeManager:CheckShow()
  local data = self:GetDataInfo()
  if data then
    for i = 1, table.count(data) do
      if data[i].status == 0 or data[i].rewardStatus == 0 then
        return true
      end
    end
  end
  return false
end

function WorldNoticeManager:CheckNotice()
  local data = self:GetDataInfo()
  if data and table.count(data) > 0 then
    return true
  end
  return false
end

function WorldNoticeManager:ShowThumbsUpBroadcastPopUI(serverId, pointId, sender, text, iconPath, prefabPath, exText)
  if not SceneUtils.GetIsInWorld() then
    return
  end
  if not self.maxShowThumbsUpCount then
    self.thumbsUpDeltaTime = 0.0333
    self.thumbsUpLifeTime = 3000
    self.maxShowThumbsUpCount = InteractiveUtil.GetMaxPopUpPerSecond(InteractiveUtil.ThumbsUpType.CityInfo)
    self.maxShowThumbsUpCount = math.ceil(self.maxShowThumbsUpCount * self.thumbsUpDeltaTime)
    local Queue = require("DataCenter.LWBattle.Logic.Surfing.Queue")
    local Stack = require("Common.Stack")
    self.showThumbsUpQueue = Queue.new()
    self.showThumbsUpStack = Stack.New()
    self.showThumbsUpItemQueue = Queue.new()
    self.showThumbsUpItemStack = Stack.New()
  end
  if self.showThumbsUpQueue:size() >= 10000 then
    return
  end
  local data = self.showThumbsUpStack:Pop() or {}
  data.serverId = serverId
  data.pointId = pointId
  data.sender = sender
  data.text = text
  data.iconPath = iconPath
  data.prefabPath = prefabPath
  data.exText = exText
  self.showThumbsUpQueue:enqueue(data)
  if not self.showThumbsUpTimer then
    self.showThumbsUpTimer = TimerManager:GetInstance():GetTimer(self.thumbsUpDeltaTime, self.OnThumbsUp, self, false, false, false)
    self.showThumbsUpTimer:Start()
  end
  if not self.__world then
    self.__world = CS.SceneManager.World
  end
end

function WorldNoticeManager:OnThumbsUp()
  local count = self.showThumbsUpQueue:size()
  count = math.min(count, self.maxShowThumbsUpCount)
  for i = 1, count do
    local data = self.showThumbsUpQueue:dequeue()
    if data then
      self:ShowThumbsUpBroadcastPopUINow(data.serverId, data.pointId, data.sender, data.text, data.iconPath, data.prefabPath, data.exText)
      self.showThumbsUpStack:Push(data)
    end
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  while self.showThumbsUpItemQueue:size() > 0 do
    local item = self.showThumbsUpItemQueue:peek()
    if not (not item or item:IsFinished(curTime, self.thumbsUpLifeTime)) then
      break
    end
    item = self.showThumbsUpItemQueue:dequeue()
    if item then
      item:SetActive(false)
      self.showThumbsUpItemStack:Push(item)
    end
  end
  if self.showThumbsUpQueue:size() <= 0 and self.showThumbsUpItemQueue:size() <= 0 then
    if self.showThumbsUpTimer then
      self.showThumbsUpTimer:Stop()
      self.showThumbsUpTimer = nil
    end
    while self.showThumbsUpItemStack:Size() > 5 do
      local item = self.showThumbsUpItemStack:Pop()
      if item then
        item:Delete()
      end
    end
  end
end

function WorldNoticeManager:ClearThumbsUp()
  if self.showThumbsUpTimer then
    self.showThumbsUpTimer:Stop()
    self.showThumbsUpTimer = nil
  end
  if self.showThumbsUpQueue then
    self.showThumbsUpQueue:reset()
    self.showThumbsUpStack:Clear()
    while self.showThumbsUpItemQueue:size() > 0 do
      local item = self.showThumbsUpItemQueue:dequeue()
      if item then
        item:Delete()
      end
    end
    self.showThumbsUpItemQueue:reset()
    local list = self.showThumbsUpItemStack.list
    if list then
      for i = 1, #list do
        list[i]:Delete()
      end
    end
    self.showThumbsUpItemStack:Clear()
  end
  self.__world = nil
end

function WorldNoticeManager:BeforeLeaveWorld()
  self:ClearThumbsUp()
end

function WorldNoticeManager:ShowThumbsUpBroadcastPopUINow(serverId, pointId, sender, text, iconPath, prefabPath, exText)
  if text == nil then
    text = Localization:GetString("thumbs_up_nority")
  end
  if iconPath == nil then
    iconPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_gerenxinxi_dianzan.png"
  end
  if serverId == nil or serverId == 0 then
    serverId = LuaEntry.Player:GetCurServerId()
  end
  local item = self.showThumbsUpItemStack:Pop() or ThumbsUpItem.New(self.__world)
  item:OnShow(serverId, pointId, sender, text, iconPath, prefabPath, exText)
  self.showThumbsUpItemQueue:enqueue(item)
end

function WorldNoticeManager:TestThumbsUp(duration, range, countPerSecond, func_)
  if not CS.CommonUtils.IsDebug() then
    return
  end
  local selfPointIndex = LuaEntry.Player:GetMainWorldPos()
  local selfPointTile = SceneUtils.IndexToTilePos(selfPointIndex, ForceChangeScene.World, LuaEntry.Player:GetSelfServerId())
  local sender = {
    abbr = "544",
    chatBubbleET = 0,
    chatBubbleId = 50001,
    country = "UN",
    headPic = "",
    headPicVer = 0,
    name = "7205198023",
    uid = "7205198023000112"
  }
  if self.__showThumbsUpTimer then
    self.__showThumbsUpTimer:Stop()
    self.__showThumbsUpTimer = nil
  end
  func_ = func_ or UIUtil.ShowThumbsUpBroadcastPopUI
  duration = duration or 3
  duration = duration * 1000
  range = range or 5
  self._startTime = UITimeManager:GetInstance():GetServerTime()
  local count = math.ceil(countPerSecond * 0.1)
  
  local function OnThumbsUp()
    for i = 1, count do
      local offsetX = math.random(-range, range)
      local offsetY = math.random(-range, range)
      local targetPointX = selfPointTile.x + offsetX
      local targetPointY = selfPointTile.y + offsetY
      local targetPointIndex = SceneUtils.TileXYToIndex(targetPointX, targetPointY, ForceChangeScene.World)
      func_(LuaEntry.Player:GetCurServerId(), targetPointIndex, sender, nil, nil, nil, nil)
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime - self._startTime >= duration and self.__showThumbsUpTimer then
      self.__showThumbsUpTimer:Stop()
      self.__showThumbsUpTimer = nil
    end
  end
  
  self.__showThumbsUpTimer = TimerManager:GetInstance():GetTimer(0.1, OnThumbsUp, self, false, false, false)
  self.__showThumbsUpTimer:Start()
end

return WorldNoticeManager
