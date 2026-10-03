local SeasonTowerSaveFormationMessage = BaseClass("SeasonTowerSaveFormationMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonTowerSaveFormationMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("stageId", param.stageId)
  local chipSetId = param.chipSetId
  if chipSetId and 0 < chipSetId and chipSetId <= 4 then
    self.sfsObj:PutInt("chipEquipGroup", chipSetId)
  end
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

function SeasonTowerSaveFormationMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local stageData = DataCenter.LWSeasonTowerManager:GetStageDataById(t.stageId)
    if stageData then
      stageData:UpdateHeroes(t.heroes)
      local squadData = DataCenter.LWSeasonTowerManager:GetFormation(t.stageId)
      if squadData then
        squadData:ParseData({
          heroes = t.heroInfos,
          chipEquipGroup = t.chipEquipGroup
        })
      end
    end
    EventManager:GetInstance():Broadcast(EventId.SeasonTowerFormationUpdate)
  end
end

return SeasonTowerSaveFormationMessage
