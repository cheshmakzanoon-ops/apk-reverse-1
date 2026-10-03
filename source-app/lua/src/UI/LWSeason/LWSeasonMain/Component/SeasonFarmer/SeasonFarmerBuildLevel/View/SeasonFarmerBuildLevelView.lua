local SeasonFarmerBuildLevelView = BaseClass("SeasonFarmerBuildLevelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local BuildLevelItem = require("UI.LWSeason.LWSeasonMain.Component.SeasonFarmer.SeasonFarmerBuildLevel.Component.SeasonFarmerBuildLevelItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local scroll_view_path = "PopUpTitle/ScrollView"
local content_path = "PopUpTitle/ScrollView/Content"
local progress_build_path = "PopUpTitle/progressBuild"
local progress_text_path = "PopUpTitle/progressBuild/progressBg/progressText"
local build_level_text_path = "PopUpTitle/progressBuild/LevelText"
local __listData = {
  {
    title = "season_builders_alliance_UI_54",
    desc = "season_builders_alliance_UI_55",
    icon = "Assets/Main/Sprites/UI/UISeason/UISeasonFarmer/mjc_S1YH_lianmengjianshezhe_chengjiu_icon1.png",
    gotoFunc = function()
      DataCenter.SeasonFarmerManager:GotoCurBuilding()
    end
  },
  {
    title = "season_builders_alliance_UI_56",
    desc = "season_builders_alliance_UI_57",
    icon = "Assets/Main/Sprites/UI/UISeason/UISeasonFarmer/mjc_S1YH_lianmengjianshezhe_chengjiu_icon2.png",
    gotoFunc = function()
      DataCenter.SeasonFarmerManager:GotoCurBuilding()
    end
  }
}

function SeasonFarmerBuildLevelView:OnCreate()
  base.OnCreate(self)
  self.dataList = {}
  self.listGO = {}
  self:ComponentDefine()
  self:RefreshList()
  self:RefreshBuildingLevel()
end

function SeasonFarmerBuildLevelView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonFarmerBuildLevelView:OnAddListener()
  base.OnAddListener(self)
end

function SeasonFarmerBuildLevelView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonFarmerBuildLevelView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.progress_build = self:AddComponent(UISlider, progress_build_path)
  self.progress_text = self:AddComponent(UIText, progress_text_path)
  self.build_level_text = self:AddComponent(UIText, build_level_text_path)
  self.ScrollView = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(GridInfinityScrollView, content_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.content:Init(bindFunc1, bindFunc2, bindFunc3)
  self.dialog_title_text:SetLocalText("season_builders_alliance_UI_41")
end

function SeasonFarmerBuildLevelView:ComponentDestroy()
  self:ClearItemCell()
  self.listGO = {}
end

function SeasonFarmerBuildLevelView:RefreshList()
  local dataList = __listData
  self.dataList = dataList
  if dataList then
    local dataCount = #dataList
    if 0 < dataCount then
      self.content:SetItemCount(dataCount)
    end
  end
end

function SeasonFarmerBuildLevelView:OnInitScroll(go, index)
  local item = self.ScrollView:AddComponent(BuildLevelItem, go)
  item:SetActive(false)
  self.listGO[go] = item
end

function SeasonFarmerBuildLevelView:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  if cellItem then
    local theIndex = index + 1
    cellItem:SetActive(true)
    cellItem:ReInit(theIndex, self.dataList[theIndex])
  end
end

function SeasonFarmerBuildLevelView:OnDestroyScrollItem(go, index)
end

function SeasonFarmerBuildLevelView:ClearItemCell()
  self.ScrollView:SetVerticalNormalizedPosition(1)
  self.ScrollView:RemoveComponents(BuildLevelItem)
  self.content:DestroyChildNode()
end

function SeasonFarmerBuildLevelView:RefreshBuildingLevel()
  local builderExpInfo = DataCenter.SeasonFarmerManager.allianceBuildInfo.builderExpInfo or {}
  local myLevel = toInt(builderExpInfo.level or 1)
  local curExp = toInt(builderExpInfo.curExp or 0)
  local levelCfg = DataCenter.SeasonFarmerTemplateManager:GetExpTemplateByLevel(myLevel)
  self.build_level_text:SetText("Lv." .. myLevel)
  if builderExpInfo and levelCfg and levelCfg.exp then
    self.progress_build:SetValue(math.min(curExp / levelCfg.exp, 1))
    self.progress_text:SetText(string.GetFormattedSeparatorNum(curExp) .. "/" .. string.GetFormattedSeparatorNum(levelCfg.exp))
  else
    self.progress_build:SetValue(0)
    if levelCfg and levelCfg.exp then
      self.progress_text:SetText("0/" .. string.GetFormattedSeparatorNum(levelCfg.exp))
    else
      self.progress_text:SetText("0/100000")
    end
  end
end

return SeasonFarmerBuildLevelView
