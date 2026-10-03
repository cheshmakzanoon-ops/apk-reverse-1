local UIBuildUpgradeView = BaseClass("UIBuildUpgradeView", UIBaseView)
local base = UIBaseView
local UIDetailsCell = require("UI.UIBuildUpgrade.Component.UIDetailsCell")
local UIDesCell = require("UI.UIBuildUpgrade.Component.UIDesCell")
local UIBuildDecorateInfo = require("UI.UIBuildUpgrade.Component.UIBuildDecorateInfo")
local DecorateAdvanceUpgrade = require("UI.UIBuildUpgrade.Component.UIDecorationAdvanceUpgrade")
local UIShowReason = require("UI.UIShowReason.UIShowReason")
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local Item = require("UI.UILWScience.UILWScienceDetail.Component.UILWScienceDetailItem")
local SeasonCallbackInfo = require("UI.LWSeason.LWSeasonMain.Component.SeasonCallback.SeasonCallbackInfo")
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local FirstPayExpRewardComponent = require("UI.UIFirstPay.Component.FirstPayExpRewardComponent")
local panel_path = "UICommonPopUpTitle/panel"
local title_text_path = "MiddleBg/BuildInfo/TopGroup/Common_img_title/titleText"
local animator_path = "MiddleBg"
local cur_level_path = "MiddleBg/BuildInfo/TopGroup/CurLevelText"
local next_level_path = "MiddleBg/BuildInfo/TopGroup/CurLevelText/Common_btn_arrow/NextLevelText"
local next_level_arrow_path = "MiddleBg/BuildInfo/TopGroup/CurLevelText/Common_btn_arrow"
local arabic_cur_level_path = "MiddleBg/BuildInfo/TopGroup/CurLevelText_Arabic"
local arabic_next_level_path = "MiddleBg/BuildInfo/TopGroup/CurLevelText_Arabic/Common_btn_arrow_Arabic/NextLevelText_Arabic"
local arabic_next_arrow_path = "MiddleBg/BuildInfo/TopGroup/CurLevelText_Arabic/Common_btn_arrow_Arabic"
local UISeasonCallbackInfoPath = "MiddleBg/DecorateInfo/UISeasonCallbackInfo"
local des_content_path = "MiddleBg/BuildInfo/Scroll View/Viewport/Common_bg1"
local layout_path = "MiddleBg/BuildInfo/layout"
local immediately_btn_path = "MiddleBg/BuildInfo/layout/Common_btn_yellow_big"
local immediately_btn_name_path = "MiddleBg/BuildInfo/layout/Common_btn_yellow_big/ImmediatelyBtn/ImmediatelyBtnName"
local immediately_btn_spend_icon_path = "MiddleBg/BuildInfo/layout/Common_btn_yellow_big/ImmediatelyBtn/CostLayout/ImmediatelyIcon"
local immediately_btn_spend_count_path = "MiddleBg/BuildInfo/layout/Common_btn_yellow_big/ImmediatelyBtn/CostLayout/ImmediatelyValue"
local free_rect_path = "MiddleBg/BuildInfo/layout/Common_btn_yellow_big/Rect_Free"
local upgrade_btn_path = "MiddleBg/BuildInfo/layout/Common_btn_green_big"
local upgrade_btn_name_path = "MiddleBg/BuildInfo/layout/Common_btn_green_big/UpgradeBtn/Upgrade"
local upgrade_btn_time_path = "MiddleBg/BuildInfo/layout/Common_btn_green_big/UpgradeBtn/TimeLayout/Time"
local back_btn_path = "MiddleBg/BuildDetails/BackBtn"
local detail_title_cell_path = "MiddleBg/BuildDetails/DetailTitleCell"
local scroll_view_path = "MiddleBg/BuildDetails/Scroll View"
local MoreText_path = "MiddleBg/BuildDetails/MoreText"
local common_bg_orange_path = "UICommonPopUpTitle/Common_bg_orange"
local close_btn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local middle_go_path = "MiddleBg/BuildDetails"
local select_details_cell_path = "MiddleBg/BuildDetails/Common_img_select"
local build_icon_path = "MiddleBg/BuildInfo/TopGroup/UIBuild_icon"
local btn_reward_path = "MiddleBg/BuildInfo/TopGroup/BtnReward"
local show_reason_path = "MiddleBg/BuildInfo/layout/Common_btn_green_big/UIShowReason"
local gain_hero_exp_content_path = "MiddleBg/BuildInfo/TopGroup/GainHeroExpContent"
local gain_hero_exp_number_text_path = "MiddleBg/BuildInfo/TopGroup/GainHeroExpContent/GainerHeroExpNumberText"
local top_group_path = "MiddleBg/BuildInfo/TopGroup"
local gain_exp_content_path = "MiddleBg/BuildInfo/TopGroup/GainExpContent"
local gainer_exp_number_text_path = "MiddleBg/BuildInfo/TopGroup/GainExpContent/GainerExpNumberText"
local gain_exp_text_path = "MiddleBg/BuildInfo/TopGroup/GainExpContent/GainExpText"
local original_time_text_path = "MiddleBg/BuildInfo/layout/Common_btn_green_big/OriginalTimeText"
local season_info_btn_path = "MiddleBg/BuildInfo/TopGroup/SeasonInfo"
local season_info_icon_path = "MiddleBg/BuildInfo/TopGroup/SeasonInfo/SeasonIcon"
local season_info_time_path = "MiddleBg/BuildInfo/TopGroup/SeasonInfo/TimeInfoItem"
local season_info_time_text_path = "MiddleBg/BuildInfo/TopGroup/SeasonInfo/TimeInfoItem/timeBg2/TimeText"
local upgrade_info_group_path = "MiddleBg/BuildInfo/UpgradeInfoGroup"
local cost_res_text_path = "MiddleBg/BuildInfo/UpgradeInfoGroup/ConsumeRes/CostResText"
local content_path = "MiddleBg/BuildInfo/UpgradeInfoGroup/ConsumeRes/Scroll/Viewport/Content"
local upgrade_item_path = "MiddleBg/BuildInfo/UpgradeInfoGroup/ConsumeRes/Scroll/Viewport/UpgradeItem"
local upgrade_info_group_path_B = "MiddleBg/BuildInfo/UpgradeInfoGroup_B"
local cost_res_text_path_B = "MiddleBg/BuildInfo/UpgradeInfoGroup_B/ConsumeRes/CostResText"
local content_path_B = "MiddleBg/BuildInfo/UpgradeInfoGroup_B/ConsumeRes/Scroll/Viewport/Content"
local upgrade_item_path_B = "MiddleBg/BuildInfo/UpgradeInfoGroup_B/ConsumeRes/Scroll/Viewport/UpgradeItem"
local build_status_path = "MiddleBg/BuildInfo/TopGroup/BuildStatus"
local max_level_path = "MiddleBg/BuildInfo/MaxLevel"
local info_btn_path = "MiddleBg/BuildInfo/TopGroup/InfoBtn"
local middle_bg_path = "MiddleBg"
local build_info_path = "MiddleBg/BuildInfo"
local Advance_Deco_Upgrade_Prefab_Path = "Assets/Main/Prefabs/UI/UIBuildUpgrade/DecorationAdvanceUpgrade.prefab"
local imgRecommandPath = "MiddleBg/BuildInfo/layout/Common_btn_green_big/imaRecommand"
local imaRecommandDiamondPath = "MiddleBg/BuildInfo/layout/Common_btn_yellow_big/imaRecommandDiamond"
local first_pay_exp_reward_path = "MiddleBg/BuildInfo/TopGroup/FirstPayExpReward"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitBtn()
  DataCenter.LWSoundManager:PlaySound(62262, false)
end

