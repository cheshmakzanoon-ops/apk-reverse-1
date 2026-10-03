local CellVipInfo = require("UI.UIVip.Component.CellVipInfo")
local CellEffect = require("UI.UIVip.Component.CellEffect")
local UIVipView = BaseClass("UIVipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local UIGray = CS.UIGray
local titleTextPath = "Root/TopBar/TextTitle"
local backBtnPath = "Root/ContentContainer/BottomBtns/BackBtn"
local renewBtnPath = "Root/ContentContainer/BottomBtns/RenewBtn"
local renewBtnTextPath = "Root/ContentContainer/BottomBtns/RenewBtn/RenewBtnText"
local vipProgerssPath = "Root/ContentContainer/Top/Slider"
local vipProgerssTextPath = "Root/ContentContainer/Top/Slider/ProgressText"
local vipAddPointsBtnPath = "Root/ContentContainer/Top/AddPointsBtn"
local vipLevelTextPath = "Root/ContentContainer/Top/vipLevelLayout/levelText"
local vipLevelNumberTextPath = "Root/ContentContainer/Top/vipLevelLayout/levelNumberText"
local vipLoginTextPath = "Root/ContentContainer/Top/VIPLoginText"
local shopBtnPath = "Root/ContentContainer/Top/ShopBtn"
local vipBgLevelTextPath = "Root/ContentContainer/Top/VIPBg/VIPBgLevelText"
local dailyScoreBtnPath = "Root/ContentContainer/Top/freeReward"
local dailyScoreBoxOpenedPath = "Root/ContentContainer/Top/freeReward/opened"
local dailyScoreBoxOpenEffectPath = "Root/ContentContainer/Top/freeReward/VFX_ui_zhoukabaoxiang_xiaoOpen"
local dailyScoreBoxUnopenedPath = "Root/ContentContainer/Top/freeReward/unopen"
local dailyScoreBoxUnopenEffectPath = "Root/ContentContainer/Top/freeReward/VFX_ui_zhoukabaoxiang_xiao"
local centerVIPLevelTextPath = "Root/ContentContainer/Center/CenterVIPLevelText"
local switchArrowsPath = "Root/ContentContainer/Center/SwitchArrows"
local leftArrowPath = "Root/ContentContainer/Center/SwitchArrows/LeftArrow"
local leftArrowRedPointPath = "Root/ContentContainer/Center/SwitchArrows/LeftArrow/LeftRedDot"
local rightArrowPath = "Root/ContentContainer/Center/SwitchArrows/RightArrow"
local rightArrowRedPointPath = "Root/ContentContainer/Center/SwitchArrows/RightArrow/RightRedDot"
local vipBuffScrollPath = "Root/ContentContainer/Center/VIPBuffContentScroll"
local vipBuffContentPath = "Root/ContentContainer/Center/VIPBuffContentScroll/Viewport/Content"
local dailyFreePackPath = "Root/ContentContainer/Bottom/DailyFreePackage"
local dailyFreePackNameTextPath = "Root/ContentContainer/Bottom/DailyFreePackage/DailyFreePackName/DailyFreePackTxtName"
local dailyPackCellScrollPath = "Root/ContentContainer/Bottom/DailyFreePackage/DailyPackCellScroll"
local dailyPackCellContentPath = "Root/ContentContainer/Bottom/DailyFreePackage/DailyPackCellScroll/Viewport/DailyPackContent"
local dailyPackClaimBtnPath = "Root/ContentContainer/Bottom/DailyFreePackage/Bottom/ClaimButton"
local dailyPackClaimBtnTextPath = "Root/ContentContainer/Bottom/DailyFreePackage/Bottom/ClaimButton/ClaimTxtPrice2"
local dailyPackIconPath = "Root/ContentContainer/Bottom/DailyFreePackage/ImgIcon"
local vipLevelPackPath = "Root/ContentContainer/Bottom/VIPLevelPackage"
local vipLevelPackNameTextPath = "Root/ContentContainer/Bottom/VIPLevelPackage/normal/TopInfo/LevelPackName/LevelPackTxtName"
local vipPackCellScrollPath = "Root/ContentContainer/Bottom/VIPLevelPackage/normal/LevelPackCellScroll"
local vipPackCellContentPath = "Root/ContentContainer/Bottom/VIPLevelPackage/normal/LevelPackCellScroll/Viewport/LevelPackContent"
local vipPackDiscountPath = "Root/ContentContainer/Bottom/VIPLevelPackage/normal/TopInfo/discountBg"
local vipPackDiscountTextPath = "Root/ContentContainer/Bottom/VIPLevelPackage/normal/TopInfo/discountBg/Bg/DiscountText"
local vipPackDescTextPath = "Root/ContentContainer/Bottom/VIPLevelPackage/normal/TopInfo/TxtDesc"
local vipPackBuyBtnPath = "Root/ContentContainer/Bottom/VIPLevelPackage/Bottom/BuyButton"
local vipPackBuyBtnTextPath = "Root/ContentContainer/Bottom/VIPLevelPackage/Bottom/BuyButton/BuyTxtPrice2"
local vipPackBgPath = "Root/ContentContainer/Bottom/VIPLevelPackage/ImgBg"
local vipPackImgPath = "Root/ContentContainer/Bottom/VIPLevelPackage/img"
local vipPackPointPath = "Root/ContentContainer/Bottom/VIPLevelPackage/Bottom/BuyButton/UIGiftPackagePoint"
local shopBtnRedPointPath = "Root/ContentContainer/Top/ShopBtn/ShopBtnRedDot"
local renewBtnRedPointPath = "Root/ContentContainer/BottomBtns/RenewBtn/RenewBtnRedDot"
local old_vip_pack_btn_path = "Root/ContentContainer/BottomBtns/OldVipPackBtn"
local old_vip_pack_time_text_path = "Root/ContentContainer/BottomBtns/OldVipPackBtn/OldVipCountDown/TimeText"
local vip_extend_desc_path = "Root/ContentContainer/Center/VipExtendRoot/VipExtendDesc"
local vip_extend_btn_path = "Root/ContentContainer/Center/VipExtendRoot/VipExtendBtn"
local vip_extend_btn_text_path = "Root/ContentContainer/Center/VipExtendRoot/VipExtendBtn/VipExtendBtnText"
local vip_extend_root_path = "Root/ContentContainer/Center/VipExtendRoot"
local vip_extend_btn_red_dot_path = "Root/ContentContainer/Center/VipExtendRoot/VipExtendBtn/VipExtendBtnRedDot"
local vipNormalPath = "Root/ContentContainer/Bottom/VIPLevelPackage/normal"
local vipRadarPath = "Root/ContentContainer/Bottom/VIPLevelPackage/radar"
local radar_packName_text_path = "Root/ContentContainer/Bottom/VIPLevelPackage/radar/TopInfo/LevelPackName/LevelPackTxtName2"
local radar_discount_text_path = "Root/ContentContainer/Bottom/VIPLevelPackage/radar/TopInfo/discountBg/Bg/DiscountText2"
local radar_desc_text_path = "Root/ContentContainer/Bottom/VIPLevelPackage/radar/TopInfo/TxtDesc2"
local radar_info_btn_path = "Root/ContentContainer/Bottom/VIPLevelPackage/radar/TopInfo/infoBtn/LW_Btn_Info"
local radar_packRewards_path = "Root/ContentContainer/Bottom/VIPLevelPackage/radar/LevelPackCellScroll2/Viewport/LevelPackContent2"
local radar_extraReward_path = "Root/ContentContainer/Bottom/VIPLevelPackage/radar/extraReward"
local PACK_IMG_PATH = "Assets/Main/TextureEx/UIVIP/%s.png"
local RADAR_DISCOUNT_ANIM_DURATION = 0.6
local RADAR_DISCOUNT_ANIM_STEP = 0.05
local Setting = CS.GameEntry and CS.GameEntry.Setting or nil
local RADAR_DISCOUNT_PLAYED_PREFIX = SettingKeys and SettingKeys.VIP_RADAR_DISCOUNT_ANIM_DAY or "VIP_RADAR_DISCOUNT_ANIM_DAY"
local RADAR_EXTRA_PLAYED_PREFIX = SettingKeys and SettingKeys.VIP_RADAR_EXTRA_ANIM_DAY or "VIP_RADAR_EXTRA_ANIM_DAY"
local radarDiscountPlayedDays = {}
local radarExtraPlayedDays = {}

local function build_played_key(prefix, actId, giftId)
  return string.format("%s_%s_%s", prefix, tostring(actId or 0), tostring(giftId or 0))
end

local function load_played_day(prefix, actId, giftId)
  if not Setting then
    return 0
  end
  local raw = Setting:GetString(build_played_key(prefix, actId, giftId), "")
  if string.IsNullOrEmpty(raw) then
    return 0
  end
  return tonumber(raw) or 0
end

local function save_played_day(prefix, actId, giftId, day)
  if not Setting then
    return
  end
  Setting:SetString(build_played_key(prefix, actId, giftId), tostring(math.floor(day or 0)))
end

local radar_quantity_fields = {
  "count",
  "num",
  "quantity",
  "amount"
}

local function get_radar_reward_count_for_anim(reward)
  if type(reward) ~= "table" then
    return 0
  end
  for _, key in ipairs(radar_quantity_fields) do
    local raw = reward[key]
    if raw ~= nil then
      local num = tonumber(raw)
      if num then
        return num
      end
    end
  end
  local value = reward.value
  if type(value) == "table" then
    for _, key in ipairs(radar_quantity_fields) do
      local raw = value[key]
      if raw ~= nil then
        local num = tonumber(raw)
        if num then
          return num
        end
      end
    end
  end
  return 0
end

local function format_discount_text(value)
  local num = tonumber(value) or 0
  return string.format("%d", math.floor(num + 0.5))
end

local function to_positive_int(value)
  local num = tonumber(value)
  if not num then
    return 0
  end
  if num < 0 then
    return math.floor(num)
  end
  return math.floor(num + 1.0E-7)
end

local function to_array(items)
  if type(items) ~= "table" then
    return {}
  end
  local result = {}
  local length = #items
  if 0 < length then
    for index = 1, length do
      result[#result + 1] = items[index]
    end
  else
    for _, value in pairs(items) do
      result[#result + 1] = value
    end
  end
  return result
end

function UIVipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  EventManager:GetInstance():Broadcast(EventId.OnEnterVipPanel)
  self.openVip18Timer = TimerManager:GetInstance():GetTimer(1.5, UIVipView.OpenVip18View, self, true, false, false)
  self.openVip18Timer:Start()
end

function UIVipView:OpenVip18View()
  local envelopItemId = LuaEntry.DataConfig:TryGetNum("vip_letter", "k2")
  local item = DataCenter.ItemData:GetItemById(envelopItemId)
  if item == nil then
    return
  end
  DataCenter.VipExtendManager:OpenUIVip18EnvelopView(item)
end

function UIVipView:OnReceiveDailyFreePack()
  if not self.scrollIndex then
    return
  end
  if not self.vipInfo then
    return
  end
  if not self.vipInfo:IsVIPActive() then
    return
  end
  self:OnClickCallBack(self.scrollIndex, false)
  self.view.ctrl:ReceiveFreeReward()
end

function UIVipView:OnBuyLevelPack()
  if not self.scrollIndex then
    return
  end
  if not self.giftPackData then
    return
  end
  self:OnClickCallBack(self.scrollIndex, true)
  local packId = ""
  if self.giftPackData and self.giftPackData.getID then
    packId = self.giftPackData:getID()
  end
  PostEventLog.Track("vip_pack_buy_click", {
    source_type = "vip_panel",
    packageid = tostring(packId)
  })
  self.view.ctrl:BuyPack(self.giftPackData)
end

local function OnFreePackItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.dailyPackCellScroll:AddComponent(UICommonResItem, itemObj)
  cellItem:ReInit(self.freePackrewards[index])
  cellItem.transform:Set_localScale(0.63, 0.658, 1)
end

local function OnFreePackItemMoveOut(self, itemObj, index)
  self.dailyPackCellScroll:RemoveComponent(itemObj.name, UICommonResItem)
end

local function OnLevelPackItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.levelPackCellScroll:AddComponent(UICommonResItem, itemObj)
  cellItem:ReInit(self.levelPackRewards[index])
  cellItem.transform:Set_localScale(0.7, 0.7, 1)
end

local function OnLevelPackItemMoveOut(self, itemObj, index)
  self.levelPackCellScroll:RemoveComponent(itemObj.name, UICommonResItem)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.curVipTemplate.effect then
    return nil
  end
  local data = self.curVipTemplate.effect[index]
  local item = loopScroll:NewListViewItem("VIPBuffLine")
  local script = self.content:GetComponent(item.gameObject.name, CellEffect)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(CellEffect, objectName)
  end
  script:SetActive(true)
  script:RefreshData(data)
  self.cells[index] = script
  return item
end

function UIVipView:ComponentDefine()
  self._vip_txt = self:AddComponent(UIText, titleTextPath)
  self._close_btn = self:AddComponent(UIButton, backBtnPath)
  self._close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.renewBtn = self:AddComponent(UIButton, renewBtnPath)
  self.renewBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVIPRewnew, {anim = true})
  end)
  self.renewBtnText = self:AddComponent(UIText, renewBtnTextPath)
  self._progress_img = self:AddComponent(UISlider, vipProgerssPath)
  self._percent_txt = self:AddComponent(UITextMeshProUGUIEx, vipProgerssTextPath)
  self.vipLoginText = self:AddComponent(UITextMeshProUGUIEx, vipLoginTextPath)
  self._add_btn = self:AddComponent(UIButton, vipAddPointsBtnPath)
  self._add_btn:SetOnClick(function()
    self:OAddClick()
  end)
  self.shopBtn = self:AddComponent(UIButton, shopBtnPath)
  self.shopBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.Vip)
    self.shopBtnRedPoint:SetActive(false)
  end)
  self._level_txt = self:AddComponent(UITextMeshProUGUIEx, vipLevelTextPath)
  self._levelNumber_txt = self:AddComponent(UITextMeshProUGUIEx, vipLevelNumberTextPath)
  self.vipBgLevelText = self:AddComponent(UITextMeshProUGUIEx, vipBgLevelTextPath)
  self.centerVIPLevelText = self:AddComponent(UITextMeshProUGUIEx, centerVIPLevelTextPath)
  self.freePackageBtnAnimN = self:AddComponent(UIAnimator, dailyScoreBtnPath)
  self.freePackageBtnN = self:AddComponent(UIButton, dailyScoreBtnPath)
  self.freePackageBtnN:SetOnClick(function()
    self:OnSendDailyPointClick()
  end)
  self.freePackageOpenN = self:AddComponent(UIImage, dailyScoreBoxOpenedPath)
  self.freePackageOpenEffN = self:AddComponent(UIBaseContainer, dailyScoreBoxOpenEffectPath)
  self.freePackageUnopenN = self:AddComponent(UIImage, dailyScoreBoxUnopenedPath)
  self.freePackageUnopenEffN = self:AddComponent(UIBaseContainer, dailyScoreBoxUnopenEffectPath)
  self.scrollview = self:AddComponent(UIScrollRect, vipBuffScrollPath)
  self.content = self:AddComponent(UIBaseContainer, vipBuffContentPath)
  self.switchArrow = self:AddComponent(UIBaseContainer, switchArrowsPath)
  self._prev_btn = self:AddComponent(UIButton, leftArrowPath)
  self._prev_btn:SetOnClick(function()
    self:ScrollNextPage(-1)
  end)
  self._preRed_Img = self:AddComponent(UIImage, leftArrowRedPointPath)
  self._next_btn = self:AddComponent(UIButton, rightArrowPath)
  self._next_btn:SetOnClick(function()
    self:ScrollNextPage(1)
  end)
  self._NextRed_Img = self:AddComponent(UIImage, rightArrowRedPointPath)
  self.dailyFreePack = self:AddComponent(UIBaseContainer, dailyFreePackPath)
  self.dailyFreePackNameText = self:AddComponent(UITextMeshProUGUIEx, dailyFreePackNameTextPath)
  self.dailyPackCellScroll = self:AddComponent(UIScrollView, dailyPackCellScrollPath)
  self.dailyPackCellScroll:SetOnItemMoveIn(function(itemObj, index)
    OnFreePackItemMoveIn(self, itemObj, index)
  end)
  self.dailyPackCellScroll:SetOnItemMoveOut(function(itemObj, index)
    OnFreePackItemMoveOut(self, itemObj, index)
  end)
  self.dailyPackClaimBtn = self:AddComponent(UIButton, dailyPackClaimBtnPath)
  self.dailyPackClaimBtn:SetOnClick(function()
    self:OnReceiveDailyFreePack()
  end)
  self.dailyPackClaimBtnText = self:AddComponent(UIText, dailyPackClaimBtnTextPath)
  self.dailyPackBoxIcon = self:AddComponent(UIImage, dailyPackIconPath)
  self.levelPack = self:AddComponent(UIBaseContainer, vipLevelPackPath)
  self.levelPackNameText = self:AddComponent(UITextMeshProUGUIEx, vipLevelPackNameTextPath)
  self.levelPackCellScroll = self:AddComponent(UIScrollView, vipPackCellScrollPath)
  self.levelPackCellScroll:SetOnItemMoveIn(function(itemObj, index)
    OnLevelPackItemMoveIn(self, itemObj, index)
  end)
  self.levelPackCellScroll:SetOnItemMoveOut(function(itemObj, index)
    OnLevelPackItemMoveOut(self, itemObj, index)
  end)
  self.levelPackDiscount = self:AddComponent(UIImage, vipPackDiscountPath)
  self.levelPackDiscountText = self:AddComponent(UIText, vipPackDiscountTextPath)
  self.levelPackDescText = self:AddComponent(UITextMeshProUGUIEx, vipPackDescTextPath)
  self.levelPackBuyBtn = self:AddComponent(UIButton, vipPackBuyBtnPath)
  self.levelPackBuyBtn:SetOnClick(function()
    self:OnBuyLevelPack()
  end)
  self.levelPackBuyBtn:SetSafeClickMode(true)
  self.levelPackBuyBtnText = self:AddComponent(UIText, vipPackBuyBtnTextPath)
  self.levelPackBoxIcon = self:AddComponent(UIImage, vipPackBgPath)
  self.levelPackImg = self:AddComponent(UIRawImage, vipPackImgPath)
  self.vipNormalRoot = self:AddComponent(UIBaseContainer, vipNormalPath)
  self.vipRadarRoot = self:AddComponent(UIBaseContainer, vipRadarPath)
  if self.vipRadarRoot then
    self.vipRadarRoot:SetActive(false)
  end
  self.radarPackNameText = self:AddComponent(UITextMeshProUGUIEx, radar_packName_text_path)
  self.radarDiscountText = self:AddComponent(UITextMeshProUGUIEx, radar_discount_text_path)
  self.radarDescText = self:AddComponent(UITextMeshProUGUIEx, radar_desc_text_path)
  self.radarInfoBtn = self:AddComponent(UIButton, radar_info_btn_path)
  if self.radarInfoBtn then
    self.radarInfoBtn:SetOnClick(function()
      local info = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SurvivalVipGift.Type)
      if not info then
        return
      end
      local title = Localization:GetString("radar_vipgift_info_title")
      local descKey = info.story
      local desc = descKey and Localization:GetString(descKey) or ""
      UIUtil.ShowIntro(title, "", desc)
    end)
  end
  self.radarPackGrid = self:AddComponent(UIGridLayoutGroup, radar_packRewards_path)
  self.radarExtraReward = self:AddComponent(UIBaseContainer, radar_extraReward_path)
  if self.radarExtraReward then
    self.radarExtraReward:SetActive(false)
  end
  self.levelPackPoint = self:AddComponent(UIGiftPackagePoint, vipPackPointPath)
  self.shopBtnRedPoint = self:AddComponent(UIImage, shopBtnRedPointPath)
  self.renewBtnRedPoint = self:AddComponent(UIImage, renewBtnRedPointPath)
  self.oldVipPackBtn = self:AddComponent(UIButton, old_vip_pack_btn_path)
  self.oldVipPackTimeText = self:AddComponent(UITextMeshProUGUIEx, old_vip_pack_time_text_path)
  self.oldVipPackBtn:SetActive(false)
  self.oldVipPackBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWOldVipPacks, {anim = true})
  end)
  self.vip_extend_desc = self:AddComponent(UITextMeshProUGUIEx, vip_extend_desc_path)
  self.vip_extend_desc:SetLocalText("vip_base_skin_desc2")
  self.vip_extend_btn = self:AddComponent(UIButton, vip_extend_btn_path)
  self.vip_extend_btn:SetOnClick(function()
    PostEventLog.Track(PostEventLog.Defines.Vip18SkinPageEnter, {source = "vip_tab"})
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVipExtend, {anim = true})
  end)
  self.vip_extend_btn_text = self:AddComponent(UITextMeshProUGUIEx, vip_extend_btn_text_path)
  self.vip_extend_btn_text:SetLocalText("vip_base_skin_button1")
  self.vip_extend_root = self:AddComponent(UIBaseContainer, vip_extend_root_path)
  self.vip_extend_btn_red_dot = self:AddComponent(UIBaseContainer, vip_extend_btn_red_dot_path)
