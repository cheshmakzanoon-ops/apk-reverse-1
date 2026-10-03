local base = UIBaseView
local UILWExpiredItemConvertView = BaseClass("UILWExpiredItemConvertView", base)
local bg_btn_path = "UICommonPopUpTitle/panel"
local title_txt_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local expireItemSubTitle_txt_path = "contentArea/expiredItem/subtitleText1"
local expireItemList_path = "contentArea/expiredItem/ItemList1"
local expireItemContent_path = "contentArea/expiredItem/ItemList1/viewport/content1"
local returnItemSubTitle_txt_path = "contentArea/ReturnItems/subtitleText2"
local returnItemList_path = "contentArea/ReturnItems/ItemList2"
local returnItemContent_path = "contentArea/ReturnItems/ItemList2/viewport/content2"
local confirm_btn_path = "contentArea/Button"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local msg = self:GetUserData()
  self.expireItemInfos = {}
  if msg.costItems then
    self.expireItemInfos = DataCenter.RewardManager:ReturnRewardParamForView(msg.costItems)
  end
  self.returnItemInfos = {}
  if msg.reward then
    self.returnItemInfos = DataCenter.RewardManager:ReturnRewardParamForView(msg.reward)
  end
  self:OnOpen()
end

local function OnDestroy(self)
  self:DestroyItems()
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
  self.bg_btn = self:AddComponent(UIButton, bg_btn_path)
  self.title_txt = self:AddComponent(UIText, title_txt_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.expireItemSubTitle_txt = self:AddComponent(UITextMeshProUGUIEx, expireItemSubTitle_txt_path)
  self.expireItemList = self:AddComponent(UIScrollRect, expireItemList_path)
  self.expireItemContent = self:AddComponent(UIBaseContainer, expireItemContent_path)
  self.returnItemSubTitle_txt = self:AddComponent(UITextMeshProUGUIEx, returnItemSubTitle_txt_path)
  self.returnItemList = self:AddComponent(UIScrollRect, returnItemList_path)
  self.returnItemContent = self:AddComponent(UIBaseContainer, returnItemContent_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.bg_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.confirm_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.bg_btn = nil
  self.title_txt = nil
  self.close_btn = nil
  self.expireItemSubTitle_txt = nil
  self.expireItemList = nil
  self.expireItemContent = nil
  self.returnItemSubTitle_txt = nil
  self.returnItemList = nil
  self.returnItemContent = nil
  self.confirm_btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnOpen(self)
  self:CreateItems()
end

local function DestroyItems(self)
  if self.expiredItems then
    self.expireItemContent:RemoveComponents(UICommonResItem)
    for i = 1, #self.expiredItems do
      self:GameObjectDestroy(self.expiredItems[i])
    end
  end
  self.expiredItems = {}
  if self.returnItems then
    self.returnItemContent:RemoveComponents(UICommonResItem)
    for i = 1, #self.returnItems do
      self:GameObjectDestroy(self.returnItems[i])
    end
  end
end

local function CreateItems(self)
  for i = 1, #self.expireItemInfos do
    local itemInfo = self.expireItemInfos[i]
    local itemRequest = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      local go = request.gameObject
      if IsNull(go) then
        return
      end
      local name = string.format("expireItem_%d", i)
      go.name = name
      go.transform:SetParent(self.expireItemContent.transform)
      local resItem = self.expireItemContent:AddComponent(UICommonResItem, name)
      resItem:SetLocalScaleXYZ(0.8, 0.8, 0.8)
      resItem:SetPivotXY(0.5, 0.5)
      resItem:ReInit(itemInfo)
    end)
    if not self.expiredItems then
      self.expiredItems = {}
    end
    self.expiredItems[#self.expiredItems + 1] = itemRequest
  end
  for i = 1, #self.returnItemInfos do
    local itemInfo = self.returnItemInfos[i]
    local itemRequest = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      local go = request.gameObject
      if IsNull(go) then
        return
      end
      local name = string.format("returnItem_%d", i)
      go.name = name
      go.transform:SetParent(self.returnItemContent.transform)
      local resItem = self.returnItemContent:AddComponent(UICommonResItem, name)
      resItem:SetLocalScaleXYZ(0.8, 0.8, 0.8)
      resItem:SetPivotXY(0.5, 0.5)
      resItem:ReInit(itemInfo)
    end)
    if not self.returnItems then
      self.returnItems = {}
    end
    self.returnItems[#self.returnItems + 1] = itemRequest
  end
end

UILWExpiredItemConvertView.OnCreate = OnCreate
UILWExpiredItemConvertView.OnDestroy = OnDestroy
UILWExpiredItemConvertView.OnEnable = OnEnable
UILWExpiredItemConvertView.OnDisable = OnDisable
UILWExpiredItemConvertView.ComponentDefine = ComponentDefine
UILWExpiredItemConvertView.ComponentDestroy = ComponentDestroy
UILWExpiredItemConvertView.DataDefine = DataDefine
UILWExpiredItemConvertView.DataDestroy = DataDestroy
UILWExpiredItemConvertView.DestroyItems = DestroyItems
UILWExpiredItemConvertView.CreateItems = CreateItems
UILWExpiredItemConvertView.OnOpen = OnOpen
return UILWExpiredItemConvertView
