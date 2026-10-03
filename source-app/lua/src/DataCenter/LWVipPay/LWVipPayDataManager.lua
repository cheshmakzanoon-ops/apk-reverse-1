local LWVipPayDataManager = BaseClass("LWVipPayDataManager")
local LWVipPayData = require("DataCenter.LWVipPay.LWVipPayData")

function LWVipPayDataManager:__init()
  self.vipPayDict = {}
end

function LWVipPayDataManager:__delete()
  self.templateDict = nil
end

function LWVipPayDataManager:GetData()
  if self.vipPayDict[1] == nil then
    local lineData = LocalController:instance():getLine(TableName.LW_VIP_PAY, 1)
    if lineData == nil then
      Logger.LogError("LWVipPayData GetTemplate lineData is nil id:" .. tostring(1))
      return nil
    end
    local vipData = LWVipPayData.New()
    vipData:Init(lineData)
    self.vipPayDict[vipData.id] = vipData
  end
  return self.vipPayDict[1]
end

return LWVipPayDataManager
