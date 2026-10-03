local AllianceBossDigGameInfoMessage = BaseClass("AllianceBossDigGameInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local DiggingMapData = require("DataCenter.DiggingGame.DiggingMapData")

local function OnCreate(self, uuid)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  local data = DiggingMapData.New()
  data:UpdateData(t)
  if not data.type or data.type <= 0 then
    data.type = SeasonDigGameType.Alliance
  end
  DataCenter.DiggingDataManager.curMapData = data
  EventManager:GetInstance():Broadcast(EventId.DiggingGameMapData, data)
  UIManager:GetInstance():OpenWindow(UIWindowNames.DiggingLevelAllianceCView, {anim = true}, data)
end

local SeasonDigGameInfoMessage_ = require("Net.Msgs.Season.DiggingGame.SeasonDigGameInfoMessage")

function AllianceBossDigGameInfoMessage:GetTestData(uuid, type_)
  return SeasonDigGameInfoMessage_.GetTestData(self, uuid or "1", SeasonDigGameType.Alliance)
end

AllianceBossDigGameInfoMessage.OnCreate = OnCreate
AllianceBossDigGameInfoMessage.HandleMessage = HandleMessage
return AllianceBossDigGameInfoMessage
