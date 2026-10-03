local ActivityThanksgivingTemplate = BaseClass("ActivityThanksgivingTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.activity_drop = 0
  self.thxgiv_acc = ""
  self.thxgiv_acc_show = ""
  self.give_item = 0
  self.merge_cost_item = ""
  self.merge_gain_item = ""
  self.give_cost_item = ""
  self.give_day_limit = 0
  self.day_receive_num = 0
  self.thxgiv_key1 = ""
  self.thxgiv_key2 = ""
  self.thxgiv_key3 = ""
  self.thxgiv_acc_tab = {}
  self.thxgiv_acc_show_tab = {}
  self.merge_cost_item_tab = {}
  self.merge_gain_item_tab = {}
  self.give_cost_item_tab = {}
  self.owner_give_item_tab = {}
  self.teach_show_tab = {}
end

local function __delete(self)
  self.id = nil
  self.activity_drop = nil
  self.thxgiv_acc = nil
  self.thxgiv_acc_show = nil
  self.give_item = nil
  self.merge_cost_item = nil
  self.merge_gain_item = nil
  self.give_cost_item = nil
  self.give_day_limit = nil
  self.day_receive_num = nil
  self.thxgiv_key1 = nil
  self.thxgiv_key2 = nil
  self.thxgiv_key3 = nil
  self.thxgiv_acc_tab = nil
  self.thxgiv_acc_show_tab = nil
  self.merge_cost_item_tab = nil
  self.merge_gain_item_tab = nil
  self.give_cost_item_tab = nil
  self.owner_give_item_tab = nil
  self.teach_show_tab = nil
end

local function InitConfig(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.activity_drop = tonumber(row:getValue("activity_drop")) or 0
  self.thxgiv_acc = row:getValue("thxgiv_acc") or ""
  self.thxgiv_acc_show = row:getValue("thxgiv_acc_show") or ""
  self.give_item = tonumber(row:getValue("give_item")) or 0
  self.merge_cost_item = row:getValue("merge_cost_item") or ""
  self.merge_gain_item = row:getValue("merge_gain_item") or ""
  self.give_cost_item = row:getValue("give_cost_item") or ""
  self.give_day_limit = tonumber(row:getValue("give_day_limit")) or 0
  self.day_receive_num = tonumber(row:getValue("day_receive_num")) or 0
  self.thxgiv_key1 = row:getValue("thxgiv_key1") or ""
  self.thxgiv_key2 = row:getValue("thxgiv_key2") or ""
  self.thxgiv_key3 = row:getValue("thxgiv_key3") or ""
  if not string.IsNullOrEmpty(self.thxgiv_acc) then
    self.thxgiv_acc_tab = string.string2array_i(self.thxgiv_acc, ";", "|")
  end
  if not string.IsNullOrEmpty(self.thxgiv_acc_show) then
    local strData = string.split(self.thxgiv_acc_show, ",")
    self.thxgiv_acc_show_tab = {}
    for i, v in ipairs(strData) do
      self.thxgiv_acc_show_tab[i] = string.string2array_i(v, ";", "|")
    end
  end
  if not string.IsNullOrEmpty(self.merge_cost_item) then
    self.merge_cost_item_tab = string.string2array_i_oneSep(self.merge_cost_item, ";")
  end
  if not string.IsNullOrEmpty(self.merge_gain_item) then
    self.merge_gain_item_tab = string.string2array_i_oneSep(self.merge_gain_item, ";")
  end
  if not string.IsNullOrEmpty(self.give_cost_item) then
    self.give_cost_item_tab = string.string2array_i_oneSep(self.give_cost_item, ";")
  end
  local owner_give_item = row:getValue("owner_give_item") or ""
  if not string.IsNullOrEmpty(owner_give_item) then
    self.owner_give_item_tab = string.string2array_i_oneSep(owner_give_item, ";")
  end
  local teachShow = row:getValue("teachShow") or ""
  if not string.IsNullOrEmpty(teachShow) then
    self.teach_show_tab = string.split(teachShow, "|")
  end
end

ActivityThanksgivingTemplate.__init = __init
ActivityThanksgivingTemplate.__delete = __delete
ActivityThanksgivingTemplate.InitConfig = InitConfig
return ActivityThanksgivingTemplate
