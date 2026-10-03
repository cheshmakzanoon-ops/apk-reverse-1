local UISeasonOfficialMainView = BaseClass("UISeasonOfficialMainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UISeasonOfficialMainItem = require("UI.UIGovernment.UISeasonOfficialMain.UISeasonOfficialMainItem")
local TITLE = {
  [GovOfficialType.Outpost] = "outpost_commander_ui_1",
  [GovOfficialType.Center] = "supreme_president_ui_2"
}
local PRESIDENT_NAME = {
  [GovOfficialType.Outpost] = "outpost_commander_ui_2",
  [GovOfficialType.Center] = "supreme_president_ui_3"
}
local DECLARE_NAME = {
  [GovOfficialType.Outpost] = "outpost_commander_ui_3",
  [GovOfficialType.Center] = "supreme_president_ui_4"
}
local DEFAULT_DECLARE = {
  [GovOfficialType.Outpost] = "outpost_commander_ui_4",
  [GovOfficialType.Center] = "supreme_president_ui_5"
}
local BUTTON_LIST = {
  [GovOfficialType.Outpost] = {
    {
      LangKey = "outpost_commander_ui_5",
      Icon = "Assets/Main/Sprites/UI/UIGovernment/Sprites/zyf_wangzhuozhan_zontongguanli_icon2.png",
      Action = function(view)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialList, {anim = true}, GovOfficialType.Outpost, view.serverId, view.buildingId)
      end
    },
    {
      LangKey = "outpost_commander_ui_6",
      Icon = "Assets/Main/Sprites/UI/UIGovernment/Sprites/zyf_wangzhuozhan_zontongguanli_icon4.png",
      Action = function(view)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialEncourage, {anim = true}, GovOfficialType.Outpost, view.serverId, view.buildingId)
      end
    },
    {
      LangKey = "outpost_commander_ui_7",
      Icon = "Assets/Main/Sprites/UI/UIGovernment/Sprites/zyf_wangzhuozhan_zontongguanli_icon5.png",
      Action = function(view)
        local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, view.serverId)
        local leaderConfig = DataCenter.GovernmentTemplateManager:GetLeaderByType(GovOfficialType.Outpost, seasonSubType)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialLeaderHistory, {anim = true}, view.serverId, view.buildingId, leaderConfig)
      end
    }
  },
  [GovOfficialType.Center] = {
    {
      LangKey = "supreme_president_ui_6",
      Icon = "Assets/Main/Sprites/UI/UIGovernment/Sprites/zyf_wangzhuozhan_zontongguanli_icon2.png",
      Action = function(view)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialList, {anim = true}, GovOfficialType.Center, view.serverId, view.buildingId)
      end
    },
    {
      LangKey = "supreme_president_ui_7",
      Icon = "Assets/Main/Sprites/UI/UIGovernment/Sprites/zyf_wangzhuozhan_zontongguanli_icon6.png",
      Action = function(view)
        if CoppaUtil.IsCoppaLimitWithTips() then
          return
        end
        local canChat = DataCenter.LWRefundPunishManager:GetCanChat()
        if not canChat then
          return
        end
        if CS.StringUtils.VersionCompare(CS.GameEntry.Sdk.Version, "1.0.258") >= 0 and not Config.IsPC() then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialMailV2, {anim = true}, view.serverId, view.buildingId)
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialMail, {anim = true}, view.serverId, view.buildingId)
        end
      end
    },
    {
      LangKey = "supreme_president_ui_8",
      Icon = "Assets/Main/Sprites/UI/UIGovernment/Sprites/zyf_wangzhuozhan_zontongguanli_icon4.png",
      Action = function(view)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialEncourage, {anim = true}, GovOfficialType.Center, view.serverId, view.buildingId)
      end
    },
    {
      LangKey = "supreme_president_ui_9",
      Icon = "Assets/Main/Sprites/UI/UIGovernment/Sprites/zyf_wangzhuozhan_zontongguanli_icon5.png",
      Action = function(view)
        local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, view.serverId)
        local leaderConfig = DataCenter.GovernmentTemplateManager:GetLeaderByType(GovOfficialType.Center, seasonSubType)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialLeaderHistory, {anim = true}, view.serverId, view.buildingId, leaderConfig)
      end
    }
  }
}
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local player_path = "Root/PackList/Viewport/Content/king/player"
local gender1_icon_path = "Root/PackList/Viewport/Content/king/GenderIcon1"
local gender2_icon_path = "Root/PackList/Viewport/Content/king/GenderIcon2"
local name_text_path = "Root/PackList/Viewport/Content/king/NameText"
local power_text_path = "Root/PackList/Viewport/Content/king/PowerText"
local country_path = "Root/PackList/Viewport/Content/king/country"
local badges_icon_path = "Root/PackList/Viewport/Content/king/badgesIcon"
local desc_btn_path = "Root/PackList/Viewport/Content/DescBtn"
local desc_txt_path = "Root/PackList/Viewport/Content/DescBtn/DescTxt"
local name_path = "Root/PackList/Viewport/Content/name"
local declare_path = "Root/PackList/Viewport/Content/declare"
local no_king_path = "Root/PackList/Viewport/Content/no_king"
local king_path = "Root/PackList/Viewport/Content/king"
local btn1_path = "Root/PackList/Viewport/Content/no_king/btn1"
local btn2_path = "Root/PackList/Viewport/Content/king/btn2"
local king_icon_path = "Root/PackList/Viewport/Content/no_king/king_icon"

