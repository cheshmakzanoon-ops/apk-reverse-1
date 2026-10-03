local ActContinuePayBoxData = BaseClass("ActContinuePayBoxData")
local ActContinuePayBoxState = {CLOSE = 0, OPEN = 1}

local function __init(self)
  self.index = 1
  self.state = ActContinuePayBoxState.CLOSE
  self.reward = {}
end

local function __delete(self)
  self.index = nil
  self.state = nil
  self.reward = nil
end

function ActContinuePayBoxData:UpdateInfo(t)
  self.index = t.index
  self.state = t.state
  self.reward = t.reward
end

ActContinuePayBoxData.ActContinuePayBoxState = ActContinuePayBoxState
return ActContinuePayBoxData
