local base = require("UI.DigMap.DigMapBrick")
local DigMapBrickDetect = BaseClass("DigMapBrickDetect", base)

function DigMapBrickDetect:OnClickCallback()
  DataCenter.DetectDigTreasureManager:OpenBrick(self.index)
end

return DigMapBrickDetect
