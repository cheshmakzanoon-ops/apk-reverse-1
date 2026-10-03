local ChatRestrictManager = BaseClass("ChatRestrictManager")
local ChatShieldInfo = require("Chat.Model.ChatShieldInfo")
local rapidjson = require("rapidjson")

function ChatRestrictManager:__init()
  self:resetData()
end

function ChatRestrictManager:resetData()
  self.shieldInfoList = {}
  self.banNameList = {}
  self.chatShieldMax = 0
  self.shareGiveLikeList = {}
  self.shareGiveLikeAnim = {}
end

function ChatRestrictManager:SetGiveLikeMsgTime(type, emojiIndex, timeStamp)
  if not emojiIndex then
    return
  end
  if not self.shareGiveLikeList[type] then
    self.shareGiveLikeList[type] = {}
  end
  self.shareGiveLikeList[type][emojiIndex] = timeStamp
end

function ChatRestrictManager:GetGiveLikeMsgTime(type, index)
  if not index then
    return
  end
  if self.shareGiveLikeList[type] ~= nil and self.shareGiveLikeList[type][index] then
    return self.shareGiveLikeList[type][index]
  end
  return 0
end

function ChatRestrictManager:SetGiveLikeAnim(type, num)
  self.shareGiveLikeAnim[type] = num
end

function ChatRestrictManager:GetGiveLikeAnim(type)
  if self.shareGiveLikeAnim[type] ~= nil then
    return self.shareGiveLikeAnim[type]
  end
  return 0
end

function ChatRestrictManager:GetMaxShield()
  return self.chatShieldMax
end

function ChatRestrictManager:GetShieldInfoList()
  return self.shieldInfoList
end

function ChatRestrictManager:releaseData()
  self:resetData()
end

function ChatRestrictManager:onServerInfo(data)
  self.shieldInfoList = {}
  self:SetChatShieldMax(LuaEntry.DataConfig:TryGetNum("chat_max", "k2"))
  if not table.IsNullOrEmpty(data.chatShield) then
    for _, v in ipairs(data.chatShield) do
      local shieldInfo = self:CreateChatShieldInfo()
      shieldInfo:onParseServerData(v)
      self:addShieldInfo(shieldInfo)
    end
  end
end

function ChatRestrictManager:CreateChatShieldInfo()
  return ChatShieldInfo.New()
end

function ChatRestrictManager:SetChatShieldMax(num)
  ChatPrint("chatShieldMax = %d", num)
  self.chatShieldMax = num
end

function ChatRestrictManager:isReachShieldLimit()
  return #self.shieldInfoList >= self.chatShieldMax
end

function ChatRestrictManager:addShieldInfo(shieldInfo)
  table.insert(self.shieldInfoList, shieldInfo)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_BLOCK_ADD, shieldInfo)
end

function ChatRestrictManager:getShieldInfoByUuid(uuid)
  for _, v in ipairs(self.shieldInfoList) do
    if v.uuid == uuid then
      return v
    end
  end
  return nil
end

function ChatRestrictManager:addBanList(uid)
  table.insert(self.banNameList, uid)
end

function ChatRestrictManager:removeRestrictUser(uid, type)
  if type == RestrictType.BLOCK then
    for i = 1, #self.shieldInfoList do
      local shieldInfo = self.shieldInfoList[i]
      if shieldInfo.uid == uid then
        table.remove(self.shieldInfoList, i)
        EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_BLOCK_REMOVE, shieldInfo)
        break
      end
    end
  elseif type == RestrictType.BAN then
    table.removebyvalue(self.banNameList, uid)
  end
end

function ChatRestrictManager:isInRestrictList(uid, type)
  if type == RestrictType.BLOCK then
    for i = 1, #self.shieldInfoList do
      local shieldInfo = self.shieldInfoList[i]
      if shieldInfo.uid == uid then
        return true
      end
    end
  elseif type == RestrictType.BAN and table.hasvalue(self.banNameList, uid) then
    return true
  end
  return false
end

function ChatRestrictManager:GetRestrictUuid(uid, type)
  if type == RestrictType.BLOCK then
    for i = 1, #self.shieldInfoList do
      local shieldInfo = self.shieldInfoList[i]
      if shieldInfo.uid == uid then
        return shieldInfo.uuid
      end
    end
  end
end

function ChatRestrictManager:chatBanOrUnBan(uid, banGMName, banTime, type)
  local currentTime = ChatInterface.getServerTime()
  local addBan = banTime == -1 or 86400 < banTime - currentTime
  if banTime == 0 then
    self:removeRestrictUser(uid, RestrictType.BAN)
  elseif addBan then
    self:addBanList(uid)
  end
end

function ChatRestrictManager:BargainShopMsgShield(msg)
  if msg.post == PostType.Text_ChatRoomSystemMsg then
    return true
  end
  if not msg or not msg.extra then
    return
  end
  local data, isOn
  if msg.extra.post == PostType.Activity_BargainShop then
    if (msg.group == ChatGroupType.GROUP_COUNTRY or msg.group == ChatGroupType.GROUP_LANGUAGE) and not LuaEntry.Player:IsLoginSourceServer() and not UIUtil.CheckDetectCanCrossServer() then
      return false
    end
    data = msg:getMessageParam()
    if data and data.activityId then
      local actInfo = DataCenter.ActBargainShopData:GetInfoByActId(data.activityId)
      if actInfo == nil or actInfo.id == nil or actInfo.endTime == nil then
        return false
      end
      if not msg:isMyChat() then
        isOn = DataCenter.ActBargainShopData:GetShieldChatIsOn(tonumber(data.activityId))
        return not isOn
      end
    end
  elseif msg.extra.post == PostType.BestReward then
    if not LuaEntry.Player:IsLoginSourceServer() then
      if msg.group == ChatGroupType.GROUP_ALLIANCE then
        return true
      end
      if msg.extra.customJsonParam ~= nil then
        local extraJson = rapidjson.decode(msg.extra.customJsonParam)
        if extraJson.packetId == 100 or extraJson.packetId == 101 then
          return true
        end
      end
      return false
    end
  elseif msg.extra.post == PostType.Detect_Treasure_Reward_Fin_Info then
    return false
  elseif msg.extra.post == PostType.TorchRelayCheer then
    if not LuaEntry.Player:IsLoginSourceServer() then
      return false
    end
    data = msg:getMessageParam()
    if data and data.activityId then
      local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(tostring(data.activityId))
      if activityData == nil or activityData.activityId == nil then
        return false
      end
      local condition = LocalController:instance():getValue(TableName.Activity, activityData.activityId, "condition")
      if condition then
        local conditionSplit = string.split(condition, "|")
        if 2 <= #conditionSplit then
          local limitLv = tonumber(conditionSplit[2])
          return limitLv <= LuaEntry.Player.level
        end
      end
    end
  elseif msg.extra.post == PostType.GiftGiving then
    local extraJson
    if type(msg.extra.customJsonParam) == "string" then
      extraJson = rapidjson.decode(msg.extra.customJsonParam)
    elseif type(msg.extra.customJsonParam) == "table" then
      extraJson = msg.extra.customJsonParam
    end
    if extraJson and extraJson.sendUid then
      return not self:isInRestrictList(extraJson.sendUid, RestrictType.BLOCK)
    end
  end
  return true
end

function ChatRestrictManager:GetMsgIsCanShow(msg)
  if not self:isInRestrictList(msg.senderUid, RestrictType.BLOCK) and self:BargainShopMsgShield(msg) and not msg:canSkip() and msg:CheckCanShow() then
    return true
  end
end

return ChatRestrictManager
