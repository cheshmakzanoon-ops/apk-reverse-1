local UILWSeasonFactionHistoryItem = BaseClass("UILWSeasonFactionHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ui_player_head_path = "UIPlayerHead"
local txt_des_path = "Txt_Des"
local txt_time_path = "Txt_Time"
local txt_title_path = "Txt_Title"

function UILWSeasonFactionHistoryItem:OnCreate()
  base.OnCreate(self)
  self.player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.player_head:SetEnableClickShowInfo(true, true)
  self.camp_1_name = Localization:GetString("season_s2_camp_choose_04")
  self.camp_2_name = Localization:GetString("season_s2_camp_choose_05")
end

function UILWSeasonFactionHistoryItem:OnDestroy()
  base.OnDestroy(self)
  self.player_head = nil
  self.txt_des = nil
  self.txt_time = nil
  self.txt_title = nil
end

function UILWSeasonFactionHistoryItem:ReInit(index, data)
  local StrServerId = "???"
  local StrName = "???"
  local StrCampName = self.camp_1_name
  local time = UITimeManager:GetInstance():GetServerTimeByUTC(data.time, false)
  self.txt_time:SetText(time)
  if data.serverId ~= nil and data.serverId ~= 0 then
    StrServerId = "#" .. data.serverId
    StrName = data.name or "???"
  end
  if data.campId == SeasonFactionType.Gendarmerie then
    StrCampName = self.camp_2_name
  end
  if data.type == "king" then
    if data.value == 1 then
      StrCampName = Localization:GetString("season_s3_activity_1000063_desc12")
    elseif data.value == 2 then
      StrCampName = Localization:GetString("season_s3_activity_1000063_desc13")
    else
      StrCampName = "???"
    end
    if data.userInfo and data.userInfo.name then
      StrName = data.userInfo.name
    end
    self.txt_title:SetLocalText("season_s3_activity_1000063_desc03")
    self.txt_des:SetLocalText("season_s3_activity_1000063_desc05", time, StrServerId, StrName, StrCampName)
  elseif data.type == 1 then
    self.txt_title:SetLocalText("season_s2_camp_choose_06")
    self.txt_des:SetLocalText("season_s2_camp_choose_10", StrServerId, "", StrName, StrCampName)
  elseif data.type == 2 then
    local StrServerId2 = "???"
    local StrCampName2 = self.camp_1_name
    if data.otherServerId ~= nil and data.otherServerId ~= 0 then
      StrServerId2 = "#" .. data.otherServerId
    end
    if data.otherCampId == SeasonFactionType.Gendarmerie then
      StrCampName2 = self.camp_2_name
    end
    self.txt_title:SetLocalText("season_s2_camp_choose_07")
    self.txt_des:SetLocalText("season_s2_camp_choose_11", StrServerId, "", StrName, StrCampName, StrServerId2, StrCampName2)
  elseif data.type == 3 then
    self.txt_title:SetLocalText("season_s2_camp_choose_06")
    self.txt_des:SetLocalText("season_s2_camp_choose_18", data.serverId, "", StrCampName)
  elseif data.type == 4 then
    self.txt_title:SetLocalText("season_s3_activity_1000063_desc03")
    self.txt_des:SetText("")
    local d1 = data.serverList[1]
    local d2 = data.serverList[2]
    if d1 == nil or d2 == nil then
      return
    end
    local v_select_1 = d1.value
    local v_select_2 = d2.value
    local server_camp_1 = d1.serverId
    local server_camp_2 = d2.serverId
    if d1.campResult ~= SeasonFactionType.Rebels then
      server_camp_1 = d2.serverId
      server_camp_2 = d1.serverId
    end
    if v_select_1 == -1 and v_select_2 == -1 then
      self.txt_des:SetLocalText("season_s3_activity_1000063_history_01", server_camp_1, server_camp_2)
    elseif v_select_1 == -1 then
      self.txt_des:SetLocalText("season_s3_activity_1000063_history_02", d1.serverId, server_camp_1, server_camp_2)
    elseif v_select_2 == -1 then
      self.txt_des:SetLocalText("season_s3_activity_1000063_history_02", d2.serverId, server_camp_1, server_camp_2)
    elseif v_select_1 == v_select_2 then
      self.txt_des:SetLocalText("season_s3_activity_1000063_history_03", server_camp_1, server_camp_2)
    else
      self.txt_des:SetLocalText("season_s3_activity_1000063_history_04", server_camp_1, server_camp_2)
    end
  end
end

return UILWSeasonFactionHistoryItem
