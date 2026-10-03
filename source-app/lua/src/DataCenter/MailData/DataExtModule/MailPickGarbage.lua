local repaidJson = require("rapidjson")
local MailPickGarbage = BaseClass("MailPickGarbage")
local Localization = CS.GameEntry.Localization

function MailPickGarbage:__init()
  self.x = 0
  self.y = 0
  self.serverId = 0
  self.eventId = 0
end

function MailPickGarbage:ParseContent(mailContent)
  self._jsonContent = mailContent
  if table.IsNullOrEmpty(self._jsonContent) then
    return
  end
  local paramContent = self._jsonContent.pointInfo
  if paramContent.x ~= nil then
    self.x = paramContent.x
  end
  if paramContent.y ~= nil then
    self.y = paramContent.y
  end
  if paramContent.serverId ~= nil then
    self.serverId = paramContent.serverId
  end
  if self._jsonContent.eventId ~= nil then
    self.eventId = self._jsonContent.eventId
  end
end

function MailPickGarbage:GetName()
  local config = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(self.eventId)
  if config ~= nil then
    return config:GetRealName()
  end
  return ""
end

function MailPickGarbage:GetHeroExpAddInfo()
  return {}
end

function MailPickGarbage:GetDescription()
  local config = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(self.eventId)
  if config ~= nil then
    return Localization:GetString(config.description)
  end
  return ""
end

return MailPickGarbage
