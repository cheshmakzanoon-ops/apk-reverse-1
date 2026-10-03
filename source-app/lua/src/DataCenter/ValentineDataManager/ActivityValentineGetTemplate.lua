local ActivityValentineGetTemplate = BaseClass("ActivityValentineGetTemplate")

function ActivityValentineGetTemplate:__init()
  self.id = 0
  self.group_id = 0
  self.exchange_box = ""
  self.gift_good = 0
  self.card = 0
  self.require_rank = 0
  self.champion_reward = ""
  self.limit_open = ""
  self.box_reward = 0
  self.box_get_group = 0
  self.pieces = 0
  self.exp = 0
  self.day_first_status = 0
  self.bubble_reward = 0
  self.bubble_times = 0
  self.box_pic = ""
  self.send_activity_id = 0
  self.anime_gift = 0
  self.random_show = ""
  self.small_msg = ""
end

function ActivityValentineGetTemplate:__delete()
  self.id = nil
  self.group_id = nil
  self.exchange_box = nil
  self.gift_good = nil
  self.card = nil
  self.require_rank = nil
  self.champion_reward = nil
  self.limit_open = nil
  self.box_reward = nil
  self.box_get_group = nil
  self.pieces = nil
  self.exp = nil
  self.day_first_status = nil
  self.bubble_reward = nil
  self.bubble_times = nil
  self.box_pic = nil
  self.send_activity_id = nil
  self.anime_gift = nil
  self.random_show = nil
  self.small_msg = nil
end

function ActivityValentineGetTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group_id = rowData:getValue("group_id") or 0
  self.exchange_box = rowData:getValue("exchange_box") or ""
  self.gift_good = rowData:getValue("gift_good") or 0
  self.card = rowData:getValue("card") or 0
  self.require_rank = rowData:getValue("require_rank") or 0
  self.champion_reward = rowData:getValue("champion_reward") or ""
  self.limit_open = rowData:getValue("limit_open") or ""
  self.box_reward = rowData:getValue("box_reward") or 0
  self.box_get_group = rowData:getValue("box_get_group") or 0
  self.pieces = rowData:getValue("pieces") or 0
  self.exp = rowData:getValue("exp") or 0
  self.day_first_status = rowData:getValue("day_first_status") or 0
  self.bubble_reward = rowData:getValue("bubble_reward") or 0
  self.bubble_times = rowData:getValue("bubble_times") or 0
  self.box_pic = rowData:getValue("box_pic") or ""
  self.send_activity_id = tonumber(rowData:getValue("send_activity_id")) or 0
  self.anime_gift = rowData:getValue("anime_gift") or 0
  self.random_show = rowData:getValue("random_show") or ""
  self.small_msg = rowData:getValue("small_msg") or ""
end

function ActivityValentineGetTemplate:GetBoxRewardPropertyInfo()
  local ret = {}
  if not self.random_show then
    return ret
  end
  local strArr = string.split(self.random_show, ";")
  for _, v in ipairs(strArr) do
    table.insert(ret, v)
  end
  return ret
end

return ActivityValentineGetTemplate
