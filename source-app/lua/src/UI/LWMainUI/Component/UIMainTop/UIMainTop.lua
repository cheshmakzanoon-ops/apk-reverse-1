local UIMainTop = BaseClass("UIMainTop", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIMainResourceProgress = require("UI.LWMainUI.Component.UIMainTop.UIMainResourceProgress")
local UIMainItemProgress = require("UI.LWMainUI.Component.UIMainTop.UIMainItemProgress")
local UIFirstChargeBtn = require("UI.LWMainUI.Component.UIMainTop.UIFirstChargeBtn")
local UIDailyPackBtn = require("UI.LWMainUI.Component.UIMainTop.UIDailyPackBtn")
local UIGovernmentBtn = require("UI.LWMainUI.Component.UIMainTop.UIGovernmentBtn")
local UIAttackCityBtn = require("UI.LWMainUI.Component.UIMainTop.UIMainAttackCityBtn")
local UIAttackCityS0Btn = require("UI.LWMainUI.Component.UIMainTop.UIMainAttackCityS0Btn")
local UIKingBtn = require("UI.LWMainUI.Component.UIMainTop.UIKingBtn")
local UIDoomVanguardBtn = require("UI.LWMainUI.Component.UIMainTop.UIDoomVanguardBtn")
local UIMainPopupPackEntrance = require("UI.UIMain.Component.UIMainRight.UIMainPopupPackEntrance")
local UIMainAllyDuelBtn = require("UI.LWMainUI.Component.UIMainTop.UIMainAllyDuelBtn")
local UIMainGiftBoxActivityBtn = require("UI.LWMainUI.Component.UIMainTop.UIMainGiftBoxActivityBtn")
local UIMainScratchActivityBtn = require("UI.LWMainUI.Component.UIMainTop.UIMainScratchActivityBtn")
local UIMainThanksGivingActivityBtn = require("UI.LWMainUI.Component.UIMainTop.UIMainThanksGivingActivityBtn")
local UIMainActivityGroupContent = require("UI.LWMainUI.Component.UIMainTop.UIMainActivityGroupContent")
local UIMainPiggyBankBtn = require("UI.LWMainUI.Component.UIMainTop.UIMainPiggyBankBtn")
local UIMainInfiniteGiftBtn = require("UI.LWMainUI.Component.UIMainTop.UIMainInfiniteGiftBtn")
local UIMainGoldBrick = require("UI.LWMainUI.Component.UIMainTop.UIMainGoldBrick")
local UIMainActivityTips = require("UI.LWMainUI.Component.UIMainTop.UIMainActivityTips")
local UIMainCrossServerBubbleTips = require("UI.LWMainUI.Component.UIMainTop.UIMainCrossServerBubbleTips")
local UIMainAccountBindTipBtn = require("UI.LWMainUI.Component.UIMainTop.UIMainAccountBindTipBtn")
local LWMainUIActivityAlarmClockDispatch = require("UI.LWMainUI.Component.UIMainTop.LWMainUIActivityAlarmClockDispatch")
local UIMainCoppaAppealBtn = require("UI.LWMainUI.Component.UIMainTop.UIMainCoppaAppealBtn")
local LWMainCityFightAlarmObj = require("UI.LWMainUI.Component.UIMainTop.LWMainCityFightAlarmObj")
local ActZoneMobilizationItem = require("UI.LWMainUI.Component.UIMainTop.ActZoneMobilizationItem")
local UIMainActMeteoriteBtn = require("UI.LWMainUI.Component.UIMainTop.UIMainActMeteoriteBtn")
local UIMainActMigrationBtn = require("UI.LWMainUI.Component.UIMainTop.UIMainActMigrationBtn")
local UIMainActLandlordBackBtn = require("UI.LWMainUI.Component.UIMainTop.UIMainActLandlordBackBtn")
local UIMainGoldStore = require("UI.LWMainUI.Component.UIMainTop.UIMainGoldStore")
local UIMainPower = require("UI.LWMainUI.Component.UIMainTop.UIMainPower")
local UIMainBuffList = require("UI.LWMainUI.Component.UIMainTop.UIMainBuffList")
local UIMeteoriteNoticeItem = require("UI.UIMainMiniMap.Component.MainMiniMapMeteoriteNoticeItem")
local UILWDominatorCockatriceUnlockMainUIEntranceComponent = require("UI/UILWDominator/CockatriceUnlock/MainUI/UILWDominatorCockatriceUnlockMainUIEntranceComponent")
local resource_bar_path = "ResourceBar/layout"
local goldStore_path = "ResourceBar/goldStore"
local gold_brick_path = "ResourceBar/layout/GoldBrick"
local power_path = "ResourceBar/layout/resourceLayout/Power"
local resourceLayout_path = "ResourceBar/layout/resourceLayout"
local uiMainBuffList_path = "ResourceBar/layout/BuffListRoot"
local cross_server_root_path = "ResourceBar/layout/CrossServerRoot"
local tip_bg_path = "ResourceBar/layout/CrossServerRoot/tipBg"
local move_city_root_path = "ResourceBar/layout/MoveCityRoot"
local img_icon_path = "ResourceBar/layout/MoveCityRoot/moveCityTipBg/img_icon"
local tip_text_path = "ResourceBar/layout/MoveCityRoot/moveCityTipBg/context/tipText"
local txt_time_path = "ResourceBar/layout/MoveCityRoot/moveCityTipBg/context/txt_time"
local btn_back_home_path = "ResourceBar/layout/MoveCityRoot/moveCityTipBg/btn_backHome"
local img_progress_path = "ResourceBar/layout/MoveCityRoot/moveCityTipBg/img_progress"
local move_city_tip_bg_path = "ResourceBar/layout/MoveCityRoot/moveCityTipBg"
local tip_pos_path = "ResourceBar/layout/MoveCityRoot/moveCityTipBg/tipPos"
local btn_tip_path = "ResourceBar/layout/MoveCityRoot/moveCityTipBg/btn_tip"
local new_bubble_root_path = "ResourceBar/layout/MoveCityRoot/moveCityTipBg/NewBubbleRoot"
local activityCenterBtn_path = "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/ActivityCenterBtn"
local activityCenterBtnArea_path = "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/ActivityCenterBtn"
local activityCenterBtnText_path = "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/ActivityCenterBtn/ActivityCenterBtnText"
local activityCenter_common_red_point_path = "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/ActivityCenterBtn/CommonRedPoint"
local activityCenterBtnIcon_path = "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/ActivityCenterBtn/Bg"
local themeActivityBtn_path = "TopBtnsContainer/LeftColBtns/Viewport/LeftTopBtns/ThemeActivityBtn"
local themeActivityBtnArea_path = "TopBtnsContainer/LeftColBtns/Viewport/LeftTopBtns/ThemeActivityBtn"
local themeActivityBtnText_path = "TopBtnsContainer/LeftColBtns/Viewport/LeftTopBtns/ThemeActivityBtn/ThemeActivityBtnTxt"
local themeActivityBtnRedPoint_path = "TopBtnsContainer/LeftColBtns/Viewport/LeftTopBtns/ThemeActivityBtn/ThemeActivityBtnRed"
local themeActivityBtnRedPointNum_path = "TopBtnsContainer/LeftColBtns/Viewport/LeftTopBtns/ThemeActivityBtn/ThemeActivityBtnRed/ThemeActivityBtnRedTxt"
local dailyPackBtn_path = "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/DailyPackBtn"
local topBtns_path = "TopBtnsContainer/LeftColBtns/Viewport/LeftTopBtns"
local popupPackageBtnTemplate_path = "TopBtnsContainer/LeftColBtns/Viewport/LeftTopBtns/UIPopupPackageT"
local enter_gift_box_activity_path = "TopBtnsContainer/LeftColBtns/Viewport/LeftTopBtns/GiftBoxActivityBtn"
local enter_thanks_giving_activity_path = "TopBtnsContainer/LeftColBtns/Viewport/LeftTopBtns/ThanksGivingActivityBtn"
local ui_main_activity_group_content_path = "TopBtnsContainer/LeftColBtns/Viewport/LeftTopBtns/UIMainActivityGroupContent"
local account_bind_tip_btn_path = "TopBtnsContainer/LeftColBtns/Viewport/LeftTopBtns/AccountBindTipBtn"
local coppa_appeal_btn_path = "TopBtnsContainer/LeftColBtns/Viewport/LeftTopBtns/UIMain_icon_coppaAppeal"
local enter_scratch_activity_path = "TopBtnsContainer/LeftColBtns/Viewport/LeftTopBtns/ScratchActivityBtn"
local piggy_bank_btn_path = "TopBtnsContainer/LeftColBtns/Viewport/LeftTopBtns/PiggyBankBtn"
local infiniteGift_btn_path = "TopBtnsContainer/LeftColBtns/Viewport/LeftTopBtns/InfiniteGiftBtn"
local dialyPack_new_tag_path = "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/DailyPackBtn/DailyPackNew"
local bubble_root_path = "ResourceBar/layout/CrossServerRoot/tipBg/BubbleRoot"
local zone_mobilization_btn_path = "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/ZoneMobilizationBtn"
local meteorite_notice_root_path = "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/MeteoriteNoticeRoot"
local dominatorCockatriceUnlockBtn_path = "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/DominatorCockatriceUnlockBtn"
local HideExtraResourceDelayTime = 1.5
local ResourceCellIndexStart = 0
local ArabicResourceCellIndexStart1 = 3
local AllianceCellIndexStart = 10
local ICON_PATH = "Assets/Main/Sprites/UI/UIMain/LWMainUI/%s.png"
local ResetResourceType = {
  ResourceType.Petroleum,
  ResourceType.FLINT,
  ResourceType.OBSIDIAN,
  ResourceType.Wood,
  ResourceType.Metal,
  ResourceType.Food
}
local ResourceType2FuncUnlockID = {
  [ResourceType.Wood] = LWFunctionUnlockType.MainUI_CoinBar,
  [ResourceType.Metal] = LWFunctionUnlockType.MainUI_MetalBar,
  [ResourceType.Food] = LWFunctionUnlockType.MainUI_FoodBar,
  [ResourceType.Petroleum] = LWFunctionUnlockType.MainUI_PetroleumBar
}
local frontBreakSundayIconPath = "Assets/Main/Sprites/UI/UIActivityFrontBreakSunday/mjc_mainUI_icon_qianxiantuwei.png"

local function RefreshPackInfo(self)
  if self.firstChargeBtn ~= nil then
    self.firstChargeBtn:RefreshShowState()
  end
  if self.dailyPackBtn ~= nil then
    self.dailyPackBtn:RefreshShowState()
  end
  if self.governmentBtn ~= nil then
    self.governmentBtn:RefreshShowState()
  end
  if self.attackCityBtn ~= nil then
    self.attackCityBtn:SetActive(false)
  end
  if self.attackCityS0Btn ~= nil then
    self.attackCityS0Btn:RefreshShowState()
  end
  if self.kingBtn ~= nil then
    self.kingBtn:RefreshShowState()
  end
  self:RefreshSeasonBtnShow()
  if self.DoomVanguardBtn ~= nil then
    self.DoomVanguardBtn:RefreshShowState()
  end
  self:RefreshPopupPackageEntrances()
  self:RefreshPiggyBankBtn()
end

local function RefreshChargeBtnRedPoint(self)
  if self.dailyPackBtn ~= nil then
    self.dailyPackBtn:RefreshShowState()
  end
end

local function RefreshFristPayBtn(self)
  if self.firstChargeBtn ~= nil then
    self.firstChargeBtn:RefreshShowState()
  end
end

local function RefreshActivityBtn(self)
  self:RefreshAlCompeteBtn()
  self:RefreshGiftBoxBtn()
  self:RefreshThanksGivingBtn()
  self:RefreshScratchBtn()
  self:RefreshPiggyBankBtn()
  self:RefreshInfiniteGiftBtn()
  self:RefreshUIMainActivityGroupContent()
  self:RefreshActivityTips()
  if self.governmentBtn ~= nil then
    self.governmentBtn:RefreshShowState()
  end
  if self.kingBtn ~= nil then
    self.kingBtn:RefreshShowState()
  end
  self:RefreshSeasonBtnShow()
  if not DataCenter.ActivityListDataManager then
    return
  end
  if not self.activityCenterBtn then
    return
  end
  if self.attackCityBtn ~= nil then
    self.attackCityBtn:SetActive(false)
  end
  if self.attackCityS0Btn ~= nil then
    self.attackCityS0Btn:RefreshShowState()
  end
  if self.DoomVanguardBtn ~= nil then
    self.DoomVanguardBtn:RefreshShowState()
  end
  self:UpdateWhenAnim(nil)
  if self.dailyPackBtn ~= nil then
    self.dailyPackBtn:RefreshShowState()
  end
  local unlock = self.view.ctrl:GetActivityCenterBtnShow()
  if not unlock then
    self.activityCenterBtn:SetActive(false)
    return
  end
  DataCenter.ActivityListDataManager:SortActivityArr()
  local list = DataCenter.ActivityListDataManager:GetNowActivityList(false)
  if not table.IsNullOrEmpty(list) then
    self.activityCenterBtn:SetActive(true)
    local isActFrontBreakSundayOpen = DataCenter.ActFrontBreakSundayDataManager:IsOpen() and DataCenter.ActFrontBreakSundayDataManager:NeedChangeEntryIcon()
    if RaceEntranceUtil.IsNewMigration() then
      local iconName = DataCenter.ActivityListDataManager:GetActivityBtnIconPath()
      if not string.IsNullOrEmpty(iconName) then
        self.activityCenterBtnIcon:LoadSprite(iconName)
      elseif isActFrontBreakSundayOpen then
        self.activityCenterBtnIcon:LoadSprite(frontBreakSundayIconPath)
      else
        self.activityCenterBtnIcon:LoadSprite(string.format(ICON_PATH, "mjc_huodong_huizong"))
      end
    elseif isActFrontBreakSundayOpen then
      self.activityCenterBtnIcon:LoadSprite(frontBreakSundayIconPath)
    else
      self.activityCenterBtnIcon:LoadSprite(string.format(ICON_PATH, "mjc_huodong_huizong"))
    end
    local redDotCount, rewardCount, tipCount = DataCenter.ActivityListDataManager:GetTotalRedDotCount()
    self.activityCenterCommonRedPoint:SetNum(rewardCount, tipCount)
  else
    self.activityCenterBtn:SetActive(false)
  end
end

function UIMainTop:DelayRefreshActivityBtn()
  self.actRedDirtyFlag = true
end

local function RefreshThemeActivityBtn(self)
  if not DataCenter.ActivityListDataManager then
    return
  end
  if not self.themeActivityBtn then
    return
  end
  local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_Activity)
  if not unlock then
    self.themeActivityBtn:SetActive(false)
    return
  end
  self.themeActivityBtnEndTime = 0
  DataCenter.ActivityListDataManager:SortActivityArr()
  local list = DataCenter.ActivityListDataManager:GetNowActivityList(false)
  local themeActivityList = {}
  if not table.IsNullOrEmpty(list) then
    for k, v in pairs(list) do
      if v.hideInActivityPanel and v.is_package == ActivityEntranceType.ThemeActivity then
        table.insert(themeActivityList, v)
      end
    end
  end
  if 0 < #themeActivityList then
    self.themeActivityBtn:SetActive(true)
    local redDotCount = DataCenter.ActivityListDataManager:GetTotalThemeActivityRedDotCount()
    if 0 < redDotCount then
      self.themeActivityBtnRedPoint:SetActive(true)
      self.themeActivityBtnRedPointNum:SetText(redDotCount)
    else
      self.themeActivityBtnRedPoint:SetActive(false)
    end
    self.themeActivityBtnEndTime = themeActivityList[1].endTime
  else
    self.themeActivityBtn:SetActive(false)
  end
