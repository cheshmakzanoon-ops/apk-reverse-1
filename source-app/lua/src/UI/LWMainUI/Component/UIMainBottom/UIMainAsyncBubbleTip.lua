local UIMainAsyncBubbleTip = BaseClass("UIMainAsyncBubbleTip", UIAsyncContainer)
local base = UIBaseContainer
local IconDefaultSize = Vector2.New(55, 52)

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, "Btn")
  self.icon = self:AddComponent(UIImage, "Btn/Icon")
  self.btn:SetOnClick(function()
    if self.param and self.param.clickCallback then
      self.param.clickCallback()
    end
  end)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.icon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.param = nil
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function UpdateData(self)
  if not GameObjectIsValid(self.gameObject) then
    return
  end
  if self.param then
    if self.param.btnImgPath then
      self.btn:LoadSprite(self.param.btnImgPath)
    end
    if self.param.iconImgPath then
      self.icon:LoadSprite(self.param.iconImgPath)
    end
    if self.param.anchorPos then
      self:SetAnchoredPosition(self.param.anchorPos)
    end
    if self.param.siblingIndex then
      self:SetSiblingIndex(self.param.siblingIndex)
    end
    local iconSize = self.param.iconSize or IconDefaultSize
    self.icon:SetSizeDelta(iconSize)
  end
end

local function SetData(self, param)
  self.param = param
  self:UpdateData()
end

UIMainAsyncBubbleTip.OnCreate = OnCreate
UIMainAsyncBubbleTip.OnDestroy = OnDestroy
UIMainAsyncBubbleTip.OnEnable = OnEnable
UIMainAsyncBubbleTip.OnDisable = OnDisable
UIMainAsyncBubbleTip.ComponentDefine = ComponentDefine
UIMainAsyncBubbleTip.ComponentDestroy = ComponentDestroy
UIMainAsyncBubbleTip.DataDefine = DataDefine
UIMainAsyncBubbleTip.DataDestroy = DataDestroy
UIMainAsyncBubbleTip.OnAddListener = OnAddListener
UIMainAsyncBubbleTip.OnRemoveListener = OnRemoveListener
UIMainAsyncBubbleTip.SetData = SetData
UIMainAsyncBubbleTip.UpdateData = UpdateData
return UIMainAsyncBubbleTip
