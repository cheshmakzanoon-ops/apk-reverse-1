local ActivityPuzzleMonsterTemplateManager = BaseClass("ActivityPuzzleMonsterTemplateManager")
local ActivityPuzzleMonsterTemplate = require("DataCenter.ActivityListData.ActivityPuzzleMonsterTemplate")

local function __init(self)
  self.templateDic = nil
end

local function __delete(self)
  self.templateDic = nil
end

local function InitAllTemplate(self)
  self.templateDic = {}
  LocalController:instance():visitTable(TableName.ActivityPuzzleMonster, function(id, lineData)
    local item = ActivityPuzzleMonsterTemplate.New()
    item:InitData(lineData)
    self.templateDic[item.id] = item
  end)
end

local function GetAllTemplate(self)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  return self.templateDic
end

local function GetTemplate(self, id)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  return self.templateDic[id]
end

local function GetTemplateByMonsterId(self, monsterId)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  for _, v in pairs(self.templateDic) do
    if v.monsterId == monsterId then
      return v
    end
  end
  return nil
end

ActivityPuzzleMonsterTemplateManager.__init = __init
ActivityPuzzleMonsterTemplateManager.__delete = __delete
ActivityPuzzleMonsterTemplateManager.InitAllTemplate = InitAllTemplate
ActivityPuzzleMonsterTemplateManager.GetAllTemplate = GetAllTemplate
ActivityPuzzleMonsterTemplateManager.GetTemplate = GetTemplate
ActivityPuzzleMonsterTemplateManager.GetTemplateByMonsterId = GetTemplateByMonsterId
return ActivityPuzzleMonsterTemplateManager