local function OnDestroy(self)
  self:SetAllCellsDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  local data = self:GetUserData()
  self:RefreshView(data)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.common_bg_orange = self:AddComponent(UIButton, common_bg_orange_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.cur_level = self:AddComponent(UIText, cur_level_path)
  self.next_level = self:AddComponent(UIText, next_level_path)
  self.des_content = self:AddComponent(UIBaseContainer, des_content_path)
  self.arabic_cur_level = self:AddComponent(UIText, arabic_cur_level_path)
  self.arabic_next_level = self:AddComponent(UIText, arabic_next_level_path)
  self.cur_level:SetActive(not CommonUtil.IsArabic() or CommonUtil.IsArabicAutoMirrorOpen())
  self.arabic_cur_level:SetActive(CommonUtil.IsArabic() and not CommonUtil.IsArabicAutoMirrorOpen())
  self.layout_btn = self:AddComponent(UIBaseContainer, layout_path)
  self.immediately_btn = self:AddComponent(UIButton, immediately_btn_path)
  self.immediately_btn_name = self:AddComponent(UIText, immediately_btn_name_path)
  self.immediately_btn_spend_icon = self:AddComponent(UIImage, immediately_btn_spend_icon_path)
  self.immediately_btn_spend_count = self:AddComponent(UIText, immediately_btn_spend_count_path)
  self.immediately_btn_spend_count_shadow = self:AddComponent(UIShadow, immediately_btn_spend_count_path)
  self._free_rect = self:AddComponent(UIBaseContainer, free_rect_path)
  self.upgrade_btn = self:AddComponent(UIButton, upgrade_btn_path)
  self.upgrade_btn_name = self:AddComponent(UIText, upgrade_btn_name_path)
  self.upgrade_btn_time = self:AddComponent(UIText, upgrade_btn_time_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.detail_title_cell = self:AddComponent(UIDetailsCell, detail_title_cell_path)
  self.middle_go = self:AddComponent(UIBaseContainer, middle_go_path)
  self.top_group = self:AddComponent(UIBaseContainer, top_group_path)
  self.next_level_arrow = self:AddComponent(UIBaseContainer, next_level_arrow_path)
  self.arabic_next_level_arrow = self:AddComponent(UIBaseContainer, arabic_next_arrow_path)
  self.select_details_cell = self:AddComponent(UIBaseContainer, select_details_cell_path)
  self.build_icon = self:AddComponent(UIImage, build_icon_path)
  self.upgradeReward_btn = self:AddComponent(UIButton, btn_reward_path)
  self.upgradeReward_btn:SetOnClick(function()
    self:OnUpgradeRewardBtnClick()
  end)
  self.show_reason = self:AddComponent(UIShowReason, show_reason_path)
  self.MoreText = self:AddComponent(UIText, MoreText_path)
  self.decorateCloseBtn = self:AddComponent(UIButton, "MiddleBg/DecorateInfo/decorateCloseBtn")
  self.decorateCloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.decorateInfo = self:AddComponent(UIBuildDecorateInfo, "MiddleBg/DecorateInfo")
  self.buildInfo = self:AddComponent(UIBaseContainer, "MiddleBg/BuildInfo")
  self.MoreText:SetActive(false)
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
  self.immediately_btn:SetSafeClickMode(true)
  self.immediately_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local t = CommonUtil.PlayerPrefsGetInt("buildUpgradeTime", 0)
    if self.recommanded or self:NotRecommendedButDontNeedConfirm() or t ~= 0 and UITimeManager:GetInstance():GetServerTime() / 1000 - t < 86400 then
      self:ImmediatelyBtnClick()
    else
      PostEventLog.Track(PostEventLog.Defines.RecommendTipOpen)
      UIUtil.ShowSecondMessage(Localization:GetString("2900005"), Localization:GetString("newbies_building_suggest_desc1"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:ImmediatelyBtnClick()
        PostEventLog.Track(PostEventLog.Defines.RecommendTipContinue)
      end, function(isNotOn)
        local intt = isNotOn and 0 or toInt(UITimeManager:GetInstance():GetServerTime() / 1000)
        CommonUtil.PlayerPrefsSetInt("buildUpgradeTime", intt)
      end, function()
        PostEventLog.Track(PostEventLog.Defines.RecommendTipCancel)
      end, function()
        PostEventLog.Track(PostEventLog.Defines.RecommendTipClose)
      end, nil, Localization:GetString(GameDialogDefine.TODAY_NO_SHOW), nil, nil, nil)
    end
  end)
  self.upgrade_btn:SetOnClick(function()
    local t = CommonUtil.PlayerPrefsGetInt("buildUpgradeTime", 0)
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.recommanded or self:NotRecommendedButDontNeedConfirm() or t ~= 0 and UITimeManager:GetInstance():GetServerTime() / 1000 - t < 86400 then
      self:UpgradeBtnClick()
    else
      PostEventLog.Track(PostEventLog.Defines.RecommendTipOpen)
      UIUtil.ShowSecondMessage(Localization:GetString("2900005"), Localization:GetString("newbies_building_suggest_desc1"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:UpgradeBtnClick()
        PostEventLog.Track(PostEventLog.Defines.RecommendTipContinue)
      end, function(isNotOn)
        local intt = isNotOn and 0 or toInt(UITimeManager:GetInstance():GetServerTime() / 1000)
        CommonUtil.PlayerPrefsSetInt("buildUpgradeTime", intt)
      end, function()
        PostEventLog.Track(PostEventLog.Defines.RecommendTipCancel)
      end, function()
        PostEventLog.Track(PostEventLog.Defines.RecommendTipClose)
      end, nil, Localization:GetString(GameDialogDefine.TODAY_NO_SHOW), nil, nil, nil)
    end
  end)
  self.back_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Close, false)
    self:BackBtnClick()
  end)
  self.gainExpText = self:AddComponent(UIBaseComponent, gain_hero_exp_content_path)
  self.gainExpNumberText = self:AddComponent(UIText, gain_hero_exp_number_text_path)
  self.gain_exp_content = self:AddComponent(UIBaseContainer, gain_exp_content_path)
  self.gainer_exp_number_text = self:AddComponent(UITextMeshProUGUIEx, gainer_exp_number_text_path)
  self.gain_exp_text = self:AddComponent(UITextMeshProUGUIEx, gain_exp_text_path)
  self.build_status = self:AddComponent(UITextMeshProUGUIEx, build_status_path)
  self.original_time_text = self:AddComponent(UITextMeshProUGUIEx, original_time_text_path)
  self.build_status:SetActive(false)
  local needHide = self:AddComponent(UIBaseContainer, upgrade_info_group_path_B)
  needHide.gameObject:SetActive(false)
  self.upgrade_info_group = self:AddComponent(UIBaseContainer, upgrade_info_group_path)
  self.cost_res_text = self:AddComponent(UITextMeshProUGUIEx, cost_res_text_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.upgrade_item = self.transform:Find(upgrade_item_path).gameObject
  self.upgrade_item:GameObjectCreatePool()
  self.max_level_txt = self:AddComponent(UITextMeshProUGUIEx, max_level_path)
  self.max_level_txt:SetLocalText(GameDialogDefine.REACH_MAX_LEVEL)
  self.max_level_txt:SetActive(false)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    if self.buildTemplate then
      UIUtil.ShowDetail(Localization:GetString(self.buildTemplate.detail_desc), "")
    end
  end)
  self.build_info_root = self:AddComponent(UICanvasGroup, build_info_path)
  self.seasonCallbackInfo = self:AddComponent(SeasonCallbackInfo, UISeasonCallbackInfoPath)
  self.middleBg = self:AddComponent(UIBaseContainer, middle_bg_path)
  self.imgRecommand = self:AddComponent(UIImage, imgRecommandPath)
  self.imaRecommandDiamond = self:AddComponent(UIImage, imaRecommandDiamondPath)
  self.season_info_btn = self:AddComponent(UIButton, season_info_btn_path)
  self.season_info_btn:SetOnClick(function()
    self:ShowSeasonBuildingTips()
  end)
  self.season_info_icon = self:AddComponent(UIImage, season_info_icon_path)
  self.season_info_time = self:AddComponent(UIBaseContainer, season_info_time_path)
  self.season_info_time_text = self:AddComponent(UIText, season_info_time_text_path)
  self.btnLeftShortcutKey = self:AddComponent(UIButton, "ShortcutKeyRoot/LeftShortcutKey")
  self.btnLeftShortcutKey:SetOnClick(function()
    if self.OnBtnLeftShortcutKeyClick then
      self:OnBtnLeftShortcutKeyClick()
    end
  end)
  self.btnRightShortcutKey = self:AddComponent(UIButton, "ShortcutKeyRoot/RightShortcutKey")
  self.btnRightShortcutKey:SetOnClick(function()
    if self.OnBtnRightShortcutKeyClick then
      self:OnBtnRightShortcutKeyClick()
    end
  end)
  self.compShortcutKeyRoot = self:AddComponent(UIBaseContainer, "ShortcutKeyRoot")
  self.compLeftShortcutKeyRedPoint = self:AddComponent(UIBaseComponent, "ShortcutKeyRoot/LeftShortcutKey/LeftShortcutKeyRedPoint")
  self.compRightShortcutKeyRedPoint = self:AddComponent(UIBaseComponent, "ShortcutKeyRoot/RightShortcutKey/RightShortcutKeyRedPoint")
  self.firstPayExpCpt = self:AddComponent(FirstPayExpRewardComponent, first_pay_exp_reward_path)
end

function UIBuildUpgradeView:NotRecommendedButDontNeedConfirm()
  if self.recommanded then
    return true
  end
  if not self:CheckEnabled() then
    return
  end
  local lv = DataCenter.BuildManager.MainLv
  local mainBuildData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.FUN_BUILD_MAIN)[1]
  if mainBuildData:IsUpgradeFinish() or mainBuildData:IsUpgrading() then
    lv = lv + 1
  end
  local mainBuidingTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_MAIN, lv)
  local mainNeedItem = mainBuidingTemplate:GetNeedResource()
  local myBuildTemp = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildData.itemId, self.buildData.level)
  local myNeedItem = myBuildTemp:GetNeedResource()
  for _, v in pairs(mainNeedItem) do
    for _, vv in pairs(myNeedItem) do
      if vv.resourceType == v.resourceType and vv.count > v.count * 0.2 then
        return false
      end
    end
  end
  return true
end

local function ComponentDestroy(self)
  self.btn = nil
  self.close_btn = nil
  self.title_text = nil
  self.animator = nil
  self.cur_level = nil
  self.next_level = nil
  self.des_content = nil
  self.cost_res_text = nil
  self.immediately_btn = nil
  self.immediately_btn_name = nil
  self.immediately_btn_spend_icon = nil
  self.immediately_btn_spend_count = nil
  self.immediately_btn_spend_count_shadow = nil
  self.layout_btn = nil
  self.upgrade_btn = nil
  self.upgrade_btn_name = nil
  self.upgrade_btn_time = nil
  self.back_btn = nil
  self.next_level_arrow = nil
  self.detail_title_cell = nil
  self.buildInfo = nil
  self.top_group = nil
  self.common_bg_orange = nil
  if not IsNull(self.select_details_cell) and not IsNull(self.middle_go) then
    self.select_details_cell.transform:SetParent(self.middle_go.transform)
  end
  self.middle_go = nil
  self.select_details_cell = nil
  self.scroll_view = nil
  self.build_icon = nil
  self.show_reason = nil
  self.MoreText = nil
  self.gainExpText = nil
  self.gainExpNumberText = nil
  self.gain_exp_content = nil
  self.gainer_exp_number_text = nil
  self.gain_exp_text = nil
  self.original_time_text = nil
  self.upgrade_info_group = nil
  self.cost_res_text = nil
  self.content = nil
  self.upgrade_item = nil
  self.middleBg = nil
  self.build_info_root = nil
  if self.advDecoLoadReq then
    self:GameObjectDestroy(self.advDecoLoadReq)
    self.advDecoLoadReq = nil
  end
  self.btnLeftShortcutKey = nil
  self.btnRightShortcutKey = nil
  self.compShortcutKeyRoot = nil
  self.compLeftShortcutKeyRedPoint = nil
  self.compRightShortcutKeyRedPoint = nil
end

local function DataDefine(self)
  self.initCell = nil
  self.buildUuid = nil
  self.buildData = nil
  self.buildTemplate = nil
  self.buildCurLevelTemplate = nil
  self.buildNextLevelTemplate = nil
  self.preBuildCells = {}
  self.needResourceCells = {}
  self.lackResource = {}
  self.lackItem = {}
  self.lackResItem = {}
  self.needPre = nil
  self.desCells = {}
  self.spendGold = 0
  self.hasItem = nil
  self.hasResItem = nil
  self.buildId = nil
  self.level = nil
  self.nextLevel = nil
  self.arrowLackResourceType = nil
  self.noBuyItemId = nil
  self.noBuyResItemId = nil
  self.isFree = false
  self.showBtnTime = nil
  self.hasClose = false
  self.stockInfoList = {}
  self.desCellIndex = 1
  self.btnCells = {}
  self.isUpgradeInfoShow = nil
  self.freeBuildingUpNewMsgLock = false
  self.isShowShortCutKey = false
