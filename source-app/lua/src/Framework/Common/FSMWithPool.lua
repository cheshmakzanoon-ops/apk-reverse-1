local Base = require("Framework.Common.FSM")
local FSM = BaseClass("FSM", Base)

function FSM:Init()
  self.states = {}
  self.curStateIndex = -1
end

local function __delete(self)
  if self.states then
    for _, v in pairs(self.states) do
      v:Delete()
      ObjectPool:GetInstance():Save(v)
    end
    self.states = nil
  end
  Base.__delete(self)
end

FSM.__delete = __delete
return FSM
