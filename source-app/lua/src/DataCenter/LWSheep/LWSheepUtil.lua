local LWSheepUtil = {}
LWSheepUtil.GAME_TEMP_WIDTH = 3
LWSheepUtil.GAME_TEMP_HEIGHT = 4
local HEIGHT_ID = 1000000
local Y_ID = 1000

function LWSheepUtil.PosXYToFloorId(x, y)
  return y * Y_ID + x
end

function LWSheepUtil.PosXYZToGridID(x, y, height)
  return height * HEIGHT_ID + y * Y_ID + x
end

function LWSheepUtil.GridIDToHeightGridID(gridId, height)
  return gridId % HEIGHT_ID + height * HEIGHT_ID
end

function LWSheepUtil.GridIDToHeight(id)
  return math.floor(id / HEIGHT_ID)
end

function LWSheepUtil.GridIDToXY(gridId)
  return gridId % HEIGHT_ID
end

function LWSheepUtil.PosXYToTempID(posX, floor)
  return floor * LWSheepUtil.GAME_TEMP_WIDTH + posX
end

function LWSheepUtil.TempIDToPosXY(tempId)
  local x = (tempId - 1) % LWSheepUtil.GAME_TEMP_WIDTH
  x = x + 1
  local y = toInt((tempId - x) / LWSheepUtil.GAME_TEMP_WIDTH)
  return x, y
end

return ConstClass("LWSheepUtil", LWSheepUtil)
