local LuckyShopMain = BaseClass("LuckyShopMain", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LuckyShopItem = require("UI.UIActivityCenterTable.Component.LuckyShop.LuckyShopItem")
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local time_path = "Root/TitleBg/Txt_Remaining"
local intro_btn_path = "Root/TitleBg/InfoBtn"
local name_path = "Root/TitleBg/Txt_ActName"
local btn_refresh_path = "Root/right/Btn_Refresh"
local btn_refresh_text_path = "Root/right/Btn_Refresh/Txt_Refresh"
local btn_refresh_free_path = "Root/right/Btn_Free_Refresh"
local btn_refresh_free_text_path = "Root/right/Btn_Free_Refresh/Txt_Free_Refresh"
local btn_add_path = "Root/right/addBg/Btn_Add"
local btn_add_item_icon_path = "Root/right/addBg/Item_Icon"
local btn_refresh_item_icon_path = "Root/right/Btn_Refresh/Item_Icon2"
local item_num_path = "Root/right/addBg/Txt_Item_Num"
local refresh_time_text_title = "Root/right/RefreshTime_Left_Text"
local discount_text_path = "Root/right/offBg/DisCount_Text"
local scroll_view_path = "Root/ScrollView"
local scroll_content_path = "Root/ScrollView/Viewport/Content"
local discount_off_bg_path = "Root/right/offBg"
local top_bg_path = "BG"
local top_bg_scale_helper_path = "BGHelper"
local effect_path = "Root/right/offBg/Effect"
local effect_btn_path = "Root/right/Btn_Refresh/BtnEffect"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DelCountDownTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.time = self:AddComponent(UIText, time_path)
  self.nameText = self:AddComponent(UIText, name_path)
  self.infoBtnN = self:AddComponent(UIButton, intro_btn_path)
  self.infoBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.refreshBtn = self:AddComponent(UIButton, btn_refresh_path)
  self.refreshBtnText = self:AddComponent(UIText, btn_refresh_text_path)
  self.refreshBtn:SetOnClick(function()
    self:OnClickRefreshBtn()
  end)
  self.refreshFreeBtn = self:AddComponent(UIButton, btn_refresh_free_path)
  self.refreshFreeBtnText = self:AddComponent(UIText, btn_refresh_free_text_path)
  self.refreshFreeBtn:SetOnClick(function()
    self:OnClickRefreshFreeBtn()
  end)
  self.refreshFreeBtn:SetActive(false)
  self.addBtn = self:AddComponent(UIButton, btn_add_path)
  self.addBtn:SetOnClick(function()
    self:OnClickAddBtn()
  end)
  self.itemIcon1 = self:AddComponent(UIImage, btn_add_item_icon_path)
  self.itemIcon2 = self:AddComponent(UIImage, btn_refresh_item_icon_path)
  self.itemNum = self:AddComponent(UIText, item_num_path)
  self.discountText = self:AddComponent(UIText, discount_text_path)
  self.discount_off_bg = self:AddComponent(UIBaseContainer, discount_off_bg_path)
  self.refreshTimeText = self:AddComponent(UIText, refresh_time_text_title)
  
  function self.CountDownTimerAction()
    self:RefreshRemainTime()
  end
  
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self._bg_img = self:AddComponent(UIImage, top_bg_path)
  self._bg_img_helper = self:AddComponent(UIImage, top_bg_scale_helper_path)
  self._diamond_topBar = self:AddComponent(UITopItem, "TopBar/DiamondBar")
  self.animator = self:AddComponent(UIAnimator, "")
  self.effectGo = self:AddComponent(UIBaseContainer, effect_path)
  self.effectBtnGo = self:AddComponent(UIBaseContainer, effect_btn_path)
  self.effectBtnGo:SetActive(false)
  self.particle = self.effectGo.transform:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  self.content = self:AddComponent(UIBaseContainer, scroll_content_path)
  self.content_view = self.content.transform:GetComponent(typeof(CS.UnityEngine.UI.GridLayoutGroup))
  self.content_view.spacing = Vector2.New(self.content_view.spacing.x, (self.scroll_view.rectTransform.rect.height - 760) / 3 + self.content_view.spacing.y)
end

local function ComponentDestroy(self)
  self.content_view.spacing = Vector2.New(self.content_view.spacing.x, self.content_view.spacing.y - (self.scroll_view.rectTransform.rect.height - 760) / 3)
  self:ClearScroll()
  if self.flipSequence1 then
    self.flipSequence1:Pause()
    self.flipSequence1:Kill()
    self.flipSequence1 = nil
  end
  if self.discount_off_bg then
    DOTween.Kill(self.discount_off_bg.transform)
  end
  self.discount_off_bg = nil
  self.time = nil
  self.nameText = nil
  self.infoBtnN = nil
  self.refreshBtn = nil
  self.refreshBtnText = nil
  self.refreshFreeBtn = nil
  self.refreshFreeBtnText = nil
  self.addBtn = nil
  self.itemIcon1 = nil
  self.itemIcon2 = nil
  self.itemNum = nil
  self.discountText = nil
  self.discountOffText = nil
  self.refreshTimeText = nil
  self._resNum_btn = nil
end

local function DataDefine(self)
  self.activityId = nil
  self.activityData = nil
  self.dataList = {}
end

local function DataDestroy(self)
  self.activityId = nil
  self.activityData = nil
  self.dataList = {}
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.LuckShopDataUpdate, self.RefreshAll)
  self:AddUIListener(EventId.LuckShopRefresh, self.ShowRefreshEffect)
  self:AddUIListener(EventId.OnPackageInfoUpdated, self.RefreshAll)
  self:AddUIListener(EventId.UpdateGold, self.ShowNeedRes)
  self:AddUIListener(EventId.UseItemSuccess, self.ShowItem)
  self:AddUIListener(EventId.ActFreeRewardReceive, self.ShowItem)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.LuckShopRefresh, self.ShowRefreshEffect)
  self:RemoveUIListener(EventId.LuckShopDataUpdate, self.RefreshAll)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.RefreshAll)
  self:RemoveUIListener(EventId.UpdateGold, self.ShowNeedRes)
  self:RemoveUIListener(EventId.UseItemSuccess, self.ShowItem)
  self:RemoveUIListener(EventId.ActFreeRewardReceive, self.ShowItem)
  base.OnRemoveListener(self)
