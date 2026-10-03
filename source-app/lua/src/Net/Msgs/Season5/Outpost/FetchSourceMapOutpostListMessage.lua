local FetchSourceMapOutpostListMessage = BaseClass("FetchSourceMapOutpostListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSourceMapOutpostListMessage:OnCreate()
  base.OnCreate(self)
end

function FetchSourceMapOutpostListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonOutpostManager:SetSourceMapOutpostList(t)
end

return FetchSourceMapOutpostListMessage
