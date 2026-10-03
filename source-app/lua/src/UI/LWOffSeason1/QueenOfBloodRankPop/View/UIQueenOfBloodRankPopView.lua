local UIQueenOfBloodRankPopView = BaseClass("UIQueenOfBloodRankPopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIQueenOfBloodRankItem = require("UI.LWOffSeason1.QueenOfBloodRankPop.Component.UIQueenOfBloodRankItem")
local UICommonTabGroup = require("UI.UICommonTabGroup.UICommonTabGroup")
local CommonTabGoupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local QualityIconPath = {
  "Assets/Main/Sprites/UI/LWOffSeason1/QueenOfBloodAtlas/mjc_nvwangtiaozhan_jin.png",
  "Assets/Main/Sprites/UI/LWOffSeason1/QueenOfBloodAtlas/mjc_nvwangtiaozhan_yin.png",
  "Assets/Main/Sprites/UI/LWOffSeason1/QueenOfBloodAtlas/mjc_nvwangtiaozhan_tong.png"
}

function UIQueenOfBloodRankPopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIQueenOfBloodRankPopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIQueenOfBloodRankPopView:ComponentDefine()
  self.textTitleTxt = self:AddComponent(UITextMeshProUGUIEx, "Root/Content/UICommonPopBg/bg_3/TitleTxt")
  self.textDescTxt = self:AddComponent(UITextMeshProUGUIEx, "Root/Content/ContentHolder/ContentJoinHolder/DescTxt")
  self.textNumTxt = self:AddComponent(UITextMeshProUGUIEx, "Root/Content/ContentHolder/ContentJoinHolder/NumTxt")
  self.scrollView = self:AddComponent(UIScrollView, "Root/Content/ContentHolder/ContentJoinHolder/Scroll")
  self.compContent = self:AddComponent(UIBaseContainer, "Root/Content/ContentHolder/ContentJoinHolder/Scroll/Viewport/Content")
  self.compOwnRankItem = self:AddComponent(UIQueenOfBloodRankItem, "Root/Content/ContentHolder/ContentJoinHolder/OwnRankItem")
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.btnPanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnClose = self:AddComponent(UIButton, "Root/Content/UICommonPopBg/bg_3/CloseBtn")
  self.btnClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.compQualityGroup = self:AddComponent(UICommonTabGroup, "Root/Content/ContentHolder/ContentJoinHolder/QualityGroup")
  self.compQualityGroup:SetTabItemStyle(CommonTabGroupItemStyle.Style5)
end

function UIQueenOfBloodRankPopView:ComponentDestroy()
  self:ClearScroll()
  self.textTitleTxt = nil
  self.textDescTxt = nil
  self.textNumTxt = nil
  self.scrollViewScroll = nil
  self.compContent = nil
  self.compOwnRankItem = nil
  self.btnPanel = nil
  self.btnClose = nil
  self.compQualityGroup = nil
end

function UIQueenOfBloodRankPopView:DataDefine()
  self.qualityTabIndex = DataCenter.OffSeason1QueenOfBloodManager:GetRankDefaultQualityAndCount()
  self.qualityGroupLoadFinish = false
  local data = self:GetUserData()
  self:SetData(data)
  self:InitQualityTabGroup()
end

function UIQueenOfBloodRankPopView:DataDestroy()
  self.ctrl:ClearRankFullData()
  self.qualityTabIndex = nil
  self.qualityGroupLoadFinish = nil
end

function UIQueenOfBloodRankPopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PushBloodyQueenS1RestRefreshRankPopInView, self.OnPushBloodyQueenS1RestRefreshRankPopInView)
  self:AddUIListener(EventId.PushBloodyQueenBattlePersonalRank, self.OnPushBloodyQueenBattlePersonalRank)
end

function UIQueenOfBloodRankPopView:OnRemoveListener()
  self:RemoveUIListener(EventId.PushBloodyQueenS1RestRefreshRankPopInView, self.OnPushBloodyQueenS1RestRefreshRankPopInView)
  self:RemoveUIListener(EventId.PushBloodyQueenBattlePersonalRank, self.OnPushBloodyQueenBattlePersonalRank)
  base.OnRemoveListener(self)
end

function UIQueenOfBloodRankPopView:InitQualityTabGroup()
  local groupList = self:GetQualityTabGroupList()
  local bindFunc1 = BindCallback(self, self.OnQualityGroupLoadFinish)
  local bindFunc2 = BindCallback(self, self.OnClickQualityTab)
  
  local function bindFunc3(index)
  end
  
  self.compQualityGroup:RefreshGroup(groupList, bindFunc1, bindFunc2, bindFunc3)
end

function UIQueenOfBloodRankPopView:GetQualityTabGroupList()
  local QualityGroupList = {}
  for i = 1, 3 do
    local temp = CommonTabGoupItemTemplate.New()
    temp.title = ""
    temp.selectBgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_sanji_1.png"
    temp.iconPath = QualityIconPath[i]
    temp.minWidth = 235
    temp.unSelectIconPath = temp.iconPath
    QualityGroupList[i] = temp
  end
  return QualityGroupList
end

function UIQueenOfBloodRankPopView:OnQualityGroupLoadFinish()
  self.compQualityGroup:SelectTab(self.qualityTabIndex)
  self.qualityGroupLoadFinish = true
end

function UIQueenOfBloodRankPopView:OnClickQualityTab(index)
  self.qualityTabIndex = index
  local rankData = self.ctrl:GetRankDataByQuality(self.qualityTabIndex)
  if rankData then
    self.rankData = rankData.ranks
    self.ownRankData = rankData.self
    self:Refresh()
  end
end

function UIQueenOfBloodRankPopView:OnItemMoveIn(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(UIQueenOfBloodRankItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  item:SetData(self.showDatalist[index], false, self.activityCount, self.qualityTabIndex)
end

function UIQueenOfBloodRankPopView:OnItemMoveOut(itemObj, index)
end

function UIQueenOfBloodRankPopView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIQueenOfBloodRankItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

function UIQueenOfBloodRankPopView:SetData(data)
  self.ctrl:RefreshRankFullData(data)
  self.activityCount = data.activityCount
  if self.qualityGroupLoadFinish then
    self:OnClickQualityTab(self.qualityTabIndex)
  end
end

function UIQueenOfBloodRankPopView:Refresh()
  local data = self.rankData
  if data and 0 < #data then
    self.scrollView:SetActive(true)
    self.showDatalist = data
    self.scrollView:SetTotalCount(#self.showDatalist)
    self.scrollView:RefillCells()
  else
    self:ClearScroll()
  end
  if self.ownRankData then
    self.compOwnRankItem:SetData(self.ownRankData, true, self.activityCount, self.qualityTabIndex)
  end
  self.textTitleTxt:SetLocalText("s1_QueenChallenge_result_title", self.activityCount or 0)
  local fullData = self.ctrl:GetRankFullData()
  self.textDescTxt:SetLocalText("s1_QueenChallenge_result_task1", fullData.cityCount or 0)
end

function UIQueenOfBloodRankPopView:OnPushBloodyQueenS1RestRefreshRankPopInView(extendInfo)
  SFSNetwork.SendMessage(MsgDefines.BloodyQueenPersonalRank, tonumber(extendInfo), false, true)
end

function UIQueenOfBloodRankPopView:OnPushBloodyQueenBattlePersonalRank(data)
  if data.activityCount == self.activityCount then
    self:SetData(data)
  end
end

return UIQueenOfBloodRankPopView