end

local function RefreshAllActivityBtn(self)
  self:AddDelayRefreshAllActivityBtnTimer()
end

function UIMainTop:AddDelayRefreshAllActivityBtnTimer()
  if self.delayRefreshAllActivityBtnCallback then
    self:DeleteDelayRefreshAllActivityBtnTimer()
  end
  if self.delayRefreshAllActivityBtnAdded then
    return
  end
  self.delayRefreshAllActivityBtnAdded = true
  
  function self.delayRefreshAllActivityBtnCallback()
    self:DeleteDelayRefreshAllActivityBtnTimer()
    local ok, err = pcall(function()
      RefreshActivityBtn(self)
      RefreshThemeActivityBtn(self)
      self:RefreshCoppaAppealBtn()
      self:RefreshAccountBindTipBtn()
    end)
    if not ok then
      Logger.LogError("\229\136\183\230\150\176\230\180\187\229\138\168\230\140\137\233\146\174\229\188\130\229\184\184\239\188\154", err)
    end
  end
  
  UpdateManager:GetInstance():AddLateUpdate(self.delayRefreshAllActivityBtnCallback)
end

function UIMainTop:DeleteDelayRefreshAllActivityBtnTimer()
  if self.delayRefreshAllActivityBtnCallback then
    UpdateManager:GetInstance():RemoveLateUpdate(self.delayRefreshAllActivityBtnCallback)
    self.delayRefreshAllActivityBtnCallback = nil
  end
  self.delayRefreshAllActivityBtnAdded = nil
end

function UIMainTop:OnCreate()
  base.OnCreate(self)
  local ok, errorMsg = pcall(function()
    self:ComponentDefine()
    self:DataDefine()
    self:ReqActivityData()
  end)
  if not ok and errorMsg then
    Logger.LogError(errorMsg)
  end
end

function UIMainTop:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainTop:OnEnable()
  base.OnEnable(self)
  self.active = true
end

function UIMainTop:OnDisable()
  base.OnDisable(self)
  self.active = false
end

function UIMainTop:OnBuildLevelUp()
  self:RefreshCells()
  if self.dailyPackBtn ~= nil then
    self.dailyPackBtn:RefreshShowState()
  end
end

