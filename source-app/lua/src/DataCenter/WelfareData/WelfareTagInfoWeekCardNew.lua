local WelfareTagInfoWeekCardNew = BaseClass("WelfareTagInfoWeekCardNew", WelfareTagInfo)
local M = WelfareTagInfoWeekCardNew
local Timer = CS.GameEntry.Timer

function M:isShow()
  local needBaseLv = LuaEntry.DataConfig:TryGetNum("weekcard_para", "k2")
  local isShow = false
  if DataCenter.BuildManager.MainLv ~= nil then
    isShow = needBaseLv <= DataCenter.BuildManager.MainLv
  end
  local weekCardList = DataCenter.WeekCardManager:GetWeekCardList()
  if #weekCardList == 0 then
    return false
  end
  for i, v in ipairs(weekCardList) do
    local tempPackage = GiftPackManager.get(v.exchangeId)
    if not tempPackage then
      return false
    end
  end
  return isShow and WelfareTagInfo.isShow(self)
end

function M:hasRedPoint()
  local needRed = DataCenter.WeekCardManager:CheckIfHasRed()
  return needRed
end

function M:getRedDotNum()
  local needRed, redNum = DataCenter.WeekCardManager:CheckIfHasRed()
  return redNum
end

function M:getInfo()
  return nil
end

function M:isShowIcon()
  return true
end

function M:CanShow()
  return true
end

return M
