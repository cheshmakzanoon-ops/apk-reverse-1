local TacticalCardSlotData = BaseClass("TacticalCardSlotData")
local Localization = CS.GameEntry.Localization

local function __init(self)
end

local function __delete(self)
end

function TacticalCardSlotData:InitData(templateData)
  self.tmpData = templateData
  self.masteryId = templateData.mastery
  self.season = templateData.season
  self.slotId = templateData.slot_id
  self.slotType = templateData.type
  self:ParseUnlockCondition()
end

function TacticalCardSlotData:ParseUnlockCondition()
  self.unlockCondList = {}
  if not self.tmpData then
    return
  end
  local condInfoList = string.split(self.tmpData.slot_condition, "|")
  for _, v in ipairs(condInfoList) do
    local condInfos = string.split(v, ";")
    if #condInfos == 2 then
      local condType = toInt(condInfos[1])
      local condParam = toInt(condInfos[2])
      self.unlockCondList[condType] = condParam
    end
  end
end

function TacticalCardSlotData:ShowLockTips()
  self:GetSlotUnlockState(true)
end

function TacticalCardSlotData:GetSlotUnlockState(isShowLockTips)
  if table.count(self.unlockCondList) <= 0 then
    if isShowLockTips then
      UIUtil.ShowTipsId(120050)
    end
    return false
  end
  if self.slotType ~= TacticalCardSlotType.Core and not DataCenter.SeasonDataManager:InNormalMode() then
    if isShowLockTips then
      UIUtil.ShowTipsId("battle_card_slot_rest")
    end
    return false
  end
  for condType, param in pairs(self.unlockCondList) do
    if condType == TacticalCardSlotUnlockCond.SeasonPassDay then
      local unlockSeasonDay = param
      local curSeasonId = SeasonUtil.GetSeason()
      local curSeasonDay = SeasonUtil.GetSeasonDay()
      if unlockSeasonDay > curSeasonDay then
        if isShowLockTips then
          UIUtil.ShowTips(CS.GameEntry.Localization:GetString("battle_card_unlock", unlockSeasonDay))
        end
        return false
      end
    elseif condType == TacticalCardSlotUnlockCond.MasteryLv then
      local masteryData = DataCenter.MasteryManager:GetData()
      local curLv = masteryData.level
      local unlockLv = param
      if curLv < unlockLv then
        if isShowLockTips then
          UIUtil.ShowTips(CS.GameEntry.Localization:GetString("battle_card_slot_level", unlockLv))
        end
        return false
      end
    end
  end
  return true
end

function TacticalCardSlotData:IsEquipCard()
  return self:GetCardData() ~= nil
end

function TacticalCardSlotData:IsLock(isShowTips)
  local isLock = not self:GetSlotUnlockState(isShowTips)
  if isShowTips then
    self:ShowLockTips()
  end
  return isLock
end

function TacticalCardSlotData:IsCD(isShowTips)
  if self:IsEquipCard() and self:GetCardData():IsInCd() then
    if isShowTips then
      UIUtil.ShowTips(Localization:GetString("battle_card_change_cd"))
    end
    return true
  end
  return false
end

function TacticalCardSlotData:IsCanEquipCard(isShowTips)
  if self:IsLock(isShowTips) then
    return false
  end
  if self:IsCD(isShowTips) then
    return false
  end
  if DataCenter.ArmyFormationDataManager:IsAnyWorldFormationOutside() then
    if isShowTips then
      UIUtil.ShowTips(Localization:GetString("battle_card_change_tips2"))
    end
    return false
  end
  return true
end

function TacticalCardSlotData:IsCanUnEquipCard(isShowTips)
  if self:IsLock(isShowTips) then
    return false
  end
  if self:IsCD(isShowTips) then
    return false
  end
  if DataCenter.ArmyFormationDataManager:IsAnyWorldFormationOutside() then
    if isShowTips then
      UIUtil.ShowTips(Localization:GetString("battle_card_change_tips2"))
    end
    return false
  end
  return true
end

function TacticalCardSlotData:GetCardData()
  local cardData
  if not self.slotId then
    return nil
  end
  local isEquipCardInSlot = TacticalCardUtil.IsSlotEquipCard(self.slotId)
  if isEquipCardInSlot then
    cardData = DataCenter.TacticalCardDataManager:GetCardDataBySlot(self.slotId)
  else
    cardData = nil
  end
  return cardData
end

function TacticalCardSlotData:GetSlotType()
  return self.slotType
end

TacticalCardSlotData.__init = __init
TacticalCardSlotData.__delete = __delete
return TacticalCardSlotData
