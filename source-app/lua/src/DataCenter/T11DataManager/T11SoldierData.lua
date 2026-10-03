local T11SoldierData = BaseClass("T11SoldierData")
local T11SoldierTemplate = require("DataCenter.T11DataManager.Template.T11SoldierTemplate")

local function __init(self)
  self.soldierData = nil
end

local function __delete(self)
  self.soldierData = nil
end

function T11SoldierData:InitSoldierData()
  self.soldierData = {}
  LocalController:instance():visitTable(TableName.T11_Soldier_Config, function(_, lineData)
    if lineData ~= nil then
      local template = T11SoldierTemplate.New()
      template:UpdateData(lineData)
      local tStage = tonumber(template.stage)
      if not self.soldierData[tStage] then
        self.soldierData[tStage] = {}
      end
      self.soldierData[tStage][template.soldierType] = template
    end
  end)
end

function T11SoldierData:GetAllSoldierDataTmpInfo()
  if not self.soldierData or table.count(self.soldierData) == 0 then
    self:InitSoldierData()
  end
  return self.soldierData
end

T11SoldierData.__init = __init
T11SoldierData.__delete = __delete
return T11SoldierData
