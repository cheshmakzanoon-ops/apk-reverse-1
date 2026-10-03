local UIAdventureIntro = BaseClass("UIAdventureIntro", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local back_path = "safeArea/Back"
local title_path = "safeArea/Title"
local reset_path = "safeArea/Reset"
local desc_path = "safeArea/DescBg/Desc"
local item_desc_path = "safeArea/ItemBg/ItemDesc"
local item_list_path = "safeArea/ItemBg/ItemList"
local go_btn_path = "safeArea/Go"
local go_text_path = "safeArea/Go/GoText"
local shop_btn_path = "safeArea/Shop"
local shop_text_path = "safeArea/Shop/ShopText"
local info_btn_path = "safeArea/Info"
local info_text_path = "safeArea/Info/InfoText"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  DataCenter.DailyActivityManager:UpdateActViewHistory(9)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.back_btn = self:AddComponent(UIButton, back_path)
  self.back_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title_text = self:AddComponent(UIText, title_path)
  self.title_text:SetLocalText(302246)
  self.reset_text = self:AddComponent(UIText, reset_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.desc_text:SetLocalText(302289)
  self.item_desc_text = self:AddComponent(UIText, item_desc_path)
  self.item_desc_text:SetLocalText(104191)
  self.item_list_go = self:AddComponent(UIBaseContainer, item_list_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_btn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.go_text = self:AddComponent(UIText, go_text_path)
  self.go_text:SetLocalText(110003)
  self.shop_btn = self:AddComponent(UIButton, shop_btn_path)
  self.shop_btn:SetOnClick(function()
    self:OnShopClick()
  end)
  self.shop_btn:SetActive(LuaEntry.DataConfig:CheckSwitch("APS_shop_explorer"))
  self.shop_text = self:AddComponent(UIText, shop_text_path)
  self.shop_text:SetLocalText(104241)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.info_text = self:AddComponent(UIText, info_text_path)
  self.info_text:SetLocalText(372116)
end

local function ComponentDestroy(self)
  self.title_text = nil
  self.reset_text = nil
  self.desc_text = nil
  self.item_desc_text = nil
  self.item_list_go = nil
  self.go_btn = nil
  self.go_text = nil
  self.shop_btn = nil
  self.shop_text = nil
  self.info_btn = nil
  self.info_text = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ShowItems()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AdventureInfoUpdate, self.OnAdventureInfoUpdate)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AdventureInfoUpdate, self.OnAdventureInfoUpdate)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  local restResetTime = DataCenter.AdventureManager:GetTodayRestResetTime()
  self.reset_text:SetLocalText(302250, restResetTime)
end

local function ShowItems(self)
  local showStr = LuaEntry.DataConfig:TryGetStr("explorer_rewardshow", "k1") or ""
  for _, str in ipairs(string.split(showStr, ",")) do
    local spls = string.split(str, ";")
    if #spls == 2 then
      local rewardType = tonumber(spls[1])
      local itemId = tonumber(spls[2])
      self:GameObjectInstantiateAsync(UIAssets.UIAdventureIntroItem, function(req)
        if req.isError then
          return
        end
        req.gameObject:SetActive(true)
        req.gameObject.name = tostring(itemId)
        req.gameObject.transform:SetParent(self.item_list_go.transform)
        req.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local param = {}
        param.rewardType = rewardType
        param.itemId = itemId
        param.count = ""
        local go = self.item_list_go:AddComponent(UIBaseContainer, tostring(itemId))
        local item = go:AddComponent(UICommonResItem, "UICommonResItem")
        item:ReInit(param)
        item:SetFlagActive(false)
      end)
    end
  end
end

local function OnGoClick(self)
  DataCenter.AdventureManager:Start()
end

local function OnShopClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop)
end

local function OnInfoClick(self)
  UIUtil.ShowIntro(Localization:GetString("302246"), Localization:GetString("100239"), Localization:GetString("302272"))
end

local function OnAdventureInfoUpdate(self)
  self:ReInit()
end

UIAdventureIntro.OnCreate = OnCreate
UIAdventureIntro.OnDestroy = OnDestroy
UIAdventureIntro.OnEnable = OnEnable
UIAdventureIntro.OnDisable = OnDisable
UIAdventureIntro.ComponentDefine = ComponentDefine
UIAdventureIntro.ComponentDestroy = ComponentDestroy
UIAdventureIntro.DataDefine = DataDefine
UIAdventureIntro.DataDestroy = DataDestroy
UIAdventureIntro.OnAddListener = OnAddListener
UIAdventureIntro.OnRemoveListener = OnRemoveListener
UIAdventureIntro.ReInit = ReInit
UIAdventureIntro.ShowItems = ShowItems
UIAdventureIntro.OnGoClick = OnGoClick
UIAdventureIntro.OnShopClick = OnShopClick
UIAdventureIntro.OnInfoClick = OnInfoClick
UIAdventureIntro.OnAdventureInfoUpdate = OnAdventureInfoUpdate
return UIAdventureIntro
