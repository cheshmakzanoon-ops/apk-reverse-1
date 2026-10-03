local GetNewsInfoMessage = BaseClass("GetNewsInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWNewsCenterManager:OnGetNewsInfo(t.news)
  end
end

GetNewsInfoMessage.OnCreate = OnCreate
GetNewsInfoMessage.HandleMessage = HandleMessage
return GetNewsInfoMessage
