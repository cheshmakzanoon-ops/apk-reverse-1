local FetchOutpostPosListMessage = BaseClass("FetchOutpostPosListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchOutpostPosListMessage:OnCreate()
  base.OnCreate(self)
end

function FetchOutpostPosListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonOutpostManager:SetOutpostPosList(t)
end

return FetchOutpostPosListMessage
