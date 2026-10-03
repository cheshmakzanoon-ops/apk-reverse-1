local ActivitySlotsInfoTemplate = BaseClass("ActivitySlotsInfoTemplate")

local function __init(self)
  self.id = 0
  self.cost_item = ""
  self.cost_item_multiple = 0
  self.score_reward = ""
  self.score_reward_show = ""
  self.max_daily = 0
  self.pic_rule = ""
  self.groupid = 0
  self.eventid = 0
  self.bp_id = 0
  self.pic_group = 0
  self.costData = {}
  self.scoreRewardData = {}
  self.scoreRewardShowData = {}
  self.cost_1_free = nil
  self.dropshow = 0
  self.big_box_pic = {}
  self.btn_pic = {}
  self.info_btn_pic = ""
  self.exchange_btn_pic = ""
  self.openbox_effect = ""
  self.btn_effect = ""
  self.main_bgcolor = ""
end

local function __delete(self)
  self.id = nil
  self.cost_item = nil
  self.cost_item_multiple = nil
  self.score_reward = nil
  self.score_reward_show = nil
  self.max_daily = nil
  self.pic_rule = nil
  self.groupid = nil
  self.eventid = nil
  self.bp_id = nil
  self.pic_group = nil
  self.costData = nil
  self.scoreRewardData = nil
  self.scoreRewardShowData = nil
  self.cost_1_free = nil
  self.dropshow = nil
  self.big_box_pic = nil
  self.btn_pic = nil
  self.info_btn_pic = nil
  self.exchange_btn_pic = nil
  self.openbox_effect = nil
  self.btn_effect = nil
  self.main_bgcolor = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.cost_item = row:getValue("cost_item") or ""
  self.cost_item_multiple = tonumber(row:getValue("cost_item_multiple")) or 0
  self.score_reward = row:getValue("score_reward") or ""
  self.score_reward_show = row:getValue("score_reward_show") or ""
  self.max_daily = row:getValue("max_daily") or ""
  self.pic_rule = row:getValue("pic_rule") or ""
  self.groupid = tonumber(row:getValue("groupid")) or 0
  self.eventid = tonumber(row:getValue("eventid")) or 0
  self.bp_id = tonumber(row:getValue("bp_id")) or 0
  self.pic_group = tonumber(row:getValue("pic_group")) or 0
  self.cost_1_free = tonumber(row:getValue("cost_1_free")) or 0
  local itemData = string.string2array_num_oneSep(self.cost_item, ";")
  self.costData = {
    type = itemData[1],
    itemId = itemData[2],
    num = itemData[3]
  }
  self.scoreRewardData = string.string2array_i(self.score_reward, ";", "|")
  self.scoreRewardShowData = string.string2array_i(self.score_reward_show, ";", "|")
  self.dropshow = tonumber(row:getValue("dropshow")) or 0
  local big_box_pic = row:getValue("big_box_pic") or ""
  if not string.IsNullOrEmpty(big_box_pic) then
    self.big_box_pic = string.split(big_box_pic, "|")
  end
  local btn_pic = row:getValue("btn_pic") or ""
  if not string.IsNullOrEmpty(btn_pic) then
    self.btn_pic = string.split(btn_pic, "|")
  end
  self.info_btn_pic = row:getValue("info_btn_pic") or ""
  self.exchange_btn_pic = row:getValue("exchange_btn_pic") or ""
  self.openbox_effect = row:getValue("openbox_effect") or ""
  self.btn_effect = row:getValue("btn_effect") or ""
  self.main_bgcolor = row:getValue("main_bgcolor") or ""
end

ActivitySlotsInfoTemplate.__init = __init
ActivitySlotsInfoTemplate.__delete = __delete
ActivitySlotsInfoTemplate.InitData = InitData
return ActivitySlotsInfoTemplate
