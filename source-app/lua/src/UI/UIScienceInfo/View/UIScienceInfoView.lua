local UIScienceInfoView = BaseClass("UIScienceInfoView", UIBaseView)
local base = UIBaseView
local UIDetailsCell = require("UI.UIScienceInfo.Component.UIDetailsCell")
local UIDesCell = require("UI.UIScienceInfo.Component.UIDesCell")
local UINeedResCell = require("UI.UIScienceInfo.Component.UINeedResCell")
local UINeedBuildCell = require("UI.UIScienceInfo.Component.UINeedBuildCell")
local SciencePreConditionItem = require("UI.UIScienceInfo.Component.SciencePreConditionItem")
local UIShowReason = require("UI.UIShowReason.UIShowReason")
local Localization = CS.GameEntry.Localization
local panel_path = "UICommonPopUpTitle/panel"
local title_text_path = "UICommonPopUpTitle/Common_img_title/titleText"
local animator_path = "BgGo/MiddleBg"
local details_btn_path = "BgGo/MiddleBg/BuildInfo/IconBg/DetailsBtn"
local cur_level_path = "BgGo/MiddleBg/BuildInfo/CurLevelText"
local next_level_path = "BgGo/MiddleBg/BuildInfo/CurLevelText/Common_btn_arrow/NextLevelText"
local level_arrow_path = "BgGo/MiddleBg/BuildInfo/CurLevelText/Common_btn_arrow"
local des_content_path = "BgGo/MiddleBg/BuildInfo/DesContent"
local need_text_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/NeedText"
local need_res_content_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/NeedResContent"
local btn_go_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/BtnGo"
local immediately_btn_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/BtnGo/Common_btn_yellow_big"
local immediately_btn_name_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/BtnGo/Common_btn_yellow_big/btnTxt_yellow_mid_new/btnTxt_yellow_mid_new_text1"
local immediately_btn_spend_icon_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/BtnGo/Common_btn_yellow_big/btnTxt_yellow_mid_new/btnTxt_yellow_mid_new_text2/btnTxt_yellow_mid_new_icon"
local immediately_btn_spend_count_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/BtnGo/Common_btn_yellow_big/btnTxt_yellow_mid_new/btnTxt_yellow_mid_new_text2"
local free_rect_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/BtnGo/Common_btn_yellow_big/Rect_Free"
local upgrade_btn_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/BtnGo/Common_btn_green_big"
local upgrade_btn_name_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/BtnGo/Common_btn_green_big/btnTxt_green_mid_new/btnTxt_green_mid_new_text1"
local upgrade_btn_time_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/BtnGo/Common_btn_green_big/btnTxt_green_mid_new/btnTxt_green_mid_new_text2"
local need_build_content_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/NeedBuildContent"
local preConditionContainer_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/pre"
local preConditionContent_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/pre/PreConditions/Viewport/Content"
local back_btn_path = "BgGo/MiddleBg/BuildDetails/BackBtn"
local detail_title_cell_path = "BgGo/MiddleBg/BuildDetails/DetailTitleCell"
local scroll_view_path = "BgGo/MiddleBg/BuildDetails/Scroll View"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local build_icon_path = "BgGo/MiddleBg/BuildInfo/IconBg/BuildIcon"
local science_des_path = "BgGo/MiddleBg/BuildInfo/IconBg/ScienceDes"
local science_level_slider_path = "BgGo/MiddleBg/BuildInfo/IconBg/LevelSlider"
local science_level_text_path = "BgGo/MiddleBg/BuildInfo/IconBg/LevelSlider/LevelText"
local researching_slider_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/NeedResContent/TimeSlider"
local researching_left_time_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/NeedResContent/TimeSlider/TimeSliderText"
local no_reason_text_path = "BgGo/MiddleBg/BuildInfo/NoReasonText"
local condition_go_path = "BgGo/MiddleBg/BuildInfo/ConditionGo"
local max_go_path = "BgGo/MiddleBg/BuildInfo/MaxLevelGo"
local max_text_path = "BgGo/MiddleBg/BuildInfo/MaxLevelGo/MaxLevelText"
local add_speed_btn_text_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/BtnGo/Common_btn_green_big/btnTxt_green_big_new"
local show_reason_path = "BgGo/MiddleBg/BuildInfo/ConditionGo/BtnGo/Common_btn_green_big/UIShowReason"
local SliderLength = 512

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SetResBarVisible(true)
  self:ReInit()
end

local function OnDestroy(self)
  self:SetAllResCellsDestroy()
  self:SetAllCellsDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIScience) then
    self:SetResBarVisible(false)
  end
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.details_btn = self:AddComponent(UIButton, details_btn_path)
  self.cur_level = self:AddComponent(UIText, cur_level_path)
  self.next_level = self:AddComponent(UIText, next_level_path)
  self.level_arrow = self:AddComponent(UIText, level_arrow_path)
  self.des_content = self:AddComponent(UIBaseContainer, des_content_path)
  self.need_text = self:AddComponent(UIText, need_text_path)
  self.need_res_content = self:AddComponent(UIBaseContainer, need_res_content_path)
  self.btn_go = self:AddComponent(UIBaseContainer, btn_go_path)
  self.immediately_btn = self:AddComponent(UIButton, immediately_btn_path)
  self.immediately_btn_name = self:AddComponent(UIText, immediately_btn_name_path)
  self.immediately_btn_spend_icon = self:AddComponent(UIImage, immediately_btn_spend_icon_path)
  self.immediately_btn_spend_count = self:AddComponent(UIText, immediately_btn_spend_count_path)
  self.immediately_btn_spend_count_shadow = self:AddComponent(UIShadow, immediately_btn_spend_count_path)
  self._free_rect = self:AddComponent(UIBaseContainer, free_rect_path)
  self.upgrade_btn = self:AddComponent(UIButton, upgrade_btn_path)
  self.upgrade_btn_name = self:AddComponent(UIText, upgrade_btn_name_path)
  self.upgrade_btn_time = self:AddComponent(UIText, upgrade_btn_time_path)
  self.preConditionContainer = self:AddComponent(UIBaseContainer, preConditionContainer_path)
  self.preConditionContent = self:AddComponent(UIBaseContainer, preConditionContent_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.detail_title_cell = self:AddComponent(UIDetailsCell, detail_title_cell_path)
  self.build_icon = self:AddComponent(UIImage, build_icon_path)
  self.science_des = self:AddComponent(UIText, science_des_path)
  self.science_level_slider = self:AddComponent(UISlider, science_level_slider_path)
  self.science_level_text = self:AddComponent(UIText, science_level_text_path)
  self.researching_slider = self:AddComponent(UISlider, researching_slider_path)
  self.researching_left_time = self:AddComponent(UIText, researching_left_time_path)
  self.no_reason_text = self:AddComponent(UIText, no_reason_text_path)
  self.condition_go = self:AddComponent(UIBaseContainer, condition_go_path)
  self.no_reason_btn = self:AddComponent(UIButton, no_reason_text_path)
  self.max_go = self:AddComponent(UIBaseContainer, max_go_path)
  self.max_text = self:AddComponent(UIText, max_text_path)
  self.add_speed_btn_text = self:AddComponent(UIText, add_speed_btn_text_path)
  self.show_reason = self:AddComponent(UIShowReason, show_reason_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.details_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:DetailsBtnClick()
  end)
  self.immediately_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ImmediatelyBtnClick()
  end)
  self.upgrade_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Science_Start, false)
    self:UpgradeBtnClick()
  end)
  self.back_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:BackBtnClick()
  end)
  self.no_reason_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:NoReasonBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.close_btn = nil
  self.title_text = nil
  self.animator = nil
  self.details_btn = nil
  self.cur_level = nil
  self.next_level = nil
  self.level_arrow = nil
  self.des_content = nil
  self.need_text = nil
  self.need_res_content = nil
  self.btn_go = nil
  self.immediately_btn = nil
  self.immediately_btn_name = nil
  self.immediately_btn_spend_icon = nil
  self.immediately_btn_spend_count = nil
  self.immediately_btn_spend_count_shadow = nil
  self.upgrade_btn = nil
  self.upgrade_btn_name = nil
  self.upgrade_btn_time = nil
  self.back_btn = nil
  self.detail_title_cell = nil
  self.cell_go = nil
  self.des_cell = nil
  self.need_build_cell = nil
  self.scroll_view = nil
  self.build_icon = nil
  self.science_des = nil
  self.science_level_slider = nil
  self.science_level_text = nil
  self.researching_go = nil
  self.researching_icon = nil
  self.researching_slider = nil
  self.researching_left_time = nil
  self.no_reason_text = nil
  self.condition_go = nil
  self.no_reason_btn = nil
  self.max_go = nil
  self.max_text = nil
  self.add_speed_btn_text = nil
  self.show_reason = nil
