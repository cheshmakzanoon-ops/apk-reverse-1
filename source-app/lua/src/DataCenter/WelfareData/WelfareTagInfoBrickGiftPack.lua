require("DataCenter.WelfareData.WelfareTagInfo")
local WelfareTagInfoBrickGiftPack = BaseClass("WelfareTagInfoBrickGiftPack", WelfareTagInfo)
local M = WelfareTagInfoBrickGiftPack

function M:isShow()
  local open = LuaEntry.DataConfig:CheckSwitch("Goldbrick_lawshop")
  if not open then
    return false
  end
  local rechargeCfg = DataCenter.RechargeManager:GetLine(GoldBrickConst.RechargeId)
  if not rechargeCfg then
    return false
  end
  local packIds = rechargeCfg.para1 and string.split(rechargeCfg.para1, "|") or {}
  if #packIds == 0 then
    return false
  end
  local packData = GiftPackageData.get(packIds[1])
  if not packData then
    return false
  end
  if WelfareController.IsAfterInitSendGetGoldBrickInfo() and not WelfareController.IsGetGoldBrickInfo() then
    return false
  end
  local isAvailable = not WelfareController.CanOpenGoldBrickStore()
  return isAvailable
end

function M:hasRedPoint()
  return false
end

function M:getRedDotNum()
  local redNum = 0
  if self:hasRedPoint() then
    redNum = 1
  end
  return redNum
end

function M:CanShow()
  return self:isShow()
end

return M
