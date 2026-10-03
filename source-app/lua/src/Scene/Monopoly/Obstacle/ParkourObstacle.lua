local base = require("Scene.Monopoly.Base.BattleObstacleBase")
local ParkourObstacle = BaseClass("ParkourObstacle", base)

function ParkourObstacle:ArrivalBefore()
  if self.data.showCondition == MonplolyObstacleShowCondition.Every then
    if self.obstacle or self.obstacle then
      self.obstacle:Delete()
      self.obstacleRes:Destroy()
    end
    self:CreatedModel()
  end
end

function ParkourObstacle:Fire()
  local param = {}
  param.type = PVEType.Parkour
  param.enterType = PVEEnterType.Monopoly
  param.levelId = tonumber(self.data.type_para)
  param.tryHeroes = self.data.tryHeroes
  param.absoluteBtn = self.data.id <= 7
  DataCenter.LWBattleManager:Enter(param)
end

return ParkourObstacle
