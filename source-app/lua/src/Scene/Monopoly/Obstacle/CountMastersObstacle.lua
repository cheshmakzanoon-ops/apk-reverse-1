local base = require("Scene.Monopoly.Base.BattleObstacleBase")
local CountMastersObstacle = BaseClass("CountMastersObstacle", base)

function CountMastersObstacle:ArrivalBefore()
  if self.data.showCondition == MonplolyObstacleShowCondition.Every then
    if self.obstacle or self.obstacle then
      self.obstacle:Delete()
      self.obstacleRes:Destroy()
    end
    self:CreatedModel()
  end
end

function CountMastersObstacle:Fire()
  local param = {}
  param.type = PVEType.Count
  param.enterType = PVEEnterType.Monopoly
  param.levelId = tonumber(self.data.type_para)
  DataCenter.LWBattleManager:Enter(param)
end

return CountMastersObstacle
