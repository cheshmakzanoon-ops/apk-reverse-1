local AllianceCongratulationDataManager = BaseClass("AllianceCongratulationDataManager")
local RewardUtil = require("Util.RewardUtil")

local function __init(self)
  self.thumbsMap = {}
  self.fixedTime = -1
  self.bubbleContents = {}
  self.isAllianceCongratulationPop = nil
  self.popInfo = nil
  self.headIndexList = {}
  self.congratulationList = nil
  self.remainRewardCount = 0
  self.maxRewardCount = nil
  self.flyCenter = nil
  self.allianceId = ""
  EventManager:GetInstance():AddListener(EventId.GF_enter_city, self.PlayPopInfo)
  EventManager:GetInstance():AddListener(EventId.GF_enter_world, self.PlayPopInfo)
  EventManager:GetInstance():AddListener(EventId.AllianceBaseDataUpdated, self.RefreshAllianceCongratulation)
end

local function __delete(self)
  self.headInfoByUidList = nil
  self.headIndexList = nil
  self.thumbsMap = nil
  self.fixedTime = nil
  self.congratulationList = nil
  self.bubbleContents = nil
  self.isAllianceCongratulationPop = nil
  self.popInfo = nil
  self.flowId = nil
  self.bubblePopContents = nil
  if self.delayPop then
    self.delayPop:Stop()
    self.delayPop = nil
  end
  self.remainRewardCount = nil
  self.flyCenter = nil
  self.allianceId = nil
  EventManager:GetInstance():RemoveListener(EventId.GF_enter_city, self.PlayPopInfo)
  EventManager:GetInstance():RemoveListener(EventId.GF_enter_world, self.PlayPopInfo)
  EventManager:GetInstance():RemoveListener(EventId.AllianceBaseDataUpdated, self.RefreshAllianceCongratulation)
end

function AllianceCongratulationDataManager:SendAllianceCongratulationThumbsUp(targetUid, configId)
  SFSNetwork.SendMessage(MsgDefines.AllianceCongratulationThumbsUp, targetUid, tostring(configId), 1)
end

function AllianceCongratulationDataManager:GetAllianceCongratulationGainThumbsUpCount(targetUid, configId)
  SFSNetwork.SendMessage(MsgDefines.AllianceCongratulationGainThumbsUpCount, targetUid, tostring(configId))
end

function AllianceCongratulationDataManager:SendGetAllianceCongratulationList()
  SFSNetwork.SendMessage(MsgDefines.AllianceCongratulationGainCongratulationList)
end

function AllianceCongratulationDataManager:SaveAllianceCongratulationList(message)
  self.congratulationList = message.congratulationList
  if not table.IsNullOrEmpty(self.congratulationList) then
    table.sort(self.congratulationList, function(a, b)
      return a.expireTimeStamp < b.expireTimeStamp
    end)
  end
  local count = tonumber(message.count) or 0
  self:UpdateRemainRewardCount(count)
  EventManager:GetInstance():Broadcast(EventId.AllianceCongratulationListNew)
end

function AllianceCongratulationDataManager:RefreshAllianceCongratulation()
  if DataCenter.AllianceCongratulationDataManager.allianceId == LuaEntry.Player:GetAllianceUid() then
    return
  end
  DataCenter.AllianceCongratulationDataManager.allianceId = LuaEntry.Player:GetAllianceUid()
  if LuaEntry.Player:IsInAlliance() then
    DataCenter.AllianceCongratulationDataManager:SendGetAllianceCongratulationList()
  else
    DataCenter.AllianceCongratulationDataManager.congratulationList = {}
    EventManager:GetInstance():Broadcast(EventId.AllianceCongratulationListNew)
  end
end

function AllianceCongratulationDataManager:UpdateRemainRewardCount(value)
  self.remainRewardCount = value
  EventManager:GetInstance():Broadcast(EventId.AllianceCongratulationCount)
end

function AllianceCongratulationDataManager:GetRemainRewardCount()
  return self.remainRewardCount
end

