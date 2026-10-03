local ActivityHunterShopTemplate = BaseClass("ActivityHunterShopTemplate")

function ActivityHunterShopTemplate:__init()
  self.id = 0
  self.group = 0
  self.reward_id = 0
  self.currency_cost = ""
  self.refresh_type = 0
  self.buy_time_limit = 0
  self.display_order = 0
  self.extra_display = ""
  self.display_type = 0
  self.common_buy_condition = ""
end

function ActivityHunterShopTemplate:__delete()
  self.id = nil
  self.group = nil
  self.reward_id = nil
  self.currency_cost = nil
  self.refresh_type = nil
  self.buy_time_limit = nil
  self.display_order = nil
  self.extra_display = nil
  self.display_type = nil
  self.common_buy_condition = nil
  self.trade_info = nil
end

function ActivityHunterShopTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = rowData:getValue("group") or 0
  self.reward_id = rowData:getValue("reward_id") or 0
  self.currency_cost = rowData:getValue("currency_cost") or ""
  self.refresh_type = rowData:getValue("refresh_type") or 0
  self.buy_time_limit = rowData:getValue("buy_time_limit") or 0
  self.display_order = rowData:getValue("display_order") or 0
  self.extra_display = rowData:getValue("extra_display") or ""
  self.display_type = rowData:getValue("display_type") or 0
  self.common_buy_condition = rowData:getValue("common_buy_condition") or ""
  self.trade_info = rowData:getValue("trade_info") or {}
end

return ActivityHunterShopTemplate
