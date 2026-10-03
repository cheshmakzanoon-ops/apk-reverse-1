local RedPacketManager = BaseClass("RedPacketManager")
local rapidjson = require("rapidjson")
RedPacketManager.ChannelType = {
  World = 1,
  Alliance = 2,
  Season = 3,
  AliFriend = 4
}

function RedPacketManager:__init()
  self.red_packet_new = 0
  self.red_packet_new_expire = 0
  self.entrySwitch = false
  self:AddListener()
end

function RedPacketManager:__delete()
  self.red_packet_new = nil
  self.red_packet_new_expire = nil
  self.entrySwitch = nil
  self:RemoveListener()
end

function RedPacketManager:OnEnterGame()
end

function RedPacketManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.RedPacketOpen, self.OnRedPacketOpen)
  EventManager:GetInstance():AddListener(EventId.RedPacketDetails, self.OnRedPacketDetails)
end

function RedPacketManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.RedPacketOpen, self.OnRedPacketOpen)
  EventManager:GetInstance():RemoveListener(EventId.RedPacketDetails, self.OnRedPacketDetails)
end

function RedPacketManager:IsHaveRedPackRed()
  local items = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_139)
  if items and 0 < #items then
    return true
  end
  local list = DataCenter.SeasonTradeShopDataManager:GetRedPacketList()
  return 0 < #list
end

function RedPacketManager:SetRedPackRedDot()
  self.items = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_139)
  if self.items then
    for i, info in pairs(self.items) do
      info:SetNewCount()
    end
  end
  DataCenter.SeasonTradeShopDataManager:SetRedPackRedDot()
end

function RedPacketManager.OnRedPacketOpen(data)
  if data and data.redPacket then
    data.redPacket.roomId = data.roomId
    data.redPacket.seqId = data.seqId
    if data.redPacket.buffReceiverUid and data.redPacket.buffReceiverUid == LuaEntry.Player.uid then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGetLuckyBuffPopup, {anim = true}, {
        redPacket = data.redPacket,
        type = 1
      })
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIRedPacketDetails, {anim = true}, data.redPacket)
    end
  end
end

function RedPacketManager:GetIsOverdue(extraJson)
  if not extraJson then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local expiredTime = tonumber(extraJson.expiredTime)
  local time = expiredTime - curTime
  if time <= 0 then
    return true
  end
end

function RedPacketManager:GetOpenShowAllRedPacketList()
  local items = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_139)
  local list = {}
  local temp
  for i, v in pairs(items) do
    temp = DataCenter.RedPacketTemplateManager:GetTemplateByGoodsId(v.goods.id)
    if temp and temp:IsOpenRedPacket() and not v:CheckIsExpireInOtherParamData() and not temp:IsLuckyRedPacket() then
      table.insert(list, v)
    end
  end
  items = DataCenter.SeasonTradeShopDataManager:GetRedPacketList()
  for i, v in pairs(items) do
    temp = v and DataCenter.RedPacketTemplateManager:GetTemplateByGoodsId(v.goods.id)
    if temp and temp:IsOpenRedPacket() then
      table.insert(list, v)
    end
  end
  return list
end

function RedPacketManager:GetIsReceive(chatData, uids)
  if chatData.senderUid == LuaEntry.Player.uid then
    return true
  end
  if uids == nil then
    return
  end
  for i = 1, #uids do
    if uids[i] == LuaEntry.Player.uid then
      return true
    end
  end
end

function RedPacketManager:GetIsNone(extraJson, uids)
  if not extraJson or not uids then
    return
  end
  local redPocketTemp
  if extraJson.packetId then
    redPocketTemp = DataCenter.RedPacketTemplateManager:GetTemplate(extraJson.packetId)
  else
    redPocketTemp = DataCenter.RedPacketTemplateManager:GetTemplateByGoodsId(extraJson.goodsId)
  end
  if not redPocketTemp then
    Logger.LogError("\233\133\141\231\189\174\233\151\174\233\162\152 \230\163\128\230\159\165\233\133\141\231\189\174 \230\178\161\230\156\137\231\186\162\229\140\133  id : " .. extraJson.goodsId)
    return
  elseif not redPocketTemp.num then
    Logger.LogError("\233\133\141\231\189\174\229\135\186\233\148\153 \231\186\162\229\140\133\230\178\161\230\156\137\230\156\128\229\164\167\230\149\176\233\135\143 \230\163\128\230\159\165\233\133\141\231\189\174  id : " .. extraJson.goodsId)
    return
  end
  if uids and #uids + 1 >= redPocketTemp.num then
    return true
  end
end

function RedPacketManager:GetRedPackRedDot()
  local count = 0
  self.items = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_139)
  if self.items then
    for i, info in pairs(self.items) do
      if not info:CheckIsExpireInOtherParamData() then
        count = count + info.count
      end
    end
  end
  count = count + DataCenter.SeasonTradeShopDataManager:GetRedPackRedDot()
  return count
end

function RedPacketManager.OnRedPacketDetails(data)
  if data and data.redPacket then
    data.redPacket.isDetails = true
    data.redPacket.roomId = data.roomId
    data.redPacket.seqId = data.seqId
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIRedPacketDetails, {anim = true}, data.redPacket)
  end
end

