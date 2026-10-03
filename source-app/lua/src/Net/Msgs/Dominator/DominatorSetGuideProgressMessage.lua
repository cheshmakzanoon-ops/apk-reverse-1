local DominatorSetGuideProgressMessage = BaseClass("DominatorSetGuideProgressMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("guid", param.guid)
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

DominatorSetGuideProgressMessage.OnCreate = OnCreate
DominatorSetGuideProgressMessage.HandleMessage = HandleMessage
return DominatorSetGuideProgressMessage
