local base = UIBaseContainer
local S6SelectCampRecordsCell = BaseClass("S6SelectCampRecordsCell", UIBaseContainer)

function S6SelectCampRecordsCell:ComponentDefine()
  self.p_log_icon = self:AddComponent(UIImage, "p_log_icon")
  self.p_log_desc = self:AddComponent(UITextMeshProUGUIEx, "p_log_desc")
  self.p_log_time = self:AddComponent(UITextMeshProUGUIEx, "p_log_time")
end

function S6SelectCampRecordsCell:ComponentDestroy()
  self.p_log_icon = nil
  self.p_log_desc = nil
  self.p_log_time = nil
end

function S6SelectCampRecordsCell:DataDefine()
end

function S6SelectCampRecordsCell:DataDestroy()
end

function S6SelectCampRecordsCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function S6SelectCampRecordsCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function S6SelectCampRecordsCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function S6SelectCampRecordsCell:InitData(data)
  if data ~= nil and data.Record ~= nil then
    self.Record = data.Record
    return true
  end
  return false
end

function S6SelectCampRecordsCell:InitUi()
  self.p_log_desc:SetText(self:GetDesc())
  self.p_log_time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(self.Record.Time))
  self.p_log_icon:LoadSpriteAsync(DataCenter.SeasonSelectCampManager.Icons[Mathf.Clamp(checknumber(self.Record.Value), 0, 2)])
end

function S6SelectCampRecordsCell:GetDesc()
  local record = self.Record
  if string.IsNullOrEmpty(record) then
    return ""
  end
  local timeStr = UITimeManager:GetInstance():TimeStampToTimeForServer(self.Record.Time)
  local serverStr = string.format("#%s", record.Sid)
  local nameStr = ""
  if record.KingInfo ~= nil then
    nameStr = record.KingInfo:GetFullName()
  end
  local valueStr = self:Value2Num(record.Value)
  if record.IsUserCreated == 1 then
    if checknumber(record.Value) == 0 then
      return CS.GameEntry.Localization:GetString("season_s6_activity_1200080_desc18", timeStr, serverStr, nameStr)
    end
    return CS.GameEntry.Localization:GetString("season_s6_activity_1200080_desc06", timeStr, serverStr, nameStr, valueStr)
  else
    return CS.GameEntry.Localization:GetString("season_s6_activity_1200080_desc07", timeStr, serverStr, nameStr, valueStr)
  end
  return ""
end

function S6SelectCampRecordsCell:Value2Num(value)
  value = checknumber(value)
  if value == 0 then
    return -1
  elseif value == 1 then
    return 0
  elseif value == 2 then
    return 1
  end
  return -1
end

return S6SelectCampRecordsCell
