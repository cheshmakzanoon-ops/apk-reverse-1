local GetPVPArenaRankListMessage = BaseClass("GetPVPArenaRankListMessage", SFSBaseMessage)
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
    DataCenter.LWPVPArenaManager:OnGetRankList(t)
  end
end

GetPVPArenaRankListMessage.OnCreate = OnCreate
GetPVPArenaRankListMessage.HandleMessage = HandleMessage
return GetPVPArenaRankListMessage