end

local function DataDestroy(self)
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if self.delay ~= nil then
    self.delay:Stop()
    self.delay = nil
  end
  self:ClearAllDelayTimers()
  DataCenter.ArrowManager:RemoveArrow()
  EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, UIWindowNames.UIBuildUpgrade)
  self.initCell = nil
  self.buildUuid = nil
  self.buildData = nil
  self.buildTemplate = nil
  self.buildCurLevelTemplate = nil
  self.buildNextLevelTemplate = nil
  self.preBuildCells = {}
  self.needResourceCells = {}
  self.lackResource = nil
  self.lackItem = nil
  self.lackResItem = nil
  self.needPre = nil
  self.desCells = {}
  self.spendGold = nil
  self.hasItem = nil
  self.hasResItem = nil
  self.buildId = nil
  self.level = nil
  self.nextLevel = nil
  self.arrowLackResourceType = nil
  self.noBuyItemId = nil
  self.noBuyResItemId = nil
  self.isFree = nil
  self.hasClose = false
  self.stockInfoList = {}
  self.desCellIndex = 1
  self.btnCells = nil
  self.isUpgradeInfoShow = nil
  self.freeBuildingUpNewMsgLock = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.UpdateItemSignal)
  self:AddUIListener(EventId.RefreshResourceItem, self.UpdateResItemSignal)
  self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
  self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
  self:AddUIListener(EventId.SoldResourceItem, self.UpdateResItemSignal)
  self:AddUIListener(EventId.UnLockFreeBuildingUpNewMsg, self.UnLockFreeBuildingUpNewMsg)
  self:AddUIListener(EventId.BuildLevelUp, self.OnBuildingLevelUp)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.UpdateItemSignal)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.UpdateResItemSignal)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
  self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
  self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:RemoveUIListener(EventId.SoldResourceItem, self.UpdateResItemSignal)
  self:RemoveUIListener(EventId.UnLockFreeBuildingUpNewMsg, self.UnLockFreeBuildingUpNewMsg)
  self:RemoveUIListener(EventId.BuildLevelUp, self.OnBuildingLevelUp)
end

function UIBuildUpgradeView:RefreshView(data)
  if type(data) == "number" then
    self:ReInit(data)
  elseif type(data) == "string" then
    self:ReInit(data)
  elseif type(data) == "table" then
    self.isShowShortCutKey = data.isShowShortCutKey or false
    self.shortCutKey_baseBuildingIdList = data.baseBuildingIdList or {}
    self.shortCutKey_curIndex = data.curIndex or 0
    if data.hasBuilding then
      self:ReInit(data.buildUuid)
    elseif data.type == Building_Upgrade_Type.DecorationBook then
      self:ReInitDecoration(data)
    end
  end
end

function UIBuildUpgradeView:RefreshViewByShortcutKey(data)
  self:SetAllCellsDestroy()
  self:DataDestroy()
  self:DataDefine()
  self:RefreshView(data)
  self:InitBtn()
end

local function ReInit(self, buildUuid, targetId, isTaskGuid)
  self.buildUuid = tonumber(buildUuid)
  if self.buildUuid == nil then
    Logger.LogError("input param : buildUuid is nil")
  end
  self.targetId = targetId
  self.hasClose = false
  self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
  if self.buildData ~= nil then
    self.buildId = self.buildData.itemId
    self.buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildId)
    if self.buildTemplate.tab_type == UIBuildListTabType.Decorate then
      self:ReInitDecoration(self.buildData)
    else
      self:SetBuildInfoActive(true)
      self.decorateInfo:SetActive(false)
      if self.advDecorateInfo then
        self.advDecorateInfo:SetActive(false)
      end
      self.cost_res_text:SetLocalText(GameDialogDefine.NEED)
      self:SetDetailsTitle()
      self:ShowPanel()
      self.compShortcutKeyRoot:SetActive(false)
    end
    self.info_btn:SetActive(not string.IsNullOrEmpty(self.buildTemplate.detail_desc))
    self:RefreshSeasonInfo()
  else
    self.info_btn:SetActive(false)
  end
end

local function ReInitDecoration(self, decorationBuildData)
  self:SetBuildInfoActive(false)
  self:CheckShowNormalOrAdvanceDecUpgradePanel(decorationBuildData)
end

local function CheckShowNormalOrAdvanceDecUpgradePanel(self, decorationBuildData)
  if decorationBuildData.type == Building_Upgrade_Type.DecorationBook then
    self:ShowNormalDecoUpgradePanel(decorationBuildData)
    return
  end
  local id = decorationBuildData.itemId
  local level = decorationBuildData.level
  local buildingLvData = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(id, level)
  if not buildingLvData or not self.buildTemplate then
    self:ShowNormalDecoUpgradePanel(decorationBuildData)
    return
  end
  local upgradeType = buildingLvData.decorationUpgradeType
  local isCurBuildingMaxLevel = level >= self.buildTemplate.max_level
  if isCurBuildingMaxLevel then
    local prevLv = level - 1
    local prevBuildingData = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(id, prevLv)
    if prevBuildingData and prevBuildingData.decorationUpgradeType then
      upgradeType = prevBuildingData.decorationUpgradeType
    end
  end
  if upgradeType == DecorationUpgradeType.AdvanceUpgrade then
    self.compShortcutKeyRoot:SetActive(false)
    self:ShowAdvanceUpgradeDecoUpgradePanel(decorationBuildData)
  else
    self.compShortcutKeyRoot:SetActive(self.isShowShortCutKey)
    self:ShowNormalDecoUpgradePanel(decorationBuildData)
  end
end

local function ShowNormalDecoUpgradePanel(self, decorationBuildData)
  if self.advDecorateInfo then
    self.advDecorateInfo:SetActive(false)
  end
  self.decorateInfo:SetActive(true)
  self.decorateInfo:ReInit(decorationBuildData)
  if self.seasonCallbackInfo then
    self.seasonCallbackInfo:TrySetItemById(SeasonCallbackType.Decoration, decorationBuildData.itemId)
  end
end

local function ShowAdvanceUpgradeDecoUpgradePanel(self, decorationBuildData)
  if self.advDecoLoadReq and not self.advDecoLoadReq.isDone then
    self:GameObjectDestroy(self.advDecoLoadReq)
    self.advDecoLoadReq = nil
  end
  self.decorateInfo:SetActive(false)
  if not self.advDecorateInfo then
    self.advDecoLoadReq = self:GameObjectInstantiateAsync(Advance_Deco_Upgrade_Prefab_Path, function(request)
      if IsNull(request.gameObject) then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.middleBg.transform)
      go.transform.localScale = Vector3.New(1, 1, 1)
      go.transform:Set_localPosition(0, 0, 0)
      local name = go.transform.name
      self.advDecorateInfo = self:AddComponent(DecorateAdvanceUpgrade, string.format("%s/%s", middle_bg_path, name))
      self.advDecorateInfo:SetActive(true)
      decorationBuildData.baseBuildingIdList = self.shortCutKey_baseBuildingIdList
      decorationBuildData.curIndex = self.shortCutKey_curIndex
      decorationBuildData.isShowShortCutKey = self.isShowShortCutKey
      self.advDecorateInfo:ReInit(decorationBuildData, function()
        self.ctrl:CloseSelf()
      end)
    end)
  else
    decorationBuildData.baseBuildingIdList = self.shortCutKey_baseBuildingIdList
    decorationBuildData.curIndex = self.shortCutKey_curIndex
    decorationBuildData.isShowShortCutKey = self.isShowShortCutKey
    self.advDecorateInfo:SetActive(true)
    self.advDecorateInfo:ReInit(decorationBuildData)
  end
end

local function SetBuildInfoActive(self, active)
  self.isUpgradeInfoShow = active
  self.build_icon:SetActive(active)
  self.common_bg_orange:SetActive(active)
  self.buildInfo:SetActive(active)
  self.top_group:SetActive(active)
  self.layout_btn:SetActive(active)
end

local function InitBtn(self)
  self.immediately_btn_name:SetLocalText(GameDialogDefine.IMMEDIATELY_UPGRADE)
  self.immediately_btn_spend_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
end

