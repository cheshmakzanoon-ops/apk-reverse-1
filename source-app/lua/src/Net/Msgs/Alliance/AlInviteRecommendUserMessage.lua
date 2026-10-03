local AlInviteRecommendUserMessage = BaseClass("AlInviteRecommendUserMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("inviteUid", uid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.inviteUid then
    local uid = t.inviteUid
    EventManager:GetInstance():Broadcast(EventId.AlInviteRecommendUserSucc, uid)
  end
end

AlInviteRecommendUserMessage.OnCreate = OnCreate
AlInviteRecommendUserMessage.HandleMessage = HandleMessage
return AlInviteRecommendUserMessage
