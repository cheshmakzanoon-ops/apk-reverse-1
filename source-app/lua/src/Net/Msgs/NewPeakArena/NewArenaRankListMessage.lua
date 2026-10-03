local NewArenaRankListMessage = BaseClass("NewArenaRankListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.NewPeakArenaManager:NewArenaRankListHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

NewArenaRankListMessage.OnCreate = OnCreate
NewArenaRankListMessage.HandleMessage = HandleMessage
return NewArenaRankListMessage
