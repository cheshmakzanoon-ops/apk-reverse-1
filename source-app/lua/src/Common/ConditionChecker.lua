local ConditionChecker = BaseClass("ConditionChecker")

function ConditionChecker:__init(callback)
  self.conditions = {}
  self.callback = callback
  self.currentIndex = 0
end

function ConditionChecker:__delete()
  self.callback = nil
  self.currentIndex = 0
end

function ConditionChecker:Add(condition)
  table.insert(self.conditions, condition)
end

function ConditionChecker:Next()
  self.currentIndex = self.currentIndex + 1
  local next = self.conditions[self.currentIndex]
  if not next then
    if self.callback then
      self.callback()
    end
    self:Destroy()
  else
    local need = next.need
    local checker = next.checker
    if not need or need() then
      if checker then
        checker(self)
      end
    else
      self:Next()
    end
  end
end

function ConditionChecker:Destroy()
  self:Delete()
end

return ConditionChecker
