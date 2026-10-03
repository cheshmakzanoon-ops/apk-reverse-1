local SeasonCityAltarRed = BaseClass("SeasonCityAltarRed", RedPointNode)

function SeasonCityAltarRed:__init(nodeName)
  self:AddListener(EventId.SeasonCityAltarRedUpdate, self.Update)
end

function SeasonCityAltarRed:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function SeasonCityAltarRed:Update()
  self:SetCountBoolean(not CommonUtil.PlayerPrefsGetBool(SettingKeys.S6_MILITARY_ALTAR_ACTIVITY_SHOW, false))
end

return SeasonCityAltarRed
