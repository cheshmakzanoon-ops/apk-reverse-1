local CommonBoxRewardItem = require("UI.UILWCommonBoxShowRewardTip.Component.CommonBoxRewardItem")
local UILWCommonBoxRewardShowTipCtrl = BaseClass("UILWCommonBoxRewardShowTipCtrl", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen
local tip_path = "Tips"
local anim_path = "Tips/Anim"
local tips_txt_path = "Tips/Anim/TipsTitle"
local right_path = "Tips/Anim/Img_Right"
local left_path = "Tips/Anim/Img_Left"
local scroll_path = "Tips/Anim/ScrollView"
local content_path = "Tips/Anim/ScrollView/Viewport/Content"
local return_btn_path = "Panel"
local cost_path = "Tips/Anim/TipsTitle/cost"
local diamondDouble_path = "Tips/Anim/TipsTitle/cost/diamondDouble"
local rewardDouble_path = "Tips/Anim/DoubleBg"
local reward_tip_cell_path = "RewardTipCell"
local img_bottom_path = "Tips/Anim/Img_Bottom"
local img_top_path = "Tips/Anim/Img_Top"

local function OnCreate(self)
  base.OnCreate(self)
  local des, posX, posY, btnAnchor, cellW, offset, rewardList = self:GetUserData()
  self.des = des
  self.posX = posX
  self.posY = posY
  self.btnAnchor = btnAnchor
  self.rewardList = rewardList
  self.cellW = cellW or 0
  self.offset = offset or 0
  self.common_res_item = self:AddComponent(UIBaseContainer, reward_tip_cell_path).gameObject
  self.common_res_item:GameObjectCreatePool()
  self.tip_obj = self:AddComponent(UIBaseContainer, tip_path)
  self.anim = self:AddComponent(UIAnimator, anim_path)
  self.tips_txt = self:AddComponent(UIText, tips_txt_path)
  self.scroll_path = self:AddComponent(UIBaseContainer, scroll_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._right_img = self:AddComponent(UIImage, right_path)
  self._left_img = self:AddComponent(UIImage, left_path)
  self.cost = self:AddComponent(UIImage, cost_path)
  self.diamondDoubleN = self:AddComponent(UIText, diamondDouble_path)
  self.diamondDoubleN:SetActive(false)
  self.rewardDoubleN = self:AddComponent(UIBaseContainer, rewardDouble_path)
  self.img_bottom = self:AddComponent(UIImage, img_bottom_path)
  self.img_top = self:AddComponent(UIImage, img_top_path)
end

local function OnDestroy(self)
  self.tip_obj = nil
  self.anim = nil
  self.animator = nil
  self.return_btn = nil
  self.tips_txt = nil
  self.des = nil
  self.isShowBtn = nil
  self.posX = nil
  self.posY = nil
  self._right_img = nil
  self._left_img = nil
  self.cost = nil
  self.img_bottom = nil
  self.img_top = nil
  self:SetAllCellDestroy()
  self.content = nil
  if self.common_res_item then
    self.common_res_item:GameObjectRecycleAll()
  end
  self.common_res_item = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self)
  local sf = UIManager:GetInstance():GetScaleFactor()
  local v3 = self.tip_obj.transform.position
  v3.x = self.posX
  v3.y = self.posY
  self.tip_obj.transform.position = v3
  local rectPos = self.tip_obj.rectTransform.anchoredPosition
  local rect = self.tip_obj.rectTransform.rect
  local halfScreenWidth = Screen.width / sf / 2 - 30
  local halfScreenHeight = Screen.height / sf / 2 - 30
  local halfHeight = rect.height / 2
  local halfWidth = rect.width / 2
  local x
  local y = rectPos.y
  local pivot
  if self.btnAnchor == CommonBoxShowRewardTipAnchor.Left then
    x = rectPos.x + halfWidth + self.cellW / 2
    y = rectPos.y
    pivot = Vector2.New(0, 0.5)
  elseif self.btnAnchor == CommonBoxShowRewardTipAnchor.Right then
    y = rectPos.y
    x = rectPos.x - halfWidth - self.cellW / 2
    pivot = Vector2.New(1, 0.5)
  elseif self.btnAnchor == CommonBoxShowRewardTipAnchor.Top then
    x = rectPos.x
    y = rectPos.y - halfHeight - self.cellW / 2
    pivot = Vector2.New(0.5, 1)
  elseif self.btnAnchor == CommonBoxShowRewardTipAnchor.Down then
    x = rectPos.x
    y = rectPos.y + halfHeight + self.cellW / 2
    pivot = Vector2.New(0.5, 0)
  end
  if pivot then
    self.anim.transform.pivot = pivot
  else
    self.anim.transform.pivot = Vector2.New(0.5, 0.5)
  end
  y = Mathf.Clamp(y, halfHeight - halfScreenHeight, halfScreenHeight - halfHeight)
  x = Mathf.Clamp(x, halfWidth - halfScreenWidth, halfScreenWidth - halfWidth)
  local tempAnchoredPosition = Vector2.New(x, y)
  self.tip_obj.rectTransform.anchoredPosition = tempAnchoredPosition
  self.anim:Play("CommonPopup_movein", 0, 0)
  self._right_img:SetActive(self.btnAnchor == CommonBoxShowRewardTipAnchor.Right)
  self._left_img:SetActive(self.btnAnchor == CommonBoxShowRewardTipAnchor.Left)
  self.img_bottom:SetActive(self.btnAnchor == CommonBoxShowRewardTipAnchor.Down)
  self.img_top:SetActive(self.btnAnchor == CommonBoxShowRewardTipAnchor.Top)
  self.rewardDoubleN:SetActive(false)
  self.diamondDoubleN:SetActive(false)
  self.rewardDoubleN:SetActive(false)
  self.tips_txt:SetActive(not string.IsNullOrEmpty(self.des))
  self.tips_txt:SetText(self.des)
  self.cost:SetActive(true)
  self:SetAllCellDestroy()
  self.common_res_item:GameObjectRecycleAll()
  if self.rewardList then
    for index, value in ipairs(self.rewardList) do
      local go = self.common_res_item:GameObjectSpawn(self.content.transform)
      go.gameObject:SetActive(true)
      go.name = "item" .. tostring(index)
      local cell = self.content:AddComponent(CommonBoxRewardItem, go.name)
      cell:ReInit(value)
    end
  end
end

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(CommonBoxRewardItem)
end

UILWCommonBoxRewardShowTipCtrl.OnCreate = OnCreate
UILWCommonBoxRewardShowTipCtrl.OnDestroy = OnDestroy
UILWCommonBoxRewardShowTipCtrl.RefreshData = RefreshData
UILWCommonBoxRewardShowTipCtrl.OnEnable = OnEnable
UILWCommonBoxRewardShowTipCtrl.OnDisable = OnDisable
UILWCommonBoxRewardShowTipCtrl.SetAllCellDestroy = SetAllCellDestroy
return UILWCommonBoxRewardShowTipCtrl
