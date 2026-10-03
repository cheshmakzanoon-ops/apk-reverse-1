local DragonOperateLogMessage = BaseClass("DragonOperateLogMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertOperateLog, {anim = true}, t)
  end
end

DragonOperateLogMessage.OnCreate = OnCreate
DragonOperateLogMessage.HandleMessage = HandleMessage
return DragonOperateLogMessage
