local ShowStatusItemMessage = BaseClass("ShowStatusItemMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

ShowStatusItemMessage.HandleMessage = HandleMessage
return ShowStatusItemMessage
