local RedPacketTemplate = BaseClass("RedPacketTemplate")
local Localization = CS.GameEntry.Localization
local defaultAppearanceId = "1"
local ConditionType = {ServerDay = 8, SeasonDay = 149}

local function __init(self)
  self.type = nil
  self.id = nil
  self.reward = nil
  self.num = nil
  self.share_para = nil
  self.para1 = nil
  self.time = nil
  self.pic = nil
  self.pic_open = nil
  self.chat_icon = nil
  self.chat_empty_icon = nil
  self.chat_bg = nil
  self.chat_bg_2 = nil
  self.send_common_tips = nil
  self.send_special_tip = nil
  self.item_pic = nil
  self.pic_tanban = nil
  self.like_type = nil
  self.gift_type = nil
  self.send_receive_condition = nil
  self.fx_hongbao = nil
end

local function __delete(self)
  self.type = nil
  self.id = nil
  self.reward = nil
  self.num = nil
  self.share_para = nil
  self.para1 = nil
  self.time = nil
  self.pic = nil
  self.pic_open = nil
  self.chat_icon = nil
  self.chat_empty_icon = nil
  self.chat_bg = nil
  self.chat_bg_2 = nil
  self.send_common_tips = nil
  self.send_special_tip = nil
  self.item_pic = nil
  self.pic_tanban = nil
  self.like_type = nil
  self.gift_type = nil
  self.send_receive_condition = nil
  self.fx_hongbao = nil
end

local function InitData(self, row, redPacketAppearanceRow)
  if row == nil then
    return
  end
  if not redPacketAppearanceRow then
  end
  self.type = row:getValue("type")
  self.id = row:getValue("id")
  self.reward = row:getValue("reward")
  self.num = row:getValue("num")
  self.share_para = row:getValue("share_para")
  self.para1 = row:getValue("para1")
  self.time = row:getValue("time")
  local str = row:getValue("luck_tips")
  str = string.split(str, "|")
  self.mySendKey = str[1]
  self.otherSendKey = str[2]
  self.init_send = row:getValue("init_send")
  self.init_copy = row:getValue("init_copy")
  self.copy_rate = row:getValue("copy_rate")
  self.para2 = row:getValue("para2")
  self.time = row:getValue("time")
  self.start_time = row:getValue("start_time")
  self.server = row:getValue("server")
  self.time_condition = row:getValue("time_condition")
  self.show_id_list = row:getValue("show_id_list")
  self.goodsId = row:getValue("goodsid")
  self.like_type = row:getValue("like_type")
  self.gift_type = row:getValue("gift_type")
  self.special_type = tonumber(row:getValue("special_type"))
  self.cross_server_open_condition = row:getValue("cross_server_open_condition")
  self.copy_channel = row:getValue("copy_channel")
  self.copy_channel_select_condition = row:getValue("copy_channel_select_condition")
  self.share_para_condition = row:getValue("share_para_condition")
  local conditionStr = row:getValue("open_condition")
  if not string.IsNullOrEmpty(conditionStr) then
    self.condition = {}
    local conditionTable = string.split(conditionStr, "|")
    self.condition.type = tonumber(conditionTable[1])
    if self.condition.type == ConditionType.SeasonDay then
      conditionTable = string.split(conditionTable[2], ",")
      self.condition.season = tonumber(conditionTable[1])
      self.condition.day = tonumber(conditionTable[2])
    elseif self.condition.type == ConditionType.ServerDay then
      self.condition.day = tonumber(conditionTable[2])
    end
  else
    self.condition = nil
  end
  local send_receive_condition = row:getValue("send_receive_condition")
  if not string.IsNullOrEmpty(send_receive_condition) then
    local conditionInfo = string.split(send_receive_condition, "|")
    self.send_receive_condition = {}
    if 1 <= table.count(conditionInfo) then
      local conditionType = tonumber(conditionInfo[1])
      self.send_receive_condition.type = conditionType
    end
    if 2 <= table.count(conditionInfo) then
      local conditionParams = string.split(conditionInfo[2], ";")
      if self.send_receive_condition.type == 1 then
        self.send_receive_condition.itemId = conditionParams[1]
        self.send_receive_condition.count = toInt(conditionParams[2])
      end
    end
  end
  self:InitAppearance()
  self.reward = self:GetReward()
end