local function SetDetailsTitle(self)
  local count = table.count(self.buildTemplate.effect_Local_dialog)
  local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k1")
  if showPower <= DataCenter.BuildManager.MainLv then
    count = 1 + count
  end
  if 0 < count then
    local param = UIDetailsCell.Param.New()
    param.names = {}
    param.names[1] = Localization:GetString(GameDialogDefine.LEVEL)
    for k, v in ipairs(self.buildTemplate.effect_Local_dialog) do
      param.names[k + 1] = Localization:GetString(v)
    end
    if showPower <= DataCenter.BuildManager.MainLv then
      param.names[#param.names + 1] = Localization:GetString(GameDialogDefine.POWER)
    end
    self.detail_title_cell:ReInit(param)
  end
end

local function ShowPanel(self)
  if self.buildData ~= nil then
    self.level = self.buildData.level
    self.nextLevel = self.level + 1
    self.buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildId, self.level)
    local isCurBuildingMaxLevel = BuildingUtils.IsBuildMaxLevel(self.buildTemplate, self.buildCurLevelTemplate)
    if not isCurBuildingMaxLevel then
      self.buildNextLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildId, self.nextLevel)
      self:RefreshContent()
    else
      self.buildNextLevelTemplate = nil
      if SeasonUtil.IsSeasonPlayerBuilding(self.buildId) or isCurBuildingMaxLevel then
        self:RefreshContent(true)
      else
        self.ctrl:CloseSelf()
        return
      end
    end
  end
  self.build_status:SetActive(false)
  if self.buildCurLevelTemplate ~= nil then
    self.build_icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.buildId, self.level))
    local items = self.buildCurLevelTemplate:GetNeedItem()
    local resources = self.buildCurLevelTemplate:GetNeedResource()
    local resourceItems = self.buildCurLevelTemplate:GetNeedResourceItem()
    if resources ~= nil or items ~= nil or resourceItems ~= nil then
      local signal = {}
      if resources then
        for k, v in ipairs(resources) do
          table.insert(signal, v.resourceType)
        end
      end
      local itemSignal = {}
      if items then
        for k, v in ipairs(items) do
          table.insert(itemSignal, v.itemId)
        end
      end
      local resourceItemSignal = {}
      if resourceItems then
        for k, v in ipairs(resourceItems) do
          table.insert(resourceItemSignal, v.itemId)
        end
      end
      local param = {}
      param.list = signal
      param.uiName = UIWindowNames.UIBuildUpgrade
      param.itemList = itemSignal
      param.resourceItemList = resourceItemSignal
      EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
    end
    local gainExpShown = false
    local gainExp = self.buildCurLevelTemplate.hero_exp_show
    local isCurBuildingMaxLevel = BuildingUtils.IsBuildMaxLevel(self.buildTemplate, self.buildCurLevelTemplate)
    if gainExp ~= 0 and not isCurBuildingMaxLevel then
      self.gainExpText:SetActive(true)
      self.gainExpNumberText:SetText(string.GetFormattedStr(gainExp))
      gainExpShown = true
      self.firstPayExpCpt:SetActive(true)
      self:RefreshFirstPayExpInfo(gainExp)
    else
      self.gainExpText:SetActive(false)
      self.firstPayExpCpt:SetActive(false)
    end
    local season_mastery_exp = 0
    if self.buildNextLevelTemplate ~= nil then
      season_mastery_exp = self.buildNextLevelTemplate.season_mastery_exp_show
    end
    if season_mastery_exp ~= 0 and not isCurBuildingMaxLevel then
      self.gain_exp_content:SetActive(true)
      self.gain_exp_text:SetActive(true)
      self.gainer_exp_number_text:SetText(string.GetFormattedStr(season_mastery_exp))
      if gainExpShown then
        self.gainExpText:SetLocalPositionXYZ(140, -240, 0)
        self.gain_exp_content:SetLocalPositionXYZ(140, -283, 0)
      else
        self.gain_exp_content:SetLocalPositionXYZ(140, -261, 0)
      end
    else
      local buildId = self.buildId
      local seasonType = SeasonUtil.GetSeasonType()
      if seasonType == SeasonMapType.Darkness and (buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION2 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION3 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION4) then
        local mgr = DataCenter.SeasonPowerWorkerManager
        local powerWorkerDict = mgr.powerWorkerDict
        local powerWorkerCount = table.count(powerWorkerDict)
        self.gain_exp_content:SetActive(false)
        self.build_status:SetActive(true)
        self.build_status:SetText("<color=#F97077>" .. Localization:GetString("season_s4_building_ui_info35") .. "</color>")
        if 0 < powerWorkerCount then
          for k, v in pairs(powerWorkerDict) do
            if v and v.buildUuid == self.buildUuid then
              self.build_status:SetText("<color=#5fef87>" .. Localization:GetString("season_s4_building_ui_info36") .. "</color>")
              break
            end
          end
        end
        if gainExpShown then
          self.gainExpText:SetLocalPositionXYZ(140, -240, 0)
          self.gain_exp_content:SetLocalPositionXYZ(140, -283, 0)
        else
          self.gain_exp_content:SetLocalPositionXYZ(140, -261, 0)
        end
        if self.powerEffectNode == nil then
          local worker = mgr:GetPowerWorkerByBuild(buildId, self.buildUuid)
          local formation = mgr:GetFormationByBuild(buildId, self.buildUuid)
          if formation ~= nil or worker ~= nil then
            local eff_path = "Assets/Main/SeasonRes/S4/Prefabs/Effect/VX/Eff_S4_dianji_BuildUpgrade.prefab"
            self.powerEffectNode = UIAsyncNode.New("eff_light", self.build_icon.transform, eff_path)
          end
        end
      else
        self.gain_exp_content:SetActive(false)
        if gainExpShown then
          self.gainExpText:SetLocalPositionXYZ(140, -261, 0)
        end
      end
    end
  end
  if self.buildCurLevelTemplate ~= nil and self.buildNextLevelTemplate ~= nil then
    local curShowLv = self.buildCurLevelTemplate:GetShowLevel()
    local nextShowLv = self.buildNextLevelTemplate:GetShowLevel()
    local buildName = Localization:GetString(self.buildCurLevelTemplate.name)
    if GMUtils.GetBool(GMConst.DebugDisplayGameID, false) then
      buildName = string.format("%s[%s]", buildName, self.buildCurLevelTemplate.id)
    end
    self.title_text:SetText(buildName)
    if curShowLv < nextShowLv then
      if not CommonUtil.IsArabic() or CommonUtil.IsArabicAutoMirrorOpen() then
        self.cur_level:SetLocalText(GameDialogDefine.LEVEL_NUMBER, curShowLv)
        self.next_level:SetText(nextShowLv)
        self.next_level_arrow:SetActive(true)
      else
        self.arabic_cur_level:SetLocalText(GameDialogDefine.LEVEL_NUMBER, curShowLv)
        self.arabic_next_level:SetText(nextShowLv)
        self.arabic_next_level_arrow:SetActive(true)
      end
    else
      local nextBuildName = Localization:GetString(self.buildNextLevelTemplate.name)
      if not CommonUtil.IsArabic() or CommonUtil.IsArabicAutoMirrorOpen() then
        self.cur_level:SetLocalText(140401, nextBuildName)
        self.next_level_arrow:SetActive(false)
      else
        self.arabic_cur_level:SetLocalText(140401, nextBuildName)
        self.arabic_next_level_arrow:SetActive(false)
      end
    end
  elseif self.buildCurLevelTemplate ~= nil then
    local curShowLv = self.buildCurLevelTemplate:GetShowLevel()
    local buildName = Localization:GetString(self.buildCurLevelTemplate.name)
    if GMUtils.GetBool(GMConst.DebugDisplayGameID, false) then
      buildName = string.format("%s[%s]", buildName, self.buildCurLevelTemplate.id)
    end
    self.title_text:SetText(buildName)
    if not CommonUtil.IsArabic() or CommonUtil.IsArabicAutoMirrorOpen() then
      self.cur_level:SetLocalText(GameDialogDefine.LEVEL_NUMBER, curShowLv)
      self.next_level_arrow:SetActive(false)
    else
      self.arabic_cur_level:SetLocalText(GameDialogDefine.LEVEL_NUMBER, curShowLv)
      self.arabic_next_level_arrow:SetActive(false)
    end
  end
  local showUpgradeReward = false
  if self.buildNextLevelTemplate ~= nil and not string.IsNullOrEmpty(self.buildNextLevelTemplate.reward_show) then
    showUpgradeReward = true
  end
  self.upgradeReward_btn.gameObject:SetActive(showUpgradeReward)
  self:ShowDesCells()
end

local function RefreshContent(self, max)
  local buildId = self.buildId
  local seasonType = SeasonUtil.GetSeasonType()
  if max then
    self.upgrade_info_group:SetActive(false)
    self.max_level_txt:SetActive(true)
    self.upgrade_btn:SetActive(false)
    self.immediately_btn:SetActive(false)
    self.isUpgradeInfoShow = false
    if seasonType == SeasonMapType.Darkness and (buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION2 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION3 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION4) and self.seasonTask == nil and self.build_info_root ~= nil then
      local luaPath = "UI.UIBuildUpgrade.Component.UISeasonBuildActiveTask"
      local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Component/BuildTask.prefab"
      self.seasonTask = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.build_info_root, function(view, go, lua, callback_param)
        if lua and lua.rectTransform then
          lua:SetLocalPositionXYZ(0, -237, 0)
        end
      end)
      self.seasonTask:SetData(buildId, self.buildUuid)
    end
  else
    local showDiamond = DataCenter.BuildManager:IsShowDiamond()
    if seasonType == SeasonMapType.Darkness and self.buildData.level == 0 and (buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION2 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION3 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION4 or buildId == BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE) then
      showDiamond = false
    end
    self.upgrade_info_group:SetActive(true)
    self.max_level_txt:SetActive(false)
    self.isUpgradeInfoShow = true
    self:RefreshMid(true)
    self.immediately_btn:SetActive(showDiamond)
    self.upgrade_btn:SetActive(true)
    self:ReInitBtn()
    UIGray.SetGray(self.immediately_btn.transform, self.needPre, not self.needPre)
    UIGray.SetGray(self.upgrade_btn.transform, self.needPre, not self.needPre)
    self:CheckStudyNowBtnGrayState()
    self:CheckTaskStatus()
  end
end

function UIBuildUpgradeView:CheckTaskStatus()
  local buildLevelTemplate = self.buildCurLevelTemplate
  if buildLevelTemplate == nil then
    return
  end
  if self.taskInfo ~= nil and self.taskInfo.state == TaskState.Received then
    if self.buildTaskDetail ~= nil then
      self.buildTaskDetail:SetActive(false)
    end
    return
  end
  local buildData = self.buildData
  local taskInfo = DataCenter.TaskManager:FindTaskInfo(buildLevelTemplate.quest_condition)
  self.taskInfo = taskInfo
  if taskInfo == nil then
    if string.IsNullOrEmpty(buildLevelTemplate.quest_condition) then
      return
    end
    local need_task = tostring(buildLevelTemplate.quest_condition)
    local task_id_vec = string.split_ss_array(buildData.completeTask or "", ",")
    for _, taskId in ipairs(task_id_vec) do
      if need_task == taskId then
        return
      end
    end
    local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(need_task)
    if questTemplate == nil then
      return nil
    end
    if self.buildTaskDetail == nil and self.build_info_root ~= nil then
      local luaPath = "UI.UIBuildUpgrade.Component.UIBuildTaskDetail"
      local prefabPath = "Assets/Main/Prefabs/UI/UIBuildUpgrade/Component/BuildTaskDetail.prefab"
      self.buildTaskDetail = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.build_info_root, function(view, go, lua, callback_param)
        if lua and lua.rectTransform then
          lua:SetLocalPositionXYZ(0, -237, 0)
        end
      end)
      self.buildTaskDetail:SetActive(true)
      self.buildTaskDetail:SetData(self.buildId, self.buildUuid, nil, questTemplate)
    end
  elseif taskInfo ~= nil and taskInfo.state ~= TaskState.Received and self.buildTaskDetail == nil and self.build_info_root ~= nil then
    local luaPath = "UI.UIBuildUpgrade.Component.UIBuildTaskDetail"
    local prefabPath = "Assets/Main/Prefabs/UI/UIBuildUpgrade/Component/BuildTaskDetail.prefab"
    self.buildTaskDetail = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.build_info_root, function(view, go, lua, callback_param)
      if lua and lua.rectTransform then
        lua:SetLocalPositionXYZ(0, -237, 0)
      end
    end)
    self.buildTaskDetail:SetActive(true)
    self.buildTaskDetail:SetData(self.buildId, self.buildUuid, taskInfo)
  end
