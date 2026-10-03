local SeasonPhotoModuleOpenMessage = BaseClass("SeasonPhotoModuleOpenMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonPhotoModuleOpenMessage:OnCreate(param)
  base.OnCreate(self)
end

function SeasonPhotoModuleOpenMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonPhotoManager:SetModuleValue(t.status)
  EventManager:GetInstance():Broadcast(EventId.SeasonPhotoModuleOpen, t.status)
end

return SeasonPhotoModuleOpenMessage