function UISeasonOfficialMainView:OnCreate()
  base.OnCreate(self)
  self.govOfficialType, self.serverId, self.buildingId = self:GetUserData()
  DataCenter.BuildingOfficialManager:FetchKingdomBuildingPositionList(self.serverId, self.buildingId)
  self:ComponentDefine()
  self:Init()
end

function UISeasonOfficialMainView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonOfficialMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomBuildingPositionList, self.Refresh)
  self:AddUIListener(EventId.KingdomBuildingPositionDeclarationUpdate, self.Refresh)
  self:Refresh()
end

function UISeasonOfficialMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.KingdomBuildingPositionList, self.Refresh)
  self:RemoveUIListener(EventId.KingdomBuildingPositionDeclarationUpdate, self.Refresh)
  base.OnRemoveListener(self)
end

function UISeasonOfficialMainView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.declare = self:AddComponent(UITextMeshProUGUIEx, declare_path)
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
  self.king_icon = self:AddComponent(UIImage, king_icon_path)
  self.functionList = self:AddComponent(UIBaseContainer, "Root/PackList/Viewport/Content/functionList")
  self.king_player_btn:SetOnClick(function()
    local curPresident = DataCenter.BuildingOfficialManager:GetSurfaceLeader(self.serverId, self.buildingId)
    if curPresident then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, curPresident.uid)
    end
  end)
  self.btn1:SetOnClick(function()
    local isDeepLeader = LuaEntry.Player:IsDeepLeader(self.serverId, self.buildingId)
    if self.govOfficialType == GovOfficialType.Outpost then
      local info = DataCenter.BuildingOfficialManager:GetSurfaceLeader(self.serverId, self.buildingId)
      if (not info or string.IsNullOrEmpty(info.uid)) and not isDeepLeader then
        UIUtil.ShowTipsId("outpost_commander_ui_12")
      end
    end
    local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, self.serverId)
    local leaderConfig = DataCenter.GovernmentTemplateManager:GetLeaderByType(self.govOfficialType, seasonSubType)
    if SeasonUtil.IsUserInSeason() and isDeepLeader then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialApply, {anim = true}, self.serverId, self.buildingId, leaderConfig)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialBuff, {anim = true}, self.serverId, self.buildingId, leaderConfig)
    end
  end)
  self.btn2:SetOnClick(function()
    local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, self.serverId)
    local leaderConfig = DataCenter.GovernmentTemplateManager:GetLeaderByType(self.govOfficialType, seasonSubType)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialBuff, {anim = true}, self.serverId, self.buildingId, leaderConfig)
  end)
  self.desc_btn:SetOnClick(function()
    if CoppaUtil.IsCoppaLimitWithTips() then
      return
    end
    if LuaEntry.Player:IsSurfaceLeader(self.serverId, self.buildingId) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialDeclaration, {anim = true}, self.govOfficialType, self.serverId, self.buildingId)
    else
      UIUtil.ShowTipsId(393018)
    end
  end)
  self.items = {}
