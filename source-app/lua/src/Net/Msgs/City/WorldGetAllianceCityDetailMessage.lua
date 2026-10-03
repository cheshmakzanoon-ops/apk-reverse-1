local WorldGetAllianceCityDetailMessage = BaseClass("WorldGetAllianceCityDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, cityId, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
  self.sfsObj:PutInt("previewAssistance", 10)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.cityId and t.towerInfo and t.towerInfo.lastTowerAttackTime then
      DataCenter.ZoneWarManager:UpdateBatteryFireTime(t.cityId, t.towerInfo.lastTowerAttackTime)
    end
    if t.occupyInfo then
      local occupyInfo = t.occupyInfo
      if occupyInfo.localMaxNum then
        DataCenter.SeasonDataManager.CrossOccupyCityMaxNumLocal = occupyInfo.localMaxNum
      end
      if occupyInfo.crossMaxNum then
        DataCenter.SeasonDataManager.CrossOccupyCityMaxNumOther = occupyInfo.crossMaxNum
      end
      if t.serverId and occupyInfo.occupyNum then
        local occupyNumDict = DataCenter.SeasonDataManager.CrossOccupyCityNumDict or {}
        occupyNumDict[t.serverId] = occupyInfo.occupyNum
        DataCenter.SeasonDataManager.CrossOccupyCityNumDict = occupyNumDict
      end
    end
    local detail = DataCenter.WorldPointDetailManager:UpdateAllianceCity(t, false)
    DataCenter.FormationAssistanceDataManager:OnUpdateFocusCityAssistanceInfo(detail.cityId, detail.maxAssistance, detail.currAssistance, detail.assistanceList)
    EventManager:GetInstance():Broadcast(EventId.WorldAllianceCityDetail)
  end
end

WorldGetAllianceCityDetailMessage.OnCreate = OnCreate
WorldGetAllianceCityDetailMessage.HandleMessage = HandleMessage
return WorldGetAllianceCityDetailMessage