end

local function RefreshMid(self, needRefresh)
  self:ClearContent()
  self.upgrade_item.gameObject:GameObjectRecycleAll()
  local list = self:GetAllNeed(needRefresh)
  local redList = {}
  local notRedList = {}
  for _, item in ipairs(list) do
    if item.isRed then
      table.insert(redList, item)
    else
      table.insert(notRedList, item)
    end
  end
  for _, item in ipairs(notRedList) do
    table.insert(redList, item)
  end
  if redList then
    for k, v in ipairs(redList) do
      local item = self.upgrade_item:GameObjectSpawn(self.content.transform)
      item.name = "item" .. k
      local cell = self.content:AddComponent(Item, item.name)
      cell:SetData(v)
      self.btnCells[v] = cell
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

function UIBuildUpgradeView:CheckEnabled()
  local lv = DataCenter.BuildManager.MainLv
  if lv < 10 then
    return
  end
  if 30 <= lv then
    return
  end
  if lv == 29 then
    local mainBuildData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.FUN_BUILD_MAIN)[1]
    if mainBuildData:IsUpgradeFinish() or mainBuildData:IsUpgrading() then
      return
    end
  end
  return true
end

local function IsNotParkingLotBuild(itemId)
  return itemId ~= BuildingTypes.LW_BUILD_PARKINGLOT and itemId ~= BuildingTypes.LW_BUILD_PARKINGLOT_TWO and itemId ~= BuildingTypes.LW_BUILD_PARKINGLOT_THREE and itemId ~= BuildingTypes.LW_BUILD_PARKINGLOT_FOUR
end

function UIBuildUpgradeView:CheckRecommand()
  self.imgRecommand:SetActive(false)
  self.imaRecommandDiamond:SetActive(false)
  self.recommanded = true
  if not self:CheckEnabled() then
    return
  end
  local curBuildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildData.itemId)
  if curBuildTemplate.tab_type ~= UIBuildListTabType.Economy and curBuildTemplate.tab_type ~= UIBuildListTabType.Military and IsNotParkingLotBuild(self.buildData.itemId) then
    return
  end
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
  local mainBuildData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.FUN_BUILD_MAIN)[1]
  local lv = DataCenter.BuildManager.MainLv
  if mainBuildData:IsUpgradeFinish() or mainBuildData:IsUpgrading() then
    lv = lv + 1
  end
  local mainBuidingTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_MAIN, lv)
  if self.buildId == BuildingTypes.FUN_BUILD_MAIN then
    self.recommanded = true
    local canShowUpgrade = buildTemplate.max_level > self.buildData.level and self.buildData.level > 0
    if canShowUpgrade and mainBuidingTemplate ~= nil and not mainBuidingTemplate:IsTimeConditionValid() then
      self.recommanded = false
    end
    if self.recommanded then
      self.recommanded = not self.needPre
    end
    if self.recommanded then
      self.imaRecommandDiamond:SetActive(self.spendGold == 0)
      self.imgRecommand:SetActive(self.spendGold ~= 0)
    end
    return
  end
  self.recommanded = nil
  local canShowUpgrade = buildTemplate.max_level > self.buildData.level and self.buildData.level > 0
  if canShowUpgrade and mainBuidingTemplate ~= nil and not mainBuidingTemplate:IsTimeConditionValid() then
    canShowUpgrade = false
  end
  if not canShowUpgrade then
    return
  end
  if self.needPre then
    return
  end
  local preBuild = mainBuidingTemplate:GetPreBuild()
  if not preBuild then
    return
  end
  if not self.buildData:IsTheHighestLevel() then
    return
  end
  if not self.buildData:CheckRecommend() then
    return
  end
  self.imaRecommandDiamond:SetActive(self.spendGold == 0)
  self.imgRecommand:SetActive(self.spendGold ~= 0)
  self.recommanded = true
end

local function ReInitBtn(self)
  self.isFree = false
  local nTime = self.buildCurLevelTemplate:GetBuildTime()
  local needPathTime = 0
  if self.buildData ~= nil then
    if self.buildData.level == 0 then
      self.upgrade_btn_name:SetLocalText(GameDialogDefine.REPAIR_FIX)
    else
      self.upgrade_btn_name:SetLocalText(GameDialogDefine.UPGRADE)
    end
    if self.buildTemplate.scan == BuildScanAnim.Play then
      needPathTime = DataCenter.BuildManager:GetPathTimeFromDroneToBuildTarget(self.buildData:GetCenterVec())
    end
  end
  self.showBtnTime = nTime + needPathTime
  self.upgrade_btn_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(nTime + needPathTime))
  self:RefreshImmediatelyGold(nTime + needPathTime)
  self.original_time_text:SetLocalText("original_time_title", UITimeManager:GetInstance():MilliSecondToFmtString(self.buildCurLevelTemplate.time * 1000))
end

local function ClearContent(self)
  self.content:RemoveComponents(Item)
end

local function UpdateBuildDataSignal(self, uuid)
  if uuid == self.buildUuid then
    self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  end
  self:ShowPanel()
end

local function UpdateGoldSignal(self)
  if self.isUpgradeInfoShow then
    self:RefreshMid(true)
    self:ReInitBtn()
    self:RefreshImmediatelyGold()
  end
end

local function UpdateResourceSignal(self)
  if self.isUpgradeInfoShow then
    self:RefreshMid(true)
    self:ReInitBtn()
    self:CheckStudyNowBtnGrayState()
  end
end

local function UpdateItemSignal(self)
  if self.isUpgradeInfoShow and self.hasItem then
    self:RefreshMid(true)
    self:ReInitBtn()
  end
  self:CheckStudyNowBtnGrayState()
end

local function UpdateResItemSignal(self)
  if self.isUpgradeInfoShow then
    self:RefreshMid(true)
    self:ReInitBtn()
    self:CheckStudyNowBtnGrayState()
  end
end

local function ClearScroll(self)
  if self.scroll_view then
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIDetailsCell)
  end
end

local function IsBuildExist(self, buildId, level)
  local hasBuild = true
  if DataCenter.ScienceManager:IsScienceBuild(buildId) then
    local highestLevel = DataCenter.ScienceManager:GetHighestScienceBuildingLevel()
    if level > highestLevel then
      hasBuild = false
    end
  elseif buildId == BuildingTypes.LW_BUILD_TANKCENTER or buildId == BuildingTypes.LW_BUILD_ARTILLERYCENTER or buildId == BuildingTypes.LW_BUILD_AIRCRAFTCENTER then
    hasBuild = self:GetHighestCenterBuildingLevel(level)
  else
    hasBuild = DataCenter.BuildManager:IsExistBuildByTypeLv(buildId, level)
  end
  return hasBuild
end

local function GetAllNeed(self, needRefresh)
  if not self.allNeed or needRefresh then
    self.allNeed = {}
    self.needPre = false
    local needMonopoly = self.buildCurLevelTemplate.mono_condition
    if needMonopoly and needMonopoly ~= 0 then
      local curId = DataCenter.MonopolyManager.player.curId
      table.insert(self.allNeed, {
        condType = ScienceUnlockConditionType.MonoPolyFinish,
        itemId = needMonopoly,
        isRed = needMonopoly >= curId
      })
    end
    local building_prerequisites = self.buildCurLevelTemplate.building_prerequisites
    if string.IsNullOrEmpty(building_prerequisites) then
      local preBuild = self.buildCurLevelTemplate:GetPreBuild()
      if preBuild ~= nil then
        for _, v1 in ipairs(preBuild) do
          local buildId = v1.buildId
          local level = v1.level
          local param = {}
          param.condType = 1
          param.itemId = buildId
          param.level = level
          param.isRed = not IsBuildExist(self, buildId, level)
          self.needPre = self.needPre or param.isRed
          table.insert(self.allNeed, param)
        end
      end
    else
      local data_list = string.split(building_prerequisites, "|")
      local lack_build = {}
      for k, v in ipairs(data_list) do
        local tmp = string.split_ii_array(v, ";")
        if 2 <= #tmp then
          if IsBuildExist(self, tmp[1], tmp[2]) then
            lack_build = nil
            table.insert(self.allNeed, {
              condType = 1,
              itemId = tmp[1],
              level = tmp[2],
              isRed = false
            })
            break
          else
            table.insert(lack_build, {
              condType = 1,
              itemId = tmp[1],
              level = tmp[2],
              isRed = true
            })
          end
        end
      end
      if lack_build ~= nil and 0 < #lack_build then
        self.needPre = true
        table.insert(self.allNeed, lack_build[1])
      end
    end
    local needScience = self.buildCurLevelTemplate:GetNeedScience()
    if needScience ~= nil then
      for k, v in ipairs(needScience) do
        local scienceId = v.scienceId
        local level = v.level
        if not DataCenter.ScienceManager:HasScienceByIdAndLevel(scienceId, level) then
          table.insert(self.allNeed, {
            condType = 6,
            itemId = scienceId,
            level = level,
            isRed = true
          })
        else
          table.insert(self.allNeed, {
            condType = 6,
            itemId = scienceId,
            level = level,
            isRed = false
          })
        end
      end
    end
    local ret = DataCenter.BuildManager:CheckBuildUpgradeResAndItem(self.buildUuid)
    local needResource = ret.needResource
    local needResItem = ret.needResItem
    local needItem = ret.needItem
    self.hasItem = ret.hasItem
    self.lackResource = ret.lackResourceDict
    self.lackItem = ret.lackItemList
    self.lackResItem = ret.lackResItemList
    if (0 < table.count(self.lackResource) or 0 < table.count(self.lackItem) or 0 < table.count(self.lackResItem)) and not self.hasClose then
      DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.UIBuildUpgradeLackResource, tostring(self.buildId))
    end
    local lackList = {}
    if needItem ~= nil then
      local itemId
      for _, v1 in ipairs(needItem) do
        local param = {}
        itemId = v1.itemId
        param.condType = 5
        param.itemId = itemId
        param.count = v1.num
        local own = 0
        local item = DataCenter.ItemData:GetItemById(itemId)
        if item ~= nil then
          own = item.count
        end
        param.own = own
        if own >= param.count then
          table.insert(self.allNeed, param)
          param.isRed = false
        else
          table.insert(lackList, param)
          param.isRed = true
        end
      end
    end
    local addResList = {}
    if needResource ~= nil then
      for _, v1 in ipairs(needResource) do
        local param = {}
        param.condType = 3
        param.resourceType = v1.resourceType
        param.count = v1.count
        local own = LuaEntry.Resource:GetCntByResType(v1.resourceType)
        param.own = own
        table.insert(addResList, param)
      end
      for _, v in ipairs(addResList) do
        if v.own >= v.count then
          table.insert(self.allNeed, v)
          v.isRed = false
        else
          table.insert(lackList, v)
          v.isRed = true
        end
      end
    end
    self.needResource = needResource
    if needResItem ~= nil then
      for _, v1 in ipairs(needResItem) do
        local param = {}
        param.condType = 4
        param.resourceItemId = v1.itemId
        param.count = v1.count
        local own = 0
        local item = DataCenter.ResourceItemDataManager:GetItemDataByItemId(param.resourceItemId)
        if item ~= nil then
          own = item.number
        end
        param.own = own
        if own < param.count then
          param.isRed = true
        else
          param.isRed = false
        end
      end
    end
    table.insertto(self.allNeed, lackList)
  end
  return self.allNeed
