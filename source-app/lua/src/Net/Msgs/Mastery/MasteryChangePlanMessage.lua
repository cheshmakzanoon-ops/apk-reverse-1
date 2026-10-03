local MasteryChangePlanMessage = BaseClass("MasteryChangePlanMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, planIndex)
  base.OnCreate(self)
  self.sfsObj:PutInt("targetPage", planIndex)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.MasteryManager:HandleChangePlan(t)
end

MasteryChangePlanMessage.OnCreate = OnCreate
MasteryChangePlanMessage.HandleMessage = HandleMessage
return MasteryChangePlanMessage
