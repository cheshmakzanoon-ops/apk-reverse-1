local NewArenaKofBattlePreviewMessage = BaseClass("NewArenaKofBattlePreviewMessage", SFSBaseMessage)
local base = SFSBaseMessage
local __isChallange = false

function NewArenaKofBattlePreviewMessage:OnCreate(otherUid, isChallange)
  base.OnCreate(self)
  if otherUid then
    self.sfsObj:PutUtfString("otherUid", otherUid)
  end
  __isChallange = isChallange
end

function NewArenaKofBattlePreviewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.NewPeakArenaManager:ParseOpponentData(t, __isChallange)
      EventManager:GetInstance():Broadcast(EventId.NewPeakArenaGetKOFBattlePreview, t)
    else
      EventManager:GetInstance():Broadcast(EventId.NewPeakArenaGetMessageError, t)
      UIUtil.ShowTipsId(t.errorCode)
      if "new_arena_tips_38" == t.errorCode then
        SFSNetwork.SendMessage(MsgDefines.NewArenaRankList)
      end
    end
  end
end

return NewArenaKofBattlePreviewMessage