end

local function GetHighestCenterBuildingLevel(self, targetLevel)
  local buildA = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_TANKCENTER)
  local highestLevel = 0
  if buildA ~= nil then
    highestLevel = buildA.level
  end
  if targetLevel <= highestLevel then
    return true
  end
  local buildB = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_ARTILLERYCENTER)
  if buildB ~= nil and highestLevel < buildB.level then
    highestLevel = buildB.level
    if targetLevel <= highestLevel then
      return true
    end
  end
  local buildC = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_AIRCRAFTCENTER)
  if buildC ~= nil and highestLevel < buildC.level then
    highestLevel = buildC.level
    if targetLevel <= highestLevel then
      return true
    end
  end
  return false
end

local function RefreshImmediatelyGold(self, needTime)
  self._free_rect:SetActive(false)
  local speedUpTime = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_BUILDSPEEDUP_WORKER) * 1000
  if speedUpTime < 0 then
    speedUpTime = 0
  end
  local nTime = self.buildCurLevelTemplate:GetBuildTime() - speedUpTime
  self.spendGold = CommonUtil.GetTimeDiamondCost(math.floor(nTime / 1000))
  if 0 < table.count(self.lackResource) then
    for k, v in pairs(self.lackResource) do
      local need = v - LuaEntry.Resource:GetCntByResType(k)
      self.spendGold = self.spendGold + CommonUtil.GetResGoldByType(k, need)
    end
  end
  if 0 < table.count(self.lackItem) then
    for _, v in pairs(self.lackItem) do
      self.spendGold = self.spendGold + CommonUtil.GetItemGoldByItemId(v.itemId, v.count)
    end
  end
  if 0 < table.count(self.lackResItem) then
    for _, v in pairs(self.lackResItem) do
      local _, diamondNum = DataCenter.ResourceItemDataManager:GetResourceItemBuyPriceTotal(v.itemId, v.count)
      self.spendGold = self.spendGold + diamondNum
    end
  end
  local freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_TIME_REDUCE) * 1000
  if 0 < freeTime and nTime <= freeTime then
    if self.lackResource ~= nil and 0 < table.count(self.lackResource) or self.lackItem ~= nil and 0 < table.count(self.lackItem) or self.lackResItem ~= nil and 0 < table.count(self.lackResItem) then
      self.isFree = false
      self.immediately_btn_name:SetAnchoredPositionXY(self.immediately_btn_name:GetAnchoredPositionX(), 26)
      self.immediately_btn_spend_count:SetActive(true)
      self.immediately_btn_spend_count:SetText(string.GetFormattedSeperatorNum(self.spendGold))
      self:RefreshGoldColor()
    else
      self.immediately_btn_name:SetAnchoredPositionXY(self.immediately_btn_name:GetAnchoredPositionX(), 20)
      self.immediately_btn_spend_count:SetActive(false)
      self._free_rect:SetActive(true)
      self.isFree = true
    end
  else
    self.immediately_btn_name:SetAnchoredPositionXY(self.immediately_btn_name:GetAnchoredPositionX(), 26)
    self.immediately_btn_spend_count:SetActive(true)
    self.immediately_btn_spend_count:SetText(string.GetFormattedSeperatorNum(self.spendGold))
    self:RefreshGoldColor()
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.immediately_btn.rectTransform)
  self:CheckRecommand()
end

local function RefreshGoldColor(self)
  local gold = LuaEntry.Player.gold
  if gold < self.spendGold then
    self.immediately_btn_spend_count:SetColor(Color.New(0.91, 0.26, 0.26, 1))
    self.immediately_btn_spend_count_shadow:AllEnable(false)
  else
    self.immediately_btn_spend_count:SetColor(WhiteColor)
    self.immediately_btn_spend_count_shadow:AllEnable(true)
  end
end

local function OnCreateCell(self, itemObj, index)
  local min, max = self.buildCurLevelTemplate:GetLevelRange()
  local level = min + index - 1
  local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildId, level)
  itemObj.name = self.buildId + level
  local cellItem = self.scroll_view:AddComponent(UIDetailsCell, itemObj)
  local param = UIDetailsCell.Param.New()
  param.names = {}
  param.names[1] = index
  for k, v in ipairs(template.local_num) do
    local effect = DataCenter.BuildManager:GetEffectNumWithType(v, self.buildTemplate.effect_Local_type[k])
    param.names[k + 1] = effect
  end
  local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k1")
  if showPower <= DataCenter.BuildManager.MainLv then
    param.names[#param.names + 1] = template.power
  end
  cellItem:ReInit(param)
  if self.buildData ~= nil and level == self.buildData.level then
    self.select_details_cell.transform:SetParent(cellItem.transform)
    self.select_details_cell.transform:SetAsFirstSibling()
    self.select_details_cell.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.select_details_cell.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.select_details_cell:SetActive(true)
  end
end

local function OnDeleteCell(self, itemObj, index)
  local min, max = self.buildCurLevelTemplate:GetLevelRange()
  local level = min + index - 1
  if level == self.level then
    self.select_details_cell.transform:SetParent(self.middle_go.transform)
    self.select_details_cell:SetActive(false)
  end
  self.scroll_view:RemoveComponent(itemObj.name, UIDetailsCell)
end

local function SetAllCellsDestroy(self)
  self:ClearScroll()
end

local function ImmediatelyBtnClick(self)
  if self.freeBuildingUpNewMsgLock then
    UIUtil.ShowTipsId(120289)
    return
  end
  if self.needResource and table.count(self.lackResource) > 0 then
    for k, _ in pairs(self.lackResource) do
      if k == ResourceType.OBSIDIAN or k == ResourceType.FLINT or k == ResourceType.Petroleum then
        for _, v in ipairs(self.needResource) do
          if k == v.resourceType then
            local data = {}
            table.insert(data, {
              resType = k,
              need = v.count
            })
            LWResourceLackUtil:GotoResLack(data)
            break
          end
        end
        return
      end
    end
  end
  if DataCenter.LWResourceLackManager:IsShowGoldSecondConfirmByLackResource(self.lackResource) then
    UIUtil.ShowMessage(Localization:GetString("diamond_lack_tips"), 2, GameDialogDefine.RESOURCE_LACK_FILL, GameDialogDefine.STILL_CONTINUE, function()
      if self.lackResource and table.count(self.lackResource) > 0 then
        local lackTab = {}
        for i, v in pairs(self.lackResource) do
          local param = {resType = i, need = v}
          table.insert(lackTab, param)
        end
        LWResourceLackUtil:GotoResLack(lackTab)
      end
    end, function()
      self:ImmediatelyUpgrade()
    end, nil, "diamond_lack_title")
    DataCenter.LWResourceLackManager:SetHasShownGoldSecondConfirmToday()
  else
    self:ImmediatelyUpgrade()
  end
end

local function GoUpgrade(self)
  if self.buildId == BuildingTypes.FUN_BUILD_MAIN and self:CheckShowBrokenTips(self.nextLevel) then
    UIUtil.ShowMessage(Localization:GetString("110165", self.nextLevel), 2, Localization:GetString(GameDialogDefine.CONFIRM), Localization:GetString(GameDialogDefine.CANCEL), function()
      local param = {}
      param.uuid = tostring(self.buildUuid)
      param.gold = BuildUpgradeUseGoldType.Yes
      param.upLevel = self.nextLevel
      param.clientParam = ""
      param.truckId = 0
      param.pathTime = 0
      param.robotUuid = 0
      SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, param)
      self.freeBuildingUpNewMsgLock = true
    end, function()
    end)
  else
    local param = {}
    param.uuid = tostring(self.buildUuid)
    param.gold = BuildUpgradeUseGoldType.Yes
    param.upLevel = self.nextLevel
    param.clientParam = ""
    param.truckId = 0
    param.pathTime = 0
    param.robotUuid = 0
    SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, param)
    self.freeBuildingUpNewMsgLock = true
    local heroData = DataCenter.HeroDataManager:GetFreeAddTimeHero(EffectDefine.BUILD_TIME_REDUCE)
    if heroData then
      do
        local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroData.heroId)
        local name = Localization:GetString(heroConfig.name)
        local freeTime = Mathf.Ceil(LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_TIME_REDUCE) / 60)
        if freeTime == 0 then
          return
        end
        local time
        if self.showBtnTime then
          if self.showBtnTime < LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_TIME_REDUCE) then
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
  end
