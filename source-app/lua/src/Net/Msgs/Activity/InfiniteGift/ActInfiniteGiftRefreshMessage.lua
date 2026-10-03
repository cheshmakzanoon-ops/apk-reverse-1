local ActInfiniteGiftRefreshMessage = BaseClass("ActInfiniteGiftRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, aid, gid)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", aid)
  self.sfsObj:PutInt("gid", gid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId(2010807)
  end
end

ActInfiniteGiftRefreshMessage.OnCreate = OnCreate
ActInfiniteGiftRefreshMessage.HandleMessage = HandleMessage
return ActInfiniteGiftRefreshMessage
