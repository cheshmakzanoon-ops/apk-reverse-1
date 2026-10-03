local ActBargainShopData = BaseClass("ActBargainShopData")
local ActBargainShopInfo = require("DataCenter.ActivityListData.ActBargainShopInfo")
local Localization = CS.GameEntry.Localization
local bargainKey = "activity_bargain_shop_desc9"
local ShareType = {
  [ChatShareChannel.TO_COUNTRY] = 1,
  [ChatShareChannel.TO_ALLIANCE] = 2,
  [ChatShareChannel.TO_PERSON] = 3,
  [ChatShareChannel.TO_LANGUAGE] = 4
}

function ActBargainShopData:__init()
  self.list = {}
end

function ActBargainShopData:__delete()
  self.list = nil
end

function ActBargainShopData:SetActivityId(id)
  if self.list[tonumber(id)] == nil then
    self.list[tonumber(id)] = ActBargainShopInfo.New()
  end
end

function ActBargainShopData:ParseEventData(message)
  if message == nil then
    return
  end
  if self.list[message.activityId] then
    local info
    if self.list[message.activityId].endTime then
      info = self.list[message.activityId]
    else
      info = ActBargainShopInfo.New()
    end
    info:ParseInfo(message)
    self.list[message.activityId] = info
  end
end

function ActBargainShopData:GetInfoByActId(activityId)
  activityId = tonumber(activityId)
  if self.list[activityId] then
    return self.list[activityId]
  end
  return nil
end

function ActBargainShopData:GetActRedNum(id)
  local info = self:GetInfoByActId(id)
  if info and info.id and info.endTime then
    return info:RedNum()
  end
end

function ActBargainShopData:GetChannelFromRoomId(roomId)
  local share_type = ChatManager2:GetInstance().Room:GetChannelFromRoomId(roomId)
  return ShareType[share_type]
end

function ActBargainShopData:SendShareChatRoomMessage(message)
  local share_param = {}
  share_param.itemUid = message.uuid
  share_param.activityId = message.activityId
  share_param.sid = LuaEntry.Player:GetSelfServerId()
  share_param.post = PostType.Activity_BargainShop
  share_param.itemId = message.itemId
  share_param.roomId = message.roomId
  local chatData = {}
  chatData.roomId = message.roomId
  chatData.post = PostType.Activity_BargainShop
  chatData.param = share_param
  local info = self:GetInfoByActId(message.activityId)
  info:SetCD(message.cd_end_time)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
  EventManager:GetInstance():Broadcast(EventId.ShareBargainShopMessage, info:GetProductByUuid(message.uuid))
end

function ActBargainShopData:GetShieldChatIsOn(activityId)
  local data = self:GetInfoByActId(activityId)
  if data and data.GetShieldChatIsOn then
    return data:GetShieldChatIsOn()
  end
end

function ActBargainShopData:GetBargainSeqId(activityId, roomId, seqId)
  return activityId .. "_" .. roomId .. "_" .. seqId
end

function ActBargainShopData:CanGetFreePack(actId)
  local data = self:GetInfoByActId(actId)
  if data then
    return data:CanGetDailyReward()
  end
  return false
end

function ActBargainShopData:SetShieldChatIsOn(activityId, isOn)
  local data = self:GetInfoByActId(activityId)
  if data then
    data:SetShieldChatIsOn(isOn)
  end
end

function ActBargainShopData:UpdateShopInfo(message)
  if message.activityId then
    local data = self:GetInfoByActId(message.activityId)
    if data then
      data:ParseInfo(message)
    end
  end
end

function ActBargainShopData:GetIsBargain(activityId, seqId)
  if activityId then
    local data = self:GetInfoByActId(activityId)
    if data then
      return data:GetIsBargain(seqId)
    end
  end
end

function ActBargainShopData:UpdateDailyRewardData(message)
  local data = self:GetInfoByActId(message.activityId)
  if not data then
    return
  end
  data:UpdateDailyRewardData(message)
end

function ActBargainShopData:AddOnBargainToHistoryList(activityId, seqId)
  if activityId then
    local data = self:GetInfoByActId(activityId)
    if data then
      data:AddOnBargainToHistoryList(seqId)
    end
  end
end

function ActBargainShopData:HelpBargain(message)
  self:AddOnBargainToHistoryList(message.activityId, message.seqId)
  EventManager:GetInstance():Broadcast(EventId.HelpBargainSuccess)
  if message and message.reward then
    if message.helpedUid then
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_CLOSE_POP_UP_KEYBOARD)
    end
    DataCenter.RewardManager:AddRewards(message.reward)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGetGiftView, {anim = true}, message)
  end
end

function ActBargainShopData:OnBuyItem(message)
  if message.activityId then
    local data = self:GetInfoByActId(message.activityId)
    if data then
      message.detailObj.uuid = message.uuid
      data:UpdateOneProductData(message.uuid, message.detailObj)
    end
    local product = data:GetProductByUuid(message.uuid)
    if product and product.template.buyTimeLimit - product.buyNum <= 0 then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBargainShopShare)
    end
    DataCenter.RewardManager:AddRewards(message.reward)
    DataCenter.RewardManager:ShowCommonReward(message)
  end
end

function ActBargainShopData:UpdateShopPropInfo(message)
  local data = self:GetInfoByActId(message.activityId)
  if data then
    data:UpdateOneProductData(message.uuid, message)
  end
end

return ActBargainShopData
