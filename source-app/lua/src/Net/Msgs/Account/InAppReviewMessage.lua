local InAppReviewMessage = BaseClass("InAppReviewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.LWFiveStarManager:CheckShowFiveStarView("server_request")
end

InAppReviewMessage.OnCreate = OnCreate
InAppReviewMessage.HandleMessage = HandleMessage
return InAppReviewMessage
