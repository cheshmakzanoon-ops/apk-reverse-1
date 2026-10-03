local SeasonTowerBattleMessage = BaseClass("SeasonTowerBattleMessage", SFSBaseMessage)
local LWSeasonTowerUtil = require("DataCenter.LWSeasonTowerManager.LWSeasonTowerUtil")
local base = SFSBaseMessage

function SeasonTowerBattleMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("stageId", param.stageId)
  self.sfsObj:PutInt("type", param.type)
  local heroInfos = param.heroes
  if heroInfos.AddSFSObject then
    self.sfsObj:PutSFSArray("heroInfos", heroInfos)
  else
    local heroArray = SFSArray.New()
    table.walk(heroInfos, function(k, v)
      local key = v.index
      if type(key) == "number" then
        key = tostring(key)
      end
      local obj = SFSObject.New()
      obj:PutLong("heroUuid", v.heroUuid)
      obj:PutUtfString("index", key)
      heroArray:AddSFSObject(obj)
    end)
    self.sfsObj:PutSFSArray("heroInfos", heroArray)
  end
end

function SeasonTowerBattleMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.LWSeasonTowerSceneManager:ClearReadyEffect()
    EventManager:GetInstance():Broadcast(EventId.SeasonTowerSweepStageChange, {
      isSweeping = false,
      showLevelList = {},
      noneLevelPass = true
    })
  else
    if t.type == SeasonTowerConfig.BattleType.Sweep then
      local result, resultFloors = LWSeasonTowerUtil.GetEffectShowListByNum(t.addFloor)
      DataCenter.LWSeasonTowerSceneManager:PlayEffect(result, resultFloors)
    else
      EventManager:GetInstance():Broadcast(EventId.SeasonTowerFakePVPBattleDataGet, t)
    end
    local stageData = DataCenter.LWSeasonTowerManager:GetStageDataById(t.stageId)
    if stageData ~= nil then
      stageData.floor = t.currFloor
    end
    if t.score then
      DataCenter.LWSeasonTowerManager.score = t.score
    end
    EventManager:GetInstance():Broadcast(EventId.SeasonTowerStageInfoRefresh)
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonTower_RefreshBubble)
end

return SeasonTowerBattleMessage