function RedPacketManager:UpdateRedPacket(data)
  UIUtil.ShowTipsId("red_pocket_desc27")
  if data.isCopy then
    if data.copyChatType == self.ChannelType.World then
      UIUtil.ShowTipsId("red_pocket_desc29")
    elseif data.copyChatType == self.ChannelType.Season then
      UIUtil.ShowTipsId("red_pocket_desc40")
    end
  end
  if data.redPackets then
    local redPacket = data.redPackets[1]
    if redPacket and redPacket.detail then
      redPacket.isDetails = true
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIRedPacketDetails, {anim = true}, redPacket)
    end
  end
  if data.reward then
    DataCenter.RewardManager:AddRewardsAndRes(data)
  end
end

function RedPacketManager:GetOpenLevel()
  return LuaEntry.DataConfig:TryGetNum("red_pocket_config", "k2")
end

function RedPacketManager:GetIsOpen()
  local level = LuaEntry.DataConfig:TryGetNum("red_pocket_config", "k2")
  if level <= DataCenter.BuildManager.MainLv then
    return true
  end
end

function RedPacketManager:GetRedPacketGetMaxNum()
  local maxNum = LuaEntry.DataConfig:TryGetNum("red_pocket_config", "k1")
  return maxNum
end

function RedPacketManager:SetRedPacketGetNumData(msg)
  if msg.red_packet_new ~= nil then
    self.red_packet_new = msg.red_packet_new
  end
  if msg.red_packet_new_expire ~= nil then
    self.red_packet_new_expire = msg.red_packet_new_expire
  end
  self:InitServerIsOn(msg)
end

function RedPacketManager:GetRedPacketGetNum()
  local curNum = self.red_packet_new
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.red_packet_new_expire then
    curNum = 0
  end
  return curNum
end

function RedPacketManager:GetChatOpenSeasonRedPacket(special_type)
  local items = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_139)
  for i = 1, #items do
    if items[i].special_type == special_type then
      return true
    end
  end
  items = DataCenter.SeasonTradeShopDataManager:GetRedPacketList()
  for i = 1, #items do
    if items[i].special_type == special_type then
      return true
    end
  end
end

function RedPacketManager:SendChatOpenToServer()
  SFSNetwork.SendMessage(MsgDefines.RedPacketSwitchStatus, true)
  self.entrySwitch = true
end

function RedPacketManager:GetChatOpen()
  if self.entrySwitch then
    return true
  end
  local templateCon
  local templateType = DataCenter.RedPacketTemplateManager:GetAllRedPackTypeTemp()
  local allTemp = DataCenter.RedPacketTemplateManager:GetAllRedPackTemplate()
  local redPackList = self:GetOpenShowAllRedPacketList()
  local hasRedPack
  if redPackList then
    hasRedPack = 0 < #redPackList
  end
  if hasRedPack then
    self:SendChatOpenToServer()
    return true
  end
  for i, template in pairs(allTemp) do
    templateCon = nil
    if template.special_type then
      templateCon = templateType[template.special_type]
    end
    if templateCon then
      if template.special_type == RedPacketType.Festival and template:IsOpenInTime() and templateCon:HasOpenDay() then
        if template:IsInOpenServers() then
          self:SendChatOpenToServer()
          return true
        end
      elseif template:IsOpenRedPacket() and templateCon:HasOpenDay() then
        self:SendChatOpenToServer()
        return true
      end
    end
  end
end

function RedPacketManager:InitServerIsOn(t)
  if t and t.redPacketSwitch then
    self.entrySwitch = t.redPacketSwitch == 1
  end
end

function RedPacketManager:GetReceiveCountByChatData(chatData)
  local uids = {}
  if chatData.clientUpdateExtra then
    local temp = string.split(chatData.clientUpdateExtra, "|")
    if not string.IsNullOrEmpty(temp[2]) then
      uids = string.split(temp[2], ",")
    end
  end
  local extraJson
  if chatData.extra ~= nil and chatData.extra.customJsonParam ~= nil then
    extraJson = rapidjson.decode(chatData.extra.customJsonParam)
  end
  local default = extraJson and extraJson.hasRob and 1 or 0
  local count = math.max(#uids, default)
  return count
end

function RedPacketManager:GetLikeNumByChatData(chatData)
  local likeNum = 0
  if chatData.clientUpdateExtra then
    local temp = string.split(chatData.clientUpdateExtra, "|")
    if temp[3] then
      likeNum = tonumber(temp[3]) or 0
    end
  end
  return likeNum
end

function RedPacketManager:CheckIsBirthdayTypeByChatData(chatData)
  local isBirthday = false
  local extraJson
  if chatData.extra ~= nil and chatData.extra.customJsonParam ~= nil then
    extraJson = rapidjson.decode(chatData.extra.customJsonParam)
  end
  local temp
  if extraJson then
    if extraJson.packetId then
      temp = DataCenter.RedPacketTemplateManager:GetTemplate(extraJson.packetId)
    elseif extraJson.goodsId then
      temp = DataCenter.RedPacketTemplateManager:GetTemplateByGoodsId(extraJson.goodsId, true)
    end
  end
  if temp and temp.type == RedPacketType.Birthday then
    isBirthday = true
  end
  return isBirthday
end

return RedPacketManager
