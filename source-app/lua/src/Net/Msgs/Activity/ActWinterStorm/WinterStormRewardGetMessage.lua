local WinterStormRewardGetMessage = BaseClass("WinterStormRewardGetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function WinterStormRewardGetMessage:OnCreate(id)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
end

function WinterStormRewardGetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActWinterStormManager:HandleRewardGet(t)
  end
end

return WinterStormRewardGetMessage