end

local function ImmediatelyUpgrade(self)
  if self.isFree then
    local param = {}
    param.uuid = tostring(self.buildUuid)
    param.gold = BuildUpgradeUseGoldType.Free
    param.upLevel = self.nextLevel
    param.clientParam = ""
    param.truckId = 0
    param.pathTime = 0
    param.robotUuid = 0
    SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, param)
    self.freeBuildingUpNewMsgLock = true
    local heroData = DataCenter.HeroDataManager:GetFreeAddTimeHero(EffectDefine.BUILD_TIME_REDUCE)
    if heroData then
      local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroData.heroId)
      local name = Localization:GetString(heroConfig.name)
      local freeTime = Mathf.Ceil(LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_TIME_REDUCE) / 60)
      local time
      if self.showBtnTime then
        if self.showBtnTime < LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_TIME_REDUCE) * 1000 then
          if self.showBtnTime > 60000 then
            local min = Mathf.Floor(self.showBtnTime / 60000)
            time = min .. Localization:GetString("100165")
          else
            time = Localization:GetString("130076", math.ceil(self.showBtnTime / 1000))
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
    return
  end
  local gold = LuaEntry.Player.gold
  if gold < self.spendGold then
    GoToUtil.GotoPayTips(self.spendGold)
  elseif self.noBuyItemId ~= nil then
    UIUtil.ShowTips(Localization:GetString(GameDialogDefine.ITEM_NO_REACH, DataCenter.ItemTemplateManager:GetName(self.noBuyItemId)))
  elseif self.noBuyResItemId ~= nil then
    UIUtil.ShowTips(Localization:GetString(GameDialogDefine.ITEM_NO_REACH, DataCenter.ResourceItemDataManager:GetName(self.noBuyResItemId)))
  elseif 0 < self.spendGold then
    local param = {
      contentText = Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES),
      btnNum = 2,
      confirmBtnParam = {
        action = function()
          GoUpgrade(self)
        end
      }
    }
    UIUtil.TryShowDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, param)
  else
    GoUpgrade(self)
  end
end

local function OnUpgradeRewardBtnClick(self)
  if self.buildNextLevelTemplate ~= nil and not string.IsNullOrEmpty(self.buildNextLevelTemplate.reward_show) then
    local rewards = DataCenter.RewardManager:ParseRewardsStr(self.buildNextLevelTemplate.reward_show)
    local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
    param.position = self.upgradeReward_btn:GetPosition()
    param.deltaX = -30
    param.dir = UIPersonalArmsRewardTipView.Direction.RIGHT
    param.rewardList = rewards
    param.title = "135269"
    param.hideCount = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
  end
end

local function UpgradeBtnClick(self)
  if self.freeBuildingUpNewMsgLock then
    UIUtil.ShowTipsId(120289)
    return
  end
  self:Upgrade()
end

local function Upgrade(self)
  if self.buildData == nil then
    return
  end
  local state = self.buildData.state
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildData.itemId, self.buildData.level)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.buildData.updateTime then
    UIUtil.ShowTipsId(GameDialogDefine.BUILD_UPGRADING)
  elseif state == BuildingStateType.Normal or state == BuildingStateType.Upgrading and curTime >= self.buildData.updateTime then
    if self.noBuyItemId ~= nil then
      UIUtil.ShowTips(Localization:GetString(GameDialogDefine.ITEM_NO_REACH, DataCenter.ItemTemplateManager:GetName(self.noBuyItemId)))
    elseif self.noBuyResItemId ~= nil then
      UIUtil.ShowTips(Localization:GetString(GameDialogDefine.ITEM_NO_REACH, DataCenter.ResourceItemDataManager:GetName(self.noBuyResItemId)))
    elseif not (table.IsNullOrEmpty(self.lackResource) and table.IsNullOrEmpty(self.lackItem)) or not table.IsNullOrEmpty(self.lackResItem) then
      local lackTab = {}
      if table.count(self.lackResource) > 0 then
        for i, v in pairs(self.lackResource) do
          local param = {resType = i, need = v}
          table.insert(lackTab, param)
        end
        LWResourceLackUtil:GotoResLack(lackTab)
        return
      end
      if table.count(self.lackItem) > 0 then
        local id, need
        for i = 1, #self.lackItem do
          id = self.lackItem[i].itemId
          need = self.lackItem[i].count
        end
        if id then
          LWResourceLackUtil:GotoGoodsItemLack(id, need)
        end
        return
      end
      if table.count(self.lackResItem) > 0 then
        local id, need
        for i = 1, #self.lackResItem do
          id = self.lackResItem[i].itemId
          need = self.lackResItem[i].needCount
        end
        if id then
          LWResourceLackUtil:GotoResourceItemLack(id, need)
        end
        return
      end
      UIUtil.ShowTipsId(120020)
    elseif buildTemplate and buildTemplate.mono_condition and buildTemplate.mono_condition ~= 0 and buildTemplate.mono_condition >= DataCenter.MonopolyManager.player.curId then
      local mono_condition = DataCenter.MonopolyManager:GetPlacealityQuestOrder(tonumber(buildTemplate.mono_condition))
      UIUtil.ShowTips(Localization:GetString(801155, mono_condition))
      self.ctrl:CloseSelf()
      SceneUtils.ChangeToCity(function()
        GoToUtil.GoToCurObstacle()
      end)
    else
      local needPathTime = 0
      if self.buildTemplate.scan == BuildScanAnim.Play then
        needPathTime = DataCenter.BuildManager:GetPathTimeFromDroneToBuildTarget(self.buildData:GetCenterVec())
      end
      local param = {}
      param.uuid = tostring(self.buildUuid)
      param.gold = BuildUpgradeUseGoldType.No
      param.upLevel = self.nextLevel
      param.clientParam = ""
      param.truckId = 0
      param.pathTime = needPathTime
      param.robotUuid = 0
      local result, queueUuid = DataCenter.BuildQueueManager:IsCanUpgrade(self.buildData.itemId, self.buildData.level)
      if result then
        param.robotUuid = queueUuid
        if self.buildId == BuildingTypes.FUN_BUILD_MAIN and self:CheckShowBrokenTips(self.nextLevel) then
          UIUtil.ShowMessage(Localization:GetString("110165", self.nextLevel), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, param)
            self.freeBuildingUpNewMsgLock = true
            self.hasClose = true
            self.ctrl:CloseSelf()
          end, function()
          end)
        else
          SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, param)
          self.freeBuildingUpNewMsgLock = true
          self.hasClose = true
          self.ctrl:CloseSelf()
        end
      else
        do
          local canBuyQueueId = DataCenter.BuildQueueManager:GetCanBuyQueue()
          if canBuyQueueId and DataCenter.BuildQueueManager:IsAnyQueueFree() then
            local window = UIManager:GetInstance():GetWindow(UIWindowNames.UILWWorkerQueue)
            if window == nil then
              UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorkerQueue, {anim = true}, canBuyQueueId)
            end
          else
            local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIBuildQueue)
            if window == nil then
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildQueue)
            end
          end
        end
      end
    end
  end
end

local function BackBtnClick(self)
  self.animator:Play("switchOut", 0, 0)
end

local function ShowDesCells(self)
  self.des_content:RemoveComponents(UIDesCell)
  for k, v in pairs(self.desCells) do
    if v.inst then
      self:GameObjectDestroy(v.inst)
    end
    v.param = nil
    v.model = nil
  end
  self.desCells = {}
  local desShowData
  if self.ctrl.GetDesShowData then
    desShowData = self.ctrl:GetDesShowData(self.buildCurLevelTemplate, self.buildNextLevelTemplate, self.buildTemplate)
  end
  if not table.IsNullOrEmpty(desShowData) then
    self.des_content:SetActive(true)
    for i, param in ipairs(desShowData) do
      self.desCellIndex = self.desCellIndex + 1
      self:AddOneDesCells(param)
    end
    self:AddPowerDesCell()
  else
    self.des_content:SetActive(false)
    self:AddPowerDesCell()
  end
end

local function AddPowerDesCell(self)
end

local function AddOneDesCells(self, param)
  local cell = {}
  table.insert(self.desCells, cell)
  cell.param = param
  cell.inst = self:GameObjectInstantiateAsync(UIAssets.DesCell, function(request)
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
    local effect = self.des_content:AddComponent(UIDesCell, nameStr)
    if effect ~= nil then
      effect:ReInit(param)
    end
    cell.model = effect
  end)
end

local function CheckShowBrokenTips(self, targetLv)
  local checkObj = LuaEntry.DataConfig:GetObj("shield_base_2")
  if checkObj ~= nil then
    local checkLevel = tonumber(checkObj)
    if targetLv == checkLevel then
      return true
    end
  end
  return false
end

local function CheckShowArrow(self)
  if not DataCenter.GuideManager:InGuide() then
    self.delayTimer = nil
    if self.arrowLackResourceType == nil or self.needResourceCells[self.arrowLackResourceType] == nil or self.needResourceCells[self.arrowLackResourceType].model == nil or self.needPre then
      DataCenter.ArrowManager:RemoveArrow()
    else
      local param = {}
      param.position = self.needResourceCells[self.arrowLackResourceType].model.transform.position
      param.arrowType = ArrowType.LackResource
      param.positionType = PositionType.Screen
      DataCenter.ArrowManager:ShowArrow(param)
    end
  end
end

local function ShowReason(self)
  local effectId = EffectDefine.BUILD_SPEED_ADD
  local buildSpeedValue = LuaEntry.Effect:GetGameEffect(effectId)
  local needLevel = LuaEntry.DataConfig:TryGetNum("show_power", "k1")
  if LuaEntry.DataConfig:CheckSwitch("update_detail") and needLevel <= DataCenter.BuildManager.MainLv and buildSpeedValue ~= nil and 0 < buildSpeedValue and 0 < self.buildCurLevelTemplate.time then
    self.show_reason:SetActive(true)
    local param = {}
    if self.buildTemplate.scan == BuildScanAnim.Play then
      param.originalTime = Localization:GetString(GameDialogDefine.ORIGINAL_TIME, UITimeManager:GetInstance():MilliSecondToFmtString(self.buildCurLevelTemplate.time * 1000 + DataCenter.BuildManager:GetPathTimeFromDroneToBuildTarget(self.buildData:GetCenterVec())))
    else
      param.originalTime = Localization:GetString(GameDialogDefine.ORIGINAL_TIME, UITimeManager:GetInstance():MilliSecondToFmtString(self.buildCurLevelTemplate.time * 1000))
    end
    param.totalDes = Localization:GetString(GameDialogDefine.REASON_BUILD_SPEED_ADD)
    local effectValueX = 0
    local effectValueY = 0
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
      paramDes.leftDes = Localization:GetString(GameDialogDefine.REASON_BUILD)
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

