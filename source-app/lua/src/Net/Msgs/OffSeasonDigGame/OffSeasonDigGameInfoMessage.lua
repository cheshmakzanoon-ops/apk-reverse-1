local OffSeasonDigGameInfoMessage = BaseClass("OffSeasonDigGameInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local DiggingMapData = require("DataCenter.DiggingGame.DiggingMapData")

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  local data = DiggingMapData.New()
  data:UpdateData(t)
  DataCenter.OffSeasonDiggingDataManager.curMapData = data
  EventManager:GetInstance():Broadcast(EventId.DiggingGameMapData, data)
  UIManager:GetInstance():OpenWindow(UIWindowNames.OffSeasonDiggingLevelAllianceView, {anim = true}, data)
end

OffSeasonDigGameInfoMessage.OnCreate = OnCreate
OffSeasonDigGameInfoMessage.HandleMessage = HandleMessage
return OffSeasonDigGameInfoMessage
