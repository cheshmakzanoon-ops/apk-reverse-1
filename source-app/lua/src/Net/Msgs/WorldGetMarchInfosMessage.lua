local WorldGetMarchInfosMessage = BaseClass("WorldGetMarchInfosMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, x, y)
  base.OnCreate(self)
  self.sfsObj:PutInt("x", toInt(x))
  self.sfsObj:PutInt("y", toInt(y))
  self.sfsObj:PutBool("needCross", true)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldMarchDataManager:WorldMarchGetHandle(t)
  end
end

WorldGetMarchInfosMessage.OnCreate = OnCreate
WorldGetMarchInfosMessage.HandleMessage = HandleMessage
return WorldGetMarchInfosMessage
