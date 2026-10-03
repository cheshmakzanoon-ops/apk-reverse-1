local UIActMonopolyShopView = BaseClass("UIActMonopolyShopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActMonopolyShopItem = require("UI.UIActMonopoly.UIActMonopolyShop.Component.UIActMonopolyShopItem")
local closeBtn_path = "contentView/topcontent/CloseBtn"
local colsebg_path = "colsebg"
local UIActMonopolyShopItem_path = "contentView/UIActMonopolyShopItem"
local scrollView_path = "contentView/ScrollView"
local content_path = "contentView/ScrollView/SoftViewport/Content"
local soft_viewport_path = "contentView/ScrollView/SoftViewport"
local bg_path = "contentView/topcontent/bg"
local content_bg_path = "contentView/contentBg"
local mask_img_path = "contentView/bottomRawImgContent/maskImg"
local bottom_raw_img_path = "contentView/bottomRawImgContent/bottomRawImg"
local bottom_raw_img2_path = "contentView/bottomRawImgContent/bottomRawImg/bottomRawImg2"
local desc2_text_path = "contentView/topcontent/Desc2"
local itemHigh = 280
local contentMaxHigh = 900

local function OnCreate(self)
  base.OnCreate(self)
  self.activityId, self.activityDetailData, self.topTipId = self:GetUserData()
  self.activityId = tonumber(self.activityId)
  self.shopShowData = self.activityDetailData:GetShopShowListData()
  if #self.shopShowData.dataArr > 1 and self.topTipId then
    for index, v in ipairs(self.shopShowData.dataArr) do
      if v.storeKey == self.topTipId and index ~= 1 then
        self.shopShowData.dataArr[1], self.shopShowData.dataArr[index] = self.shopShowData.dataArr[index], self.shopShowData.dataArr[1]
        break
      end
    end
  end
  self.animator = self:AddComponent(UIAnimator, "")
  self.close_btn = self:AddComponent(UIButton, closeBtn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
    EventManager:GetInstance():Broadcast(EventId.ActMonopolyShopViewClose)
  end)
  self.colsebg = self:AddComponent(UIButton, colsebg_path)
  self.colsebg:SetOnClick(function()
    self.ctrl:CloseSelf()
    EventManager:GetInstance():Broadcast(EventId.ActMonopolyShopViewClose)
  end)
  self.scrollView = self:AddComponent(UILayoutElement, scrollView_path)
  self.shopItems = {}
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.uiActMonopolyShopItem = self:AddComponent(UIBaseContainer, UIActMonopolyShopItem_path)
  self.uiActMonopolyShopItem:SetActive(false)
  self.uiActMonopolyShopItem.gameObject:GameObjectCreatePool()
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.soft_viewport = self:AddComponent(UIImage, soft_viewport_path)
  self.content_bg = self:AddComponent(UIImage, content_bg_path)
  self.mask_img = self:AddComponent(UIImage, mask_img_path)
  self.bottom_raw_img = self:AddComponent(UIRawImage, bottom_raw_img_path)
  self.bottom_raw_img2 = self:AddComponent(UIRawImage, bottom_raw_img2_path)
  self.desc2_text = self:AddComponent(UIText, desc2_text_path)
  self:RefreshView()
  self:PlayOpenAni()
end

local function OnDestroy(self)
  self:ClearAllItem()
  self.content_bg = nil
  self.mask_img = nil
  self.bottom_raw_img = nil
  self.bottom_raw_img2 = nil
  self.desc2_text = nil
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetActMonopolyShopMsg, self.OnGetShopDataChangeMsg)
  self:AddUIListener(EventId.GetActMonopolyShoUpdatepMsg, self.OnGetShopDataChangeMsg)
  self:AddUIListener(EventId.OnPackageInfoUpdated, self.OnGetShopDataChangeMsg)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetActMonopolyShopMsg, self.OnGetShopDataChangeMsg)
  self:RemoveUIListener(EventId.GetActMonopolyShoUpdatepMsg, self.OnGetShopDataChangeMsg)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.OnGetShopDataChangeMsg)
end

