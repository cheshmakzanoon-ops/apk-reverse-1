local WorldTrendManager = BaseClass("WorldTrendManager", Singleton)
local WorldTrendDataInfo = require("DataCenter.WorldTrendManager.WorldTrendDataInfo")
local WorldTrendRankDataInfo = require("DataCenter.WorldTrendManager.WorldTrendRankDataInfo")

function WorldTrendManager:__init()
  self.dataInfo = {}
  self.rankInfo = {}
  self.ServerTrendsStatus = {
    DefaultStatus = 0,
    Prepare = 1,
    Ongoing = 2,
    Fail = 3,
    Finish = 4
  }
  self.ServerTrendsRewardStatus = {
    DefaultRewardStatus = 0,
    NotSuccess = 1,
    Unreceived = 2,
    Received = 3,
    NotJoin = 4
  }
  self.redPointNum = 0
  self.curparam = 0
  self.isInitSend = true
  self.NewOngoing = 0
  self:AddListener()
end

function WorldTrendManager:__delete()
  self.dataInfo = nil
  self.rankInfo = nil
  self.ServerTrendsStatus = nil
  self.ServerTrendsRewardStatus = nil
  self.redPointNum = nil
  self.curparam = nil
  self.isInitSend = nil
  self:RemoveListener()
end

function WorldTrendManager:InitData()
  self.isInitSend = true
  self:RequestWorldTrendServerData()
end

function WorldTrendManager:UpdateWorldTrendData(serverData)
  if serverData and serverData.trendsInfo ~= nil then
    self.dataInfo = {}
    local last = Setting:GetPrivateInt(SettingKeys.LAST_WORLD_TREDN, 0)
    local id
    for i, v in ipairs(serverData.trendsInfo) do
      local tempData = WorldTrendDataInfo.New()
      tempData:UpdateDataInfo(v)
      if tempData.status == self.ServerTrendsStatus.Ongoing then
        id = tempData.id
      end
      table.insert(self.dataInfo, tempData)
    end
    if id and tonumber(id) ~= last then
      self.NewOngoing = id
    end
    if self.isInitSend then
      for i = 1, #self.dataInfo do
        if self.dataInfo[i].rewardStatus == self.ServerTrendsRewardStatus.Unreceived or self.dataInfo[i].status == self.ServerTrendsStatus.Ongoing then
          self:PushWorldTrendBubble()
        end
      end
      self.isInitSend = false
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTrend, {anim = true})
  end
end

function WorldTrendManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.MainLvUp, self.PushWorldTrendBubble)
end

function WorldTrendManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.MainLvUp, self.PushWorldTrendBubble)
end

function WorldTrendManager:PushWorldTrendBubble()
  EventManager:GetInstance():Broadcast(EventId.WorldTrendRedUpdate)
end

function WorldTrendManager:GetDataInfo()
  return self.dataInfo
end

function WorldTrendManager:RequestWorldTrendServerData()
  SFSNetwork.SendMessage(MsgDefines.ServerTrendsInfo)
end

function WorldTrendManager:SendServerTrendsReward(id)
  SFSNetwork.SendMessage(MsgDefines.ServerTrendsReward, id)
end

function WorldTrendManager:SetWorldTrendRedNum(message)
  self.redPointNum = message.num
  EventManager:GetInstance():Broadcast(EventId.WorldTrendRedUpdate)
end

function WorldTrendManager:GetWorldTrendRedNum()
  return self.redPointNum
end

function WorldTrendManager:GetBuildIsBubble()
  local data = self:GetDataInfo()
  for i = 1, #data do
    if data[i].levelLimit <= DataCenter.BuildManager.MainLv and data[i].rewardStatus == self.ServerTrendsRewardStatus.Unreceived then
      return true
    end
  end
  return false
end

function WorldTrendManager:ReceiveRewardHandle(message)
  DataCenter.RewardManager:ShowCommonReward(message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  if message.id ~= nil then
    for i = 1, #self.dataInfo do
      if self.dataInfo[i].id == message.id then
        self.dataInfo[i]:UpdateRewardStatus()
        break
      end
    end
    self.redPointNum = self.redPointNum - 1
  end
  EventManager:GetInstance():Broadcast(EventId.WorldTrendUpdate, tonumber(message.id))
  EventManager:GetInstance():Broadcast(EventId.WorldTrendRedUpdate)
end

function WorldTrendManager:SendServerTrendsRank(id)
  SFSNetwork.SendMessage(MsgDefines.ServerTrendsRank, id)
end

function WorldTrendManager:SetParam(id)
  self.curparam = id
end

function WorldTrendManager:GetParam()
  return self.curparam
end

function WorldTrendManager:ReceiveRankData(message)
  if message.rankInfos then
    self.rankInfo = {}
    local info = message.rankInfos
    for i = 1, #info do
      local tempData = WorldTrendRankDataInfo.New()
      tempData:UpdateDataInfo(info[i])
      table.insert(self.rankInfo, tempData)
    end
    if next(message.rankInfos) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTrendRank, {anim = true}, self.rankInfo)
    else
      UIUtil.ShowTipsId(302139)
    end
  end
end

function WorldTrendManager:CheckJumpCell()
  local data = self:GetDataInfo()
  local Unreceived = 0
  local Ongoing = 0
  local Prepare = 0
  local targetIndex = 1
  if next(data) then
    for i = 1, #data do
      if data[i].rewardStatus == self.ServerTrendsRewardStatus.Unreceived then
        Unreceived = i
        break
      end
      if data[i].status == self.ServerTrendsStatus.Ongoing then
        Ongoing = i
        break
      end
      if data[i].status == self.ServerTrendsStatus.Prepare then
        Prepare = i
        break
      end
    end
    if Unreceived ~= 0 then
      targetIndex = Unreceived
    elseif Ongoing ~= 0 then
      targetIndex = Ongoing
    elseif Prepare ~= 0 then
      targetIndex = Prepare
    end
    return targetIndex
  end
  return targetIndex
end

function WorldTrendManager:CheckOpen()
  local configOpenState = LuaEntry.DataConfig:CheckSwitch("worldtrend_switch")
  return configOpenState
end

return WorldTrendManager
