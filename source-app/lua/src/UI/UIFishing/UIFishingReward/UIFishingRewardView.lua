local UIFishingRewardView = BaseClass("UIFishingRewardView", UIBaseView)
local base = UIBaseView
local UIGuidePioneerHeroExpCell = require("UI.UIPVE.UIPVEResult.Component.UIGuidePioneerHeroExpCell")
local UICommonRewardPopUpComponent = require("UI.UICommonRewardTitle.UICommonRewardPopUpComponent")
local reward_path = "UICommonRewardPopUp"
local panel_path = "UICommonRewardPopUp/Panel"
local banner_path = "UICommonRewardPopUp/Panel/Banner"
local img_title_bg_path = "UICommonRewardPopUp/Panel/ImgTitleBg"
local title_name_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local layout_path = "layout"
local hero_list_path = "layout/heroList"
local scroll_view_path = "layout/CellList"
local skip_anim_btn_path = "SkipAnimButton"
local scroll_view_change_path = "CellListChange"
local rect_newchange_path = "Rect_NewChange"
local special_bg_path = "SpecialBg"
local other_title_text_path = "SpecialBg/OtherTitleBg/OtherTitleText"
local tips_content_path = "layout/TipsContent"
local tips_text_path = "layout/TipsContent/TipsText"
local click_tp_path = "layout/clickTp"
local cellDelay = 0.125
local lineCount = 4

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local param = self:GetUserData()
  self.param = param
  self:SortReward()
  if self.param.heroExp ~= nil then
    self.heroList:SetActive(true)
  else
    self.heroList:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
end

function UIFishingRewardView:SortReward()
  if self.param and self.param.rewardList and #self.param.rewardList > 1 then
    for i, v in ipairs(self.param.rewardList) do
      v._originIdx = i
      v._quality = DataCenter.RewardManager:GetRewardQualityWithOthers(v.rewardType, v.itemId)
    end
    table.sort(self.param.rewardList, function(a, b)
      local orderA = a._quality or 0
      local orderB = b._quality or 0
      if orderA ~= orderB then
        return orderA > orderB
      end
      return a._originIdx < b._originIdx
    end)
  end
end

local function OnDestroy(self)
  self:ClearAllDelayTimers()
  if DataCenter.GuideManager:GetGuideType() == GuideType.ShowFakeHero then
    DataCenter.GuideManager:DoNext()
  end
  if self.param and self.param.CloseFunc then
    self.param.CloseFunc()
  end
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.rewardTitle = self:TryAddComponent(UICommonRewardPopUpComponent, reward_path)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.banner = self:AddComponent(UIBaseContainer, banner_path)
  self.img_title_bg = self:AddComponent(UIImage, img_title_bg_path)
  self.title_name = self:AddComponent(UIText, title_name_path)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
  self.heroList = self:AddComponent(UIBaseContainer, hero_list_path)
  self.click_tp = self:AddComponent(UITextMeshProUGUIEx, click_tp_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.btn:SetOnClick(function()
    self:CheckIsExertFun()
    EventManager:GetInstance():Broadcast(EventId.OnRewardGetPanelClose)
    if self.param and (self.param.flyReward == nil or self.param.flyReward) then
      local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
      if window and window.Ctrl:IsVisible() then
        local cfg = {}
        for i, v in ipairs(self.cells) do
          if v and not IsNull(v.transform) then
            table.insert(cfg, {
              v.transform.position,
              self.param.rewardList[i]
            })
          end
        end
        EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward, cfg)
      end
    end
    self.ctrl:CloseSelf()
  end)
  self.skip_anim_btn = self:AddComponent(UIButton, skip_anim_btn_path)
  self.skip_anim_btn.gameObject:SetActive(false)
  self.skip_anim_btn:SetOnClick(function()
    self:SkipCellAnim()
  end)
  self.scroll_view_change = self:AddComponent(UIScrollView, scroll_view_change_path)
  self.scroll_view_change:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view_change:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.rect_NewChangeObj = self:AddComponent(UIBaseContainer, rect_newchange_path)
  self.rect_NewChangeAnim = self:AddComponent(UIAnimator, rect_newchange_path)
  if self.transform:Find(special_bg_path) ~= nil then
    self.special_bg = self:AddComponent(UIBaseContainer, special_bg_path)
    self.special_bg:SetActive(false)
  end
  if self.transform:Find(other_title_text_path) ~= nil then
    self.other_title_text = self:AddComponent(UITextMeshProUGUIEx, other_title_text_path)
  end
  if self.transform:Find(tips_content_path) ~= nil then
    self.tips_content = self:AddComponent(UIBaseContainer, tips_content_path)
    self.tips_content:SetActive(false)
  end
  if self.transform:Find(tips_text_path) ~= nil then
    self.tips_text = self:AddComponent(UITextMeshProUGUIEx, tips_text_path)
  end
