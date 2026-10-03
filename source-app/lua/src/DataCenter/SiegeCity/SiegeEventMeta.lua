local SiegeEventMeta = BaseClass("SiegeEventMeta")

local function __init(self)
end

local function __delete(self)
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("name")
  self.desc = row:getValue("desc")
  self.condition = row:getValue("condition")
  self.condition_para = row:getValue("condition_para")
  local reward_show = row:getValue("reward_show")
  reward_show = string.split(reward_show, ";")
  self.reward_show = {
    id = tonumber(reward_show[1]),
    type = tonumber(reward_show[2]),
    count = tonumber(reward_show[3])
  }
end

SiegeEventMeta.__init = __init
SiegeEventMeta.__delete = __delete
SiegeEventMeta.InitData = InitData
return SiegeEventMeta
