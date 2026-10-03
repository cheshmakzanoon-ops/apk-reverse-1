local NormalFormationInfoSaveMessage = BaseClass("NormalFormationInfoSaveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, heroInfos, saveType, chipSetId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", tonumber(uuid))
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
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ArmyFormationDataManager:UpdateArmyFormationListData(t)
    EventManager:GetInstance():Broadcast(EventId.ArmyFormatUpdate)
    EventManager:GetInstance():Broadcast(EventId.GF_hero_squad_saved, t.index)
    if t.action == 1 then
      UIUtil.ShowTipsId(300056)
    end
  end
end

NormalFormationInfoSaveMessage.OnCreate = OnCreate
NormalFormationInfoSaveMessage.HandleMessage = HandleMessage
return NormalFormationInfoSaveMessage
