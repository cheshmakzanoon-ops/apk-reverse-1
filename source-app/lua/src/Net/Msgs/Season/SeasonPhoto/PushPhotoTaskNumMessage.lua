local PushPhotoTaskNumMessage = BaseClass("PushPhotoTaskNumMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushPhotoTaskNumMessage:OnCreate()
  base.OnCreate(self)
end

function PushPhotoTaskNumMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonPhotoManager:UpdateReward(t.photoTaskInfo)
end

return PushPhotoTaskNumMessage