end

local function DataDefine(self)
  self.lastCurTime = 0
  self.bUuid = nil
  self.buildUuid = nil
  self.buildData = nil
  self.buildTemplate = nil
  self.buildCurLevelTemplate = nil
  self.buildNextLevelTemplate = nil
  self.preBuildCells = {}
  self.freePreBuildCells = {}
  self.needResourceCells = {}
  self.freeNeedResourceCells = {}
  self.lackResource = {}
  self.lackItem = {}
  self.btnGoActive = nil
  self.immediatelyBtnSpendColor = nil
  self.needText = nil
  self.desCells = {}
  self.freeDesCells = {}
  self.spendGold = 0
  self.hasItem = nil
  self.noBuyItem = {}
  self.lackResourceItem = {}
  self.isSendFinish = nil
  self.PreConditionList = {}
  self.ResourceModels = {}
  self.modelCount = 0
end

local function DataDestroy(self)
  EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, UIWindowNames.UIScienceInfo)
  self.bUuid = nil
  self.buildUuid = nil
  self.buildData = nil
  self.buildTemplate = nil
  self.buildCurLevelTemplate = nil
  self.buildNextLevelTemplate = nil
  self.preBuildCells = nil
  self.freePreBuildCells = nil
  self.needResourceCells = nil
  self.freeNeedResourceCells = nil
  self.lackResource = nil
  self.lackItem = nil
  self.btnGoActive = nil
  self.immediatelyBtnSpendColor = nil
  self.needText = nil
  self.desCells = nil
  self.freeDesCells = nil
  self.spendGold = nil
  self.hasItem = nil
  self.lastCurTime = nil
  self.noBuyItem = nil
  self.lackResourceItem = nil
  self.isSendFinish = nil
  self.PreConditionList = nil
  self.ResourceModels = nil
  self.modelCount = nil
  self.showBtnTime = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceSignal)
  self:AddUIListener(EventId.RefreshItems, self.UpdateItemSignal)
  self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
  self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
  self:AddUIListener(EventId.RefreshResourceItem, self.UpdateResourceItemSignal)
  self:AddUIListener(EventId.OnScienceQueueResearch, self.OnScienceSearchingSignal)
  self:AddUIListener(EventId.AllianceQueueHelpNew, self.AllianceQueueHelpNewSignal)
  self:AddUIListener(EventId.SoldResourceItem, self.UpdateResourceItemSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceSignal)
  self:RemoveUIListener(EventId.RefreshItems, self.UpdateItemSignal)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
  self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
  self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.UpdateResourceItemSignal)
  self:RemoveUIListener(EventId.OnScienceQueueResearch, self.OnScienceSearchingSignal)
  self:RemoveUIListener(EventId.AllianceQueueHelpNew, self.AllianceQueueHelpNewSignal)
  self:RemoveUIListener(EventId.SoldResourceItem, self.UpdateResourceItemSignal)
end

local function ReInit(self)
  local scienceId, bUuid = self:GetUserData()
  self.scienceId = scienceId
  self.bUuid = bUuid
  self.isSendFinish = false
  self.maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(self.scienceId)
  self.queue = DataCenter.ScienceManager:GetScienceQueueByScienceId(tostring(self.scienceId))
  self:SetDetailsTitle()
  self:ShowPanel()
  self:ShowCells()
end

local function SetResBarVisible(self, isShow)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
  if not window or window.View then
  end
end

local function SetDetailsTitle(self)
  local param = UIDetailsCell.Param.New()
  local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, 1)
  if template ~= nil then
    local length = table.count(template.show)
    param.name1 = Localization:GetString(GameDialogDefine.LEVEL)
    local nextNameIndex = 2
    if 0 < length then
      param.name2 = Localization:GetString(template.show[1].dialog)
      nextNameIndex = 3
    end
    if 1 < length then
      param.name3 = Localization:GetString(template.show[2].dialog)
      nextNameIndex = 4
    end
    if 2 < length then
      param.name4 = Localization:GetString(template.show[3].dialog)
      nextNameIndex = 5
    end
    if 3 < length then
      param.name5 = Localization:GetString(template.show[4].dialog)
      nextNameIndex = 6
    end
    if 4 < length then
      param.name6 = Localization:GetString(template.show[5].dialog)
      nextNameIndex = 7
    end
    if nextNameIndex == 2 then
      for effectIndex = 1, table.count(template.effect) do
        local effectId = template.effect[effectIndex].effectId
        local nameStr = GetTableData(TableName.EffectNumDesc, effectId, "des")
        param["name" .. nextNameIndex] = Localization:GetString(nameStr)
        nextNameIndex = nextNameIndex + 1
      end
    end
    local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k1")
    if showPower <= DataCenter.BuildManager.MainLv then
      param["name" .. nextNameIndex] = Localization:GetString(GameDialogDefine.POWER)
    end
    nextNameIndex = nextNameIndex + 1
    self.detail_title_cell:ReInit(param)
  end
end

