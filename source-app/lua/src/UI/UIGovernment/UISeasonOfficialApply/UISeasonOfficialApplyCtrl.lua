local UISeasonOfficialApplyCtrl = BaseClass("UISeasonOfficialApplyCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialApply)
end

local function SendKingdomPositionApply(self, positionId)
  SFSNetwork.SendMessage(MsgDefines.KingdomPositionApply, positionId)
end

local function SendKingdomPositionAppointmentDelete(self, positionId, officialApplyData, isCtrl)
  local check = TodayNoSecondConfirmType.KingdomPositionApplyDeleteBySelf
  local str = Localization:GetString("officer_apply_043", LuaEntry.DataConfig:TryGetNum("auto_wonder_config", "k7"))
  if isCtrl then
    check = TodayNoSecondConfirmType.KingdomPositionApplyDeleteByCtrl
    local template = DataCenter.GovernmentTemplateManager:GetTemplate(positionId)
    str = Localization:GetString("officer_apply_042", officialApplyData:GetFullName(), Localization:GetString(template.name))
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
        str = Localization:GetString("officer_apply_044", math.ceil(cd / min))
      else
        str = Localization:GetString("officer_apply_043", math.ceil(cd / 1000))
      end
    end
  end
  if needShow then
    UIUtil.ShowSecondMessage("", str, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.KingdomPositionAppointmentDelete, {positionId = positionId, uid = uid})
    end, function(needSellConfirm)
      DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(check, needSellConfirm)
    end, nil, function()
    end, nil, Localization:GetString(GameDialogDefine.TODAY_NO_SHOW), nil, nil, nil)
  else
    SFSNetwork.SendMessage(MsgDefines.KingdomPositionAppointmentDelete, {positionId = positionId, uid = uid})
  end
end

local function SendKingdomPositionHistoryList(self, positionId)
  SFSNetwork.SendMessage(MsgDefines.KingdomPositionHistoryList, positionId)
end

UISeasonOfficialApplyCtrl.CloseSelf = CloseSelf
UISeasonOfficialApplyCtrl.SendKingdomPositionApply = SendKingdomPositionApply
UISeasonOfficialApplyCtrl.SendKingdomPositionAppointmentDelete = SendKingdomPositionAppointmentDelete
UISeasonOfficialApplyCtrl.SendKingdomPositionHistoryList = SendKingdomPositionHistoryList
return UISeasonOfficialApplyCtrl