function UIMainTop:ComponentDefine()
  self.goldBrick = self:AddComponent(UIMainGoldBrick, gold_brick_path)
  self.mainPower = self:AddComponent(UIMainPower, power_path)
  self.view:RegisterFunctionUnlock(LWFunctionUnlockType.MainUI_PowerBar, self.mainPower.gameObject)
  self.uiMainBuffList = self:AddComponent(UIMainBuffList, uiMainBuffList_path)
  self.cross_server_root = self:AddComponent(UIBaseContainer, cross_server_root_path)
  self.crossServerTip = self:AddComponent(UIBaseComponent, tip_bg_path)
  self.crossServerTipText = self:AddComponent(UIText, tip_bg_path .. "/tipText")
  self.crossServerBackHomeBtn = self:AddComponent(UIButton, tip_bg_path .. "/backHomeBtn")
  self.crossServerBackHomeBtn:SetOnClick(function()
    if LuaEntry.Player:IsInSelfServer() then
      CrossServerUtil.BackToSrcServer()
    else
      CrossServerUtil.JumpToServerByServerId(LuaEntry.Player:GetSelfServerId(), MoveCrossServerType.BackToSrcServer, LuaEntry.Player:GetMainWorldPos())
    end
  end)
  self.crossServerMaxBtn = self:AddComponent(UIButton, tip_bg_path .. "/maxBtn")
  self.crossServerMaxBtn:SetOnClick(function()
    if self.view.left then
      self.view.left:OnCrossServerMaxBtnClick()
    end
  end)
  self.cross_server_root:SetActive(false)
  self.crossServerTip:SetActive(false)
  if not IsNull(self.transform:Find(bubble_root_path)) then
    self.crossServerBubbleRoot = self:AddComponent(UIMainCrossServerBubbleTips, bubble_root_path)
    self.crossServerBubbleRoot:SetActive(false)
  end
  self.move_city_root = self:AddComponent(UIBaseContainer, move_city_root_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.btn_back_home = self:AddComponent(UIButton, btn_back_home_path)
  if not IsNull(self.transform:Find(new_bubble_root_path)) then
    self.new_bubble_root = self:AddComponent(UIMainCrossServerBubbleTips, new_bubble_root_path)
    self.new_bubble_root:SetActive(false)
  end
  self.img_progress = self:AddComponent(UIImage, img_progress_path)
  self.move_city_tip_bg = self:AddComponent(UIBaseContainer, move_city_tip_bg_path)
  self.tip_pos = self:AddComponent(UIBaseContainer, tip_pos_path)
  self.btn_tip = self:AddComponent(UIButton, btn_tip_path)
  self.move_city_root:SetActive(false)
  self.btn_back_home:SetOnClick(function()
    local selfServerId = LuaEntry.Player:GetSelfServerId()
    local curServerId = LuaEntry.Player:GetCurServerId()
    local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(curServerId)
    if isBigMapMode and not loginSameGroup then
      CrossServerUtil.JumpToServerByServerId(selfServerId, MoveCrossServerType.BackToSrcServer, LuaEntry.Player:GetMainWorldPos())
    elseif isBigMapMode and not srcSameGroup then
      CrossServerUtil.BackToSrcServer()
    elseif LuaEntry.Player:IsInSelfServer() then
      CrossServerUtil.BackToSrcServer()
    else
      CrossServerUtil.JumpToServerByServerId(selfServerId, MoveCrossServerType.BackToSrcServer, LuaEntry.Player:GetMainWorldPos())
    end
  end)
  self.btn_tip:SetOnClick(function()
    if self.new_bubble_root then
      self.new_bubble_root:ImmediatelyStop()
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMoveCityTip, {anim = false}, {
      bg = self.move_city_tip_bg.rectTransform,
      position = self.tip_pos.rectTransform.position
    })
  end)
  self.resourceCells_bar = self:AddComponent(UIBaseContainer, resource_bar_path)
  if Config.IsPC() then
    CS.RectTransformUtils.ApplyAnchorPreset(self.resourceCells_bar.rectTransform, CS.UnityEngine.TextAnchor.UpperLeft, true, true)
  end
  self.goldStoreN = self:AddComponent(UIMainGoldStore, goldStore_path)
  self.goldStoreN:SetActive(true)
  self.isOn = true
  self.rightTopBtnsRoot = self:AddComponent(UIBaseContainer, "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns")
  self.governmentBtn = self:AddComponent(UIGovernmentBtn, "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/KingActivity")
  self.attackCityBtn = self:AddComponent(UIAttackCityBtn, "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/AttackCityActivity")
  self.attackCityS0Btn = self:AddComponent(UIAttackCityS0Btn, "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/AttackCityActivityNew")
  self.kingBtn = self:AddComponent(UIKingBtn, "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/NewKingActivity")
  self.firstChargeBtn = self:AddComponent(UIFirstChargeBtn, "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/FirstChargeBtn")
  self.DoomVanguardBtn = self:AddComponent(UIDoomVanguardBtn, "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/DoomVanguardBtn")
  self.activityCenterBtn = self:AddComponent(UIBaseContainer, activityCenterBtn_path)
  self.activityCenterBtnArea = self:AddComponent(UIButton, activityCenterBtnArea_path)
  self.activityCenterBtnArea:SetOnClick(function()
    self.activityCenterCommonRedPoint:SetViewed()
    GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable)
  end)
  self.activityCenterBtnIcon = self:AddComponent(UIImage, activityCenterBtnIcon_path)
  self.activityCenterBtnText = self:AddComponent(UIText, activityCenterBtnText_path)
  self.activityCenterBtnText:SetLocalText(2000046)
  self.activityCenterCommonRedPoint = self:AddComponent(UICommonRedPoint, activityCenter_common_red_point_path)
  self.activityCenterCommonRedPoint:SetType(CommonRedPointPriority.Level1)
  self.dailyPackBtn = self:AddComponent(UIDailyPackBtn, dailyPackBtn_path)
  self.topBtns = self:AddComponent(UIBaseContainer, topBtns_path)
  self.popupPackageBtn = self:AddComponent(UIMainPopupPackEntrance, popupPackageBtnTemplate_path)
  self.themeActivityBtn = self:AddComponent(UIBaseContainer, themeActivityBtn_path)
  self.themeActivityBtnArea = self:AddComponent(UIButton, themeActivityBtnArea_path)
  self.themeActivityBtnArea:SetOnClick(function()
    GoToUtil.GotoOpenView(UIWindowNames.UIThemeActivityTable)
  end)
  self.themeActivityBtnText = self:AddComponent(UIText, themeActivityBtnText_path)
  self.themeActivityBtnRedPoint = self:AddComponent(UIBaseContainer, themeActivityBtnRedPoint_path)
  self.themeActivityBtnRedPointNum = self:AddComponent(UIText, themeActivityBtnRedPointNum_path)
  self.view:RegisterFunctionUnlock(LWFunctionUnlockType.MainUI_GoldBar, self.goldStoreN.gameObject)
  self.view:RegisterFunctionUnlock(LWFunctionUnlockType.MainUI_FirstPay, self.firstChargeBtn.gameObject)
  self.gift_box_activity_btn = self:AddComponent(UIMainGiftBoxActivityBtn, enter_gift_box_activity_path)
  self.gift_box_activity_btn:SetActive(false)
  self.thanks_giving_activity_btn = self:AddComponent(UIMainThanksGivingActivityBtn, enter_thanks_giving_activity_path)
  self.thanks_giving_activity_btn:SetActive(false)
  self.ui_main_activity_group_content = self:AddComponent(UIMainActivityGroupContent, ui_main_activity_group_content_path)
  self.scratch_activity_btn = self:AddComponent(UIMainScratchActivityBtn, enter_scratch_activity_path)
  self.scratch_activity_btn:SetActive(false)
  self.piggy_bank_btn = self:AddComponent(UIMainPiggyBankBtn, piggy_bank_btn_path)
  self.piggy_bank_btn:SetActive(false)
  self.allyDuelBtn = self:AddComponent(UIMainAllyDuelBtn, "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/AllyDuel")
  self.actMeteoriteBtn = self:AddComponent(UIMainActMeteoriteBtn, "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/ActMeteoriteBtn")
  self.actMigrationBtn = self:AddComponent(UIMainActMigrationBtn, "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/ActMigrationBtn")
  self.actLandlordBackBtn = self:AddComponent(UIMainActLandlordBackBtn, "TopBtnsContainer/RightColBtns/Viewport/RightTopBtns/ActLandlordBackBtn")
  self.infiniteGiftBtn = self:AddComponent(UIMainInfiniteGiftBtn, infiniteGift_btn_path)
  self.dialyPackNew = self:AddComponent(UIBaseContainer, dialyPack_new_tag_path)
  self.meteoriteNoticeRoot = self.transform:Find(meteorite_notice_root_path)
  if IsNotNull(self.meteoriteNoticeRoot) then
    self.meteoriteNoticeRoot.gameObject:SetActive(false)
  end
  self.activityTips = self:AddComponent(UIMainActivityTips, "TopBtnsContainer/ActivityTips")
  self.accountBindTipBtn = self:AddComponent(UIMainAccountBindTipBtn, account_bind_tip_btn_path)
  self.accountBindTipBtn:SetActive(false)
  self.coppaAppealBtn = self:AddComponent(UIMainCoppaAppealBtn, coppa_appeal_btn_path)
  self.coppaAppealBtn:SetActive(false)
  self.zone_mobilization_btn = self:AddComponent(ActZoneMobilizationItem, zone_mobilization_btn_path)
  self.alarmClockDispatch = self:AddComponent(LWMainUIActivityAlarmClockDispatch, "")
  self.resourceLayout = self:AddComponent(UIBaseContainer, resourceLayout_path)
end

