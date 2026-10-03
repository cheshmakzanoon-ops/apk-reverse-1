local UIRobotPackContent = BaseClass("UIRobotPackContent", UIBaseContainer)
local base = UIBaseContainer
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local title_text_path = "TitleText"
local desc_text_path = "DescText"
local diamond_text_path = "DiamondText"
local buy_button_path = "BuyButton"
local price_text_path = "BuyButton/PriceText"
local big_item_path = "ItemGroup/BigItem"
local small_item_path = "ItemGroup/SmallItem"
local robot_image_path = "RobotImage"
local point_path = "BuyButton/UIGiftPackagePoint"

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
  self:DestroyItems()
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.desc_text = self:AddComponent(UIText, desc_text_path)
  self.diamond_text = self:AddComponent(UIText, diamond_text_path)
  self.buy_button = self:AddComponent(UIButton, buy_button_path)
  self.buy_button:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetPayReward, false)
    self.view.ctrl:CloseSelf()
    self.view.ctrl:BuyGift(self.pack)
  end)
  self.price_text = self:AddComponent(UIText, price_text_path)
  self.big_item = self.transform:Find(big_item_path).gameObject
  self.small_item = self.transform:Find(small_item_path).gameObject
  self.instantiate_items = {}
  self.robot_image = self:AddComponent(UIImage, robot_image_path)
  self.point_rect = self:AddComponent(UIGiftPackagePoint, point_path)
end

local function ComponentDestroy(self)
  self.title_text = nil
  self.desc_text = nil
  self.diamond_text = nil
  self.buy_button = nil
  self.price_text = nil
  self.big_item = nil
  self.small_item = nil
  self.instantiate_items = nil
  self.robot_image = nil
  self.point_rect = nil
end

local function DataDefine(self)
  self.pack = nil
end

local function DataDestroy(self)
  self.pack = nil
end

local function SetData(self, pack, view)
  self.pack = pack
  self.view = view
  self.title_text:SetLocalText(pack:getName())
  self.desc_text:SetText(pack:getDescText())
  self.diamond_text:SetText(pack:getDiamond())
  self.price_text:SetText(DataCenter.PayManager:GetDollarText(pack:getPrice(), pack:getProductID()))
  self.robot_image:LoadSprite(string.format(LoadPath.UIRobotPack, pack:getPopupImageH()))
  self.robot_image:SetNativeSize()
  self:ShowItems()
  self.point_rect:RefreshPoint(pack)
end

local function ShowItems(self)
  self:DestroyItems()
  local pack = self.pack
  local list = self:ParseItemsStr(pack:getItemsStr())
  if #list == 0 then
    return
  end
  local bigItemData = list[1]
  bigItemData.rewardType = RewardType.GOODS
  self:InstantiateItem(self.big_item, bigItemData, 1, big_item_path)
  table.remove(list, 1)
  local smallItemDataList = list
  for i, v in ipairs(smallItemDataList) do
    v.rewardType = RewardType.GOODS
    self:InstantiateItem(self.small_item, v, i, small_item_path)
  end
end

local function InstantiateItem(self, template, data, index, path)
  local go = CS.UnityEngine.GameObject.Instantiate(template, template.transform.parent)
  go.name = template.gameObject.name .. index
  go:SetActive(true)
  local item = self:AddComponent(UICommonResItem, path .. index)
  item:ReInit(data)
  table.insert(self.instantiate_items, item.gameObject)
end

local function DestroyItems(self)
  self:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.instantiate_items) do
    CS.UnityEngine.GameObject.Destroy(v)
  end
  self.instantiate_items = {}
end

local function ParseItemsStr(self, str)
  local subs = string.split(str, "|")
  local items = {}
  for i, v in ipairs(subs) do
    local item = self:ParseItemData(v)
    if item ~= nil then
      table.insert(items, item)
    end
  end
  return items
end

local function ParseItemData(self, str)
  local subs = string.split(str, ";")
  if #subs == 2 then
    return {
      itemId = subs[1],
      count = subs[2]
    }
  else
    return nil
  end
end

UIRobotPackContent.OnCreate = OnCreate
UIRobotPackContent.OnDestroy = OnDestroy
UIRobotPackContent.OnCreateCell = OnCreateCell
UIRobotPackContent.OnDeleteCell = OnDeleteCell
UIRobotPackContent.OnDisable = OnDisable
UIRobotPackContent.ReInit = ReInit
UIRobotPackContent.ComponentDefine = ComponentDefine
UIRobotPackContent.DataDefine = DataDefine
UIRobotPackContent.ComponentDestroy = ComponentDestroy
UIRobotPackContent.DataDestroy = DataDestroy
UIRobotPackContent.OnEnable = OnEnable
UIRobotPackContent.OnAddListener = OnAddListener
UIRobotPackContent.OnRemoveListener = OnRemoveListener
UIRobotPackContent.SetData = SetData
UIRobotPackContent.Show = Show
UIRobotPackContent.ShowItems = ShowItems
UIRobotPackContent.ParseItemsStr = ParseItemsStr
UIRobotPackContent.ParseItemData = ParseItemData
UIRobotPackContent.InstantiateItem = InstantiateItem
UIRobotPackContent.DestroyItems = DestroyItems
return UIRobotPackContent
