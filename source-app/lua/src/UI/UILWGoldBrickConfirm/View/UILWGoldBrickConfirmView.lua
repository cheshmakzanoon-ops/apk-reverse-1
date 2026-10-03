local base = UIBaseView
local UILWGoldBrickConfirmView = BaseClass("UILWGoldBrickConfirmView", base)
local goldBrickCount_txt_path = "layout/cost/goldBrickCountTxt"
local goldBrick_icon_path = "layout/cost/goldBrickIcon"
local right_btn_path = "layout/btnGo/rightBtn"
local left_btn_path = "layout/btnGo/leftBtn"
local close_btn_path = "layout/UICommonPopBg/closeBtn"
local desc_txt_path = "layout/desName"
local haveGoldBrick_icon_path = "layout/ResourceBar/layout/GoldBrick/Icon"
local haveGoldBrick_txt_path = "layout/ResourceBar/layout/GoldBrick/Text"
local closePanel_btn_path = "panel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.giftPackName, self.costGoldBrick, self.callback = self:GetUserData()
  self:RefreshDesc()
  self:RefreshCostGoldBrick()
  self:RefershHaveGoldBrick()
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
  self.goldBrickCount_txt = self:AddComponent(UIText, goldBrickCount_txt_path)
  self.goldBrick_icon = self:AddComponent(UIImage, goldBrick_icon_path)
  self.right_btn = self:AddComponent(UIButton, right_btn_path)
  self.left_btn = self:AddComponent(UIButton, left_btn_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.desc_txt = self:AddComponent(UIText, desc_txt_path)
  self.haveGoldBrick_icon = self:AddComponent(UIImage, haveGoldBrick_icon_path)
  self.haveGoldBrick_txt = self:AddComponent(UIText, haveGoldBrick_txt_path)
  self.closePanel_btn = self:AddComponent(UIButton, closePanel_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.left_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.right_btn:SetOnClick(function()
    local haveGoldBrick = DataCenter.GoldBrickDataManager:GetGoldBrickCount()
    if haveGoldBrick < self.costGoldBrick then
      UIUtil.ShowTipsId("400408")
      return
    end
    if self.callback then
      self.callback()
      self.ctrl:CloseSelf()
    end
  end)
  self.right_btn:SetSafeClickMode(true)
  self.closePanel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.goldBrickCount_txt = nil
  self.goldBrick_icon = nil
  self.right_btn = nil
  self.left_btn = nil
  self.close_btn = nil
  self.desc_txt = nil
  self.haveGoldBrick_icon = nil
  self.haveGoldBrick_txt = nil
  self.closePanel_btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefershHaveGoldBrick(self)
  local haveGoldBrick = DataCenter.GoldBrickDataManager:GetGoldBrickCount()
  self.haveGoldBrick_txt:SetText(haveGoldBrick)
end

local function RefreshCostGoldBrick(self)
  self.goldBrickCount_txt:SetText(self.costGoldBrick)
end

local function RefreshDesc(self)
  self.desc_txt:SetLocalText("400405", self.giftPackName)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GoldBrickUpdate, self.OnGoldBrickUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.GoldBrickUpdate, self.OnGoldBrickUpdate)
end

local function OnGoldBrickUpdate(self)
  self:RefershHaveGoldBrick()
end

UILWGoldBrickConfirmView.OnCreate = OnCreate
UILWGoldBrickConfirmView.OnDestroy = OnDestroy
UILWGoldBrickConfirmView.OnEnable = OnEnable
UILWGoldBrickConfirmView.OnDisable = OnDisable
UILWGoldBrickConfirmView.ComponentDefine = ComponentDefine
UILWGoldBrickConfirmView.ComponentDestroy = ComponentDestroy
UILWGoldBrickConfirmView.DataDefine = DataDefine
UILWGoldBrickConfirmView.DataDestroy = DataDestroy
UILWGoldBrickConfirmView.RefershHaveGoldBrick = RefershHaveGoldBrick
UILWGoldBrickConfirmView.RefreshCostGoldBrick = RefreshCostGoldBrick
UILWGoldBrickConfirmView.RefreshDesc = RefreshDesc
UILWGoldBrickConfirmView.OnGoldBrickUpdate = OnGoldBrickUpdate
return UILWGoldBrickConfirmView
