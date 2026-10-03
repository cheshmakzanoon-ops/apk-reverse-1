local CreditTemplateManager = BaseClass("CreditTemplateManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.creditTemplates = {}
  self:InitAllTemplate()
end

local function __delete(self)
  self.creditTemplates = nil
end

local function InitAllTemplate(self)
  LocalController:instance():visitTable(TableName.Credit_Price, function(id, lineData)
    local productId = lineData:getValue("product_id") or ""
    local productData = {}
    productData.id = productId
    productData.credit = lineData:getValue("credit") or 0
    self.creditTemplates[productId] = productData
  end)
end

local function GetCreditValue(self, productId)
  if self.creditTemplates[tostring(productId)] then
    return self.creditTemplates[tostring(productId)].credit
  end
  return 0
end

CreditTemplateManager.__init = __init
CreditTemplateManager.__delete = __delete
CreditTemplateManager.InitAllTemplate = InitAllTemplate
CreditTemplateManager.GetCreditValue = GetCreditValue
return CreditTemplateManager
