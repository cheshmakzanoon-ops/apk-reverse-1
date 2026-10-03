local FormationSaveMessage = BaseClass("FormationSaveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, index, heroInfos, saveType, chipSetId, squadNo)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
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
  self.sfsObj:PutInt("action", saveType)
  if chipSetId and 0 < chipSetId and chipSetId <= 4 then
    self.sfsObj:PutInt("chipEquipGroup", chipSetId)
  end
  if squadNo and 0 < squadNo and squadNo <= 4 then
    self.sfsObj:PutInt("squadNo", squadNo)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local actionType = t.action
    if actionType == FormationSaveType.PVESquad or actionType == FormationSaveType.PVESquadAuto or actionType == FormationSaveType.DominatorAndHero345 or actionType == FormationSaveType.OnlyDominator or actionType == FormationSaveType.DominatorNormal or actionType == FormationSaveType.T11IdleGameBattleEvent then
      DataCenter.ArmyFormationDataManager:UpdateTemplateFormationListData(t)
      if actionType == FormationSaveType.PVESquad then
        local isChange = true
        if t.isChange ~= nil then
          isChange = t.isChange
        end
        if isChange then
          UIUtil.ShowTipsId(300056)
        end
      end
    elseif actionType == FormationSaveType.TruckDefenceSquad then
      DataCenter.LWMyStationDataManager:OnGetSaveTruckFormation(t, false)
    elseif actionType == FormationSaveType.TruckAttackSquad then
      DataCenter.LWMyStationDataManager:OnGetSaveTruckFormation(t, true)
    end
    EventManager:GetInstance():Broadcast(EventId.ArmyFormatUpdate)
  end
end

FormationSaveMessage.OnCreate = OnCreate
FormationSaveMessage.HandleMessage = HandleMessage
return FormationSaveMessage
