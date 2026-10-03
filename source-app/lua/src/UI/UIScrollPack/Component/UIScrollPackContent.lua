local UIScrollPackContent = BaseClass("UIScrollPackContent", UIBaseContainer)
local base = UIBaseContainer
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local bg_path = "Bg"
local percent_bg_path = "PercentBg"
local percent_path = "PercentBg/Percent"
local title_path = "Title"
local desc_path = "Desc"
local diamond_image_path = "GameObject/DiamondBg"
local diamond_text_path = "GameObject/DiamondBg/DiamondNum"
local time_bg_path = "GameObject/TimeBg"
local time_path = "GameObject/TimeBg/Time"
local scroll_view_path = "ScrollView"
local buy_btn_path = "BuyButton"
local buy_text_path = "BuyButton/BuyButtonText"
local effect_path = "Effect"
local point_path = "BuyButton/UIGiftPackagePoint"
local MISSING_IMAGE = string.format(PackageImgPath.ScrollPack, "SellDiamond")
local TitleColorDict = {
  SellConsigliere = Color.New(0.3568628, 0.254902, 0.6392157, 1),
  SellDetective = Color.New(0.5019608, 0.3137255, 0.3803922, 1),
  SellClown = Color.New(0.3568628, 0.254902, 0.6392157, 1),
  Default = Color.New(0.5529412, 0.254902, 0.05098039, 1)
}
local DescColorDict = {
  SellConsigliere = WhiteColor,
  SellSumo = WhiteColor,
  SellDetective = Color.New(0.5019608, 0.3137255, 0.3803922, 1),
  SellClown = WhiteColor,
  Default = Color.New(0.8156863, 0.4078431, 0.1960784, 1)
}

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
  self.bg_image = self:AddComponent(UIImage, bg_path)
  self.percent_bg_go = self:AddComponent(UIBaseContainer, percent_bg_path)
  self.percent_text = self:AddComponent(UIText, percent_path)
  self.title_text = self:AddComponent(UIText, title_path)
  self.title_outline = self:AddComponent(UIOutline, title_path)
  self.title_shadow = self:AddComponent(UIShadow, title_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.diamond_image = self:AddComponent(UIImage, diamond_image_path)
  self.diamond_text = self:AddComponent(UIText, diamond_text_path)
  self.time_bg_go = self:AddComponent(UIBaseContainer, time_bg_path)
  self.time_text = self:AddComponent(UIText, time_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.buy_btn:SetOnClick(function()
    self:OnBuyClick()
  end)
  self.buy_text = self:AddComponent(UIText, buy_text_path)
  self.point_rect = self:AddComponent(UIGiftPackagePoint, point_path)
  self.effect_go = self:AddComponent(UIBaseContainer, effect_path)
end

local function ComponentDestroy(self)
  self.bg_image = nil
  self.percent_bg_go = nil
  self.percent_text = nil
  self.title_text = nil
  self.title_outline = nil
  self.title_shadow = nil
  self.desc_text = nil
  self.diamond_image = nil
  self.diamond_text = nil
  self.time_bg_go = nil
  self.time_text = nil
  self.scroll_view = nil
  self.buy_btn = nil
  self.buy_text = nil
  self.point_rect = nil
  self.effect_go = nil
end

local function DataDefine(self)
  self.pack = nil
  self.rewardList = nil
  self.timer = nil
  self.onBuy = nil
end

local function DataDestroy(self)
  self.pack = nil
  self.rewardList = nil
  if self.timer ~= nil then
    self.timer:Stop()
  end
  self.timer = nil
  self.onBuy = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ShowCells(self)
  local count = table.count(self.rewardList)
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  end
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UICommonResItem)
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(UICommonResItem, itemObj)
  item:ReInit(self.rewardList[index])
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

local function SetData(self, pack, onBuy)
  self.pack = pack
  self.onBuy = onBuy
  self.rewardList = {}
  local heroStr = pack:getHeroesStr()
  if not string.IsNullOrEmpty(heroStr) then
    local spls = string.split(heroStr, ";")
    if #spls == 2 then
      local reward = {
        rewardType = RewardType.HERO,
        itemId = tonumber(spls[1]),
        count = tonumber(spls[2])
      }
      table.insert(self.rewardList, reward)
    end
  end
  local resStrs = string.split(pack:getResourceStr(), "|")
  for _, resStr in ipairs(resStrs) do
    local spls = string.split(resStr, ";")
    if #spls == 2 then
      local reward = {
        rewardType = ResTypeToReward[tonumber(spls[1])],
        count = tonumber(spls[2])
      }
      table.insert(self.rewardList, reward)
    end
  end
  local itemStrs = string.split(pack:getItemsStr(), "|")
  for _, itemStr in ipairs(itemStrs) do
    local spls = string.split(itemStr, ";")
    if #spls == 2 then
      local reward = {
        rewardType = RewardType.GOODS,
        itemId = tonumber(spls[1]),
        count = tonumber(spls[2])
      }
      table.insert(self.rewardList, reward)
    end
  end
  local alStrs = pack:getAllianceGift()
  if alStrs ~= nil then
    if type(alStrs) == "table" and not table.IsNullOrEmpty(alStrs) then
      for _, alStr in ipairs(alStrs) do
        if not string.IsNullOrEmpty(alStr) then
          local spls = string.split(alStr, ";")
          if #spls == 5 then
            local reward = {
              rewardType = RewardType.GOODS,
              iconName = string.format(LoadPath.UIAllianceGift, spls[1]),
              itemName = spls[2],
              itemDesc = spls[3],
              count = spls[4],
              itemColor = spls[5]
            }
            table.insert(self.rewardList, reward)
          end
        end
      end
    elseif type(alStrs) == "string" and not string.IsNullOrEmpty(alStrs) then
      for _, alStr in ipairs(string.split(alStrs, "|")) do
        if not string.IsNullOrEmpty(alStr) then
          local spls = string.split(alStr, ";")
          if #spls == 5 then
            local reward = {
              rewardType = RewardType.GOODS,
              iconName = string.format(LoadPath.UIAllianceGift, spls[1]),
              itemName = spls[2],
              itemDesc = spls[3],
              count = spls[4],
              itemColor = spls[5]
            }
            table.insert(self.rewardList, reward)
          end
        end
      end
    end
  end
  local percent = pack:getPercent()
  if percent ~= nil then
    self.percent_bg_go:SetActive(true)
    self.percent_text:SetText(percent .. "%")
  else
    self.percent_bg_go:SetActive(false)
  end
  local diamond = tonumber(pack:getDiamond())
  if 0 < diamond then
    self.diamond_image:SetActive(true)
    self.diamond_text:SetText(string.GetFormattedSeperatorNum(diamond))
  else
    self.diamond_image:SetActive(false)
  end
  local titleColor = TitleColorDict[pack:getPopupImageH()] or TitleColorDict.Default
  local descColor = DescColorDict[pack:getPopupImageH()] or DescColorDict.Default
  self.title_text:SetText(pack:getNameText())
  self.title_outline:SetColor(titleColor)
  self.title_shadow:SetAllColor(titleColor)
  self.desc_text:SetText(pack:getDescText())
  self.desc_text:SetColor(descColor)
  self.buy_text:SetText(DataCenter.PayManager:GetDollarText(pack:getPrice(), pack:getProductID()))
  if self.timer ~= nil then
    self.timer:Stop()
  end
  if pack:getTimeType() ~= PackTimeType.AlwaysHideTime then
    self.time_bg_go:SetActive(true)
    self.timer = TimerManager:GetInstance():GetTimer(0.1, self.TimerAction, self, false, false, false)
    self.timer:Start()
  else
    self.time_bg_go:SetActive(false)
  end
  self:ShowCells()
  self.bg_image:LoadSprite(string.format(PackageImgPath.ScrollPack, pack:getPopupImageH()), MISSING_IMAGE)
  self.point_rect:RefreshPoint(pack)
  for i = 0, self.effect_go.transform.childCount - 1 do
    local tf = self.effect_go.transform:GetChild(i)
    if string.endswith(tf.name, pack:getPopupImageH()) then
      tf.gameObject:SetActive(true)
    else
      tf.gameObject:SetActive(false)
    end
  end
end

local function TimerAction(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local restTime = self.pack:getEndTime() - curTime
  if restTime < 0 then
    return
  end
  self.time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(restTime))
end

local function OnBuyClick(self)
  if self.onBuy then
    self.onBuy()
  end
  DataCenter.PayManager:BuyGift(self.pack)
end

UIScrollPackContent.OnCreate = OnCreate
UIScrollPackContent.OnDestroy = OnDestroy
UIScrollPackContent.OnEnable = OnEnable
UIScrollPackContent.OnDisable = OnDisable
UIScrollPackContent.ComponentDefine = ComponentDefine
UIScrollPackContent.ComponentDestroy = ComponentDestroy
UIScrollPackContent.DataDefine = DataDefine
UIScrollPackContent.DataDestroy = DataDestroy
UIScrollPackContent.OnAddListener = OnAddListener
UIScrollPackContent.OnRemoveListener = OnRemoveListener
UIScrollPackContent.ShowCells = ShowCells
UIScrollPackContent.ClearScroll = ClearScroll
UIScrollPackContent.OnCreateCell = OnCreateCell
UIScrollPackContent.OnDeleteCell = OnDeleteCell
UIScrollPackContent.SetData = SetData
UIScrollPackContent.TimerAction = TimerAction
UIScrollPackContent.OnBuyClick = OnBuyClick
return UIScrollPackContent
