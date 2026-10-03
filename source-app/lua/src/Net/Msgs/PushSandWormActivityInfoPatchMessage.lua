local PushSandWormActivityInfoPatchMessage = BaseClass("PushSandWormActivityInfoPatchMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, msg)
  base.HandleMessage(self, msg)
  if msg.errorCode then
    UIUtil.ShowTipsId(msg.errorCode)
  else
    if msg.ls and msg.ls[1] and msg.ls[1].monsterId and DataCenter.JungleTrialDataManager:IsChomper(msg.ls[1].monsterId) then
      return
    end
    DataCenter.SandWormHuntDataManager:HandleSandWormHuntActivityInfo(msg)
  end
end

PushSandWormActivityInfoPatchMessage.HandleMessage = HandleMessage
return PushSandWormActivityInfoPatchMessage
