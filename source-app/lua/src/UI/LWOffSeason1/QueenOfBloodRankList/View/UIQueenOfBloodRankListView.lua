local UIQueenOfBloodRankListView = BaseClass("UIQueenOfBloodRankListView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonTabGroup = require("UI.UICommonTabGroup.UICommonTabGroup")
local UIQueenOfBloodRankListItem = require("UI.LWOffSeason1.QueenOfBloodRankList.Component.UIQueenOfBloodRankListItem")
local CommonTabGoupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local QualityIconPath = {
  "Assets/Main/Sprites/UI/LWOffSeason1/QueenOfBloodAtlas/mjc_nvwangtiaozhan_jin.png",
  "Assets/Main/Sprites/UI/LWOffSeason1/QueenOfBloodAtlas/mjc_nvwangtiaozhan_yin.png",
  "Assets/Main/Sprites/UI/LWOffSeason1/QueenOfBloodAtlas/mjc_nvwangtiaozhan_tong.png"
}

function UIQueenOfBloodRankListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIQueenOfBloodRankListView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIQueenOfBloodRankListView:ComponentDefine()
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/TopBar/TextTitle")
  self.compTypeGroup = self:AddComponent(UICommonTabGroup, "Root/TypeGroup")
  self.compQualityGroup = self:AddComponent(UICommonTabGroup, "Root/QualityGroup")
  self.compTitleGroup = self:AddComponent(UIBaseComponent, "Root/TitleGroup")
  self.textTitle1 = self:AddComponent(UITextMeshProUGUIEx, "Root/TitleGroup/Bg/Title1Text")
  self.textTitle2 = self:AddComponent(UITextMeshProUGUIEx, "Root/TitleGroup/Bg/Title2Text")
  self.textTitle3 = self:AddComponent(UITextMeshProUGUIEx, "Root/TitleGroup/Bg/Title3Text")
  self.btnInfo = self:AddComponent(UIButton, "Root/TitleGroup/Bg/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.scrollView = self:AddComponent(UIScrollView, "Root/ScrollView")
  self.compSelfItem = self:AddComponent(UIQueenOfBloodRankListItem, "Root/SelfItem")
  self.textTip = self:AddComponent(UITextMeshProUGUIEx, "Root/BottomBar/TipText")
  self.btnBack = self:AddComponent(UIButton, "Root/BottomBar/BackBtn")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.serverBg = self:AddComponent(UIBaseComponent, "Root/BottomBar/ServerBg")
  self.serverBg:SetActive(false)
  self.serverIcon = self:AddComponent(UIImage, "Root/BottomBar/ServerBg/ServerIcon")
  self.compTypeGroup:SetTabItemStyle(CommonTabGroupItemStyle.Style4)
  self.compQualityGroup:SetTabItemStyle(CommonTabGroupItemStyle.Style5)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.noneText = self:AddComponent(UIText, "Root/ScrollView/NoneText")
  self.noneText:SetLocalText("s1_QueenChallenge_rank_nodata")
  self.noneText:SetActive(false)
  self.roundGroup = self:AddComponent(UIBaseComponent, "Root/BottomBar/RoundGroup")
  self.roundLeftBtn = self:AddComponent(UIButton, "Root/BottomBar/RoundGroup/LeftBtn")
  self.roundRightBtn = self:AddComponent(UIButton, "Root/BottomBar/RoundGroup/RightBtn")
  self.roundText = self:AddComponent(UIText, "Root/BottomBar/RoundGroup/RoundBg/RoundText")
  self.roundLeftBtn:SetOnClick(function()
    self:ChangeRoundIndex(-1)
  end)
  self.roundRightBtn:SetOnClick(function()
    self:ChangeRoundIndex(1)
  end)
end

function UIQueenOfBloodRankListView:ComponentDestroy()
  self:ClearScroll()
  self.textTitle = nil
  self.compTypeGroup = nil
  self.compQualityGroup = nil
  self.compTitleGroup = nil
  self.textTitle1 = nil
  self.textTitle2 = nil
  self.textTitle3 = nil
  self.btnInfo = nil
  self.scrollView = nil
  self.compSelfItem = nil
  self.textTip = nil
  self.btnBack = nil
  self.noneText = nil
  self.roundGroup = nil
  self.roundRightBtn = nil
  self.roundText = nil
end

function UIQueenOfBloodRankListView:DataDefine()
  self.typeTabIndex = 1
  self.qualityTabIndex, self.roundTabIndex = DataCenter.OffSeason1QueenOfBloodManager:GetRankDefaultQualityAndCount()
  self.rankFullData = nil
  self.qualityGroupNeedRequest = true
  self:Init()
end

function UIQueenOfBloodRankListView:DataDestroy()
  self.ctrl:ClearRankFullData()
  self.typeTabIndex = nil
  self.qualityTabIndex = nil
  self.roundTabIndex = nil
  self.rankFullData = nil
  self.qualityGroupNeedRequest = nil
end

function UIQueenOfBloodRankListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PushBloodyQueenBattlePersonalRank, self.OnPushBloodyQueenBattlePersonalRank)
  self:AddUIListener(EventId.PushBloodyQueenBattleAllianceRank, self.OnPushBloodyQueenBattleAllianceRank)
  self:AddUIListener(EventId.PushBloodyQueenBattleAreaRank, self.OnPushBloodyQueenBattleAreaRank)
end

function UIQueenOfBloodRankListView:OnRemoveListener()
  self:RemoveUIListener(EventId.PushBloodyQueenBattlePersonalRank, self.OnPushBloodyQueenBattlePersonalRank)
  self:RemoveUIListener(EventId.PushBloodyQueenBattleAllianceRank, self.OnPushBloodyQueenBattleAllianceRank)
  self:RemoveUIListener(EventId.PushBloodyQueenBattleAreaRank, self.OnPushBloodyQueenBattleAreaRank)
  base.OnRemoveListener(self)
end

function UIQueenOfBloodRankListView:OnBtnInfoClick()
  UIUtil.ShowButtonTips(self.btnInfo, "", "s1_QueenChallenge_rank_warzone_desc")
end

function UIQueenOfBloodRankListView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UIQueenOfBloodRankListView:OnPushBloodyQueenBattlePersonalRank(data)
  if self.typeTabIndex ~= 1 or self.roundTabIndex ~= data.activityCount then
    return
  end
  self.ctrl:RefreshRankFullData(data)
  self:OnClickQualityTab(self.qualityTabIndex)
end

function UIQueenOfBloodRankListView:OnPushBloodyQueenBattleAllianceRank(data)
  if self.typeTabIndex ~= 2 or self.roundTabIndex ~= data.activityCount then
    return
  end
  self.ctrl:RefreshRankFullData(data)
  self:OnClickQualityTab(self.qualityTabIndex)
end

function UIQueenOfBloodRankListView:OnPushBloodyQueenBattleAreaRank(data)
  if self.typeTabIndex ~= 3 then
    return
  end
  self.rankData = data.ranks
  self.ownRankData = data.self
  self:Refresh()
end

function UIQueenOfBloodRankListView:Init()
  local cfg = LuaEntry.DataConfig:TryGetStr("s1_offSeason_rerecapture", "k19")
  local cfgId = 511010
  local count = 16
  if not string.IsNullOrEmpty(cfg) then
    local split = string.split(cfg, ";")
    count = tonumber(split[1])
    cfgId = tonumber(split[2])
  end
  local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(cfgId)
  if itemCfg ~= nil then
    self.serverIcon:LoadSprite(string.format(LoadPath.ItemPath, itemCfg.icon))
  end
  self.textTip:SetLocalText("s1_QueenChallenge_rank_warzone_reward", count, Localization:GetString(itemCfg.name))
  self:InitTypeTabGroup()
end

function UIQueenOfBloodRankListView:InitTypeTabGroup()
  local groupList = self:GetTypeTabGroupList()
  local bindFunc1 = BindCallback(self, self.OnTypeGroupLoadFinish)
  local bindFunc2 = BindCallback(self, self.OnClickTypeTab)
  
  local function bindFunc3(index)
  end
  
  self.compTypeGroup:RefreshGroup(groupList, bindFunc1, bindFunc2, bindFunc3)
end

function UIQueenOfBloodRankListView:GetTypeTabGroupList()
  local typeGroupList = {}
  for i = 1, 3 do
    local temp = CommonTabGoupItemTemplate.New()
    if i == 1 then
      temp.title = Localization:GetString("s1_QueenChallenge_rank_personal")
    elseif i == 2 then
      temp.title = Localization:GetString("s1_QueenChallenge_rank_alliance")
    elseif i == 3 then
      temp.title = Localization:GetString("s1_QueenChallenge_rank_warzone")
    end
    temp.selectBgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_yiji_1.png"
    temp.arrowPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_yiji_1_1.png"
    typeGroupList[i] = temp
  end
  return typeGroupList
end

function UIQueenOfBloodRankListView:OnTypeGroupLoadFinish()
  self.compTypeGroup:SelectTab(1)
end

function UIQueenOfBloodRankListView:OnClickTypeTab(index)
  self.typeTabIndex = index
  self.qualityGroupNeedRequest = true
  if self.typeTabIndex == 1 then
    self.compQualityGroup:SetActive(true)
    self.compTitleGroup:SetActive(false)
    self.roundGroup:SetActive(true)
    self.serverBg:SetActive(false)
    self.btnInfo:SetActive(false)
    self.textTip:SetActive(false)
    self:InitQualityTabGroup()
  elseif self.typeTabIndex == 2 then
    self.compQualityGroup:SetActive(true)
    self.compTitleGroup:SetActive(false)
    self.roundGroup:SetActive(true)
    self.serverBg:SetActive(false)
    self.btnInfo:SetActive(false)
    self.textTip:SetActive(false)
    self:InitQualityTabGroup()
  elseif self.typeTabIndex == 3 then
    self.compQualityGroup:SetActive(false)
    self.compTitleGroup:SetActive(true)
    self.roundGroup:SetActive(false)
    self.serverBg:SetActive(true)
    self.btnInfo:SetActive(true)
    self.textTitle1:SetLocalText("s1_QueenChallenge_rank_warzone_rank")
    self.textTitle2:SetLocalText("s1_QueenChallenge_rank_warzone_name")
    self.textTitle3:SetLocalText("s1_QueenChallenge_rank_warzone_result")
    self.textTip:SetActive(true)
    SFSNetwork.SendMessage(MsgDefines.BloodyQueenBattleAreaRank)
  end
end

function UIQueenOfBloodRankListView:InitQualityTabGroup()
  local groupList = self:GetQualityTabGroupList()
  local bindFunc1 = BindCallback(self, self.OnQualityGroupLoadFinish)
  local bindFunc2 = BindCallback(self, self.OnClickQualityTab)
  
  local function bindFunc3(index)
  end
  
  self.compQualityGroup:RefreshGroup(groupList, bindFunc1, bindFunc2, bindFunc3)
end

function UIQueenOfBloodRankListView:GetQualityTabGroupList()
  local QualityGroupList = {}
  for i = 1, 3 do
    local temp = CommonTabGoupItemTemplate.New()
    temp.title = ""
    temp.selectBgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_sanji_1.png"
    temp.iconPath = QualityIconPath[i]
    temp.minWidth = 250
    temp.unSelectIconPath = temp.iconPath
    QualityGroupList[i] = temp
  end
  return QualityGroupList
end

function UIQueenOfBloodRankListView:OnQualityGroupLoadFinish()
  self.compQualityGroup:SelectTab(self.qualityTabIndex)
end

function UIQueenOfBloodRankListView:OnClickQualityTab(index)
  self.qualityTabIndex = index
  if self.qualityGroupNeedRequest then
    self:ChangeRoundIndex(0)
  else
    local rankData = self.ctrl:GetRankDataByQuality(self.qualityTabIndex)
    if rankData then
      self.rankData = rankData.ranks
      self.ownRankData = rankData.self
      self:Refresh()
    else
      self.rankData = nil
      self.ownRankData = nil
      self:Refresh()
    end
  end
end

function UIQueenOfBloodRankListView:OnItemMoveIn(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(UIQueenOfBloodRankListItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  item:SetData(self.showDatalist[index], self.typeTabIndex, false, self.roundTabIndex, self.qualityTabIndex)
end

function UIQueenOfBloodRankListView:OnItemMoveOut(itemObj, index)
end

function UIQueenOfBloodRankListView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIQueenOfBloodRankListItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

function UIQueenOfBloodRankListView:Refresh()
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
    self.compSelfItem:SetActive(true)
    self.compSelfItem:SetData(self.ownRankData, self.typeTabIndex, true, self.roundTabIndex, self.qualityTabIndex)
    self.noneText:SetActive(false)
  else
    self.compSelfItem:SetActive(false)
    self.noneText:SetActive(true)
  end
end

function UIQueenOfBloodRankListView:ChangeRoundIndex(changeNum)
  local index = self.roundTabIndex + changeNum
  if index < 1 or index > (DataCenter.OffSeason1QueenOfBloodManager.activityCount or 6) then
    return
  end
  self.roundTabIndex = index
  self.roundText:SetText(self.roundTabIndex)
  self.qualityGroupNeedRequest = false
  self.ctrl:ClearRankFullData()
  if self.typeTabIndex == 1 then
    SFSNetwork.SendMessage(MsgDefines.BloodyQueenPersonalRank, self.roundTabIndex)
  elseif self.typeTabIndex == 2 then
    SFSNetwork.SendMessage(MsgDefines.BloodyQueenAllianceRank, self.roundTabIndex)
  end
end

return UIQueenOfBloodRankListView
