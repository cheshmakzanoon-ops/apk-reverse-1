local UIAllianceGovernmentSkillView = BaseClass("UIAllianceGovernmentSkillView", UIBaseView)
local base = UIBaseView
local OfficialItem = require("UI.UIAlliance.UIAllianceGovernmentSkill.Component.UIAllianceGovernmentOfficialItem")
local UIAllianceGovernmentAresMissileSkill = require("UI.UIAlliance.UIAllianceGovernmentSkill.Component.UIAllianceGovernmentAresMissileSkill")
local UIAllianceGovernmentAresMissileNormal = require("UI.UIAlliance.UIAllianceGovernmentSkill.Component.UIAllianceGovernmentAresMissileNormal")
local UIAllianceGovernmentGoddessMummySkill = require("UI.UIAlliance.UIAllianceGovernmentSkill.Component.UIAllianceGovernmentGoddessMummySkill")
local bg_path = "Root/ScrollView/Viewport/Content/TopOfficial/bg"
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local tab_scroll_path = "Root/TopBar/TabScroll"
local content_path = "Root/ScrollView/Viewport/Content"
local top_ares_path = "Root/ScrollView/Viewport/Content/TopOfficial"
local ares_missile_skill_path = "Root/ScrollView/Viewport/Content/AresMissileSkill"
local goddess_mummy_skill_path = "Root/ScrollView/Viewport/Content/GoddessMummySkill"
local ares_missile_normal_path = "Root/ScrollView/Viewport/Content/AresMissileNormal"
local skill_history_btn_path = "Root/BottomBar/SkillHistoryBtn"
local tab_item1_path = "Root/TopBar/TabScroll/Viewport/TabContent/TabItem1"
local tab_item2_path = "Root/TopBar/TabScroll/Viewport/TabContent/TabItem2"
local tab_item3_path = "Root/TopBar/TabScroll/Viewport/TabContent/TabItem3"
local tab_item4_path = "Root/TopBar/TabScroll/Viewport/TabContent/TabItem4"

function UIAllianceGovernmentSkillView:OnCreate()
  base.OnCreate(self)
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Mummy or seasonType == SeasonMapType.Darkness then
    DataCenter.ZoneWarManager:InitData()
  end
  self.seasonType = seasonType
  self.firstShow = true
  SFSNetwork.SendMessage(MsgDefines.GetAllianceOfficialSkillList)
  SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarVsInfo)
  self:ComponentDefine()
  self:Init()
end

function UIAllianceGovernmentSkillView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceGovernmentSkillView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.RefreshCurTab)
  self:AddUIListener(EventId.AllianceMember, self.RefreshCurTab)
  self:AddUIListener(EventId.UpdateGovernmentSkillCount, self.RefreshCurTab)
end

function UIAllianceGovernmentSkillView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceMember, self.RefreshCurTab)
  self:RemoveUIListener(EventId.UpdateGovernmentSkillCount, self.RefreshCurTab)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.RefreshCurTab)
  base.OnRemoveListener(self)
end

function UIAllianceGovernmentSkillView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("season_alliance_government_skill_01")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.tab_scroll = self:AddComponent(UIScrollRect, tab_scroll_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.top_official = self:AddComponent(OfficialItem, top_ares_path)
  self.ares_missile_skill = self:AddComponent(UIAllianceGovernmentAresMissileSkill, ares_missile_skill_path)
  self.goddess_mummy_skill = self:AddComponent(UIAllianceGovernmentGoddessMummySkill, goddess_mummy_skill_path)
  self.ares_missile_normal = self:AddComponent(UIAllianceGovernmentAresMissileNormal, ares_missile_normal_path)
  self.skill_history_btn = self:AddComponent(UIButton, skill_history_btn_path)
  self.skill_history_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceGovernmentSkillHistory)
  end)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.tab_item3 = self:AddComponent(UIToggle, tab_item3_path)
  self.tab_item4 = self:AddComponent(UIToggle, tab_item4_path)
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:OnClickTab(LWAlMemberOffcialType.Deputy_Al_Leader)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:OnClickTab(LWAlMemberOffcialType.Al_Goddess)
    end
  end)
  self.tab_item3:SetOnValueChanged(function(tf)
    if tf then
      self:OnClickTab(LWAlMemberOffcialType.War_Commander)
    end
  end)
  self.tab_item4:SetOnValueChanged(function(tf)
    if tf then
      self:OnClickTab(LWAlMemberOffcialType.Al_Ambassadoe)
    end
  end)
  local leftUseTime = 0
  local timeList = DataCenter.AllianceGovernmentSkillManager.skillTimeList
  if timeList ~= nil then
    for k, v in pairs(timeList) do
      if v and v.skillId ~= nil and v.skillId ~= 0 then
        local cfg = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(v.skillId)
        if cfg ~= nil and cfg.skill_flag == AlOfficialSkillType.MissileFactory then
          leftUseTime = toInt(v.leftUseTime)
          break
        end
      end
    end
  end
