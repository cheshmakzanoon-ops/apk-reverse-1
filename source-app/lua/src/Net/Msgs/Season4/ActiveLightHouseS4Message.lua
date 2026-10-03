local ActiveLightHouseS4Message = BaseClass("ActiveLightHouseS4Message", SFSBaseMessage)
local base = SFSBaseMessage

function ActiveLightHouseS4Message:OnCreate()
  base.OnCreate(self)
end

function ActiveLightHouseS4Message:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
end

return ActiveLightHouseS4Message
