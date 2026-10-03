local LWArmedUpgradeTemplateManager = BaseClass("LWArmedUpgradeTemplateManager")
local LWArmedUpgradeTemplate = require("DataCenter.LWArmedUpgradeManager.LWArmedUpgradeTemplate")

function LWArmedUpgradeTemplateManager:__init()
  self.lwArmedUpgradeTemplateDict = nil
  self.armedUpgradeMaxLevel = nil
end

function LWArmedUpgradeTemplateManager:__delete()
  self.lwArmedUpgradeTemplateDict = nil
  self.armedUpgradeMaxLevel = nil
end

function LWArmedUpgradeTemplateManager:TryInitArmedUpgradeTemplate()
  if self.lwArmedUpgradeTemplateDict == nil then
    self.lwArmedUpgradeTemplateDict = {}
    local tableName = LuaEntry.Player:GetABTestTableName(TableName.LW_ARMED_UPGRADE)
    LocalController:instance():visitTable(tableName, function(id, lineData)
      local level = lineData.level
      if self.lwArmedUpgradeTemplateDict[level] == nil and lineData ~= nil then
        local template = LWArmedUpgradeTemplate.New()
        template:UpdateData(lineData)
        self.lwArmedUpgradeTemplateDict[level] = template
      end
    end)
  end
end

function LWArmedUpgradeTemplateManager:GetArmedUpgradeTemplateByLevel(level)
  self:TryInitArmedUpgradeTemplate()
  return self.lwArmedUpgradeTemplateDict[level]
end

function LWArmedUpgradeTemplateManager:GetArmedUpgradeMaxLevel()
  if self.armedUpgradeMaxLevel == nil then
    self:TryInitArmedUpgradeTemplate()
    for level, template in pairs(self.lwArmedUpgradeTemplateDict) do
      if self.armedUpgradeMaxLevel == nil or level > self.armedUpgradeMaxLevel then
        self.armedUpgradeMaxLevel = level
      end
    end
  end
  return self.armedUpgradeMaxLevel
end

return LWArmedUpgradeTemplateManager