end

function UIAllianceGovernmentSkillView:ComponentDestroy()
  self.tab_scroll = nil
  self.btn_back = nil
  self.top_ares = nil
  self.tab_item1 = nil
  self.tab_item2 = nil
  self.tab_item3 = nil
  self.tab_item4 = nil
  self.ares_missile_skill = nil
  self.skill_history_btn = nil
  self.content = nil
  self.ares_missile_normal = nil
  self.bg = nil
end

function UIAllianceGovernmentSkillView:Init()
  local defaultTab = self:GetUserData() or LWAlMemberOffcialType.None
  local shownTabTypeList = {}
  local shownTabNodeList = {}
  self.curTab = nil
  for OfficialType = 1, 4 do
    local showTab = DataCenter.AllianceGovernmentSkillManager:CheckHasUsableSkillByOfficial(OfficialType)
    local tabNode = self["tab_item" .. OfficialType]
    if tabNode then
      tabNode:SetActive(showTab)
      if showTab then
        if defaultTab == LWAlMemberOffcialType.None or defaultTab == OfficialType then
          defaultTab = OfficialType
          tabNode:SetIsOn(true)
        end
        table.insert(shownTabTypeList, OfficialType)
        table.insert(shownTabNodeList, tabNode)
      end
    end
  end
  local tabCount = #shownTabNodeList
  if defaultTab == LWAlMemberOffcialType.None and 0 < tabCount then
    defaultTab = shownTabTypeList[1]
    shownTabNodeList[1]:SetIsOn(true)
  end
  if self.curTab == nil then
    self:OnClickTab(defaultTab)
  end
end

function UIAllianceGovernmentSkillView:OnClickTab(officialType)
  if self.curTab == officialType then
    return
  end
  if officialType == LWAlMemberOffcialType.Deputy_Al_Leader then
    self.tab_scroll:AnimHorizontalNormalizedPos(0, 0.2)
    self.curTab = officialType
    self:RefreshCurTab()
    if self.seasonType == SeasonMapType.Darkness then
      self.bg:LoadSprite("Assets/Main/SeasonRes/Shared/Textures/AllianceOfficialSkill/ljq_guanzhijineng_gesila.png")
    else
      self.bg:LoadSprite("Assets/Main/TextureEx/Season/FactionDeclareWar/mjc_guanzhijineng_zhanshen_bg01.png")
    end
  elseif officialType == LWAlMemberOffcialType.Al_Goddess then
    UIUtil.ShowTipsId(120018)
  elseif officialType == LWAlMemberOffcialType.War_Commander then
    self.curTab = officialType
    self:RefreshCurTab()
    self.bg:LoadSprite("Assets/Main/SeasonRes/Shared/Textures/AllianceOfficialSkill/mjc_guanzhijineng_nvs_bg.png")
  elseif officialType == LWAlMemberOffcialType.Al_Ambassadoe then
    self.curTab = officialType
    self:RefreshCurTab()
    self.bg:LoadSprite("Assets/Main/SeasonRes/Shared/Textures/AllianceOfficialSkill/mjc_guanzhijineng_dianta_bg01.png")
  end
end

