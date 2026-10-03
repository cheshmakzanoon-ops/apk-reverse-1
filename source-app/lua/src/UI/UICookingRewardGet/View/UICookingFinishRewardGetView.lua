local UIGiftPackageRewardGetView = require("UI.UIGiftPackageRewardGet.View.UIGiftPackageRewardGetView")
local base = UIGiftPackageRewardGetView
local UICookingFinishRewardGetView = BaseClass("UICookingFinishRewardGetView", base)
local UICookingFinishRewardGetItem = require("UI.UICookingRewardGet.Component.UICookingFinishRewardGetItem")
local Localization = CS.GameEntry.Localization
local DispatchTaskCell = require("UI.UIGiftPackageRewardGet.Component.DispatchTaskCell")
local DetectEventHelpInfoItem = require("UI.UIGiftPackageRewardGet.Component.DetectEventHelpInfoItem")
local panel_path = "UICommonRewardPopUp/Panel"
local title_name_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local layout_path = "layout"
local dispatch_task_path = "layout/DispatchTask"
local hero_list_path = "layout/heroList"
local scroll_view_path = "layout/CellList"
local skip_anim_btn_path = "SkipAnimButton"
local scroll_view_change_path = "CellListChange"
local rect_newchange_path = "Rect_NewChange"
local detectEventHelpInfo_path = "detectEventHelpInfo"

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.title_name = self:AddComponent(UIText, title_name_path)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
  self.heroList = self:AddComponent(UIBaseContainer, hero_list_path)
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
    self.ctrl:CloseSelf()
  end)
  self.skip_anim_btn = self:AddComponent(UIButton, skip_anim_btn_path)
  self.skip_anim_btn.gameObject:SetActive(true)
  self.skip_anim_btn:SetOnClick(function()
    self:SkipCellAnim()
    EventManager:GetInstance():Broadcast(EventId.OnRewardGetPanelClose)
    self.ctrl:CloseSelf()
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
  if self.transform:Find(dispatch_task_path) ~= nil then
    self.dispatchTaskInfo = self:AddComponent(DispatchTaskCell, dispatch_task_path)
    self.dispatchTaskInfo:SetActive(false)
  end
  if self.transform:Find(detectEventHelpInfo_path) ~= nil then
    self.detectEventHelpInfo = self:AddComponent(DetectEventHelpInfoItem, detectEventHelpInfo_path)
    self.detectEventHelpInfo:SetActive(false)
  end
  self.new_title = self:AddComponent(UIText, "ImgTitleBg/NewTextTitle")
  self.new_title:SetLocalText("thanksactivity_UI023")
  self.tip_text = self:AddComponent(UIText, "TipText")
end

local function ClearScroll(self)
  self.cells = {}
  if self.param and self.param.isUpChange then
    if self.scroll_view_change then
      self.scroll_view_change:ClearCells()
      self.scroll_view_change:RemoveComponents(UICookingFinishRewardGetItem)
    end
  elseif self.scroll_view then
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UICookingFinishRewardGetItem)
  end
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem
  if self.param.isUpChange then
    cellItem = self.scroll_view_change:AddComponent(UICookingFinishRewardGetItem, itemObj)
  else
    cellItem = self.scroll_view:AddComponent(UICookingFinishRewardGetItem, itemObj)
  end
  local rewardParam = self.param.rewardList[index]
  local param = UICommonResItem.Param.New()
  param.rewardType = rewardParam.rewardType
  param.itemId = rewardParam.itemId
  param.count = rewardParam.count
  param.heroUuid = rewardParam.heroUuid
  param.isHeroBox = rewardParam.isHeroBox
  param.bUuid = rewardParam.bUuid
  cellItem:ReInit(param, 1 < index)
  if self.showAnim then
    self.cells[index] = cellItem
  end
end

local function OnDeleteCell(self, itemObj, index)
  if self.param.isUpChange then
    self.scroll_view_change:RemoveComponent(itemObj.name, UICookingFinishRewardGetItem)
  else
    self.scroll_view:RemoveComponent(itemObj.name, UICookingFinishRewardGetItem)
  end
end

local function SetNameText(self, value)
  if self.nameText ~= value then
    self.nameText = value
    self.title_name:SetText(value)
    if table.count(self.param.rewardList) > 1 then
      self.title_name:SetLocalText(2800083)
    end
  end
  local count = #self.param.rewardList
  if 3 <= count then
    local extraItemName1 = DataCenter.ItemTemplateManager:GetName(self.param.rewardList[2].itemId)
    local extraItemName2 = DataCenter.ItemTemplateManager:GetName(self.param.rewardList[3].itemId)
    self.tip_text:SetLocalText("thanksactivity_UI027", extraItemName1, extraItemName2)
  elseif count == 2 then
    local extraItemName1 = DataCenter.ItemTemplateManager:GetName(self.param.rewardList[2].itemId)
    if self.param.rewardList[1].itemId == self.param.rewardList[2].itemId then
      self.tip_text:SetLocalText("thanksactivity_UI025", extraItemName1)
    else
      self.tip_text:SetLocalText("thanksactivity_UI026", extraItemName1)
    end
  else
    self.tip_text:SetText("")
  end
end

UICookingFinishRewardGetView.ClearScroll = ClearScroll
UICookingFinishRewardGetView.OnCreateCell = OnCreateCell
UICookingFinishRewardGetView.OnDeleteCell = OnDeleteCell
UICookingFinishRewardGetView.SetNameText = SetNameText
UICookingFinishRewardGetView.ComponentDefine = ComponentDefine
return UICookingFinishRewardGetView
