local PushFishPondCrocodileCatchMessage = BaseClass("PushFishPondCrocodileCatchMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushFishPondCrocodileCatchMessage:OnCreate()
  base.OnCreate(self)
end

function PushFishPondCrocodileCatchMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.FishingDataManager:JumpToCrocodile(t)
  end
end

return PushFishPondCrocodileCatchMessage
