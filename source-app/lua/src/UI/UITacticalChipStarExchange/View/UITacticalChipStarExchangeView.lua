local UITacticalChipStarExchangeView = BaseClass("UITacticalChipStarExchangeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UITacticalChipStarExchangeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITacticalChipStarExchangeView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITacticalChipStarExchangeView:ComponentDefine()
  self.btnBg = self:AddComponent(UIButton, "BgBtn")
  self.btnBg:SetOnClick(function()
    self:OnBtnBgClick()
  end)
  self.textTitle = self:AddComponent(UIText, "Root/title")
  self.btnClose = self:AddComponent(UIButton, "Root/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compChipBgLeft = self:AddComponent(UIBaseContainer, "Top/chipBgLeft")
  self.compChipBgRight = self:AddComponent(UIBaseContainer, "Top/chipBgRight")
  self.compChangeLineVfxNode = self:AddComponent(UIBaseContainer, "Top/changeLine/changeLineVfxNode")
  self.textExchangeTips = self:AddComponent(UIText, "Top/exchangeTips")
  self.compChipListNode = self:AddComponent(UIBaseContainer, "Middle/chipListNode")
  self.loopGridViewItemHolder = self:AddComponent(UILoopGridView, "Middle/chipListNode/ItemHolder")
  self.compItemContent = self:AddComponent(UIBaseContainer, "Middle/chipListNode/ItemHolder/Viewport/ItemContent")
  self.compTabOpening = self:AddComponent(UIBaseContainer, "Middle/chipListNode/tabRoot/tabOpening")
  self.compTabAttack = self:AddComponent(UIBaseContainer, "Middle/chipListNode/tabRoot/tabAttack")
  self.compTabDisturb = self:AddComponent(UIBaseContainer, "Middle/chipListNode/tabRoot/tabDisturb")
  self.compTabDefend = self:AddComponent(UIBaseContainer, "Middle/chipListNode/tabRoot/tabDefend")
  self.textNoChipTip = self:AddComponent(UIText, "Middle/chipListNode/noChipTip")
  self.textNoChipTip:SetLocalText("battlesystem_factory_inventory_desc1")
  self.btnExchange = self:AddComponent(UIButton, "Bottom/exchangeBtn")
  self.btnExchange:SetOnClick(function()
    self:OnBtnExchangeClick()
  end)
  self.textExchangeBtn = self:AddComponent(UIText, "Bottom/exchangeBtn/Btn/exchangeBtnText")
end

function UITacticalChipStarExchangeView:ComponentDestroy()
  self.btnBg = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compChipBgLeft = nil
  self.compChipBgRight = nil
  self.compChangeLineVfxNode = nil
  self.textExchangeTips = nil
  self.compChipListNode = nil
  self.loopGridViewItemHolder = nil
  self.compItemContent = nil
  self.compTabOpening = nil
  self.compTabAttack = nil
  self.compTabDisturb = nil
  self.compTabDefend = nil
  self.textNoChipTip = nil
  self.btnExchange = nil
  self.textExchangeBtn = nil
end

function UITacticalChipStarExchangeView:DataDefine()
end

function UITacticalChipStarExchangeView:DataDestroy()
end

function UITacticalChipStarExchangeView:OnAddListener()
  base.OnAddListener(self)
end

function UITacticalChipStarExchangeView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITacticalChipStarExchangeView:OnBtnBgClick()
end

function UITacticalChipStarExchangeView:OnBtnCloseClick()
end

function UITacticalChipStarExchangeView:OnBtnExchangeClick()
end

return UITacticalChipStarExchangeView
