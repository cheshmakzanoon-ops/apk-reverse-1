local ActMonopolyParaTemplate = BaseClass("ActMonopolyParaTemplate")

local function __init(self)
  self.id = 0
  self.para6 = ""
  self.para8 = ""
  self.para9 = 0
  self.event_key = ""
  self.event_para = ""
  self.drop_show_id = 0
  self.item_add_score = ""
  self.grid_add_score = ""
  self.ext_key = ""
  self.usebox_list = {}
  self.shop_icon = ""
  self.para13 = ""
  self.party_empty = ""
  self.get_jindu = ""
  self.gold_icon = ""
  self.dropshow_title = ""
  self.task_progress_para = ""
  self.shop_text_color = ""
  self.trigger_effect = {}
  self.scenePath = ""
end

local function __delete(self)
  self.id = nil
  self.para6 = nil
  self.para8 = nil
  self.para9 = nil
  self.event_key = nil
  self.event_para = nil
  self.drop_show_id = nil
  self.item_add_score = nil
  self.grid_add_score = nil
  self.ext_key = nil
  self.usebox_list = nil
  self.shop_icon = nil
  self.para13 = nil
  self.party_empty = nil
  self.get_jindu = nil
  self.gold_icon = nil
  self.dropshow_title = nil
  self.task_progress_para = nil
  self.shop_text_color = nil
  self.trigger_effect = nil
  self.scenePath = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.para6 = row:getValue("para6") or ""
  self.para8 = row:getValue("para8") or ""
  self.para9 = tonumber(row:getValue("para9")) or 0
  self.para13 = row:getValue("para13") or ""
  self.para14 = row:getValue("para14") or ""
  self.para15 = row:getValue("para15") or ""
  self.party_empty = row:getValue("party_empty") or ""
  self.event_key = row:getValue("event_key") or ""
  self.event_para = row:getValue("event_para") or ""
  self.drop_show_id = tonumber(row:getValue("drop_show_id")) or 0
  self.item_add_score = row:getValue("item_add_score") or ""
  self.grid_add_score = row:getValue("grid_add_score") or ""
  self.ext_key = row:getValue("ext_key") or ""
  self.shop_icon = row:getValue("shop_icon") or ""
  self.get_jindu = row:getValue("get_jindu") or ""
  self.gold_icon = row:getValue("gold_icon") or ""
  self.dropshow_title = row:getValue("dropshow_title") or ""
  self.task_progress_para = row:getValue("task_progress_para") or ""
  self.shop_text_color = row:getValue("shop_text_color") or ""
  local usebox_list_str = row:getValue("usebox_list") or ""
  if not string.IsNullOrEmpty(usebox_list_str) then
    self.usebox_list = string.string2array_num_oneSep(usebox_list_str, "|")
  end
  self.trigger_effect = row:getValue("trigger_effect") or {}
  self.scenePath = row:getValue("scence") or ""
end

ActMonopolyParaTemplate.__init = __init
ActMonopolyParaTemplate.__delete = __delete
ActMonopolyParaTemplate.InitData = InitData
return ActMonopolyParaTemplate