function UIMainTop:ComponentDestroy()
  self.resourceCells_bar = nil
  self.goldStoreN = nil
  self.firstChargeBtn = nil
  self.governmentBtn = nil
  self.attackCityBtn = nil
  self.attackCityS0Btn = nil
  self.kingBtn = nil
  self.SeasonBtn = nil
  self.OffSeasonBtn = nil
  self.DoomVanguardBtn = nil
  self.farmerBtn = nil
  self.activityCenterBtn = nil
  self.activityCenterBtnIcon = nil
  self.activityCenterBtnArea = nil
  self.activityCenterBtnText = nil
  self.activityCenterCommonRedPoint = nil
  self.themeActivityBtn = nil
  self.themeActivityBtnArea = nil
  self.themeActivityBtnText = nil
  self.themeActivityBtnRedPoint = nil
  self.themeActivityBtnRedPointNum = nil
  self.dailyPackBtn = nil
  self.topBtns = nil
  self.popupPackageBtn = nil
  self.activityGotoTip = nil
  self.activityGotoTipText = nil
  self.activityGotoTipGotoBtn = nil
  self.jumpAction = nil
  self.meteoriteNotice = nil
  self.seasonResDownload = nil
  self.rightTopBtnsRoot = nil
  self.zone_mobilization_btn = nil
  self.dominatorCockatriceUnlockBtn = nil
  self.move_city_root = nil
  self.img_icon = nil
  self.tip_text = nil
  self.txt_time = nil
  self.btn_back_home = nil
  self.tip_pos = nil
  self.img_progress = nil
  self.move_city_tip_bg = nil
  self.btn_tip = nil
  self.new_bubble_root = nil
  self:DestroyActivityAlarmClockView()
  self:DestroyCityFightAlarmView()
  self:DestroyDominatorEntrance()
  self.resourceLayout = nil
  self.alarmClockDispatch = nil
end

function UIMainTop:DataDefine()
  self.showList = {}
  self.needWaitLoadCount = 0
  self.resourceCells = {}
  self.itemCells = {}
  self.resourceItemCells = {}
  self.allianceItemCells = {}
  self.showGoldStore = true
  self.cacheGoldStoreType = nil
  
  function self.delay_refresh_resource_timer_action()
    self:DelayRefreshResourceTimerBallBack()
  end
  
  self.delayRefreshResourceTimer = nil
  self.isInPve = false
  self.prevStrComRedPointCount = 0
  self.sortedActivityCheckerList = {}
  self.themeActivityBtnTextStr = nil
  self.actRedDirtyFlag = false
  self.loadCount = 0
  self.resourceCount = 0
  self.delayRefreshAllActivityBtnCallback = nil
  self.delayRefreshAllActivityBtnAdded = nil
end

function UIMainTop:DataDestroy()
  self.allianceItemCells = {}
  self.sortedActivityCheckerList = {}
  self.delay_refresh_resource_timer_action = nil
  self.prevStrComRedPointCount = 0
  self.jumpAction = nil
  self.actRedDirtyFlag = nil
  self.loadCount = nil
  self.resourceCount = nil
  self:DeleteDelayRefreshAllActivityBtnTimer()
end

function UIMainTop:ReqActivityData()
  DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(4)
end

function UIMainTop:ReInit()
  self:DeleteDelayRefreshResourceTimer()
  self.goldStoreN:ReInit()
  self:DeleteDelayRefreshAllActivityBtnTimer()
  local param = {}
  param.list = ResetResourceType
  param.uiName = UIWindowNames.UIMain .. "Default"
  self.showList = {param}
  self:RefreshCells()
  RefreshAllActivityBtn(self)
  RefreshPackInfo(self)
  self:RefreshCoppaAppealBtn()
  self:RefreshCrossServerTip()
  self.uiMainBuffList:RefreshBuff()
  self.mainPower:ReInit()
  self:RefreshShowActivityAlarmClockView()
  self:RefresSeasonResourceDownloadBtn()
  self:RefreshZoneMobilizationAct()
  self:RefreshDominatorEntrance()
end

function UIMainTop:GetPowerPosition()
  return self.mainPower.imgPowerIcon.gameObject.transform.position
end

function UIMainTop:OnGoldBrickUpdate()
  if self.goldBrick then
    local status = self.goldBrick:GetActive()
    self.goldBrick:Refresh()
    if self.goldBrick:GetActive() ~= status then
      self:RefreshCells()
    end
  end
end

function UIMainTop:RefreshCrossServerTip()
  local player = LuaEntry.Player
  local mySourceServerId = player:GetSourceServerId()
  local loginServerId = player:GetSelfServerId()
  local curServerId = player:GetCurServerId()
  local curScene = CS.SceneManager.CurrSceneID
  local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(curServerId)
  if self.view.left and self.view.left:IsAnyBattleFieldSmallShow() then
    self.move_city_root:SetActive(false)
    self.cross_server_root:SetActive(true)
    self.crossServerTip:SetActive(true)
    self.crossServerBackHomeBtn:SetActive(false)
    self.crossServerMaxBtn:SetActive(true)
    self.crossServerTipText:SetLocalText("Desert_strom_tips1028")
  elseif isBigMapMode and srcSameGroup and loginSameGroup then
    self.move_city_root:SetActive(false)
    self.cross_server_root:SetActive(false)
    self.crossServerTip:SetActive(false)
    self.crossServerMaxBtn:SetActive(false)
  elseif (curServerId ~= mySourceServerId or loginServerId ~= mySourceServerId) and curScene == SceneManagerSceneID.World or loginServerId ~= mySourceServerId and curScene == SceneManagerSceneID.City then
    self.cross_server_root:SetActive(false)
    self.move_city_root:SetActive(true)
    self.tip_text:SetLocalText("world_cross_teleport_tips_1004", curServerId)
    local canMoveCity = MoveCityUtil.CanMoveCity()
    self.img_progress:SetActive(canMoveCity)
    local cdTime, cd = CrossServerUtil.GetCrossMoveCD()
    local canShowCd = 0 < cdTime and canMoveCity
    self.img_progress:SetFillAmount(canShowCd and 1 - cdTime / cd or 1)
    self.txt_time:SetActive(canShowCd)
    if canShowCd then
      self.txt_time:SetText(UITimeManager:GetInstance():GetFormattedTime(cdTime / 1000))
    end
  else
    self.move_city_root:SetActive(false)
    self.cross_server_root:SetActive(false)
    self.crossServerTip:SetActive(false)
    self.crossServerMaxBtn:SetActive(false)
  end
  self.uiMainBuffList:RefreshBuff()
end

function UIMainTop:DelayRefreshResource(time)
  self:AddDelayRefreshResourceTimer(time)
end

function UIMainTop:AddDelayRefreshResourceTimer(time)
  self:DeleteDelayRefreshResourceTimer()
  self.delayRefreshResourceTimer = TimerManager:GetInstance():GetTimer(time, self.delay_refresh_resource_timer_action, self, true, false, false)
  self.delayRefreshResourceTimer:Start()
end

function UIMainTop:RefreshResource()
  if self.isInPve == true then
    return
  end
  if self.delayRefreshResourceTimer == nil then
    self:RefreshCells()
    for k, v in pairs(self.resourceCells) do
      if v.model ~= nil then
        v.model:Refresh()
      end
    end
  end
end

function UIMainTop:RefreshCells()
  self.needWaitLoadCount = 0
  local count = table.count(self.showList)
  local param = self.showList[count]
  local have = {}
  local needRemove = {}
  local inSeason = false
  local seasonType = SeasonMapType.Nothing
  local info = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if info then
    inSeason = info:ServerInReady() and info:InNormalMode()
    if inSeason then
      seasonType = info:GetServerType(false)
    end
  end
  if param.list ~= nil then
    for k, v in ipairs(param.list) do
      local unlocked = true
      local funcUnlockID = ResourceType2FuncUnlockID[v]
      if funcUnlockID ~= nil then
        unlocked = DataCenter.LWFunctionUnlockManager:CheckCanShow(funcUnlockID)
      end
      if not inSeason and (ResourceType.OBSIDIAN == v or ResourceType.FLINT == v) then
        unlocked = false
      elseif seasonType ~= SeasonMapType.Nothing and CS.SDKManager.IS_UNITY_EDITOR() then
        unlocked = true
      elseif ResourceType.OBSIDIAN == v and LuaEntry.Resource:GetCntByResType(v) == 0 then
        unlocked = false
      elseif ResourceType.FLINT == v and LuaEntry.Resource:GetCntByResType(v) == 0 then
        unlocked = false
      end
      if unlocked then
        have[v] = true
        self:AddOneResourceCell(v, false)
      end
    end
  end
  for k, v in pairs(self.resourceCells) do
    if not have[v.param.resourceType] then
      table.insert(needRemove, k)
    end
  end
  for k, v in ipairs(needRemove) do
    self:RemoveOneResourceCell(v)
  end
  have = {}
  needRemove = {}
  if param.allianceList ~= nil then
    for k, v in ipairs(param.allianceList) do
      have[v] = true
      self:AddOneAllianceItemCell(v)
    end
  end
  for k, v in pairs(self.allianceItemCells) do
    if not have[v.param.aItemType] then
      table.insert(needRemove, k)
    end
  end
  for k, v in ipairs(needRemove) do
    self:RemoveOneAllianceItemCell(v)
  end
  self:CheckLoadCount()
end

