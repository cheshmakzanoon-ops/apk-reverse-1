local base = require("Scene.Monopoly.Base.BattleObstacleBase")
local EmigratedObstacle = BaseClass("EmigratedObstacle", base)

function EmigratedObstacle:Fire()
  local stateId = tonumber(self.data.type_para)
  local curChapter = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), stateId, "group")
  if curChapter then
    DataCenter.ZombieBattleManager:Destroy()
    local param = {}
    param.type = PVEType.Barrage
    param.enterType = PVEEnterType.Monopoly
    param.levelId = stateId
    param.levelGroupId = curChapter
    DataCenter.ZombieBattleManager:Enter(param)
  else
    Logger.LogError("\230\142\168\229\155\190\229\133\179\229\141\161\228\184\141\229\173\152\229\156\168    : " .. stateId)
  end
end

return EmigratedObstacle
