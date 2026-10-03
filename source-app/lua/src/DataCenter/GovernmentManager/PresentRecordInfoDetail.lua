local PresentRecordInfoDetail = BaseClass("PresentRecordInfoDetail")
local Localization = CS.GameEntry.Localization

function PresentRecordInfoDetail:__init()
  self.presentId = 0
  self.sendTime = 0
  self.toUid = ""
  self.name = ""
  self.abbr = ""
end

function PresentRecordInfoDetail:__delete()
  self.presentId = 0
  self.sendTime = 0
  self.toUid = ""
  self.name = ""
  self.abbr = ""
end

function PresentRecordInfoDetail:ParseData(message)
  if message == nil then
    return
  end
  if message.presentId then
    self.presentId = message.presentId
  elseif message.cfgId then
    self.presentId = message.cfgId
  end
  if message.sendTime then
    self.sendTime = message.sendTime
  end
  if message.toUid then
    self.toUid = message.toUid
  end
  if message.name then
    self.name = message.name
  end
  if message.abbr then
    self.abbr = message.abbr
  end
end

function PresentRecordInfoDetail:GetPlayerName(uid)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(uid, self.name)
  if self.abbr ~= nil and self.abbr ~= "" then
    return "[" .. self.abbr .. "] " .. showName
  end
  return showName
end

function PresentRecordInfoDetail:GetPacketName()
  local result = ""
  local template = DataCenter.WonderGiftTemplateManager:GetTemplate(self.presentId)
  if template ~= nil then
    result = Localization:GetString(template.name)
  end
  return result
end

return PresentRecordInfoDetail
