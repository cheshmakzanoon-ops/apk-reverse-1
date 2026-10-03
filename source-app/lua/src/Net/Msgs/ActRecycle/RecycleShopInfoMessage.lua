local RecycleShopInfoMessage = BaseClass("RecycleShopInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function RecycleShopInfoMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function RecycleShopInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.activityId then
    DataCenter.ActRecycleManager:UpdateData(t.activityId, t)
  end
end

return RecycleShopInfoMessage