local function ShowPanel(self)
  self.curLevel = DataCenter.ScienceManager:GetScienceLevel(self.scienceId)
  local name = ""
  local des = ""
  local icon = ""
  if self.curLevel > 0 then
    self.buildCurLevelTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, self.curLevel)
    name = self.buildCurLevelTemplate.name
    des = self.buildCurLevelTemplate.description
    icon = string.format(LoadPath.ScienceIcons, self.buildCurLevelTemplate.icon)
  else
    self.buildCurLevelTemplate = nil
  end
  if self.curLevel < self.maxLevel then
    self.buildNextLevelTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, self.curLevel + 1)
    if name == "" then
      name = self.buildNextLevelTemplate.name
    end
    if des == "" then
      des = self.buildNextLevelTemplate.description
    end
    if icon == "" then
      icon = string.format(LoadPath.ScienceIcons, self.buildNextLevelTemplate.icon)
    end
    self.next_level:SetText(self.curLevel + 1)
    self.next_level:SetActive(true)
    self.level_arrow:SetActive(true)
    self.preLockedId = nil
    local needScience = self.buildNextLevelTemplate.needScience
    if needScience then
      for k, v in ipairs(needScience) do
        if not DataCenter.ScienceManager:HasScienceByIdAndLevel(v.scienceId, 1) then
          self.preLockedId = v.scienceId
          break
        end
      end
    end
    local param = {}
    param.list = {}
    param.uiName = UIWindowNames.UIScienceInfo
    local resources = self.buildNextLevelTemplate.needResource
    if resources ~= nil then
      local signal = {}
      for k, v in ipairs(resources) do
        table.insert(signal, v.resourceType)
      end
      table.sort(signal, function(a, b)
        return a < b
      end)
      param.list = signal
    end
    local items = self.buildNextLevelTemplate.needItem
    if items then
      param.itemList = {}
      for i, v in ipairs(items) do
        table.insert(param.itemList, v.itemId)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
  else
    self.buildNextLevelTemplate = nil
    self.next_level:SetActive(false)
    self.level_arrow:SetActive(false)
  end
  self.title_text:SetLocalText(name)
  self.cur_level:SetLocalText(GameDialogDefine.LEVEL_NUMBER, self.curLevel)
  self.science_des:SetLocalText(des)
  self.build_icon:LoadSprite(icon)
  self.science_level_text:SetText(self.curLevel .. "/" .. self.maxLevel)
  self.science_level_slider:SetValue(self.curLevel / self.maxLevel)
  self.researchingActive = false
  if self.curLevel >= self.maxLevel then
    self.max_text:SetLocalText(GameDialogDefine.REACH_MAX_LEVEL)
    self:SetConditionActive(false)
    self.max_go:SetActive(true)
    self.no_reason_text:SetActive(false)
    self.preConditionContainer:SetActive(false)
    self.show_reason:SetActive(false)
    self:SetBtnGoActive(false)
  else
    local unreachedPreConditions = self:GetUnreachedPreConditions()
    if 0 < #unreachedPreConditions then
      self:SetConditionActive(true)
      self.need_text:SetLocalText(100040)
      self.max_go:SetActive(false)
      self.no_reason_text:SetActive(false)
      self.researching_slider:SetActive(false)
      self.add_speed_btn_text:SetActive(false)
      self.upgrade_btn_name:SetActive(true)
      self.upgrade_btn_time:SetActive(true)
      if DataCenter.BuildManager:IsShowDiamond() then
        self.immediately_btn:SetActive(true)
      else
        self.immediately_btn:SetActive(false)
      end
      self:ShowNeedResource()
      self.preConditionContainer:SetActive(true)
      self:ShowPreConditions(unreachedPreConditions)
      self.show_reason:SetActive(false)
      self:SetBtnGoActive(false)
    elseif self.preLockedId then
      self.no_reason_text:SetLocalText(GameDialogDefine.NEED_PRE_SCIENCE_LEVEL)
      self:SetConditionActive(false)
      self.max_go:SetActive(false)
      self.no_reason_text:SetActive(true)
      self.preConditionContainer:SetActive(false)
      self.show_reason:SetActive(false)
      self:SetBtnGoActive(false)
    elseif self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work and tostring(self.scienceId) == self.queue.itemId then
      self:SetConditionActive(true)
      self.need_text:SetLocalText(GameDialogDefine.LEFT_TIME)
      self.max_go:SetActive(false)
      self.no_reason_text:SetActive(false)
      self.researching_slider:SetActive(true)
      self.immediately_btn:SetActive(false)
      self.upgrade_btn_name:SetActive(false)
      self.upgrade_btn_time:SetActive(false)
      self.add_speed_btn_text:SetActive(true)
      self.preConditionContainer:SetActive(false)
      self:RefreshResearchingBtnName()
      self.researchingActive = true
      self.lackResource = {}
      for k, v in pairs(self.needResourceCells) do
        v:SetActive(false)
        table.insert(self.freeNeedResourceCells, v)
      end
      self.needResourceCells = {}
      self:SetBtnGoActive(true)
      self.show_reason:SetActive(false)
    else
      self:SetConditionActive(true)
      self.need_text:SetLocalText(GameDialogDefine.NEED)
      self.max_go:SetActive(false)
      self.no_reason_text:SetActive(false)
      self.researching_slider:SetActive(false)
      self.add_speed_btn_text:SetActive(false)
      self.upgrade_btn_name:SetActive(true)
      self.upgrade_btn_time:SetActive(true)
      if DataCenter.BuildManager:IsShowDiamond() then
        self.immediately_btn:SetActive(true)
      else
        self.immediately_btn:SetActive(false)
      end
      self:ShowNeedResource()
      self.preConditionContainer:SetActive(false)
      self:SetBtnGoActive(true)
      self:ShowBtn()
      self:ShowReason()
    end
  end
  self:ShowDesCells()
  self:ShowDesCellsWithoutShow()
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIDetailsCell)
end

local function TryShowPreConditions(self)
  local conditions = self:GetUnreachedPreConditions()
  if conditions and 0 < #conditions then
    self.preConditionContainer:SetActive(true)
    self:ShowPreConditions(conditions)
    self.show_reason:SetActive(false)
    self:SetBtnGoActive(false)
  else
    self.preConditionContainer:SetActive(false)
    self:SetBtnGoActive(true)
    self:ShowBtn()
    self:ShowReason()
  end
end

local function ShowPreConditions(self, conditions)
  self:SetAllPreConditionsDestroy()
  local list = conditions
  self.modelCount = 0
  if list ~= nil and 0 < #list then
    for i = 1, table.length(list) do
      self.modelCount = self.modelCount + 1
      self.ResourceModels[self.modelCount] = self:GameObjectInstantiateAsync(UIAssets.UIScienceInfoPreConditionItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.preConditionContent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.preConditionContent:AddComponent(SciencePreConditionItem, nameStr)
        cell:SetCondition(list[i])
        table.insert(self.PreConditionList, cell)
      end)
    end
  end
end

local function SetAllPreConditionsDestroy(self)
  self.preConditionContent:RemoveComponents(SciencePreConditionItem)
  if self.ResourceModels ~= nil then
    for k, v in pairs(self.ResourceModels) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.ResourceModels = {}
  self.PreConditionList = {}
end

local function GetUnreachedPreConditions(self)
  local retTb = {}
  self.preBuildCells = {}
  local needPre = false
  local preBuild = self.buildNextLevelTemplate.needBuild
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.bUuid)
  if preBuild ~= nil then
    for k1, v1 in ipairs(preBuild) do
      local buildId = v1.buildId
      if v1.buildId == BuildingTypes.FUN_BUILD_SCIENE then
        buildId = buildingData.itemId
      end
      if not DataCenter.BuildManager:IsExistBuildByTypeLv(buildId, v1.level) then
        local cond = {}
        cond.condType = 1
        cond.itemId = buildId
        cond.level = v1.level
        table.insert(retTb, cond)
      end
    end
  end
  local needScience = self.buildNextLevelTemplate.needScience
  if needScience ~= nil then
    for k, v in ipairs(needScience) do
      if not DataCenter.ScienceManager:HasScienceByIdAndLevel(v.scienceId, v.level) then
        local cond = {}
        cond.condType = 2
        cond.itemId = v.scienceId
        cond.level = v.level
        table.insert(retTb, cond)
      end
    end
  end
  return retTb
end

local function ShowPreBuild(self)
  for k, v in pairs(self.preBuildCells) do
    v.gameObject:SetActive(false)
    table.insert(self.freePreBuildCells, v)
  end
  self.preBuildCells = {}
  local needPre = false
  local preBuild = self.buildNextLevelTemplate.needBuild
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.bUuid)
  if preBuild ~= nil then
    for k1, v1 in ipairs(preBuild) do
      if buildingData.level < v1.level then
        needPre = true
        self:AddOnePreBuildCells(buildingData.itemId, v1.level)
      end
    end
  end
  if needPre then
    self.need_build_content:SetActive(true)
    self:SetBtnGoActive(false)
    self.show_reason:SetActive(false)
  else
    self.need_build_content:SetActive(false)
    self:SetBtnGoActive(true)
    self:ShowBtn()
    self:ShowReason()
  end
end

local function AddOnePreBuildCells(self, buildId, buildLv)
  if #self.freePreBuildCells > 0 then
    local temp = table.remove(self.freePreBuildCells)
    if temp ~= nil then
      local param = UINeedBuildCell.Param.New()
      param.buildId = buildId
      param.buildLv = buildLv
      temp.gameObject:SetActive(true)
      temp:ReInit(param)
      temp.transform:SetParent(self.need_build_content.transform)
      temp.transform:SetAsLastSibling()
      self.preBuildCells[param.buildId] = temp
    end
  else
    self:GameObjectInstantiateAsync(UIAssets.NeedBuildCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.need_build_content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:SetAsLastSibling()
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      self.preBuildCells[buildId] = self.need_build_content:AddComponent(UINeedBuildCell, nameStr)
      local param = UINeedBuildCell.Param.New()
      param.buildId = buildId
      param.buildLv = buildLv
      self.preBuildCells[buildId]:ReInit(param)
    end)
  end
