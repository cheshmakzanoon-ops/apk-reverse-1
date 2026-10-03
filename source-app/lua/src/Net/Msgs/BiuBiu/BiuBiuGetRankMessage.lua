local BiuBiuGetRankMessage = BaseClass("BiuBiuGetRankMessage", SFSBaseMessage)
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
    DataCenter.LWBiuBiuDataManager:UpdateRank(t)
  end
end

BiuBiuGetRankMessage.OnCreate = OnCreate
BiuBiuGetRankMessage.HandleMessage = HandleMessage
return BiuBiuGetRankMessage
