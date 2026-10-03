local AllianceWarEventData = BaseClass("AllianceWarEventData")

function AllianceWarEventData:__init(msg)
  self:ParseServerData(msg)
  self.uuid = AllianceWarEventData.CreateUuid(msg)
  self.template = DataCenter.AllianceWarEventDataManager:GetTemplateByType(self.type)
  self.reminder = DataCenter.AllianceWarEventDataManager:LoadReminder(self.uuid)
  self.seen = false
end

function AllianceWarEventData:__delete()
  self:Destroy()
end

function AllianceWarEventData:Destroy()
  local myAllianceId = LuaEntry.Player.allianceId
  if not string.IsNullOrEmpty(self.allianceId) and self.allianceId ~= myAllianceId then
    EventManager:GetInstance():Broadcast(EventId.MakeWorldColorDirty, self.allianceId)
  elseif not string.IsNullOrEmpty(self.defAllianceId) and self.defAllianceId ~= myAllianceId then
    EventManager:GetInstance():Broadcast(EventId.MakeWorldColorDirty, self.defAllianceId)
  end
  self.uuid = nil
  self.template = nil
end

function AllianceWarEventData.CreateUuid(msg)
  if msg.type == AlWarEventType.ATTACK_OUTPOST_WAR or msg.type == AlWarEventType.DEFENSE_OUTPOST_WAR then
    return string.format("%s/%s/%s/%s", msg.type, msg.warOwnerServer, msg.point, msg.startTime // 3600000)
  end
  return string.format("%s/%s/%s/%s", msg.type, msg.warOwnerServer, msg.point, msg.startTime)
end

function AllianceWarEventData:ParseServerData(message)
  if message == nil then
    return
  end
  self.type = message.type or 0
  self.serverId = message.warOwnerServer or 0
  self.buildId = message.cityId or 0
  self.startTime = message.startTime or 0
  self.endTime = message.endTime or 0
  self.joinNum = message.joinNum or 0
  self.allianceJoinNum = message.allianceJoinNum or 0
  self.point = message.point or 0
  self.abbr = message.abbr
  self.allianceId = message.allianceId
  self.defAllianceId = message.defAllianceId
  return self
end

function AllianceWarEventData:SetReminder(bool)
  if self.reminder ~= bool then
    self.reminder = bool
    EventManager:GetInstance():Broadcast(EventId.AllianceWarEventReminderChange, self)
    DataCenter.AllianceWarEventDataManager:SaveReminder(self.uuid, bool)
  end
end

function AllianceWarEventData:SetSeen()
  self.seen = true
end

function AllianceWarEventData:IsAllianceJoin(allianceId)
  if string.IsNullOrEmpty(allianceId) then
    return false
  end
  if self.allianceId == allianceId or self.defAllianceId == allianceId then
    return true
  end
  return false
end

function AllianceWarEventData:IsMyAllianceJoined()
  local myAllianceId = LuaEntry.Player.allianceId
  return self:IsAllianceJoin(myAllianceId)
end

return AllianceWarEventData