end

local function SetData(self, activityId)
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  
  local function gotoDiamond()
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.DiamondShop)
  end
  
  self._diamond_topBar:SetData(nil, ResourceType.Gold, gotoDiamond)
  self:RefreshAll()
  DataCenter.LuckyShopManager:SetIsNew()
end

local function RefreshAll(self)
  self.nameText:SetText(Localization:GetString(self.activityData.name))
  self:AddCountDownTimer()
  self:RefreshRemainTime()
  self:ShowCells()
  self:ShowItem()
  self:ShowDisCount()
  self:ShowNeedRes()
end

local function ShowItem(self)
  local data = DataCenter.LuckyShopManager:GetShopInfo()
  if data == nil then
    return
  end
  self.itemIcon1:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(data.refreshGoodsId))
  self.itemIcon2:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(data.refreshGoodsId))
  local count = DataCenter.ItemData:GetItemCount(data.refreshGoodsId)
  self.itemNum:SetText(count .. "/1")
end

local function ShowDisCount(self)
  local data = DataCenter.LuckyShopManager:GetShopInfo()
  if data == nil then
    return
  end
  local localText = ""
  if data.shopArr == nil or table.count(data.shopArr) == 0 then
    self.discountText:SetText("")
    localText = Localization:GetString("320593", "?")
    self.refreshBtnText:SetLocalText(320596)
    self.effectBtnGo:SetActive(true)
  else
    localText = Localization:GetString("320593", data.discount)
    self.refreshBtnText:SetLocalText(320590)
    self.effectBtnGo:SetActive(false)
  end
  self.discountText:SetText(localText .. " " .. "OFF")
end

local function GetListData(self)
  self.dataList = {}
  if not self.activityData then
    return
  end
  local data = DataCenter.LuckyShopManager:GetShopInfo()
  if data == nil then
    return
  end
  for k, v in ipairs(data.shopArr) do
    local para = {}
    para.isNull = false
    para.shopId = v.shopId
    para.rewardType = v.rewardType
    para.rewardId = v.rewardId
    para.rewardNum = v.rewardNum
    para.costType = v.costType
    para.costId = v.costId
    para.isBuy = v:IsBuy()
    para.index = k
    para.costNum = v.costNum
    para.originalPrice = v.price
    para.activityId = self.activityId
    table.insert(self.dataList, para)
  end
  local count = table.count(self.dataList)
  local activity = DataCenter.LuckyShopManager:GetActivity()
  local max = 9
  for i = count + 1, max do
    local para = {}
    para.isNull = true
    para.index = i
    table.insert(self.dataList, para)
  end
end

local function ShowCells(self)
  local needAllRefresh = false
  if self.dataList == nil or table.count(self.dataList) == 0 then
    needAllRefresh = true
  end
  self:GetListData()
  if needAllRefresh then
    self:ClearScroll()
    local count = table.count(self.dataList)
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  else
    local allComp = self.scroll_view:GetComponents(LuckyShopItem)
    for k, v in ipairs(allComp) do
      local index = v.data.index
      if self.dataList[index] ~= nil then
        v:SetData(self.dataList[index])
      end
    end
  end
end

local function AddCountDownTimer(self)
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(0.5, self.CountDownTimerAction, self, false, false, false)
  end
  self.countDownTimer:Start()
end

local function RefreshRemainTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.activityData.endTime - curTime
  if 0 < remainTime then
    self.time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.time:SetText("")
  end
  local data = DataCenter.LuckyShopManager:GetShopInfo()
  if data ~= nil then
    local refreshRemainTime = data.refreshTime * 1000 - curTime
    if 0 < refreshRemainTime then
      self.refreshTimeText:SetLocalText(302012, UITimeManager:GetInstance():MilliSecondToFmtString(refreshRemainTime))
    elseif data.shopArr == nil or table.count(data.shopArr) == 0 then
      local activity = DataCenter.LuckyShopManager:GetActivity()
      if activity ~= nil then
        self.refreshTimeText:SetLocalText(320588, activity.para_2)
      end
    else
      self.refreshTimeText:SetText("")
    end
  end
