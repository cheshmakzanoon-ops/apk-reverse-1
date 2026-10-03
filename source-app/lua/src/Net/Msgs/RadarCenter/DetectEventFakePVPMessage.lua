local DetectEventFakePVPMessage = BaseClass("DetectEventFakePVPMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, formationTemplateId, heroInfos, chipSetId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
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
    EventManager:GetInstance():Broadcast(EventId.TowerupFakePVPBattleDataGet, t)
  end
end

DetectEventFakePVPMessage.OnCreate = OnCreate
DetectEventFakePVPMessage.HandleMessage = HandleMessage
return DetectEventFakePVPMessage
