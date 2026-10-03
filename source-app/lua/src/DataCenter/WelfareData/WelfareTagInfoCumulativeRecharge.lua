require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoCumulativeRecharge = BaseClass("WelfareTagInfoCumulativeRecharge", WelfareTagInfo)
local M = WelfareTagInfoCumulativeRecharge

function M:isShow()
  local isShow = DataCenter.CumulativeRechargeManager:CheckIsShow()
  return isShow
end

function M:getRedDotNum()
  local count = DataCenter.CumulativeRechargeManager:GetRedNum()
  return count
end

function M:getInfo()
  return nil
end

function M:isShowIcon()
  local info = self:getInfo()
  return info ~= nil and WelfareTagInfo.isShowIcon(self)
end

function M:getBgName()
  return "CumulativeRecharge"
end

function M:isFullBg()
  return true
end

return M