function UIMainTop:AddOneResourceCell(resourceType, showExpandAnimation, showExpandParam)
  local param = {}
  param.resourceType = resourceType
  if resourceType ~= ResourceType.BatteryPower then
    param.iconName = self.view.ctrl:GetResourceIconName(resourceType, true)
  end
  param.showExpandAnimation = showExpandAnimation
  param.showExpandParam = showExpandParam
  param.parent = self
  if self.resourceCells[resourceType] == nil then
    self.resourceCells[resourceType] = {}
  end
  self.resourceCells[resourceType].param = param
  if self.resourceCells[resourceType].model ~= nil then
    self.resourceCells[resourceType].model:ChangeParam(param)
  elseif self.resourceCells[resourceType].inst == nil then
    self.needWaitLoadCount = self.needWaitLoadCount + 1
    self.resourceCells[resourceType].inst = self:GameObjectInstantiateAsync(UIAssets.UIMainTopResourceCell, function(request)
      self.needWaitLoadCount = self.needWaitLoadCount - 1
      if request.isError then
        self.resourceCells[resourceType] = nil
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.resourceCells_bar.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_sizeDelta(166, 52)
      local nameStr = tostring(resourceType)
      go.name = nameStr
      local model = self.resourceCells_bar:AddComponent(UIMainResourceProgress, nameStr)
      self.resourceCells[resourceType].model = model
      model:ReInit(self.resourceCells[resourceType].param)
      go.transform:SetSiblingIndex(ResourceCellIndexStart)
      self.loadCount = self.loadCount + 1
      self:CheckLoadCount()
    end)
  else
    self.needWaitLoadCount = self.needWaitLoadCount + 1
  end
end

function UIMainTop:RemoveOneResourceCell(id)
  if self.resourceCells[id] ~= nil then
    if self.resourceCells[id].model ~= nil then
      self.resourceCells_bar:RemoveComponent(tostring(id), UIMainResourceProgress)
      self.resourceCells[id].model:OnDestroy()
    end
    if self.resourceCells[id].inst ~= nil then
      self:GameObjectDestroy(self.resourceCells[id].inst)
    end
    self.resourceCells[id] = nil
  end
end

function UIMainTop:SetOneResourceCellActive(resourceType, active)
  if resourceType == ResourceType.GoldBrick then
    if self.goldBrick then
      local showGoldBrick = self.goldBrick:ShouldShow()
      if showGoldBrick then
        self.goldBrick:SetActive(active)
      end
    end
    return
  end
  if self.resourceCells[resourceType] ~= nil and self.resourceCells[resourceType].model ~= nil then
    self.resourceCells[resourceType].model:SetActive(active)
  end
end

function UIMainTop:AddOneAllianceItemCell(aItemType)
  local param = {}
  param.aItemType = aItemType
  if self.allianceItemCells[aItemType] == nil then
    self.allianceItemCells[aItemType] = {}
  end
  self.allianceItemCells[aItemType].param = param
  if self.allianceItemCells[aItemType].model ~= nil then
    self.allianceItemCells[aItemType].model:ChangeParam(param)
  elseif self.allianceItemCells[aItemType].inst == nil then
    self.needWaitLoadCount = self.needWaitLoadCount + 1
    self.allianceItemCells[aItemType].inst = self:GameObjectInstantiateAsync(UIAssets.UIMainTopResourceCell, function(request)
      self.needWaitLoadCount = self.needWaitLoadCount - 1
      if request.isError then
        self.allianceItemCells[aItemType] = nil
        return
      end
      local go = request.gameObject
      self.resourceCount = 0
      for _, v in pairs(self.resourceCells) do
        self.resourceCount = self.resourceCount + 1
      end
      AllianceCellIndexStart = self.resourceCount
      local parent = self.resourceCells_bar
      if self.resourceCount and self.resourceCount >= 5 and self.resourceLayout then
        parent = self.resourceLayout
      end
      go.transform:SetParent(parent.transform, false)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.resourceLayout.rectTransform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(aItemType)
      go.name = nameStr
      local model = parent:AddComponent(UIMainItemProgress, nameStr)
      self.allianceItemCells[aItemType].model = model
      model:ReInit(self.allianceItemCells[aItemType].param)
      self:CheckLoadCount()
    end)
  else
    self.needWaitLoadCount = self.needWaitLoadCount + 1
  end
end

function UIMainTop:RemoveOneAllianceItemCell(id)
  if self.allianceItemCells[id] ~= nil then
    if self.allianceItemCells[id].model ~= nil then
      self.resourceCells_bar:RemoveComponent(tostring(id), UIMainItemProgress)
      self.resourceLayout:RemoveComponent(tostring(id), UIMainItemProgress)
      self.allianceItemCells[id].model:OnDestroy()
    end
    if self.allianceItemCells[id].inst ~= nil then
      self:GameObjectDestroy(self.allianceItemCells[id].inst)
    end
    self.allianceItemCells[id] = nil
  end
end

function UIMainTop:CheckLoadCount()
  local count = table.count(self.showList)
  if 0 < count then
    local param = self.showList[count]
    for k, v in ipairs(param.list) do
      if self.resourceCells[v] ~= nil and self.resourceCells[v].model ~= nil then
        self.resourceCells[v].model.transform:SetSiblingIndex(ResourceCellIndexStart)
      end
    end
    if param.allianceList ~= nil then
      for k, v in ipairs(param.allianceList) do
        if self.allianceItemCells[v] ~= nil and self.allianceItemCells[v].model ~= nil then
          self.allianceItemCells[v].model.transform:SetSiblingIndex(AllianceCellIndexStart)
        end
      end
    end
    self.resourceCount = 0
    for _, v in pairs(self.resourceCells) do
      self.resourceCount = self.resourceCount + 1
    end
    if CommonUtil.IsArabicAutoMirrorOpen() and self.loadCount == self.resourceCount then
      if self.resourceCount > 3 and self.resourceCount < 5 then
        self.goldBrick.gameObject.transform:SetParent(self.resourceCells_bar.transform, false)
        self.goldBrick.transform:SetSiblingIndex(ArabicResourceCellIndexStart1)
      end
      self.loadCount = 0
    end
    if self.resourceCount and self.resourceCount >= 5 and self.resourceLayout then
      self.goldBrick.gameObject.transform:SetParent(self.resourceLayout.transform, false)
    end
    self.resourceCount = 0
  end
end

function UIMainTop:DelayRefreshResourceTimerBallBack()
  self:DeleteDelayRefreshResourceTimer()
  self:RefreshCells()
end

function UIMainTop:DeleteDelayRefreshResourceTimer()
  if self.delayRefreshResourceTimer ~= nil then
    self.delayRefreshResourceTimer:Stop()
    self.delayRefreshResourceTimer = nil
  end
end

function UIMainTop:Update1000MS()
  if SceneUtils.GetIsInWorld() then
    local theSeasonType = SeasonUtil.GetSeasonType()
    if theSeasonType == SeasonMapType.CityStronghold or theSeasonType == SeasonMapType.Snow or theSeasonType == SeasonMapType.Darkness then
      local x, y = self.resourceCells_bar.rectTransform:Get_sizeDelta()
      if self.resourceCells_bar_height ~= y then
        self.resourceCells_bar_height = y
        EventManager:GetInstance():Broadcast(EventId.PostLayoutSizeChanged, {
          t = LayoutSizeChangeType.MainUIResourceBar,
          w = x,
          h = y
        })
      end
    end
  end
  if self.actRedDirtyFlag then
    self.actRedDirtyFlag = false
    self:RefreshUIMainActivityGroupContent()
  end
  if self.txt_time:GetActive() then
    local cdTime = CrossServerUtil.GetCrossMoveCD()
    local canShowCd = 0 < cdTime
    self.txt_time:SetActive(canShowCd)
    if canShowCd then
      self.txt_time:SetText(UITimeManager:GetInstance():GetFormattedTime(cdTime / 1000))
    end
  end
end

function UIMainTop:Update()
  if self.themeActivityBtnEndTime and self.themeActivityBtnEndTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local timeLeft = self.themeActivityBtnEndTime - curTime
    if 0 < timeLeft then
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(timeLeft)
      self:SetThemeActivityBtnText(timeStr)
    else
      self:SetThemeActivityBtnText("")
    end
  else
    self:SetThemeActivityBtnText("")
  end
  if self.img_progress:GetActive() then
    local cdTime, cd = CrossServerUtil.GetCrossMoveCD()
    self.img_progress:SetFillAmount(0 < cdTime and 1 - cdTime / cd or 1)
  end
end

function UIMainTop:SetThemeActivityBtnText(str)
  if self.themeActivityBtnTextStr ~= str then
    self.themeActivityBtnTextStr = str
    self.themeActivityBtnText:SetText(str)
  end
end

function UIMainTop:GetResourcePos(resourceType)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.resourceCells_bar.rectTransform)
  if self.resourceCells[resourceType] ~= nil and self.resourceCells[resourceType].model ~= nil then
    return self.resourceCells[resourceType].model:GetResourcePos()
  end
  if self.itemCells[resourceType] ~= nil and self.itemCells[resourceType].model ~= nil then
    return self.itemCells[resourceType].model:GetResourcePos()
  end
  return self.resourceCells_bar.transform.position
end

function UIMainTop:GetAllianceItemPos(aItemType)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.resourceCells_bar.rectTransform)
  if self.allianceItemCells[aItemType] ~= nil and self.allianceItemCells[aItemType].model ~= nil then
    return self.allianceItemCells[aItemType].model:GetResourcePos()
  end
  local alBtnPos = UIUtil.GetUIMainSavePos(UIMainSavePosType.AllianceBtn)
  if alBtnPos ~= nil then
    return alBtnPos
  end
  return self.resourceCells_bar.transform.position
