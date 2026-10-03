local GaleArenaRankListMessage = BaseClass("GaleArenaRankListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.NewGaleArenaManager:NewArenaRankListHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GaleArenaRankListMessage.OnCreate = OnCreate
GaleArenaRankListMessage.HandleMessage = HandleMessage
return GaleArenaRankListMessage
