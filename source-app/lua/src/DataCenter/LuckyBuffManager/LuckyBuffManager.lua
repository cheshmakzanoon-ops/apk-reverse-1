local LuckyBuffManager = BaseClass("LuckyBuffManager")

function LuckyBuffManager:__init()
  self.luckyConfigList = {}
  self.notSharedLuckyPacketList = {}
  self.shortestTimePacketUUid = nil
end

function LuckyBuffManager:__delete()
  self.luckyConfigList = nil
  self.notSharedLuckyPacketList = nil
  self.shortestTimePacketUUid = nil
end

function LuckyBuffManager:InitLuckyPacketData()
  SFSNetwork.SendMessage(MsgDefines.AllianceLuckSiphonGainInfo)
end

function LuckyBuffManager:OnReceiveLuckyPacketData(message)
  if table.IsNullOrEmpty(message) then
    return
  end
  self.notSharedLuckyPacketList = {}
  self.shortestTimePacketUUid = nil
  if not table.IsNullOrEmpty(message.luckInfo) then
    local cur_time = UITimeManager:GetInstance():GetServerTime()
    local shortestTime = 0
    for _, luckyPacketInfo in ipairs(message.luckInfo) do
      local packet_uuid = luckyPacketInfo.uid
      if packet_uuid and not self.notSharedLuckyPacketList[packet_uuid] then
        local expire_time = luckyPacketInfo.expireTime or 0
        if cur_time < expire_time then
          if shortestTime == 0 then
            shortestTime = expire_time
            self.shortestTimePacketUUid = packet_uuid
          elseif 0 < expire_time and expire_time < shortestTime then
            shortestTime = expire_time
            self.shortestTimePacketUUid = packet_uuid
          end
          self.notSharedLuckyPacketList[packet_uuid] = luckyPacketInfo
        end
      end
    end
  end
end

function LuckyBuffManager:AddLuckyPacket(luckyPacketInfo)
  local luckyPacketList = luckyPacketInfo.luckInfo or {}
  for _, packetInfo in ipairs(luckyPacketList) do
    self.notSharedLuckyPacketList[packetInfo.uid] = packetInfo
  end
  self:FilterExpiredLuckyPacket()
end

function LuckyBuffManager:UpdateLuckyPacket(uuid, count)
  if not uuid or not self.notSharedLuckyPacketList[uuid] then
    return
  end
  if not count or count <= 0 then
    self.notSharedLuckyPacketList[uuid] = nil
  else
    self.notSharedLuckyPacketList[uuid].count = count
  end
  self:FilterExpiredLuckyPacket()
end

function LuckyBuffManager:FilterExpiredLuckyPacket()
  if table.IsNullOrEmpty(self.notSharedLuckyPacketList) then
    self.shortestTimePacketUUid = nil
    return
  end
  local cur_time = UITimeManager:GetInstance():GetServerTime()
  local shortestTime = 0
  local needDeleteList = {}
  self.shortestTimePacketUUid = nil
  for uuid, packetInfo in pairs(self.notSharedLuckyPacketList) do
    local expire_time = packetInfo.expireTime or 0
    if cur_time < expire_time then
      if shortestTime == 0 then
        shortestTime = expire_time
        self.shortestTimePacketUUid = uuid
      elseif 0 < expire_time and expire_time < shortestTime then
        shortestTime = expire_time
        self.shortestTimePacketUUid = uuid
      end
    else
      table.insert(needDeleteList, uuid)
    end
  end
  for _, uuid in ipairs(needDeleteList) do
    self.notSharedLuckyPacketList[uuid] = nil
  end
end

function LuckyBuffManager:GetNotSharedLuckyPacketList()
  return self.notSharedLuckyPacketList or {}
end

function LuckyBuffManager:GetLuckyConfigById(lucky_id)
  if not self.luckyConfigList[lucky_id] then
    self.luckyConfigList[lucky_id] = LocalController:instance():getLine(TableName.LW_CONVEYLUCK, lucky_id) or {}
  end
  return self.luckyConfigList[lucky_id]
end

function LuckyBuffManager:GetShortestExpireTime()
  if not self.shortestTimePacketUUid or not self.notSharedLuckyPacketList[self.shortestTimePacketUUid] then
    self:FilterExpiredLuckyPacket()
    return 0
  end
  return self.notSharedLuckyPacketList[self.shortestTimePacketUUid].expireTime or 0
end

function LuckyBuffManager:OpenLuckyPacketSharePopup(ifShowNewest)
  self:FilterExpiredLuckyPacket()
  if table.IsNullOrEmpty(self.notSharedLuckyPacketList) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIShareLuckyBuffPopup, {anim = true}, {
    ifShowNewest = ifShowNewest or false
  })
end

return LuckyBuffManager
