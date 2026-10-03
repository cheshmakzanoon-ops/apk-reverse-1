local PlayerStageInfoMessage = BaseClass("PlayerStageInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, stageGroupId, stageId, isWin, templateId, formations, heroes, checkFormation)
  base.OnCreate(self)
  self.sfsObj:PutInt("stageGroupId", stageGroupId)
  self.sfsObj:PutInt("stageId", stageId)
  self.sfsObj:PutBool("isWin", isWin)
  self.sfsObj:PutInt("index", templateId)
  if checkFormation ~= nil then
    self.sfsObj:PutBool("checkFormation", checkFormation)
  end
  local formationArray = SFSArray.New()
  table.walk(formations, function(k, v)
    local key = k
    if type(key) == "number" then
      key = tostring(key)
    end
    local obj = SFSObject.New()
    obj:PutUtfString("armyId", key)
    obj:PutInt("count", math.floor(v))
    formationArray:AddSFSObject(obj)
  end)
  self.sfsObj:PutSFSArray("formations", formationArray)
  if heroes then
    if heroes.AddSFSObject then
      self.sfsObj:PutSFSArray("heroInfos", heroes)
    else
      local heroArray = SFSArray.New()
      table.walk(heroes, function(k, v)
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
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.isWin == true then
    DataCenter.StageManager:UpdateData(message.stageGroupId, message.stageId, message.reward, message.isWin)
    DataCenter.RewardManager:AddRewardsAndRes(message)
    if message.reward then
      EventManager:GetInstance():Broadcast(EventId.LWBattleReward, message.reward)
    end
    EventManager:GetInstance():Broadcast(EventId.LWBarrageBattleEnd, message)
  end
  DataCenter.ArmyFormationDataManager:UpdateTemplateFormationListData(message)
end

PlayerStageInfoMessage.OnCreate = OnCreate
PlayerStageInfoMessage.HandleMessage = HandleMessage
return PlayerStageInfoMessage
