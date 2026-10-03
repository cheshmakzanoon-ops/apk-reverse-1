local AlApplyListMessage = BaseClass("AlApplyListMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, page)
  base.OnCreate(self)
  self.sfsObj:PutInt("page", page)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceMemberDataManager:UpdateAllianceApplyList(t)
    EventManager:GetInstance():Broadcast(EventId.AllianceMemberRedPoint)
  end
end

AlApplyListMessage.OnCreate = OnCreate
AlApplyListMessage.HandleMessage = HandleMessage
return AlApplyListMessage
