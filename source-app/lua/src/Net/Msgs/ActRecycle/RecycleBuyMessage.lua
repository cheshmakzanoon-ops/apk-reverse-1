local RecycleBuyMessage = BaseClass("RecycleBuyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function RecycleBuyMessage:OnCreate(activityId, id, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("id", id)
  self.sfsObj:PutInt("num", num)
end

function RecycleBuyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActRecycleManager:OnExchangeShopSuccess(t)
  end
end

return RecycleBuyMessage
