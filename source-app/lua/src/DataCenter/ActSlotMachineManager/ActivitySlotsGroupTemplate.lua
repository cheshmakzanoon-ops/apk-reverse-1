local ActivitySlotsGroupTemplate = BaseClass("ActivitySlotsGroupTemplate")

local function __init(self)
  self.id = 0
  self.groupid = 0
  self.weight = 0
  self.type = 0
  self.block_1 = 0
  self.block_2 = 0
  self.block_3 = 0
  self.reward_show = ""
  self.get_reward_text = ""
end

local function __delete(self)
  self.id = nil
  self.groupid = nil
  self.weight = nil
  self.type = nil
  self.block_1 = nil
  self.block_2 = nil
  self.block_3 = nil
  self.reward_show = nil
  self.get_reward_text = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.groupid = tonumber(row:getValue("groupid")) or 0
  self.weight = tonumber(row:getValue("weight")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.block_1 = tonumber(row:getValue("block_1")) or 0
  self.block_2 = tonumber(row:getValue("block_2")) or 0
  self.block_3 = tonumber(row:getValue("block_3")) or 0
  self.reward_show = row:getValue("reward_show") or ""
  self.get_reward_text = row:getValue("get_reward_text") or ""
end

ActivitySlotsGroupTemplate.__init = __init
ActivitySlotsGroupTemplate.__delete = __delete
ActivitySlotsGroupTemplate.InitData = InitData
return ActivitySlotsGroupTemplate
