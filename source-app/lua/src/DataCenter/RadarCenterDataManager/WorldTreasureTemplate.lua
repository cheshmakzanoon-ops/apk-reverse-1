local WorldTreasureTemplate = BaseClass("WorldTreasureTemplate")

local function __init(self)
end

local function __delete(self)
  self.id = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.type = row:getValue("type")
  self.size = row:getValue("size")
  self.max_reward_times = row:getValue("max_reward_times")
  self.expire_time = row:getValue("expire_time")
  self.daily_max = tonumber(row:getValue("daily_max"))
  self.name = row:getValue("name")
  self.desc = row:getValue("desc")
end

WorldTreasureTemplate.__init = __init
WorldTreasureTemplate.__delete = __delete
WorldTreasureTemplate.InitData = InitData
return WorldTreasureTemplate
