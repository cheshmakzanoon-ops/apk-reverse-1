local EasterEggInfoMessage = BaseClass("EasterEggInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EasterEggInfoMessage:OnCreate(activityId, clearReceiveGiftDataFlag)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("client_para", clearReceiveGiftDataFlag)
end

function EasterEggInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActEasterEggManager:UpdateActInfo(t)
  end
end

return EasterEggInfoMessage