local function ClearAllItem(self)
  self.content:RemoveComponents(UIActMonopolyShopItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.uiActMonopolyShopItem.gameObject:GameObjectRecycleAll()
  self.shopItems = {}
end

local function RefreshView(self)
  local dataNum = #self.shopShowData.dataArr
  local itemNum = #self.shopItems
  if dataNum ~= itemNum then
    self:ClearAllItem()
    for i = 1, dataNum do
      local index = i
      local item = self.uiActMonopolyShopItem.gameObject:GameObjectSpawn(self.content.transform)
      item.name = index
      local obj = self.content:AddComponent(UIActMonopolyShopItem, item.name)
      obj:SetActive(true)
      self.shopItems[index] = obj
    end
  end
  for i = 1, dataNum do
    self.shopItems[i]:SetData(self.activityId, self.shopShowData.dataArr[i])
  end
  local contentH = dataNum * itemHigh
  contentH = math.min(contentH, contentMaxHigh)
  self.scrollView:SetPreferredHeight(contentH)
  self.soft_viewport:SetImage(nil)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityInfo == nil then
    return
  end
  local showTemp = activityInfo:GetShowConfigTemp()
  if showTemp == nil then
    return
  end
  local imgStr = showTemp.pic_spec4
  local imgList = string.split(imgStr, "|")
  if #imgList == 7 then
    self.bg:LoadSprite(string.format(UIAssets.UIActMonopolyTexturePath, imgList[1]))
    self.bg:SetNativeSize()
    self.content_bg:LoadSprite(string.format(UIAssets.UIActMonopolySpritePath, imgList[2]))
    self.mask_img:LoadSprite(string.format(UIAssets.UIActMonopolySpritePath, imgList[7]))
    self.bottom_raw_img:LoadSprite(string.format(UIAssets.UIActMonopolyTexturePath, imgList[3]))
    self.bottom_raw_img:SetNativeSize()
    self.bottom_raw_img2:LoadSprite(string.format(UIAssets.UIActMonopolyTexturePath, imgList[6]))
  end
  local paraTemp = DataCenter.ActMonopolyDataManager:GetMonopolyParaTempById(activityInfo.richman_para)
  if paraTemp ~= nil and not string.IsNullOrEmpty(paraTemp.shop_text_color) then
    local splitPara = string.split(paraTemp.shop_text_color, "|")
    if #splitPara == 3 then
      local splitDesc2Color = string.split(splitPara[1], ",")
      if #splitDesc2Color == 4 then
        self.desc2_text:SetColorRGBA255(tonumber(splitDesc2Color[1]), tonumber(splitDesc2Color[2]), tonumber(splitDesc2Color[3]), tonumber(splitDesc2Color[4]))
      end
    end
  end
end

local function PlayOpenAni(self)
  self.animator:Play("Eff_dwf_shangdian_dakai")
  local dataNum = #self.shopShowData.dataArr
  for i = 1, dataNum do
    self.shopItems[i]:PlayAniDelayTime(0.3 * i)
  end
end

local function OnGetShopDataChangeMsg(self)
  if self.activityDetailData == nil then
    return
  end
  self.shopShowData = self.activityDetailData:GetShopShowListData()
  if #self.shopShowData.dataArr > 1 and self.topTipId then
    for index, v in ipairs(self.shopShowData.dataArr) do
      if v.storeKey == self.topTipId and index ~= 1 then
        self.shopShowData.dataArr[1], self.shopShowData.dataArr[index] = self.shopShowData.dataArr[index], self.shopShowData.dataArr[1]
        break
      end
    end
  end
  if self.shopShowData.refreshTime > 0 then
    self:RefreshView()
  else
    self.ctrl:CloseSelf()
  end
end

local function Update1000MS(self)
  if self.shopShowData and self.shopShowData.refreshTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local shopLeftTime = self.shopShowData.refreshTime * 1000 - curTime
    if shopLeftTime < 0 then
      shopLeftTime = 0
      self:OnGetShopDataChangeMsg()
    end
  else
    self.ctrl:CloseSelf()
  end
end

UIActMonopolyShopView.OnCreate = OnCreate
UIActMonopolyShopView.OnDestroy = OnDestroy
UIActMonopolyShopView.OnAddListener = OnAddListener
UIActMonopolyShopView.OnRemoveListener = OnRemoveListener
UIActMonopolyShopView.ClearAllItem = ClearAllItem
UIActMonopolyShopView.RefreshView = RefreshView
UIActMonopolyShopView.PlayOpenAni = PlayOpenAni
UIActMonopolyShopView.OnGetShopDataChangeMsg = OnGetShopDataChangeMsg
UIActMonopolyShopView.Update1000MS = Update1000MS
return UIActMonopolyShopView
