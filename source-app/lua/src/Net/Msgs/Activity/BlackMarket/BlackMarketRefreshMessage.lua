local BlackMarketRefreshMessage = BaseClass("BlackMarketRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, aid)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", aid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActBlackMarketDataManager:ParseActInfoMessage(t)
  end
end

BlackMarketRefreshMessage.OnCreate = OnCreate
BlackMarketRefreshMessage.HandleMessage = HandleMessage
return BlackMarketRefreshMessage
