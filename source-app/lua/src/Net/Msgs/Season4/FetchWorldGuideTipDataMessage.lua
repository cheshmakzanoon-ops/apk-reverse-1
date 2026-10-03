local FetchWorldGuideTipDataMessage = BaseClass("FetchWorldGuideTipDataMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchWorldGuideTipDataMessage:OnCreate()
  base.OnCreate(self)
end

function FetchWorldGuideTipDataMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if table.count(t.events) > 0 then
    DataCenter.WorldBattleGuideManager:OnServerData(t.events)
  end
end

return FetchWorldGuideTipDataMessage
