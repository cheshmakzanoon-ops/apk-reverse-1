local UserDecorationSuggestSwitchMessage = BaseClass("UserDecorationSuggestSwitchMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserDecorationSuggestSwitchMessage:OnCreate(isOn)
  base.OnCreate(self)
  self.sfsObj:PutBool("switchNew", isOn)
end

function UserDecorationSuggestSwitchMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DecorationRecommendManager:OnSetOpenMessageCallback(t)
  end
end

return UserDecorationSuggestSwitchMessage
