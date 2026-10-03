local LWSheepCard = BaseClass("LWSheepCard")
local LWSheepUtil = require("DataCenter.LWSheep.LWSheepUtil")
local GAME_TEMPORARY_MAX_COUNT = 3
local GAME_TEMPORARY_DEPTH_COUNT = 6

function LWSheepCard:__init()
  self.gridId = 0
  self.pos = {
    x = 0,
    y = 0,
    z = 0
  }
  self.offset = {x = 0, y = 0}
  self.pictureId = 0
  self.occGridList = {}
  self.tempId = nil
  self.cardWidth = 0
  self.cardHeight = 0
end

function LWSheepCard:__delete()
  self.id = nil
  self.pos = nil
  self.offset = nil
  self.pictureId = nil
  self.occGridList = nil
  self.tempId = nil
  self.cardWidth = nil
  self.cardHeight = nil
end

function LWSheepCard:Bind(gridId, x, y, height, offsetX, offsetY, pictureId, cardWidth, cardHeight)
  self.tempId = nil
  self.gridId = gridId
  self.pos.x = x
  self.pos.y = y
  self.pos.z = height
  self.offset.x = offsetX
  self.offset.y = offsetY
  self.pictureId = pictureId
  self.cardWidth = cardWidth
  self.cardHeight = cardHeight
  self.occGridList = {
    [self.gridId] = false,
    [LWSheepUtil.PosXYZToGridID(x + 1, y, height)] = false,
    [LWSheepUtil.PosXYZToGridID(x, y + 1, height)] = false,
    [LWSheepUtil.PosXYZToGridID(x + 1, y + 1, height)] = false
  }
  if self.pos.x == 3 and self.pos.y == 2 and self.pos.z == 5 then
    local aaa = 1
  end
  GAME_TEMPORARY_MAX_COUNT = tonumber(DataCenter.LWSheepDataManager:GetActivityData().para_4)
  GAME_TEMPORARY_DEPTH_COUNT = tonumber(DataCenter.LWSheepDataManager:GetActivityData().para_5)
end

function LWSheepCard:BindTempId(tempId)
  self.tempId = tempId
end

function LWSheepCard:ForEachSetOcc(callback)
  for k, _ in pairs(self.occGridList) do
    self.occGridList[k] = callback(k)
  end
end

function LWSheepCard:IsOcc(gridId)
  return self.occGridList[gridId] ~= nil
end

function LWSheepCard:SetOccGridList(gridId, value)
  local toLock = self:IsOcc(gridId)
  if toLock then
    self.occGridList[gridId] = value
  end
end

function LWSheepCard:IsVisual()
  for _, v in pairs(self.occGridList) do
    if v then
      return false
    end
  end
  return true
end

function LWSheepCard:GetUIPosInGameArena()
  local x = self.pos.x * self.cardWidth + self.offset.x * self.cardWidth * 0.2
  local y = self.pos.y * self.cardHeight + self.offset.y * self.cardHeight * 0.2
  return {x = x, y = y}
end

function LWSheepCard:GetUIPosXInRemoveArena(index)
  return (index - 1) * 2 * self.cardWidth
end

function LWSheepCard:GetUIPosXInTempArena()
  if self.tempId == nil then
    return 0
  end
  local x = (self.tempId - 1) % GAME_TEMPORARY_MAX_COUNT
  x = x + 1
  local y = toInt((self.tempId - x) / GAME_TEMPORARY_MAX_COUNT)
  return (x - 2 + y * 0.1) * (self.cardWidth + 150)
end

function LWSheepCard:GetPosToServer()
  return string.format("%d_%d_%d", self.pos.x, self.pos.y, self.pos.z)
end

function LWSheepCard:SamePos(pos)
  return self.pos.x == pos.x and self.pos.y == pos.y and self.pos.z == pos.z
end

return LWSheepCard
