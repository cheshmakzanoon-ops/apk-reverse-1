local PushAllianceBossSandWormCritTipMessage = BaseClass("PushAllianceBossSandWormCritTipMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
  else
    DataCenter.AllyDrillBaseManager:ShowCritTipEffect(t)
  end
end

PushAllianceBossSandWormCritTipMessage.HandleMessage = HandleMessage
return PushAllianceBossSandWormCritTipMessage
