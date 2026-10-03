local repaidJson = require("rapidjson")
local MailWeatherReport = BaseClass("MailWeatherReport")

function MailWeatherReport:__init()
  self.id = nil
end

function MailWeatherReport:ParseContent(mailContent)
  if table.IsNullOrEmpty(mailContent) then
    return
  end
  self.id = mailContent.id
end

function MailWeatherReport:GetWeatherIcon()
  local weatherInfo = DataCenter.SeasonWeatherManager:GetWeatherInfo()
  if not weatherInfo then
    return ""
  end
  local typeInfo = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(weatherInfo.weatherId)
  if not typeInfo then
    return ""
  end
  return typeInfo.icon or ""
end

return MailWeatherReport