end

function UISeasonOfficialMainView:RefreshKingdomBadges()
  self.king_badges_icon:LoadSprite(DataCenter.GovernmentManager:GetKingdomBadgesIconPath())
end

function UISeasonOfficialMainView:ComponentDestroy()
  self:ClearAllItems()
  self.btn_back = nil
end

function UISeasonOfficialMainView:Init()
  self:ClearAllItems()
  local btnList = BUTTON_LIST[self.govOfficialType]
  for _, v in ipairs(btnList) do
    local item = self.functionList:LoadComponentAsync(UISeasonOfficialMainItem, "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/OfficialFunctionItem.prefab")
    item:SetData(v)
    table.insert(self.items, item)
  end
  self.name:SetLocalText(PRESIDENT_NAME[self.govOfficialType])
  self.declare:SetLocalText(DECLARE_NAME[self.govOfficialType])
  self.text_title:SetLocalText(TITLE[self.govOfficialType])
  local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, self.serverId)
  local leaderConfig = DataCenter.GovernmentTemplateManager:GetLeaderByType(self.govOfficialType, seasonSubType)
  self.king_icon:LoadSpriteAsync(leaderConfig.icon)
end

function UISeasonOfficialMainView:Refresh()
  local kingInfo = DataCenter.GovernmentManager:GetCrossServerKingInfo(self.serverId)
  local curPresident = DataCenter.BuildingOfficialManager:GetSurfaceLeader(self.serverId, self.buildingId)
  local hasKing = curPresident and curPresident.uid and curPresident.uid ~= ""
  if hasKing then
    if LuaEntry.Player:GetUid() == curPresident.uid then
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
    else
      self.king_name_text:SetText(UIUtil.FormatServerAllianceName(curPresident.serverId, curPresident.abbr, curPresident.name, curPresident.uid))
      self.king_player:SetHead(curPresident.uid, curPresident.pic, curPresident.picVer, nil, curPresident:GetHeadBgImg())
      self.king_gender1_icon:SetActive(curPresident.gender == 1)
      self.king_gender2_icon:SetActive(curPresident.gender == 2)
      self.king_power_text:SetLocalText(100392, string.GetFormattedSeperatorNum(curPresident.power))
      local template = DataCenter.NationTemplateManager:GetNationTemplate(curPresident.country)
      if template then
        self.king_country:LoadSprite(template:GetNationFlagPath())
      end
    end
  end
  self.no_king:SetActive(not hasKing)
  self.king:SetActive(hasKing)
  if kingInfo and kingInfo.badges and kingInfo.badges.cfgId then
    local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(kingInfo.badges.cfgId)
    if itemCfg then
      self.king_badges_icon:LoadSprite(string.format(LoadPath.ItemPath, itemCfg.icon))
    else
      self.king_badges_icon:LoadSprite(DataCenter.GovernmentManager:GetKingdomBadgesIconPath())
    end
  else
    self.king_badges_icon:LoadSprite(DataCenter.GovernmentManager:GetKingdomBadgesIconPath())
  end
  if curPresident ~= nil and curPresident.declaration ~= nil and curPresident.declaration ~= "" then
    self.desc_txt:SetText(curPresident.declaration)
  else
    self.desc_txt:SetLocalText(DEFAULT_DECLARE[self.govOfficialType])
  end
end

function UISeasonOfficialMainView:ClearAllItems()
  for _, v in pairs(self.items) do
    self.functionList:RemoveAsyncComponent(v)
  end
  self.items = {}
end

return UISeasonOfficialMainView
