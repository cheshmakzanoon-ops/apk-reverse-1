local GetCrossServerKingInfoMessage = BaseClass("GetCrossServerKingInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCrossServerKingInfoMessage:OnCreate(serverIds)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("serverIds", serverIds)
end

function GetCrossServerKingInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.GovernmentManager:OnCrossServerKingInfo(t)
  EventManager:GetInstance():Broadcast(EventId.OnGetServerKingData, t)
end

return GetCrossServerKingInfoMessage