end

function UIMainTop:GetGoodsPos()
  return self.goldStoreN.transform.position
end

function UIMainTop:GetGoldBtnPos()
  return self.goldStoreN.transform.position
end

function UIMainTop:GetGoldBrickPos()
  return self.goldBrick:GetTargetPos()
end

function UIMainTop:OnQueryLayoutSize(data)
  if data ~= nil and data.t == LayoutSizeChangeType.MainUIResourceBar and type(data.f) == "function" then
    local x, y = self.resourceCells_bar.rectTransform:Get_sizeDelta()
    pcall(data.f, x, y)
  end
end

function UIMainTop:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.QueryLayoutSize, self.OnQueryLayoutSize)
  self:AddUIListener(EventId.OnPackageInfoUpdated, RefreshPackInfo)
  self:AddUIListener(EventId.RefreshWelfareRedDot, RefreshChargeBtnRedPoint)
  self:AddUIListener(EventId.MainLvUp, self.OnMainLevelUp)
  self:AddUIListener(EventId.MainTaskSuccess, RefreshAllActivityBtn)
  self:AddUIListener(EventId.MainTaskUpdate, RefreshAllActivityBtn)
  self:AddUIListener(EventId.RefreshActivityRedDot, RefreshAllActivityBtn)
  self:AddUIListener(EventId.BuildLevelUp, RefreshAllActivityBtn)
  self:AddUIListener(EventId.UpdateFirstPayState, RefreshFristPayBtn)
  self:AddUIListener(EventId.RefreshActivityDetailData, RefreshAllActivityBtn)
  self:AddUIListener(EventId.DragonInfoRefresh, RefreshAllActivityBtn)
  self:AddUIListener(EventId.OnAllyDrillStageChange, RefreshAllActivityBtn)
  self:AddUIListener(EventId.CrossKingScheduleRefresh, RefreshAllActivityBtn)
  self:AddUIListener(EventId.ActGiftBoxOpen, RefreshAllActivityBtn)
  self:AddUIListener(EventId.ActGiftBoxDel, RefreshAllActivityBtn)
  self:AddUIListener(EventId.OnRecvNewActivityInfo, RefreshAllActivityBtn)
  self:AddUIListener(EventId.OnFunctionOnAnimFinsh, RefreshActivityBtn)
  self:AddUIListener(EventId.OnEnterWorld, self.OnEnterWorld)
  self:AddUIListener(EventId.OnEnterCity, self.OnEnterCity)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
  self:AddUIListener(EventId.GoldBrickUpdate, self.OnGoldBrickUpdate)
  self:AddUIListener(EventId.ShowCrossServerTip, self.RefreshCrossServerTip)
  self:AddUIListener(EventId.ShowCrossServerBubbleTips, self.OnShowCrossServerBubbleTips)
  self:AddUIListener(EventId.AccountBindTipChanged, self.OnAccountBindTipChanged)
  self:AddUIListener(EventId.GetActivityAlarmClockData, self.RefreshShowActivityAlarmClockView)
  self:AddUIListener(EventId.UpdateActivityAlarmClockData, self.RefreshShowActivityAlarmClockView)
  self:AddUIListener(EventId.CityFightAlarm, self.RefreshShowCityFightAlarmView)
  self:AddUIListener(EventId.LWUnpackResourceRewardUpdate, self.RefresSeasonResourceDownloadBtn)
  self:AddUIListener(EventId.GetZoneMobilizationInfoData, self.RefreshZoneMobilizationAct)
  self:AddUIListener(EventId.ReceivePushRequestZoneMobilizationData, self.OnReceivePushMsgRequestZoneMobilizationData)
  self:AddUIListener(EventId.LWSeasonResourceDownloadStart, self.RefresSeasonResourceDownloadBtn)
  self:AddUIListener(EventId.SeasonStatusChanged, self.RefresSeasonResourceDownloadBtn)
  self:AddUIListener(EventId.ActMigrationInfoUpdate, self.RefreshAlCompeteBtn)
  self:AddUIListener(EventId.AllyDuelScoreGachaGotData, self.RefreshAlCompeteBtn)
  self:AddUIListener(EventId.MeteoriteBattleNotice, self.RefreshMeteoriteNotice)
  self:AddUIListener(EventId.UseItemSuccess, self.DelayRefreshActivityBtn)
  self:AddUIListener(EventId.DominatorCommonGuideProgressChanged, self.RefreshDominatorEntrance)
  self:AddUIListener(EventId.UIPrivacy_Confirm, self.RefreshCoppaAppealBtn)
  self:AddUIListener(EventId.LandlordCurServerChanged, self.RefreshAlCompeteBtn)
  self:AddUIListener(EventId.LandlordCenterStateChange, self.RefreshAlCompeteBtn)
end

function UIMainTop:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.QueryLayoutSize, self.OnQueryLayoutSize)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, RefreshPackInfo)
  self:RemoveUIListener(EventId.RefreshWelfareRedDot, RefreshChargeBtnRedPoint)
  self:RemoveUIListener(EventId.MainLvUp, self.OnMainLevelUp)
  self:RemoveUIListener(EventId.MainTaskSuccess, RefreshAllActivityBtn)
  self:RemoveUIListener(EventId.MainTaskUpdate, RefreshAllActivityBtn)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, RefreshAllActivityBtn)
  self:RemoveUIListener(EventId.BuildLevelUp, RefreshAllActivityBtn)
  self:RemoveUIListener(EventId.UpdateFirstPayState, RefreshFristPayBtn)
  self:RemoveUIListener(EventId.RefreshActivityDetailData, RefreshAllActivityBtn)
  self:RemoveUIListener(EventId.DragonInfoRefresh, RefreshAllActivityBtn)
  self:RemoveUIListener(EventId.OnAllyDrillStageChange, RefreshAllActivityBtn)
  self:RemoveUIListener(EventId.CrossKingScheduleRefresh, RefreshAllActivityBtn)
  self:RemoveUIListener(EventId.ActGiftBoxOpen, RefreshAllActivityBtn)
  self:RemoveUIListener(EventId.ActGiftBoxDel, RefreshAllActivityBtn)
  self:RemoveUIListener(EventId.OnRecvNewActivityInfo, RefreshAllActivityBtn)
  self:RemoveUIListener(EventId.OnFunctionOnAnimFinsh, RefreshActivityBtn)
  self:RemoveUIListener(EventId.OnEnterWorld, self.OnEnterWorld)
  self:RemoveUIListener(EventId.OnEnterCity, self.OnEnterCity)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  self:RemoveUIListener(EventId.GoldBrickUpdate, self.OnGoldBrickUpdate)
  self:RemoveUIListener(EventId.ShowCrossServerTip, self.RefreshCrossServerTip)
  self:RemoveUIListener(EventId.ShowCrossServerBubbleTips, self.OnShowCrossServerBubbleTips)
  self:RemoveUIListener(EventId.AccountBindTipChanged, self.OnAccountBindTipChanged)
  self:RemoveUIListener(EventId.GetActivityAlarmClockData, self.RefreshShowActivityAlarmClockView)
  self:RemoveUIListener(EventId.UpdateActivityAlarmClockData, self.RefreshShowActivityAlarmClockView)
  self:RemoveUIListener(EventId.CityFightAlarm, self.RefreshShowCityFightAlarmView)
  self:RemoveUIListener(EventId.LWUnpackResourceRewardUpdate, self.RefresSeasonResourceDownloadBtn)
  self:RemoveUIListener(EventId.GetZoneMobilizationInfoData, self.RefreshZoneMobilizationAct)
  self:RemoveUIListener(EventId.ReceivePushRequestZoneMobilizationData, self.OnReceivePushMsgRequestZoneMobilizationData)
  self:RemoveUIListener(EventId.LWSeasonResourceDownloadStart, self.RefresSeasonResourceDownloadBtn)
  self:RemoveUIListener(EventId.SeasonStatusChanged, self.RefresSeasonResourceDownloadBtn)
  self:RemoveUIListener(EventId.ActMigrationInfoUpdate, self.RefreshAlCompeteBtn)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaGotData, self.RefreshAlCompeteBtn)
  self:RemoveUIListener(EventId.MeteoriteBattleNotice, self.RefreshMeteoriteNotice)
  self:RemoveUIListener(EventId.UseItemSuccess, self.DelayRefreshActivityBtn)
  self:RemoveUIListener(EventId.DominatorCommonGuideProgressChanged, self.RefreshDominatorEntrance)
  self:RemoveUIListener(EventId.UIPrivacy_Confirm, self.RefreshCoppaAppealBtn)
  self:RemoveUIListener(EventId.LandlordCurServerChanged, self.RefreshAlCompeteBtn)
  self:RemoveUIListener(EventId.LandlordCenterStateChange, self.RefreshAlCompeteBtn)
end

function UIMainTop:RefreshSeasonBtnShow()
  local flag = false
  if self.SeasonBtn ~= nil then
    flag = self.SeasonBtn:RefreshShowState()
  end
  if self.OffSeasonBtn ~= nil then
    self.OffSeasonBtn:RefreshShowState(flag)
  end
  if self.farmerBtn ~= nil then
    self.farmerBtn:RefreshShowState()
  end
  if self.KingBattleBtn ~= nil then
    self.KingBattleBtn:RefreshShowState()
  end