local function GetGuideLackCellBtn(self)
  for k, v in pairs(self.needResourceCells) do
    if v.model ~= nil and v.model:IsLack() then
      DataCenter.ArrowManager:RemoveArrow()
      return v.model:GetGuideBtn()
    end
  end
end

local function ShowUpgradeGuide(self)
  if not LuaEntry.DataConfig:CheckSwitch("ABtest_chapter_1") or LuaEntry.Player.abTest == ABTestType.A then
    return
  end
  if not self.buildId or self.buildId ~= BuildingTypes.FUN_BUILD_MAIN then
    return
  end
  if not self.level or self.level ~= 1 then
    return
  end
  local guideFinish = CS.GameEntry.Setting:PlayerPrefsGetInt("MainBuildingUpgradeGuide", 0)
  if guideFinish ~= 0 then
    return
  end
  CS.GameEntry.Setting:PlayerPrefsSetInt("MainBuildingUpgradeGuide", 1)
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.ArrowManager:RemoveArrow()
    local param = {}
    param.position = self.upgrade_btn:GetPosition()
    param.arrowType = ArrowType.Building
    param.positionType = PositionType.Screen
    param.isPanel = false
    if not DataCenter.GuideManager:InGuide() and param.position ~= nil then
      DataCenter.ArrowManager:ShowArrow(param)
    end
  end, 1)
end

local function UnLockFreeBuildingUpNewMsg(self)
  self.freeBuildingUpNewMsgLock = false
end

function UIBuildUpgradeView:ShowTip(data, position)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgradeExtraTip, {anim = true}, data, position)
end

function UIBuildUpgradeView:IsExistLackResNotGetWithDiamond()
  if not self.lackResource or table.count(self.lackResource) <= 0 then
    return false
  end
  for i, k in pairs(self.lackResource) do
    local resType = i
    local isHaveItemInBag = LWResourceLackUtil:IsExistLackResourceIteminBag(resType)
    if not LWResourceLackUtil:IsResourcePurchasableWithDiamonds(resType) and not isHaveItemInBag then
      return true
    end
  end
  return false
end

function UIBuildUpgradeView:CheckStudyNowBtnGrayState()
  if self.needPre then
    return
  end
  local isNeedGraystudyNowBtn = self:IsExistLackResNotGetWithDiamond()
  UIGray.SetGray(self.immediately_btn.transform, isNeedGraystudyNowBtn, not isNeedGraystudyNowBtn)
end

function UIBuildUpgradeView:OnBuildingLevelUp(data)
  if not data or data.uuid ~= self.buildUuid or not self.buildData then
    return
  end
  self:CheckDecorationLevelUp()
end

function UIBuildUpgradeView:CheckDecorationLevelUp()
  if self.buildTemplate.tab_type ~= UIBuildListTabType.Decorate then
    return
  end
  self:ReInitDecoration(self.buildData)
end

function UIBuildUpgradeView:CreateDelayTimer(callback, delay, timerName)
  if self.delayTimers == nil then
    self.delayTimers = {}
  end
  timerName = timerName or "timer_" .. tostring(#self.delayTimers + 1)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayTimers[timerName] then
      self.delayTimers[timerName] = nil
    end
    callback()
  end, delay)
  self.delayTimers[timerName] = timer
  return timer
end

function UIBuildUpgradeView:ClearAllDelayTimers()
  if self.delayTimers then
    for name, timer in pairs(self.delayTimers) do
      if timer then
        timer:Stop()
      end
    end
    self.delayTimers = {}
  end
end

function UIBuildUpgradeView:Update1000MS()
  if self.seasonEndTime then
    UIUtil.SetLeftTimeText(self.season_info_time_text, nil, self.seasonEndTime)
  end
end

function UIBuildUpgradeView:RefreshSeasonInfo()
  if not self.buildTemplate or self.buildTemplate.tab_type ~= UIBuildListTabType.SeasonCityBuild then
    self.season_info_btn:SetActive(false)
    return
  end
  local seasonIcon = SeasonUtil.GetSeasonSmallIconPath(SeasonUtil.GetSeason())
  if not seasonIcon then
    self.season_info_btn:SetActive(false)
    return
  end
  self.season_info_icon:LoadSprite(seasonIcon)
  self.season_info_icon:SetNativeSize()
  self.season_info_btn:SetActive(true)
  if SeasonUtil.GetSeasonLeftDay() < 0 then
    self.seasonEndTime = SeasonUtil.GetSeasonEndTime()
    self.season_info_time:SetActive(true)
    self:Update1000MS()
  else
    self.seasonEndTime = nil
    self.season_info_time:SetActive(false)
  end
end

function UIBuildUpgradeView:ShowSeasonBuildingTips()
  local tipsId = SeasonUtil.GetSeasonLeftDay() < 0 and "season_building_tips_2" or "season_building_tips_1"
  UIUtil.ShowBubbleTips(CS.GameEntry.Localization:GetString(tipsId), self.season_info_icon.transform.position, 0, -30, 0)
end

function UIBuildUpgradeView:RefreshFirstPayExpInfo(gainBaseExp)
  local buildingExpData = DataCenter.FirstPayManager:GetCurBuildExpData()
  if not buildingExpData then
    return
  end
  local exExpPercent = buildingExpData.exExpPercent / 10000
  local exGainExp = gainBaseExp * exExpPercent
  local curMaxGainExp = buildingExpData:GetCurRemainExpInPool()
  exGainExp = math.min(exGainExp, curMaxGainExp)
  local data = {}
  data.addExp = exGainExp
  self.firstPayExpCpt:Refresh(data)
end

UIBuildUpgradeView.OnCreate = OnCreate
UIBuildUpgradeView.OnDestroy = OnDestroy
UIBuildUpgradeView.OnEnable = OnEnable
UIBuildUpgradeView.OnDisable = OnDisable
UIBuildUpgradeView.ComponentDefine = ComponentDefine
UIBuildUpgradeView.ComponentDestroy = ComponentDestroy
UIBuildUpgradeView.DataDefine = DataDefine
UIBuildUpgradeView.DataDestroy = DataDestroy
UIBuildUpgradeView.OnAddListener = OnAddListener
UIBuildUpgradeView.OnRemoveListener = OnRemoveListener
UIBuildUpgradeView.ReInit = ReInit
UIBuildUpgradeView.ReInitDecoration = ReInitDecoration
UIBuildUpgradeView.SetBuildInfoActive = SetBuildInfoActive
UIBuildUpgradeView.OnDeleteCell = OnDeleteCell
UIBuildUpgradeView.OnCreateCell = OnCreateCell
UIBuildUpgradeView.ClearScroll = ClearScroll
UIBuildUpgradeView.SetAllCellsDestroy = SetAllCellsDestroy
UIBuildUpgradeView.ImmediatelyBtnClick = ImmediatelyBtnClick
UIBuildUpgradeView.ImmediatelyUpgrade = ImmediatelyUpgrade
UIBuildUpgradeView.OnUpgradeRewardBtnClick = OnUpgradeRewardBtnClick
UIBuildUpgradeView.UpgradeBtnClick = UpgradeBtnClick
UIBuildUpgradeView.Upgrade = Upgrade
UIBuildUpgradeView.BackBtnClick = BackBtnClick
UIBuildUpgradeView.ShowPanel = ShowPanel
UIBuildUpgradeView.RefreshContent = RefreshContent
UIBuildUpgradeView.ClearContent = ClearContent
UIBuildUpgradeView.RefreshMid = RefreshMid
UIBuildUpgradeView.GetAllNeed = GetAllNeed
UIBuildUpgradeView.InitBtn = InitBtn
UIBuildUpgradeView.ReInitBtn = ReInitBtn
UIBuildUpgradeView.RefreshImmediatelyGold = RefreshImmediatelyGold
UIBuildUpgradeView.SetDetailsTitle = SetDetailsTitle
UIBuildUpgradeView.ShowDesCells = ShowDesCells
UIBuildUpgradeView.AddPowerDesCell = AddPowerDesCell
UIBuildUpgradeView.AddOneDesCells = AddOneDesCells
UIBuildUpgradeView.UpdateGoldSignal = UpdateGoldSignal
UIBuildUpgradeView.UpdateResourceSignal = UpdateResourceSignal
UIBuildUpgradeView.UpdateBuildDataSignal = UpdateBuildDataSignal
UIBuildUpgradeView.RefreshGoldColor = RefreshGoldColor
UIBuildUpgradeView.UpdateItemSignal = UpdateItemSignal
UIBuildUpgradeView.UpdateResItemSignal = UpdateResItemSignal
UIBuildUpgradeView.CheckShowBrokenTips = CheckShowBrokenTips
UIBuildUpgradeView.CheckShowArrow = CheckShowArrow
UIBuildUpgradeView.ShowReason = ShowReason
UIBuildUpgradeView.GetGuideLackCellBtn = GetGuideLackCellBtn
UIBuildUpgradeView.ShowUpgradeGuide = ShowUpgradeGuide
UIBuildUpgradeView.UnLockFreeBuildingUpNewMsg = UnLockFreeBuildingUpNewMsg
UIBuildUpgradeView.GetHighestCenterBuildingLevel = GetHighestCenterBuildingLevel
UIBuildUpgradeView.CheckShowNormalOrAdvanceDecUpgradePanel = CheckShowNormalOrAdvanceDecUpgradePanel
UIBuildUpgradeView.ShowNormalDecoUpgradePanel = ShowNormalDecoUpgradePanel
UIBuildUpgradeView.ShowAdvanceUpgradeDecoUpgradePanel = ShowAdvanceUpgradeDecoUpgradePanel
return UIBuildUpgradeView
