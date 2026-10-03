local SandWormTaskInfoMessage = BaseClass("SandWormTaskInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
  else
    DataCenter.SandWormHuntDataManager:HandleSandWormTaskInfo(t)
  end
end

SandWormTaskInfoMessage.HandleMessage = HandleMessage
return SandWormTaskInfoMessage
