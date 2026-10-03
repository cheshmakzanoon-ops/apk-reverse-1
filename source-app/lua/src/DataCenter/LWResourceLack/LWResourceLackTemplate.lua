local LWResourceLackTemplate = BaseClass("LWResourceLackTemplate")

function LWResourceLackTemplate:__init()
end

function LWResourceLackTemplate:__delete()
end

function LWResourceLackTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.res = tonumber(row:getValue("res")) or 0
  self.goods = tonumber(row:getValue("goods")) or 0
  self.res_item = tonumber(row:getValue("res_item")) or 0
  self.special_trigger = tonumber(row:getValue("special_trigger")) or 0
  self.tips = tonumber(row:getValue("tips")) or 0
  self.btn_name = row:getValue("btn_name") or "btn_name"
  self.name = row:getValue("name") or "name"
  self.des = row:getValue("des") or "des"
  self.para1 = row:getValue("para1")
  self.para2 = row:getValue("para2")
  self.pic = row:getValue("pic")
  local base = row:getValue("base")
  local arr = string.split(base, "-")
  self.minLevel = tonumber(arr[1]) or 0
  self.maxLevel = tonumber(arr[2]) or 0
  self.raw_order = row:getValue("order")
  self.baseline = row:getValue("baseline")
  self.needCalcOrder = not string.IsNullOrEmpty(self.baseline)
  if not self.needCalcOrder then
    self.order = tonumber(self.raw_order)
  end
  self.needHero = row:getValue("hero") or ""
  self.color = tonumber(row:getValue("color")) or 0
  self.canUseAll = tonumber(row:getValue("can_use_all") or 0)
  self.builders_alliance_show = tonumber(row:getValue("builders_alliance_show") or 0)
  self.para3 = row:getValue("para3")
  self.mutal_lack_tips = tonumber(row:getValue("mutal_lack_tips")) or 0
  self.show_condition = row:getValue("show_condition") or ""
end

function LWResourceLackTemplate:InitType59FakeLackData(param)
  self.goods = param.goods or 0
  self.itemOrder = param.itemOrder or 0
  self.tips = 2
  self.btn_name = "450018"
  self.name = ""
  self.color = 0
  local itemId = param.itemId
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if template then
    self.name = template.name
    self.color = template.color
  end
  self.pic = DataCenter.ItemTemplateManager:GetIconPath(itemId)
  self.des = "450019"
  self.para1 = itemId
  self.id = 0
  self.res = 0
  self.res_item = 0
  self.special_trigger = 0
  self.para2 = ""
  self.para3 = ""
  self.mutal_lack_tips = 0
  self.show_condition = ""
  self.minLevel = 1
  self.maxLevel = 100
  self.raw_order = 0
  self.order = 0
  self.baseline = ""
  self.needCalcOrder = false
  self.needHero = ""
  self.canUseAll = 0
  self.builders_alliance_show = 0
end

return LWResourceLackTemplate
