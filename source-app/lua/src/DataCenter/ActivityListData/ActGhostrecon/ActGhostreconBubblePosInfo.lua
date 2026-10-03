local ActGhostreconBubblePosInfo = BaseClass("ActGhostreconBubblePosInfo")

local function __init(self)
  self.poolIndex = 1
  self.index = 1
  self.uuid = nil
end

local function __delete(self)
  self.poolIndex = nil
  self.index = nil
  self.uuid = nil
end

ActGhostreconBubblePosInfo.__init = __init
ActGhostreconBubblePosInfo.__delete = __delete
return ActGhostreconBubblePosInfo
