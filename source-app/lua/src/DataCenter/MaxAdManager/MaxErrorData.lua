local MaxErrorData = BaseClass("MaxErrorData")

local function __init(self)
  self.code = 0
  self.message = ""
  self.networkErrorCode = 0
  self.networkErrorMessage = ""
  self.extra = ""
end

local function __delete(self)
  self.code = 0
  self.message = ""
  self.networkErrorCode = 0
  self.networkErrorMessage = ""
  self.extra = ""
end

local function InitData(self, data)
  self.code = data.code
  self.message = data.message
  self.networkErrorCode = data.networkErrorCode
  self.networkErrorMessage = data.networkErrorMessage
  self.extra = data.extra
end

MaxErrorData.__init = __init
MaxErrorData.__delete = __delete
MaxErrorData.InitData = InitData
return MaxErrorData
