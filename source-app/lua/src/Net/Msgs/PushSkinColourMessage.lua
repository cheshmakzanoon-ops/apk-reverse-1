local PushSkinColourMessage = BaseClass("PushSkinColourMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSkinColourMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushSkinColourMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ItemSkinDataManager:UpdateSkinData(t)
  end
end

return PushSkinColourMessage
