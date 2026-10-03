local ActMonopolyTemplate = BaseClass("ActMonopolyTemplate")

local function __init(self)
  self.id = 0
  self.group = 0
  self.order = 0
  self.type = 0
  self.exp = ""
  self.expList = {}
  self.reward = ""
  self.rewardList = {}
  self.event_list_str = ""
  self.eventList = {}
  self.event_list_dropshow_str = ""
  self.eventListDropShow = {}
  self.exhibition = ""
  self.pos = ""
  self.posData = {x = 0, y = 0}
  self.posShowOrder = self.posData.x + self.posData.y
  self.direction = ActMonopolyGridDirType.Left
  self.index = 0
  self.grid_desc = ""
  self.grid_descList = {}
  self.grid_prefab = ""
end

local function __delete(self)
  self.id = nil
  self.group = nil
  self.order = nil
  self.type = nil
  self.exp = nil
  self.expList = nil
  self.reward = nil
  self.rewardList = nil
  self.event_list_str = nil
  self.eventList = nil
  self.event_list_dropshow_str = nil
  self.eventListDropShow = nil
  self.exhibition = nil
  self.pos = nil
  self.posData = nil
  self.posShowOrder = nil
  self.direction = nil
  self.index = nil
  self.grid_desc = nil
  self.grid_descList = nil
  self.grid_prefab = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.group = tonumber(row:getValue("group")) or 0
  self.order = tonumber(row:getValue("order")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.exp = row:getValue("exp")
  if not string.IsNullOrEmpty(self.exp) then
    self.expList = string.string2array_i_oneSep(self.exp)
  end
  self.reward = row:getValue("reward")
  if not string.IsNullOrEmpty(self.reward) then
    self.rewardList = string.string2array_i_oneSep(self.reward)
  end
  self.event_list_str = row:getValue("event_list")
  if not string.IsNullOrEmpty(self.event_list_str) then
    self.eventList = string.string2array_i(self.event_list_str)
  end
  self.event_list_dropshow_str = row:getValue("event_list_dropshow")
  if not string.IsNullOrEmpty(self.event_list_dropshow_str) then
    self.eventListDropShow = string.string2array_i(self.event_list_dropshow_str)
  end
  self.exhibition = row:getValue("exhibition")
  self.pos = row:getValue("pos")
  if not string.IsNullOrEmpty(self.pos) then
    self.posData.x, self.posData.y = string.string2_ii(self.pos, "|")
    self.posShowOrder = self.posData.x + self.posData.y
  end
  self.direction = tonumber(row:getValue("direction")) or ActMonopolyGridDirType.Left
  self.grid_desc = row:getValue("grid_desc") or ""
  self.grid_descList = string.split(self.grid_desc, "|")
  self.grid_prefab = row:getValue("grid_prefab") or ""
end

ActMonopolyTemplate.__init = __init
ActMonopolyTemplate.__delete = __delete
ActMonopolyTemplate.InitData = InitData
return ActMonopolyTemplate
