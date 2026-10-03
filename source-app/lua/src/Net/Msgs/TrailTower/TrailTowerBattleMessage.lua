local TrailTowerBattleMessage = BaseClass("TrailTowerBattleMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function TrailTowerBattleMessage:OnCreate(trailTowerId, trailTowerLvId, heroInfos, chipSetId)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", trailTowerId)
  self.sfsObj:PutInt("lvId", trailTowerLvId)
  if heroInfos then
    if heroInfos.AddSFSObject then
      self.sfsObj:PutSFSArray("heroInfos", heroInfos)
    else
      local heroArray = SFSArray.New()
      table.walk(heroInfos, function(k, v)
        local key = k
        if type(key) == "number" then
          key = tostring(key)
        end
        local obj = SFSObject.New()
        obj:PutLong("heroUuid", v)
        obj:PutUtfString("index", key)
        heroArray:AddSFSObject(obj)
      end)
      self.sfsObj:PutSFSArray("heroInfos", heroArray)
    end
  else
    Logger.LogError("heroInfos is nil")
  end
  if chipSetId and 0 < chipSetId and chipSetId <= 4 then
    self.sfsObj:PutInt("chipEquipGroup", chipSetId)
  end
end

function TrailTowerBattleMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    if errCode == "trialtower_error_01" then
      DataCenter.LWTrailTowerManager:ExitTrailTowerPlay()
    end
  else
    DataCenter.LWTrailTowerManager:TrailTowerBattleDataGet(message, false)
    EventManager:GetInstance():Broadcast(EventId.TrailTowerBattleDataGet, message)
  end
end

return TrailTowerBattleMessage
