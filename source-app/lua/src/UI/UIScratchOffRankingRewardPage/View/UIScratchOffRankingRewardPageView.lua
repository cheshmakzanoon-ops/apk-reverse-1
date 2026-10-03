local UIScratchOffRankingRewardPageView = BaseClass("UIScratchOffRankingRewardPageView", UIBaseView)
local base = UIBaseView
local ScratchOffRankingRewardItem = require("UI.UIScratchOffRankingRewardPage.Comp.ScratchOffRankingRewardItem")
local titleTxt_path = "UICommonPopUpTitle/Common_img_title/titleText"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local panel_path = "UICommonPopUpTitle/panel"
local noRecordTxt_path = "Root/noRecordTxt"
local scrollView_Path = "Root/ScrollView"

function UIScratchOffRankingRewardPageView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self.rankingRewardInfos = self:GetUserData()
  self:RefreshView()
end

function UIScratchOffRankingRewardPageView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIScratchOffRankingRewardPageView:OnEnable()
  base.OnEnable(self)
end

function UIScratchOffRankingRewardPageView:DataDefine()
end

function UIScratchOffRankingRewardPageView:DataDestroy()
  self.rankingRewardInfos = nil
end

function UIScratchOffRankingRewardPageView:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.noRecordTxt = self:AddComponent(UIText, noRecordTxt_path)
  self.noRecordTxt:SetLocalText(302233)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panelBtn = self:AddComponent(UIButton, panel_path)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.ScrollView = self:AddComponent(UIScrollView, scrollView_Path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
end

function UIScratchOffRankingRewardPageView:ComponentDestroy()
  self.titleTxt = nil
  self.closeBtn = nil
  self.panelBtn = nil
  self.ScrollView = nil
  self.noRecordTxt = nil
end

function UIScratchOffRankingRewardPageView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.ScrollView:AddComponent(ScratchOffRankingRewardItem, itemObj)
  item:SetData(self.rankingRewardInfos[index])
end

function UIScratchOffRankingRewardPageView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, ScratchOffRankingRewardItem)
end

function UIScratchOffRankingRewardPageView:RefreshView()
  if self.rankingRewardInfos and #self.rankingRewardInfos > 0 then
    self.ScrollView:SetTotalCount(#self.rankingRewardInfos)
    self.ScrollView:RefillCells()
    self.ScrollView:ScrollToCell(1)
    self.noRecordTxt:SetActive(false)
  else
    self.noRecordTxt:SetActive(true)
  end
end

function UIScratchOffRankingRewardPageView:OnAddListener()
  base.OnAddListener(self)
end

function UIScratchOffRankingRewardPageView:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UIScratchOffRankingRewardPageView
