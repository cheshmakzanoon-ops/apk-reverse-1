local base = require("DataCenter.TowerUpDataManager.TowerUpBaseTemplate")
local TowerUpTemplate = BaseClass("TowerUpTemplate", base)

local function __init(self)
end

local function __delete(self)
end

local function InitData(self, row)
  base.InitData(self, row)
end

TowerUpTemplate.__init = __init
TowerUpTemplate.__delete = __delete
TowerUpTemplate.InitData = InitData
return TowerUpTemplate