function RedPacketTemplate:InitAppearance()
  local conditions = string.split(self.time_condition, "|")
  local timeInfo, condition1, condition2, appearanceId
  for index, time in pairs(conditions) do
    timeInfo = string.split(time, ";")
    condition1 = self:GetIsOpenByTime(timeInfo[1])
    condition2 = self:GetIsOpenByTime(timeInfo[2], true)
    if condition1 and condition2 then
      appearanceId = index
    end
  end
  if appearanceId then
    local showIdList = string.split(self.show_id_list, "|")
    appearanceId = showIdList[appearanceId]
  end
  appearanceId = appearanceId or defaultAppearanceId
  self.appearanceId = appearanceId
  local redPacketAppearanceRow = LocalController:instance():getLine(TableName.LW_Chat_RedPacket_Appearance, appearanceId)
  self.chat_mainui_desc = redPacketAppearanceRow:getValue("chat_mainui_desc")
  self.chat_desc = redPacketAppearanceRow:getValue("chat_desc")
  self.send_special_tips = redPacketAppearanceRow:getValue("send_special_tips")
  self.chat_bg_2 = redPacketAppearanceRow:getValue("chat_bg_2")
  self.chat_bg = redPacketAppearanceRow:getValue("chat_bg")
  self.chat_empty_icon = redPacketAppearanceRow:getValue("chat_empty_icon")
  self.chat_icon = redPacketAppearanceRow:getValue("chat_icon")
  self.pic_open = redPacketAppearanceRow:getValue("pic_open")
  self.pic = redPacketAppearanceRow:getValue("pic")
  self.share_info_text = redPacketAppearanceRow:getValue("share_info_text")
  self.item_pic = redPacketAppearanceRow:getValue("item_pic")
  self.item_pic = redPacketAppearanceRow:getValue("item_pic")
  self.send_common_tips = redPacketAppearanceRow:getValue("send_common_tips")
  self.luky_pic = redPacketAppearanceRow:getValue("luky_pic")
  self.pic_tanban = redPacketAppearanceRow:getValue("pic_tanban")
  self.fx_hongbao = redPacketAppearanceRow:getValue("fx_hongbao")
  local keys = string.split(self.send_common_tips, "|")
  self.keys = {}
  local key
  for i, v in pairs(keys) do
    key = string.split(v, ";")
    table.insert(self.keys, key[1])
  end
end

local function GetReward(self)
  local rewards = string.split(self.reward, ";")
  local reward = {}
  if tonumber(rewards[1]) == RewardType.GOODS then
    reward.reward = DataCenter.ItemTemplateManager:GetItemTemplate(rewards[2])
    reward.pic = DataCenter.ItemTemplateManager:GetIconPath(rewards[2])
  elseif tonumber(rewards[1]) == 1 then
    reward.pic = DataCenter.ResourceManager:GetResourceIconByType(rewards[2])
  end
  reward.num = rewards[3]
  return reward
end

local function HasOpenDay(self)
  if not self.condition then
    return true
  end
  if self.condition.type == ConditionType.SeasonDay then
    local nowSeason, day = DataCenter.SeasonDataManager:GetNowSeasonAndSeasonDay()
    if not self.condition.day or not self.condition.season then
      return
    end
    return nowSeason >= self.condition.season and day >= self.condition.day
  elseif self.condition.type == ConditionType.ServerDay then
    local day = UITimeManager:GetInstance():GetServerOpenDays()
    if not self.condition.day then
      return
    end
    return day >= self.condition.day
  end
end

local function GetName(self)
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.goodsId)
  if goods then
    return goods.name
  end
  return ""
end

