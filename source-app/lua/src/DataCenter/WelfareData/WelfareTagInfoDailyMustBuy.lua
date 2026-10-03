require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoDailyMustBuy = BaseClass("WelfareTagInfoDailyMustBuy", WelfareTagInfo)
local M = WelfareTagInfoDailyMustBuy

function M:isShow()
  return WelfareTagInfo.isShow(self)
end

function M:getRedDotNum()
  return DataCenter.DailyMustBuyManager:GetCanGetStageNum()
end

function M:getInfo()
  local lineData = DataCenter.RechargeManager:GetLine(self._id)
  local para1 = lineData.para1
  local groupIds = string.split(para1, "|")
  local groups = {}
  for _, groupId in ipairs(groupIds) do
    local group = GiftPackManager.GetPacksByGroupId(groupId, false)
    if not table.IsNullOrEmpty(group) then
      table.insert(groups, group[1])
    end
  end
  return groups
end

function M:isShowIcon()
  local info = self:getInfo()
  return info ~= nil and WelfareTagInfo.isShowIcon(self)
end

function M:getBgName()
  return "DailyPackage"
end

function M:isFullBg()
  return true
end

function M:CanBuy()
  local packs = self:getInfo()
  if not table.IsNullOrEmpty(packs) then
    return true
  end
  local redDotNum = self:getRedDotNum()
  return 0 < redDotNum
end

return M
