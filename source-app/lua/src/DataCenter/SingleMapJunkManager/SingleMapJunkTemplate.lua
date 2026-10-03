local SingleMapJunkTemplate = BaseClass("SingleMapJunkTemplate")

local function __init(self)
  self.id = 0
  self.name = ""
  self.description = ""
  self.show = ""
  self.scale = {}
  self.radius = 0
  self.time = 0
  self.dialog = 0
  self.action = 0
  self.reward = ""
  self.type = 0
  self.pic = ""
  self.rewardNew = 0
  self.cycleTime = 0
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.description = nil
  self.show = nil
  self.scale = nil
  self.radius = nil
  self.time = nil
  self.dialog = nil
  self.action = nil
  self.reward = nil
  self.type = nil
  self.pic = nil
  self.rewardNew = nil
  self.cycleTime = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("Name")
  self.description = row:getValue("Desc")
  self.show = row:getValue("Desc")
  local scaleStr = string.split(row:getValue("Scale"), ",")
  self.scale = Vector2.New(tonumber(scaleStr[1]), tonumber(scaleStr[2]))
  self.radius = tonumber(row:getValue("Radius"))
  self.time = tonumber(row:getValue("Time"))
  self.dialog = tonumber(row:getValue("Dialog"))
  self.action = tonumber(row:getValue("Action"))
  self.reward = row:getValue("Reward")
  self.type = tonumber(row:getValue("Type"))
  self.pic = row:getValue("pic") or ""
  self.rewardNew = tonumber(row:getValue("Reward_New"))
  self.cycleTime = tonumber(row:getValue("CycleTime"))
end

SingleMapJunkTemplate.__init = __init
SingleMapJunkTemplate.__delete = __delete
SingleMapJunkTemplate.InitData = InitData
return SingleMapJunkTemplate