end

local function ComponentDestroy(self)
  self.btn = nil
  self.banner = nil
  self.img_title_bg = nil
  self.title_name = nil
  self.scroll_view = nil
  self.scroll_view_change = nil
  self.skip_anim_btn = nil
  self.rewardTitle = nil
  self.special_bg = nil
  self.other_title_text = nil
  self.tips_content = nil
  self.tips_text = nil
  self.click_tp = nil
  self.rewardTitle = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function DataDefine(self)
  self.param = nil
  self.nameText = nil
  self.cells = {}
  self.showAnim = true
  self.scrollTo = false
end

local function DataDestroy(self)
  self.param = nil
  self.nameText = nil
  self.cells = nil
  self.showAnim = nil
  self.scrollTo = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  local param, callback = self:GetUserData()
  if callback then
    callback()
  end
  EventManager:GetInstance():Broadcast(EventId.UpdatePlayerExp)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function CheckIsExertFun(self)
end

local function ReInit(self)
  self.scrollTo = false
  self:SetNameText(self.param.title)
  if not string.IsNullOrEmpty(self.param.clickTip) then
    self.click_tp:SetActive(true)
    self.click_tp:SetText(self.param.clickTip)
  else
    self.click_tp:SetActive(false)
  end
  if self.param.treasureChestReward then
    if self.special_bg then
      self.banner:SetActive(false)
      self.img_title_bg:SetActive(false)
      self.special_bg:SetActive(true)
    end
    if self.other_title_text then
      self.other_title_text:SetText(self.param.title)
    end
  else
    self.banner:SetActive(true)
    self.img_title_bg:SetActive(true)
    if self.special_bg then
      self.special_bg:SetActive(false)
    end
  end
  if self.param.tips then
    if self.tips_content then
      self.tips_content:SetActive(true)
      self.tips_text:SetText(self.param.tips)
    end
  elseif self.tips_content then
    self.tips_content:SetActive(false)
  end
  self:ShowCells()
  self.showAnim = true
end

local function ClearScroll(self)
  self.cells = {}
  if self.param and self.param.isUpChange then
    if self.scroll_view_change then
      self.scroll_view_change:ClearCells()
      self.scroll_view_change:RemoveComponents(UICommonResItem)
    end
  elseif self.scroll_view then
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UICommonResItem)
  end
  if self.heroList then
    self.heroList:RemoveComponents(UIGuidePioneerHeroExpCell)
  end
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem
  local nowIndex = index
  if self.param.isUpChange then
    cellItem = self.scroll_view_change:AddComponent(UICommonResItem, itemObj)
  else
    cellItem = self.scroll_view:AddComponent(UICommonResItem, itemObj)
  end
  local rewardParam = self.param.rewardList[index]
  local param = UICommonResItem.Param.New()
  param.rewardType = rewardParam.rewardType
  param.itemId = rewardParam.itemId
  param.count = rewardParam.count
  param.heroUuid = rewardParam.heroUuid
  param.isHeroBox = rewardParam.isHeroBox
  param.bUuid = rewardParam.bUuid
  param.isConfiscate = rewardParam.isConfiscate
  param.isFish = rewardParam.isFish
  cellItem:ReInit(param)
  if not self.scrollTo and self.showAnim then
    cellItem:SetRewardAlpha(0)
    self:CreateDelayTimer(function()
      cellItem:SetRewardAlpha(1)
      cellItem:PlayAnimator("Eff_ui_icon_chuxian_tongyong_new")
      cellItem:SetRewardEffect(0.8)
    end, 0.05 + 0.05 * (nowIndex - 1), nowIndex)
  else
    cellItem:SetRewardAlpha(1)
    cellItem:PlayAnimator("Eff_ui_icon_chuxian_tongyong_idle")
  end
  if self.showAnim then
    self.cells[index] = cellItem
  end
end

function UIFishingRewardView:CreateDelayTimer(callback, delay, timerName)
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

function UIFishingRewardView:ClearAllDelayTimers()
  if self.delayTimers then
    for name, timer in pairs(self.delayTimers) do
      if timer then
        timer:Stop()
      end
    end
    self.delayTimers = {}
  end
end

local function OnDeleteCell(self, itemObj, index)
  if self.param.isUpChange then
    self.scroll_view_change:RemoveComponent(itemObj.name, UICommonResItem)
  else
    self.scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
  end
end

