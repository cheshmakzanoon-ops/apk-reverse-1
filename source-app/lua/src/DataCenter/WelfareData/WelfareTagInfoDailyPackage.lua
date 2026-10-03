require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoDailyPackage = BaseClass("WelfareTagInfoDailyPackage", WelfareTagInfo)
local M = WelfareTagInfoDailyPackage

function M:isShow()
  local totalPack, packs = DataCenter.DailyPackageManager:getDailyPackageGroup()
  if string.IsNullOrEmpty(totalPack) or table.IsNullOrEmpty(packs) then
    return false
  end
  return WelfareTagInfo.isShow(self)
end

function M:getRedDotNum()
  if not DataCenter.DailyPackageManager:IsBought() and DataCenter.DailyPackageManager:HasTabRedDot() then
    return 1
  end
  return 0
end

function M:getInfo()
  return nil
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
  local totalPack, packs = DataCenter.DailyPackageManager:getDailyPackageGroup()
  if string.IsNullOrEmpty(totalPack) or table.IsNullOrEmpty(packs) then
    return false
  end
  local totalPackInfo = GiftPackageData.get(totalPack)
  if totalPackInfo ~= nil and totalPackInfo:canGet() then
    for i, packId in pairs(packs) do
      local packInfo = GiftPackageData.get(packId)
      if packInfo ~= nil and packInfo:canGet() and packInfo:isTimeValid() then
        return true
      end
    end
  end
  local redNum = self:getRedDotNum()
  return 1 <= redNum
end

return M
