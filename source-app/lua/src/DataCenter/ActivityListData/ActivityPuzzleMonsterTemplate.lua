local ActivityPuzzleMonsterTemplate = BaseClass("ActivityPuzzleMonsterTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.name = 0
  self.id = 0
  self.monsterId = 0
  self.rewardShow = ""
  self.consumeType = ConsumeType.ConsumeType_Nil
  self.consumeId = 0
  self.consumeNum = 0
  self.color = ""
  self.unlock = ""
  self.reward_detail = ""
end

local function __delete(self)
  self.name = nil
  self.id = nil
  self.monsterId = nil
  self.rewardShow = nil
  self.color = nil
end

local function InitData(self, row)
  self.id = row:getValue("id")
  self.name = row:getValue("name")
  self.monsterId = row:getValue("monster_id")
  self.rewardShow = row:getValue("reward_show")
  self.color = row:getValue("color")
  self.unlock = toInt(row:getValue("unlock")) or 0
  self.reward_detail = row:getValue("reward_detail") or ""
  local consumeStr = row:getValue("consume") or ""
  if string.IsNullOrEmpty(consumeStr) then
    self.consumeType = ConsumeType.ConsumeType_Nil
  else
    local vec = string.split(consumeStr, ";")
    if table.count(vec) == 3 then
      self.consumeType = toInt(vec[1])
      self.consumeId = toInt(vec[2])
      self.consumeNum = toInt(vec[3])
    else
      self.consumeType = ConsumeType.ConsumeType_Nil
    end
  end
end

ActivityPuzzleMonsterTemplate.__init = __init
ActivityPuzzleMonsterTemplate.__delete = __delete
ActivityPuzzleMonsterTemplate.InitData = InitData
return ActivityPuzzleMonsterTemplate
