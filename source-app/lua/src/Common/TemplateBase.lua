TemplateBase = BaseClass("TemplateBase")

function TemplateBase:__init()
  self._tbl_index = nil
  self._tbl_data = nil
  self._tbl_ext = nil
  self:OnCreate()
end

function TemplateBase:__delete()
  self:OnDestroy()
end

function TemplateBase:OnCreate()
end

function TemplateBase:OnDestroy()
end

function TemplateBase:SetRowData(tbl_index, tbl_data, tbl_ext)
  self._tbl_index = tbl_index
  self._tbl_data = tbl_data
  self._tbl_ext = tbl_ext
  self.id = self:getIntValue("id")
end

function TemplateBase:getValue(xmlAttr, defValue)
  if self._tbl_index ~= nil then
    local idxAttr = self._tbl_index[xmlAttr]
    if idxAttr ~= nil and self._tbl_data ~= nil then
      local _key = idxAttr[1]
      local _type = idxAttr[2]
      local _link = idxAttr[3]
      local value = self._tbl_data[_key]
      if _link and value and self._tbl_ext then
        value = self._tbl_ext[value]
      end
      if _type == "string" then
        return value or defValue or ""
      else
        return value or defValue
      end
    end
  end
  return defValue
end

function TemplateBase:getIntValue(xmlAttr, defValue)
  local value = self:getValue(xmlAttr)
  return tonumber(value) or defValue or 0
end

return TemplateBase