end

function UIVipView:DataDefine()
  self.list = {}
  self.vipInfo = {}
  self.viptemplate = {}
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.canGet = false
  self.refreshIndex = 0
  self.scrollIndex = 0
  self.lastIndex = 0
  self.isBuy = false
  self.itemIndex = 0
  self.cells = {}
  self.activityListManager = DataCenter.ActivityListDataManager
  self.vipGiftActManager = DataCenter.VipGiftActDataManager
  self.radarPackRewards = {}
  self.radarPackReqs = {}
  self.radarPackCells = {}
  self.radarPackPendingRewards = {}
  self.radarExtraRewardReqs = {}
  self.radarExtraRewardCells = {}
  self.radarExtraRewardPendingRewards = {}
  self.radarCurrentContext = nil
  self.radarDiscountAnimTimer = nil
  self.radarDiscountAnimInfo = nil
  self.radarExtraAnimTimer = nil
  self.radarExtraAnimInfo = nil
  self.radarExtraAnimEntries = nil
  self.effectScrollViewRectOrigin = self.scrollview.rectTransform.offsetMax
end

function UIVipView:OnDestroy()
  self.scrollview.rectTransform.offsetMax = self.effectScrollViewRectOrigin
  if self.claimFreeTimer then
    self.claimFreeTimer:Stop()
    self.claimFreeTimer = nil
  end
  self:ClearScroll()
  self._vip_txt = nil
  self._close_btn = nil
  self.renewBtn = nil
  self._progress_img = nil
  self._box_btn = nil
  self._box_anim = nil
  self._percent_txt = nil
  self._add_btn = nil
  self._level_txt = nil
  self._boxOpen_img = nil
  self._boxOpen_2_img = nil
  self._boxClose_img = nil
  self._time_txt = nil
  self._receive_txt = nil
  self._preRed_Img = nil
  self._NextRed_Img = nil
  self.dailyFreePack = nil
  self.dailyFreePackNameText = nil
  self.dailyPackCellScroll = nil
  self.dailyPackClaimBtn = nil
  self.dailyPackClaimBtnText = nil
  self.dailyPackBoxIcon = nil
  self.levelPack = nil
  self.levelPackNameText = nil
  self.levelPackCellScroll = nil
  self.levelPackDiscount = nil
  self.levelPackDiscountText = nil
  self.levelPackDescText = nil
  self.levelPackBuyBtn = nil
  self.levelPackBuyBtnText = nil
  self.levelPackBoxIcon = nil
  if self.radarPackGrid ~= nil then
    UIUtil.ClearReward(self.radarPackGrid, self.radarPackReqs)
  end
  if self.radarExtraReward ~= nil then
    UIUtil.ClearReward(self.radarExtraReward, self.radarExtraRewardReqs)
  end
  self.vipNormalRoot = nil
  self.vipRadarRoot = nil
  self.radarPackNameText = nil
  self.radarDiscountText = nil
  self.radarDescText = nil
  self.radarInfoBtn = nil
  self.radarPackGrid = nil
  self.radarExtraReward = nil
  self.radarPackRewards = nil
  self.radarPackReqs = nil
  self.radarPackCells = nil
  self.radarPackPendingRewards = nil
  self.radarExtraRewardReqs = nil
  self.radarExtraRewardCells = nil
  self.radarExtraRewardPendingRewards = nil
  self:StopRadarDiscountAnim()
  self:StopRadarExtraCountAnim()
  self.radarDiscountAnimTimer = nil
  self.radarDiscountAnimInfo = nil
  self.radarCurrentContext = nil
  self.activityListManager = nil
  self.vipGiftActManager = nil
  self.levelPackPoint = nil
  self._prev_btn = nil
  self._next_btn = nil
  self.vipInfo = nil
  self.scrollview = nil
  self.content = nil
  self._vipDes_rect = nil
  self._mask_btn = nil
  self.list = nil
  self.viptemplate = nil
  self:DeleteTimer()
  self.timer_action = nil
  self.canGet = nil
  self.refreshIndex = nil
  self.scrollIndex = nil
  self.lastIndex = nil
  self.isBuy = nil
  self.itemIndex = nil
  self.cells = nil
  if self.openVip18Timer then
    self.openVip18Timer:Stop()
    self.openVip18Timer = nil
  end
  base.OnDestroy(self)
