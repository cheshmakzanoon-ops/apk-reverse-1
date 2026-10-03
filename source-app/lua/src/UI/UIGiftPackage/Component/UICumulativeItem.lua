local UIGiftItem = require("UI.UIGiftPackage.Component.UICumulativeRewardItem")
local UICumulativeItem = BaseClass("UICumulativeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local txt_score_path = "Image/Txt_Score"
local event_trigger_path = "CellScroll/Viewport/CellScrollEventTrigger"
local scroll_view_path = "CellScroll"
local content_path = "CellScroll/Viewport/Content"
local btn_reward_path = "Btn_Reward"
local normal_img_path = "Img_Normal"
local canReceive_img_path = "Img_CanReceive"
local pro_img_path = "Img_pro"
local proLine_img_path = "Img_ProLine"
local mask_img_path = "Img_Mask"
local reward_particle_path = "Particle_Reward"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self._score_txt = self:AddComponent(UIText, txt_score_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.event_trigger = self:AddComponent(UIEventTrigger, event_trigger_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.event_trigger:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.event_trigger:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.event_trigger:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self._reward_btn = self:AddComponent(UIButton, btn_reward_path)
  self._reward_btn:SetOnClick(function()
    self:OnClickReward()
  end)
  self.normal_img = self:AddComponent(UIImage, normal_img_path)
  self.anim_tree = self:AddComponent(UIAnimator, normal_img_path)
  self.canReceive_img = self:AddComponent(UIImage, canReceive_img_path)
  self.pro_img = self:AddComponent(UIImage, pro_img_path)
  self._proLine_img = self:AddComponent(UIImage, proLine_img_path)
  self._mask_img = self:AddComponent(UIImage, mask_img_path)
  self.reward_particle = self:AddComponent(UIBaseComponent, reward_particle_path)
end

local function ComponentDestroy(self)
  self.image = nil
  self.title_name = nil
  self.time = nil
  self.desc = nil
  self.money = nil
  self.cur_price = nil
  self.last_price = nil
  self.buy_btn = nil
  self.scroll_view = nil
  self.event_trigger = nil
  self.img_desc = nil
  self._proLine_img = nil
  self._mask_img = nil
end

local function DataDefine(self)
  self.param = {}
  self.timeValue = nil
  self.buyBtnEnable = nil
  self.listParam = {}
  self.position = nil
  self.needTrans = nil
  self.imgColor = nil
  self.cell = {}
  self.itemList = {}
  self.isFirst = true
end

local function DataDestroy(self)
  self.param = nil
  self.timeValue = nil
  self.buyBtnEnable = nil
  self.listParam = nil
  self.position = nil
  self.needTrans = nil
  self.imgColor = nil
  self.cell = nil
  self.isFirst = nil
  if self.delayTime ~= nil then
    self.delayTime:Stop()
    self.delayTime = nil
  end
end

local function ReInit(self, param)
  self.param = param
  self._score_txt:SetText(self.param.info.needScore)
  self.pro_img:SetActive(false)
  self._proLine_img:SetActive(false)
  self._mask_img:SetActive(false)
  if self.param.info.needScore <= self.param.curScore and self.param.info.state == 0 then
    self._reward_btn:SetActive(true)
    self.rewardEffect = true
    if next(param.listKill) then
      for i = 1, #param.listKill do
        if param.listKill[i] == param.index then
          self.normal_img:SetActive(true)
          break
        else
          self.normal_img:SetActive(false)
        end
      end
    else
      self.normal_img:SetActive(false)
    end
  elseif self.param.info.state == 1 then
    self._reward_btn:SetActive(false)
    self.rewardEffect = false
    self.normal_img:SetActive(false)
    self._mask_img:SetActive(true)
  else
    self._reward_btn:SetActive(false)
    self.rewardEffect = false
    self.normal_img:SetActive(true)
  end
  self.anim_tree:Play("V_ui_tree_idea", 0, 0)
  self.listParam = self.param.info.reward
  self:ClearScroll()
  if 0 < #self.listParam then
    self.scroll_view:SetTotalCount(#self.listParam)
    self.scroll_view:RefillCells()
  end
end

local function RewardUpdate(self)
  self._reward_btn:SetActive(false)
  self._mask_img:SetActive(true)
  self.pro_img:SetAnchoredPositionXY(0, 190)
  for i, v in pairs(self.cell) do
    v:SetCheckActive(1)
    v:SetReceiveState(false)
  end
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UIGiftItem, itemObj)
  cellItem:ReInit(self.listParam[index], self.param.info.state, self.rewardEffect)
  self.cell[index] = cellItem
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIGiftItem)
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIGiftItem)
end

local function OnBeginDrag(self, eventData)
  self.needTrans = nil
  self.position = eventData.position
  if self.param.scrollView ~= nil then
    self.param.scrollView:OnBeginDrag(eventData)
  end
  self.scroll_view:OnBeginDrag(eventData)
end

local function OnEndDrag(self, eventData)
  self.needTrans = nil
  if self.param.scrollView ~= nil then
    self.param.scrollView:OnEndDrag(eventData)
  end
  self.scroll_view:OnEndDrag(eventData)
end

local function OnDrag(self, eventData)
  if self.needTrans == nil then
    local X = math.abs(eventData.position.x - self.position.x)
    local Y = math.abs(eventData.position.y - self.position.y)
    if X > Y then
      self.needTrans = true
    elseif X < Y then
      self.needTrans = false
    end
  end
  if self.needTrans ~= nil then
    if self.needTrans then
      if self.param.scrollView ~= nil then
        self.param.scrollView:OnDrag(eventData)
      end
    else
      self.scroll_view:OnDrag(eventData)
    end
  end
end

local function OnClickReward(self)
  DataCenter.CumulativeRechargeManager:SendReward(self.param.rechargeId, self.param.info.stageId)
end

local function TestAnim(self, curStage)
  self.anim_tree:Play("V_ui_tree_dao", 0, 0)
  self.delayTime = TimerManager:GetInstance():DelayInvoke(function()
    self.normal_img:SetActive(false)
  end, 1)
end

UICumulativeItem.OnCreate = OnCreate
UICumulativeItem.OnDestroy = OnDestroy
UICumulativeItem.ReInit = ReInit
UICumulativeItem.ComponentDefine = ComponentDefine
UICumulativeItem.ComponentDestroy = ComponentDestroy
UICumulativeItem.DataDefine = DataDefine
UICumulativeItem.DataDestroy = DataDestroy
UICumulativeItem.OnClickReward = OnClickReward
UICumulativeItem.ClearScroll = ClearScroll
UICumulativeItem.OnCreateCell = OnCreateCell
UICumulativeItem.OnDeleteCell = OnDeleteCell
UICumulativeItem.RewardUpdate = RewardUpdate
UICumulativeItem.OnDrag = OnDrag
UICumulativeItem.OnEndDrag = OnEndDrag
UICumulativeItem.OnBeginDrag = OnBeginDrag
UICumulativeItem.TestAnim = TestAnim
return UICumulativeItem
