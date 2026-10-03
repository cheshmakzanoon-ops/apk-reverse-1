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
    local serverId = t.serverId
    if t.occupyNum then
      local occupyNum = t.occupyNum.occupyNum
      local occupyMaxNum = t.occupyNum.occupyMaxNum
      local dailyOccupyNum = t.occupyNum.dailyOccupyNum
      DataCenter.SeasonDataManager.occupyNum = occupyNum
      DataCenter.SeasonDataManager.occupyMaxNum = occupyMaxNum
      DataCenter.SeasonDataManager.dailyOccupyNum = dailyOccupyNum
      DataCenter.SeasonDataManager.dailyStrongholdOccupyNum = dailyOccupyNum
      if serverId then
        local CrossOccupyMaxNum = DataCenter.SeasonDataManager.CrossOccupyStrongholdMaxNum
        if CrossOccupyMaxNum then
          CrossOccupyMaxNum[tostring(serverId)] = occupyMaxNum
        end
      end
    end
    if t.cityId and t.towerInfo and t.towerInfo.lastTowerAttackTime then
      DataCenter.ZoneWarManager:UpdateBatteryFireTime(t.cityId, t.towerInfo.lastTowerAttackTime)
    end
    local detail = DataCenter.WorldPointDetailManager:UpdateAllianceCity(t, true)
    DataCenter.FormationAssistanceDataManager:OnUpdateFocusCityAssistanceInfo(detail.cityId, detail.maxAssistance, detail.assistanceList)
    EventManager:GetInstance():Broadcast(EventId.WorldAllianceCityDetail)
  end
end

WorldGetAllianceCityDetailMessage.OnCreate = OnCreate
WorldGetAllianceCityDetailMessage.HandleMessage = HandleMessage
return WorldGetAllianceCityDetailMessage
