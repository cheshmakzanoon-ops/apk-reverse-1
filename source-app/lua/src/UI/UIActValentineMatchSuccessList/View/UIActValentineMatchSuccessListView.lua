local UIActValentineMatchSuccessListView = BaseClass("UIActValentineMatchSuccessListView", UIBaseView)
local base = UIBaseView
local UIActValentineMatchSuccessRowShell = require("UI.UIActValentineMatchSuccessList.Component.UIActValentineMatchSuccessRowShell")
local Localization = CS.GameEntry.Localization

function UIActValentineMatchSuccessListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIActValentineMatchSuccessListView:OnDestroy()
  DataCenter.ValentineDataManager:ClearAllMatchRedPointDict(self.activityId)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActValentineMatchSuccessListView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.matchMemberScroll = self.viewSkin:AddComponent(self, UILoopListView2, 2)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compMatchMemberScroll = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compEmptyRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.textEmptyTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textGetLikeNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textLikeEachNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnGetLikeRoot = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnGetLikeRoot:SetOnClick(function()
    self:OnBtnGetLikeRootClick()
  end)
  self.btnLikeEachRoot = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnLikeEachRoot:SetOnClick(function()
    self:OnBtnLikeEachRootClick()
  end)
  self.compLWBtnInfo = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.compInfoTips = self.viewSkin:AddComponent(self, UIBaseComponent, 14)
  self.btnTipClose = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnTipClose:SetOnClick(function()
    self:ClickMoreInfoCloseBtn()
  end)
  self.textInfoTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.textEmptyTips:SetLocalText("Valentine_send_bp_desc_04")
end

function UIActValentineMatchSuccessListView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.matchMemberScroll = nil
  self.compContent = nil
  self.compMatchMemberScroll = nil
  self.btnPanel = nil
  self.compEmptyRoot = nil
  self.textEmptyTips = nil
  self.textGetLikeNum = nil
  self.textLikeEachNum = nil
  self.btnClose = nil
  self.btnGetLikeRoot = nil
  self.btnLikeEachRoot = nil
  self.compLWBtnInfo = nil
  self.compInfoTips = nil
  self.btnTipClose = nil
  self.textInfoTips = nil
end

function UIActValentineMatchSuccessListView:DataDefine()
  self.activityId = self:GetUserData()
  self.matchSuccessData = {}
  self.matchPlayerRowData = {}
  self.itemScriptDic = {}
  self.matchMemberScroll:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
  local param = {
    activityId = self.activityId
  }
  SFSNetwork.SendMessage(MsgDefines.ValentineFollowList, param)
end

function UIActValentineMatchSuccessListView:DataDestroy()
  self.activityId = nil
  self.matchSuccessData = nil
  self.matchPlayerRowData = nil
  self.itemScriptDic = {}
  self.compContent:RemoveComponents(UIActValentineMatchSuccessRowShell)
  self.matchMemberScroll:ClearAllItems()
end

function UIActValentineMatchSuccessListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshValentineMatchSuccessList, self.RefreshView)
end

function UIActValentineMatchSuccessListView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshValentineMatchSuccessList, self.RefreshView)
  base.OnRemoveListener(self)
end

function UIActValentineMatchSuccessListView:RefreshView()
  self.matchSuccessData = DataCenter.ValentineDataManager:GetActMatchSuccessData(self.activityId)
  if not self.matchSuccessData then
    Logger.LogError("UIActValentineMatchSuccessListView RefreshView \232\142\183\229\143\150  matchSuccessData \228\184\186 nil.activityId:" .. tostring(self.activityId))
    return
  end
  if self.compInfoTips then
    self.compInfoTips:SetActive(false)
  end
  self.textTitle:SetLocalText("Valentine_send_bp_title_02")
  self.textGetLikeNum:SetText(self.matchSuccessData.followSize)
  self.textLikeEachNum:SetText(self.matchSuccessData.mutualFollowSize)
  self.textInfoTips:SetText(Localization:GetString("Valentine_send_bp_desc_03", self.matchSuccessData.followSize, self.matchSuccessData.mutualFollowSize))
  local matchPlayerDataList = self.matchSuccessData.playerArr or {}
  self.compMatchMemberScroll:SetActive(0 < #matchPlayerDataList)
  self.compEmptyRoot:SetActive(#matchPlayerDataList <= 0)
  if 0 < #matchPlayerDataList then
    self.matchPlayerRowData = {}
    local index = 1
    for i = 1, #matchPlayerDataList, 2 do
      self.matchPlayerRowData[index] = {
        matchPlayerDataList[i],
        matchPlayerDataList[i + 1]
      }
      index = index + 1
    end
    self.matchMemberScroll:SetListItemCount(#self.matchPlayerRowData, false, false)
    self.matchMemberScroll:RefreshAllShownItem()
  end
  local anchoredPosition1 = self.btnGetLikeRoot:GetAnchoredPosition()
  local arrowPos1X = anchoredPosition1.x
  local arrowPos1Y = anchoredPosition1.y
  self.compLWBtnInfo:SetAnchoredPositionXY(arrowPos1X, arrowPos1Y)
end

function UIActValentineMatchSuccessListView:OnGetItemByIndex(listview, index)
  if index < 0 or index >= #self.matchPlayerRowData then
    return nil
  end
  index = index + 1
  local item = listview:NewListViewItem("UIActValentineMatchSuccessRowShell")
  if item == nil then
    Logger.LogError("UIActValentineMatchSuccessListView \230\187\145\229\138\168\229\136\151\232\161\168\232\142\183\229\143\150Item\228\184\186\231\169\186 \239\188\154" .. tostring(index))
    return nil
  end
  local temp = self.itemScriptDic[item]
  if temp == nil then
    NameCount = NameCount + 1
    item.gameObject.name = item.gameObject.name .. tostring(NameCount)
    temp = self.compContent:AddComponent(UIActValentineMatchSuccessRowShell, item.gameObject)
    temp:SetActive(true)
    self.itemScriptDic[item] = temp
  end
  temp:SetActive(true)
  temp:SetData(self.activityId, self.matchPlayerRowData[index])
  return item
end

function UIActValentineMatchSuccessListView:OnRecycleItemFunc(loopListViewItem)
end

function UIActValentineMatchSuccessListView:ClickMoreInfoBtn()
  if not self.compInfoTips then
    return
  end
  self.compInfoTips:SetActive(not self.compInfoTips.activeSelf)
end

function UIActValentineMatchSuccessListView:ClickMoreInfoCloseBtn()
  if not self.compInfoTips then
    return
  end
  self.compInfoTips:SetActive(false)
end

function UIActValentineMatchSuccessListView:OnBtnGetLikeRootClick()
  self:ClickMoreInfoBtn()
end

function UIActValentineMatchSuccessListView:OnBtnLikeEachRootClick()
  self:ClickMoreInfoBtn()
end

function UIActValentineMatchSuccessListView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIActValentineMatchSuccessListView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UIActValentineMatchSuccessListView