end

function UIMainTop:OnEnterWorld()
  if self.governmentBtn ~= nil then
    self.governmentBtn:RefreshShowState()
  end
  if self.kingBtn ~= nil then
    self.kingBtn:RefreshShowState()
  end
  self:RefreshSeasonBtnShow()
end

function UIMainTop:OnEnterCity()
  self:RefreshCoppaAppealBtn()
  self.actLandlordBackBtn:RefreshBtn()
end

function UIMainTop:UpdateWhenAnim(animName)
  if animName == UIMainAnimType.LeftRightBottomHide then
    self.uiMainBuffList:SetListVisible(false)
    self.uiMainBuffList:SetRootActive(false)
    self.mainPower:SetActive(false)
    self.cross_server_root:SetActive(false)
    self.crossServerTip:SetActive(false)
  elseif animName and animName ~= UIMainAnimType.AllHide then
    self.mainPower:SetActive(DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_PowerBar))
    self:RefreshCrossServerTip()
  end
  if animName == UIMainAnimType.AllHide or animName == UIMainAnimType.LeftRightBottomHide then
    self.activityTips:InterruptTips()
  end
end

function UIMainTop:RefreshPopupPackageEntrances()
  local showRecharegs = WelfareController.GetPopupPackages(RechargeEntryType.MainUIPop)
  self.popupRecharges = showRecharegs
  if table.IsNullOrEmpty(showRecharegs) then
    if self.popupPackageBtn ~= nil then
      self.popupPackageBtn:SetActive(false)
    end
    return
  end
  if self.popupPackageBtn ~= nil then
    self.popupPackageBtn:SetActive(true)
    self.popupPackageBtn:SetEntrance(self.popupRecharges)
  end
end

function UIMainTop:RefreshAllianceItemSignal()
  for k, v in pairs(self.allianceItemCells) do
    if v.model ~= nil then
      v.model:Refresh()
    end
  end
end

function UIMainTop:ShowExtraResource(data)
  self:RemoveListParamByUIName(data.uiName)
  local hasAdd = {}
  local param = {}
  param.list = {}
  param.uiName = data.uiName
  param.itemList = data.itemList
  param.resourceItemList = data.resourceItemList
  param.allianceList = data.allianceList
  param.noUseResetResource = data.noUseResetResource
  param.hideBtnList = data.hideBtnList
  param.hideResList = data.hideResList
  if param.hideBtnList ~= nil then
    for k, v in ipairs(param.hideBtnList) do
      self:SetBtnVisible(v, false)
    end
  end
  if param.hideResList ~= nil then
    for k, v in ipairs(param.hideResList) do
      self:SetOneResourceCellActive(v, false)
    end
  end
  if not param.noUseResetResource then
    for k, v in ipairs(ResetResourceType) do
      if hasAdd[v] == nil then
        hasAdd[v] = true
        table.insert(param.list, v)
      end
    end
  end
  if data.list ~= nil then
    for k, v in ipairs(data.list) do
      if hasAdd[v] == nil then
        hasAdd[v] = true
        table.insert(param.list, v)
      end
    end
  end
  table.sort(param.list, function(a, b)
    if UIMainResourceSort[a] == nil then
      return false
    end
    if UIMainResourceSort[b] == nil then
      return true
    end
    return UIMainResourceSort[a] > UIMainResourceSort[b]
  end)
  table.insert(self.showList, param)
  self.uiMainBuffList:SetRootActive(false)
  self.cross_server_root:SetActive(false)
  self:RefreshCells()
end

function UIMainTop:HideExtraResource(uiName)
  self:RemoveListParamByUIName(uiName)
  if uiName == UIWindowNames.UIFarm or uiName == UIWindowNames.UIFarmGather or uiName == "BuildTimeTip" then
    self:DelayRefreshResource(HideExtraResourceDelayTime)
  else
    self:RefreshCells()
    self:RefreshCrossServerTip()
    self.uiMainBuffList:RefreshBuff()
  end
end

function UIMainTop:RemoveListParamByUIName(uiName)
  local removeIndex, param
  for k, v in ipairs(self.showList) do
    if v.uiName == uiName then
      param = v
      removeIndex = k
      break
    end
  end
  if removeIndex ~= nil then
    table.remove(self.showList, removeIndex)
  end
  if param ~= nil then
    if param.hideBtnList ~= nil then
      for k, v in ipairs(param.hideBtnList) do
        self:SetBtnVisible(v, true)
      end
    end
    if param.hideResList ~= nil then
      for k, v in ipairs(param.hideResList) do
        self:SetOneResourceCellActive(v, true)
      end
    end
  end
end

function UIMainTop:SetBtnVisible(btnType, visible)
  if self:CanControlVisibleByBtnType(btnType) then
    local btn = self:GetBtnByBtnType(btnType)
    if btn ~= nil then
      btn:SetActive(visible)
    end
  end
end

function UIMainTop:CanControlVisibleByBtnType(btnType)
  if btnType == UIMainTopBtnType.Stamina then
    return true
  elseif btnType == UIMainTopBtnType.Goods then
    return self.view.ctrl:IsShowUIMainMiddleLevel()
  elseif btnType == UIMainTopBtnType.Gold then
    return DataCenter.UnlockBtnManager:IsShowBtn(UnlockBtnType.Resource)
  end
  return true
end

function UIMainTop:GetBtnByBtnType(btnType)
  if btnType == UIMainTopBtnType.Stamina then
    return nil
  elseif btnType == UIMainTopBtnType.Goods then
    return nil
  elseif btnType == UIMainTopBtnType.Gold then
    return nil
  end
end

function UIMainTop:RefreshAlCompeteBtn()
  self.allyDuelBtn:RefreshAlCompeteBtn()
  self.actMeteoriteBtn:RefreshAlCompeteBtn()
  self.actMigrationBtn:RefreshAlCompeteBtn()
  self.actLandlordBackBtn:RefreshBtn()
end

local function RefreshMeteoriteNoticeComp(comp)
  if not comp then
    return
  end
  local currenrNotice = DataCenter.ActMeteoriteBattleManager:GetCurrentNotice()
  if not currenrNotice then
    comp:Close()
    return
  end
  if comp then
    comp:Refresh(currenrNotice)
  end
end

function UIMainTop:RefreshMeteoriteNotice()
  if IsNull(self.meteoriteNoticeRoot) then
    return
  end
  local battleInfo = DataCenter.ActMeteoriteBattleManager:GetBattleWorldInfo()
  if not battleInfo then
    if self.meteoriteNotice then
      self.meteoriteNotice:Close()
    else
      self.meteoriteNoticeRoot.gameObject:SetActive(false)
    end
  elseif not self.meteoriteNotice then
    self.meteoriteNotice = self:LoadComponentAsync(MeteoriteBattleUtils.NoticeItemRenderLuaPath, UIAssets.UIMeteoriteNoticeItemRenderer, self.meteoriteNoticeRoot, function()
      RefreshMeteoriteNoticeComp(self.meteoriteNotice)
    end, nil, self.meteoriteNoticeRoot.gameObject)
  else
    RefreshMeteoriteNoticeComp(self.meteoriteNotice)
  end
end

function UIMainTop:RefreshGiftBoxBtn()
  self.gift_box_activity_btn:Refresh()
end

function UIMainTop:RefreshThanksGivingBtn()
  self.thanks_giving_activity_btn:Refresh()
end

function UIMainTop:RefreshUIMainActivityGroupContent(IsPassDayRefresh)
  if not self.ui_main_activity_group_content then
    return
  end
  local prevActive = self.ui_main_activity_group_content:GetActive()
  local curActive = self.ui_main_activity_group_content:Refresh()
  if IsPassDayRefresh == true then
    self.ui_main_activity_group_content:OnPassDayRefresh()
  end
  if (prevActive ~= curActive or curActive) and self.topBtns then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.topBtns.transform)
  end
end

function UIMainTop:RefreshScratchBtn()
  self.scratch_activity_btn:Refresh()
end

function UIMainTop:RefreshPiggyBankBtn()
  self.piggy_bank_btn:Refresh()
end

function UIMainTop:RefreshInfiniteGiftBtn()
  self.infiniteGiftBtn:Refresh()
end

function UIMainTop:OnLeagueMatchStageChangeSignal()
  self:RefreshAlCompeteBtn()
end

function UIMainTop:OnPassDay()
  if self.dailyPackBtn ~= nil then
    self.dailyPackBtn:RefreshNewTag()
  end
  RefreshAllActivityBtn(self)
  self:RefreshUIMainActivityGroupContent(true)
end

function UIMainTop:RefreshActivityTips()
  self.activityTips:Refresh()
end

