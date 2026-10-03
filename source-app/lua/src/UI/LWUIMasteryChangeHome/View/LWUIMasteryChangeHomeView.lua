local LWUIMasteryChangeHomeView = BaseClass("LWUIMasteryChangeHomeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIMasteryChangeHomeItem = require("UI.LWUIMasteryChangeHome.Component.LWUIMasteryChangeHomeItem")
local homeItem_path = "MasteryItemContent/home"
local return_btn_path = "UICommonMiniPopUpTitle/panel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/CloseBtn")
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.desTxt = self:AddComponent(UIText, "DesTxt")
  self.des2Txt = self:AddComponent(UIText, "Des2Txt")
  self.homeItems = {}
  for i = 1, 2 do
    local itemPath = homeItem_path .. i
    local homeItem = self:AddComponent(LWUIMasteryChangeHomeItem, itemPath)
    self.homeItems[i] = homeItem
  end
  self.changeBtn = self:AddComponent(UIButton, "changeBtn")
  self.changeBtn:SetOnClick(function()
    self:OnChangeHomeBtnClick()
  end)
  self.goodsIcon = self:AddComponent(UIImage, "changeBtn/item/goodsIcon")
  self.itemCount = self:AddComponent(UIText, "changeBtn/item/itemCount")
end

local function ComponentDestroy(self)
  self.return_btn = nil
  self.close_btn = nil
  self.desTxt = nil
  self.des2Txt = nil
  self.homeItems = nil
  self.changeBtn = nil
  self.goodsIcon = nil
  self.itemCount = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.OnItemDataChange)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.OnItemDataChange)
end

local function DataDefine(self)
  self.selectHomeId = 0
  self.selfHomeId = 0
end

local function DataDestroy(self)
  self.selectHomeId = nil
  self.selfHomeId = nil
end

local function ReInit(self)
  self.masteryData = DataCenter.MasteryManager:GetData()
  self.selfHomeId = self.masteryData.home_id
  local itemIndex = 1
  for i = 1, #MasteryHomeShowList do
    local homeId = MasteryHomeShowList[i]
    if homeId ~= self.selfHomeId and itemIndex <= #self.homeItems then
      self.homeItems[itemIndex]:SetData(homeId, 0, function(homeId)
        self:OnMasteryItemClick(homeId)
      end)
      itemIndex = itemIndex + 1
    end
  end
  self:Refresh()
end

local function Refresh(self)
  self:RefreshItems()
  self:RefreshInfoContent()
end

local function RefreshItems(self)
  for _, item in pairs(self.homeItems) do
    item:SetSelectData(self.selectHomeId)
  end
  CS.UIGray.SetGray(self.changeBtn.transform, self.selectHomeId == 0, true)
end

local function RefreshInfoContent(self)
  local costId = LuaEntry.DataConfig:TryGetNum("lw_season_mastery", "k2")
  local costNum = 1
  local costItem = DataCenter.ItemData:GetItemById(costId)
  local costItemNum = costItem and costItem.count or 0
  local costTemp = DataCenter.ItemTemplateManager:GetItemTemplate(costId)
  local costIconPath = string.format(LoadPath.ItemPath, costTemp.icon)
  self.goodsIcon:LoadSprite(costIconPath)
  self.itemCount:SetText(string.format("%d/%d", costItemNum, costNum))
end

local function OnMasteryItemClick(self, homeId)
  if self.selectHomeId == homeId then
    return
  end
  local showTemp = DataCenter.MasteryManager:GetHomeShowTempByHomeId(homeId)
  if not showTemp.lock then
    self.selectHomeId = homeId
    self:RefreshItems()
  else
    UIUtil.ShowTipsId("season_mastery_104")
  end
end

local function OnChangeHomeBtnClick(self)
  if self.selectHomeId == 0 then
    UIUtil.ShowTipsId("season_tips165")
    return
  end
  local costId = LuaEntry.DataConfig:TryGetNum("lw_season_mastery", "k2")
  local costNum = 1
  local costItem = DataCenter.ItemData:GetItemById(costId)
  local costItemNum = costItem and costItem.count or 0
  if costNum <= costItemNum then
    local canUse, tempData = DataCenter.MasteryManager:CanUseTemplates(self.selectHomeId)
    if not canUse then
      SFSNetwork.SendMessage(MsgDefines.LwSeasonMasteryHomeChange, self.selectHomeId, 0)
      self.ctrl:CloseSelf()
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryTemplate, {anim = true}, {tempData, self})
    end
  else
    LWResourceLackUtil:GotoGoodsItemLack(costId, 1)
  end
end

local function OnItemDataChange(self)
  self:RefreshInfoContent()
end

LWUIMasteryChangeHomeView.OnCreate = OnCreate
LWUIMasteryChangeHomeView.OnDestroy = OnDestroy
LWUIMasteryChangeHomeView.ComponentDefine = ComponentDefine
LWUIMasteryChangeHomeView.ComponentDestroy = ComponentDestroy
LWUIMasteryChangeHomeView.OnAddListener = OnAddListener
LWUIMasteryChangeHomeView.OnRemoveListener = OnRemoveListener
LWUIMasteryChangeHomeView.DataDefine = DataDefine
LWUIMasteryChangeHomeView.DataDestroy = DataDestroy
LWUIMasteryChangeHomeView.ReInit = ReInit
LWUIMasteryChangeHomeView.Refresh = Refresh
LWUIMasteryChangeHomeView.RefreshItems = RefreshItems
LWUIMasteryChangeHomeView.RefreshInfoContent = RefreshInfoContent
LWUIMasteryChangeHomeView.OnMasteryItemClick = OnMasteryItemClick
LWUIMasteryChangeHomeView.OnChangeHomeBtnClick = OnChangeHomeBtnClick
LWUIMasteryChangeHomeView.OnItemDataChange = OnItemDataChange
return LWUIMasteryChangeHomeView
