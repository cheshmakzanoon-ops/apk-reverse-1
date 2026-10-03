local PersonalDiscoverSuppliesInfoMessage = BaseClass("PersonalDiscoverSuppliesInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PersonalDiscoverSuppliesInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

local function __SortSuppliesInfo(a, b)
  if a.state ~= b.state then
    return a.state < b.state
  end
  if a.configId ~= b.configId then
    local aConfig = LocalController:instance():getLine(TableName.LWIceSupplies, a.configId)
    local bConfig = LocalController:instance():getLine(TableName.LWIceSupplies, b.configId)
    if aConfig and bConfig and aConfig.level ~= bConfig.level then
      return aConfig.level > bConfig.level
    end
    return a.configId > b.configId
  end
  if a.alreadyCharge ~= b.alreadyCharge then
    return a.alreadyCharge > b.alreadyCharge
  end
  return a.chargeEndTime < b.chargeEndTime
end

function PersonalDiscoverSuppliesInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    table.sort(t.discoverSupplies, __SortSuppliesInfo)
    DataCenter.WorldPointDetailManager:UpdatePersonalDiscoverSuppliesInfo(t)
  end
end

return PersonalDiscoverSuppliesInfoMessage