end

function UIVipView:OnEnable()
  base.OnEnable(self)
  self:OnUpdateVipRedDot()
end

function UIVipView:OnDisable()
  base.OnDisable(self)
  self:StopRadarExtraCountAnim()
end

function UIVipView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.VipDataRefresh, self.Refresh)
  self:AddUIListener(EventId.VipRefreshFree, self.RefreshFree)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshPayGift)
  self:AddUIListener(EventId.VipExtendDesignRefresh, self.OnUpdateVipRedDot)
  self:AddUIListener(EventId.VipExtendDesignRedPoint, self.OnUpdateVipRedDot)
  self:AddUIListener(EventId.UpdateAIHelpRedPoint, self.OnUpdateVipRedDot)
  self:AddUIListener(EventId.OnPassDay, self.OnVipRadarPassDayRefresh)
  self:AddUIListener(EventId.SurvivalVipGiftInfoUpdate, self.OnSurvivalVipGiftInfoUpdate)
end

function UIVipView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.VipDataRefresh, self.Refresh)
  self:RemoveUIListener(EventId.VipRefreshFree, self.RefreshFree)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshPayGift)
  self:RemoveUIListener(EventId.VipExtendDesignRefresh, self.OnUpdateVipRedDot)
  self:RemoveUIListener(EventId.VipExtendDesignRedPoint, self.OnUpdateVipRedDot)
  self:RemoveUIListener(EventId.UpdateAIHelpRedPoint, self.OnUpdateVipRedDot)
  self:RemoveUIListener(EventId.OnPassDay, self.OnVipRadarPassDayRefresh)
  self:RemoveUIListener(EventId.SurvivalVipGiftInfoUpdate, self.OnSurvivalVipGiftInfoUpdate)
