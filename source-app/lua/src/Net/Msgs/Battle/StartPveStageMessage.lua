local StartPveStageMessage = BaseClass("StartPveStageMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, stageGroupId, stageId, formationTemplateId, formations, heroInfos, chipSetId)
  base.OnCreate(self)
  self.sfsObj:PutInt("stageGroupId", stageGroupId)
  self.sfsObj:PutInt("stageId", stageId)
  self.sfsObj:PutInt("index", formationTemplateId)
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
  local stage = string.format("%s/%s", stageGroupId, stageId)
  PostEventLog.Track(PostEventLog.Defines.BattleBarrageStart, {
    stageId = tostring(stageId)
  })
  if chipSetId and 0 < chipSetId and chipSetId <= 4 then
    self.sfsObj:PutInt("chipEquipGroup", chipSetId)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ArmyFormationDataManager:UpdateTemplateFormationListData(t)
    EventManager:GetInstance():Broadcast(EventId.ArmyFormatUpdate)
    DataCenter.ZombieBattleManager:StartBattle()
    if t.idleRewardStageId and t.lastIdleRewardTimeStamp then
      DataCenter.StageManager:UpdateHangUpReward(t.lastIdleRewardTimeStamp, t.idleRewardStageId)
    end
  end
end

StartPveStageMessage.OnCreate = OnCreate
StartPveStageMessage.HandleMessage = HandleMessage
return StartPveStageMessage