end

local function ShowBtn(self)
  self.immediately_btn_name:SetLocalText(GameDialogDefine.IMMEDIATELY_RESEARCHING)
  self.immediately_btn_spend_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
  self:RefreshImmediatelyGold()
  self.upgrade_btn_name:SetLocalText(GameDialogDefine.RESEARCHING)
  local nTime = self.buildNextLevelTemplate:GetScienceTime()
  self.showBtnTime = nTime
  self.upgrade_btn_time:SetText(UITimeManager:GetInstance():SecondToFmtString(nTime))
end

local function RefreshImmediatelyGold(self)
  self._free_rect:SetActive(false)
  local nTime = self.buildNextLevelTemplate:GetScienceTime()
  self.spendGold = CommonUtil.GetTimeDiamondCost(nTime)
  if table.count(self.lackResource) > 0 then
    for k, v in ipairs(self.lackResource) do
      self.spendGold = self.spendGold + CommonUtil.GetResGoldByType(v.resourceType, v.needCount)
    end
  end
  if 0 < table.count(self.lackItem) then
    for k, v in ipairs(self.lackItem) do
      self.spendGold = self.spendGold + v.needGold
    end
  end
  local freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE)
  if 0 < freeTime and nTime <= freeTime then
    if table.count(self.lackResource) > 0 or 0 < table.count(self.lackItem) then
      self.isFree = false
      self.immediately_btn_name:SetAnchoredPositionXY(self.immediately_btn_name:GetAnchoredPositionX(), 33)
      self.immediately_btn_spend_count:SetActive(true)
    else
      self._free_rect:SetActive(true)
      self.isFree = true
      self.immediately_btn_name:SetAnchoredPositionXY(self.immediately_btn_name:GetAnchoredPositionX(), 20)
      self.immediately_btn_spend_count:SetActive(false)
    end
  else
    self.isFree = false
    self.immediately_btn_name:SetAnchoredPositionXY(self.immediately_btn_name:GetAnchoredPositionX(), 33)
    self.immediately_btn_spend_count:SetActive(true)
  end
  self.immediately_btn_spend_count:SetText(string.GetFormattedSeperatorNum(self.spendGold))
  self:RefreshGoldColor()
end

local function RefreshGoldColor(self)
  local gold = LuaEntry.Player.gold
  if gold < self.spendGold then
    self:SetImmediatelyBtnSpendColor(RedColor)
    self.immediately_btn_spend_count_shadow:AllEnable(false)
  else
    self:SetImmediatelyBtnSpendColor(WhiteColor)
    self.immediately_btn_spend_count_shadow:AllEnable(true)
  end
end

local function ShowNeedResource(self)
  self.lackResource = {}
  for k, v in pairs(self.needResourceCells) do
    v:SetActive(false)
    table.insert(self.freeNeedResourceCells, v)
  end
  self.needResourceCells = {}
  local addList = {}
  local resources = self.buildNextLevelTemplate.needResource
  if resources ~= nil then
    for k1, v1 in ipairs(resources) do
      local param = UINeedResCell.Param.New()
      param.resourceType = v1.resourceType
      param.count = v1.count
      local own = LuaEntry.Resource:GetCntByResType(v1.resourceType)
      if own < v1.count then
        local res = {}
        res.resourceType = v1.resourceType
        res.allCount = v1.count
        res.needCount = v1.count - own
        table.insert(self.lackResource, res)
        param.isRed = true
      else
        param.isRed = false
      end
      table.insert(addList, param)
    end
    table.sort(addList, function(a, b)
      return a.resourceType < b.resourceType
    end)
  end
  self.lackResourceItem = {}
  local items = self.buildNextLevelTemplate.needResourceItem
  if items ~= nil then
    for k1, v1 in ipairs(items) do
      local param = UINeedResCell.Param.New()
      param.resourceItemId = v1.resourceItemId
      param.count = v1.count
      local own = 0
      local item = DataCenter.ResourceItemDataManager:GetItemDataByItemId(param.resourceItemId)
      if item ~= nil then
        own = item.number
      end
      if own < param.count then
        local res = {}
        res.resourceItemId = param.resourceItemId
        res.allCount = param.count
        res.needCount = param.count - own
        table.insert(self.lackResourceItem, res)
        param.isRed = true
      else
        param.isRed = false
      end
      table.insert(addList, param)
    end
  end
  self.noBuyItem = {}
  self.lackItem = {}
  self.hasItem = false
  items = self.buildNextLevelTemplate.needItem
  if items ~= nil then
    for k1, v1 in ipairs(items) do
      local param = UINeedResCell.Param.New()
      param.itemId = v1.itemId
      param.count = v1.count
      local own = 0
      local item = DataCenter.ItemData:GetItemById(param.itemId)
      if item ~= nil then
        own = item.count
      end
      if own < param.count then
        local template = DataCenter.ItemTemplateManager:GetItemTemplate(param.itemId)
        if template ~= nil then
          if 0 < template.price then
            local par = {}
            par.itemId = param.itemId
            par.allCount = param.count
            par.needCount = param.count - own
            par.needGold = template.price * par.needCount
            table.insert(self.lackItem, par)
          else
            local par = {}
            par.itemId = param.itemId
            par.allCount = param.count
            par.needCount = param.count - own
            table.insert(self.noBuyItem, par)
          end
        end
        param.isRed = true
      else
        param.isRed = false
      end
      table.insert(addList, param)
      self.hasItem = true
    end
  end
  self:AddNeedResourceCells(addList)
end

local function AddNeedResourceCells(self, addList)
  self:SetAllResCellsDestroy()
  self.model = {}
  local list = addList
  if list ~= nil then
    self.modelCount = 0
    for i = 1, table.length(list) do
      self.modelCount = self.modelCount + 1
      self.model[self.modelCount] = self:GameObjectInstantiateAsync(UIAssets.NeedResourceCell, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.need_res_content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:SetAsLastSibling()
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local temp = self.need_res_content:AddComponent(UINeedResCell, nameStr)
        temp:ReInit(list[i])
        table.insert(self.needResourceCells, temp)
      end)
    end
  end
end

local function SetAllResCellsDestroy(self)
  self.need_res_content:RemoveComponents(UINeedResCell)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function AddOneNeedResourceCells(self, param)
  if #self.freeNeedResourceCells > 0 then
    local temp = table.remove(self.freeNeedResourceCells)
    if temp ~= nil then
      temp.gameObject:SetActive(true)
      temp:ReInit(param)
      temp.transform:SetParent(self.need_res_content.transform)
      temp.transform:SetAsLastSibling()
      table.insert(self.needResourceCells, temp)
    end
  else
    self:GameObjectInstantiateAsync(UIAssets.NeedResourceCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.need_res_content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:SetAsLastSibling()
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local temp = self.need_res_content:AddComponent(UINeedResCell, nameStr)
      temp:ReInit(param)
      table.insert(self.needResourceCells, temp)
    end)
  end
end

