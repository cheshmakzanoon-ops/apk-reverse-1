local base = UIBaseView
local CommonShowBubbleTipView = BaseClass("CommonShowBubbleTipView", base)
local right_path = "Tip/Img_Right"
local left_path = "Tip/Img_Left"
local content_path = "Tip/Text"
local panel_path = "Panel"
local tips_path = "Tip"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local data = self:GetUserData()
  self.des = data.des
  self.posX = data.posX
  self.posY = data.posY
  self.isleft = CommonUtil.IsArabicAutoMirrorOpen() and not data.isLeft or data.isLeft
  self.cellW = data.cellW or 0
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.right = self:AddComponent(UIBaseContainer, right_path)
  self.left = self:AddComponent(UIBaseContainer, left_path)
  self.content = self:AddComponent(UIText, content_path)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.tips = self:AddComponent(UIBaseContainer, tips_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.right = nil
  self.left = nil
  self.content = nil
  self.panel = nil
  self.tips = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function CommonShowBubbleTipView:RefreshData()
  local v3 = self.tips.transform.position
  v3.x = self.posX
  v3.y = self.posY
  self.tips.transform.pivot = Vector2.New(self.isleft and 0 or 1, 0)
  self.tips.transform.position = v3
  self.right:SetActive(not self.isleft)
  self.left:SetActive(self.isleft)
  self.content:SetText(self.des)
end

CommonShowBubbleTipView.OnCreate = OnCreate
CommonShowBubbleTipView.OnDestroy = OnDestroy
CommonShowBubbleTipView.OnEnable = OnEnable
CommonShowBubbleTipView.OnDisable = OnDisable
CommonShowBubbleTipView.ComponentDefine = ComponentDefine
CommonShowBubbleTipView.ComponentDestroy = ComponentDestroy
CommonShowBubbleTipView.DataDefine = DataDefine
CommonShowBubbleTipView.DataDestroy = DataDestroy
return CommonShowBubbleTipView
