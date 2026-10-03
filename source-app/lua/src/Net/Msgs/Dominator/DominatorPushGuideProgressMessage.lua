local DominatorPushGuideProgressMessage = BaseClass("DominatorPushGuideProgressMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutLong("trainId", param.trainId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DominatorGuideManager:UpdateGuideProgress(t, false)
  end
end

DominatorPushGuideProgressMessage.OnCreate = OnCreate
DominatorPushGuideProgressMessage.HandleMessage = HandleMessage
return DominatorPushGuideProgressMessage
