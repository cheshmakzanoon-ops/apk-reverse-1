local SeasonSuppliesShareDataManager = BaseClass("SeasonSuppliesShareDataManager")
local Localization = CS.GameEntry.Localization
local WorldChargeData = require("DataCenter.WorldPointDetail.WorldChargeData")

function SeasonSuppliesShareDataManager:__init()
  self.activityId = nil
  self.shareInfo = nil
  self.discovererList = nil
  self:AddListener()
end

function SeasonSuppliesShareDataManager:__delete()
  self:RemoveListener()
  self.shareInfo = nil
end

function SeasonSuppliesShareDataManager:Init()
  if not self:IsActive() then
    return
  end
  self:GetActivityInfo(true)
end

function SeasonSuppliesShareDataManager:Startup()
end

function SeasonSuppliesShareDataManager:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.DiscoverSuppliesInfo, self.DiscoverSuppliesInfo, self)
end

function SeasonSuppliesShareDataManager:RemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.DiscoverSuppliesInfo, self.DiscoverSuppliesInfo, self)
end

function SeasonSuppliesShareDataManager:InitData(data)
  self.activityId = data.id
  self:Init()
end

function SeasonSuppliesShareDataManager:IsActive(includePrepare)
  return SeasonUtil.IsSeasonActivityOpen(self.activityId, nil, includePrepare, true)
end

function SeasonSuppliesShareDataManager:UpdateInfo(msg)
  if self.shareInfo == nil then
    self.shareInfo = {}
    self.shareInfo.rewardCount = 0
    self.shareInfo.remainData = {}
    self.shareInfo.suppliesPointData = {}
  end
  if msg then
    if msg.newRewardMax and msg.newRewardCount and 0 < msg.newRewardMax then
      self.shareInfo.rewardMax = msg.newRewardMax
      self.shareInfo.rewardLeftCount = msg.newRewardCount
      self.shareInfo.rewardCount = msg.newRewardMax - msg.newRewardCount
    else
      self.shareInfo.rewardCount = msg.user_reward_count
      self.shareInfo.rewardLeftCount = nil
      self.shareInfo.rewardMax = self:GetCountLimit()
    end
    if msg.remainData then
      local remainData, totalNum = {}, 0
      for i, v in ipairs(msg.remainData) do
        local tData = {}
        tData.level = v.level
        tData.count = v.num
        totalNum = totalNum + v.num
        remainData[i] = tData
      end
      table.sort(remainData, function(a, b)
        return a.level > b.level
      end)
      remainData.totalNum = totalNum
      self.shareInfo.remainData = remainData
    else
      self.shareInfo.remainData = {}
    end
    if msg.share_ice_supplies then
      local suppliesPointData = {}
      for index, value in ipairs(msg.share_ice_supplies) do
        if DataCenter.SeasonDataManager:IsInBattleServerGroup(value.suppliesPointData.server) then
          local data = {}
          data.state = value.state
          data.uid = value.senderInfo.uid
          data.playerServerid = value.senderInfo.server
          data.userName = value.senderInfo.name
          data.pic = value.senderInfo.pic
          data.picver = value.senderInfo.picver
          data.headSkinId = value.senderInfo.headSkinId
          data.headSkinET = value.senderInfo.headSkinET
          local suppliesData = value.suppliesPointData
          data.configId = suppliesData.configId
          data.progress = suppliesData.progress
          data.pointId = suppliesData.pontId
          data.pointServerid = suppliesData.server
          if suppliesData.chargeStartTime or suppliesData.battery then
            data.shareTime = value.shareTime
            data.chargeData = WorldChargeData.New()
            data.chargeData:ParseData(suppliesData)
          end
          local configData = LocalController:instance():getLine(TableName.LWIceSupplies, data.configId)
          data.level = configData and configData.level or 0
          suppliesPointData[index] = data
        end
      end
      table.sort(suppliesPointData, function(a, b)
        if a.state ~= b.state then
          return a.state < b.state
        end
        if a.level ~= b.level then
          return a.level > b.level
        end
        if a.progress ~= b.progress then
          return a.progress < b.progress
        end
        if a.shareTime ~= b.shareTime then
          return a.shareTime > b.shareTime
        end
        return false
      end)
      self.shareInfo.suppliesPointData = suppliesPointData
    else
      self.shareInfo.suppliesPointData = {}
    end
  end
  EventManager:GetInstance():Broadcast(EventId.GetActivitySuppliesShareInfoEvent)
end

function SeasonSuppliesShareDataManager:GetActivityInfo(sendMsg)
  if sendMsg then
    SFSNetwork.SendMessage(MsgDefines.GetActivitySuppliesShareInfo)
  end
  return self.shareInfo
end

function SeasonSuppliesShareDataManager:GetCountLimit()
  if self.countLimit == nil then
    self.countLimit = 0
    local seasonConfig = DataCenter.SeasonDataManager:GetServerCurrentSeasonConfig()
    if seasonConfig then
      local t = string.split(seasonConfig.lw_supplies_refresh, "|")
      if t and 2 < #t then
        self.countLimit = toInt(t[3])
      end
    end
  end
  return self.countLimit
end

function SeasonSuppliesShareDataManager:GetSuppliesRefreshCount()
  if self.refreshCount == nil then
    self.refreshCount = 0
    self.refreshLimit = 0
    local seasonConfig = DataCenter.SeasonDataManager:GetServerCurrentSeasonConfig()
    if seasonConfig then
      local t = string.split(seasonConfig.supplies_para, "|")
      if t then
        self.refreshCount = t[1] and toInt(t[1]) or 0
        self.refreshLimit = t[2] and toInt(t[2]) or 0
      end
    end
  end
  return self.refreshCount, self.refreshLimit
end

function SeasonSuppliesShareDataManager:DiscoverSuppliesInfo(oneData)
  if not self.discovererList then
    self.discovererList = {}
  end
  table.insert(self.discovererList, oneData)
end

return SeasonSuppliesShareDataManager