function AllianceCongratulationDataManager:SaveThumbsUpInfo(message)
  local targetUid = message.targetUid
  local configId = message.configId
  if self.thumbsMap == nil then
    self.thumbsMap = {}
  end
  if self.thumbsMap[targetUid] and self.thumbsMap[targetUid][configId] then
    self.thumbsMap[targetUid][configId].count = message.count
    self.thumbsMap[targetUid][configId].selfThumb = message.selfThumb
    self.thumbsMap[targetUid][configId].needRefresh = false
  else
    self.thumbsMap[targetUid] = self.thumbsMap[targetUid] or {}
    self.thumbsMap[targetUid][configId] = {
      count = message.count,
      selfThumb = message.selfThumb,
      needRefresh = false
    }
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceCongratulationThumbsUpCount)
end

function AllianceCongratulationDataManager:GetThumbsUpInfo(targetUid, configId)
  if self.thumbsMap[targetUid] and self.thumbsMap[targetUid][configId] then
    return self.thumbsMap[targetUid][configId]
  end
  return nil
end

function AllianceCongratulationDataManager:ChangeThumbsUpTarget(message)
  local targetUid = message.targetUid
  local configId = message.configId
  if self.thumbsMap == nil then
    self.thumbsMap = {}
  end
  if self.thumbsMap[targetUid] and self.thumbsMap[targetUid][configId] then
    self.thumbsMap[targetUid][configId].needRefresh = true
  else
    self.thumbsMap[targetUid] = self.thumbsMap[targetUid] or {}
    self.thumbsMap[targetUid][configId] = {needRefresh = true}
  end
end

function AllianceCongratulationDataManager:GetAllianceCongratulationList()
  if not LuaEntry.Player:IsInAlliance() then
    return {}
  end
  if not table.IsNullOrEmpty(self.congratulationList) then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for i = #self.congratulationList, 1, -1 do
      local item = self.congratulationList[i]
      if item.uid == LuaEntry.Player.uid or curTime >= item.expireTimeStamp or item.selfThumb == true then
        table.remove(self.congratulationList, i)
      end
    end
  end
  self:RemoveDuplicateCongrats()
  return self.congratulationList
end

function AllianceCongratulationDataManager:RemoveDuplicateCongrats()
  if not self.congratulationList or #self.congratulationList <= 1 then
    return
  end
  local uniqueMap = {}
  local newList = {}
  for _, v in ipairs(self.congratulationList) do
    local key = tostring(v.uid) .. "_" .. tostring(v.configId)
    if not uniqueMap[key] then
      uniqueMap[key] = true
      table.insert(newList, v)
    end
  end
  self.congratulationList = newList
end

function AllianceCongratulationDataManager:InitAllianceCongratulationData(message)
  if LuaEntry.Player:IsInAlliance() then
    DataCenter.AllianceCongratulationDataManager:SendGetAllianceCongratulationList()
  end
end

function AllianceCongratulationDataManager:AllianceCongratulationBubbleState()
  if not LuaEntry.Player:IsInAlliance() then
    return false
  end
  if not table.IsNullOrEmpty(self.congratulationList) then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for i = #self.congratulationList, 1, -1 do
      local item = self.congratulationList[i]
      if item.uid == LuaEntry.Player.uid or curTime >= item.expireTimeStamp or item.selfThumb == true then
        table.remove(self.congratulationList, i)
      end
    end
  end
  self:RemoveDuplicateCongrats()
  return not table.IsNullOrEmpty(self.congratulationList)
end

function AllianceCongratulationDataManager:SetFlyCenter(value)
  self.flyCenter = value
end

function AllianceCongratulationDataManager:PlayFlyAni(rewards)
  if table.IsNullOrEmpty(rewards) then
    return
  end
  if rewards ~= nil then
    local rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(rewards) or {}
    if not table.IsNullOrEmpty(rewardList) then
      local value = rewardList[1]
      local rewardType = value.rewardType
      local itemId = value.itemId
      local pic = RewardUtil.GetPic(rewardType, itemId)
      if pic ~= "" then
        local resourceType = RewardToResType[rewardType]
        local flyEndPos
        if resourceType ~= nil then
          flyEndPos = UIUtil.GetResourcePos(resourceType)
        end
        if flyEndPos == nil then
          flyEndPos = Vector3.New(0, 0, 0)
        end
        local num = 1
        if tonumber(itemId) == 200360 then
          num = 5
        end
        local position = DataCenter.AllianceCongratulationDataManager.flyCenter or Vector3.New(0, 0, 0)
        UIUtil.DoFly(tonumber(rewardType), num, pic, position, flyEndPos, 154, 154, nil, nil, 1)
      end
    end
  end
