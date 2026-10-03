local DominatorEditUserNameMessage = BaseClass("DominatorEditUserNameMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutUtfString("name", param.name)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DominatorManager:OnEditUserNameCallback(t)
  end
end

DominatorEditUserNameMessage.OnCreate = OnCreate
DominatorEditUserNameMessage.HandleMessage = HandleMessage
return DominatorEditUserNameMessage
