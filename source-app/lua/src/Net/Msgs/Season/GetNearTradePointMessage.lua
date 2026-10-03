local GetNearTradePointMessage = BaseClass("GetNearTradePointMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("searchType", type or 1)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    GoToUtil.GoToCurWorldPoint(t)
  end
end

GetNearTradePointMessage.OnCreate = OnCreate
GetNearTradePointMessage.HandleMessage = HandleMessage
return GetNearTradePointMessage
