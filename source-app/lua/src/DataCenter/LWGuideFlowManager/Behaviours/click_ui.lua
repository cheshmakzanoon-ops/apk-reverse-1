local base = require("DataCenter.LWGuideFlowManager.Behaviours.__click_base")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"string", "windowName"},
  {"string", "compPath"}
}
behaviour.params = table.mergeArray(behaviour.params, base.params)

function behaviour:__SetupMaskParams(maskParams)
  local window = UIManager:GetInstance():GetWindow(self.windowName)
  if window == nil then
    return "window not found:" .. self.windowName
  end
  if window.State ~= 2 then
    return "window not opened:" .. self.windowName
  end
  local finalCompPath = base.FormatStringParamWithContext(self, self.compPath)
  if not finalCompPath then
    return "comp path format error:" .. self.windowName .. "//" .. self.compPath
  end
  local comp = window.View.transform:Find(finalCompPath)
  if IsNull(comp) then
    return "comp not found:" .. self.windowName .. "//" .. self.compPath
  end
  maskParams.target = comp
  return nil
end

return behaviour
