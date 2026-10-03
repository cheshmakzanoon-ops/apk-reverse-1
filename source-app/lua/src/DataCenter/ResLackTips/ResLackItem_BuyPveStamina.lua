local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_BuyPveStamina = BaseClass("ResLackItem_BuyPveStamina", ResLackItemBase)

function ResLackItem_BuyPveStamina:CheckIsOk(_resType, _needCnt)
  self._resType = _resType
  self.targetCount = _needCnt
  return true
end

function ResLackItem_BuyPveStamina:GetBtnName()
  self.costGoldNum = 0
  self.recoverNum = 0
  local goldStr = LuaEntry.DataConfig:TryGetStr("role_stamina", "k1")
  local strArr = string.split(goldStr, "|")
  local useCount = LuaEntry.Player:GetCurStaminaGoldNum()
  if 0 < #strArr then
    local index = math.min(useCount + 1, #strArr)
    local str = strArr[index]
    local arr = string.split(str, ";")
    if 2 <= #arr then
      self.costGoldNum = tonumber(arr[1])
      self.recoverNum = tonumber(arr[2])
    end
  end
  return string.GetFormattedSeperatorNum(self.costGoldNum)
end

function ResLackItem_BuyPveStamina:TodoAction()
  if LuaEntry.Player.gold >= self.costGoldNum then
    SFSNetwork.SendMessage(MsgDefines.UserRecoverPlayerStamina)
  else
    UIUtil.ShowTipsId(120027)
  end
end

function ResLackItem_BuyPveStamina:GetBuyNum()
  return self.recoverNum
end

return ResLackItem_BuyPveStamina