local function OnCreateCell(self, itemObj, index)
  local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, index)
  if template ~= nil then
    local nextNameIndex = 1
    itemObj.name = self.scienceId + index
    local cellItem = self.scroll_view:AddComponent(UIDetailsCell, itemObj)
    local param = UIDetailsCell.Param.New()
    local length = table.count(template.show)
    param.name1 = index
    nextNameIndex = 2
    if 0 < length then
      param.name2 = DataCenter.BuildManager:GetEffectNumWithType(template.show[1].value, template.show[1].valueType)
      nextNameIndex = 3
    end
    if 1 < length then
      param.name3 = DataCenter.BuildManager:GetEffectNumWithType(template.show[2].value, template.show[2].valueType)
      nextNameIndex = 4
    end
    if 2 < length then
      param.name4 = DataCenter.BuildManager:GetEffectNumWithType(template.show[3].value, template.show[3].valueType)
      nextNameIndex = 5
    end
    if 3 < length then
      param.name5 = DataCenter.BuildManager:GetEffectNumWithType(template.show[4].value, template.show[4].valueType)
      nextNameIndex = 6
    end
    if 4 < length then
      param.name6 = DataCenter.BuildManager:GetEffectNumWithType(template.show[5].value, template.show[5].valueType)
      nextNameIndex = 7
    end
    if nextNameIndex == 2 then
      for effectIndex = 1, table.count(template.effect) do
        local effectId = template.effect[effectIndex].effectId
        local type = toInt(GetTableData(TableName.EffectNumDesc, effectId, "type"))
        local curNum = tonumber(template.effect[effectIndex].effectValue)
        local curValue = self:GetEffectNumWithType(curNum, type)
        param["name" .. nextNameIndex] = curValue
        nextNameIndex = nextNameIndex + 1
      end
    end
    local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k1")
    if showPower <= DataCenter.BuildManager.MainLv then
      param["name" .. nextNameIndex] = "+" .. template.power
    end
    nextNameIndex = nextNameIndex + 1
    cellItem:ReInit(param)
  end
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIDetailsCell)
end

local function ShowCells(self)
  self:ClearScroll()
  self.scroll_view:SetTotalCount(self.maxLevel)
  self.scroll_view:RefillCells()
end

local function SetAllCellsDestroy(self)
  self:ClearScroll()
end

local function DetailsBtnClick(self)
  self.animator:Play("switchEnter", 0, 0)
end

local function ImmediatelyBtnClick(self)
  if table.count(self.lackResourceItem) > 0 or 0 < table.count(self.noBuyItem) then
    UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
  elseif self.immediatelyBtnSpendColor == RedColor then
    GoToUtil.GotoPayTips(self.spendGold)
  elseif self.isFree then
    SFSNetwork.SendMessage(MsgDefines.ScienceResearchNew, {
      itemId = self.scienceId,
      useGold = ScienceResearchUseGold.Free,
      robotUuid = 0,
      bUuid = self.bUuid
    })
    local heroData = DataCenter.HeroDataManager:GetFreeAddTimeHero(EffectDefine.RESEARCH_TIME_REDUCE)
    if heroData then
      do
        local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroData.heroId)
        local name = Localization:GetString(heroConfig.name)
        local freeTime = Mathf.Ceil(LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE) / 60)
        local time
        if self.showBtnTime then
          if self.showBtnTime < LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE) then
            if 60 < self.showBtnTime then
              local min = Mathf.Floor(self.showBtnTime / 60)
              time = min .. Localization:GetString("100165")
            else
              time = Localization:GetString("130076", self.showBtnTime)
            end
          else
            time = freeTime .. Localization:GetString("100165")
          end
        else
          time = freeTime .. Localization:GetString("100165")
        end
        local str = Localization:GetString("110201", name, time, Localization:GetString("310148"))
        TimerManager:GetInstance():DelayInvoke(function()
          UIUtil.ShowTips(str, nil, nil, heroData)
        end, 1)
      end
    end
  else
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.ScienceResearchNew, {
        itemId = self.scienceId,
        useGold = ScienceResearchUseGold.UseGold,
        robotUuid = 0,
        bUuid = self.bUuid
      })
      local heroData = DataCenter.HeroDataManager:GetFreeAddTimeHero(EffectDefine.RESEARCH_TIME_REDUCE)
      if heroData then
        local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroData.heroId)
        local name = Localization:GetString(heroConfig.name)
        local freeTime = Mathf.Ceil(LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE) / 60)
        if freeTime == 0 then
          return
        end
        local time
        if self.showBtnTime then
          if self.showBtnTime < LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE) then
            if 60 < self.showBtnTime then
              local min = Mathf.Floor(self.showBtnTime / 60)
              time = min .. Localization:GetString("100165")
            else
              time = Localization:GetString("130076", self.showBtnTime)
            end
          else
            time = freeTime .. Localization:GetString("100165")
          end
        else
          time = freeTime .. Localization:GetString("100165")
        end
        local str = Localization:GetString("110201", name, time, Localization:GetString("100025"))
        TimerManager:GetInstance():DelayInvoke(function()
          UIUtil.ShowTips(str, nil, nil, heroData)
        end, 1)
      end
    end, function()
    end)
  end
end

local function UpgradeBtnClick(self)
  if self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
    if self.queue.itemId ~= nil then
      if LuaEntry.Player:IsInAlliance() and self.queue.isHelped == 0 then
        SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp, self.queue.uuid, AllianceHelpType.Queue, NewQueueType.Science, self.queue.itemId)
        self.add_speed_btn_text:SetLocalText(GameDialogDefine.ADD_SPEED)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, {anim = true}, ItemSpdMenu.ItemSpdMenu_Science, self.queue.uuid)
      end
    else
      UIUtil.ShowTipsId(129107)
    end
  else
    local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(self.bUuid)
    if queue ~= nil then
      local robotData
      local robotIndex = DataCenter.BuildQueueManager:GetFreeQueueIndex()
      if 0 < robotIndex then
        robotData = DataCenter.BuildQueueManager:GetQueueDataByIndex(robotIndex)
      end
      if robotData ~= nil then
        if queue:GetQueueState() == NewQueueState.Free then
          if 0 < table.count(self.lackResource) then
            local tempRes = {}
            for k, v in ipairs(self.lackResource) do
              local param = {}
              param.type = ResLackType.Res
              param.resType = v.resourceType
              param.targetNum = v.allCount
              table.insert(tempRes, param)
            end
            GoToResLack.GoToItemResLackList(tempRes)
          elseif 0 < table.count(self.lackResourceItem) then
            UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
          elseif 0 < table.count(self.lackItem) or 0 < table.count(self.noBuyItem) then
            UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
          else
            SFSNetwork.SendMessage(MsgDefines.ScienceResearchNew, {
              itemId = self.scienceId,
              useGold = ScienceResearchUseGold.NoUseGold,
              robotUuid = robotData.uuid,
              bUuid = queue.funcUuid
            })
            self.ctrl:CloseSelf()
          end
        elseif 0 < table.count(self.lackResourceItem) then
          UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
        elseif 0 < table.count(self.lackItem) or 0 < table.count(self.noBuyItem) then
          UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
        else
          UIUtil.ShowTipsId(129107)
        end
      elseif queue:GetQueueState() == NewQueueState.Free then
        if 0 < table.count(self.lackResource) then
          local lackTab = {}
          for k, v in pairs(self.lackResource) do
            local param = {}
            param.type = ResLackType.Res
            param.resType = v.resourceType
            param.targetNum = v.allCount
            table.insert(lackTab, param)
          end
          GoToResLack.GoToItemResLackList(lackTab)
        elseif 0 < table.count(self.lackResourceItem) then
          UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
        elseif 0 < table.count(self.lackItem) or 0 < table.count(self.noBuyItem) then
          UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
        else
          local buildQueueParam = {}
          buildQueueParam.enterType = UIBuildQueueEnterType.Science
          buildQueueParam.uuid = self.bUuid
          buildQueueParam.messageParam = self.scienceId
          DataCenter.BuildQueueManager:SetWillUpgradeParam(buildQueueParam)
          self.ctrl:CloseSelf()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildList)
          UIUtil.ShowTipsId(130500)
        end
      else
        UIUtil.ShowTipsId(129107)
      end
    end
  end
end

