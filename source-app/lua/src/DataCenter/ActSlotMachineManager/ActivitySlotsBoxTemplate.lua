local ActivitySlotsBoxTemplate = BaseClass("ActivitySlotsBoxTemplate")

local function __init(self)
  self.id = 0
  self.groupid = 0
  self.boxid = 0
  self.box_reward = ""
  self.name = ""
  self.weight = 0
  self.rate_show = 0
  self.box_reward_rate_show = {}
  self.box_para2 = ""
  self.box_reward_show_para1 = ""
  self.box_reward_show_para2 = ""
end

local function __delete(self)
  self.id = nil
  self.groupid = nil
  self.boxid = nil
  self.box_reward = nil
  self.name = nil
  self.weight = nil
  self.rate_show = nil
  self.box_reward_rate_show = nil
  self.box_para2 = ""
  self.box_reward_show_para1 = ""
  self.box_reward_show_para2 = ""
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.groupid = tonumber(row:getValue("groupid")) or 0
  self.boxid = tonumber(row:getValue("boxid")) or 0
  self.box_reward = row:getValue("box_reward") or ""
  self.name = row:getValue("name") or ""
  self.weight = tonumber(row:getValue("weight")) or 0
  self.rate_show = tonumber(row:getValue("rate_show")) or 0
  local box_reward_rate_show = row:getValue("box_reward_rate_show") or ""
  if not string.IsNullOrEmpty(box_reward_rate_show) then
    self.box_reward_rate_show = string.string2array_num_oneSep(box_reward_rate_show, "|")
  end
  self.box_para2 = row:getValue("box_para2") or ""
  self.box_reward_show_para1 = row:getValue("box_reward_show_para1") or ""
  self.box_reward_show_para2 = row:getValue("box_reward_show_para2") or ""
end

ActivitySlotsBoxTemplate.__init = __init
ActivitySlotsBoxTemplate.__delete = __delete
ActivitySlotsBoxTemplate.InitData = InitData
return ActivitySlotsBoxTemplate
