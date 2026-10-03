require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoSpecialPackStoreStyle = BaseClass("WelfareTagInfoSpecialPackStoreStyle", WelfareTagInfo)
local M = WelfareTagInfoSpecialPackStoreStyle

function M:ctor()
  WelfareTagInfo.ctor(self)
  self.packIdList = {}
end

function M:parse(data)
  WelfareTagInfo.parse(self, data)
  local _para1 = data.para1
  if _para1 ~= nil and not string.IsNullOrEmpty(_para1) then
    self.packIdList = string.split(_para1, "|")
  end
end

function M:isShow()
  local list = self:getPackList(false)
  return list ~= nil and 0 < #list and WelfareTagInfo.isShow(self)
end

function M:getPackList(isSort)
  if #self.packIdList <= 0 then
    return {}
  end
  local list = GiftPackageData.getPacksIgnoreTime(self.packIdList, isSort, true, false)
  for _, v in pairs(list) do
    v:setTagID(self:getID())
  end
  return list
end

function M:getNameForIcon()
  local list = self:getPackList(true)
  if #list < 1 then
    return ""
  end
  return list[1]:getNameText()
end

function M:isShowIcon()
  return self:isShow() and WelfareTagInfo.isShowIcon(self)
end

function M:getPopPackList(isSort)
  if #self.packIdList <= 0 then
    return {}
  end
  local list = GiftPackageData.getPopSpecialPacksById(self.packIdList, isSort)
  for _, v in ipairs(list) do
    v:setTagID(self:getID())
  end
  return list
end

return M
