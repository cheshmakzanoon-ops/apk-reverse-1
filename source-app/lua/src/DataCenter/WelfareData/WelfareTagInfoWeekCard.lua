require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoWeekCard = BaseClass("WelfareTagInfoWeekCard", WelfareTagInfo)
local M = WelfareTagInfoWeekCard

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
  return list ~= nil and 0 < #list and WelfareTagInfo.isShow(self)
end

function M:hasRedPoint()
  local packs = self:getPackList(true)
  for _, v in ipairs(packs) do
    if v:isFree() and v:canGet() then
      return true
    end
  end
  return false
end

function M:getPackList(isSort)
  if #self.packIdList <= 0 then
    return {}
  end
  local list = GiftPackageData.getPacks(self.packIdList, isSort)
  for _, v in ipairs(list) do
    v:setTagID(self:getID())
  end
  return list
end

function M:isShowIcon()
  return self:isShow() and WelfareTagInfo.isShowIcon(self)
end

return M