local function BackBtnClick(self)
  self.animator:Play("switchOut", 0, 0)
end

local function SetBtnGoActive(self, value)
  if self.btnGoActive ~= value then
    self.btnGoActive = value
    self.btn_go.gameObject:SetActive(value)
  end
end

local function SetImmediatelyBtnSpendColor(self, value)
  if self.immediatelyBtnSpendColor ~= value then
    self.immediatelyBtnSpendColor = value
    self.immediately_btn_spend_count:SetColor(value)
  end
end

local function SetBuildIconImage(self, imageName)
  self.build_icon:LoadSprite(imageName)
end

local function SetBuildIconImageScale(self, value)
  if self.buildIconScale ~= value then
    self.buildIconScale = value
    self.build_icon.transform.localScale = value
  end
end

local function ShowDesCellsWithoutShow(self)
  if self.buildNextLevelTemplate ~= nil and table.count(self.buildNextLevelTemplate.show) > 0 then
    return
  end
  if self.buildCurLevelTemplate ~= nil and 0 < table.count(self.buildCurLevelTemplate.show) then
    return
  end
  for k, v in pairs(self.desCells) do
    v.gameObject:SetActive(false)
    table.insert(self.freeDesCells, v)
  end
  local isUse = false
  self.desCells = {}
  if self.buildCurLevelTemplate == nil and self.buildNextLevelTemplate ~= nil then
    local count = table.count(self.buildNextLevelTemplate.effect)
    for k, v in ipairs(self.buildNextLevelTemplate.effect) do
      local param = {}
      local effectId = v.effectId
      local value = v.effectValue
      local nameStr = GetTableData(TableName.EffectNumDesc, effectId, "des")
      param.name = Localization:GetString(nameStr)
      local type = toInt(GetTableData(TableName.EffectNumDesc, effectId, "type"))
      if type == EffectLocalType.Dialog then
        param.addValue = self:GetEffectNumWithType(value, type)
      else
        local numb = tonumber(value)
        param.addValue = self:GetEffectNumWithType(numb, type)
      end
      param.showLine = k ~= count
      self:AddOneDesCells(param)
      isUse = true
    end
    self:AddPowerDesCell(-1)
  elseif self.buildCurLevelTemplate ~= nil and self.buildNextLevelTemplate == nil then
    local isFirst = true
    for k, v in ipairs(self.buildCurLevelTemplate.effect) do
      local param = {}
      local effectId = v.effectId
      local value = v.effectValue
      local nameStr = GetTableData(TableName.EffectNumDesc, effectId, "des")
      param.name = Localization:GetString(nameStr)
      local type = toInt(GetTableData(TableName.EffectNumDesc, effectId, "type"))
      if type == EffectLocalType.Dialog then
        param.curValue = self:GetEffectNumWithType(value, type)
      else
        local numb = tonumber(value)
        param.curValue = self:GetEffectNumWithType(numb, type)
      end
      if isFirst then
        param.showLine = false
        isFirst = false
      else
        param.showLine = true
      end
      self:AddOneDesCells(param)
      isUse = true
    end
    self:AddPowerDesCell(1)
  elseif self.buildCurLevelTemplate ~= nil and self.buildNextLevelTemplate ~= nil then
    local curNums = self.buildCurLevelTemplate.effect
    local nextNums = self.buildNextLevelTemplate.effect
    local allCount = table.count(nextNums)
    for i = 1, allCount do
      local param = {}
      local effectId = nextNums[i].effectId
      local value = nextNums[i].effectValue
      local nameStr = GetTableData(TableName.EffectNumDesc, effectId, "des")
      param.name = Localization:GetString(nameStr)
      local type = toInt(GetTableData(TableName.EffectNumDesc, effectId, "type"))
      if type == EffectLocalType.Dialog then
        param.addValue = self:GetEffectNumWithType(value, type)
      else
        local curNumb = tonumber(curNums[i].effectValue)
        local nextNumb = value
        if nextNumb == curNumb then
          param.curValue = self:GetEffectNumWithType(curNumb, type)
        else
          param.curValue = self:GetEffectNumWithType(curNumb, type)
          param.addValue = self:GetEffectNumWithType(nextNumb, type)
        end
      end
      param.showLine = allCount ~= i
      self:AddOneDesCells(param)
      isUse = true
    end
    self:AddPowerDesCell(0)
  end
  self.des_content:SetActive(isUse)
end

local function ShowDesCells(self)
  if self.buildNextLevelTemplate ~= nil and table.count(self.buildNextLevelTemplate.show) == 0 then
    return
  end
  if self.buildCurLevelTemplate ~= nil and table.count(self.buildCurLevelTemplate.show) == 0 then
    return
  end
  for k, v in pairs(self.desCells) do
    v.gameObject:SetActive(false)
    table.insert(self.freeDesCells, v)
  end
  local isUse = false
  self.desCells = {}
  if self.buildCurLevelTemplate == nil and self.buildNextLevelTemplate ~= nil then
    local count = table.count(self.buildNextLevelTemplate.show)
    for k, v in ipairs(self.buildNextLevelTemplate.show) do
      local param = {}
      param.name = Localization:GetString(v.dialog)
      local type = v.valueType
      if type == EffectLocalType.Dialog then
        param.addValue = DataCenter.BuildManager:GetEffectNumWithType(v.value, type)
      else
        local numb = tonumber(v.value)
        param.addValue = DataCenter.BuildManager:GetEffectNumWithType(numb, type)
      end
      param.showLine = k ~= count
      self:AddOneDesCells(param)
      isUse = true
    end
    self:AddPowerDesCell(-1)
  elseif self.buildCurLevelTemplate ~= nil and self.buildNextLevelTemplate == nil then
    local isFirst = true
    for k, v in ipairs(self.buildCurLevelTemplate.show) do
      local param = {}
      param.name = Localization:GetString(v.dialog)
      local type = v.valueType
      if type == EffectLocalType.Dialog then
        param.curValue = DataCenter.BuildManager:GetEffectNumWithType(v.value, type)
      else
        local numb = tonumber(v.value)
        param.curValue = DataCenter.BuildManager:GetEffectNumWithType(numb, type)
      end
      if isFirst then
        param.showLine = false
        isFirst = false
      else
        param.showLine = true
      end
      self:AddOneDesCells(param)
      isUse = true
    end
    self:AddPowerDesCell(1)
  elseif self.buildCurLevelTemplate ~= nil and self.buildNextLevelTemplate ~= nil then
    local curNums = self.buildCurLevelTemplate.show
    local nextNums = self.buildNextLevelTemplate.show
    local allCount = table.count(nextNums)
    for i = 1, allCount do
      local param = {}
      param.name = Localization:GetString(nextNums[i].dialog)
      local type = nextNums[i].valueType
      if type == EffectLocalType.Dialog then
        param.addValue = DataCenter.BuildManager:GetEffectNumWithType(nextNums[i].value, type)
      else
        local curNumb = tonumber(curNums[i].value)
        local nextNumb = tonumber(nextNums[i].value)
        if nextNumb == curNumb then
          param.curValue = DataCenter.BuildManager:GetEffectNumWithType(curNumb, type)
        else
          param.curValue = DataCenter.BuildManager:GetEffectNumWithType(curNumb, type)
          param.addValue = DataCenter.BuildManager:GetEffectNumWithType(nextNumb, type)
        end
      end
      param.showLine = allCount ~= i
      self:AddOneDesCells(param)
      isUse = true
    end
    self:AddPowerDesCell(0)
  end
  self.des_content:SetActive(isUse)
end

local function AddPowerDesCell(self, type)
  local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k1")
  if showPower <= DataCenter.BuildManager.MainLv then
    self.des_content:SetActive(true)
    local param = {}
    param.name = Localization:GetString(GameDialogDefine.POWER)
    if type == -1 then
      local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, index)
      param.addValue = "+" .. self.buildNextLevelTemplate.power
    elseif type == 1 then
      param.curValue = "+" .. self.buildCurLevelTemplate.power
    else
      param.curValue = "+" .. self.buildCurLevelTemplate.power
      param.addValue = "+" .. self.buildNextLevelTemplate.power
    end
    param.showLine = true
    self:AddOneDesCells(param)
  end
