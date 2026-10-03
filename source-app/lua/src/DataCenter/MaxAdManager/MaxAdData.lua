local MaxAdData = BaseClass("MaxAdData")

local function __init(self)
  self.countryCode = ""
  self.networkName = ""
  self.adUnitId = ""
  self.adFormat = ""
  self.placement = ""
  self.dspId = ""
  self.networkPlacement = ""
  self.revenuePrecision = ""
  self.dspName = ""
  self.revenue = 0
end

local function __delete(self)
  self.countryCode = ""
  self.networkName = ""
  self.adUnitId = ""
  self.adFormat = ""
  self.placement = ""
  self.dspId = ""
  self.networkPlacement = ""
  self.revenuePrecision = ""
  self.dspName = ""
  self.revenue = 0
end

local function InitData(self, data)
  self.countryCode = data.countryCode
  self.networkName = data.networkName
  self.adUnitId = data.adUnitId
  self.adFormat = data.adFormat
  self.placement = data.placement
  self.dspId = data.dspId
  self.networkPlacement = data.networkPlacement
  self.revenuePrecision = data.revenuePrecision
  self.dspName = data.dspName
  self.revenue = data.revenue
end

MaxAdData.__init = __init
MaxAdData.__delete = __delete
MaxAdData.InitData = InitData
return MaxAdData
