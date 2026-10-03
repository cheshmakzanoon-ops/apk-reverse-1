local LWSheepGetRankMessage = BaseClass("LWSheepGetRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSheepDataManager:UpdateRank(t)
  end
end

LWSheepGetRankMessage.OnCreate = OnCreate
LWSheepGetRankMessage.HandleMessage = HandleMessage
return LWSheepGetRankMessage
