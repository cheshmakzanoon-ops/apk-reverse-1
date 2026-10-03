local VirusHistoryItem = BaseClass("VirusHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local ui_player_head_path = "UIPlayerHead"
local txt_des_path = "Txt_Des"
local txt_time_path = "Txt_Time"
local txt_name_path = "Txt_Title"

function VirusHistoryItem:OnCreate()
  base.OnCreate(self)
  self.player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
end

function VirusHistoryItem:OnDestroy()
  base.OnDestroy(self)
  self.player_head = nil
  self.txt_des = nil
  self.txt_time = nil
  self.txt_name = nil
end

function VirusHistoryItem:ReInit(index, data)
  local change = data.add
  if data.type == VirusChangeType.PVELackResist then
    self.txt_name:SetColorRGBA(1, 0.09, 0.22, 1)
    self.txt_des:SetLocalText("season_s1_add_virus_info01", change)
  elseif data.type == VirusChangeType.PVESpecial then
    self.txt_name:SetColorRGBA(1, 0.09, 0.22, 1)
    self.txt_des:SetLocalText("season_s1_add_virus_info02", change)
  elseif data.type == VirusChangeType.PVPLose then
    self.txt_name:SetColorRGBA(1, 0.09, 0.22, 1)
    self.txt_des:SetLocalText("season_s1_add_virus_info03", change)
  elseif data.type == VirusChangeType.PVPWin then
    self.txt_name:SetColorRGBA(1, 0.09, 0.22, 1)
    self.txt_des:SetLocalText("season_s1_add_virus_info04", change)
  elseif data.type == VirusChangeType.VirusExplosion then
    self.txt_name:SetColorRGBA(1, 0.09, 0.22, 1)
    self.txt_des:SetLocalText("season_s1_add_virus_info06", change)
  elseif data.type == VirusChangeType.CultivateVirus then
    self.txt_name:SetColorRGBA(0.14, 0.61, 0.77, 1)
    self.txt_des:SetLocalText("season_s1_add_virus_info07", change)
  elseif data.type == VirusChangeType.Pumpkin then
    self.txt_name:SetColorRGBA(1, 0.09, 0.22, 1)
    self.txt_des:SetLocalText("season_s1_add_virus_info09", change)
  elseif data.type == VirusChangeType.Weather then
    self.txt_name:SetColorRGBA(1, 0.09, 0.22, 1)
    self.txt_des:SetLocalText("s1_virus_info01", change)
  elseif data.type == VirusChangeType.WorldBuildingAdd then
    self.txt_name:SetColorRGBA(1, 0.09, 0.22, 1)
    self.txt_des:SetLocalText("season_mastery_S1_2025_tips4", change)
  end
  if data.time then
    self.txt_time:SetText(UITimeManager:GetInstance():ConvertServerTimeToLocalTime(data.time, false))
  else
    self.txt_time:SetText("")
  end
  if data.type == VirusChangeType.PVELackResist or data.type == VirusChangeType.PVESpecial then
    local meta = DataCenter.MonsterTemplateManager:GetMonsterTemplate(data.cfgId)
    self.player_head:SetData(nil, meta:GetSmallIcon())
    self.player_head:SetEnableClickShowInfo(false, true)
    self.txt_name:SetLocalText(meta.name)
  elseif data.type == VirusChangeType.PVPLose or data.type == VirusChangeType.PVPWin then
    self.player_head:SetHeadAndFrame(data.avatar.uid, data.avatar.headPic, data.avatar.headPicVer, nil, data.avatar.headSkinId, data.avatar.headSkinET)
    self.player_head:SetEnableClickShowInfo(true, true)
    self.txt_name:SetText(UIUtil.FormatAllianceAndName(data.avatar.abbr, data.avatar.name))
  elseif data.type == VirusChangeType.VirusExplosion then
    local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(data.cfgId)
    local iconPath = skillTemp:GetIconFullPath()
    self.player_head:SetData(nil, iconPath)
    self.player_head:SetEnableClickShowInfo(false, true)
    self.txt_name:SetLocalText(skillTemp.name)
  elseif data.type == VirusChangeType.CultivateVirus then
    local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(data.cfgId)
    local iconPath = skillTemp:GetIconFullPath()
    self.player_head:SetData(nil, iconPath)
    self.player_head:SetEnableClickShowInfo(false, true)
    self.txt_name:SetLocalText(skillTemp.name)
  elseif data.type == VirusChangeType.Pumpkin then
    self.player_head:SetData(nil, "Assets/Main/Sprites/ItemIcons/icon_building_halloween2023.png")
    self.player_head:SetEnableClickShowInfo(false, true)
    self.txt_name:SetText(UIUtil.FormatAllianceAndName(data.avatar.abbr, data.avatar.name))
  elseif data.type == VirusChangeType.Weather then
    local weatherType = data.cfgId or 0
    local typeInfo = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(weatherType)
    if typeInfo then
      self.player_head:SetData(nil, typeInfo.icon)
      self.player_head:SetEnableClickShowInfo(false, true)
      self.txt_name:SetLocalText(typeInfo.name)
    end
  elseif data.type == VirusChangeType.WorldBuildingAdd then
    self.player_head:SetHeadAndFrame(data.avatar.uid, data.avatar.headPic, data.avatar.headPicVer, nil, data.avatar.headSkinId, data.avatar.headSkinET)
    self.player_head:SetEnableClickShowInfo(true, true)
    self.txt_name:SetText(UIUtil.FormatAllianceAndName(data.avatar.abbr, data.avatar.name))
  end
end

return VirusHistoryItem
