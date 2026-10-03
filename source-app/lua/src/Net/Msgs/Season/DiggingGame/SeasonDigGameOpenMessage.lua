local SeasonDigGameOpenMessage = BaseClass("SeasonDigGameOpenMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, uid, pos, type_)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type_ or 1)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutUtfString("uid", uid)
  self.sfsObj:PutInt("pos", pos)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
end

local function GetTestData(self, uuid, uid, pos, type_)
  local t = {}
  SFSNetwork.SendMessage(MsgDefines.SeasonDigGameOpenPush, uuid, uid, pos, type_)
  return t
end

SeasonDigGameOpenMessage.GetTestData = GetTestData
SeasonDigGameOpenMessage.OnCreate = OnCreate
SeasonDigGameOpenMessage.HandleMessage = HandleMessage
return SeasonDigGameOpenMessage
