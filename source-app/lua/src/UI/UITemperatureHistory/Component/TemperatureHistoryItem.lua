local TemperatureHistoryItem = BaseClass("TemperatureHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ui_player_head_path = "UIPlayerHead"
local txt_des_path = "Txt_Des"
local txt_time_path = "Txt_Time"
local txt_name_path = "Txt_Title"

function TemperatureHistoryItem:OnCreate()
  base.OnCreate(self)
  self.player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
end

function TemperatureHistoryItem:OnDestroy()
  base.OnDestroy(self)
  self.player_head = nil
  self.txt_des = nil
  self.txt_time = nil
  self.txt_name = nil
end

function TemperatureHistoryItem:ReInit(index, data)
  local change = DataCenter.TemperatureManager:FormatTemperature(data.add)
  change = 0 <= change and "+ " .. change or "- " .. math.abs(change)
  if data.type == TemperatureChangeType.AttackedByRunningBoss or data.type == TemperatureChangeType.AttackedByZombieRushBoss then
    self.txt_name:SetColorRGBA(1, 0.09, 0.22, 1)
    self.txt_des:SetLocalText("season_s2_temperature_list2", "", change)
  elseif data.type == TemperatureChangeType.AttackedByPlayer then
    self.txt_name:SetColorRGBA(1, 0.09, 0.22, 1)
    self.txt_des:SetLocalText("season_s2_temperature_list2", "", change)
  elseif data.type == TemperatureChangeType.LANDMINE then
    self.txt_name:SetColorRGBA(1, 0.09, 0.22, 1)
    self.txt_des:SetLocalText("season_s2_temperature_list1", Localization:GetString("season_mastery_s2_name_1_6"), change)
  elseif data.type == TemperatureChangeType.WARMING then
    self.txt_name:SetColorRGBA(0.14, 0.61, 0.77, 1)
    self.txt_des:SetLocalText("season_s2_temperature_list1", Localization:GetString("season_s2_send_warm"), change)
  end
  if data.time then
    self.txt_time:SetText(UITimeManager:GetInstance():ConvertServerTimeToLocalTime(data.time, false))
  else
    self.txt_time:SetText("")
  end
  if table.IsNullOrEmpty(data.avatar) then
    local meta = DataCenter.MonsterTemplateManager:GetMonsterTemplate(data.cfgId)
    self.player_head:SetData(nil, meta:GetSmallIcon())
    self.player_head:SetEnableClickShowInfo(false, true)
    self.txt_name:SetLocalText(meta.name)
    self.txt_name:SetColorRGBA(1, 0.09, 0.22, 1)
  else
    self.player_head:SetHeadAndFrame(data.avatar.uid, data.avatar.headPic, data.avatar.headPicVer, nil, data.avatar.headSkinId, data.avatar.headSkinET)
    self.player_head:SetEnableClickShowInfo(true, true)
    self.txt_name:SetText(UIUtil.FormatAllianceAndName(data.avatar.abbr, data.avatar.name))
    if data.avatar.uid and data.avatar.serverId and data.avatar.allianceId then
      local color = UIUtil.GetPlayerCampColor(data.avatar.uid, data.avatar.allianceId, data.avatar.serverId)
      self.txt_name:SetColor(color)
    end
  end
end

return TemperatureHistoryItem
