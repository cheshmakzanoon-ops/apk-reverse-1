local OrderTemplateManager = BaseClass("OrderTemplateManager")

local function __init(self)
  self.orderTemplateDic = {}
  self.useTableName = nil
end

local function __delete(self)
  self.orderTemplateDic = nil
  self.useTableName = nil
end

local function GetOrderTemplate(self, id)
  if self.orderTemplateDic[tonumber(id)] == nil then
    local oneTemplate = LocalController:instance():getLine(self:GetTableName(), tostring(id))
    if oneTemplate ~= nil then
      local item = OrderTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.orderTemplateDic[item.id] = item
      end
    end
  end
  return self.orderTemplateDic[tonumber(id)]
end

local function GetRewardProps(self, itemList)
  local result = {}
  for k, v in ipairs(itemList) do
    local param = {}
    param.itemId = v.itemId
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(v.itemId)
    if template ~= nil and template.show == 1 then
      param.icon_name = template.pic
      param.name = template.name
      param.quality_name = "Common_img_quality_green"
      param.itemType = template.itemType
      param.num = v.count
      table.insert(result, param)
    end
  end
  return result
end

local function GetTableName(self)
  if self.useTableName == nil then
    self.useTableName = LuaEntry.Player:GetABTestTableName(TableName.Order)
  end
  return self.useTableName
end

OrderTemplateManager.__init = __init
OrderTemplateManager.__delete = __delete
OrderTemplateManager.GetOrderTemplate = GetOrderTemplate
OrderTemplateManager.GetRewardProps = GetRewardProps
OrderTemplateManager.GetTableName = GetTableName
return OrderTemplateManager
