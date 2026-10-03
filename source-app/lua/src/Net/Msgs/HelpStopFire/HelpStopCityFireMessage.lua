local HelpStopCityFireMessage = BaseClass("HelpStopCityFireMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, targetUid, isFree)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", targetUid)
  self.sfsObj:PutInt("isFree", isFree)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.BuildHelpStopFireManager:HelpStopCityFireHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

HelpStopCityFireMessage.OnCreate = OnCreate
HelpStopCityFireMessage.HandleMessage = HandleMessage
return HelpStopCityFireMessage
