local T11IdleGameEventTemplate = BaseClass("T11IdleGameEventTemplate")

function T11IdleGameEventTemplate:__init()
  self.id = 0
  self.event_type = 0
  self.quest_id = ""
  self.event_reward = ""
  self.event_character = ""
  self.battle_army = ""
  self.share_id = ""
  self.start_plot = ""
  self.end_plot = ""
  self.special_quest_name = ""
  self.normal_short_desc = ""
  self.long_desc = ""
  self.quest_para = ""
end

function T11IdleGameEventTemplate:__delete()
  self.id = nil
  self.event_type = nil
  self.quest_id = nil
  self.event_reward = nil
  self.event_character = nil
  self.battle_army = nil
  self.share_id = nil
  self.start_plot = nil
  self.end_plot = nil
  self.special_quest_name = nil
  self.normal_short_desc = nil
  self.long_desc = nil
  self.quest_para = nil
end

function T11IdleGameEventTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.event_type = rowData:getValue("event_type") or 0
  self.quest_id = rowData:getValue("quest_id") or ""
  self.event_reward = rowData:getValue("event_reward") or ""
  self.event_character = rowData:getValue("event_character") or ""
  self.battle_army = rowData:getValue("battle_army") or ""
  self.share_id = rowData:getValue("share_id") or ""
  self.start_plot = rowData:getValue("start_plot") or ""
  self.end_plot = rowData:getValue("end_plot") or ""
  self.special_quest_name = rowData:getValue("special_quest_name") or ""
  self.normal_short_desc = rowData:getValue("normal_short_desc") or ""
  self.long_desc = rowData:getValue("long_desc") or ""
  self.quest_para = rowData:getValue("quest_para") or ""
end

return T11IdleGameEventTemplate
