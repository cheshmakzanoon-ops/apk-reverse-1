local base = require("DataCenter.LWGuideFlowManager.Behaviours.__click_base")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"string", "windowName"},
  {"string", "compPath"},
  {"number", "autoNext"}
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
  self:InitAutoDoNext(self.autoNext or 3)
  return nil
end

function behaviour:InitAutoDoNext(delay)
  self:RemoveDelayTimer()
  if delay and 0 < delay then
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.OnNextEvent then
        self.OnNextEvent()
      end
    end, delay)
  end
end

function behaviour:RemoveDelayTimer()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function behaviour:__BeforeEnd()
  self:RemoveDelayTimer()
end

return behaviour
