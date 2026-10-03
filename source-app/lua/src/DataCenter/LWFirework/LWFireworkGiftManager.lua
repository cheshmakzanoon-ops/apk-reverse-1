local LWFireworkGiftManager = BaseClass("LWFireworkGiftManager", CEventable)
local Setting = CS.GameEntry.Setting
local LWFireworkGift = require("DataCenter.LWFirework.LWFireworkGift")
local LWFireworkQueue = require("DataCenter.LWFirework.LWFireworkQueue")
local rapidjson = require("rapidjson")

function LWFireworkGiftManager:__init()
  self.uid2FireworkGiftQueueMap = {}
  self.uid2ChatData = {}
  self.chatBubbleViewedTable = CommonUtil.PlayerPrefsGetTable(SettingKeys.FIREWORK_GIFT_CHAT_TIP, {})
  self.giftUuid2TimeTable = CommonUtil.PlayerPrefsGetTable(SettingKeys.FIREWORK_GIFT_UUID_TIME_GOT, {})
  self:CheckGiftPrefsTime()
  self.chatExistTime = LuaEntry.DataConfig:TryGetNum("fireworks", "k2", 120)
  self:AddListener()
  self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, true)
  self.updateSecTimer:Start()
end

local function DeleteTimer(self)
  if self.updateSecTimer ~= nil then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function LWFireworkGiftManager:__delete()
  DeleteTimer(self)
  self.uid2FireworkGiftQueueMap = nil
  self.uid2ChatData = nil
  self.chatBubbleViewedTable = nil
  self.chatExistTime = nil
end

function LWFireworkGiftManager:Startup()
end

function LWFireworkGiftManager:AddListener()
  self:RegisterEvent(EventId.CHAT_ROOM_SEL, self.OnChatRoomSelect)
end

function LWFireworkGiftManager:CheckGiftPrefsTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for k, v in pairs(self.giftUuid2TimeTable) do
    if (curTime - v) / 1000 > OneDayTime then
      self.giftUuid2TimeTable[k] = nil
    end
  end
  CommonUtil.PlayerPrefsSetTable(SettingKeys.FIREWORK_GIFT_UUID_TIME_GOT, self.giftUuid2TimeTable)
end

function LWFireworkGiftManager:IsThisGiftUuidGot(uuid)
  if self.giftUuid2TimeTable[tostring(uuid)] then
    return true
  end
  return false
end

function LWFireworkGiftManager:SetGiftUuidGot(uuid)
  if not self.giftUuid2TimeTable[tostring(uuid)] then
    self.giftUuid2TimeTable[tostring(uuid)] = UITimeManager:GetInstance():GetServerTime()
    CommonUtil.PlayerPrefsSetTable(SettingKeys.FIREWORK_GIFT_UUID_TIME_GOT, self.giftUuid2TimeTable)
  end
end

function LWFireworkGiftManager:GetGiftQueueByPlayerUid(playerUid)
  if self.uid2FireworkGiftQueueMap[playerUid] then
    return self.uid2FireworkGiftQueueMap[playerUid]
  end
end

function LWFireworkGiftManager:UpdateFireworkGiftQueueByUserUidCsData(uid, fireworkGiftList, allianceUid)
  if not uid then
    return
  end
  if not fireworkGiftList or not self.uid2FireworkGiftQueueMap[uid] and fireworkGiftList.Count == 0 then
    return
  end
  local newQueue = LWFireworkQueue.New()
  for i = 0, fireworkGiftList.Count - 1 do
    local newData = LWFireworkGift.New()
    newData:SetCsData(fireworkGiftList[i], uid, allianceUid)
    newQueue:Enqueue(newData)
  end
  self.uid2FireworkGiftQueueMap[uid] = newQueue
  EventManager:GetInstance():Broadcast(EventId.FireworkGiftDataCsUpdate)
end

function LWFireworkGiftManager:IsHasAvailableBoxForMeByUid(uid)
  if self.uid2FireworkGiftQueueMap[uid] then
    local giftQueue = self.uid2FireworkGiftQueueMap[uid]
    if giftQueue:GetSize() > 0 then
      local ret = false
      giftQueue:ForEach(function(giftData)
        giftData:CheckIsAvailable()
        if giftData.isAvailable and not self:IsThisGiftUuidGot(giftData.uuid) then
          ret = true
        end
      end)
      return ret
    end
  end
  return false
end

