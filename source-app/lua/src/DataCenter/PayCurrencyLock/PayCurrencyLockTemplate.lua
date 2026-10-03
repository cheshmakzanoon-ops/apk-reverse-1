local PayCurrencyLockTemplate = BaseClass("PayCurrencyLockTemplate")

function PayCurrencyLockTemplate:__init()
  self.id = 0
  self.storeCodeAlpha2 = ""
  self.storeCodeAlpha3 = ""
end

function PayCurrencyLockTemplate:__delete()
  self.id = nil
  self.storeCodeAlpha2 = nil
  self.storeCodeAlpha3 = nil
end

function PayCurrencyLockTemplate:UpdateData(rowData)
  self.id = rowData:getValue("id") or 0
  self.storeCodeAlpha2 = rowData:getValue("Alpha2") or ""
  self.storeCodeAlpha3 = rowData:getValue("Alpha3") or ""
end

return PayCurrencyLockTemplate
