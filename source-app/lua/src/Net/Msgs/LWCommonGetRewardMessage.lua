local LWCommonGetRewardMessage = BaseClass("LWCommonGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, rewardIds, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type or 0)
  self.sfsObj:PutUtfStringArray("rewardIds", rewardIds)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ClientRewardToServerDataManager:HandleServerData(t)
  end
end

LWCommonGetRewardMessage.OnCreate = OnCreate
LWCommonGetRewardMessage.HandleMessage = HandleMessage
return LWCommonGetRewardMessage
