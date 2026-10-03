local UIQueenOfBloodAllianceListPopView = BaseClass("UIQueenOfBloodAllianceListPopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIQueenOfBloodAllianceItem = require("UI.LWOffSeason1.QueenOfBloodAlliance.Component.UIQueenOfBloodAllianceListItem")

function UIQueenOfBloodAllianceListPopView:OnCreate()
  base.OnCreate(self)
  self.param = self:GetUserData()
  DataCenter.OffSeason1QueenOfBloodManager:SendBloodyQueenS1RestChooseCityDefendGain(self.param)
  self:ComponentDefine()
  self:DataDefine()
end

function UIQueenOfBloodAllianceListPopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIQueenOfBloodAllianceListPopView:ComponentDefine()
  self.btnClose = self:AddComponent(UIButton, "Root/Content/UICommonPopBg/bg_3/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.scrollView = self:AddComponent(UIScrollView, "Root/Content/ContentHolder/ContentJoinHolder/Scroll")
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.content = self:AddComponent(UIBaseComponent, "Root/Content/ContentHolder/ContentJoinHolder/Scroll/Viewport/Content")
  self.imgEmpty = self:AddComponent(UIImage, "Root/Content/ContentHolder/ContentJoinHolder/imgEmpty")
  self.scrollView:SetActive(false)
  self.imgEmpty.gameObject:SetActive(false)
  self.textTitle = self:AddComponent(UIText, "Root/Content/UICommonPopBg/bg_3/TitleTxt")
end

function UIQueenOfBloodAllianceListPopView:ComponentDestroy()
  self.btnClose = nil
  self.btnPanel = nil
  self.scrollView = nil
  self.content = nil
  self.imgEmpty = nil
  self.textTitle = nil
end

function UIQueenOfBloodAllianceListPopView:DataDefine()
  self.allianceList = {}
  self.scrollCellPool = {}
  self.itemIndex = 1
end

function UIQueenOfBloodAllianceListPopView:DataDestroy()
  self:ClearScroll()
end

function UIQueenOfBloodAllianceListPopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ShowQueenOfBloodAllianceList, self.RefreshUI)
end

function UIQueenOfBloodAllianceListPopView:OnRemoveListener()
  self:RemoveUIListener(EventId.ShowQueenOfBloodAllianceList, self.RefreshUI)
  base.OnRemoveListener(self)
end

function UIQueenOfBloodAllianceListPopView:RefreshUI()
  self.itemIndex = 1
  self.allianceList = DataCenter.OffSeason1QueenOfBloodManager:GetSelectAllianceList()
  if self.allianceList and #self.allianceList > 0 then
    self.scrollView:SetActive(true)
    self.scrollView:SetTotalCount(#self.allianceList)
    self.scrollView:RefillCells()
    self.imgEmpty.gameObject:SetActive(false)
    self.textTitle:SetLocalText("s1_QueenChallenge_signUpList_title", #self.allianceList)
  else
    self.scrollView:SetActive(false)
    self.imgEmpty.gameObject:SetActive(true)
    self.textTitle:SetLocalText("s1_QueenChallenge_signUpList_title", 0)
  end
end

function UIQueenOfBloodAllianceListPopView:OnItemMoveIn(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(UIQueenOfBloodAllianceItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local data = self.allianceList[index]
  item:ReInit(data)
end

function UIQueenOfBloodAllianceListPopView:OnItemMoveOut(itemObj, index)
end

function UIQueenOfBloodAllianceListPopView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIQueenOfBloodAllianceItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.allianceList = {}
end

function UIQueenOfBloodAllianceListPopView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIQueenOfBloodAllianceListPopView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

return UIQueenOfBloodAllianceListPopView
