local TowerUpTemplateManager = BaseClass("TowerUpTemplateManager")

local function __init(self)
  self.firstRewardStage = nil
  self.stageCache = {}
end

local function __delete(self)
  self.firstRewardStage = nil
  self.stageCache = nil
end

local function GetTableName(self)
  return LuaEntry.Player:GetABTestTableName(TableName.TowerUp)
end

local function GetFirstRewardStage(self)
  if self.firstRewardStage == nil then
    self.firstRewardStage = {}
    LocalController:instance():visitTable(self:GetTableName(), function(id, lineData)
      local first_rewarad = lineData:getValue("first_reward")
      if not string.IsNullOrEmpty(first_rewarad) then
        table.insert(self.firstRewardStage, id)
      end
    end)
    table.sort(self.firstRewardStage, function(a, b)
      return a < b
    end)
  end
  return self.firstRewardStage
end

local function GetTowerUpTemplate(self, id)
  id = tonumber(id)
  local template = self.stageCache[id]
  if 0 < id and template == nil then
    local cfg = LocalController:instance():tryGetLine(self:GetTableName(), id)
    if cfg then
      template = TowerUpTemplate.New()
      template:InitData(cfg)
      self.stageCache[id] = template
    end
  end
  return template
end

local function GetTowerUpUnlockTemplate(self, id)
  local template = self:GetTowerUpTemplate(id)
  if template and not template:IsUnlock() then
    template = nil
  end
  return template
end

TowerUpTemplateManager.__init = __init
TowerUpTemplateManager.__delete = __delete
TowerUpTemplateManager.GetTowerUpUnlockTemplate = GetTowerUpUnlockTemplate
TowerUpTemplateManager.GetTowerUpTemplate = GetTowerUpTemplate
TowerUpTemplateManager.GetTableName = GetTableName
TowerUpTemplateManager.GetFirstRewardStage = GetFirstRewardStage
return TowerUpTemplateManager
