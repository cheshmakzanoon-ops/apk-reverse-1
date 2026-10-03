local ValentineFollowGmMessage = BaseClass("ValentineFollowGmMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineFollowGmMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
  self.sfsObj:PutUtfString("uid", param.uid)
  self.sfsObj:PutInt("num", param.num)
end

function ValentineFollowGmMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return ValentineFollowGmMessage
