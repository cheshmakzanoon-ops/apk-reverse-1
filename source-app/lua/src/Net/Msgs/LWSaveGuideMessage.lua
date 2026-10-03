local LWSaveGuideMessage = BaseClass("LWSaveGuideMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, state)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("lwGuideRecord", tostring(state))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil and t.lwGuideRecord ~= nil then
    DataCenter.LWGuideManager:UpdateGuide(t)
  end
end

LWSaveGuideMessage.OnCreate = OnCreate
LWSaveGuideMessage.HandleMessage = HandleMessage
return LWSaveGuideMessage
