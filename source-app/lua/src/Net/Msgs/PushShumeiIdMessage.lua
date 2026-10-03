local PushShumeiIdMessage = BaseClass("PushShumeiIdMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushShumeiIdMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushShumeiIdMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local shumeiId = t.shumeiId
    if not string.IsNullOrEmpty(shumeiId) then
      CS.GameEntry.Setting:SetString("LW_CacheShumeiDeviceId", shumeiId)
      CS.GameEntry.Setting:Save()
      PostEventLog.SetSuperProperties({lw_shumei_id = shumeiId})
    else
    end
  end
end

return PushShumeiIdMessage