function UIMainTop:GetBtnPosByType(mainUITipType)
  if mainUITipType == MainUITipType.Activity then
    if self.activityCenterBtn:GetActive() then
      return self.activityCenterBtn.transform.position
    end
  elseif mainUITipType == MainUITipType.Gift then
    if self.dailyPackBtn:GetActive() then
      return self.dailyPackBtn.transform.position
    end
  elseif mainUITipType == MainUITipType.AllyCity then
    if self.governmentBtn:GetActive() then
      return self.governmentBtn.transform.position
    elseif self.attackCityBtn:GetActive() then
      return self.attackCityBtn.transform.position
    end
  elseif mainUITipType == MainUITipType.WarZone then
    if self.kingBtn:GetActive() then
      return self.kingBtn.transform.position
    end
  elseif mainUITipType == MainUITipType.AllyDuel then
    if self.allyDuelBtn:GetActive() then
      return self.allyDuelBtn.transform.position
    end
  elseif mainUITipType == MainUITipType.Season then
  elseif mainUITipType == MainUITipType.AccountBind then
    if self.accountBindTipBtn:GetActive() then
      return self.accountBindTipBtn.transform.position
    end
  elseif mainUITipType == MainUITipType.MeteoriteBattle then
    if self.actMeteoriteBtn:GetActive() then
      return self.actMeteoriteBtn.transform.position
    end
  elseif mainUITipType == MainUITipType.AttackCityS0 then
    if self.attackCityS0Btn:GetActive() then
      return self.attackCityS0Btn.transform.position
    end
  else
    local position
    if self.ui_main_activity_group_content and self.ui_main_activity_group_content:GetBtnByGroupId(mainUITipType) then
      local targetBtn = self.ui_main_activity_group_content:GetBtnByGroupId(mainUITipType)
      position = targetBtn.transform.position
    end
    return position
  end
  return nil
end

function UIMainTop:OnShowCrossServerBubbleTips(languageId)
  if self.move_city_root:GetActive() then
    if UIManager:GetInstance():GetWindow(UIWindowNames.LWUIMoveCityTip) ~= nil then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMoveCityTip)
    end
    self.new_bubble_root:ShowBubbleTips(languageId)
  elseif self.crossServerBubbleRoot then
    self.crossServerBubbleRoot:ShowBubbleTips(languageId)
  end
end

function UIMainTop:OnAccountBindTipChanged()
  self:RefreshAccountBindTipBtn()
end

function UIMainTop:OnMainLevelUp()
  RefreshAllActivityBtn(self)
end

function UIMainTop:GetBuffIconPosByIndex(index)
  return self.uiMainBuffList:GetIconWorldPos()
end

function UIMainTop:RefreshAccountBindTipBtn()
  self.accountBindTipBtn:Refresh()
  self:RefreshActivityTips()
end

function UIMainTop:RefreshCoppaAppealBtn()
  if not self.coppaAppealBtn then
    return
  end
  local canShow = CoppaUtil.IsShowCoppaBtnInMainUI()
  if not canShow then
    if self.coppaAppealBtn:GetActive() then
      self.coppaAppealBtn:SetActive(false)
    end
    return
  end
  self.coppaAppealBtn:SetActive(true)
  self.coppaAppealBtn:Refresh()
end

function UIMainTop:RefreshShowActivityAlarmClockView()
  self.alarmClockDispatch:RefreshShowActivityAlarmClockView()
end

function UIMainTop:DestroyActivityAlarmClockView()
  self.alarmClockDispatch:DestroyActivityAlarmClockView()
end

function UIMainTop:RefreshShowCityFightAlarmView()
  local declareInfo = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
  if not declareInfo or not declareInfo.content then
    return
  end
  local cityId = declareInfo.content
  if self.cityFightAlarmReq == nil then
    self.cityFightAlarmReq = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/UICityEvent/LWMainCityFightAlarmObj.prefab")
    self.cityFightAlarmReq:completed("+", function(req)
      local gameObject = req.gameObject
      if IsNull(gameObject) then
        self:DestroyCityFightAlarmView()
        return
      end
      gameObject.transform:SetParent(self.transform)
      gameObject.transform:Set_localScale(1, 1, 1)
      gameObject.transform:Set_anchoredPosition(-21, -63, 0)
      local name = "LWMainCityFightAlarmObj"
      gameObject.name = name
      self.cityFightAlarmObj = self:AddComponent(LWMainCityFightAlarmObj, name)
      self.cityFightAlarmObj:ReInit(cityId)
    end)
  elseif self.cityFightAlarmObj ~= nil then
    self.cityFightAlarmObj:ReInit(cityId)
  end
end

function UIMainTop:HideCityFightAlarmView()
  if self.cityFightAlarmObj ~= nil then
    self.cityFightAlarmObj:SetActive(false)
  end
end

function UIMainTop:DestroyCityFightAlarmView()
  if self.cityFightAlarmReq ~= nil then
    self.cityFightAlarmReq:Destroy()
    self.cityFightAlarmReq = nil
  end
  self.cityFightAlarmReq = nil
end

function UIMainTop:RefreshSeasonBtns()
  local seasonType = SeasonUtil.GetSeasonType()
  if self.farmerBtn == nil and seasonType ~= SeasonMapType.Nothing then
    local luaPath = "UI.LWMainUI.Component.UIMainTop.UIFarmerBtn"
    local prefabPath = "Assets/Main/Prefabs/UI/LWSeason/UIFarmerBtn.prefab"
    self.farmerBtn = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.rightTopBtnsRoot, function(view, go, stove_center_level)
      if IsNotNull(self.meteoriteNoticeRoot) then
        self.meteoriteNoticeRoot:SetAsLastSibling()
      end
    end)
    self.farmerBtn:SetActive(false)
  end
  if self.SeasonBtn == nil and (seasonType ~= SeasonMapType.Nothing or SeasonUtil.IsInSeasonPrepareMode()) then
    local luaPath = "UI.LWMainUI.Component.UIMainTop.UISeasonBtn"
    local prefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonBtn.prefab"
    self.SeasonBtn = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.rightTopBtnsRoot, function(view, go, stove_center_level)
      if IsNotNull(self.meteoriteNoticeRoot) then
        self.meteoriteNoticeRoot:SetAsLastSibling()
      end
    end)
    self.SeasonBtn:SetActive(false)
  end
  if self.OffSeasonBtn == nil and seasonType ~= SeasonMapType.Nothing then
    local luaPath = "UI.LWMainUI.Component.UIMainTop.UIOffSeasonBtn"
    local prefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWOffSeasonBtn.prefab"
    self.OffSeasonBtn = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.rightTopBtnsRoot, function(view, go, stove_center_level)
      if IsNotNull(self.meteoriteNoticeRoot) then
        self.meteoriteNoticeRoot:SetAsLastSibling()
      end
    end)
    self.OffSeasonBtn:SetActive(false)
  end
  if self.KingBattleBtn == nil and seasonType >= SeasonMapType.NineNation then
    local luaPath = "UI.LWMainUI.Component.UIMainTop.UISeasonKingBattleBtn"
    local prefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonKingBattleBtn.prefab"
    self.KingBattleBtn = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.rightTopBtnsRoot, function(view, go, stove_center_level)
      if IsNotNull(self.meteoriteNoticeRoot) then
        self.meteoriteNoticeRoot:SetAsLastSibling()
      end
    end)
    self.KingBattleBtn:SetActive(false)
  end
  self:RefreshSeasonBtnShow()
end

function UIMainTop:ShowSeasonResDownloadBtn()
  if self.seasonResDownload == nil then
    local prefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonResourceDownloadBtn.prefab"
    local luaPath = "UI.LWMainUI.Component.UIMainTop.UISeasonResDownloadBtn"
    self.seasonResDownload = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.rightTopBtnsRoot)
  end
  self.seasonResDownload:ReInit()
end

function UIMainTop:RefresSeasonResourceDownloadBtn()
  local mainLv = toInt(DataCenter.BuildManager.MainLv)
  if mainLv >= SEASON_MIN_LEVEL then
    self:RefreshSeasonBtns()
  end
  local packageId = SeasonUtil.CheckSeasonResourceBtnShowState()
  if packageId ~= nil then
    self:ShowSeasonResDownloadBtn()
  elseif self.seasonResDownload then
    self.seasonResDownload:SetActive(false)
  end
end

local function RefreshZoneMobilizationAct(self)
  if self.zone_mobilization_btn then
    self.zone_mobilization_btn:ReInit()
  end
end

local function OnReceivePushMsgRequestZoneMobilizationData(self, message)
  if message then
    if message.firstOpen then
      DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(1)
    elseif message.tabType then
      DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(message.tabType)
    end
  end
end

function UIMainTop:RefreshDominatorEntrance()
  if self.dominatorCockatriceUnlockBtn == nil then
    local isShow = DataCenter.DominatorCockatriceUnlockManager:IsShowMainUIEntrance()
    if isShow and self.dominatorEntranceReq == nil then
      local prefabPath = "Assets/Main/Prefabs/UI/LWMainUI/DominatorUnlockBtn.prefab"
      self.dominatorEntranceReq = self:GameObjectInstantiateAsync(prefabPath, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.rightTopBtnsRoot.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "DominatorCockatriceUnlockBtn"
        self.dominatorCockatriceUnlockBtn = self.rightTopBtnsRoot:AddComponent(UILWDominatorCockatriceUnlockMainUIEntranceComponent, go.name)
        self.dominatorCockatriceUnlockBtn:ReInit()
      end)
    end
  else
    self.dominatorCockatriceUnlockBtn:ReInit()
  end
end

function UIMainTop:DestroyDominatorEntrance()
  if self.dominatorEntranceReq ~= nil then
    self.dominatorEntranceReq:Destroy()
    self.dominatorEntranceReq = nil
  end
end

UIMainTop.RefreshZoneMobilizationAct = RefreshZoneMobilizationAct
UIMainTop.OnReceivePushMsgRequestZoneMobilizationData = OnReceivePushMsgRequestZoneMobilizationData
return UIMainTop
