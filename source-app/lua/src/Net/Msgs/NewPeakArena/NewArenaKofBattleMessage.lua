local NewArenaKofBattleMessage = BaseClass("NewArenaKofBattleMessage", SFSBaseMessage)
local base = SFSBaseMessage

function NewArenaKofBattleMessage:OnCreate(otherUid, teamInfoArray)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("otherUid", otherUid)
  self.sfsObj:PutSFSArray("teamInfos", teamInfoArray)
end

function NewArenaKofBattleMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    EventManager:GetInstance():Broadcast(EventId.KOFBattleFinishError)
    return
  end
  if message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  message.typeKOF = TypeKOF.NewPeakArena
  EventManager:GetInstance():Broadcast(EventId.KOFBattleFinish, message)
end

return NewArenaKofBattleMessage