end

local function DelCountDownTimer(self)
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

local function OnClickInfoBtn(self)
  if self.activityData and self.activityData.story then
    UIUtil.ShowIntro(Localization:GetString(self.activityData.name), Localization:GetString("100239"), Localization:GetString("320592"))
  end
end

local function OnClickAddBtn(self)
  local data = DataCenter.LuckyShopManager:GetShopInfo()
  if data == nil or data.refreshGoodsId == 0 then
    return
  end
  local canGotoPackShop = DataCenter.LuckyShopManager:CanGotoPackShop()
  if canGotoPackShop then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.activityId, DataCenter.LuckyShopManager:GetGiftPackId(), data.refreshGoodsId)
  else
    UIUtil.ShowTipsId(320346)
  end
end

local function OnClickRefreshBtn(self)
  local data = DataCenter.LuckyShopManager:GetShopInfo()
  if data == nil then
    return
  end
  local count = DataCenter.ItemData:GetItemCount(data.refreshGoodsId)
  if count <= 0 then
    self:OnClickAddBtn()
  else
    if not DataCenter.LuckyShopManager:IsAllItemBuy() then
      local needShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.LuckyShopRefresh)
      if needShow then
        UIUtil.ShowSecondMessage("", Localization:GetString("320591"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          DataCenter.LuckyShopManager:RefreshShop(self.activityId)
        end, function(needSellConfirm)
          DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.LuckyShopRefresh, needSellConfirm)
        end, nil, function()
        end, nil, Localization:GetString(GameDialogDefine.TODAY_NO_SHOW), nil, nil, nil)
      else
        DataCenter.LuckyShopManager:RefreshShop(self.activityId)
      end
      return
    end
    DataCenter.LuckyShopManager:RefreshShop(self.activityId)
  end
end

local function OnClickRefreshFreeBtn(self)
  local data = DataCenter.LuckyShopManager:GetShopInfo()
  if data == nil then
    return
  end
  local count = DataCenter.ItemData:GetItemCount(data.refreshGoodsId)
  if count <= 0 then
    self:OnClickAddBtn()
  end
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(LuckyShopItem, itemObj)
  local data = self.dataList[index]
  cellItem:SetData(data)
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, LuckyShopItem)
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(LuckyShopItem)
end

local function ShowRefreshEffect(self)
  self.animator:Play("Eff_ui_zhekou", 0, 0)
  self.particle:Play()
end

function LuckyShopMain:ShowNeedRes()
  if self._diamond_topBar then
    self._diamond_topBar:RefreshData()
  end
end

local function OnAddBtnClick(self)
  if self.addBtncallBack then
    self:addBtncallBack()
    return
  end
  if self.itemId then
    LWResourceLackUtil:GotoGoodsItemLack(self.itemId, showNeedCount)
  elseif self.resourceType == ResourceType.Gold then
    local data = {}
    table.insert(data, {
      resType = self.resourceType,
      need = 100000
    })
    LWResourceLackUtil:GotoResLack(data)
  end
end

LuckyShopMain.ShowRefreshEffect = ShowRefreshEffect
LuckyShopMain.OnCreateCell = OnCreateCell
LuckyShopMain.OnDeleteCell = OnDeleteCell
LuckyShopMain.ClearScroll = ClearScroll
LuckyShopMain.OnCreate = OnCreate
LuckyShopMain.OnDestroy = OnDestroy
LuckyShopMain.ComponentDefine = ComponentDefine
LuckyShopMain.ComponentDestroy = ComponentDestroy
LuckyShopMain.DataDefine = DataDefine
LuckyShopMain.DataDestroy = DataDestroy
LuckyShopMain.OnAddListener = OnAddListener
LuckyShopMain.OnRemoveListener = OnRemoveListener
LuckyShopMain.OnClickRefreshBtn = OnClickRefreshBtn
LuckyShopMain.OnClickRefreshFreeBtn = OnClickRefreshFreeBtn
LuckyShopMain.SetData = SetData
LuckyShopMain.RefreshAll = RefreshAll
LuckyShopMain.ShowCells = ShowCells
LuckyShopMain.AddCountDownTimer = AddCountDownTimer
LuckyShopMain.RefreshRemainTime = RefreshRemainTime
LuckyShopMain.DelCountDownTimer = DelCountDownTimer
LuckyShopMain.GetListData = GetListData
LuckyShopMain.OnClickAddBtn = OnClickAddBtn
LuckyShopMain.OnClickInfoBtn = OnClickInfoBtn
LuckyShopMain.ShowItem = ShowItem
LuckyShopMain.ShowDisCount = ShowDisCount
LuckyShopMain.OnAddBtnClick = OnAddBtnClick
return LuckyShopMain
