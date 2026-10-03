local BattleFieldBlockRangeUtil = {}

function BattleFieldBlockRangeUtil.CreateBlockRangeAccessor(luaPrefix)
  local BlockGroup = {}
  local BlockArea = {}
  local api = {}
  
  function api.SetBlockRangeData(idx)
    local data = BlockGroup[idx]
    if data ~= nil then
      BlockArea = data
      return data
    end
    data = require(luaPrefix .. idx)
    BlockGroup[idx] = data
    BlockArea = data
    return data
  end
  
  function api.GetBlockRangeValue(pointId)
    local posV2 = SceneUtils.IndexToTilePos(toInt(pointId), ForceChangeScene.World)
    local data = BlockArea[posV2.y]
    local t = 0
    if data then
      for _, v in ipairs(data) do
        if posV2.x >= v.f and posV2.x <= v.t then
          t = v.i
          break
        end
      end
    end
    return t
  end
  
  function api._GetBlockArea()
    return BlockArea
  end
  
  function api._GetPos(pointId)
    return SceneUtils.IndexToTilePos(toInt(pointId), ForceChangeScene.World)
  end
  
  return api
end

return ConstClass("BattleFieldBlockRangeUtil", BattleFieldBlockRangeUtil)
