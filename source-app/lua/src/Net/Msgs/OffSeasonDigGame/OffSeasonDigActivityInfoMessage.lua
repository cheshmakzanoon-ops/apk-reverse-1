local OffSeasonDigActivityInfoMessage = BaseClass("OffSeasonDigActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.OffSeasonDiggingDataManager:OnMapListUpdate(t)
end

OffSeasonDigActivityInfoMessage.OnCreate = OnCreate
OffSeasonDigActivityInfoMessage.HandleMessage = HandleMessage
return OffSeasonDigActivityInfoMessage