local function ShowCells(self)
  self:ClearScroll()
  if self.param.heroExp ~= nil then
    for _, heroExpInfo in ipairs(self.param.heroExp) do
      self:AddHeroExpObj(heroExpInfo)
    end
  end
  if self.param.isUpChange then
    self.scroll_view_change:SetActive(true)
    self.scroll_view_change:SetTotalCount(#self.param.rewardList)
    self.scroll_view_change:RefillCells()
  else
    self.scroll_view_change:SetActive(false)
    self.scroll_view:SetTotalCount(#self.param.rewardList)
    self.scroll_view:RefillCells()
  end
  self:PlayCellAnim()
end

local function AddHeroExpObj(self, heroExpInfo)
  self:GameObjectInstantiateAsync(UIAssets.UIHeroCellSmall, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.heroList.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:SetAsLastSibling()
    go.name = tostring(heroExpInfo.heroUuid)
    local itemObj = self.heroList:AddComponent(UIGuidePioneerHeroExpCell, go.name)
    itemObj:InitData(heroExpInfo)
  end)
end

local function PlayCellAnim(self)
  local totalCount = #self.param.rewardList
  if totalCount <= lineCount * 2 then
    return
  end
  self.skip_anim_btn.gameObject:SetActive(true)
  local seq = DOTween.Sequence()
  local hasTriggeredScroll = false
  for index = 1, totalCount do
    seq:AppendInterval(cellDelay):AppendCallback(function()
      if not self.showAnim then
        return
      end
      local cell = self.cells[index]
      if not cell then
        return
      end
      if index == lineCount * 2 + 1 and not hasTriggeredScroll then
        hasTriggeredScroll = true
        local targetIndex = totalCount - lineCount
        if self.param.isUpChange then
          self.scroll_view_change:ScrollToCell(targetIndex, 300)
        else
          self.scroll_view:ScrollToCell(targetIndex, 300)
        end
        self.scrollTo = true
      end
      if index == totalCount then
        self.skip_anim_btn.gameObject:SetActive(false)
        self.showAnim = false
      end
    end)
  end
  if self.param.isUpChange then
    self.rect_NewChangeObj:SetActive(true)
    self.rect_NewChangeAnim:Play("V_ui_jiesuo_wupin", 0, 0)
  else
    self.rect_NewChangeObj:SetActive(false)
  end
end

local function SkipCellAnim(self)
  self.showAnim = false
  self.skip_anim_btn.gameObject:SetActive(false)
  self:ClearAllDelayTimers()
  self:ClearScroll()
  if self.param.isUpChange then
    self.scroll_view_change:SetTotalCount(#self.param.rewardList)
    self.scroll_view_change:RefillCells()
    if #self.param.rewardList > lineCount * 2 then
      self.scroll_view_change:ScrollToCell(#self.param.rewardList - lineCount, 20000)
    end
  else
    self.scroll_view:SetTotalCount(#self.param.rewardList)
    self.scroll_view:RefillCells()
    if #self.param.rewardList > lineCount * 2 then
      self.scrollTo = true
      self.scroll_view:ScrollToCell(#self.param.rewardList - lineCount, 20000)
    end
  end
  if self.param.isUpChange then
    self.rect_NewChangeObj:SetActive(true)
    self.rect_NewChangeAnim:Play("V_ui_jiesuo_wupin", 0, 1)
  else
    self.rect_NewChangeObj:SetActive(false)
  end
end

local function SetNameText(self, value)
  if self.nameText ~= value then
    self.nameText = value
    self.title_name:SetText(value)
  end
end

UIFishingRewardView.OnCreate = OnCreate
UIFishingRewardView.OnDestroy = OnDestroy
UIFishingRewardView.OnEnable = OnEnable
UIFishingRewardView.OnDisable = OnDisable
UIFishingRewardView.ComponentDefine = ComponentDefine
UIFishingRewardView.ComponentDestroy = ComponentDestroy
UIFishingRewardView.DataDefine = DataDefine
UIFishingRewardView.DataDestroy = DataDestroy
UIFishingRewardView.OnAddListener = OnAddListener
UIFishingRewardView.OnRemoveListener = OnRemoveListener
UIFishingRewardView.CheckIsExertFun = CheckIsExertFun
UIFishingRewardView.ReInit = ReInit
UIFishingRewardView.OnDeleteCell = OnDeleteCell
UIFishingRewardView.ShowCells = ShowCells
UIFishingRewardView.OnCreateCell = OnCreateCell
UIFishingRewardView.ClearScroll = ClearScroll
UIFishingRewardView.SetNameText = SetNameText
UIFishingRewardView.PlayCellAnim = PlayCellAnim
UIFishingRewardView.SkipCellAnim = SkipCellAnim
UIFishingRewardView.AddHeroExpObj = AddHeroExpObj
return UIFishingRewardView
