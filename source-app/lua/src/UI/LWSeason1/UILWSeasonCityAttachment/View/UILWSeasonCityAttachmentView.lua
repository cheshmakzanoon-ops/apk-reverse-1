local UILWSeasonCityAttachmentView = BaseClass("UILWSeasonCityAttachmentView", UIBaseView)
local base = UIBaseView
local lastActiveTabIndex = 2
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local TabLevel = require("UI.LWSeason1.UILWSeasonCityAttachment.Component.UILWSeasonCityAttachmentTabLevel")
local TabCity = require("UI.LWSeason1.UILWSeasonCityAttachment.Component.UILWSeasonCityAttachmentTabCity")
local TabBuild = require("UI.LWSeason1.UILWSeasonCityAttachment.Component.UILWSeasonCityAttachmentTabBuild")
local tab_item1_path = "Root/TopBar/Tab/TabItem1"
local tab_item2_path = "Root/TopBar/Tab/TabItem2"
local tab_item3_path = "Root/TopBar/Tab/TabItem3"
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local info_btn_path = "Root/TopBar/InfoBtn"
local btn_effect_path = "Root/BottomBar/BtnEffect"
local tips_path = "Root/BottomBar/tips"
local red_point_tab_path = "Root/TopBar/Tab/TabItem2/RedPointTab"
local red_point_fetch_path = "Root/BottomBar/BtnEffect/RedPointFetch"

function UILWSeasonCityAttachmentView:OnCreate()
  base.OnCreate(self)
  self.dynamicNodeList = {}
  lastActiveTabIndex = 2
  self:ComponentDefine()
  self:OnTabChanged(lastActiveTabIndex)
  if lastActiveTabIndex == 2 then
    self.tab_item2:SetIsOn(true)
  elseif lastActiveTabIndex == 3 then
    self.tab_item3:SetIsOn(true)
  else
    lastActiveTabIndex = 1
    self.tab_item1:SetIsOn(true)
  end
  if self.tabIndex == nil then
    self:OnTabChanged(lastActiveTabIndex)
  end
  SFSNetwork.SendMessage(MsgDefines.FetchCityAttachmentList)
  DataCenter.AllianceMemberDataManager:TryInitMemberList(false)
end

function UILWSeasonCityAttachmentView:OnDestroy()
  if self.dynamicNodeList then
    for _, node in ipairs(self.dynamicNodeList) do
      if node and type(node.Delete) == "function" then
        pcall(node.Delete, node)
      end
    end
  end
  self.dynamicNodeList = nil
  self.content = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCityAttachmentView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CityAttachmentInfoUpdate, self.UpdateData)
  self:AddUIListener(EventId.CityAttachmentOneRewardFinish, self.CheckCityAttachmentReward)
  self:AddUIListener(EventId.CityAttachmentALLRewardFinish, self.OnCityAttachmentALLRewardFinish)
end

function UILWSeasonCityAttachmentView:OnRemoveListener()
  self:RemoveUIListener(EventId.CityAttachmentInfoUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.CityAttachmentOneRewardFinish, self.CheckCityAttachmentReward)
  self:RemoveUIListener(EventId.CityAttachmentALLRewardFinish, self.OnCityAttachmentALLRewardFinish)
  base.OnRemoveListener(self)
end

function UILWSeasonCityAttachmentView:ComponentDefine()
  self.content = self:AddComponent(UIBaseComponent, "Root/Content")
  self.tips = self:AddComponent(UITextMeshProUGUIEx, tips_path)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("season_builders_alliance_UI_3")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.btnFetchALL = self:AddComponent(UIButton, btn_effect_path)
  self.info_btn:SetOnClick(function()
    local cfg = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
    if cfg and not string.IsNullOrEmpty(cfg.alliance_help) then
      local msg = Localization:GetString(cfg.alliance_help)
      UIUtil.ShowDetail(msg, nil, nil, true, true)
    end
  end)
  self.red_point_tab = self:AddComponent(UIImage, red_point_tab_path)
  self.red_point_fetch = self:AddComponent(UIImage, red_point_fetch_path)
  self.btnFetchALL:SetOnClick(function()
    SFSNetwork.SendMessage(MsgDefines.GetCityAttachmentALLReward)
  end)
  self.btnFetchALL:SetSafeClickMode(true)
  self.red_point_tab:SetActive(false)
  self.red_point_fetch:SetActive(false)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.tab_item3 = self:AddComponent(UIToggle, tab_item3_path)
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(1)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(2)
    end
  end)
  self.tab_item3:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(3)
    end
  end)
