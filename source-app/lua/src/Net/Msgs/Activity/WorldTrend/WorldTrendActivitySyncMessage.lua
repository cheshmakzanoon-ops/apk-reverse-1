local WorldTrendActivitySyncMessage = BaseClass("WorldTrendActivitySyncMessage", SFSBaseMessage)
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
    DataCenter.LWWorldTrendDataManager:ParseActivityData(t)
  end
end

WorldTrendActivitySyncMessage.OnCreate = OnCreate
WorldTrendActivitySyncMessage.HandleMessage = HandleMessage
return WorldTrendActivitySyncMessage
