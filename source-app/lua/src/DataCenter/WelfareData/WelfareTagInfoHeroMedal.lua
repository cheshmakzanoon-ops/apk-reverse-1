require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoHeroMedal = BaseClass("WelfareTagInfoHeroMedal", WelfareTagInfo)
local M = WelfareTagInfoHeroMedal
local Timer = CS.GameEntry.Timer

function M:isShow()
  local packList = GiftPackageData.GetHeroMedalPackageList()
  local isShow = false
  for i, v in ipairs(packList) do
    if v.packageIdList then
      for m, packageId in ipairs(v.packageIdList) do
        local packageInfo = GiftPackageData.get(packageId)
        if packageInfo then
          isShow = true
          break
        end
      end
    end
  end
  return isShow and WelfareTagInfo.isShow(self)
end

function M:hasRedPoint()
  return false
end

function M:getRedDotNum()
  return 0
end

function M:getInfo()
  return nil
end

function M:isShowIcon()
  return true
end

return M
