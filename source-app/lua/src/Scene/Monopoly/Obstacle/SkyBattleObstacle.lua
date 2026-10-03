local base = require("Scene.Monopoly.Base.BattleObstacleBase")
local SkyBattleObstacle = BaseClass("SkyBattleObstacle", base)

function SkyBattleObstacle:ArrivalBefore()
  if self.data.showCondition == MonplolyObstacleShowCondition.Every then
    if self.obstacle then
      self.obstacle:Delete()
    end
    if self.obstacleRes then
      self.obstacleRes:Destroy()
    end
    self:CreatedModel()
  end
end

function SkyBattleObstacle:Fire()
  local param = {}
  param.type = PVEType.SkyBattle
  param.enterType = PVEEnterType.Monopoly
  param.levelId = tonumber(self.data.type_para)
  DataCenter.LWBattleManager:Enter(param)
end

return SkyBattleObstacle
