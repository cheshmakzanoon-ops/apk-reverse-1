local MainView = BaseClass("MainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local MainItem = require("UI.UIGovernment.Main.Component.MainItem")
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local player_path = "Root/Content/king/player"
local gender1_icon_path = "Root/Content/king/GenderIcon1"
local gender2_icon_path = "Root/Content/king/GenderIcon2"
local name_text_path = "Root/Content/king/NameText"
local power_text_path = "Root/Content/king/PowerText"
local country_path = "Root/Content/king/country"
local badges_icon_path = "Root/Content/king/badgesIcon"
local desc_btn_path = "Root/Content/DescBtn"
local desc_txt_path = "Root/Content/DescBtn/DescTxt"
local no_king_path = "Root/Content/no_king"
local king_path = "Root/Content/king"
local btn1_path = "Root/Content/no_king/btn1"
local btn2_path = "Root/Content/king/btn2"

function MainView:OnCreate()
  base.OnCreate(self)
  self.serverId, self.buildingId = self:GetUserData()
  self:ComponentDefine()
  DataCenter.GovernmentManager:GetKingInfo(self.serverId)
  self:UpdateData()
end

function MainView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GovernmentPresidentRefresh, self.UpdateData)
  self:AddUIListener(EventId.KingdomPresidentInfoUpdate, self.UpdateData)
  self:AddUIListener(EventId.KingdomBadgesInfoRefresh, self.RefreshKingdomBadges)
  self:AddUIListener(EventId.KingdomBadgesInfoUpdate, self.RefreshKingdomBadges)
  self:AddUIListener(EventId.OnGetServerKingData, self.RefreshKingdomBadges)
end

function MainView:OnRemoveListener()
  self:RemoveUIListener(EventId.GovernmentPresidentRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.KingdomPresidentInfoUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.KingdomBadgesInfoRefresh, self.RefreshKingdomBadges)
  self:RemoveUIListener(EventId.KingdomBadgesInfoUpdate, self.RefreshKingdomBadges)
  self:RemoveUIListener(EventId.OnGetServerKingData, self.RefreshKingdomBadges)
  base.OnRemoveListener(self)
end

function MainView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetTextFormat("#%s %s", self.serverId, Localization:GetString("457047"))
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.king_player = self:AddComponent(UICommonHead, player_path)
  self.king_player_btn = self:AddComponent(UIButton, player_path)
  self.king_gender1_icon = self:AddComponent(UIImage, gender1_icon_path)
  self.king_gender2_icon = self:AddComponent(UIImage, gender2_icon_path)
  self.king_name_text = self:AddComponent(UIText, name_text_path)
  self.king_power_text = self:AddComponent(UIText, power_text_path)
  self.king_country = self:AddComponent(UIImage, country_path)
  self.king_badges_icon = self:AddComponent(UIImage, badges_icon_path)
  self.desc_btn = self:AddComponent(UIButton, desc_btn_path)
  self.desc_txt = self:AddComponent(UIText, desc_txt_path)
  self.no_king = self:AddComponent(UIImage, no_king_path)
  self.btn1 = self:AddComponent(UIButton, btn1_path)
  self.btn2 = self:AddComponent(UIButton, btn2_path)
  self.king = self:AddComponent(UIImage, king_path)
  for i = 1, 7 do
    local item = self:AddComponent(MainItem, "Root/Content/ScrollView/Viewport/functionList/item" .. i)
    item:ReInit(i, self.serverId)
  end
  self.king_player_btn:SetOnClick(function()
    local curPresident = DataCenter.GovernmentManager:GetCurPresident(self.serverId)
    if curPresident == nil then
      if LuaEntry.Player:IsPresident(self.serverId) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, LuaEntry.Player.uid)
      end
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, curPresident.uid)
    end
  end)
  self.btn1:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentPresidentBuff, {anim = true}, 0, nil, self.serverId, DataCenter.GovernmentManager:GetCurPresident(self.serverId))
  end)
  self.btn2:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentPresidentBuff, {anim = true}, 0, nil, self.serverId, DataCenter.GovernmentManager:GetCurPresident(self.serverId))
  end)
  self.desc_btn:SetOnClick(function()
    if CoppaUtil.IsCoppaLimitWithTips() then
      return
    end
    if LuaEntry.Player:IsPresident(self.serverId) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentPresidentDeclaration, {anim = true}, self.serverId)
    else
      UIUtil.ShowTipsId(393018)
    end
  end)
end

function MainView:RefreshKingdomBadges()
  self.king_badges_icon:LoadSprite(DataCenter.GovernmentManager:GetKingdomBadgesIconPath(self.serverId))
end

function MainView:ComponentDestroy()
  self.btn_back = nil
end

function MainView:UpdateData()
  local curPresident = DataCenter.GovernmentManager:GetCurPresident(self.serverId)
  if curPresident == nil then
    if LuaEntry.Player:IsPresident(self.serverId) then
      local player = LuaEntry.Player
      self.king_player:SetHead(player.uid, player.pic, player.picVer, nil, player:GetHeadBgImg())
      self.king_name_text:SetLocalText("science_condition", player.level, LuaEntry.Player:GetFullName())
      self.king_gender1_icon:SetActive(player:GetGender() == 1)
      self.king_gender2_icon:SetActive(player:GetGender() == 2)
      self.king_power_text:SetLocalText(100392, string.GetFormattedSeperatorNum(player.power))
      local template = DataCenter.NationTemplateManager:GetNationTemplate(player.country)
      if template then
        self.king_country:LoadSprite(template:GetNationFlagPath())
      end
      curPresident = player
    end
  else
    local presidentName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(curPresident.uid, curPresident.name)
    if string.IsNullOrEmpty(curPresident.allianceAbbr) then
      presidentName = Localization:GetString("science_condition", curPresident.level, presidentName)
    else
      presidentName = Localization:GetString("science_condition", curPresident.level, "[" .. curPresident.allianceAbbr .. "]" .. presidentName)
    end
    self.king_name_text:SetText(presidentName)
    self.king_player:SetHead(curPresident.uid, curPresident.pic, curPresident.picVer, nil, curPresident:GetHeadBgImg())
    self.king_gender1_icon:SetActive(curPresident.gender == 1)
    self.king_gender2_icon:SetActive(curPresident.gender == 2)
    self.king_power_text:SetLocalText(100392, string.GetFormattedSeperatorNum(curPresident.power))
    local template = DataCenter.NationTemplateManager:GetNationTemplate(curPresident.country)
    if template then
      self.king_country:LoadSprite(template:GetNationFlagPath())
    end
  end
  self.no_king:SetActive(curPresident == nil)
  self.king:SetActive(curPresident ~= nil)
  self.king_badges_icon:LoadSprite(DataCenter.GovernmentManager:GetKingdomBadgesIconPath(self.serverId))
  if curPresident ~= nil and curPresident.declaration ~= nil and curPresident.declaration ~= "" then
    self.desc_txt:SetText(curPresident.declaration)
  else
    self.desc_txt:SetLocalText(457062)
  end
end

return MainView
