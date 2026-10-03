local PlayPlotManager = BaseClass("PlayPlotManager", Singleton)

function PlayPlotManager:__init()
  self:AddListener()
end

function PlayPlotManager:__delete()
  self:RemoveListener()
end

function PlayPlotManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.OnActRadarPlayer, self.OnActRadarPlayer)
  EventManager:GetInstance():AddListener(EventId.AllianceCityFirstOccupy, self.AllianceCityFirstOccupy)
  EventManager:GetInstance():AddListener(EventId.SendAllianceDeclareWar, self.SendAllianceDeclareWar)
end

function PlayPlotManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.OnActRadarPlayer, self.OnActRadarPlayer)
  EventManager:GetInstance():RemoveListener(EventId.AllianceCityFirstOccupy, self.AllianceCityFirstOccupy)
  EventManager:GetInstance():RemoveListener(EventId.SendAllianceDeclareWar, self.SendAllianceDeclareWar)
end

function PlayPlotManager:PlayRadarPlayerPlot(data)
  Logger.Log("PlayPlot" .. data)
  local marchData = DataCenter.WorldMarchDataManager:GetMarch(data)
  if marchData then
    local pointId = marchData.targetPos
    local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
    if pointInfo and pointInfo.PointType == WorldPointType.PlayerBuilding then
      cast(pointInfo, typeof(CS.BuildPointInfo))
      if pointInfo.specialType == CS.Protobuf.SpecialType.DetectEvent then
        local uuid = pointInfo.uuid
        local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
        local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
        if template ~= nil and template.type == DetectEventType.FAKE_PLAYER then
          local simplayer = template.para
          local playerConfig = LocalController:instance():getLine(TableName.LW_SIMPLAYER, simplayer)
          local plotId = playerConfig.attack_plot_id
          local playerInfo = DataCenter.WorldPointDetailManager:GetDetailByPointId(pointId)
          if playerInfo then
            local playerInfo = {
              uid = playerInfo.uid,
              pic = playerInfo.pic,
              picVer = playerInfo.picVer
            }
            local bubbleParams = {}
            bubbleParams.plotId = plotId
            local targetPos = SceneUtils.TileIndexToWorld(pointId)
            bubbleParams.anchor = Vector3.New(targetPos.x, targetPos.y + 3.7, targetPos.z)
            bubbleParams.mode = "3D"
            bubbleParams.playerInfo = playerInfo
            EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
          end
        end
      end
    end
  end
end

function PlayPlotManager:PlayAttackCityPlot(data)
  local marchData = DataCenter.WorldMarchDataManager:GetMarch(data)
  if marchData and marchData.ownerUid == LuaEntry.Player.uid then
    local pointId = marchData.targetPos
    local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
    if pointInfo and (pointInfo.PointType == WorldPointType.WORLD_ALLIANCE_CITY or pointInfo.PointType == WorldPointType.WORLD_CITY_STRONGHOLD) then
      local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
      local cityId = allianceCityPointInfo.cityId
      local data = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
      if data then
        local plotId = data:GetPlotIdByIndex(3)
        if plotId then
          local bubbleParams = {}
          bubbleParams.plotId = plotId
          local targetPos = SceneUtils.TileIndexToWorld(pointId)
          bubbleParams.anchor = Vector3.New(targetPos.x + 0.8, targetPos.y + 7.1, targetPos.z)
          bubbleParams.mode = "3D"
          EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
        end
      end
    end
  end
end

function PlayPlotManager:PlayCityFirstOccupy(data)
  local cityId = data.cityId
  local aid = data.aid
  local cityDetail = DataCenter.WorldPointDetailManager:GetAllianceCityData(cityId)
  if cityDetail ~= nil then
    local selfAid = LuaEntry.Player:GetAllianceUid()
    if aid == selfAid then
      local data = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
      if data then
        local plotId = data:GetPlotIdByIndex(4)
        EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
          plotGroupId = tonumber(plotId),
          hideMainUI = true
        })
      end
    end
  end
end

function PlayPlotManager:PlayAllianceDeclareWar(data)
  local cityId = data.cityId
  local pointId = data.pointId
  local cityDetail = DataCenter.WorldPointDetailManager:GetAllianceCityData(cityId)
  if cityDetail ~= nil and (cityDetail.firstOccupyInfo == nil or cityDetail.firstOccupyInfo.firstOccupyTime == nil) then
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
    if meta then
      local plotId = meta:GetPlotIdByIndex(2)
      if plotId == nil or plotId == "" then
        return
      end
      local bubbleParams = {}
      bubbleParams.plotId = plotId
      local targetPos = SceneUtils.TileIndexToWorld(pointId)
      bubbleParams.anchor = Vector3.New(targetPos.x + 0.8, targetPos.y + 7.1, targetPos.z)
      bubbleParams.mode = "3D"
      EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
    end
  end
end

local function OnActRadarPlayer(data)
  if CS.SceneManager.World == nil then
    return
  end
  PlayPlotManager:GetInstance():PlayRadarPlayerPlot(data)
end

local function OnActAllianceCity(data)
  if CS.SceneManager.World == nil then
    return
  end
  PlayPlotManager:GetInstance():PlayAttackCityPlot(data)
end

local function AllianceCityFirstOccupy(data)
  if CS.SceneManager.World == nil then
    return
  end
  PlayPlotManager:GetInstance():PlayCityFirstOccupy(data)
end

local function SendAllianceDeclareWar(data)
  if CS.SceneManager.World == nil then
    return
  end
  PlayPlotManager:GetInstance():PlayAllianceDeclareWar(data)
end

PlayPlotManager.OnActRadarPlayer = OnActRadarPlayer
PlayPlotManager.OnActAllianceCity = OnActAllianceCity
PlayPlotManager.AllianceCityFirstOccupy = AllianceCityFirstOccupy
PlayPlotManager.SendAllianceDeclareWar = SendAllianceDeclareWar
return PlayPlotManager
