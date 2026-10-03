local ModifyDefenceFormationMessage = BaseClass("ModifyDefenceFormationMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, action)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("action", action)
  local formationType = 0
  if BattleFieldUtil.InBattleField() then
    local flag = DataCenter.ArmyFormationDataManager.UseBattleFieldFlag
    if flag then
      formationType = 7
    end
  end
  self.sfsObj:PutInt("formationType", formationType)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.army_formation then
    table.walk(message.army_formation, function(k, v)
      DataCenter.ArmyFormationDataManager:UpdateArmyFormationListData(v)
    end)
    EventManager:GetInstance():Broadcast(EventId.CityDefencePriorityUpdate)
  end
  if message.battlefield_formation then
    table.walk(message.battlefield_formation, function(k, v)
      DataCenter.ArmyFormationDataManager:UpdateArmyFormationListData(v)
    end)
    EventManager:GetInstance():Broadcast(EventId.CityDefencePriorityUpdate)
  end
end

ModifyDefenceFormationMessage.OnCreate = OnCreate
ModifyDefenceFormationMessage.HandleMessage = HandleMessage
return ModifyDefenceFormationMessage
