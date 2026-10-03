local ActivityHunterTemplate = BaseClass("ActivityHunterTemplate")

function ActivityHunterTemplate:__init()
  self.id = 0
  self.group_id = 0
  self.open_condition = ""
  self.activity = 0
  self.cost_id = 0
  self.cost_num = 0
  self.anto_option = 0
  self.select_option = 0
  self.box_exchange = 0
  self.box_reward = 0
  self.max_daily = 0
  self.init_refreshtime = 0
  self.max_refreshtime = 0
  self.time_recoveryspeed = 0
  self.refresh_item = 0
  self.add_score = 0
  self.score_reward = ""
  self.score_reward_show = ""
  self.stageid = 0
  self.eventid = 0
  self.monster_group = 0
  self.shopid = 0
  self.dropshow = 0
  self.para_group = 0
  self.broadcast_id = ""
  self.reward_show = ""
  self.daily_mailid = ""
  self.first_effect = ""
  self.guide_group = ""
end

function ActivityHunterTemplate:__delete()
  self.id = nil
  self.group_id = nil
  self.open_condition = nil
  self.activity = nil
  self.cost_id = nil
  self.cost_num = nil
  self.anto_option = nil
  self.select_option = nil
  self.box_exchange = nil
  self.box_reward = nil
  self.max_daily = nil
  self.init_refreshtime = nil
  self.max_refreshtime = nil
  self.time_recoveryspeed = nil
  self.refresh_item = nil
  self.add_score = nil
  self.score_reward = nil
  self.score_reward_show = nil
  self.stageid = nil
  self.eventid = nil
  self.monster_group = nil
  self.shopid = nil
  self.dropshow = nil
  self.para_group = nil
  self.broadcast_id = nil
  self.reward_show = nil
  self.daily_mailid = nil
  self.first_effect = nil
  self.guide_group = nil
end

function ActivityHunterTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group_id = rowData:getValue("group_id") or 0
  self.open_condition = rowData:getValue("open_condition") or ""
  self.activity = rowData:getValue("activity") or 0
  self.cost_id = rowData:getValue("cost_id") or 0
  self.cost_num = rowData:getValue("cost_num") or 0
  self.anto_option = rowData:getValue("anto_option") or 0
  self.select_option = rowData:getValue("select_option") or 0
  self.box_exchange = rowData:getValue("box_exchange") or 0
  self.box_reward = rowData:getValue("box_reward") or 0
  self.max_daily = rowData:getValue("max_daily") or 0
  self.init_refreshtime = rowData:getValue("init_refreshtime") or 0
  self.max_refreshtime = rowData:getValue("max_refreshtime") or 0
  self.time_recoveryspeed = rowData:getValue("time_recoveryspeed") or 0
  self.refresh_item = rowData:getValue("refresh_item") or 0
  self.add_score = rowData:getValue("add_score") or 0
  self.score_reward = rowData:getValue("score_reward") or ""
  self.score_reward_show = rowData:getValue("score_reward_show") or ""
  self.stageid = rowData:getValue("stageid") or 0
  self.eventid = rowData:getValue("eventid") or 0
  self.monster_group = rowData:getValue("monster_group") or 0
  self.shopid = rowData:getValue("shopid") or 0
  self.dropshow = rowData:getValue("dropshow") or 0
  self.para_group = rowData:getValue("para_group") or 0
  self.broadcast_id = rowData:getValue("broadcast_id") or ""
  self.reward_show = rowData:getValue("reward_show") or ""
  self.daily_mailid = rowData:getValue("daily_mailid") or ""
  self.first_effect = rowData:getValue("first_effect") or ""
  self.guide_group = rowData:getValue("guide_group") or ""
end

return ActivityHunterTemplate
