local AllianceBossDigGameOpenMessage = BaseClass("AllianceBossDigGameOpenMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, pos)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("pos", pos)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
end

local SeasonDigGameOpenPushMessage_ = require("Net.Msgs.Season.DiggingGame.SeasonDigGameOpenPushMessage")

function AllianceBossDigGameOpenMessage:GetTestData(uuid, pos)
  return SeasonDigGameOpenPushMessage_.GetTestData(self, uuid or "1", "", pos, SeasonDigGameType.Alliance)
end

AllianceBossDigGameOpenMessage.OnCreate = OnCreate
AllianceBossDigGameOpenMessage.HandleMessage = HandleMessage
return AllianceBossDigGameOpenMessage
