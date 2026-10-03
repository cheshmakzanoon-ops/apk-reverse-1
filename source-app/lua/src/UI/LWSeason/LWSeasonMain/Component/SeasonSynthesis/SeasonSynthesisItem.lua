local SeasonSynthesisItem = BaseClass("SeasonSynthesisItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.itemID = 0
  self.itemCount = 0
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.itemID = 0
  self.itemCount = 0
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.addBtn = self:AddComponent(UIButton, "Bg/AddFlag")
  self.icon = self:AddComponent(UIButton, "Bg/itemIcon")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "Bg/itemNameText")
  self.swapBtn = self:AddComponent(UIButton, "Bg/swapBtn")
  self.addBtn:SetOnClick(function()
    self:OnAddBtnClickFunc()
  end)
  self.icon:SetOnClick(function()
    self:OnAddBtnClickFunc()
  end)
  self.swapBtn:SetOnClick(function()
    self:OnSwapBtnClickFunc()
  end)
end

local function ComponentDestroy(self)
  self.addBtn = nil
  self.icon = nil
  self.name = nil
  self.swapBtn = nil
end

local function SetItemCount(self, count)
  self.itemCount = count
  if count == 0 then
    self.icon:SetActive(false)
    self.name:SetActive(false)
    self.swapBtn:SetActive(true)
    self.addBtn:SetActive(true)
  else
    self.icon:SetActive(true)
    self.name:SetActive(true)
    self.swapBtn:SetActive(false)
    self.addBtn:SetActive(false)
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemID)
    if itemTemplate ~= nil then
      self.icon:LoadSprite(string.format(LoadPath.ItemPath, itemTemplate.icon))
    end
    self.name:SetLocalText("130128", count)
  end
end

local function OnAddBtnClickFunc(self)
  LWResourceLackUtil:GotoGoodsItemLack(self.itemID, 1)
end

local function OnSwapBtnClickFunc(self)
  if CrossServerUtil:IsInOtherServer() then
    UIUtil.ShowTipsId("forbidden_exchange_tips")
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISplinterExchange, {anim = true}, SplinterExchangeType.SeasonSynthesiss.Id, 1, self.itemID)
  end
end

SeasonSynthesisItem.OnCreate = OnCreate
SeasonSynthesisItem.OnDestroy = OnDestroy
SeasonSynthesisItem.ComponentDefine = ComponentDefine
SeasonSynthesisItem.ComponentDestroy = ComponentDestroy
SeasonSynthesisItem.SetItemCount = SetItemCount
SeasonSynthesisItem.OnAddBtnClickFunc = OnAddBtnClickFunc
SeasonSynthesisItem.OnSwapBtnClickFunc = OnSwapBtnClickFunc
return SeasonSynthesisItem
