local GoldTreeHideNameMessage = BaseClass("GoldTreeHideNameMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GoldTreeHideNameMessage:OnCreate(weekTime, isHide)
  base.OnCreate(self)
  self.sfsObj:PutLong("weekTime", weekTime)
  self.sfsObj:PutBool("isHide", isHide)
end

function GoldTreeHideNameMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.GoldTreeThirdError, MsgDefines.GoldTreeHideName)
    return
  end
  if t.userGoldTreeDataInfo.userGoldTeeInfo.lotteryHideName == 0 then
    UIUtil.ShowTipsId("season_s4_s_gold_tree_tips_31")
  else
    UIUtil.ShowTipsId("season_s4_s_gold_tree_tips_30")
  end
  DataCenter.SeasonGoldTreeThirdManager:GoldTreeHideNameMessage(t)
end

return GoldTreeHideNameMessage
