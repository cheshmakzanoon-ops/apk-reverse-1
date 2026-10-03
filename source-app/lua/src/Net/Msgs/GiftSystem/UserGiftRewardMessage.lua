local UserGiftRewardMessage = BaseClass("UserGiftRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserGiftRewardMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", param.id)
end

function UserGiftRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.GiftSystemManager:HandleGetPrivilegeReward(t)
  end
end

return UserGiftRewardMessage