end

local function AddOneDesCells(self, param)
  if #self.freeDesCells > 0 then
    local temp = table.remove(self.freeDesCells)
    if temp ~= nil then
      temp.gameObject:SetActive(true)
      temp:ReInit(param)
      temp.transform:SetParent(self.des_content.transform)
      temp.transform:SetAsLastSibling()
      self.desCells[param.name] = temp
    end
  else
    self:GameObjectInstantiateAsync(UIAssets.DesCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.des_content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:SetAsLastSibling()
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      self.desCells[param.name] = self.des_content:AddComponent(UIDesCell, nameStr)
      self.desCells[param.name]:ReInit(param)
    end)
  end
end

local function UpdateBuildDataSignal(self, uuid)
  if table.count(self.preBuildCells) > 0 then
    local tempBuild = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    if tempBuild ~= nil and self.preBuildCells[tempBuild.type] ~= nil then
      self:TryShowPreConditions()
    end
  end
end

local function UpdateResourceSignal(self)
  if self.conditionActive and not self.researchingActive then
    self:ShowNeedResource()
    if self.btnGoActive then
      self:ShowBtn()
    end
  end
end

local function UpdateResourceItemSignal(self)
  if self.conditionActive and not self.researchingActive then
    self:ShowNeedResource()
    if self.btnGoActive then
      self:ShowBtn()
    end
  end
end

local function UpdateGoldSignal(self)
  if self.conditionActive and self.btnGoActive then
    self:RefreshGoldColor()
  end
end

local function UpdateItemSignal(self)
  if self.conditionActive and not self.researchingActive and self.hasItem then
    self:ShowNeedResource()
    if self.btnGoActive then
      self:ShowBtn()
    end
  end
end

local function SetConditionActive(self, value)
  if self.conditionActive ~= value then
    self.conditionActive = value
    self.condition_go:SetActive(value)
  end
end

local function Update(self)
  if self.researchingActive and self.queue ~= nil then
    if self.queue:GetQueueState() == NewQueueState.Work then
      self:UpdateLeftTime()
    elseif self.queue:GetQueueState() == NewQueueState.Finish and not self.isSendFinish then
      self.isSendFinish = true
      DataCenter.ScienceManager:CheckResearchFinishByBuildUuid(tonumber(self.queue.funcUuid))
    end
  end
end

local function UpdateLeftTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local changeTime = self.queue.endTime - curTime
  local maxTime = self.queue.endTime - self.queue.startTime
  if changeTime < maxTime and 0 < changeTime then
    local tempTimeSec = math.ceil(changeTime / 1000)
    if tempTimeSec ~= self.laseTime then
      self.laseTime = tempTimeSec
      local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
      self:SetCurTimeValue(tempTimeValue)
    end
    if 0 < maxTime then
      local tempValue = 1 - changeTime / maxTime
      if TimeBarUtil.CheckIsNeedChangeBar(changeTime, self.queue.endTime - self.lastCurTime, maxTime, SliderLength) then
        self.lastCurTime = curTime
        self:SetSliderValue(tempValue)
      end
    end
  else
    self.laseTime = 0
    self:SetSliderValue(0)
    self:SetCurTimeValue("")
  end
end

local function SetSliderValue(self, value)
  if self.curSliderValue ~= value then
    self.curSliderValue = value
    self.researching_slider:SetValue(value)
  end
end

local function SetCurTimeValue(self, value)
  if self.curTimeValue ~= value then
    self.curTimeValue = value
    self.researching_left_time:SetText(value)
  end
end

local function UpdateScienceSignal(self, scienceId)
  self:ShowPanel()
end

local function NoReasonBtnClick(self)
  if self.preLockedId then
    self.ctrl:CloseSelf()
    GoToUtil.GotoScience(self.preLockedId)
  end
end

local function RefreshResearchingBtnName(self)
  if LuaEntry.Player:IsInAlliance() and self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work and self.queue.isHelped == 0 then
    self.add_speed_btn_text:SetLocalText(GameDialogDefine.ALLIANCE_HELP)
  else
    self.add_speed_btn_text:SetLocalText(GameDialogDefine.ADD_SPEED)
  end
end

local function OnScienceSearchingSignal(self)
  self:ShowPanel()
end

local function OnScienceQueueFinishSignal(self)
  self.isSendFinish = false
  self:ShowPanel()
end

local function AllianceQueueHelpNewSignal(self)
  self:ShowPanel()
end

local function GetEffectNumWithType(self, value, type)
  local addValue = tonumber(value)
  local addSign = addValue and tonumber(addValue) > 0 and "+" or ""
  if type == EffectLocalTypeInEffectDesc.Num then
    return addSign .. string.GetFormattedSeperatorNum(value)
  elseif type == EffectLocalTypeInEffectDesc.Percent then
    return addSign .. string.GetFormattedPercentStr(value / 100)
  elseif type == EffectLocalTypeInEffectDesc.Thousandth then
    return addSign .. string.GetFormattedThousandthStr(value / 1000)
  end
end

