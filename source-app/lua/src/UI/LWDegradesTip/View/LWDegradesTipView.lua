local LWDegradesTipView = BaseClass("LWDegradesTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWDegradesTipInfoItem = require("UI.LWDegradesTip.Component.LWDegradesTipInfoItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  local degrades_tip_bg_path = "DegradesTipBg"
  local degrades_tip_path = "DegradesTip"
  local anchor_right_path = "DegradesTip/TipBg/AnchorRight"
  local anchor_left_path = "DegradesTip/TipBg/AnchorLeft"
  local title_path = "DegradesTip/TipBg/Title"
  local desc_path = "DegradesTip/TipBg/Desc"
  local scroll_view_path = "DegradesTip/TipBg/ScrollView"
  local content_path = "DegradesTip/TipBg/ScrollView/Viewport/Content"
  self.degrades_tip_bg = self:AddComponent(UIButton, degrades_tip_bg_path)
  self.degrades_tip_bg:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.degrades_tip = self:AddComponent(UIBaseContainer, degrades_tip_path)
  self.anchor_right = self:AddComponent(UIImage, anchor_right_path)
  self.anchor_left = self:AddComponent(UIImage, anchor_left_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.scroll_view = self:AddComponent(UIImage, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.degrades_item = self.transform:Find("DegradesTip/TipBg/DegradesItem").gameObject
  self.degrades_item:GameObjectCreatePool()
  self.degrades_item:SetActive(false)
  self.title:SetLocalText("season_mastery_UI_tips_19")
  self.desc:SetLocalText("season_mastery_UI_tips_20")
end

local function ComponentDestroy(self)
  self.content:RemoveComponents(LWDegradesTipInfoItem)
  self.degrades_item.gameObject:GameObjectRecycleAll()
  self.degrades_tip_bg = nil
  self.degrades_tip = nil
  self.anchor_right = nil
  self.anchor_left = nil
  self.title = nil
  self.desc = nil
  self.scroll_view = nil
  self.content = nil
end

local function OnEnable(self)
  self:Refresh()
end

local function Refresh(self)
  local soldiers, alignObject, isLeft = self:GetUserData()
  if alignObject.gameObject == nil or not alignObject.gameObject.activeInHierarchy then
    self.ctrl:CloseSelf()
    return
  end
  local screenPos = PosConverse.UIWorldToScreenPos(alignObject.transform.position)
  local uiPos = PosConverse.ScreenToUIPos(self.rectTransform, screenPos)
  local xOffset = self.degrades_tip:GetAnchoredPositionX()
  self.degrades_tip:SetAnchoredPositionXY(xOffset, uiPos.y)
  if isLeft then
    self.anchor_right:SetActive(false)
    self.anchor_left:SetActive(true)
  else
    self.anchor_right:SetActive(true)
    self.anchor_left:SetActive(false)
  end
  local soldierCount = 0
  for k, v in pairs(soldiers) do
    soldierCount = soldierCount + 1
    local item = self.degrades_item:GameObjectSpawn(self.content.transform)
    item:SetActive(true)
    item.name = "SoldierCell" .. soldierCount
    local obj = self.content:AddComponent(LWDegradesTipInfoItem, item.name)
    obj:SetData(v)
  end
end

LWDegradesTipView.OnCreate = OnCreate
LWDegradesTipView.OnDestroy = OnDestroy
LWDegradesTipView.ComponentDefine = ComponentDefine
LWDegradesTipView.ComponentDestroy = ComponentDestroy
LWDegradesTipView.OnEnable = OnEnable
LWDegradesTipView.Refresh = Refresh
return LWDegradesTipView
