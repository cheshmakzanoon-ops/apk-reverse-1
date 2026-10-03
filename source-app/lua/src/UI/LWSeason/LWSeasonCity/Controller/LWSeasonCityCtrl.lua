local LWSeasonCityCtrl = BaseClass("LWSeasonCityCtrl", UIBaseCtrl)

function LWSeasonCityCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonCity)
end

function LWSeasonCityCtrl:GetMyAllianceCities()
  local myAlId = LuaEntry.Player.allianceId
  local myAlCities = DataCenter.WorldAllianceCityDataManager:GetCitiesByAlId(myAlId)
  return myAlCities
end

return LWSeasonCityCtrl
