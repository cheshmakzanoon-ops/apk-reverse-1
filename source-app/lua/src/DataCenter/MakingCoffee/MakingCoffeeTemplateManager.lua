local MakingCoffeeTemplateManager = BaseClass("MakingCoffeeTemplateManager")
local MakingCoffeeTemplate = require("DataCenter.MakingCoffee.MakingCoffeeTemplate")

local function __init(self)
  self.templateDict = {}
  self.templateList = {}
  self.allStatus = {}
  self.allGoods = {}
  self.maxCoffeeCount = nil
  self:InitAllTemplate()
end

local function __delete(self)
  self.templateDict = nil
  self.templateList = nil
  self.allStatus = nil
  self.allGoods = nil
  self.maxCoffeeCount = nil
end

local function GetAllTemplate(self)
  return self.templateDict
end

local function InitAllTemplate(self)
  self.templateDict = {}
  LocalController:instance():visitTable(TableName.LW_MAKING_COFFEE, function(id, lineData)
    if lineData ~= nil then
      local item = MakingCoffeeTemplate.New()
      item:InitData(lineData)
      if item.id then
        self.templateDict[item.id] = item
        if item.status and item.status > 0 then
          table.insert(self.allStatus, item.status)
        end
        table.insert(self.templateList, item)
      end
    end
  end)
  table.sort(self.templateList, function(a, b)
    return a.order > b.order
  end)
end

function MakingCoffeeTemplateManager:GetAllCoffeeList()
  return self.templateList
end

function MakingCoffeeTemplateManager:GetTemplate(id)
  if not id then
    return
  end
  return self.templateDict[id]
end

function MakingCoffeeTemplateManager:GetAllFreeConfigID()
  local idList = {}
  for i = 1, #self.templateList do
    if self.templateList[i].unlock_goods == "0" then
      table.insert(idList, self.templateList[i].id)
    end
  end
  return idList
end

function MakingCoffeeTemplateManager:GetAllStatus()
  return self.allStatus
end

MakingCoffeeTemplateManager.__init = __init
MakingCoffeeTemplateManager.__delete = __delete
MakingCoffeeTemplateManager.GetAllTemplate = GetAllTemplate
MakingCoffeeTemplateManager.InitAllTemplate = InitAllTemplate
return MakingCoffeeTemplateManager
