local SandWormAlOpRecordMessage = BaseClass("SandWormAlOpRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
  else
    DataCenter.SandWormHuntDataManager:SetSandWormHistory(t.ls)
  end
end

SandWormAlOpRecordMessage.OnCreate = OnCreate
SandWormAlOpRecordMessage.HandleMessage = HandleMessage
return SandWormAlOpRecordMessage
