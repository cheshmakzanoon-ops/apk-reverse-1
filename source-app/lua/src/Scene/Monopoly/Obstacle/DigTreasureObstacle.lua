local base = require("Scene.Monopoly.Base.BaseObstacle")
local DigTreasureObstacle = BaseClass("DigTreasureObstacle", base)

function DigTreasureObstacle:__init()
  self.isComplete = false
end

function DigTreasureObstacle:__delete()
  if self.obstacleRes then
    self.obstacleRes:Destroy()
    self.obstacleRes = nil
  end
  if self.placeality then
    self.placeality:Delete()
    self.placeality = nil
  end
  self.isComplete = nil
end

function DigTreasureObstacle:Fire()
  if self.isComplete then
    return
  end
  local mapID = self.data.type_para
  DataCenter.MonopolyDigTreasureManager:CreateMap(mapID, self.data.id)
end

function DigTreasureObstacle:OnEventEnd()
  self.isComplete = true
  if self.tileEffectRes then
    self.tileEffectRes:Destroy()
  end
  if self.battleEffectRes then
    self.battleEffectRes:Destroy()
  end
  self:DestroyObstacleRes()
end

function DigTreasureObstacle:OnTriggerClick()
  base.OnTriggerClick(self)
end

return DigTreasureObstacle
