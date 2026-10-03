local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ScratchOffGame = BaseClass("ScratchOffGame", base)
local Localization = CS.GameEntry.Localization
local ScratchOffDetailPage = require("UI.UIActivityCenterTable.Component.ScratchOffGame.ScratchOffDetailPage")
local ScratchOffRankingPage = require("UI.UIActivityCenterTable.Component.ScratchOffGame.ScratchOffRankingPage")
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local tabHolder_path = "RightView/Top/TabHolder"
local detailPageToggle_path = "RightView/Top/TabHolder/Tab/toggle1"
local detailPageToggleRedPoint_path = "RightView/Top/TabHolder/Tab/toggle1/RedPoint1"
local rankingPageToggle_path = "RightView/Top/TabHolder/Tab/toggle2"
local detailPage_path = "RightView/ActDetailPage"
local rankingPage_path = "RightView/RankingPage"
local diamondBar_path = "RightView/Top/DiamondBar"
local itemBar_path = "RightView/Top/ItemBar"

function ScratchOffGame:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function ScratchOffGame:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ScratchOffGame:DataDefine()
  self.selctedPageIndex = nil
end

function ScratchOffGame:DataDestroy()
  self.selctedPageIndex = nil
end

function ScratchOffGame:RefreshCurrentPage()
  if self.detailPageToggle:GetIsOn() then
    self.detailPage:SetActive(true)
    self.rankingPage:SetActive(false)
    self.detailPage:SetData(self.activityId, self.actId)
    self.selectedPageIndex = 1
  else
    self.detailPage:SetActive(false)
    self.rankingPage:SetActive(true)
    self.rankingPage:SetData(self.activityId, self.actId)
    self.selectedPageIndex = 2
  end
end

function ScratchOffGame:OnToggleClick(toggleIndex)
  if self.selectedPageIndex == toggleIndex then
    return
  end
  if toggleIndex == 1 then
    self.detailPage:SetActive(true)
    self.rankingPage:SetActive(false)
    self.detailPage:SetData(self.activityId, self.actId)
  else
    self.detailPage:SetActive(false)
    self.rankingPage:SetActive(true)
    self.rankingPage:SetData(self.activityId, self.actId)
  end
  self.selectedPageIndex = toggleIndex
end

function ScratchOffGame:ComponentDefine()
  self.tabHolder = self:AddComponent(UIBaseContainer, tabHolder_path)
  self.detailPageToggle = self:AddComponent(UIToggle, detailPageToggle_path)
  self.detailPageToggle:SetOnValueChanged(function(tf)
    if tf then
      self:OnToggleClick(1)
    end
  end)
  self.detailPageToggleRedPoint = self:AddComponent(UIBaseContainer, detailPageToggleRedPoint_path)
  self.rankingPageToggle = self:AddComponent(UIToggle, rankingPageToggle_path)
  self.rankingPageToggle:SetOnValueChanged(function(tf)
    if tf then
      self:OnToggleClick(2)
    end
  end)
  self.detailPage = self:AddComponent(ScratchOffDetailPage, detailPage_path)
  self.rankingPage = self:AddComponent(ScratchOffRankingPage, rankingPage_path)
  self.diamondBar = self:AddComponent(UITopItem, diamondBar_path)
  self.itemBar = self:AddComponent(UITopItem, itemBar_path)
  
  local function gotoDiamond()
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.DiamondShop)
  end
  
  self.diamondBar:SetData(nil, ResourceType.Gold, gotoDiamond)
end

function ScratchOffGame:OnEnable()
  base.OnEnable(self)
end

function ScratchOffGame:ComponentDestroy()
end

function ScratchOffGame:SetData(activityId, id)
  self.activityId = id
  self.actId = activityId
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
  if not self.activityInfo then
    return
  end
  self.activityTemplate = DataCenter.ScratchOffGameManager:GetActivityTemplate(self.activityId)
  
  local function gotoPack()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.activityId, self.activityTemplate.exchange, self.activityTemplate.costItemId)
  end
  
  self.itemBar:SetData(self.activityTemplate.costItemId, nil, gotoPack)
  if self.detailPageToggle:GetIsOn() then
    self:RefreshCurrentPage()
  else
    self.detailPageToggle:SetIsOn(true)
    self.rankingPageToggle:SetIsOn(false)
  end
end

function ScratchOffGame:OnDisable()
  base.OnDisable(self)
end

function ScratchOffGame:RefreshRedPoint()
  if self.activityId == nil then
    self.detailPageToggleRedPoint:SetActive(false)
    return
  end
  self.detailPageToggleRedPoint:SetActive(DataCenter.ScratchOffGameManager:GetRedPointCount(toInt(self.activityId)) > 0)
end

function ScratchOffGame:RefreshGold()
  if self.diamondBar then
    self.diamondBar:RefreshData()
  end
end

function ScratchOffGame:RefreshItem()
  if self.itemBar then
    self.itemBar:RefreshData()
  end
end

function ScratchOffGame:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.RefreshRedPoint)
  self:AddUIListener(EventId.UpdateGold, self.RefreshGold)
  self:AddUIListener(EventId.RefreshItems, self.RefreshItem)
end

function ScratchOffGame:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshGold)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshItem)
end

return ScratchOffGame
