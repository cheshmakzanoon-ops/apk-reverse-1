local UISeasonBattlePassCtrl = BaseClass("UISeasonBattlePassCtrl", UIBaseCtrl)

function UISeasonBattlePassCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonBattlePass)
end

function UISeasonBattlePassCtrl:OnClickOneGet(activityId, actData)
  if not activityId or not actData then
    return
  end
  local num = actData:GetRedNum()
  if num <= 0 then
    UIUtil.ShowTipsId(320446)
    return
  end
  local actId = toInt(activityId)
  if actData.type == EnumActivity.BattlePass_new.Type then
    SFSNetwork.SendMessage(MsgDefines.NewReceiveBPAllReward, actId)
  else
    SFSNetwork.SendMessage(MsgDefines.ReceiveBattlePassAllReward, actId)
  end
end

function UISeasonBattlePassCtrl:OnClickIntro(activityId)
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if activityData == nil then
    return
  end
  local param = {}
  param.activityRulesStr = CS.GameEntry.Localization:GetString(activityData.story)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
end

function UISeasonBattlePassCtrl:SendBattlePassMessage(activityId)
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(activityId))
end

function UISeasonBattlePassCtrl:OpenPackagePopUp(activityId, isHigh)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassNewYearGiftPackagePopUp, tonumber(activityId), isHigh)
end

function UISeasonBattlePassCtrl:BuyLvUp(activityId)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassBuy, toInt(activityId))
end

return UISeasonBattlePassCtrl
