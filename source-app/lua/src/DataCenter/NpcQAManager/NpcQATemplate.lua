local NpcQATemplate = BaseClass("NpcQATemplate")

local function __init(self)
  self.id = 0
  self.type = 0
  self.question = ""
  self.answers = {}
  self.answer = ""
  self.fraction = 0
  self.level = ""
  self.reward_true = {}
end

local function __delete(self)
  self.id = nil
  self.type = nil
  self.question = nil
  self.answers = nil
  self.answer = nil
  self.fraction = nil
  self.level = nil
  self.reward_true = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.type = row:getValue("type")
  self.question = row:getValue("question")
  self.answers = row:getValue("answers")
  self.answer = row:getValue("answer")
  self.fraction = row:getValue("fraction")
  self.level = row:getValue("level")
  if string.IsNullOrEmpty(self.level) then
    self.showMinLv = 0
    self.showMaxLv = IntMaxValue
  else
    local vec = string.split(self.level, "-")
    if table.count(vec) == 2 then
      self.showMinLv = toInt(vec[1])
      self.showMaxLv = toInt(vec[2])
    else
      self.showMinLv = 0
      self.showMaxLv = IntMaxValue
    end
  end
  local rewardStr = row:getValue("reward_true") or ""
  local vec = string.split(rewardStr, "|")
  for _, v in ipairs(vec) do
    local tmpVec = string.split(v, ";")
    local reward = {}
    reward.rewardType = RewardType.GOODS
    reward.count = toInt(tmpVec[2])
    reward.itemId = toInt(tmpVec[1])
    table.insert(self.reward_true, reward)
  end
end

local function IsValid(self)
  local mainLv = DataCenter.BuildManager.MainLv
  return mainLv >= self.showMinLv and mainLv <= self.showMaxLv
end

NpcQATemplate.__init = __init
NpcQATemplate.__delete = __delete
NpcQATemplate.InitData = InitData
NpcQATemplate.IsValid = IsValid
return NpcQATemplate