function UIAllianceGovernmentSkillView:RefreshCurTab()
  self.top_official:SetOfficialType(self.curTab)
  if self.curTab ~= LWAlMemberOffcialType.Al_Ambassadoe and self.GuardianTower ~= nil then
    self.GuardianTower:SetActive(false)
  end
  if self.curTab == LWAlMemberOffcialType.Deputy_Al_Leader then
    self.goddess_mummy_skill:SetActive(false)
    local cfg = DataCenter.AllianceGovernmentSkillManager:GetUsableConfigBySkillType(AlOfficialSkillType.AresMissile)
    if cfg ~= nil then
      self.ares_missile_skill:SetActive(true)
      self.ares_missile_skill:ReInit()
    else
      self.ares_missile_skill:SetActive(false)
    end
    self:TryShowNormalAresMissile()
  elseif self.curTab == LWAlMemberOffcialType.War_Commander then
    self.ares_missile_skill:SetActive(false)
    self.ares_missile_normal:SetActive(false)
    local cfg = DataCenter.AllianceGovernmentSkillManager:GetUsableConfigBySkillType(AlOfficialSkillType.GoddessMummy)
    if cfg ~= nil then
      self.goddess_mummy_skill:SetActive(true)
      self.goddess_mummy_skill:ReInit()
    else
      self.goddess_mummy_skill:SetActive(false)
    end
  elseif self.curTab == LWAlMemberOffcialType.Al_Ambassadoe then
    self.ares_missile_skill:SetActive(false)
    self.ares_missile_normal:SetActive(false)
    self.goddess_mummy_skill:SetActive(false)
    self:TryShowAmbassadoeSkill()
  end
  self.firstShow = false
end

function UIAllianceGovernmentSkillView:TryShowAmbassadoeSkill()
  if self.seasonType == SeasonMapType.Darkness then
    local cfg = DataCenter.AllianceGovernmentSkillManager:GetUsableConfigBySkillType(AlOfficialSkillType.GuardianTower)
    if cfg ~= nil then
      if self.GuardianTower == nil then
        local luaPath = "UI.UIAlliance.UIAllianceGovernmentSkill.Component.UIAllianceGovernmentGuardianTowerSkill"
        local prefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/Component/DarknessAmbassadorSkill.prefab"
        self.GuardianTower = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.content, function(view, go, lua, callback_param)
          lua:SetActive(self.curTab == LWAlMemberOffcialType.Al_Ambassadoe)
          lua:ReInit()
        end)
      else
        self.GuardianTower:SetActive(true)
        self.GuardianTower:ReInit()
      end
    elseif self.GuardianTower then
      self.GuardianTower:SetActive(false)
    end
  elseif self.GuardianTower then
    self.GuardianTower:SetActive(false)
  end
end

function UIAllianceGovernmentSkillView:TryShowNormalAresMissile()
  if self.seasonType == SeasonMapType.Mummy or self.seasonType == SeasonMapType.Darkness then
    local cfg = DataCenter.AllianceGovernmentSkillManager:GetUsableConfigBySkillType(AlOfficialSkillType.MissileFactory)
    if cfg ~= nil and DataCenter.AllianceGovernmentSkillManager:CanUseGovernmentSkill(cfg.id) then
      self.ares_missile_normal:SetActive(true)
      self.ares_missile_normal:ReInit()
    else
      if self.firstShow then
        self.ares_missile_skill.expand_node = false
        self.ares_missile_skill:SwitchExpandMode()
      end
      self.ares_missile_normal:SetActive(false)
    end
  else
    if self.firstShow then
      self.ares_missile_skill.expand_node = false
      self.ares_missile_skill:SwitchExpandMode()
    end
    self.ares_missile_normal:SetActive(false)
  end
end

function UIAllianceGovernmentSkillView:Update100MS()
  local full_width, full_height = self.content:GetSizeDeltaXY()
  if self.curTab == LWAlMemberOffcialType.Deputy_Al_Leader then
    local height = 0
    if self.ares_missile_skill:GetActive() then
      local _, height1 = self.ares_missile_skill:GetSizeDeltaXY()
      self.ares_missile_skill:SetLocalPositionXYZ(0, -370, 0)
      height = height1 + 5
    end
    if self.ares_missile_normal:GetActive() then
      local _, height2 = self.ares_missile_normal:GetSizeDeltaXY()
      if height == 0 then
        self.ares_missile_normal:SetLocalPositionXYZ(0, -370, 0)
        height = height2 + 5
      else
        self.ares_missile_normal:SetLocalPositionXYZ(0, -370 - height, 0)
        height = height + height2 + 5
      end
    end
    full_height = 370 + height
  elseif self.curTab == LWAlMemberOffcialType.War_Commander then
    local _, goddess_height = self.goddess_mummy_skill:GetSizeDeltaXY()
    full_height = 370 + goddess_height
  elseif self.curTab == LWAlMemberOffcialType.Al_Ambassadoe and self.GuardianTower then
    local _, ambassadoe_height = self.GuardianTower:GetSizeDeltaXY()
    self.GuardianTower:SetLocalPositionXYZ(0, -370, 0)
    full_height = 370 + ambassadoe_height
  end
  self.content:SetSizeDeltaXY(full_width, full_height)
end

return UIAllianceGovernmentSkillView
