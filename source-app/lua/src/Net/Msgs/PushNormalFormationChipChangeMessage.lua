local PushNormalFormationChipChangeMessage = BaseClass("PushNormalFormationChipChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local updateFormation = t.groupEnum
    local useSetId = t.value
    if updateFormation then
      local formationData = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByIndex(updateFormation)
      if formationData then
        local msg = {}
        msg.uuid = formationData.uuid
        msg.chipEquipGroup = useSetId
        DataCenter.ArmyFormationDataManager:UpdateArmyFormationListData(msg)
      end
    end
  end
end

PushNormalFormationChipChangeMessage.OnCreate = OnCreate
PushNormalFormationChipChangeMessage.HandleMessage = HandleMessage
return PushNormalFormationChipChangeMessage
