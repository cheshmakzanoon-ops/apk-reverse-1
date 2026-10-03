local HeatSourceTemplateManager = BaseClass("HeatSourceTemplateManager")
local HeatSourceTemplate = require("DataCenter.Temperature.HeatSourceTemplate")

function HeatSourceTemplateManager:__init()
  self.allMeta = nil
  self.templateDict = {}
end

function HeatSourceTemplateManager:__delete()
  self:Destroy()
end

function HeatSourceTemplateManager:Destroy()
  if self.allMeta then
    for _, v in pairs(self.allMeta) do
      v:Delete()
    end
  end
  self.allMeta = nil
end

function HeatSourceTemplateManager:InitMeta()
  if not LocalController:instance():hasTable(TableName.Env_Temperature) then
    return
  end
  self.allMeta = {}
  self.personalStoveMeta = {}
  self.allyStoveMeta = {}
  self.victoryTowerMeta = {}
  LocalController:instance():visitTable(TableName.Env_Temperature, function(id, lineData)
    if lineData ~= nil then
      local meta = HeatSourceTemplate.New()
      meta:InitConfig(lineData)
      self.allMeta[id] = meta
      self.templateDict[id] = meta
      if meta.type == HeatSourceType.PersonalStove then
        self.personalStoveMeta[meta.level] = meta
      elseif meta.type == HeatSourceType.AllianceStove then
        self.allyStoveMeta[meta.level] = meta
      elseif meta.type == HeatSourceType.VictoryTower then
        self.victoryTowerMeta[meta.level] = meta
      end
    end
  end)
end

function HeatSourceTemplateManager:GetPersonalStoveTemplateByLevel(level)
  if self.allMeta == nil then
    self:InitMeta()
  end
  if self.personalStoveMeta == nil then
    return nil
  end
  return self.personalStoveMeta[level]
end

function HeatSourceTemplateManager:GetVictoryTowerTemplateByLevel(level)
  if self.allMeta == nil then
    self:InitMeta()
  end
  if self.victoryTowerMeta == nil then
    return nil
  end
  return self.victoryTowerMeta[level]
end

function HeatSourceTemplateManager:GetTemplate(metaId)
  if self.templateDict == nil then
    return nil
  end
  local ret = self.templateDict[metaId]
  if ret == nil then
    local lineData = LocalController:instance():getLine(TableName.Env_Temperature, metaId)
    if lineData then
      ret = HeatSourceTemplate.New()
      ret:InitConfig(lineData)
    end
  end
  return ret
end

return HeatSourceTemplateManager
