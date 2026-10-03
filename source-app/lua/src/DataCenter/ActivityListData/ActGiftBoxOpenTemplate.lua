local ActGiftBoxOpenTemplate = BaseClass("ActGiftBoxOpenTemplate")

local function __init(self)
  self.id = 0
  self.activity = 0
  self.cost_item = 0
  self.cost_1 = 0
  self.cost_1_free = 0
  self.cost_5 = 0
  self.draw_max_daily = 0
  self.box_num = 0
  self.unlock_goods = 0
  self.rank = ""
  self.show_building = 0
  self.add_score = 0
  self.consume_item_score = 0
  self.show_rank = 0
  self.boxopen_id = 0
  self.settings_name = ""
end

local function __delete(self)
  self.id = nil
  self.activity = nil
  self.cost_item = nil
  self.cost_1 = nil
  self.cost_1_free = nil
  self.cost_5 = nil
  self.draw_max_daily = nil
  self.box_num = nil
  self.unlock_goods = nil
  self.rank = nil
  self.show_building = nil
  self.add_score = nil
  self.consume_item_score = nil
  self.show_rank = nil
  self.boxopen_id = nil
  self.settings_name = nil
end

local function InitData(self, row)
  self.id = row:getValue("id")
  self.activity = row:getValue("activity")
  self.cost_item = row:getValue("cost_item")
  self.cost_1 = row:getValue("cost_1")
  self.cost_1_free = tonumber(row:getValue("cost_1_free"))
  self.cost_5 = row:getValue("cost_5")
  self.draw_max_daily = row:getValue("draw_max_daily")
  self.box_num = row:getValue("box_num")
  self.unlock_goods = row:getValue("unlock_goods")
  self.rank = row:getValue("rank") or ""
  self.show_building = row:getValue("show_building") or 0
  self.add_score = row:getValue("add_score") or 0
  self.show_rank = row:getValue("show_rank") or 0
  local str = row:getValue("consume_item_score") or ""
  local strArray = string.split(str, "|")
  self.consume_item_score = tonumber(strArray[2])
  self.boxopen_id = tonumber(row:getValue("boxopen_id")) or 0
  self.settings_name = row:getValue("settings_name")
end

ActGiftBoxOpenTemplate.__init = __init
ActGiftBoxOpenTemplate.__delete = __delete
ActGiftBoxOpenTemplate.InitData = InitData
return ActGiftBoxOpenTemplate
