local T11SoldierPreviewData = BaseClass("T11SoldierPreviewData")
local T11SoldierPreviewTemplate = require("DataCenter.T11DataManager.Template.T11SoldierPreviewTemplate")

local function __init(self)
  self.previewData = nil
end

local function __delete(self)
  self.previewData = nil
end

function T11SoldierPreviewData:InitPreviewData()
  self.previewData = {}
  LocalController:instance():visitTable(TableName.T11_Preview_Config, function(_, lineData)
    if lineData ~= nil then
      local template = T11SoldierPreviewTemplate.New()
      template:UpdateData(lineData)
      table.insert(self.previewData, template)
    end
  end)
  table.sort(self.previewData, function(a, b)
    return a.stage < b.stage
  end)
end

function T11SoldierPreviewData:GetPreviewData()
  if not self.previewData or table.count(self.previewData) == 0 then
    self:InitPreviewData()
  end
  return self.previewData
end

T11SoldierPreviewData.__init = __init
T11SoldierPreviewData.__delete = __delete
return T11SoldierPreviewData
