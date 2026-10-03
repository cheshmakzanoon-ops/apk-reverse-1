local LimitDropHistoryShowData = BaseClass("LimitDropHistoryShowData")

local function __init(self)
  self.type = nil
  self.data = nil
end

local function __delete(self)
  self.type = nil
  self.data = nil
end

function LimitDropHistoryShowData:UpdateData(type, data)
  self.type = type
  self.data = data
end

LimitDropHistoryShowData.__init = __init
LimitDropHistoryShowData.__delete = __delete
return LimitDropHistoryShowData