end

function UIVipView:OnVipRadarPassDayRefresh()
  if self.vipGiftActManager then
    local actId = self:GetSurvivalRadarActivityId()
    if 0 < actId then
      self.vipGiftActManager:SendGetInfo(actId)
    end
  end
end

function UIVipView:OnSurvivalVipGiftInfoUpdate()
  self:RefreshPayGift()
end

function UIVipView:RefreshRenewBtn()
  if self.vipInfo then
    if self.vipInfo:IsVIPActive() then
      self:AddTimer()
      self.shouldUpdateRenew = true
    else
      self.renewBtnText:SetLocalText(2000271)
      self.shouldUpdateRenew = false
      self:RefreshRenewBtnRedPoint()
    end
  end
end

function UIVipView:Refresh(vipWindowType)
  self.ctrl:ShowOpenLvUp(vipWindowType)
  self.vipInfo = DataCenter.VIPManager:GetVipData()
  self:SetValue()
  self:RefreshDailyBox()
  self:RefreshRenewBtn()
  self:RefreshShopBtnRedPoint()
  self:GotoPage(self.scrollIndex)
end

function UIVipView:ReInit()
  self.vipInfo = DataCenter.VIPManager:GetVipData()
  self._preRed_Img:SetActive(false)
  self._NextRed_Img:SetActive(false)
  self:RefreshDailyBox()
  self:RefreshVipContent()
  self:RefreshRenewBtn()
  self:RefreshShopBtnRedPoint()
  self:RefreshOldVipPacks()
end

function UIVipView:RefreshEffectList()
  self:ClearEffectCells()
  self:ItemRevertCustomAdd()
  for i = 1, table.count(self.curVipTemplate.effect) do
    local data = self.curVipTemplate.effect[i]
    if data.id then
      local effectId = tonumber(data.id)
      if effectId == EffectDefine.Truck_Super_Departure_50248 then
        local isFunctionOn = LuaEntry.DataConfig:CheckSwitch("super_truck_launch")
        if not isFunctionOn then
          goto lbl_42
        end
      end
    end
    self.cellPrefabList[i] = self:GameObjectInstantiateAsync(UIAssets.UIVIPEffectLine, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.name = tostring(i)
      go:SetActive(true)
      local cellComp = self.content:AddComponent(CellEffect, go.name)
      self.packCompList[i] = cellComp
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(cellComp.rectTransform)
      cellComp:RefreshData(data)
    end)
    ::lbl_42::
  end
end

function UIVipView:SetValue(targetLv)
  local nextVipInfo = DataCenter.VIPManager:GetNextVipData()
  self._vip_txt:SetLocalText(320222)
  self._percent_txt:SetText(string.GetFormattedSeperatorNum(self.vipInfo.score) .. "/" .. string.GetFormattedSeperatorNum(nextVipInfo.point))
  self._progress_img:SetValue(self.vipInfo.score / nextVipInfo.point)
  self.vipLoginText:SetLocalText(2000269, string.GetFormattedSeperatorNum(self.vipInfo:GetLoginDays()), string.format("<color=#AAFF5F>%s</color>", string.GetFormattedSeperatorNum(DataCenter.VIPManager:TomorrowPoint())))
  self._levelNumber_txt:SetLocalText(2000268, self.vipInfo.level)
  self.vipBgLevelText:SetText(string.format("VIP %d", self.vipInfo.level))
  if targetLv == self.vipInfo.level and self.scrollIndex ~= self.vipInfo.level and not self.isBuy then
    self.scrollIndex = self.vipInfo.level
    self.isBuy = false
  end
end