end

function AllianceCongratulationDataManager:UpdateCrossDayRewardCount()
  if self.maxRewardCount then
    self.remainRewardCount = self.maxRewardCount
  else
    self.maxRewardCount = LuaEntry.DataConfig:TryGetNum("alliance_Congratulations", "k5", 100)
    self.remainRewardCount = self.maxRewardCount
  end
end

function AllianceCongratulationDataManager:GetBubbleFixedTime()
  if self.fixedTime == -1 then
    self.fixedTime = LuaEntry.DataConfig:TryGetNum("alliance_Congratulations", "k1", 5)
  end
  return self.fixedTime
end

function AllianceCongratulationDataManager:GetBubbleStringContents()
  if table.IsNullOrEmpty(self.bubbleContents) then
    local contents = LuaEntry.DataConfig:TryGetStr("alliance_Congratulations", "k2", "")
    for s in string.gmatch(contents, "([^|]+)") do
      table.insert(self.bubbleContents, s)
    end
  end
  return self.bubbleContents
end

function AllianceCongratulationDataManager:GetListPopBubbleStringContents()
  if table.IsNullOrEmpty(self.bubblePopContents) then
    self.bubblePopContents = {}
    local contents = LuaEntry.DataConfig:TryGetStr("alliance_Congratulations", "k6", "")
    for s in string.gmatch(contents, "([^;]+)") do
      table.insert(self.bubblePopContents, s)
    end
  end
  return self.bubblePopContents
end

function AllianceCongratulationDataManager:SetPopInfo(value)
  self.popInfo = value
  if value == nil and self.delayPop then
    self.delayPop:Stop()
    self.delayPop = nil
  end
end

function AllianceCongratulationDataManager:GetPopInfo()
  return self.popInfo
end

function AllianceCongratulationDataManager:PlayPopInfo()
  DataCenter.AllianceCongratulationDataManager:SetDelay()
end

function AllianceCongratulationDataManager:SetDelay()
  if self.delayPop then
    self.delayPop:Stop()
    self.delayPop = nil
  end
  local infos = DataCenter.AllianceCongratulationDataManager:GetPopInfo()
  if infos then
    self.delayPop = TimerManager:GetInstance():DelayInvoke(function()
      if CS.SceneManager:IsInCity() or CS.SceneManager:IsInWorld() then
        local infos2 = DataCenter.AllianceCongratulationDataManager:GetPopInfo()
        if infos2 then
          UIUtil.OpenLWUIChatCommonShare(infos2.share_components)
        end
      end
    end, 0.5)
  end
end

function AllianceCongratulationDataManager:SetGuideInfo(id)
  self.flowId = id
end

function AllianceCongratulationDataManager:PlayGuide()
  if self.flowId then
    DataCenter.LWGuideFlowManager:TryTriggerFlexibly(self.flowId)
    self.flowId = nil
  end
end

function AllianceCongratulationDataManager:GetPlayerHeadInfo(uid)
  if table.IsNullOrEmpty(self.headIndexList) then
    self.headIndexList = {
      1,
      3,
      25
    }
  end
  if self.headInfoByUidList and self.headInfoByUidList[uid] then
    return self.headInfoByUidList[uid]
  end
  local s = tostring(uid)
  local sum = 0
  for c in s:gmatch("%d") do
    sum = sum + tonumber(c)
  end
  local index = sum % 3 + 1
  local param = {
    name = "",
    abbr = "",
    headPic = "player_head_" .. self.headIndexList[index],
    headPicVer = 0
  }
  if not self.headInfoByUidList then
    self.headInfoByUidList = {}
  end
  self.headInfoByUidList[uid] = param
  return self.headInfoByUidList[uid]
end

function AllianceCongratulationDataManager:GetPlayerHeadInfoForRewardPop()
  if not table.IsNullOrEmpty(self.headInfoByUidList) then
    return self.headInfoByUidList
  end
  return nil
end

function AllianceCongratulationDataManager:SetPlayerHeadInfoEmpty()
  self.headInfoByUidList = {}
end

AllianceCongratulationDataManager.__init = __init
AllianceCongratulationDataManager.__delete = __delete
return AllianceCongratulationDataManager
