local LLCityDetailData = BaseClass("LLCityDetailData")

function LLCityDetailData:__init()
  self.cityId = 0
  self.ownerCampId = 0
  self.state = 0
  self.progress = 0
  self.progressMax = 0
  self.occupyStartProgress = 0
  self.occupyStartTime = 0
  self.landlordNum = 0
  self.farmerNum = 0
  self.refreshBuffTime = 0
  self.buffId = 0
  self.effects = nil
end

function LLCityDetailData:__delete()
  self.effects = nil
end

function LLCityDetailData:ParseData(msg)
  self.cityId = msg.cityId or 0
  local template = DataCenter.LandlordMgr:GetCityTemplate(self.cityId)
  self.isThroneCity = template ~= nil and template:IsLLThroneCity()
  self.ownerCampId = msg.ownerCampId or 0
  self.state = msg.state or 0
  self.progress = msg.progress or 0
  self.progressMax = msg.progressMax or 0
  self.occupyStartProgress = msg.occupyStartProgress or 0
  self.occupyStartTime = msg.occupyStartTime or 0
  self.landlordNum = msg.landlordNum or 0
  self.farmerNum = msg.farmerNum or 0
  self.refreshBuffTime = msg.refreshBuffTime or 0
  self.buffId = msg.buffId or 0
  local effect = msg.effect
  self.effects = {}
  if effect ~= nil then
    for key, value in pairs(effect) do
      self.effects[tonumber(key)] = value
    end
  end
end

function LLCityDetailData:GetEffectValue()
  local effectId = LLConst.OccupySpeedEffectId[self.ownerCampId]
  local effectValue = self.effects[effectId] or 0
  return effectValue
end

function LLCityDetailData:GetSpeed()
  if self.progressMax <= 0 or self.ownerCampId == LLConst.LandLordGroup.NONE then
    return 0
  end
  local effectValue = self:GetEffectValue()
  return DataCenter.LandlordMgr:CalculateOccupySpeed(self.occupyStartTime, effectValue, self.isThroneCity)
end

function LLCityDetailData:GetPercent()
  if self.progressMax <= 0 then
    return 0, 0
  end
  if self.ownerCampId == LLConst.LandLordGroup.NONE then
    local stageInfo = DataCenter.LandlordMgr:GetActCurStageInfo()
    local time = 0
    if stageInfo ~= nil then
      time = stageInfo.eTime - UITimeManager:GetInstance():GetServerSeconds()
    end
    return self.progress, time
  end
  local effectValue = self:GetEffectValue()
  local progress, time = DataCenter.LandlordMgr:CalculateOccupyCurProgress(self.occupyStartTime, self.occupyStartProgress, self.progressMax, self.ownerCampId, effectValue, self.isThroneCity)
  return progress, time
end

return LLCityDetailData
