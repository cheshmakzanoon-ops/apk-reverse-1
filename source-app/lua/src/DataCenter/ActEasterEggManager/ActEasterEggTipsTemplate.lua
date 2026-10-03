local ActEasterEggTipsTemplate = BaseClass("ActEasterEggTipsTemplate")

function ActEasterEggTipsTemplate:__init()
  self.id = 0
  self.group = 0
  self.textKey = ""
  self.eggType = 0
  self.showFirst = 0
end

function ActEasterEggTipsTemplate:__delete()
  self.id = nil
  self.group = nil
  self.textKey = nil
  self.eggType = nil
  self.showFirst = nil
end

function ActEasterEggTipsTemplate:UpdateData(rowData)
  if not rowData then
    Logger.LogError("rowData is nil")
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = rowData:getValue("group") or 0
  self.textKey = rowData:getValue("text_key") or ""
  self.eggType = rowData:getValue("egg_type") or ""
  self.showFirst = rowData:getValue("show_first") and tonumber(rowData:getValue("show_first")) or 0
end

function ActEasterEggTipsTemplate:GetGroup()
  local result = {}
  if type(self.eggType) == "number" then
    table.insert(result, self.eggType)
  elseif type(self.eggType) == "string" then
    local eggTypeStr = string.split(self.eggType, ";")
    for k, v in pairs(eggTypeStr) do
      if v and tonumber(v) then
        table.insert(result, tonumber(v))
      end
    end
  end
  return result
end

return ActEasterEggTipsTemplate
