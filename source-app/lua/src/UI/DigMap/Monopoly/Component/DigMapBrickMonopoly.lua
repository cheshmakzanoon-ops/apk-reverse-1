local base = require("UI.DigMap.DigMapBrick")
local DigMapBrickMonopoly = BaseClass("DigMapBrickMonopoly", base)

function DigMapBrickMonopoly:OnClickCallback()
  DataCenter.MonopolyDigTreasureManager:OpenBrick(self.index)
end

return DigMapBrickMonopoly
