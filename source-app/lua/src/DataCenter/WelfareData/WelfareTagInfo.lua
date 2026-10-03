WelfareTagInfo = BaseClass("WelfareTagInfo")
local M = WelfareTagInfo

function M:ctor()
  self._id = ""
  self._type = WelfareTagType.Unknown
  self._name = ""
  self._isHot = false
  self._order = 0
  self._iconOrder = 0
  self._imagePath = ""
  self._icon = ""
  self._showIcon = false
  self._iconUnlockLv = 0
  self._isOff = false
  self._entryType = 0
end

function M:parse(data)
  if data == nil then
    return false
  end
  self._id = tostring(data.id)
  self._type = tonumber(data.type)
  self._name = tonumber(data.name) or tostring(data.name) or ""
  self._isHot = tonumber(data.hot) == 1
  self._order = tonumber(data.order)
  self._imagePath = tonumber(data.id)
  self._icon = tostring(data.icon)
  self._showIcon = tonumber(data.show_icon) == 1 or tonumber(data.show_icon) == 2
  self._iconPos = tonumber(data.show_icon)
  self._isOff = tonumber(data.onoff) == 1
  self._iconUnlockLv = tonumber(data.unlock_lv)
  self._iconOrder = tonumber(data.icon_order)
  self._entryType = tonumber(data.entry_type) or 0
  return true
end

function M:getID()
  return self._id
end

function M:getType()
  return self._type
end

function M:isSpecialPackTag()
  return WelfareController.isSpecialPackTag(self:getType())
end

function M:isHot()
  return self._isHot
end

function M:getOrder()
  return self._order
end

function M:getIconOrder()
  return self._iconOrder
end

function M:getEntryType()
  return self._entryType
end

function M:getName()
  return self._name
end

function M:getNameForIcon()
  return self._name
end

function M:getImagePath()
  return self._imagePath
end

function M:getIconName()
  return self._icon
end

function M:isShowIcon()
  return self._showIcon
end

function M:iconPos()
  return self._iconPos
end

function M:isUnlockIcon(level)
  if self._iconUnlockLv == nil then
    return true
  else
    return level >= self._iconUnlockLv
  end
end

function M:isShow()
  return not self._isOff and self:isUnlockIcon(DataCenter.BuildManager.MainLv)
end

function M:hasRedPoint()
  return false
end

function M:getRedDotNum()
  return 0
end

function M:hasSpecialBg()
  return false
end

function M:isFullBg()
  return false
end

function M:getBgName()
  return ""
end

function M:getPackList(isSort)
  return {}
end

function M:GetPveShowPacks()
  local packIds = {}
  local lineData = DataCenter.RechargeManager:GetLine(self._id)
  local para1 = lineData.para1
  if not string.IsNullOrEmpty(para1) then
    for _, packId in ipairs(string.split(para1, ";")) do
      table.insert(packIds, packId)
    end
  end
  return packIds
end

function M:GetPveShowLevels()
  local pveLevels = {}
  local lineData = DataCenter.RechargeManager:GetLine(self._id)
  local para2 = lineData.para2
  if not string.IsNullOrEmpty(para2) then
    for _, str in ipairs(string.split(para2, ";")) do
      table.insert(pveLevels, tonumber(str))
    end
  end
  return pveLevels
end

function M:CanBuy()
  return true
end

function M:GetActivityId()
  return self._activityId
end

function M:CheckIfIsToEnd()
  return false
end

function M:CanShow()
  return true
end

function M:CanShowNewTag()
  return false
end

function M:OnShowPage()
end

return M