local function GetRandomKey(self)
  math.randomseed(SafeLocalOsTime())
  local randomNum = math.random(1, #self.keys)
  return self.keys[randomNum]
end

local function GetPath(name, isRaw)
  return ChatInterface.GetChatUIPath("ChatRedPacket/" .. name, isRaw)
end

function RedPacketTemplate:GetServer(info, param)
  local dicStr
  dicStr = string.split(info, "-")
  if 1 < #dicStr then
    param.dic[tonumber(dicStr[1])] = tonumber(dicStr[2])
  else
    table.insert(param.list, tonumber(dicStr[1]))
  end
end

function RedPacketTemplate:IsInOpenServers()
  local serverStr = self.server
  serverStr = string.split(serverStr, "|")
  local param = {}
  param.dic = {}
  param.list = {}
  if 1 < #serverStr then
    for w, info in pairs(serverStr) do
      self:GetServer(info, param)
    end
  else
    self:GetServer(serverStr[1], param)
  end
  local playerServer = LuaEntry.Player:GetSourceServerId()
  for startServer, endServer in pairs(param.dic) do
    if playerServer >= tonumber(startServer) and playerServer <= tonumber(endServer) then
      return true
    end
  end
  for i, v in pairs(param.list) do
    if v == playerServer then
      return true
    end
  end
end

function RedPacketTemplate:GetIsOpenByTime(time, isGreater)
  if string.IsNullOrEmpty(time) then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local date = string.split(time, "-")
  if table.count(date) == 6 then
    local year = tonumber(date[1])
    local month = tonumber(date[2])
    local day = tonumber(date[3])
    local hour = tonumber(date[4])
    local min = tonumber(date[5])
    local sec = tonumber(date[6])
    local absoluteTime = SafeLocalOsTime({
      year = year,
      month = month,
      day = day,
      hour = hour,
      min = min,
      sec = sec
    })
    return isGreater and curTime <= absoluteTime or curTime >= absoluteTime
  end
end

function RedPacketTemplate:IsOpenInTime()
  return self:GetIsOpenByTime(self.start_time)
end

function RedPacketTemplate:GetluckKey(uid)
  return uid == LuaEntry.Player.uid and self.luckTips[1] or self.luck_tips[2]
end

function RedPacketTemplate.GetRawImgPath(path)
  return "Assets/Main/TextureEx/ChatRedPacket/" .. path
end

function RedPacketTemplate:IsOpenRedPacket()
  return self:IsOpenInTime() and self:IsInOpenServers()
end

function RedPacketTemplate:Condition(showTip)
  local result = true
  if self.send_receive_condition and self.send_receive_condition.type == 1 then
    local hasCount = DataCenter.ItemData:GetItemCount(self.send_receive_condition.itemId)
    result = hasCount < self.send_receive_condition.count
    if not result and showTip and self.send_receive_condition.itemId == RollTreasureItemId then
      UIUtil.ShowTipsId("season4_cave_exploration_tips_5")
    end
  end
  return result
end

function RedPacketTemplate:IsCanCrossServer()
  if string.IsNullOrEmpty(self.cross_server_open_condition) then
    return true
  end
  return TimeConditionUtils.CheckTimeConditionsByStr(self.cross_server_open_condition)
end

function RedPacketTemplate:GetCopyChannelConditionByIndex(index)
  if not string.IsNullOrEmpty(self.copy_channel_select_condition) then
    local copyChannelConditionList = string.split(self.copy_channel_select_condition, "#")
    return copyChannelConditionList[index]
  end
end

function RedPacketTemplate:GetCanCopyChannelCount()
  local isShowWorld = self:IsCanCopyChannel(DataCenter.RedPacketManager.ChannelType.World)
  local isShowSeason = self:IsCanCopyChannel(DataCenter.RedPacketManager.ChannelType.Season)
  local count = 0
  if DataCenter.SeasonAllyFriendManager:HasFriend() then
    local isShowAliFriend = self:IsCanCopyChannel(DataCenter.RedPacketManager.ChannelType.AliFriend)
    if isShowAliFriend then
      count = count + 1
    end
  end
  if isShowWorld then
    count = count + 1
  end
  if isShowSeason then
    count = count + 1
  end
  return count
end

function RedPacketTemplate:IsCanCopyChannel(channel)
  if channel == DataCenter.RedPacketManager.ChannelType.AliFriend and not DataCenter.SeasonAllyFriendManager:HasFriend() then
    return false
  end
  local channelIndex = 0
  if not string.IsNullOrEmpty(self.copy_channel) then
    local copyChannel = string.split(self.copy_channel, "|")
    for i, v in ipairs(copyChannel) do
      if v == tostring(channel) then
        channelIndex = i
      end
    end
  end
  if 0 < channelIndex then
    local condition = self:GetCopyChannelConditionByIndex(channelIndex)
    return condition == nil or TimeConditionUtils.CheckTimeConditionsByStr(condition)
  end
  return false
end

function RedPacketTemplate:IsCanShareChannel(channel)
  if not string.IsNullOrEmpty(self.share_para) then
    local channelIndex = 0
    local shareChannel = string.split(self.share_para, "|")
    for i, v in ipairs(shareChannel) do
      if v == tostring(channel) then
        channelIndex = i
        break
      end
    end
    if 0 < channelIndex then
      local condition = self:GetShareChannelConditionByIndex(channelIndex)
      return condition == nil or TimeConditionUtils.CheckTimeConditionsByStr(condition)
    end
  end
  return false
end

function RedPacketTemplate:GetShareChannelConditionByIndex(index)
  if not string.IsNullOrEmpty(self.share_para_condition) then
    local shareChannelConditionList = string.split(self.share_para_condition, "#")
    return shareChannelConditionList[index]
  end
end

function RedPacketTemplate:IsLuckyRedPacket()
  if not self.type then
    return false
  end
  return self.type == RedPacketType.LuckyBuff or self.type == RedPacketType.LuckyWithoutBuff
end

RedPacketTemplate.__init = __init
RedPacketTemplate.__delete = __delete
RedPacketTemplate.InitData = InitData
RedPacketTemplate.GetReward = GetReward
RedPacketTemplate.GetName = GetName
RedPacketTemplate.GetPath = GetPath
RedPacketTemplate.GetRandomKey = GetRandomKey
RedPacketTemplate.HasOpenDay = HasOpenDay
return RedPacketTemplate
