local AllyDrillRoadHogMeta = BaseClass("AllyDrillRoadHogMeta")

local function __init(self)
  self.id = 0
end

local function __delete(self)
  self.id = nil
end

function AllyDrillRoadHogMeta:InitConfig(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.level = tonumber(row:getValue("level")) or 0
  self.difficulty = self.level
  self.monsterId = tonumber(row:getValue("monsterId")) or 0
  self.name = tonumber(row:getValue("name")) or 0
  self.digging_game = tonumber(row:getValue("digging_game")) or 16001
  local donate_level = row:getValue("donate_level")
  donate_level = string.split(donate_level, "|")
  self.donate_level = {}
  for i = 1, #donate_level do
    local donate = string.split(donate_level[i], ";")
    self.donate_level[i] = tonumber(donate[2])
  end
  local donate_level_bonus = row:getValue("donate_level_bouns")
  donate_level_bonus = string.split(donate_level_bonus, "|")
  self.donate_level_bonus = {}
  for i = 1, #donate_level_bonus do
    local donate = string.split(donate_level_bonus[i], ";")
    self.donate_level_bonus[i] = tonumber(donate[2])
  end
  local unlock_condition = row:getValue("unlock_condition")
  self.unlock_condition = unlock_condition
  unlock_condition = string.split(unlock_condition, "|")
  for i = 1, #unlock_condition do
    local unlock = string.split(unlock_condition[i], ";")
    local condition = tonumber(unlock[1])
    if condition == 1 then
    elseif condition == 2 then
      self.unlockLevelLimit = tonumber(unlock[2])
      self.unlockStageLimit = tonumber(unlock[3])
    end
  end
  local alliance_bonus = row:getValue("alliance_bonus")
  alliance_bonus = string.split(alliance_bonus, "|")
  self.alliance_bonus = {}
  for i = 1, #alliance_bonus do
    local bonus = string.split(alliance_bonus[i], ";")
    local range = string.split(bonus[1], "-")
    self.alliance_bonus[i] = {
      min = tonumber(range[1]),
      max = tonumber(range[2]),
      bonus = tonumber(bonus[2])
    }
  end
  self.show_condition = tonumber(row:getValue("show_condition")) or 0
  self.isConfirm = (tonumber(row:getValue("is_confirm")) or 0) == 1
  self.stage = row:getValue("stage") or 1
end

AllyDrillRoadHogMeta.__init = __init
AllyDrillRoadHogMeta.__delete = __delete
return AllyDrillRoadHogMeta
