local base = UIBaseView
local LWSeasonWorldView = BaseClass("LWSeasonWorldView", base)
local SeasonWorldModelViewer = require("UI.LWSeasonWorld.Component.SeasonWorldModelViewer")
local SeasonWorldSeasonItem = require("UI.LWSeasonWorld.Component.SeasonWorldSeasonItem")
local SeasonWorldSelectItem = require("UI.LWSeasonWorld.Component.SeasonWorldSelectItem")
local SeasonTravelWorldTemplate = require("DataCenter.SeasonTravelManager.SeasonTravelWorldTemplate")
local Localization = CS.GameEntry.Localization
local map_root_path = "MapRoot"
local select_season_path = "Root/selectSeason"
local text_title_path = "Root/TopBar/TextTitle"
local tip_btn_path = "Root/TopBar/tipBtn"
local item_season_path = "itemSeason"
local btn_back_path = "BottomBar/BtnBack"
local condition_btns_path = "BottomBar/ConditionBtnScroll/ConditionBtns"
local ui_sign_pos_path = "Root/selectSeason/item/uiSignPos"
local pos_path = "Root/selectSeason/item/uiSignPos/pos"

function LWSeasonWorldView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.itemViews = {}
  self.configs = {}
  LocalController:instance():visitTable(TableName.SEASON_TRAVEL_WORLD, function(id, lineData)
    local template = SeasonTravelWorldTemplate.New()
    template:UpdateData(lineData)
    self.configs[template.season + 1] = template
  end)
  self:Execute()
  UIUtil.OpenModuleCheck(UserSettingKey.AGREE_SEASON_AROUND_WORLD, "season_travel_world_ui_09", "season_travel_world_ui_10", BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function LWSeasonWorldView:OnDestroy()
  self.configs = nil
  self.itemViews = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonWorldView:ComponentDefine()
  self.model_Viewer = self:AddComponent(SeasonWorldModelViewer, map_root_path)
  self.select_season = self:AddComponent(SeasonWorldSelectItem, select_season_path)
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.tip_btn = self:AddComponent(UIButton, tip_btn_path)
  self.item_season = self:AddComponent(SeasonWorldSeasonItem, item_season_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.condition_btns = self:AddComponent(UIBaseContainer, condition_btns_path)
  self.ui_sign_pos = self:AddComponent(UIBaseContainer, ui_sign_pos_path)
  self.pos = self:AddComponent(UIBaseContainer, pos_path)
  self.animator = self:AddComponent(UIAnimator, "")
  self.btn_back:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.tip_btn:SetOnClick(BindCallback(self, self.ClickTip))
  self.go_Item = self.item_season.gameObject
  self.go_Item:GameObjectCreatePool()
  self.go_Item:SetActive(false)
end

function LWSeasonWorldView:ComponentDestroy()
  self.go_Item:GameObjectRecycleAll()
  self.go_Item = nil
  self.model_Viewer = nil
  self.select_season = nil
  self.text_title = nil
  self.tip_btn = nil
  self.item_season = nil
  self.btn_back = nil
  self.condition_btns = nil
  self.ui_sign_pos = nil
  self.pos = nil
  self.animator = nil
end

function LWSeasonWorldView:OnAddListener()
  base.OnAddListener(self)
end

function LWSeasonWorldView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWSeasonWorldView:OnEnable()
  base.OnEnable(self)
  self.condition_btns:SetAnchoredPositionXY(0, self.condition_btns:GetAnchoredPositionY())
end

function LWSeasonWorldView:Execute()
  self:RefreshModel()
  self:RefreshSeason()
  self.curIndex = self:GetUserData()
  if self.curIndex == nil then
    self:SetUp()
  end
end

function LWSeasonWorldView:RefreshSeason()
  for index, template in ipairs(self.configs) do
    local goName = "season_item_" .. index
    local theItem = self.itemViews[goName]
    if theItem == nil then
      local goItem = self.go_Item:GameObjectSpawn(self.condition_btns.transform)
      goItem.name = goName
      theItem = self.condition_btns:AddComponent(SeasonWorldSeasonItem, goName)
      self.itemViews[goName] = theItem
    end
    theItem:SetActive(true)
    theItem:ReInit(template)
    if not template:Condition() then
      break
    end
  end
end

function LWSeasonWorldView:RefreshModel()
  self.animator:Play("V_ui_LWSeasonWorld_in1", 0, 0)
  self.animator.unity_animator:Update()
  self.animator:SetSpeed(0)
  self.model_Viewer:ReloadScene(self.configs, function()
    self.model_Viewer:RefreshMapItem()
    self.animator:SetSpeed(1)
    self.animator:Play("V_ui_LWSeasonWorld_in1", 0, 0)
  end)
end

function LWSeasonWorldView:SetUp()
  self.curIndex = -1
  self.select_season:SetActive(false)
end

function LWSeasonWorldView:OnClickItem(template, modelClick)
  if self.curIndex == template.season then
    return
  end
  local selectItemView
  for _, itemView in pairs(self.itemViews) do
    if itemView.template == template then
      selectItemView = itemView
      selectItemView:SetSelect(true)
    else
      itemView:SetSelect(false)
    end
  end
  if selectItemView == nil then
    return
  end
  self.curIndex = template.season
  self.select_season:SetActive(false)
  self.select_season:ReInit(template, selectItemView.state >= 4)
  self.model_Viewer:Switch(template, modelClick, function()
    self.select_season:SetActive(true)
  end)
end

function LWSeasonWorldView:ClickTip()
  local param = {
    activityRulesStr = Localization:GetString("season_travel_world_ui_08")
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

return LWSeasonWorldView
