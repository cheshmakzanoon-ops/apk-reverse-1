local base = UIBaseContainer
local CampSelectHistoryItem = BaseClass("CampSelectHistoryItem", base)
local Localization = CS.GameEntry.Localization
local desc_path = "desc"
local time_path = "Txt_Time"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.desc = self:AddComponent(UIText, desc_path)
  self.time = self:AddComponent(UIText, time_path)
end

local function ComponentDestroy(self)
  self.desc = nil
  self.time = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function CampSelectHistoryItem:RefreshItem(data, index)
  self.desc:SetText(self:GetStr(data))
  self.time:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(data.createTime))
end

function CampSelectHistoryItem:GetStr(data)
  local colorStr = "<color=#099b4a>%s</color>"
  local reason = DataCenter.CampWarManager.ExchangeRequestReasonCode
  if data.reasonCode == reason.INITIATOR_EXCHANGE_LIMIT_EXCEEDED then
    local initiatorName = string.format("#%s", data.initiatorServerId)
    local targetName = string.format("%s#%s", data.initiatorAvatar.name, data.initiatorServerId)
    initiatorName = string.format(colorStr, initiatorName)
    targetName = string.format(colorStr, targetName)
    return Localization:GetString("season_s4_camp_battle_15", initiatorName, targetName)
  end
  local status = DataCenter.CampWarManager.ExchangeRequestFinalStatus
  if data.finalStatus == status.PENDING then
    local initiatorName = string.format("%s#%s", data.initiatorAvatar.name, data.initiatorServerId)
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(data.targetOriginalCityId), data.targetServerId)
    local cityName = meta and Localization:GetString(meta.name) or "-"
    local targetName = string.format("%s#%s", cityName, data.targetServerId)
    initiatorName = string.format(colorStr, initiatorName)
    targetName = string.format(colorStr, targetName)
    return Localization:GetString("season_s4_camp_battle_12", initiatorName, targetName)
  end
  if data.finalStatus == status.CANCELLED then
    local initiatorName = string.format("%s#%s", data.initiatorAvatar.name, data.initiatorServerId)
    local targetName = string.format("#%s", data.targetServerId)
    initiatorName = string.format(colorStr, initiatorName)
    targetName = string.format(colorStr, targetName)
    return Localization:GetString("season_s4_camp_battle_18", initiatorName, targetName)
  end
  if data.finalStatus == status.REJECTED then
    local initiatorName = string.format("%s#%s", data.initiatorAvatar.name, data.initiatorServerId)
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(data.targetOriginalCityId), data.targetServerId)
    local cityName = meta and Localization:GetString(meta.name) or "-"
    local targetName = string.format("%s#%s", cityName, data.targetServerId)
    initiatorName = string.format(colorStr, initiatorName)
    targetName = string.format(colorStr, targetName)
    return Localization:GetString("season_s4_camp_battle_13", initiatorName, targetName)
  end
  if data.finalStatus == status.ACCEPTED then
    local initiatorName = string.format("%s#%s", data.initiatorAvatar.name, data.initiatorServerId)
    local targetName = string.format("#%s", data.targetServerId)
    local initiatorMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(data.initiatorNewCityId), data.initiatorServerId)
    local initiatorCityName = initiatorMeta and Localization:GetString(initiatorMeta.name) or "-"
    local targetMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(data.targetNewCityId), data.targetServerId)
    local targetCityName = targetMeta and Localization:GetString(targetMeta.name) or "-"
    local initiatorServerId = string.format("#%s", data.initiatorServerId)
    local targetServerId = string.format("#%s", data.targetServerId)
    initiatorName = string.format(colorStr, initiatorName)
    targetName = string.format(colorStr, targetName)
    initiatorCityName = string.format(colorStr, initiatorCityName)
    targetCityName = string.format(colorStr, targetCityName)
    initiatorServerId = string.format(colorStr, initiatorServerId)
    targetServerId = string.format(colorStr, targetServerId)
    return Localization:GetString("season_s4_camp_battle_14", targetName, initiatorName, initiatorServerId, initiatorCityName, targetServerId, targetCityName)
  end
  return Localization:GetString("season_s4_s_cross_throne_reject_tips_3")
end

CampSelectHistoryItem.OnCreate = OnCreate
CampSelectHistoryItem.OnDestroy = OnDestroy
CampSelectHistoryItem.OnEnable = OnEnable
CampSelectHistoryItem.OnDisable = OnDisable
CampSelectHistoryItem.ComponentDefine = ComponentDefine
CampSelectHistoryItem.ComponentDestroy = ComponentDestroy
CampSelectHistoryItem.DataDefine = DataDefine
CampSelectHistoryItem.DataDestroy = DataDestroy
return CampSelectHistoryItem
