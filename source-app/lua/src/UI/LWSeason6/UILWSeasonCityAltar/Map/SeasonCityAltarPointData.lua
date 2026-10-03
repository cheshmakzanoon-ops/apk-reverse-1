local SeasonCityAltarPointData = BaseClass("SeasonCityAltarPointData")

function SeasonCityAltarPointData:__init()
  self.HasInit = false
end

function SeasonCityAltarPointData:__delete()
  self.HasInit = false
end

function SeasonCityAltarPointData:SetData(pointInfo, serverId)
  self.HasInit = true
  self.Owner = pointInfo.owner
  self.TmpOwner = pointInfo.tmpOwner
  self.ServerId = checknumber(serverId)
  self.CityId = pointInfo.cityId
  self.BattleStartTime = checknumber(pointInfo.battleStartTime)
  self.BattleEndTime = checknumber(pointInfo.battleEndTime)
  self.OccupyList = pointInfo.occupylist
  self.GiveUpTime = checknumber(pointInfo.giveupTime)
  self.FishState = checknumber(pointInfo.fishState)
  self.FirstOccupyTime = checknumber(pointInfo.firstOccupyTime)
  self.FirstOccupyUser = pointInfo.firstOwner
  self.CityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.CityId, self.ServerId)
end

function SeasonCityAltarPointData:GetTimeState()
  if not self.HasInit then
    return AllianceCityShowTimeState.AltarLock, 0
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now < self.BattleStartTime then
    return AllianceCityShowTimeState.AltarLock, self.BattleStartTime
  elseif now >= self.BattleStartTime and now < self.BattleEndTime then
    return AllianceCityShowTimeState.AltarBattle, self.BattleEndTime
  else
    return AllianceCityShowTimeState.AltarOver, math.maxinteger
  end
end

function SeasonCityAltarPointData:GetOccupier()
  local occupier = ""
  if self.TmpOwner ~= nil then
    occupier = self.TmpOwner.allianceId
  elseif self.Owner ~= nil then
    occupier = self.Owner.allianceId
  end
  return occupier
end

function SeasonCityAltarPointData:GetSortedOccupyList()
  if not table.IsNullOrEmpty(self.OccupyList) then
    local occupier = self:GetOccupier()
    table.sort(self.OccupyList, function(a, b)
      local aIsOccupy = a.userInfo ~= nil and a.userInfo.allianceId == occupier
      local bIsOccupy = b.userInfo ~= nil and b.userInfo.allianceId == occupier
      return aIsOccupy and not bIsOccupy or not aIsOccupy and not bIsOccupy and a.score > b.score
    end)
    local top3 = {}
    for _, occupy in pairs(self.OccupyList) do
      table.insert(top3, occupy)
    end
    return top3
  end
  return {}
end

function SeasonCityAltarPointData:HasOwner()
  return table.IsNullOrEmpty(self.Owner)
end

function SeasonCityAltarPointData:GetOwnerFullName()
  if not table.IsNullOrEmpty(self.Owner) then
    return string.format("[%s] %s", self.Owner.alAbbr, self.Owner.uidName)
  end
  return ""
end

function SeasonCityAltarPointData:GetTmpOwner()
  return self.TmpOwner
end

function SeasonCityAltarPointData:BelongMyAlliance()
  if LuaEntry.Player:IsInAlliance() and self.Owner ~= nil and not string.IsNullOrEmpty(self.Owner.allianceId) then
    return self.Owner.allianceId == LuaEntry.Player.allianceId
  end
  return false
end

function SeasonCityAltarPointData:CanGiveUp()
  if self:BelongMyAlliance() and self:CheckOptAuth() then
    local state, time = self:GetTimeState()
    if state ~= AllianceCityShowTimeState.AltarBattle then
      local leftTime = time - UITimeManager:GetInstance():GetServerTime()
      return leftTime > OneHourTime * 1000
    end
  end
  return false
end

function SeasonCityAltarPointData:GetGiveUpLeftTime()
  return checknumber(self.GiveUpTime) - UITimeManager:GetInstance():GetServerTime()
end

function SeasonCityAltarPointData:IsGivingUp()
  return self:GetGiveUpLeftTime() > 0
end

function SeasonCityAltarPointData:CanFish()
  if self:CheckOptAuth() then
    local state, _ = self:GetTimeState()
    if state == AllianceCityShowTimeState.AltarLock or state == AllianceCityShowTimeState.AltarOver then
      return checknumber(self.FishState) == 0
    end
  end
  return false
end

function SeasonCityAltarPointData:CheckOptAuth()
  if self:BelongMyAlliance() then
    return DataCenter.AllianceBaseDataManager:IsR4orR5()
  end
  return false
end

return SeasonCityAltarPointData
