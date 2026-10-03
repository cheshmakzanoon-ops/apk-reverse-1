local MoveCrossServerMessage = BaseClass("MoveCrossServerMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MoveCrossServerMessage:OnCreate(param)
  base.OnCreate(self)
  if param ~= nil then
    if param.useCrossItem then
      self.sfsObj:PutBool("useCrossItem", true)
    else
      self.sfsObj:PutBool("useCrossItem", false)
    end
    self.sfsObj:PutInt("serverId", param.serverId)
    self.sfsObj:PutInt("type", param.type)
    self.sfsObj:PutInt("dstPoint", param.dstPoint)
    EventManager:GetInstance():Broadcast(EventId.SetCrossMovingUI, toInt(param.serverId))
  end
end

function MoveCrossServerMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    if t.errorCode == SeverErrorCode then
      t.errorCode = 120447
    end
    CrossServerUtil.LogCrossEnableList()
  else
    if t.crossMoveCDEnd then
      DataCenter.LeagueMatchManager:SetCrossMoveCDEnd(t.crossMoveCDEnd)
    end
    EventManager:GetInstance():Broadcast(EventId.MoveCrossServerMessage)
  end
  DataCenter.AllianceCompeteDataManager:MoveCrossServerHandle(t)
end

return MoveCrossServerMessage
