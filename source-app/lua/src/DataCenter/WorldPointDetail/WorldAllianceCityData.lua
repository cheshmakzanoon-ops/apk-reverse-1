local WorldAllianceCityData = BaseClass("WorldAllianceCityData")

local function __init(self)
  self.cityId = 0
  self.attackList = {}
  self.defenceList = {}
  self.battleStartTime = 0
  self.armyUnit = {}
  self.firstOccupyInfo = {}
  self.durabilityMax = 0
  self.armyMax = 0
  self.armyCur = 0
end

local function __delete(self)
  self.cityId = nil
  self.attackList = nil
  self.defenceList = nil
  self.firstOccupyInfo = nil
  self.durabilityMax = nil
  self.ruinObj = nil
  self.armyMax = 0
  self.armyCur = 0
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  self.serverId = message.serverId
  self.cityId = toInt(message.cityId or message.strongholdId)
  if message.battleStartTime ~= nil then
    self.battleStartTime = message.battleStartTime
  end
  if message.armyUnit ~= nil then
    self.armyUnit = PBController.ParsePb1(message.armyUnit, "protobuf.ArmyUnitInfo")
  end
  self.attachmentList = message.attachmentList
  self.slotFirstStatus = message.slotFirstStatus
  self.attackList = {}
  self.defenceList = {}
  if message.attackInfos ~= nil then
    local arr = message.attackInfos
    table.walk(arr, function(k, v)
      local oneData = {}
      if v.alAbbr ~= nil then
        oneData.alAbbr = v.alAbbr
      end
      if v.alName ~= nil then
        oneData.alName = v.alName
      end
      if v.point ~= nil then
        oneData.point = v.point
      end
      if v.alId ~= nil then
        oneData.allianceId = v.alId
      end
      if v.buildPoint ~= nil then
        oneData.buildPoint = v.buildPoint
      end
      table.insert(self.attackList, oneData)
    end)
  end
  if message.defendInfo ~= nil then
    local arr = message.defendInfo
    local oneData = {}
    if arr.aid ~= nil then
      oneData.aid = arr.aid
    end
    if arr.alAbbr ~= nil then
      oneData.alAbbr = arr.alAbbr
    end
    if arr.alName ~= nil then
      oneData.alName = arr.alName
    end
    if arr.occupyServerId ~= nil then
      oneData.occupyServerId = arr.occupyServerId
    end
    table.insert(self.defenceList, oneData)
  end
  if message.durabilityMax then
    self.durabilityMax = message.durabilityMax
  end
  if message.armyMax then
    self.armyMax = message.armyMax
  end
  if message.towerInfo then
    self.towerInfo = message.towerInfo
  end
  if not table.IsNullOrEmpty(message.latestOccupy) then
    local latestOccupy = message.latestOccupy
    local avatar = latestOccupy.avatar
    local data = BasePlayerInfo.New()
    data:ParseData(avatar)
    data.time = latestOccupy.time
    self.latestOccupy = data
  end
  if message.armyCur then
    self.armyCur = message.armyCur
  end
  if message.missileFactory then
    self.missileFactoryProduct = message.missileFactory.product
  end
  self.firstOccupyInfo = {}
  local obj = message.firstOccupyInfo
  if not table.IsNullOrEmpty(obj) then
    if obj.firstOccupyTime ~= nil then
      self.firstOccupyInfo.firstOccupyTime = obj.firstOccupyTime
    end
    if obj.alAbbr ~= nil then
      self.firstOccupyInfo.alAbbr = obj.alAbbr
    end
    if obj.alName ~= nil then
      self.firstOccupyInfo.alName = obj.alName
    end
    if obj.alIcon ~= nil then
      self.firstOccupyInfo.alIcon = obj.alIcon
    end
    if obj.aid ~= nil then
      self.firstOccupyInfo.aid = obj.aid
    end
  end
  self.firstCrossOccupyInfo = {}
  obj = message.firstCrossOccupyInfo
  if not table.IsNullOrEmpty(obj) then
    if obj.firstCrossOccupyTime ~= nil then
      self.firstCrossOccupyInfo.firstOccupyTime = obj.firstCrossOccupyTime
    end
    if obj.alAbbr ~= nil then
      self.firstCrossOccupyInfo.alAbbr = obj.alAbbr
    end
    if obj.alName ~= nil then
      self.firstCrossOccupyInfo.alName = obj.alName
    end
    if obj.alIcon ~= nil then
      self.firstCrossOccupyInfo.alIcon = obj.alIcon
    end
    if obj.aid ~= nil then
      self.firstCrossOccupyInfo.aid = obj.aid
    end
    if obj.crossServerId ~= nil then
      self.firstCrossOccupyInfo.serverId = obj.crossServerId
    end
  end
  if not string.IsNullOrEmpty(message.declareAlliances) then
    self.declareAlliances = string.split(message.declareAlliances, ",")
  end
  if message.act_nuclear_score then
  end
  if message.greenRate then
    self.greenRate = message.greenRate
  end
  if message.suppliesNum then
    self.suppliesNum = message.suppliesNum
  end
  if WorldBattleUtil.EnableShowWorldAssistanceInfo() then
    self.maxAssistance = message.maxAssistance or 0
    self.currAssistance = message.currAssistance or 0
    self.assistanceTotalPower = message.assistanceTotalPower or 0
    self.assistanceList = nil
    if message.assistanceList then
      self.assistanceList = {}
      for k, v in ipairs(message.assistanceList) do
        local _p = AssistancePlayerInfo.New()
        _p:Parse(v)
        table.insert(self.assistanceList, _p)
      end
    end
  else
    self.assistanceList = nil
  end
  if message.hasGhost then
    self.hasGhost = message.hasGhost
  else
    self.hasGhost = false
  end
  self.cityBattleS1RestInfo = message.cityBattleS1RestInfo
  self.warTimeIndex = message.warTimeIndex
  if message.bankDetail then
    self.bankDetail = message.bankDetail
    self.userBankInfo = message.userBankInfo
  end
  if message.ruinObj then
    self.ruinObj = message.ruinObj
  end
end

function WorldAllianceCityData:HasFirstOccupy()
  if self.firstCrossOccupyInfo then
    return toInt(self.firstCrossOccupyInfo.firstOccupyTime) > 0
  end
  return false
end

WorldAllianceCityData.__init = __init
WorldAllianceCityData.__delete = __delete
WorldAllianceCityData.ParseData = ParseData
return WorldAllianceCityData
