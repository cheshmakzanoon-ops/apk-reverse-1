local ShowAdsDetailMessage = BaseClass("ShowAdsDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ShowAdsDetailMessage:OnCreate(id)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
end

function ShowAdsDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.MaxAdManager:ShowAdById(t.id)
  end
end

return ShowAdsDetailMessage
