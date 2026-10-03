local base = require("UI.DigMap.DigMapBrick")
local DigMapBrickBuilding = BaseClass("DigMapBrickBuilding", base)

function DigMapBrickBuilding:OnClickCallback()
  DataCenter.BuildingDigTreasureManager:OpenBrick(self.index)
end

return DigMapBrickBuilding