end

function UILWSeasonCityAttachmentView:ComponentDestroy()
  self.scroll_view_city = nil
  self.scroll_view_level = nil
  self.scroll_view_build = nil
  self.tips = nil
  self.btn_back = nil
  self.info_btn = nil
  self.btnFetchALL = nil
  self.tab_item1 = nil
  self.tab_item2 = nil
  self.tab_item3 = nil
end

function UILWSeasonCityAttachmentView:OnCityAttachmentALLRewardFinish()
  DataCenter.SeasonFarmerManager:CleanBuildReward()
  self.btnFetchALL:SetActive(false)
  self.red_point_tab:SetActive(false)
  self.red_point_fetch:SetActive(false)
end

function UILWSeasonCityAttachmentView:CheckCityAttachmentReward()
  local leftNum = DataCenter.SeasonFarmerManager:CountOfBuildReward()
  self.btnFetchALL:SetActive(0 < leftNum and toInt(self.tabIndex) == 2)
  self.red_point_tab:SetActive(0 < leftNum)
  self.red_point_fetch:SetActive(0 < leftNum)
end

function UILWSeasonCityAttachmentView:UpdateData()
  local allianceBuildInfo = DataCenter.SeasonFarmerManager.allianceBuildInfo
  local isFarmer = DataCenter.SeasonFarmerManager:IsActive()
  local tabIndex = toInt(self.tabIndex)
  local prefabPath
  if tabIndex == 1 then
    if self.scroll_view_city == nil then
      prefabPath = "Assets/Main/Prefabs/UI/LWSeason1/CityAttachmentMain/Component/ScrollViewCity.prefab"
      self.scroll_view_city = TabCity.New(self, self.content.transform, prefabPath)
      table.insert(self.dynamicNodeList, self.scroll_view_city)
    end
    self.scroll_view_city:ReInit(isFarmer, allianceBuildInfo)
  elseif tabIndex == 2 then
    if self.scroll_view_build == nil then
      prefabPath = "Assets/Main/Prefabs/UI/LWSeason1/CityAttachmentMain/Component/ScrollViewBuild.prefab"
      self.scroll_view_build = TabBuild.New(self, self.content.transform, prefabPath)
      table.insert(self.dynamicNodeList, self.scroll_view_build)
    end
    self.scroll_view_build:ReInit(isFarmer, allianceBuildInfo)
  elseif tabIndex == 3 then
    if self.scroll_view_level == nil then
      prefabPath = "Assets/Main/Prefabs/UI/LWSeason1/CityAttachmentMain/Component/ScrollViewLevel.prefab"
      self.scroll_view_level = TabLevel.New(self, self.content.transform, prefabPath)
      table.insert(self.dynamicNodeList, self.scroll_view_level)
    end
    self.scroll_view_level:ReInit(isFarmer, allianceBuildInfo)
  end
  self:CheckCityAttachmentReward()
end

function UILWSeasonCityAttachmentView:OnTabChanged(tabIndex)
  local isFarmer = DataCenter.SeasonFarmerManager:IsActive()
  self.tabIndex = tabIndex
  self.tips:SetActive(tabIndex ~= 2)
  if self.scroll_view_city ~= nil then
    self.scroll_view_city:SetActive(tabIndex == 1)
  end
  if self.scroll_view_build ~= nil then
    self.scroll_view_build:SetActive(tabIndex == 2)
  end
  if self.scroll_view_level ~= nil then
    self.scroll_view_level:SetActive(tabIndex == 3)
  end
  self:UpdateData()
  if tabIndex ~= 2 then
    if isFarmer then
      self.tips:SetLocalText("season_builders_alliance_UI_1")
    else
      self.tips:SetLocalText("season_builders_alliance_UI_2")
    end
  end
  lastActiveTabIndex = tabIndex
end

return UILWSeasonCityAttachmentView
