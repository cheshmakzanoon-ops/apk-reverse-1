local LWWorldTrendTemplateManager = BaseClass("LWWorldTrendTemplateManager")
local LWWorldTrendTemplate = require("DataCenter.LWWorldTrendManager.LWWorldTrendTemplate")

local function __init(self)
  self.allEvnetInfos = {}
end

local function __delete(self)
  self.dayInfos = nil
end

function LWWorldTrendTemplateManager:Startup()
end

function LWWorldTrendTemplateManager:InitAllTemplate()
  LocalController:instance():visitTable(TableName.LW_WorldTrends, function(id, lineData)
    local item = LWWorldTrendTemplate.New()
    item:InitData(lineData)
    table.insert(self.allEvnetInfos, item)
  end)
  table.sort(self.allEvnetInfos, function(a, b)
    if a.id < b.id then
      return true
    end
  end)
  return self.allEvnetInfos
end

LWWorldTrendTemplateManager.__init = __init
LWWorldTrendTemplateManager.__delete = __delete
return LWWorldTrendTemplateManager
