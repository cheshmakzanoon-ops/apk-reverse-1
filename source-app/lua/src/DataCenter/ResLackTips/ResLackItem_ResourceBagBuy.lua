local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_ResourceBagBuy = BaseClass("ResLackItem_ResourceBagBuy", ResLackItemBase)
local Localization = CS.GameEntry.Localization

function ResLackItem_ResourceBagBuy:CheckIsOk(_resType, _needCnt)
  self._resType = _resType
  self.targetCount = _needCnt
  return true
end

function ResLackItem_ResourceBagBuy:TodoAction(pos, isRefresh, lacktab)
  local res = {}
  res[self._resType] = self.needCount
  local needCostGold = self.spendGold
  if needCostGold <= LuaEntry.Player.gold then
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING, string.GetFormattedSeperatorNum(needCostGold) .. Localization:GetString(GameDialogDefine.DIAMOND), string.GetFormattedSeperatorNum(self.needCount), DataCenter.ResourceManager:GetResourceNameByType(self._resType)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      if isRefresh then
        local param = {}
        param.tips = self:GetTips()
        param.count = lacktab.disNum - self.needCount
        param.type = self._resType
        DataCenter.ResLackManager:SetRefreshParam(param)
      end
      SFSNetwork.SendMessage(MsgDefines.BuyItemAndResource, res)
    end, function()
    end)
  else
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoPayTips(needCostGold)
  end
end

function ResLackItem_ResourceBagBuy:UpdateCount(_needCnt)
  self.targetCount = _needCnt
end

function ResLackItem_ResourceBagBuy:GetBtnName()
  self.needCount = self.targetCount
  local own = LuaEntry.Resource:GetCntByResType(self._resType)
  if 0 < own then
    self.needCount = self.targetCount - own
  end
  self.spendGold = CommonUtil.GetResGoldByType(self._resType, self.needCount)
  return string.GetFormattedSeperatorNum(self.spendGold)
end

function ResLackItem_ResourceBagBuy:GetBuyNum()
  return self.needCount
end

return ResLackItem_ResourceBagBuy
