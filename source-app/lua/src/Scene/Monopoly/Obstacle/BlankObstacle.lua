local base = require("Scene.Monopoly.Base.BaseObstacle")
local BlankPlaceality = BaseClass("BlankPlaceality", base)

function BlankPlaceality:__delete()
  if self.obstacleRes then
    self.obstacleRes:Destroy()
    self.obstacleRes = nil
  end
  if self.placeality then
    self.placeality:Delete()
    self.placeality = nil
  end
end

return BlankPlaceality
