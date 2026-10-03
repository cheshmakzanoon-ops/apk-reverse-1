local UIOfficialAppointApplyListCtrl = BaseClass("UIOfficialAppointApplyListCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIOfficialAppointApplyList)
end

local function SendKingdomPositionApplyDelete(self, positionId, officialApplyData, isCtrl)
  local check = TodayNoSecondConfirmType.KingdomPositionApplyDeleteBySelf
  local str = Localization:GetString("officer_apply_019", LuaEntry.DataConfig:TryGetNum("auto_wonder_config", "k7"))
  if isCtrl then
    check = TodayNoSecondConfirmType.KingdomPositionApplyDeleteByCtrl
    local template = DataCenter.GovernmentTemplateManager:GetTemplate(positionId)
    str = Localization:GetString("officer_apply_010", officialApplyData:GetFullName(), Localization:GetString(template.name))
  end
  local needShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(check)
  local uid = officialApplyData.uid
  if not isCtrl then
    local cd = DataCenter.OfficialApplyManager:GetOwnApplyCD(positionId)
    if cd <= 0 then
      needShow = false
    else
      local min = 60000
      if cd > min then
        str = Localization:GetString("officer_apply_023", math.ceil(cd / min))
      else
        str = Localization:GetString("officer_apply_019", math.ceil(cd / 1000))
      end
    end
  end
  if needShow then
    UIUtil.ShowSecondMessage("", str, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.KingdomPositionApplyDelete, positionId, uid)
    end, function(needSellConfirm)
      DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(check, needSellConfirm)
    end, nil, function()
    end, nil, Localization:GetString(GameDialogDefine.TODAY_NO_SHOW), nil, nil, nil)
  else
    SFSNetwork.SendMessage(MsgDefines.KingdomPositionApplyDelete, positionId, uid)
  end
end

UIOfficialAppointApplyListCtrl.CloseSelf = CloseSelf
UIOfficialAppointApplyListCtrl.SendKingdomPositionApplyDelete = SendKingdomPositionApplyDelete
return UIOfficialAppointApplyListCtrl
