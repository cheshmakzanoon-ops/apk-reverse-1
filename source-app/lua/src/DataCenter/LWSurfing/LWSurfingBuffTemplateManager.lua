local LWSurfingBuffTemplateManager = BaseClass("LWSurfingBuffTemplateManager")
local Localization = CS.GameEntry.Localization
local LWSurfingBuffTemplate = require("DataCenter.LWSurfing.LWSurfingBuffTemplate")

function LWSurfingBuffTemplateManager:__init()
  self.buffConfigList = {}
end

function LWSurfingBuffTemplateManager:__delete()
  self.buffConfigList = nil
end

function LWSurfingBuffTemplateManager:GetTemplate(buffId)
  if self.buffConfigList == nil then
    self.buffConfigList = {}
  end
  if self.buffConfigList[buffId] then
    return self.buffConfigList[buffId]
  else
    local lineData = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.lw_parkour_buff), buffId)
    if lineData ~= nil then
      local item = LWSurfingBuffTemplate.New()
      item:InitData(lineData)
      if item.id ~= nil then
        self.buffConfigList[item.id] = item
        return self.buffConfigList[item.id]
      end
    end
  end
  return nil
end

return LWSurfingBuffTemplateManager
