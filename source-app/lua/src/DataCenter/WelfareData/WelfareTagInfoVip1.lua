require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoVip1 = BaseClass("WelfareTagInfoVip1", WelfareTagInfo)
local M = WelfareTagInfoVip1

function M:ctor()
  WelfareTagInfo.ctor(self)
  self.packIdList = {}
end

function M:parse(data)
  WelfareTagInfo.parse(self, data)
  local _para1 = data:getValue("para1")
  if _para1 ~= nil and _para1 ~= "" then
    self.packIdList = string.split(_para1, ";")
  end
end

function M:isShow()
  local list = self:getPackList(false)
  return false
end

function M:getPackList(isSort)
  if #self.packIdList <= 0 then
    return {}
  end
  local list = GiftPackageData.getPacksIgnoreBoughtStatus(self.packIdList, isSort)
  for _, v in ipairs(list) do
    v:setTagID(self:getID())
  end
  return list
end

function M:getPopPackList(isSort)
  return self:getPackList(isSort)
end

function M:hasRedPoint()
  if #self.packIdList <= 0 then
    return false
  end
  return GiftPackageData.hasBought(_, self.packIdList[1])
end

function M:isFullBg()
  return true
end

function M:getBgName()
  return "UI_vipBG"
end

return M
