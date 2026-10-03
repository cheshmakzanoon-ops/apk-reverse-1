local FormationAssistanceDataManager = BaseClass("FormationAssistanceDataManager")

local function __init(self)
  self.assistanceDataList = {}
  self.focusedPointInfo = {}
  self.lastTreatMarchId = nil
  self.lastTreatMarchUuid = nil
end

local function __delete(self)
  self.assistanceDataList = nil
  self.focusedPointInfo = nil
  self.lastTreatMarchId = nil
  self.lastTreatMarchUuid = nil
end

local function UpdateAssistanceData(self, message)
  if message == nil or message.uuid == nil then
    return
  end
  local assistanceData = FormationAssistanceData.New()
  assistanceData:ParseData(message)
  if assistanceData.uuid ~= 0 then
    self.assistanceDataList[assistanceData.uuid] = assistanceData
  end
  if assistanceData.uid and assistanceData.uid == LuaEntry.Player.uid and assistanceData.type == AssistanceType.MainCity then
    self.myAssistanceData = assistanceData
  end
  self.lastTreatUuid = nil
  self.lastTreatMarchUuid = nil
  EventManager:GetInstance():Broadcast(EventId.GetAssistanceData, assistanceData.uuid)
end

function FormationAssistanceDataManager:TryRetreatMarchTeam(buuid, marchUuid)
  SFSNetwork.SendMessage(MsgDefines.AssistanceTeamRetreat, buuid, marchUuid)
  self.lastTreatUuid = buuid
  self.lastTreatMarchUuid = marchUuid
end

function FormationAssistanceDataManager:OnAssistanceTeamRetreat(message)
  local needNotify = false
  if message.success and self.lastTreatUuid then
    local data = self:GetAssistanceData(self.lastTreatUuid)
    if data and data.showList then
      for k, v in ipairs(data.showList) do
        if v.uuid == self.lastTreatMarchUuid then
          table.remove(data.showList, k)
          needNotify = true
          break
        end
      end
    end
    self.lastTreatUuid = nil
    self.lastTreatMarchUuid = nil
  end
  if needNotify then
    EventManager:GetInstance():Broadcast(EventId.GetAssistanceData)
  end
end

function FormationAssistanceDataManager:OnUpdateFocusPointAssistanceInfo(pointId, maxAssistance, currAssistance, assistanceList)
  if not pointId then
    return
  end
  self.focusedPointInfo = {}
  self.focusedPointInfo.pointId = pointId
  self.focusedPointInfo.maxAssistance = maxAssistance or 0
  self.focusedPointInfo.currAssistance = currAssistance or 0
  self.focusedPointInfo.assistanceList = assistanceList
  self.focusedPointInfo.full = self.focusedPointInfo.maxAssistance > 0 and assistanceList and #assistanceList >= self.focusedPointInfo.maxAssistance
  if assistanceList then
    local myUuid = LuaEntry.Player:GetUid()
    for k, v in ipairs(assistanceList) do
      if v.uid == myUuid then
        self.focusedPointInfo.my = v
      end
    end
  end
end

function FormationAssistanceDataManager:OnUpdateFocusCityAssistanceInfo(cityId, maxAssistance, currAssistance, assistanceList)
  if not cityId then
    return
  end
  self.focusedAllianceCityInfo = {}
  self.focusedAllianceCityInfo.cityId = cityId
  self.focusedAllianceCityInfo.maxAssistance = maxAssistance or 0
  self.focusedAllianceCityInfo.currAssistance = currAssistance or 0
  self.focusedAllianceCityInfo.assistanceList = assistanceList
  if assistanceList then
    local myUuid = LuaEntry.Player:GetUid()
    for k, v in ipairs(assistanceList) do
      if v.uid == myUuid then
        self.focusedAllianceCityInfo.my = v
      end
    end
    self.focusedAllianceCityInfo.full = #assistanceList >= self.focusedAllianceCityInfo.maxAssistance
  end
end

function FormationAssistanceDataManager:GetFocusedPointAssistanceInfo(pointId)
  if self.focusedPointInfo and self.focusedPointInfo.pointId == pointId then
    return self.focusedPointInfo
  end
end

function FormationAssistanceDataManager:GetFocusedCityAssistanceInfo(cityId)
  if self.focusedAllianceCityInfo and self.focusedAllianceCityInfo.cityId == cityId then
    return self.focusedAllianceCityInfo
  end
end

local function GetAssistanceData(self, uuid)
  return self.assistanceDataList[uuid]
end

local function GetMyAssistanceData(self)
  return self.myAssistanceData
end

FormationAssistanceDataManager.__init = __init
FormationAssistanceDataManager.__delete = __delete
FormationAssistanceDataManager.UpdateAssistanceData = UpdateAssistanceData
FormationAssistanceDataManager.GetAssistanceData = GetAssistanceData
FormationAssistanceDataManager.GetMyAssistanceData = GetMyAssistanceData
return FormationAssistanceDataManager
