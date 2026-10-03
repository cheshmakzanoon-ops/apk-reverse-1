local AllianceCityTipBaseClass = BaseClass("AllianceCityTipBaseClass")

function AllianceCityTipBaseClass:__init(gameObject)
  self.gameObject = gameObject
  self.transform = gameObject.transform
  self.lodCache = 1
  self.timer = nil
  self.timer_tick = 1
  
  function self.timer_action(temp)
    self:TimerAction()
  end
end

function AllianceCityTipBaseClass:__delete()
  self:DeleteTimer()
  self.gameObject = nil
  self.transform = nil
  self.timer_action = nil
  self.timer = nil
  self.theCityDetail = nil
  self.theExtraInfo = nil
end

function AllianceCityTipBaseClass:UpdateCityInfo()
  local pointInfo = self.data:GetPointInfo()
  if pointInfo ~= nil then
    local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
    if extraInfo ~= nil then
      if self.data and (self.data.type == WorldAllianceCityType.King or self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.MissileFactory) then
        local state = extraInfo.state
        self.isCrossServerThrone = state == AllianceCityState.SERVER_NEUTRAL or state == AllianceCityState.SERVER_OCCUPIED or state == AllianceCityState.SERVER_BUILD_THRONE
      end
      self.theExtraInfo = extraInfo
    end
    self.thePointInfo = pointInfo
  end
  self.theCityDetail = DataCenter.WorldPointDetailManager:GetAllianceCityData(self.cityId)
end

function AllianceCityTipBaseClass:OnKingOccupyProgressRefresh()
  self:UpdateCityInfo()
end

function AllianceCityTipBaseClass:OnPointDateUpdate()
  self:UpdateCityInfo()
end

function AllianceCityTipBaseClass:OnPointOutView()
  self:UpdateCityInfo()
end

function AllianceCityTipBaseClass:OnWorldAllianceCityDetail()
  self:UpdateCityInfo()
end

function AllianceCityTipBaseClass:SetLod(lod)
  self.lodCache = lod
end

function AllianceCityTipBaseClass:CheckLod(lod)
  self.lodCache = lod
end

function AllianceCityTipBaseClass:ReInit(data)
  self.data = data
  self.isKingCity = data:IsThroneCity()
  self.cityId = toInt(self.data.id)
  self.cityType = toInt(self.data.type)
  self.serverId = self.data:GetCurServerId()
  self.seasonInfo = SeasonUtil.GetSeasonInfo(self.serverId)
  if self.seasonInfo then
    self.seasonType = self.seasonInfo:GetServerSubdivisionType(false)
  end
  if self.data and (self.cityType == WorldAllianceCityType.King or self.cityType == WorldAllianceCityType.Canon) then
    self:AddTimer()
  else
    self:DeleteTimer()
  end
end

function AllianceCityTipBaseClass:AddTimer()
  self:DeleteTimer()
  self.timer = TimerManager:GetInstance():GetTimer(self.timer_tick or 1, self.timer_action, self, false, false, false)
  self.timer:Start()
end

function AllianceCityTipBaseClass:TimerAction()
end

function AllianceCityTipBaseClass:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

return AllianceCityTipBaseClass