local function ShowReason(self)
  local effectId = EffectDefine.SCIENCE_SPEED_ADD
  local needLevel = LuaEntry.DataConfig:TryGetNum("show_power", "k1")
  local buildSpeedValue = LuaEntry.Effect:GetGameEffect(effectId)
  if LuaEntry.DataConfig:CheckSwitch("update_detail") and needLevel <= DataCenter.BuildManager.MainLv and buildSpeedValue ~= nil and 0 < buildSpeedValue and 0 < self.buildNextLevelTemplate.time then
    local effectValueX = 0
    local effectValueY = 0
    self.show_reason:SetActive(true)
    local param = {}
    param.originalTime = Localization:GetString(GameDialogDefine.ORIGINAL_TIME, UITimeManager:GetInstance():SecondToFmtString(self.buildNextLevelTemplate.time))
    param.totalDes = Localization:GetString(GameDialogDefine.REASON_SCIENCE_SPEED_ADD)
    effectValueX, effectValueY = math.modf(buildSpeedValue)
    if effectValueY == 0 then
      param.totalValue = effectValueX .. "%"
    else
      param.totalValue = string.format("%.2f%%", buildSpeedValue)
    end
    param.cellParams = {}
    local effectValue
    effectValue = LuaEntry.Effect:GetReasonEffectValue(effectId, EffectReasonType.Science)
    if effectValue ~= nil and 0 < effectValue then
      local paramDes = {}
      paramDes.leftDes = Localization:GetString(GameDialogDefine.SCIENCE)
      effectValueX, effectValueY = math.modf(effectValue)
      if effectValueY == 0 then
        paramDes.rightDes = effectValueX .. "%"
      else
        paramDes.rightDes = effectValue .. "%"
      end
      table.insert(param.cellParams, paramDes)
    end
    effectValue = DataCenter.AllianceScienceDataManager:GetAllianceScienceEffectById(effectId)
    if effectValue ~= nil and 0 < effectValue then
      local paramDes = {}
      paramDes.leftDes = Localization:GetString(GameDialogDefine.ALLIANCE_SCIENCE)
      effectValueX, effectValueY = math.modf(effectValue)
      if effectValueY == 0 then
        paramDes.rightDes = effectValueX .. "%"
      else
        paramDes.rightDes = effectValue .. "%"
      end
      table.insert(param.cellParams, paramDes)
    end
    effectValue = LuaEntry.Effect:GetReasonEffectValue(effectId, EffectReasonType.Building)
    if effectValue ~= nil and 0 < effectValue then
      local paramDes = {}
      paramDes.leftDes = Localization:GetString(GameDialogDefine.REASON_SCIENCE_CENTER)
      effectValueX, effectValueY = math.modf(effectValue)
      if effectValueY == 0 then
        paramDes.rightDes = effectValueX .. "%"
      else
        paramDes.rightDes = effectValue .. "%"
      end
      table.insert(param.cellParams, paramDes)
    end
    effectValue = LuaEntry.Effect:GetReasonEffectValue(effectId, EffectReasonType.Hero)
    if effectValue ~= nil and 0 < effectValue then
      local paramDes = {}
      paramDes.leftDes = Localization:GetString(GameDialogDefine.REASON_HERO)
      effectValueX, effectValueY = math.modf(effectValue)
      if effectValueY == 0 then
        paramDes.rightDes = effectValueX .. "%"
      else
        paramDes.rightDes = effectValue .. "%"
      end
      table.insert(param.cellParams, paramDes)
    end
    effectValue = LuaEntry.Effect:GetReasonEffectValue(effectId, EffectReasonType.VIP)
    if effectValue ~= nil and 0 < effectValue then
      local paramDes = {}
      paramDes.leftDes = Localization:GetString(GameDialogDefine.REASON_VIP)
      effectValueX, effectValueY = math.modf(effectValue)
      if effectValueY == 0 then
        paramDes.rightDes = effectValueX .. "%"
      else
        paramDes.rightDes = effectValue .. "%"
      end
      table.insert(param.cellParams, paramDes)
    end
    effectValue = DataCenter.WorldAllianceCityDataManager:GetAllianceCityEffectById(effectId)
    if effectValue ~= nil and 0 < effectValue then
      local paramDes = {}
      paramDes.leftDes = Localization:GetString(GameDialogDefine.REASON_ALLIANCE)
      effectValueX, effectValueY = math.modf(effectValue)
      if effectValueY == 0 then
        paramDes.rightDes = effectValueX .. "%"
      else
        paramDes.rightDes = effectValue .. "%"
      end
      table.insert(param.cellParams, paramDes)
    end
    effectValue = LuaEntry.Effect:GetReasonEffectValue(effectId, EffectReasonType.Career)
    if effectValue ~= nil and 0 < effectValue then
      local paramDes = {}
      paramDes.leftDes = Localization:GetString(GameDialogDefine.PLAYER_CAREER)
      effectValueX, effectValueY = math.modf(effectValue)
      if effectValueY == 0 then
        paramDes.rightDes = effectValueX .. "%"
      else
        paramDes.rightDes = string.format("%.2f%%", effectValue)
      end
      table.insert(param.cellParams, paramDes)
    end
    effectValue = LuaEntry.Effect:GetReasonEffectValue(effectId, EffectReasonType.Alliance_Career)
    if effectValue ~= nil and 0 < effectValue then
      local paramDes = {}
      paramDes.leftDes = Localization:GetString(GameDialogDefine.ALLIANCE_CAREER)
      effectValueX, effectValueY = math.modf(effectValue)
      if effectValueY == 0 then
        paramDes.rightDes = effectValueX .. "%"
      else
        paramDes.rightDes = string.format("%.2f%%", effectValue)
      end
      table.insert(param.cellParams, paramDes)
    end
    self.show_reason:ReInit(param)
  else
    self.show_reason:SetActive(false)
  end
end

UIScienceInfoView.OnCreate = OnCreate
UIScienceInfoView.OnDestroy = OnDestroy
UIScienceInfoView.OnEnable = OnEnable
UIScienceInfoView.OnDisable = OnDisable
UIScienceInfoView.ComponentDefine = ComponentDefine
UIScienceInfoView.ComponentDestroy = ComponentDestroy
UIScienceInfoView.DataDefine = DataDefine
UIScienceInfoView.DataDestroy = DataDestroy
UIScienceInfoView.OnAddListener = OnAddListener
UIScienceInfoView.OnRemoveListener = OnRemoveListener
UIScienceInfoView.ReInit = ReInit
UIScienceInfoView.OnDeleteCell = OnDeleteCell
UIScienceInfoView.ShowCells = ShowCells
UIScienceInfoView.OnCreateCell = OnCreateCell
UIScienceInfoView.ClearScroll = ClearScroll
UIScienceInfoView.SetAllCellsDestroy = SetAllCellsDestroy
UIScienceInfoView.DetailsBtnClick = DetailsBtnClick
UIScienceInfoView.ImmediatelyBtnClick = ImmediatelyBtnClick
UIScienceInfoView.UpgradeBtnClick = UpgradeBtnClick
UIScienceInfoView.BackBtnClick = BackBtnClick
UIScienceInfoView.ShowPanel = ShowPanel
UIScienceInfoView.AddOnePreBuildCells = AddOnePreBuildCells
UIScienceInfoView.ShowBtn = ShowBtn
UIScienceInfoView.RefreshImmediatelyGold = RefreshImmediatelyGold
UIScienceInfoView.ShowNeedResource = ShowNeedResource
UIScienceInfoView.AddOneNeedResourceCells = AddOneNeedResourceCells
UIScienceInfoView.SetBtnGoActive = SetBtnGoActive
UIScienceInfoView.SetImmediatelyBtnSpendColor = SetImmediatelyBtnSpendColor
UIScienceInfoView.SetBuildIconImage = SetBuildIconImage
UIScienceInfoView.SetBuildIconImageScale = SetBuildIconImageScale
UIScienceInfoView.SetDetailsTitle = SetDetailsTitle
UIScienceInfoView.ShowDesCells = ShowDesCells
UIScienceInfoView.ShowDesCellsWithoutShow = ShowDesCellsWithoutShow
UIScienceInfoView.AddPowerDesCell = AddPowerDesCell
UIScienceInfoView.AddOneDesCells = AddOneDesCells
UIScienceInfoView.UpdateBuildDataSignal = UpdateBuildDataSignal
UIScienceInfoView.UpdateResourceSignal = UpdateResourceSignal
UIScienceInfoView.UpdateGoldSignal = UpdateGoldSignal
UIScienceInfoView.RefreshGoldColor = RefreshGoldColor
UIScienceInfoView.UpdateItemSignal = UpdateItemSignal
UIScienceInfoView.SetConditionActive = SetConditionActive
UIScienceInfoView.Update = Update
UIScienceInfoView.UpdateLeftTime = UpdateLeftTime
UIScienceInfoView.SetSliderValue = SetSliderValue
UIScienceInfoView.SetCurTimeValue = SetCurTimeValue
UIScienceInfoView.UpdateScienceSignal = UpdateScienceSignal
UIScienceInfoView.UpdateResourceItemSignal = UpdateResourceItemSignal
UIScienceInfoView.NoReasonBtnClick = NoReasonBtnClick
UIScienceInfoView.RefreshResearchingBtnName = RefreshResearchingBtnName
UIScienceInfoView.OnScienceSearchingSignal = OnScienceSearchingSignal
UIScienceInfoView.OnScienceQueueFinishSignal = OnScienceQueueFinishSignal
UIScienceInfoView.AllianceQueueHelpNewSignal = AllianceQueueHelpNewSignal
UIScienceInfoView.GetEffectNumWithType = GetEffectNumWithType
UIScienceInfoView.TryShowPreConditions = TryShowPreConditions
UIScienceInfoView.ShowPreConditions = ShowPreConditions
UIScienceInfoView.GetUnreachedPreConditions = GetUnreachedPreConditions
UIScienceInfoView.SetAllPreConditionsDestroy = SetAllPreConditionsDestroy
UIScienceInfoView.SetResBarVisible = SetResBarVisible
UIScienceInfoView.ShowReason = ShowReason
UIScienceInfoView.AddNeedResourceCells = AddNeedResourceCells
UIScienceInfoView.SetAllResCellsDestroy = SetAllResCellsDestroy
return UIScienceInfoView