function UIVipView:RefreshVipContent()
  self.viptemplate = DataCenter.VIPManager:GetVipDatas()
  local targetLv = self:GetUserData()
  if targetLv == nil then
    targetLv = self.vipInfo.level
  end
  self.scrollIndex = targetLv and targetLv or self.vipInfo.level
  self._prev_btn:SetActive(targetLv ~= 1)
  self._next_btn:SetActive(targetLv ~= #self.viptemplate)
  self:SetValue(targetLv)
  self:GotoPage(targetLv)
end

function UIVipView:RefreshVipContentIndex()
  self:GotoPage(self.vipInfo.level)
end

function UIVipView:ClearEffectCells()
  if self.cellPrefabList ~= nil then
    for k, v in pairs(self.cellPrefabList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cellPrefabList = {}
  if self.content ~= nil then
    self.content:RemoveComponents(CellEffect)
  end
  self.packCompList = {}
end

function UIVipView:ClearScroll()
  self:ClearEffectCells()
  if self.dailyPackCellScroll then
    self.dailyPackCellScroll:ClearCells()
    self.dailyPackCellScroll:RemoveComponents(UICommonResItem)
  end
  if self.levelPackCellScroll then
    self.levelPackCellScroll:ClearCells()
    self.levelPackCellScroll:RemoveComponents(UICommonResItem)
  end
  if self.radarPackGrid then
    UIUtil.ClearReward(self.radarPackGrid, self.radarPackReqs)
  end
  self.cells = {}
end

function UIVipView:OnClickCallBack(index, isBuy)
  self.refreshIndex = index
  self.isBuy = isBuy
end

function UIVipView:RefreshFreePackBoxIcon(state)
  if state then
    self.dailyPackBoxIcon:LoadSprite("Assets/Main/Sprites/UI/UILWVIP/zyf_vip_baoxiang2_open.png")
  else
    self.dailyPackBoxIcon:LoadSprite("Assets/Main/Sprites/UI/UILWVIP/zyf_vip_baoxiang2_close.png")
  end
end

function UIVipView:RefreshFree()
  if not self.curVipTemplate then
    return
  end
  if not self.vipInfo then
    return
  end
  local level = self.curVipTemplate.level
  self.dailyFreePackNameText:SetLocalText(self.curVipTemplate.freePackNameKey, level)
  self.dailyPackCellScroll:ClearCells()
  self.dailyPackCellScroll:RemoveComponents(UICommonResItem)
  self.freePackrewards = self.curVipTemplate.freePackRewardList
  if #self.freePackrewards > 0 then
    self.dailyPackCellScroll:SetTotalCount(#self.freePackrewards)
    self.dailyPackCellScroll:RefillCells()
  end
  self.refreshFreePackTime = false
  if not self.vipInfo:IsVIPActive() then
    UIGray.SetGray(self.dailyPackClaimBtn.transform, true, false)
    self:RefreshFreePackBoxIcon(false)
    self.dailyPackClaimBtnText:SetLocalText(2000290)
    self.dailyPackClaimBtn:SetActive(true)
    return
  end
  if level > self.vipInfo.level then
    UIGray.SetGray(self.dailyPackClaimBtn.transform, true, false)
    self:RefreshFreePackBoxIcon(false)
    self.dailyPackClaimBtnText:SetLocalText(2000292)
    self.dailyPackClaimBtn:SetActive(true)
    return
  elseif level < self.vipInfo.level then
    UIGray.SetGray(self.dailyPackClaimBtn.transform, true, false)
    self:RefreshFreePackBoxIcon(false)
    self.dailyPackClaimBtnText:SetLocalText(2000292)
    self.dailyPackClaimBtn:SetActive(false)
    return
  end
  if DataCenter.VIPManager:FreeGoodCanGet(level) then
    UIGray.SetGray(self.dailyPackClaimBtn.transform, false, true)
    self:RefreshFreePackBoxIcon(false)
    self.dailyPackClaimBtnText:SetLocalText(2000293)
    self.dailyPackClaimBtn:SetActive(true)
  else
    self:AddTimer()
    UIGray.SetGray(self.dailyPackClaimBtn.transform, true, false)
    self:RefreshFreePackBoxIcon(true)
    self.refreshFreePackTime = true
    self.dailyPackClaimBtn:SetActive(true)
  end
end

function UIVipView:GetSurvivalRadarActivityId()
  if not (self.activityListManager and EnumActivity) or not EnumActivity.SurvivalVipGift then
    return 0
  end
  local info = self.activityListManager:GetOneOpenActivityByType(EnumActivity.SurvivalVipGift.Type)
  if type(info) == "table" then
    local first = info[1]
    if first ~= nil then
      info = first
    end
  end
  if type(info) ~= "table" then
    return 0
  end
  local actId = info.id or info.activityId
  return to_positive_int(actId)
end

function UIVipView:CheckRadarPackContext()
  if not self.vipGiftActManager then
    return false
  end
  local actId = self:GetSurvivalRadarActivityId()
  if actId <= 0 then
    return false
  end
  local template = self.curVipTemplate
  if not template then
    return false
  end
  local giftId = to_positive_int(template.reward2)
  if giftId <= 0 then
    return false
  end
  local data = self.vipGiftActManager:GetDataCanShow(actId)
  if not data then
    return false
  end
  local stageEntry
  local extraList = self.vipGiftActManager:GetGiftExtraInfo(actId)
  if type(extraList) == "table" then
    for _, entry in ipairs(extraList) do
      local entryGiftId = to_positive_int(entry.vipGiftId or entry.stageId)
      if entryGiftId == giftId then
        stageEntry = entry
        break
      end
    end
  end
  if not stageEntry then
    local config = self.vipGiftActManager:GetActivityConfig(actId)
    if config then
      local configStage
      if config.stageMap and config.stageMap[giftId] then
        configStage = config.stageMap[giftId]
      else
        for _, stage in ipairs(config.stageList or {}) do
          if to_positive_int(stage.vipGiftId) == giftId then
            configStage = stage
            break
          end
        end
      end
      if configStage then
        stageEntry = {
          stageId = to_positive_int(configStage.stageId or giftId),
          vipGiftId = to_positive_int(configStage.vipGiftId or giftId),
          config = configStage,
          extraRewards = to_array(configStage.extraRewards or configStage.rewards or {})
        }
      end
    end
  elseif not stageEntry.config then
    local config = self.vipGiftActManager:GetActivityConfig(actId)
    if config then
      stageEntry.config = config.stageMap and config.stageMap[giftId] or stageEntry.config
    end
  end
  if not stageEntry then
    return false
  end
  if self.vipGiftActManager and self.vipGiftActManager.GetStageDiscountDetail then
    local detail = self.vipGiftActManager:GetStageDiscountDetail(actId, stageEntry)
    local extraPercent = detail.extra or 0
    if not extraPercent or extraPercent <= 0 then
      return false
    end
  end
  return true, {
    actId = actId,
    stage = stageEntry,
    giftId = giftId
  }
end

function UIVipView:ClearRadarLayout()
  self:StopRadarExtraCountAnim()
  if self.radarPackGrid then
    UIUtil.ClearReward(self.radarPackGrid, self.radarPackReqs)
    self.radarPackReqs = {}
    self.radarPackCells = {}
    self.radarPackPendingRewards = {}
  end
  if self.radarExtraReward then
    UIUtil.ClearReward(self.radarExtraReward, self.radarExtraRewardReqs)
    self.radarExtraRewardReqs = {}
    self.radarExtraRewardCells = {}
    self.radarExtraRewardPendingRewards = {}
    self.radarExtraReward:SetActive(false)
  end
  if self.radarPackNameText then
    self.radarPackNameText:SetText("")
  end
  if self.radarDiscountText then
    self:StopRadarDiscountAnim()
    self.radarDiscountText:SetText("")
  end
  if self.radarDescText then
    self.radarDescText:SetText("")
  end
  self.radarPackRewards = {}
  self.radarCurrentContext = nil
end

function UIVipView:UpdateVipPackLayout()
  local useRadar, context = self:CheckRadarPackContext()
  self.radarCurrentContext = context
  if self.vipNormalRoot then
    self.vipNormalRoot:SetActive(not useRadar)
  end
  if self.vipRadarRoot then
    self.vipRadarRoot:SetActive(useRadar)
  end
  if useRadar then
    self:RefreshRadarPack(context)
  else
    self:ClearRadarLayout()
  end
end

function UIVipView:StopRadarDiscountAnim()
  if self.radarDiscountAnimTimer then
    self.radarDiscountAnimTimer:Stop()
    self.radarDiscountAnimTimer = nil
  end
  self.radarDiscountAnimInfo = nil
end

function UIVipView:StopRadarExtraCountAnim()
  if self.radarExtraAnimTimer then
    self.radarExtraAnimTimer:Stop()
    self.radarExtraAnimTimer = nil
  end
  self.radarExtraAnimInfo = nil
  self.radarExtraAnimEntries = nil
end

function UIVipView:OnRadarDiscountAnimTick()
  local info = self.radarDiscountAnimInfo
  if not info or not self.radarDiscountText then
    self:StopRadarDiscountAnim()
    return
  end
  info.elapsed = (info.elapsed or 0) + RADAR_DISCOUNT_ANIM_STEP
  local progress = info.elapsed / info.duration
  if 1 <= progress then
    progress = 1
  end
  local value = info.from + (info.to - info.from) * progress
  self.radarDiscountText:SetText(format_discount_text(value))
  if 1 <= progress then
    self:StopRadarDiscountAnim()
  end
end

function UIVipView:OnRadarExtraCountAnimTick()
  local info = self.radarExtraAnimInfo
  local entries = self.radarExtraAnimEntries
  if not (info and entries) or #entries == 0 then
    self:StopRadarExtraCountAnim()
    return
  end
  info.elapsed = (info.elapsed or 0) + RADAR_DISCOUNT_ANIM_STEP
  local progress = info.elapsed / info.duration
  if 1 <= progress then
    progress = 1
  end
  for _, e in ipairs(entries) do
    if e.cell and e.cell.SetItemCount then
      local value = e.from + e.diff * progress
      value = math.floor(value + 0.5)
      if 0 <= e.diff then
        if value > e.to then
          value = e.to
        end
      elseif value < e.to then
        value = e.to
      end
      e.cell:SetItemCount(value)
    end
  end
  if 1 <= progress then
    self:StopRadarExtraCountAnim()
  end
end

function UIVipView:StartRadarExtraCountAnim(prevCounts, newCounts)
  self:StopRadarExtraCountAnim()
  local cells = self.radarExtraRewardCells or {}
  local entries = {}
  for index, toValue in pairs(newCounts or {}) do
    local fromValue = prevCounts and prevCounts[index] or 0
    if fromValue ~= toValue then
      local cell = cells[index]
      if cell and cell.SetItemCount then
        entries[#entries + 1] = {
          cell = cell,
          from = fromValue,
          to = toValue,
          diff = toValue - fromValue
        }
      end
    end
  end
  if #entries == 0 then
    return
  end
  for _, entry in ipairs(entries) do
    if entry.cell and entry.cell.SetItemCount then
      entry.cell:SetItemCount(entry.from)
    end
  end
  self.radarExtraAnimEntries = entries
  self.radarExtraAnimInfo = {duration = RADAR_DISCOUNT_ANIM_DURATION, elapsed = 0}
  local timerMgr = TimerManager and TimerManager:GetInstance()
  if not timerMgr then
    for _, e in ipairs(entries) do
      if e.cell and e.cell.SetItemCount then
        e.cell:SetItemCount(e.to)
      end
    end
    self:StopRadarExtraCountAnim()
    return
  end
  self.radarExtraAnimTimer = timerMgr:GetTimer(RADAR_DISCOUNT_ANIM_STEP, UIVipView.OnRadarExtraCountAnimTick, self, false, false, false)
  if self.radarExtraAnimTimer then
    self.radarExtraAnimTimer:Start()
  else
    for _, e in ipairs(entries) do
      if e.cell and e.cell.SetItemCount then
        e.cell:SetItemCount(e.to)
      end
    end
    self:StopRadarExtraCountAnim()
  end
end

function UIVipView:PlayRadarDiscountAnim(fromValue, toValue)
  if not self.radarDiscountText then
    return false
  end
  fromValue = tonumber(fromValue) or 0
  toValue = tonumber(toValue) or 0
  if math.abs(toValue - fromValue) < 0.01 then
    self:StopRadarDiscountAnim()
    self.radarDiscountText:SetText(format_discount_text(toValue))
    return false
  end
  self:StopRadarDiscountAnim()
  local timerMgr = TimerManager and TimerManager:GetInstance()
  if not timerMgr then
    self.radarDiscountText:SetText(format_discount_text(toValue))
    return false
  end
  self.radarDiscountAnimInfo = {
    duration = RADAR_DISCOUNT_ANIM_DURATION,
    elapsed = 0,
    from = fromValue,
    to = toValue
  }
  self.radarDiscountAnimTimer = timerMgr:GetTimer(RADAR_DISCOUNT_ANIM_STEP, UIVipView.OnRadarDiscountAnimTick, self, false, false, false)
  if self.radarDiscountAnimTimer then
    self.radarDiscountAnimTimer:Start()
    self:OnRadarDiscountAnimTick()
    return true
  end
  self.radarDiscountAnimInfo = nil
  self.radarDiscountText:SetText(format_discount_text(toValue))
  return false
end

function UIVipView:TryPlayRadarDiscountDailyAnim(context, percent)
  if not context or not self.vipGiftActManager then
    return false
  end
  local actId = context.actId
  local giftId = context.giftId
  local stage = context.stage
  if not stage then
    return false
  end
  local stageConfig = stage.config
  if not stageConfig then
    return false
  end
  local dayInfo = self.vipGiftActManager:GetDayInfo(actId)
  local currentDay = dayInfo and tonumber(dayInfo.currentDay) or 0
  local maxDay = dayInfo and tonumber(dayInfo.maxDay) or 0
  if currentDay <= 0 then
    return false
  end
  if 0 < maxDay and currentDay > maxDay then
    return false
  end
  radarDiscountPlayedDays = radarDiscountPlayedDays or {}
  local actMap = radarDiscountPlayedDays[actId]
  local lastPlayedDay = 0
  if actMap then
    lastPlayedDay = actMap[giftId] or 0
  end
  local storedDay = load_played_day(RADAR_DISCOUNT_PLAYED_PREFIX, actId, giftId)
  if lastPlayedDay < storedDay then
    lastPlayedDay = storedDay
  end
  if lastPlayedDay == currentDay then
    return false
  end
  percent = tonumber(percent) or 0
  if percent <= 0 then
    return false
  end
  
  local function sum_extra_units(list)
    local total = 0
    for _, reward in ipairs(to_array(list)) do
      local c = get_radar_reward_count_for_anim(reward)
      if 0 < c then
        total = total + c
      end
    end
    return total
  end
  
  local serverExtraList = stage.extraRewards or stage.rewards or stage.putBoxParam or {}
  local configExtraList = stageConfig.extraRewards or stageConfig.rewards or stageConfig.putBoxParam or {}
  local unitsToday = sum_extra_units(serverExtraList)
  local unitsPerDay = sum_extra_units(configExtraList)
  if unitsToday <= 0 or unitsPerDay <= 0 then
    return false
  end
  local unitsYesterday = unitsToday - unitsPerDay
  if unitsYesterday < 0 then
    unitsYesterday = 0
  end
  if unitsYesterday == unitsToday then
    return false
  end
  local basePercent = 0
  do
    local vipGiftId = stageConfig.vipGiftId or stage.vipGiftId
    if vipGiftId and 0 < vipGiftId then
      local pack = GiftPackageData.get(tostring(vipGiftId))
      local packPercent = pack and pack:getPercent()
      basePercent = tonumber(packPercent) or 0
    end
  end
  local perItemBonus = tonumber(stageConfig.addScore or stageConfig.rebateStep or stageConfig.rebateRatioRaw) or 0
  if perItemBonus == 0 then
    return false
  end
  local yesterdayPercent = basePercent + perItemBonus * unitsYesterday
  local todayPercent = basePercent + perItemBonus * unitsToday
  if math.abs(todayPercent - yesterdayPercent) < 0.01 then
    return false
  end
  self:PlayRadarDiscountAnim(yesterdayPercent, todayPercent)
  actMap = actMap or {}
  actMap[giftId] = currentDay
  radarDiscountPlayedDays[actId] = actMap
  save_played_day(RADAR_DISCOUNT_PLAYED_PREFIX, actId, giftId, currentDay)
  return true
end

function UIVipView:RefreshRadarPack(context)
  if not context or not context.stage then
    self:ClearRadarLayout()
    return
  end
  local packData = self.giftPackData
  packData = packData or GiftPackageData.get(tostring(context.giftId))
  if packData then
    self.radarPackNameText:SetText(packData:getNameText())
    self.radarDescText:SetLocalText(2000267, packData:getBuyTimes())
  end
  if self.radarDiscountText then
    local percent = 0
    if self.vipGiftActManager then
      percent = self.vipGiftActManager:GetStageDiscountPercent(context.actId, context.stage) or 0
    end
    if percent and 0 < percent then
      if not self:TryPlayRadarDiscountDailyAnim(context, percent) then
        self:StopRadarDiscountAnim()
        self.radarDiscountText:SetText(format_discount_text(percent))
      end
    else
      self:StopRadarDiscountAnim()
      self.radarDiscountText:SetText("")
    end
  end
  self.radarPackRewards = to_array(self.levelPackRewards or {})
  self:RefreshRadarPackItems(self.radarPackRewards)
  local extraRewards = {}
  if context.stage.extraRewards and 0 < #context.stage.extraRewards then
    extraRewards = to_array(context.stage.extraRewards)
  elseif context.stage.rewards and 0 < #context.stage.rewards then
    extraRewards = to_array(context.stage.rewards)
  end
  local stageConfig = context.stage.config
  local configExtra = {}
  if stageConfig then
    if stageConfig.extraRewards and 0 < #stageConfig.extraRewards then
      configExtra = to_array(stageConfig.extraRewards)
    elseif stageConfig.rewards and 0 < #stageConfig.rewards then
      configExtra = to_array(stageConfig.rewards)
    elseif stageConfig.putBoxParam and 0 < #stageConfig.putBoxParam then
      configExtra = to_array(stageConfig.putBoxParam)
    end
  end
  self:RefreshRadarExtraRewardItems(extraRewards, configExtra, context)
end

function UIVipView:RefreshRadarPackItems(items)
  if not self.radarPackGrid then
    return
  end
  self.radarPackReqs = self.radarPackReqs or {}
  self.radarPackCells = self.radarPackCells or {}
  self.radarPackPendingRewards = self.radarPackPendingRewards or {}
  local rewards = to_array(items)
  local total = #rewards
  if total == 0 then
    for index, cell in ipairs(self.radarPackCells) do
      self.radarPackPendingRewards[index] = nil
      if cell then
        local go = cell.gameObject
        if go and IsNull and IsNull(go) then
          go = nil
        end
        if go and go.SetActive then
          go:SetActive(false)
        elseif cell.SetActive then
          cell:SetActive(false)
        end
      end
    end
    for index, request in pairs(self.radarPackReqs) do
      if request and request.Destroy then
        request:Destroy()
      end
      self.radarPackReqs[index] = nil
    end
    return
  end
  for index = 1, total do
    local reward = rewards[index]
    self.radarPackPendingRewards[index] = reward
    local cell = self.radarPackCells[index]
    local go = cell and cell.gameObject or nil
    if go and IsNull and IsNull(go) then
      go = nil
    end
    if cell and cell.ReInit and go then
      go.name = string.format("radar_pack_reward_%d", index)
      if go.SetActive then
        go:SetActive(true)
      end
      local transform = go.transform
      if transform then
        if transform.parent ~= self.radarPackGrid.transform then
          transform:SetParent(self.radarPackGrid.transform)
        end
        if transform.SetSiblingIndex then
          transform:SetSiblingIndex(index - 1)
        end
      end
      if cell.SetLocalScaleXYZ then
        cell:SetLocalScaleXYZ(0.62, 0.62, 0.62)
      end
      if cell.SetPivotMiddle then
        cell:SetPivotMiddle()
      end
      cell:ReInit(reward)
      if cell.SetItemCountActive then
        cell:SetItemCountActive(true)
      end
      self.radarPackReqs[index] = nil
    else
      if cell and not go then
        self.radarPackCells[index] = nil
      end
      if not self.radarPackReqs[index] then
        local idx = index
        local request
        request = self.radarPackGrid:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function()
          if not self.radarPackGrid then
            return
          end
          local go = request and request.gameObject or nil
          if not go then
            return
          end
          go.name = string.format("radar_pack_reward_%d", idx)
          go.transform:SetParent(self.radarPackGrid.transform)
          if go.transform and go.transform.SetSiblingIndex then
            go.transform:SetSiblingIndex(idx - 1)
          end
          local cell = self.radarPackGrid:AddComponent(UICommonResItem, go)
          if cell.SetLocalScaleXYZ then
            cell:SetLocalScaleXYZ(0.62, 0.62, 0.62)
          end
          if cell.SetPivotMiddle then
            cell:SetPivotMiddle()
          end
          self.radarPackCells[idx] = cell
          local rewardData = self.radarPackPendingRewards and self.radarPackPendingRewards[idx] or nil
          if rewardData then
            cell:ReInit(rewardData)
            if cell.SetItemCountActive then
              cell:SetItemCountActive(true)
            end
            if go.SetActive then
              go:SetActive(true)
            end
          elseif go.SetActive then
            go:SetActive(false)
          end
          self.radarPackReqs[idx] = nil
        end)
        if request then
          self.radarPackReqs[idx] = request
        end
      end
    end
  end
  local cells = self.radarPackCells
  for index = total + 1, #cells do
    local cell = cells[index]
    self.radarPackPendingRewards[index] = nil
    if cell then
      local go = cell.gameObject
      if go and IsNull and IsNull(go) then
        go = nil
      end
      if go and go.SetActive then
        go:SetActive(false)
      elseif cell.SetActive then
        cell:SetActive(false)
      end
    end
  end
  for index, request in pairs(self.radarPackReqs) do
    if total < index then
      if request and request.Destroy then
        request:Destroy()
      end
      self.radarPackReqs[index] = nil
    end
  end
  for index in pairs(self.radarPackPendingRewards) do
    if total < index then
      self.radarPackPendingRewards[index] = nil
    end
  end
end

function UIVipView:RefreshRadarExtraRewardItems(items, configItems, context)
  if not self.radarExtraReward then
    return
  end
  self.radarExtraRewardReqs = self.radarExtraRewardReqs or {}
  self.radarExtraRewardCells = self.radarExtraRewardCells or {}
  self.radarExtraRewardPendingRewards = self.radarExtraRewardPendingRewards or {}
  local rewards = to_array(items)
  local total = #rewards
  local actId = context and context.actId or nil
  local giftId = context and context.giftId or nil
  local currentDay = 0
  local shouldAnimate = true
  if actId and giftId and self.vipGiftActManager then
    local dayInfo = self.vipGiftActManager:GetDayInfo(actId)
    currentDay = dayInfo and tonumber(dayInfo.currentDay) or 0
    local maxDay = dayInfo and tonumber(dayInfo.maxDay) or 0
    if 0 < currentDay then
      if 0 < maxDay and currentDay > maxDay then
        shouldAnimate = false
      else
        radarExtraPlayedDays = radarExtraPlayedDays or {}
        local actMap = radarExtraPlayedDays[actId]
        local lastPlayedDay = 0
        if actMap then
          lastPlayedDay = actMap[giftId] or 0
        end
        local storedDay = load_played_day(RADAR_EXTRA_PLAYED_PREFIX, actId, giftId)
        if lastPlayedDay < storedDay then
          lastPlayedDay = storedDay
        end
        if lastPlayedDay == currentDay then
          shouldAnimate = false
        end
      end
    end
  end
  local configList = to_array(configItems or {})
  local todayCounts = {}
  local yesterdayCounts = {}
  for index = 1, total do
    local reward = rewards[index]
    local today = get_radar_reward_count_for_anim(reward)
    local cfgReward = configList[index]
    local perDay = cfgReward and get_radar_reward_count_for_anim(cfgReward) or 0
    local yesterday = today - perDay
    if yesterday < 0 then
      yesterday = 0
    end
    todayCounts[index] = today
    yesterdayCounts[index] = yesterday
  end
  if total == 0 then
    self.radarExtraReward:SetActive(false)
    for index, cell in ipairs(self.radarExtraRewardCells) do
      if cell and cell.SetActive then
        cell:SetActive(false)
      elseif cell and cell.gameObject then
        cell.gameObject:SetActive(false)
      end
      self.radarExtraRewardPendingRewards[index] = nil
    end
    for index, request in pairs(self.radarExtraRewardReqs) do
      if request and request.Destroy then
        request:Destroy()
      end
      self.radarExtraRewardReqs[index] = nil
    end
    self:StopRadarExtraCountAnim()
    return
  end
  self.radarExtraReward:SetActive(true)
  for index = 1, total do
    local reward = rewards[index]
    self.radarExtraRewardPendingRewards[index] = reward
    local cell = self.radarExtraRewardCells[index]
    local go = cell and cell.gameObject or nil
    if go and IsNull and IsNull(go) then
      go = nil
    end
    if cell and cell.ReInit and go then
      go.name = string.format("radar_extra_reward_%d", index)
      if cell.SetActive then
        cell:SetActive(true)
      else
        go:SetActive(true)
      end
      cell:SetLocalScaleXYZ(0.62, 0.62, 0.62)
      cell:SetPivotMiddle()
      cell:SetSizeDeltaXY(80, 80)
      cell:ReInit(reward)
      cell:SetItemCountActive(true)
      self.radarExtraRewardReqs[index] = nil
    elseif go == nil and cell then
      self.radarExtraRewardCells[index] = nil
    elseif not self.radarExtraRewardReqs[index] then
      local idx = index
      local request
      request = self.radarExtraReward:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function()
        if not self.radarExtraReward then
          return
        end
        local go = request and request.gameObject or nil
        if not go then
          return
        end
        go.name = string.format("radar_extra_reward_%d", idx)
        go.transform:SetParent(self.radarExtraReward.transform)
        local cell = self.radarExtraReward:AddComponent(UICommonResItem, go)
        cell:SetLocalScaleXYZ(0.62, 0.62, 0.62)
        cell:SetPivotMiddle()
        cell:SetSizeDeltaXY(80, 80)
        self.radarExtraRewardCells[idx] = cell
        local rewardData = self.radarExtraRewardPendingRewards and self.radarExtraRewardPendingRewards[idx] or nil
        if rewardData then
          cell:ReInit(rewardData)
          cell:SetItemCountActive(true)
          if cell.SetActive then
            cell:SetActive(true)
          else
            go:SetActive(true)
          end
        elseif cell.SetActive then
          cell:SetActive(false)
        else
          go:SetActive(false)
        end
        self.radarExtraRewardReqs[idx] = nil
      end)
      if request then
        self.radarExtraRewardReqs[idx] = request
      end
    end
  end
  local cells = self.radarExtraRewardCells
  for index = total + 1, #cells do
    local cell = cells[index]
    self.radarExtraRewardPendingRewards[index] = nil
    if cell then
      if cell.SetActive then
        cell:SetActive(false)
      elseif cell.gameObject then
        cell.gameObject:SetActive(false)
      end
    end
  end
  for index, request in pairs(self.radarExtraRewardReqs) do
    if total < index then
      if request and request.Destroy then
        request:Destroy()
      end
      self.radarExtraRewardReqs[index] = nil
    end
  end
  for index in pairs(self.radarExtraRewardPendingRewards) do
    if total < index then
      self.radarExtraRewardPendingRewards[index] = nil
    end
  end
  if shouldAnimate then
    self:StartRadarExtraCountAnim(yesterdayCounts, todayCounts)
    if actId and giftId and 0 < currentDay then
      radarExtraPlayedDays = radarExtraPlayedDays or {}
      local actMap = radarExtraPlayedDays[actId] or {}
      actMap[giftId] = currentDay
      radarExtraPlayedDays[actId] = actMap
      save_played_day(RADAR_EXTRA_PLAYED_PREFIX, actId, giftId, currentDay)
    end
  end
end

function UIVipView:RefreshPayGift(id)
  if not self.curVipTemplate then
    self:UpdateVipPackLayout()
    return
  end
  self.giftPackData = GiftPackageData.get(tostring(self.curVipTemplate.reward2))
  self.levelPackCellScroll:ClearCells()
  self.levelPackCellScroll:RemoveComponents(UICommonResItem)
  if not self.giftPackData then
    self.levelPackNameText:SetText("")
    self.levelPackDiscount:SetActive(false)
    UIGray.SetGray(self.levelPackBuyBtn.transform, true, false)
    self.levelPackBuyBtnText:SetLocalText(2000292)
    self.levelPackPoint:SetActive(false)
    self:UpdateVipPackLayout()
    return
  end
  self.levelPackRewards = self.giftPackData:getItems(true)
  if #self.levelPackRewards > 0 then
    self.levelPackCellScroll:SetTotalCount(#self.levelPackRewards)
    self.levelPackCellScroll:RefillCells()
  end
  local levelPackImgPath = self.giftPackData:getPopupImageMini()
  local useRadarForImage, radarContextForImage = self:CheckRadarPackContext()
  if useRadarForImage and radarContextForImage and radarContextForImage.stage then
    local stageData = radarContextForImage.stage
    
    local function pickVipPic(source)
      if not source then
        return nil
      end
      local pic = source.vipPic
      if pic and not string.IsNullOrEmpty(pic) then
        return string.format(PACK_IMG_PATH, pic)
      end
      return nil
    end
    
    local vipPic = pickVipPic(stageData) or pickVipPic(stageData.config)
    if vipPic and not string.IsNullOrEmpty(vipPic) then
      levelPackImgPath = vipPic
    end
  end
  if levelPackImgPath and levelPackImgPath ~= "" then
    self.levelPackImg:LoadSprite(levelPackImgPath)
  else
    self.levelPackImg:LoadSprite(self.giftPackData:getPopupImageMini())
  end
  self.levelPackImg:SetNativeSize()
  self.levelPackNameText:SetText(self.giftPackData:getNameText())
  local percent = self.giftPackData:getPercent()
  if not string.IsNullOrEmpty(percent) then
    self.levelPackDiscount:SetActive(true)
    self.levelPackDiscountText:SetText(string.format("%s", percent))
  else
    self.levelPackDiscount:SetActive(false)
  end
  local state = DataCenter.VIPManager:AnalyzePayGoodState(self.curVipTemplate.level, self.curVipTemplate.reward2)
  if state == VipPayGoodState.Lock then
    UIGray.SetGray(self.levelPackBuyBtn.transform, true, false)
    self.levelPackBuyBtnText:SetLocalText(2000292)
    self.levelPackPoint:SetActive(false)
    self.levelPackDescText:SetLocalText(2000267, self.giftPackData:getBuyTimes())
  elseif state == VipPayGoodState.CanBuy then
    UIGray.SetGray(self.levelPackBuyBtn.transform, false, true)
    self.levelPackBuyBtnText:SetText(self.giftPackData:getPriceText())
    self.levelPackDescText:SetLocalText(2000267, self.giftPackData:getBuyTimes())
    self.levelPackPoint:SetActive(true)
    self.levelPackPoint:RefreshPoint(self.giftPackData)
  elseif state == VipPayGoodState.HasGet or VipPayGoodState.CanGet then
    UIGray.SetGray(self.levelPackBuyBtn.transform, true, false)
    self.levelPackBuyBtnText:SetLocalText(2000294)
    self.levelPackDescText:SetLocalText(2000267, self.giftPackData:getBuyTimes())
    self.levelPackPoint:SetActive(false)
  end
  self:UpdateVipPackLayout()
end

function UIVipView:RefreshDailyBox()
  if not DataCenter.VIPManager:CanGetDailyPoint() then
    self:AddTimer()
    self.canGet = false
    self.freePackageBtnAnimN:Play("V_ui_zhoukabaoxiang_01_opened", 0, 0)
    self.freePackageOpenN:SetActive(true)
    self.freePackageUnopenN:SetActive(false)
  else
    self.canGet = true
    self.freePackageBtnAnimN:Play("V_ui_zhoukabaoxiang_01_idle", 0, 0)
    self.freePackageOpenN:SetActive(false)
    self.freePackageUnopenN:SetActive(true)
  end
end

function UIVipView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIVipView:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
    self.timer:Start()
  end
  self.timer_action()
end

function UIVipView:RefreshTime()
  local resTime = UITimeManager:GetInstance():GetResSecondsTo24()
  if resTime <= 0 then
    self:DeleteTimer()
  elseif self.refreshFreePackTime then
    self.dailyPackClaimBtnText:SetText(UITimeManager:GetInstance():SecondToFmtString(resTime))
  end
  if self.vipInfo then
    if self.shouldUpdateRenew then
      local endTime = self.vipInfo.endTime
      if endTime and 0 < endTime then
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        if endTime >= curTime then
          self.renewBtnText:SetText(UITimeManager:GetInstance():SecondToFmtString(self.vipInfo.endTime - curTime))
        else
          self.renewBtnText:SetLocalText(2000271)
          self.shouldUpdateRenew = false
          DataCenter.VIPManager:RequestLatestVipInfo()
          pcall(function()
            DataCenter.VIPManager:VipReqSourceRecord(VipRequestSource.VipView)
          end)
        end
        return
      end
    end
    self:RefreshRenewBtnRedPoint()
  end
end

function UIVipView:RefreshFreePackTime()
end

function UIVipView:GotoPage(page)
  if page < 0 or page > #self.viptemplate then
    return
  end
  self.curVipTemplate = self.viptemplate[page]
  self.scrollIndex = page
  self._prev_btn:SetActive(self.scrollIndex ~= 1)
  self._next_btn:SetActive(self.scrollIndex ~= #self.viptemplate)
  self:RefreshEffectList()
  local str = Localization:GetString(2000270, self.curVipTemplate.level)
  if not self.vipInfo:IsVIPActive() then
    str = string.format("%s  (%s)", str, Localization:GetString(2000292))
  end
  self.centerVIPLevelText:SetText(str)
  self:RefreshFree()
  self:RefreshPayGift()
  self:RefreshSpecialShow()
end

function UIVipView:RefreshSpecialShow()
  if self.curVipTemplate.level == 18 then
    local vip18RootRect = self.vip_extend_root.rectTransform.rect
    local targetHeight = self.effectScrollViewRectOrigin.y + vip18RootRect.y - 20
    self.scrollview.rectTransform.offsetMax = Vector2.New(self.effectScrollViewRectOrigin.x, targetHeight)
    self.vip_extend_root:SetActive(true)
  else
    self.scrollview.rectTransform.offsetMax = self.effectScrollViewRectOrigin
    self.vip_extend_root:SetActive(false)
  end
  self:OnUpdateVipRedDot()
end

function UIVipView:ScrollNextPage(page)
  if self.scrollIndex + page < 0 or self.scrollIndex + page > #self.viptemplate then
    return
  end
  self:GotoPage(self.scrollIndex + page)
end

function UIVipView:OnPageScroll(index)
  self.scrollIndex = index
  self._prev_btn:SetActive(self.scrollIndex ~= 1)
  self._next_btn:SetActive(self.scrollIndex ~= #self.viptemplate)
end

function UIVipView:OnSendDailyPointClick()
  if not self.canGet then
    return
  end
  self.freePackageBtnAnimN:Play("V_ui_zhoukabaoxiang_01_open", 0, 0)
  self.claimFreeTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.ctrl then
      self.ctrl:VipAddLoginScore()
    end
    self.claimFreeTimer = nil
  end, 0.5)
end

function UIVipView:OAddClick()
  self.ctrl:OnOpenPurchase()
end

function UIVipView:RefreshShopBtnRedPoint()
  local showShopRefresh = false
  local lastShowShopRefreshTime = CS.GameEntry.Setting:GetString(SettingKeys.LAST_TIME_SHOW_VIP_SHOP_REFRESH, "")
  if string.IsNullOrEmpty(lastShowShopRefreshTime) then
    showShopRefresh = true
  else
    local lastShowShopRefreshTime = tonumber(lastShowShopRefreshTime)
    local isSameWeek = UITimeManager:GetInstance():CheckIfIsSameWeek(lastShowShopRefreshTime * 1000)
    if not isSameWeek then
      showShopRefresh = true
    end
  end
  self.shopBtnRedPoint:SetActive(showShopRefresh)
end

function UIVipView:RefreshRenewBtnRedPoint()
  if not self.vipInfo then
    self.renewBtnRedPoint:SetActive(false)
    return
  end
  if self.vipInfo:IsVIPActive() then
    self.renewBtnRedPoint:SetActive(false)
    return
  end
  local remainTime = self.vipInfo.endTime - UITimeManager:GetInstance():GetServerSeconds()
  local k1 = LuaEntry.DataConfig:TryGetStr("vip_alert_config", "k1", 10)
  if remainTime < k1 * 60 then
    self.renewBtnRedPoint:SetActive(true)
  end
end

function UIVipView:RefreshOldVipPackTime()
  if self.oldPackEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.oldPackEndTime then
      self:RemoveOldVipPackTimer()
      self.oldVipPackBtn:SetActive(false)
    else
      self.oldVipPackTimeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.oldPackEndTime - curTime))
    end
  end
end

function UIVipView:AddOldVipPackTimer()
  if not self.onRefreshOldVipPackTime then
    self.onRefreshOldVipPackTime = BindCallback(self, self.RefreshOldVipPackTime)
  end
  if not self.oldVipPackTimer then
    self.oldVipPackTimer = TimerManager:GetInstance():GetTimer(1, self.onRefreshOldVipPackTime, self, false, false, true)
    self.oldVipPackTimer:Start()
  end
end

function UIVipView:RemoveOldVipPackTimer()
  if self.oldVipPackTimer then
    self.oldVipPackTimer:Stop()
    self.oldVipPackTimer = nil
  end
end

function UIVipView:RefreshOldVipPacks()
  local oldPackTimeRangeStr = LuaEntry.DataConfig:TryGetStr("vip_old_gift_config", "k2")
  
  local function HideOldVipPack()
    self:RemoveOldVipPackTimer()
    self.oldVipPackBtn:SetActive(false)
  end
  
  if not string.IsNullOrEmpty(oldPackTimeRangeStr) then
    local timeArr = string.split(oldPackTimeRangeStr, ";")
    if #timeArr == 2 then
      self.oldPackStartTime = tonumber(timeArr[1])
      self.oldPackEndTime = tonumber(timeArr[2])
    end
    if not self.oldPackStartTime or not self.oldPackEndTime then
      HideOldVipPack()
      return
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local inTime = curTime >= self.oldPackStartTime and curTime <= self.oldPackEndTime
    if inTime then
      local serverRange = LuaEntry.DataConfig:TryGetStr("vip_old_gift_config", "k3")
      if not string.IsNullOrEmpty(serverRange) then
        local serverRangeArr = string.split(serverRange, ";")
        if 2 <= #serverRangeArr then
          local startServerId = tonumber(serverRangeArr[1])
          local endServerId = tonumber(serverRangeArr[2])
          local serverId = LuaEntry.Player:GetSourceServerId()
          if startServerId <= serverId and endServerId >= serverId then
            self.oldVipPackBtn:SetActive(true)
            self:RefreshOldVipPackTime()
            self:AddOldVipPackTimer()
            return
          end
        end
      end
    end
  end
  HideOldVipPack()
end

function UIVipView:OnUpdateVipRedDot()
  local isV18Red = DataCenter.VipExtendManager:IsRed()
  local isVip18ContactRed = DataCenter.VipExtendManager:IsVip18ContactRed()
  self.vip_extend_btn_red_dot:SetActive(isV18Red or isVip18ContactRed)
end

function UIVipView:ItemRevertCustomAdd()
  local openLv = LuaEntry.DataConfig:TryGetNum("undo_system", "k2")
  local mainLv = DataCenter.BuildManager.MainLv
  if openLv > mainLv then
    return
  end
  local isFunctionOn = LuaEntry.DataConfig:CheckSwitch("undo_system_switch")
  if not isFunctionOn then
    return
  end
  local customData = {
    id = "custom",
    descID = "undo_system_vip_name",
    isNew = false,
    num_type = 1,
    value = 1
  }
  local targetLv = self.scrollIndex
  local isFirstStage = false
  local k4 = LuaEntry.DataConfig:TryGetStr("undo_system", "k4")
  if k4 and k4 ~= "" then
    local k4List = string.split(k4, ";")
    for i = 1, #k4List do
      local k4Data = string.split(k4List[i], "|")
      if #k4Data == 2 then
        local lv = tonumber(k4Data[1])
        if targetLv <= lv then
          if i == 1 then
            isFirstStage = true
          end
          customData.value = tonumber(k4Data[2])
          break
        end
      end
    end
  end
  for i = 1, #self.curVipTemplate.effect do
    local data = self.curVipTemplate.effect[i]
    if data.id == customData.id then
      table.remove(self.curVipTemplate.effect, i)
      break
    end
  end
  if isFirstStage then
    return
  end
  table.insert(self.curVipTemplate.effect, customData)
end

return UIVipView
