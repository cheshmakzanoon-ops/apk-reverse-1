local UITacticalWeaponChipChooseFeedView = BaseClass("UITacticalWeaponChipChooseFeedView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SkillChipSmallItem = require("UI.UILWTWSkillChip.UILWTWSkillChipUpgrade.Component.SkillChipSelectSmallItem")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local close_btn_path = "Root/CloseBtn"
local quality_title_bg_path = "Root/levelInfoBaseRoot/qualityTitleBg"
local level_info_title_path = "Root/levelInfoBaseRoot/levelInfoTitle"
local cur_level_value_path = "Root/levelInfoBaseRoot/curLevelValue"
local arrow_path = "Root/levelInfoBaseRoot/curLevelValue/arrow"
local next_level_value_path = "Root/levelInfoBaseRoot/curLevelValue/nextLevelValue"
local quality_up_tip_path = "Root/levelInfoBaseRoot/qualityUpTip"
local level_progress_path = "Root/levelInfoBaseRoot/levelProgress"
local level_progress_fill_pre_path = "Root/levelInfoBaseRoot/levelProgress/Bg/levelProgressFillPre"
local level_progress_fill_path = "Root/levelInfoBaseRoot/levelProgress/Bg/levelProgressFill"
local level_progress_value_path = "Root/levelInfoBaseRoot/levelProgress/levelProgressValue"
local QUALITY_BG_STR = "Assets/Main/Sprites/UI/LWUITacticalWeaponChip/FX_wurenjixingpian_biaoti%s"
local item_holder_path = "Root/propsNode/ItemHolder"
local item_content_path = "Root/propsNode/ItemHolder/Viewport/ItemContent"
local use_props_tip_path = "Root/propsNode/usePropsTip"
local confirm_btn_path = "Root/confirmBtn"
local confirm_btn_text_path = "Root/confirmBtn/Btn/confirmBtnText"
local bg_btn_path = "Root/BgBtn"
local QUALITY_BAR_PATH = "Assets/Main/Sprites/UI/LWUITacticalWeaponChip/%s"

function UITacticalWeaponChipChooseFeedView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnReInit()
end

function UITacticalWeaponChipChooseFeedView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITacticalWeaponChipChooseFeedView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.bg_btn = self:AddComponent(UIButton, bg_btn_path)
  self.bg_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.qualityTitleBg = self:AddComponent(UIImage, quality_title_bg_path)
  self.levelInfoTitle = self:AddComponent(UITextMeshProUGUIEx, level_info_title_path)
  self.curLevelValue = self:AddComponent(UITextMeshProUGUIEx, cur_level_value_path)
  self.arrowObj = self:AddComponent(UIBaseContainer, arrow_path)
  self.nextLevelValue = self:AddComponent(UITextMeshProUGUIEx, next_level_value_path)
  self.quality_up_tip = self:AddComponent(UITextMeshProUGUIEx, quality_up_tip_path)
  self.levelProgressRoot = self:AddComponent(UIBaseContainer, level_progress_path)
  self.progressDefaultFill = self.levelProgressRoot.rectTransform.sizeDelta.x
  self.levelProgressFillPre = self:AddComponent(UIBaseContainer, level_progress_fill_pre_path)
  self.levelProgressFill = self:AddComponent(UIBaseContainer, level_progress_fill_path)
  self.levelProgressValue = self:AddComponent(UITextMeshProUGUIEx, level_progress_value_path)
  self.chips_scroll_content = self:AddComponent(UIScrollRect, item_content_path)
  self.chips_scroll = self:AddComponent(UILoopGridView, item_holder_path)
  self.chips_scroll:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
  self.chips_scrollRect = self:AddComponent(UIScrollRect, item_holder_path)
  self.use_props_tip = self:AddComponent(UITextMeshProUGUIEx, use_props_tip_path)
  self.use_props_tip:SetLocalText("battlesystem_main_desc5")
  self.noneTips = self:AddComponent(UITextMeshProUGUIEx, "Root/propsNode/noneTips")
  self.noneTips:SetLocalText("battlesystem_main_desc7")
  self.confirm_btn_text = self:AddComponent(UITextMeshProUGUIEx, confirm_btn_text_path)
  self.confirm_btn_text:SetLocalText("battlesystem_main_button4")
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn:SetOnClick(function()
    self:OnConfirmBtn()
  end)
  self.getMoreBtnText = self:AddComponent(UITextMeshProUGUIEx, "Root/getMoreBtn/Btn/getMoreBtnText")
  self.getMoreBtnText:SetLocalText("battlesystem_main_button5")
  self.getMoreBtn = self:AddComponent(UIButton, "Root/getMoreBtn")
  self.getMoreBtn:SetOnClick(function()
    self:OnGetMoreBtnClick()
  end)
  self.clickCallback = BindCallback(self, self.OnSkillChipItemClick)
  self.longPressCallback = BindCallback(self, self.OnSkillChipItemLongPress)
  self.pointerUpCallback = BindCallback(self, self.OnSkillChipItemPointerUp)
  self.unsetClickCallback = BindCallback(self, self.OnUnsetClick)
  self.unsetLongPressCallback = BindCallback(self, self.OnUnsetLongPressStart)
  self.unsetPointerUpCallback = BindCallback(self, self.OnUnsetPointerUp)
  self.beginDragCallback = BindCallback(self, self.OnBeginDrag)
  self.endDragCallback = BindCallback(self, self.OnEndDrag)
  self.dragCallback = BindCallback(self, self.OnDrag)
end

function UITacticalWeaponChipChooseFeedView:ComponentDestroy()
  self:ClearScroll()
  self.close_btn = nil
  self.bg_btn = nil
  self.qualityTitleBg = nil
  self.levelInfoTitle = nil
  self.curLevelValue = nil
  self.arrowObj = nil
  self.nextLevelValue = nil
  self.quality_up_tip = nil
  self.levelProgressRoot = nil
  self.progressDefaultFill = nil
  self.levelProgressFillPre = nil
  self.levelProgressFill = nil
  self.levelProgressValue = nil
  self.chips_scroll_content = nil
  self.chips_scroll = nil
  self.chips_scrollRect = nil
  self.use_props_tip = nil
  self.noneTips = nil
  self.confirm_btn_text = nil
  self.confirm_btn = nil
  self.getMoreBtnText = nil
  self.getMoreBtn = nil
  self.clickCallback = nil
  self.longPressCallback = nil
  self.pointerUpCallback = nil
  self.unsetClickCallback = nil
  self.unsetLongPressCallback = nil
  self.unsetPointerUpCallback = nil
  self.beginDragCallback = nil
  self.endDragCallback = nil
  self.dragCallback = nil
end

function UITacticalWeaponChipChooseFeedView:DataDefine()
  self.cacheToNextLvCurExp = 0
  self.cacheNextLv = 0
end

function UITacticalWeaponChipChooseFeedView:DataDestroy()
  if self.expProgressAniSeq then
    self.expProgressAniSeq:Kill()
    self.expProgressAniSeq = nil
  end
  if self.expValueAniSeq then
    self.expValueAniSeq:Kill()
    self.expValueAniSeq = nil
  end
  self.cacheToNextLvCurExp = nil
  self.cacheNextLv = nil
  self.cacheNextLvTemplate = nil
  self.clickCallback = nil
  self.longPressCallback = nil
  self.pointerUpCallback = nil
  self.unsetClickCallback = nil
  self.unsetLongPressCallback = nil
  self.unsetPointerUpCallback = nil
  self.beginDragCallback = nil
  self.endDragCallback = nil
  self.dragCallback = nil
end

function UITacticalWeaponChipChooseFeedView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TWSkillUpdate, self.OnPropsUpdate)
  self:AddUIListener(EventId.RefreshItems, self.OnPropsUpdate)
