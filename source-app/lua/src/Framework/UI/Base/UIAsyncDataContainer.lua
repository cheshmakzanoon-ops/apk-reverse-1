local base = UIAsyncContainer
local UIAsyncDataContainer = BaseClass("UIAsyncDataContainer", base)
UIAsyncDataContainer.DataSchema = nil
UIAsyncDataContainer.PrefabPath = nil

function UIAsyncDataContainer:__delete(...)
  self.viewData = nil
end

function UIAsyncDataContainer:__init(...)
  self.viewData = {}
end

function UIAsyncDataContainer:SetData(...)
  local args = {
    ...
  }
  local argCount = select("#", ...)
  local schema = self.DataSchema
  if not self.data then
    self.data = {}
  else
    for k in pairs(self.data) do
      self.data[k] = nil
    end
  end
  if type(schema) == "table" and 0 < #schema then
    if #schema == argCount then
      for i, key in ipairs(schema) do
        self.viewData[key] = args[i]
      end
    else
      Logger.LogError(string.format("UIAsyncItemBase(%s): SetData argument count mismatch. Expected %d (from Schema), got %d.", self.__cname or "Unknown", #schema, argCount))
    end
  elseif 0 < argCount then
    Logger.LogError(string.format("UIAsyncItemBase(%s): Cannot set data. Define DataSchema or pass a single table.", self.__cname or "Unknown"))
  end
  self:RefreshView()
end

function UIAsyncDataContainer:PartialSetData(...)
  return
end

function UIAsyncDataContainer:GetData()
  return self.viewData
end

return UIAsyncDataContainer
