local PushItemuseDetectInfoMessage = BaseClass("PushItemuseDetectInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushItemuseDetectInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushItemuseDetectInfoMessage:HandleMessage(t)
  base.HandleMessage(message)
  if t.errorCode == nil then
    local pointId = t.pointId
    if pointId and 0 < pointId then
      if not LuaEntry.Player:IsInSelfServer() then
        return
      end
      GoToUtil.CloseAllWindows()
      GoToUtil.MoveToWorldPointAndOpen(pointId, nil, nil)
    end
  end
end

return PushItemuseDetectInfoMessage