end

function UITacticalWeaponChipChooseFeedView:OnRemoveListener()
  self:RemoveUIListener(EventId.TWSkillUpdate, self.OnPropsUpdate)
  self:RemoveUIListener(EventId.RefreshItems, self.OnPropsUpdate)
  base.OnRemoveListener(self)
end

function UITacticalWeaponChipChooseFeedView:OnPropsUpdate()
  self:RefreshList()
end

function UITacticalWeaponChipChooseFeedView:OnReInit()
  self.weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  if self.weaponInfo == nil then
    return
  end
  self:RefreshBaseData()
  self:RefreshList()
  self:RefreshExpProgress()
end

function UITacticalWeaponChipChooseFeedView:RefreshBaseData()
  self.curLv = self.weaponInfo.chipLv
  self.curExp = self.weaponInfo.chipExp
  self.curLevelTemplate = DataCenter.TacticalChipManager:GetLevelTemplate(self.curLv)
  local tier = self.curLevelTemplate.system_tier
  self.curTierTemplate = DataCenter.TacticalChipManager:GetTierTemplate(tier)
  self.qualityTitleBg:LoadSprite(string.format(QUALITY_BAR_PATH, self.curTierTemplate.tier_banner))
  self.levelInfoTitle:SetLocalText(self.curTierTemplate.tier_name)
  self.curLevelValue:SetText(string.format("Lv.%s", self.curLv))
  if not DataCenter.TacticalChipManager:IsMaxTier(tier) then
    local nextTier = tier + 1
    local nextTierTemplate = DataCenter.TacticalChipManager:GetTierTemplate(nextTier)
    self.quality_up_tip:SetLocalText("battlesystem_main_desc3", nextTierTemplate.tier_level)
  end
