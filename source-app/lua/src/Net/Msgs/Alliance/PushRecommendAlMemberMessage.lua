local PushRecommendAlMemberMessage = BaseClass("PushRecommendAlMemberMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceMemberDataManager:UpdateAlMemberRecommendNum(t)
  end
end

PushRecommendAlMemberMessage.OnCreate = OnCreate
PushRecommendAlMemberMessage.HandleMessage = HandleMessage
return PushRecommendAlMemberMessage
