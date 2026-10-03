local FireworkGift = BaseClass("FireworkGift")

function FireworkGift:__init()
  self.uuid = 0
  self.configId = 0
  self.type = 0
  self.num = 0
  self.max = 0
  self.sendTime = 0
  self.sendUid = ""
  self.index = 0
  self.isAvailable = false
  self.allianceUid = 0
end

function FireworkGift:SetData(data, ownerUid)
  if not data then
    return
  end
  self.uuid = data.uuid or 0
  self.configId = data.configId or 0
  self.type = GetTableData(TableName.Firework, self.configId, "type", 0)
  self.num = data.num or 0
  self.max = data.max or 0
  self.sendTime = data.sendTime or 0
  self.sendUid = data.sendUid or ""
  self.ownerUid = ownerUid or ""
  self.index = data.index or 0
  self:CheckIsAvailable()
end

function FireworkGift:SetCsData(data, ownerUid, allianceUid)
  if not data then
    return
  end
  self.uuid = data.Uuid or 0
  self.configId = data.ConfigId or 0
  self.type = GetTableData(TableName.Firework, self.configId, "type", 0)
  self.num = data.Num or 0
  self.max = data.Max or 0
  self.sendTime = data.SendTime or 0
  self.sendUid = data.SendUid or ""
  self.ownerUid = ownerUid or ""
  self.index = data.Index or 0
  self.allianceUid = allianceUid or 0
  self:CheckIsAvailable()
end

function FireworkGift:GetUuid()
  return self.uuid
end

function FireworkGift:GetConfigId()
  return self.configId
end

function FireworkGift:GetNum()
  return self.num
end

function FireworkGift:GetMax()
  return self.max
end

function FireworkGift:GetSendTime()
  return self.sendTime
end

function FireworkGift:GetSendUid()
  return self.sendUid
end

function FireworkGift:GetIndex()
  return self.index
end

function FireworkGift:IsReachLimit()
  return self.num >= self.max
end

function FireworkGift:GetRemainCount()
  return math.max(0, self.max - self.num)
end

function FireworkGift:CheckIsAvailable()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local oldData = self.isAvailable
  local memberData
  if not string.IsNullOrEmpty(LuaEntry.Player:GetAllianceUid()) then
    memberData = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(self.ownerUid)
  end
  if self.type == 1 then
    self.isAvailable = not self:IsReachLimit() and curTime > self.sendTime and LuaEntry.Player:IsInAlliance() and self.allianceUid == LuaEntry.Player:GetAllianceUid()
  else
    self.isAvailable = not self:IsReachLimit() and curTime > self.sendTime and memberData ~= nil
  end
  if self.type == 1 then
    if self.fireworksDuration == nil then
      self.fireworksDuration = LuaEntry.DataConfig:TryGetNum("fireworks", "k2", 0) * 60 * 1000
    end
    if curTime >= self.sendTime + self.fireworksDuration then
      self.isAvailable = false
    end
  end
  return oldData ~= self.isAvailable
end

return FireworkGift
