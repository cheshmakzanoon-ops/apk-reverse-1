local LWBaseCheckActivityTip = BaseClass("LWBaseCheckActivityTip")

local function abstractFunction()
  error("This is an abstract function and must be implemented in the derived class.")
end

local function __init(self, activityId)
  self.activityId = activityId
end

local function __delete(self)
  self.activityId = nil
end

function LWBaseCheckActivityTip:CheckIsShowTip()
  abstractFunction()
end

LWBaseCheckActivityTip.__init = __init
LWBaseCheckActivityTip.__delete = __delete
return LWBaseCheckActivityTip
