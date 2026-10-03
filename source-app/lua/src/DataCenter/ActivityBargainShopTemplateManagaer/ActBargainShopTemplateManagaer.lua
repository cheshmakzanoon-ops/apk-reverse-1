local ActBargainShopTemplateManagaer = BaseClass("ActBargainShopTemplateManagaer")
local ActBaragainShopPropTemplate = require("DataCenter.ActivityBargainShopTemplateManagaer.ActBaragainShopPropTemplate")

local function __init(self)
  self.templateDic = {}
end

local function __delete(self)
  self.templateDic = nil
end

local function GetActBaragainShopPropTemplate(self, id)
  local numId = tonumber(id)
  if self.templateDic[numId] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.LW_Activity_BargainShop, tostring(id))
    if oneTemplate ~= nil then
      local item = ActBaragainShopPropTemplate:New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.templateDic[item.id] = item
      end
    end
  end
  return self.templateDic[numId]
end

ActBargainShopTemplateManagaer.__init = __init
ActBargainShopTemplateManagaer.__delete = __delete
ActBargainShopTemplateManagaer.GetActBaragainShopPropTemplate = GetActBaragainShopPropTemplate
return ActBargainShopTemplateManagaer
