local UILWMummyHistoryConvert = BaseClass("UILWMummyHistoryConvert", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ui_player_head_path = "UIPlayerHead"
local txt_des_path = "Txt_Des"
local txt_time_path = "Txt_Time"
local txt_title_path = "Txt_Title"

function UILWMummyHistoryConvert:OnCreate()
  base.OnCreate(self)
  self.target_icon = self:AddComponent(UIImage, "targetIcon")
  self.player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.player_head:SetEnableClickShowInfo(true, true)
  self.target_icon:SetActive(false)
end

function UILWMummyHistoryConvert:OnDestroy()
  self.player_head = nil
  self.txt_des = nil
  self.txt_time = nil
  self.txt_title = nil
  base.OnDestroy(self)
end

function UILWMummyHistoryConvert:ReInit(index, data)
  local extraInfo = data.extraInfo
  if data.changeType == 0 then
    self.txt_des:SetText("<color=#ff0000>Convert By GM API</color>")
  elseif data.changeType == 1 then
    self.txt_des:SetText(Localization:GetString("season_s3_Mummy_tips001", data.helperNum or 0))
  elseif data.changeType == 2 then
    local itemName = ""
    if extraInfo == nil then
      Logger.LogError("UILWMummyHistoryConvert \231\188\186\229\143\130\230\149\176, changeType = 2")
    elseif extraInfo.id ~= nil then
      local itemInfo = DataCenter.ItemTemplateManager:GetItemTemplate(toInt(extraInfo.id))
      if itemInfo then
        itemName = Localization:GetString(itemInfo.name)
      end
    end
    self.txt_des:SetText(Localization:GetString("season_s3_Mummy_tips002", data.helperNum or 0, itemName or ""))
  elseif data.changeType == 3 then
    self.txt_des:SetText(Localization:GetString("season_s3_Mummy_tips003", data.helperNum or 0))
  elseif data.changeType == 4 then
    self.txt_des:SetText(Localization:GetString("season_s3_Mummy_tips004", data.helperNum or 0))
    self.target_icon:LoadSprite("Assets/Main/Sprites/UI/UIMastery/wxy_S3_shouhuzhezhishi.png")
  elseif data.changeType == 5 then
    self.txt_des:SetText(Localization:GetString("season_s3_Mummy_tips009", data.helperNum or 0))
  elseif data.changeType == 6 then
    self.txt_des:SetText(Localization:GetString("season_s3_Mummy_tips018", data.helperNum or 0))
    self.target_icon:LoadSprite("Assets/Main/Sprites/UI/UIMastery/wxy_S3_buzhenwang.png")
  elseif data.changeType == 7 then
    self.txt_des:SetText(Localization:GetString("season_s3_mail_mummy_ui_info02", data.helperNum or 0))
  elseif data.changeType == 8 then
    self.txt_des:SetText(Localization:GetString("season_s4_Mummy_ui_convert_08", data.helperNum or 0))
  elseif data.changeType == 9 then
    self.txt_des:SetText(Localization:GetString("season_s4_Mummy_ui_convert_09", data.helperNum or 0))
  elseif data.changeType == 10 then
    self.txt_des:SetText(Localization:GetString("season_s4_Mummy_ui_convert_10", data.helperNum or 0))
  elseif data.changeType == 11 then
    self.txt_des:SetText(Localization:GetString("season_s4_Mummy_ui_convert_11", data.helperNum or 0))
  else
    self.txt_des:SetText(Localization:GetString("120028", Localization:GetString("season_s3_Mummy_ui_tittle02"), data.helperNum or 0))
  end
  self.txt_time:SetText(UITimeManager:GetInstance():GetServerTimeByUTC(data.eventTime or 0, false))
  if data.user ~= nil then
    local playerName = UIUtil.FormatAllianceAndName(data.user.alAbbr or data.user.abbr, data.user.name)
    self.player_head:ParseHeadInfo(data.user)
    self.txt_title:SetText(playerName)
  else
    self.txt_title:SetText("")
  end
  self.target_icon:SetActive(data.changeType == 4 or data.changeType == 6)
  self.player_head:SetActive(data.changeType ~= 4 and data.changeType ~= 6)
end

return UILWMummyHistoryConvert