end

function UITacticalWeaponChipChooseFeedView:RefreshList()
  self.chipsDataList = DataCenter.TacticalChipManager:GetUpgradeProps()
  if table.count(self.chipsDataList) <= 0 then
    self.use_props_tip:SetActive(false)
    self.noneTips:SetActive(true)
    self.chips_scroll:SetActive(false)
    self.chips_scroll:SetListItemCount(0)
  else
    self.use_props_tip:SetActive(true)
    self.noneTips:SetActive(false)
    self.chips_scroll:SetActive(true)
    self.chips_scroll:SetListItemCount(#self.chipsDataList)
    self.chips_scroll:RefreshAllShownItem()
  end
end

function UITacticalWeaponChipChooseFeedView:RefreshExpProgress()
  if self.weaponInfo == nil then
    return
  end
  self.arrowObj:SetActive(false)
  self.nextLevelValue:SetActive(false)
  if DataCenter.TacticalChipManager:IsMaxLevel(self.curLv) then
    self:RefreshExpFill(self.levelProgressFill.rectTransform, 1, 1)
    self:RefreshExpFill(self.levelProgressFillPre.rectTransform, 1, 1)
    self.levelProgressValue:SetLocalText("battlesystem_main_desc6")
    return
  end
  local toNextExp = self.curLevelTemplate.exp_cost
  self:RefreshExpFill(self.levelProgressFill.rectTransform, self.curExp, toNextExp)
  self:RefreshPreExpProgressForce()
end

function UITacticalWeaponChipChooseFeedView:RefreshPreExpProgressForce()
  local curLv = self.curLv
  local curExp = self.curExp
  local preLv, preEx = DataCenter.TacticalChipManager:GetPreLvByUpgradeFeedCache(curLv, curExp)
  local feedData = DataCenter.TacticalChipManager:GetUpgradeFeedCache()
  local addTotalExp = 0
  if feedData then
    addTotalExp = feedData.totalExp
  end
  local percent = preEx / self.curLevelTemplate.exp_cost
  if curLv < preLv then
    percent = 1
  end
  self.cacheToNextLvCurExp = preEx
  self.cacheNextLv = preLv
  self.cacheNextLvTemplate = DataCenter.TacticalChipManager:GetLevelTemplate(preLv)
  local toNextExp = self.curLevelTemplate.exp_cost
  self:RefreshExpFill(self.levelProgressFillPre.rectTransform, self.curExp + addTotalExp, toNextExp)
  self:UpdateExpValue(curExp + addTotalExp)
  if percent == 1 then
    self.nextLevelValue:SetText(string.format("Lv.%s", preLv))
  end
  self.arrowObj:SetActive(percent == 1)
  self.nextLevelValue:SetActive(percent == 1)
end

local expAniDuration = 0.32
local progressAnimScale = 1.2

function UITacticalWeaponChipChooseFeedView:PlayAniPreExpProgress(oldExp, newExp)
  if self.expValueAniSeq then
    self.expValueAniSeq:Kill()
  end
  self.expValueAniSeq = CS.DG.Tweening.DOTween.Sequence()
  local time = 0
  self.expValueAniSeq:Insert(time, self.levelProgressValue.transform:DOScale(Vector3.New(progressAnimScale, progressAnimScale, progressAnimScale), 0.15))
  time = time + expAniDuration * 0.5
  self.expValueAniSeq:Insert(time, self.levelProgressValue.transform:DOScale(Vector3.one, expAniDuration / 2))
  if oldExp >= self.curLevelTemplate.exp_cost and newExp >= self.curLevelTemplate.exp_cost then
    return
  end
  local toNextExp = self.curLevelTemplate.exp_cost
  local from = oldExp
  local to = newExp
  if newExp > self.curLevelTemplate.exp_cost then
    to = self.curLevelTemplate.exp_cost
  elseif oldExp > self.curLevelTemplate.exp_cost then
    from = self.curLevelTemplate.exp_cost
  end
  if self.expProgressAniSeq then
    self.expProgressAniSeq:Kill()
  end
  self.expProgressAniSeq = CS.DG.Tweening.DOTween.Sequence()
  self.expProgressAniSeq:Append(DOTween.To(function(x)
    self:RefreshExpFill(self.levelProgressFillPre.rectTransform, x, toNextExp)
  end, from, to, expAniDuration):SetEase(CS.DG.Tweening.Ease.OutCubic))
end

function UITacticalWeaponChipChooseFeedView:RefreshExpFill(rectTrans, curValue, totalValue)
  local showProgress = math.min(curValue / totalValue, 1)
  if showProgress < 0 then
    showProgress = 0
  end
  local sizeDelta = rectTrans.sizeDelta
  sizeDelta.x = self.progressDefaultFill * showProgress
  rectTrans.sizeDelta = sizeDelta
end

function UITacticalWeaponChipChooseFeedView:OnGetItemByRowColumn(loopScroll, index)
  if self.chipsDataList ~= nil then
    local count = #self.chipsDataList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("TacticalChipItemWithNum")
    local script = self.chips_scroll_content:GetComponent(item.gameObject.name, SkillChipSmallItem)
    if script == nil then
      local name = "props_" .. index
      item.gameObject.name = name
      script = self.chips_scroll_content:AddComponent(SkillChipSmallItem, name)
      script:SetOnClick(self.clickCallback)
      script:SetOnLongPress(self.longPressCallback)
      script:SetOnPointerUp(self.pointerUpCallback)
      script:SetOnUnsetClick(self.unsetClickCallback)
      script:SetOnUnsetLongPress(self.unsetLongPressCallback)
      script:SetOnUnsetPointerUp(self.unsetPointerUpCallback)
      script:SetOnBeginDrag(self.beginDragCallback)
      script:SetOnEndDrag(self.endDragCallback)
      script:SetOnDrag(self.dragCallback)
    end
    script:SetActive(true)
    local data = self.chipsDataList[index]
    script:SetData(data)
    return item
  end
end

function UITacticalWeaponChipChooseFeedView:ClearScroll()
  if self.chips_scroll then
    self.chips_scroll_content:RemoveComponents(SkillChipSmallItem)
    self.chips_scroll:ClearAllItems()
    self.chips_scroll = nil
  end
end

function UITacticalWeaponChipChooseFeedView:OnSkillChipItemClick(item, itemInfo)
  if not itemInfo then
    return
  end
  if self.startLongPress then
    self:RemoveLongPressTimer()
    return
  end
  if DataCenter.TacticalChipManager:IsMaxLevel(self.curLv) then
    return
  end
  self:OnAddFeed(item, itemInfo)
end

function UITacticalWeaponChipChooseFeedView:OnUnsetClick(item, itemInfo)
  if not itemInfo then
    return
  end
  if self.startLongPress then
    self:RemoveLongPressTimer()
    return
  end
  self:OnSubFeed(item, itemInfo)
end

function UITacticalWeaponChipChooseFeedView:OnAddFeed(item, itemInfo)
  if DataCenter.TacticalChipManager:IsMaxLevel(self.cacheNextLv) then
    return
  end
  if itemInfo.useCount >= itemInfo.maxCount then
    if self.startLongPress then
      self:RemoveLongPressTimer()
    end
    item:SetSelectNumber(itemInfo.useCount)
    return
  end
  if DataCenter.TacticalChipManager:IsChipFeed(itemInfo) then
    local isNotRecommended, tipsKey = DataCenter.TacticalChipManager:NotRecommendedFeed(itemInfo.uuid)
    if isNotRecommended then
      UIUtil.TryShowConfirm(TodayNoSecondConfirmType.TacticalChipUpgradeFeedUse, Localization:GetString(tipsKey), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:OnAddFeedInner(item, itemInfo)
      end, nil, nil, Localization:GetString("battlesystem_consume_chips_confirm1"), false, nil, nil)
    else
      self:OnAddFeedInner(item, itemInfo)
    end
  else
    self:OnAddFeedInner(item, itemInfo)
  end
end

function UITacticalWeaponChipChooseFeedView:OnAddFeedInner(item, itemInfo)
  local oldAddExp, newAddExp = DataCenter.TacticalChipManager:AddUpgradeFeedCache(itemInfo)
  self:PlayAniPreExpProgress(self.curExp + oldAddExp, self.curExp + newAddExp)
  local exp = self.cacheToNextLvCurExp + itemInfo.addExp
  if exp >= self.cacheNextLvTemplate.exp_cost then
    local residueExp = exp
    repeat
      residueExp = residueExp - self.cacheNextLvTemplate.exp_cost
      self.cacheNextLv = self.cacheNextLv + 1
      self.cacheNextLvTemplate = DataCenter.TacticalChipManager:GetLevelTemplate(self.cacheNextLv)
    until residueExp < self.cacheNextLvTemplate.exp_cost or DataCenter.TacticalChipManager:IsMaxLevel(self.cacheNextLv)
    self.cacheToNextLvCurExp = residueExp
  else
    self.cacheToNextLvCurExp = exp
  end
  self:UpdateExpValue(self.curExp + newAddExp)
  local useCount = DataCenter.TacticalChipManager:GetFeedUseCountCache(itemInfo.type, itemInfo.uuid)
  item:SetSelectNumber(useCount)
end

function UITacticalWeaponChipChooseFeedView:OnSubFeed(item, itemInfo)
  if itemInfo.useCount <= 0 then
    if self.startLongPress then
      self:RemoveLongPressTimer()
    end
    item:SetSelectNumber(0)
    return
  end
  local oldAddExp, newAddExp = DataCenter.TacticalChipManager:SubUpgradeFeedCache(itemInfo)
  self:PlayAniPreExpProgress(self.curExp + oldAddExp, self.curExp + newAddExp)
  local exp = self.cacheToNextLvCurExp - itemInfo.addExp
  if exp < 0 then
    local residueExp = exp
    repeat
      self.cacheNextLv = self.cacheNextLv - 1
      self.cacheNextLvTemplate = DataCenter.TacticalChipManager:GetLevelTemplate(self.cacheNextLv)
      residueExp = residueExp + self.cacheNextLvTemplate.exp_cost
    until 0 <= residueExp or self.cacheNextLv == 0
    self.cacheToNextLvCurExp = residueExp
  else
    self.cacheToNextLvCurExp = exp
  end
  self:UpdateExpValue(self.curExp + newAddExp)
  local useCount = DataCenter.TacticalChipManager:GetFeedUseCountCache(itemInfo.type, itemInfo.uuid)
  item:SetSelectNumber(useCount)
end

function UITacticalWeaponChipChooseFeedView:UpdateExpValue(newExp)
  local preLv, preEx = DataCenter.TacticalChipManager:GetPreLvByUpgradeFeedCache(self.curLv, self.curExp)
  self.arrowObj:SetActive(preLv > self.curLv)
  self.nextLevelValue:SetActive(preLv > self.curLv)
  self.levelProgressValue:SetText(string.format("%s/%s", newExp, self.curLevelTemplate.exp_cost))
  self.nextLevelValue:SetText(string.format("Lv.%s", preLv))
end

function UITacticalWeaponChipChooseFeedView:OnLongPressTimer()
  if self.startLongPress and self.longPressItem and self.longPressItemInfo then
    if self.addSpeed > 0 then
      self:OnAddFeed(self.longPressItem, self.longPressItemInfo)
    elseif self.addSpeed < 0 then
      self:OnSubFeed(self.longPressItem, self.longPressItemInfo)
    end
  end
end

function UITacticalWeaponChipChooseFeedView:OnSkillChipItemLongPress(item, itemInfo)
  if not itemInfo then
    return
  end
  if self.startLongPress then
    self:RemoveLongPressTimer()
  end
  if DataCenter.TacticalChipManager:IsMaxLevel(self.curLv) then
    return
  end
  self.startLongPress = true
  self.longPressItemInfo = itemInfo
  self.longPressItem = item
  self:AddLongPressTimer()
  self.addSpeed = 1
end

function UITacticalWeaponChipChooseFeedView:OnSkillChipItemPointerUp(item, itemInfo)
  if not itemInfo then
    return
  end
  self:RemoveLongPressTimer(self)
end

function UITacticalWeaponChipChooseFeedView:OnUnsetLongPressStart(item, itemInfo)
  if not itemInfo then
    return
  end
  if self.startLongPress then
    self:RemoveLongPressTimer()
  end
  self.startLongPress = true
  self.longPressItemInfo = itemInfo
  self.longPressItem = item
  self:AddLongPressTimer()
  self.addSpeed = -1
end

function UITacticalWeaponChipChooseFeedView:OnUnsetPointerUp(item, itemInfo)
  if not itemInfo then
    return
  end
  self:RemoveLongPressTimer(self)
end

function UITacticalWeaponChipChooseFeedView:OnBeginDrag(eventData)
  if self.chips_scrollRect then
    self.chips_scrollRect:OnBeginDrag(eventData)
  end
  if self.chips_scroll then
    self.chips_scroll:OnBeginDrag(eventData)
  end
end

function UITacticalWeaponChipChooseFeedView:OnEndDrag(eventData)
  if self.chips_scrollRect then
    self.chips_scrollRect:OnEndDrag(eventData)
  end
  if self.chips_scroll then
    self.chips_scroll:OnEndDrag(eventData)
  end
end

function UITacticalWeaponChipChooseFeedView:OnDrag(eventData)
  if self.chips_scrollRect then
    self.chips_scrollRect:OnDrag(eventData)
  end
  if self.chips_scroll then
    self.chips_scroll:OnDrag(eventData)
  end
end

function UITacticalWeaponChipChooseFeedView:OnConfirmBtn()
  self.ctrl:CloseSelf()
end

function UITacticalWeaponChipChooseFeedView:OnGetMoreBtnClick()
  TacticalWeaponUtils.ShowSkillChipExpLackWindow()
end

function UITacticalWeaponChipChooseFeedView:AddLongPressTimer()
  if self.longPressTimer == nil then
    self.longPressTimer = TimerManager:GetInstance():GetTimer(0.1, function()
      self:OnLongPressTimer()
    end, nil, false, false, false)
  end
  self.longPressTimer:Start()
end

function UITacticalWeaponChipChooseFeedView:RemoveLongPressTimer()
  if self.longPressTimer ~= nil then
    self.longPressTimer:Stop()
    self.longPressTimer = nil
  end
  self.startLongPress = false
  self.longPressItem = nil
  self.longPressItemInfo = nil
  self.addSpeed = 1
end

return UITacticalWeaponChipChooseFeedView
