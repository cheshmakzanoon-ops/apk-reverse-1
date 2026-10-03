local ThroneConnectedInfoMessage = BaseClass("ThroneConnectedInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ThroneConnectedInfoMessage:OnCreate()
  base.OnCreate(self)
end

function ThroneConnectedInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonNineKingManager:SetThroneConnectedInfo(t)
  EventManager:GetInstance():Broadcast(EventId.ThroneConnectedInfoMessage, t)
end

function ThroneConnectedInfoMessage:GetTestData()
  local msg = {}
  local midServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.Source)
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local centerId = SeasonUtil.GetCenterCityId(loginServerId)
  local center = {}
  center.cityId = centerId
  center.type = 1
  center.allianceId = "allianceId_center"
  center.allianceAbbr = "AC"
  center.allianceName = "Alliance Center"
  center.allianceIcon = tostring(math.random(1, 5))
  center.serverId = LuaEntry.Player:GetSourceServerId()
  local cityTemp = DataCenter.AllianceCityTemplateManager:GetTemplate(center.cityId, midServerId)
  center.pointId = cityTemp and cityTemp:GetPointId()
  center.protectTime = UITimeManager:GetInstance():GetServerTime() + math.random(60000, 3600000)
  msg.throne = center
  msg.ls = {}
  local cityIds = {
    1026,
    1058,
    1027,
    994,
    996,
    963,
    932,
    964
  }
  for i = 1, 8 do
    local data = {}
    data.serverId = LuaEntry.Player:GetSourceServerId()
    if math.random(0, 100) < 30 then
      data.cityId = cityIds[i]
      data.type = 4
      data.allianceId = ""
      data.allianceAbbr = ""
      data.allianceName = ""
      data.allianceIcon = ""
      data.protectTime = 0
      table.insert(msg.ls, data)
    else
      data.cityId = cityIds[i]
      data.type = 1
      local index = math.random(1, 3)
      if index <= 1 then
        data.allianceId = LuaEntry.Player.allianceId
        data.allianceAbbr = LuaEntry.Player:GetAllianceAbbr()
        data.allianceName = LuaEntry.Player:GetAllianceName()
        data.allianceIcon = tostring(math.random(1, 5))
      else
        data.allianceId = "allianceId_" .. index
        data.allianceAbbr = "A" .. index
        data.allianceName = "Alliance " .. index
        data.allianceIcon = tostring(math.random(1, 5))
      end
      data.protectTime = UITimeManager:GetInstance():GetServerTime() + math.random(60000, 3600000)
      table.insert(msg.ls, data)
    end
    cityTemp = DataCenter.AllianceCityTemplateManager:GetTemplate(data.cityId, midServerId)
    data.pointId = cityTemp and cityTemp:GetPointId()
  end
  return msg
end

return ThroneConnectedInfoMessage
