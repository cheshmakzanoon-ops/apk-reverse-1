local GiftPackTemplate = BaseClass("GiftPackTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.productID = ""
  self.lineData = {}
end

local function __delete(self)
  self.id = nil
  self.productID = nil
  self.lineData = nil
end

local function DefaultValueTonil(value)
  if value == nil then
    return nil
  end
  if type(value) == "string" and string.IsNullOrEmpty(value) then
    return nil
  elseif type(value) == "number" and value == 0 then
    return nil
  end
  return value
end

local function InitConfig(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.productID = DefaultValueTonil(row:getValue("product_id"))
  self.type = DefaultValueTonil(row:getValue("type"))
  self.dollar = DefaultValueTonil(row:getValue("dollar"))
  self.gold_doller = DefaultValueTonil(row:getValue("gold_doller"))
  self.gold_brick_doller = DefaultValueTonil(row:getValue("gold_brick_doller"))
  self.name = DefaultValueTonil(row:getValue("name"))
  self.gift = DefaultValueTonil(row:getValue("gift"))
  self.item = DefaultValueTonil(row:getValue("item"))
  self.equip = DefaultValueTonil(row:getValue("equip"))
  self.resource = DefaultValueTonil(row:getValue("resource"))
  self.resource_item = DefaultValueTonil(row:getValue("resource_item"))
  self.equipment = DefaultValueTonil(row:getValue("equipment"))
  self.percent = DefaultValueTonil(row:getValue("percent"))
  self.price = DefaultValueTonil(row:getValue("price"))
  self.popup_image_mini_band = DefaultValueTonil(row:getValue("popup_image_mini_band"))
  self.popup_image = DefaultValueTonil(row:getValue("popup_image"))
  self.popup = DefaultValueTonil(row:getValue("popup"))
  self.time = DefaultValueTonil(row:getValue("time"))
  self.time_type = DefaultValueTonil(row:getValue("time_type"))
  self.popup_image_mini = DefaultValueTonil(row:getValue("popup_image_mini"))
  self.is_show = DefaultValueTonil(row:getValue("is_show"))
  self.description = DefaultValueTonil(row:getValue("description"))
  self.show_type = DefaultValueTonil(row:getValue("show_type"))
  self.platform = DefaultValueTonil(row:getValue("platform"))
  self.product_id_ios = DefaultValueTonil(row:getValue("product_id_ios"))
  self.item_combine = DefaultValueTonil(row:getValue("item_combine"))
  self.group = DefaultValueTonil(row:getValue("group"))
  self.item_use = DefaultValueTonil(row:getValue("item_use"))
  self.confirm = DefaultValueTonil(row:getValue("confirm"))
  self.reward = DefaultValueTonil(row:getValue("reward"))
  self.if_buy = DefaultValueTonil(row:getValue("if_buy"))
  self.image_show = DefaultValueTonil(row:getValue("image_show"))
  self.product_id_google = DefaultValueTonil(row:getValue("product_id_google"))
  self.buy_times = DefaultValueTonil(row:getValue("buy_times"))
  self.hero = DefaultValueTonil(row:getValue("hero"))
  self.hero_combine = DefaultValueTonil(row:getValue("hero_combine"))
  self.popup_week = DefaultValueTonil(row:getValue("popup_week"))
  self.popup_image_h = DefaultValueTonil(row:getValue("popup_image_h"))
  self.popup_image_b = DefaultValueTonil(row:getValue("popup_image_b"))
  self.recharge_point = DefaultValueTonil(row:getValue("recharge_point"))
  self.sub_name = DefaultValueTonil(row:getValue("sub_name"))
  self.best_buy = DefaultValueTonil(row:getValue("best_buy"))
  self.image_mini_quality = DefaultValueTonil(row:getValue("image_mini_quality"))
  self.prefab_name = DefaultValueTonil(row:getValue("prefab_name"))
  self.lack_pic = DefaultValueTonil(row:getValue("lack_pic"))
  self.buy_type = row:getValue("buy_type") or 0
  self.buy_reward = row:getValue("buy_reward") or {}
  self.buy_type_cost = row:getValue("buy_type_cost") or {}
  self.nextgift = row:getValue("nextgift") or ""
  self.forwardgift = row:getValue("forwardgift") or ""
  self.buy_type_cost_type = self.buy_type_cost[2]
  self.buy_type_cost_num = self.buy_type_cost[3]
  local allianceGiftStr = row:getValue("alliance_gift") or ""
  if string.IsNullOrEmpty(allianceGiftStr) then
    self.giftData = nil
  else
    local giftDataList = {}
    local arr = string.split(allianceGiftStr, "|")
    if not table.IsNullOrEmpty(arr) then
      for i = 1, #arr do
        local giftId = tonumber(arr[i])
        local icon = GetTableData(TableName.AllianceGiftGroup, giftId, "icon")
        local name = GetTableData(TableName.AllianceGiftGroup, giftId, "name")
        local title = GetTableData(TableName.AllianceGiftGroup, giftId, "title")
        local color = GetTableData(TableName.AllianceGiftGroup, giftId, "color")
        local str = string.format("%s;%s;%s;1;%s", icon, name, title, color)
        table.insert(giftDataList, str)
      end
    end
    self.giftData = giftDataList
  end
  self.common_buy_condition = DefaultValueTonil(row:getValue("common_buy_condition"))
  self.can_refund = DefaultValueTonil(row:getValue("can_refund"))
  self.preview_info_group = row:getValue("preview_info_group") or 0
  self.alert_condition = DefaultValueTonil(row:getValue("alert_condition"))
end

GiftPackTemplate.__init = __init
GiftPackTemplate.__delete = __delete
GiftPackTemplate.InitConfig = InitConfig
return GiftPackTemplate