function LWFireworkGiftManager:IsHasAvailableBoxByUid(uid)
  if self.uid2FireworkGiftQueueMap[uid] then
    local giftQueue = self.uid2FireworkGiftQueueMap[uid]
    if giftQueue:GetSize() > 0 then
      local ret = false
      giftQueue:ForEach(function(giftData)
        giftData:CheckIsAvailable()
        if giftData.isAvailable then
          ret = true
        end
      end)
      return ret
    end
  end
  return false
end

function LWFireworkGiftManager:OnSelfGetFireworksGift(t)
  if not t then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(t)
  if self.giftUuid2TimeTable and t.uuid then
    self:SetGiftUuidGot(t.uuid)
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFireworkGiftGotShow) then
      EventManager:GetInstance():Broadcast(EventId.FireworkGiftGotUpdate, t)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFireworkGiftGotShow, {anim = true}, t)
    end
  end
end

function LWFireworkGiftManager:OnGetFireworksGift(t)
  local pointId = t.pointId
  local iconPath, num
  if t.reward then
    local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(t.reward)
    if rewardList and 0 < #rewardList then
      iconPath = DataCenter.RewardManager:GetPicByType(rewardList[1].rewardType, rewardList[1].itemId)
      num = rewardList[1].count
    end
  end
  UIUtil.ShowFireworkGiftGotBroadcastPopUI(pointId, t, num, iconPath)
end

function LWFireworkGiftManager:SetNewFireworkGiftInChat(chatData)
  if self.uid2ChatData and chatData and chatData.extra ~= nil and chatData.extra.customJsonParam ~= nil then
    local extraJson = rapidjson.decode(chatData.extra.customJsonParam)
    if not self:IsAlreadyHasChat(extraJson.uuid) then
      local data = {
        ownerUid = extraJson.ownerUid,
        chatData = chatData
      }
      self.uid2ChatData[extraJson.uuid] = data
    end
  end
end

function LWFireworkGiftManager:IsAlreadyHasChat(uuid)
  if self.uid2ChatData and self.uid2ChatData[uuid] then
    return true
  end
  return false
end

function LWFireworkGiftManager:SetBubbleTipViewedPrefs(playerUid)
  if self.uid2ChatData then
    for k, v in pairs(self.uid2ChatData) do
      if v.ownerUid == playerUid then
        self.chatBubbleViewedTable[tostring(k)] = 1
      end
    end
  end
  CommonUtil.PlayerPrefsSetTable(SettingKeys.FIREWORK_GIFT_CHAT_TIP, self.chatBubbleViewedTable)
end

function LWFireworkGiftManager:DeleteAllBubbleTipViewedPrefs()
  self.chatBubbleViewedTable = {}
  CommonUtil.PlayerPrefsSetTable(SettingKeys.FIREWORK_GIFT_CHAT_TIP, self.chatBubbleViewedTable)
end

function LWFireworkGiftManager:IsThisChatViewed(chatUuid)
  return self.chatBubbleViewedTable[tostring(chatUuid)] == 1
end

function LWFireworkGiftManager:OnChatRoomSelect(t)
  local roomData = ChatManager2:GetInstance().Room:GetRoomData(t)
  if roomData and roomData:isAllianceRoom() then
    self.uid2ChatData = {}
    self:DeleteAllBubbleTipViewedPrefs(t)
  end
end

function LWFireworkGiftManager:GetRandomAvailableFireworkBoxPlayerUid()
  if self.uid2FireworkGiftQueueMap then
    for k, v in pairs(self.uid2FireworkGiftQueueMap) do
      local ret, data
      if v and v:GetSize() > 0 then
        v:ForEach(function(giftData)
          giftData:CheckIsAvailable()
          if giftData.isAvailable and not self:IsThisGiftUuidGot(giftData.uuid) then
            ret = k
            data = giftData
          end
        end)
      end
      if ret then
        return ret, data
      end
    end
  end
end

function LWFireworkGiftManager:OnUpdateSec()
  if self.uid2FireworkGiftQueueMap then
    local changedPlayerUid = {}
    for k, v in pairs(self.uid2FireworkGiftQueueMap) do
      local size = v:GetSize()
      if 0 < size then
        v:ForEach(function(giftData)
          if giftData:CheckIsAvailable() then
            changedPlayerUid[k] = true
          end
        end)
      end
    end
    if not table.IsNullOrEmpty(changedPlayerUid) then
      EventManager:GetInstance():Broadcast(EventId.FireworkGiftDataTimeUpdate, changedPlayerUid)
    end
  end
end

return LWFireworkGiftManager
