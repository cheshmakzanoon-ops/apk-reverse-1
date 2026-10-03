local LWUIZoneMobilizationAllianceRankView = BaseClass("LWUIZoneMobilizationAllianceRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIZoneMobilizationAllianceRankTabItemRender = require("UI.LWUIZoneMobilization.LWUIAllianceRank.Component.LWUIZoneMobilizationAllianceRankTabItemRender")
local LWUIZoneMobilizationAllianceRankItemRender = require("UI.LWUIZoneMobilization.LWUIAllianceRank.Component.LWUIZoneMobilizationAllianceRankItemRender")
local TopThreeTrophiesRawImageName = "ljq_zhanqudongyuan_paihangbang_jiangbei_0%s_no%s"
local RankItemPrefab = "Assets/Main/Prefabs/UI/LWUIZoneMobilization/LWUIZoneMobilizationAllianceRankItemRender.prefab"
local TabViewDataList = {
  {
    tabType = ZoneMobilizationRankType.Donated,
    tabName = "zone_mobilization_donate_alliance_rank_title"
  },
  {
    tabType = ZoneMobilizationRankType.Damage,
    tabName = "zone_mobilization_damage_alliance_rank_title"
  }
}

function LWUIZoneMobilizationAllianceRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIZoneMobilizationAllianceRankView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIZoneMobilizationAllianceRankView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.tabScrollView = self.viewSkin:AddComponent(self, UIScrollView, 1)
  self.bgImage = self.viewSkin:AddComponent(self, UIImage, 2)
  self.bgLeftRawImage = self.viewSkin:AddComponent(self, UIRawImage, 3)
  self.bgRightRawImage = self.viewSkin:AddComponent(self, UIRawImage, 4)
  self.rankRawImage = self.viewSkin:AddComponent(self, UIRawImage, 5)
  self.backBtn = self.viewSkin:AddComponent(self, UIButton, 6)
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.rewardBtn = self.viewSkin:AddComponent(self, UIButton, 7)
  self.rewardBtn:SetOnClick(function()
    self:OnRewardBtnClick()
  end)
  self.personalRankBtn = self.viewSkin:AddComponent(self, UIButton, 8)
  self.personalRankBtn:SetOnClick(function()
    self:OnPersonalRankBtnClick()
  end)
  self.rankLoopListView = self.viewSkin:AddComponent(self, UILoopListView2, 9)
  self.rankScrollContent = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.joinAllianceBtn = self.viewSkin:AddComponent(self, UIButton, 11)
  self.joinAllianceBtn:SetOnClick(function()
    self:OnJoinAllianceBtnClick()
  end)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.rawImgTopThreeTrophiesRawImage = self.viewSkin:AddComponent(self, UIRawImage, 13)
  self.rawImgTopOneTrophiesRawImage = self.viewSkin:AddComponent(self, UIRawImage, 14)
  self.rawImgTopTwoTrophiesRawImage = self.viewSkin:AddComponent(self, UIRawImage, 15)
  self.imgTopTwoAllianceFlag = self.viewSkin:AddComponent(self, UIImage, 16)
  self.imgTopThreeAllianceFlag = self.viewSkin:AddComponent(self, UIImage, 17)
  self.imgTopOneAllianceFlag = self.viewSkin:AddComponent(self, UIImage, 18)
  self.textTopThreeAllianceAbbr = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.textTopTwoAllianceAbbr = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.textTopOneAllianceAbbr = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.textTopTwoAllianceName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.textTopThreeAllianceName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.textTopOneAllianceName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 24)
  self.textTopTwoAllianceScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 25)
  self.textTopThreeAllianceScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 26)
  self.textTopOneAllianceScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 27)
  self.topThreeTrophiesRawImage = {
    self.rawImgTopOneTrophiesRawImage,
    self.rawImgTopTwoTrophiesRawImage,
    self.rawImgTopThreeTrophiesRawImage
  }
  self.topThreeAllianceFlag = {
    self.imgTopOneAllianceFlag,
    self.imgTopTwoAllianceFlag,
    self.imgTopThreeAllianceFlag
  }
  self.topThreeAllianceAbbrText = {
    self.textTopOneAllianceAbbr,
    self.textTopTwoAllianceAbbr,
    self.textTopThreeAllianceAbbr
  }
  self.topThreeAllianceNameText = {
    self.textTopOneAllianceName,
    self.textTopTwoAllianceName,
    self.textTopThreeAllianceName
  }
  self.topThreeAllianceScoreText = {
    self.textTopOneAllianceScore,
    self.textTopTwoAllianceScore,
    self.textTopThreeAllianceScore
  }
end

function LWUIZoneMobilizationAllianceRankView:ComponentDestroy()
  self.viewSkin = nil
  self.tabScrollView = nil
  self.bgImage = nil
  self.bgLeftRawImage = nil
  self.bgRightRawImage = nil
  self.rankRawImage = nil
  self.backBtn = nil
  self.rewardBtn = nil
  self.personalRankBtn = nil
  self.rankLoopListView = nil
  self.rankScrollContent = nil
  self.joinAllianceBtn = nil
  self.content = nil
  self.rawImgTopThreeTrophiesRawImage = nil
  self.rawImgTopOneTrophiesRawImage = nil
  self.rawImgTopTwoTrophiesRawImage = nil
  self.imgTopTwoAllianceFlag = nil
  self.imgTopThreeAllianceFlag = nil
  self.imgTopOneAllianceFlag = nil
  self.textTopThreeAllianceAbbr = nil
  self.textTopTwoAllianceAbbr = nil
  self.textTopOneAllianceAbbr = nil
  self.textTopTwoAllianceName = nil
  self.textTopThreeAllianceName = nil
  self.textTopOneAllianceName = nil
  self.textTopTwoAllianceScore = nil
  self.textTopThreeAllianceScore = nil
  self.textTopOneAllianceScore = nil
  self.topThreeTrophiesRawImage = nil
  self.topThreeAllianceFlag = nil
  self.topThreeAllianceAbbrText = nil
  self.topThreeAllianceNameText = nil
  self.topThreeAllianceScoreText = nil
end

function LWUIZoneMobilizationAllianceRankView:DataDefine()
  self.tabScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnTabItemMoveIn(itemObj, index)
  end)
  self.tabScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnTabItemMoveOut(itemObj, index)
  end)
  self.rankLoopListView:InitListView(0, function(listView, index)
    return self:OnGetItemByIndex(listView, index)
  end)
  self.tabViewItemRenderDict = {}
  self.rankInfoData = {}
  self.initPlayAni = false
  self.curRankType = self:GetUserData() or ZoneMobilizationRankType.Donated
  local tabCount = #TabViewDataList
  if 0 < tabCount then
    self.tabScrollView:SetTotalCount(tabCount)
    self.tabScrollView:RefillCells()
  end
  self:RefreshJoinAllianceView()
  self:ReqRankList()
  self:RefreshCurRankTypeView()
  self:ShowRankList()
end

function LWUIZoneMobilizationAllianceRankView:DataDestroy()
  self:ClearTabScroll()
  self:ClearRankLoopView()
  self.selfAllianceRankItemReq = nil
  self.selfAllianceRankItem = nil
  self.curRankType = nil
  self.tabViewItemRenderDict = nil
  self.rankInfoData = nil
  self.initPlayAni = nil
end

function LWUIZoneMobilizationAllianceRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetZoneMobilizationRankData, self.OnGetRankData)
  self:AddUIListener(EventId.AllianceCreateSuccess, self.OnCreateAllianceSuccess)
  self:AddUIListener(EventId.AllianceApplySuccess, self.OnJoinAllianceSuccess)
end

function LWUIZoneMobilizationAllianceRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.GetZoneMobilizationRankData, self.OnGetRankData)
  self:RemoveUIListener(EventId.AllianceCreateSuccess, self.OnCreateAllianceSuccess)
  self:RemoveUIListener(EventId.AllianceApplySuccess, self.OnJoinAllianceSuccess)
  base.OnRemoveListener(self)
end

function LWUIZoneMobilizationAllianceRankView:OnBackBtnClick()
  self.ctrl:CloseSelf()
end

function LWUIZoneMobilizationAllianceRankView:OnRewardBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIZoneMobilizationRankRewardPreview, {anim = true}, self.curRankType)
end

function LWUIZoneMobilizationAllianceRankView:OnPersonalRankBtnClick()
  if self.rankInfoData then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIZoneMobilizationPersonalRank, {anim = true}, self.rankInfoData)
  end
end

function LWUIZoneMobilizationAllianceRankView:OnJoinAllianceBtnClick()
  UIUtil.OnJoinAllianceBtnClick()
end

function LWUIZoneMobilizationAllianceRankView:OnGetRankData(rankType)
  if self.curRankType == rankType then
    self:ShowRankList()
  end
end

function LWUIZoneMobilizationAllianceRankView:OnCreateAllianceSuccess(isSuccess)
  if isSuccess then
    self:ReqRankList()
    self:RefreshJoinAllianceView()
  end
end

function LWUIZoneMobilizationAllianceRankView:OnJoinAllianceSuccess()
  self:ReqRankList()
  self:RefreshJoinAllianceView()
end

function LWUIZoneMobilizationAllianceRankView:ReqRankList()
  SFSNetwork.SendMessage(MsgDefines.ZoneMobilizationRankList, self.curRankType)
end

function LWUIZoneMobilizationAllianceRankView:RefreshCurRankTypeView()
  local bgImagePath, bgRawImagePath, rankRawImagePath
  if self.curRankType == ZoneMobilizationRankType.Donated then
    bgImagePath = "ljq_zhanqudongyuan_paihangbang_jiugong_01"
    bgRawImagePath = "ljq_zhanqudongyuan_paihangbang_bg_03"
    rankRawImagePath = "ljq_zhanqudongyuan_paihangbang_dizuo_01"
  elseif self.curRankType == ZoneMobilizationRankType.Damage then
    bgImagePath = "ljq_zhanqudongyuan_paihangbang_jiugong_02"
    bgRawImagePath = "ljq_zhanqudongyuan_paihangbang_bg_04"
    rankRawImagePath = "ljq_zhanqudongyuan_paihangbang_dizuo_02"
  end
  self.bgImage:LoadSpriteAuto(string.format(LoadPath.LWUIZoneMobilizationSpritePath, bgImagePath))
  bgRawImagePath = string.format(LoadPath.LWUIZoneMobilizationTexturePath, bgRawImagePath)
  self.bgLeftRawImage:LoadSpriteAuto(bgRawImagePath)
  self.bgRightRawImage:LoadSpriteAuto(bgRawImagePath)
  self.rankRawImage:LoadSpriteAuto(string.format(LoadPath.LWUIZoneMobilizationTexturePath, rankRawImagePath))
  for i = 1, 3 do
    local trophiesName = string.format(TopThreeTrophiesRawImageName, self.curRankType, i)
    self.topThreeTrophiesRawImage[i]:LoadSpriteAuto(string.format(LoadPath.LWUIZoneMobilizationTexturePath, trophiesName))
    self.topThreeAllianceFlag[i]:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, "3"))
  end
end

function LWUIZoneMobilizationAllianceRankView:RefreshJoinAllianceView()
  local x = self.rankLoopListView:GetOffsetMinXY()
  if not LuaEntry.Player:IsInAlliance() then
    self.personalRankBtn:SetActive(false)
    self.joinAllianceBtn:SetActive(true)
    self.rankLoopListView:SetOffsetMinXY(x, 173)
  else
    self.personalRankBtn:SetActive(true)
    self.joinAllianceBtn:SetActive(false)
    self.rankLoopListView:SetOffsetMinXY(x, 308.8)
  end
end

function LWUIZoneMobilizationAllianceRankView:OnTabItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.tabScrollView:AddComponent(LWUIZoneMobilizationAllianceRankTabItemRender, itemObj)
  if itemRender ~= nil then
    local tableData = TabViewDataList[index]
    itemRender:InitData(tableData, self.curRankType)
    self.tabViewItemRenderDict[tableData.tabType] = itemRender
  end
end

function LWUIZoneMobilizationAllianceRankView:OnTabItemMoveOut(itemObj, index)
  self.tabScrollView:RemoveComponent(itemObj.name, LWUIZoneMobilizationAllianceRankTabItemRender)
end

function LWUIZoneMobilizationAllianceRankView:ClearTabScroll()
  self.tabScrollView:ClearCells()
  self.tabScrollView:RemoveComponents(LWUIZoneMobilizationAllianceRankTabItemRender)
  self.tabViewItemRenderDict = {}
end

function LWUIZoneMobilizationAllianceRankView:OnTabItemClick(newRankType)
  if self.curRankType == newRankType then
    return
  end
  if self.tabViewItemRenderDict[self.curRankType] ~= nil then
    self.tabViewItemRenderDict[self.curRankType]:SetSelectState(false)
  end
  self.curRankType = newRankType
  if self.tabViewItemRenderDict[newRankType] ~= nil then
    self.tabViewItemRenderDict[newRankType]:SetSelectState(true)
  end
  self:ReqRankList()
  self:RefreshCurRankTypeView()
  self:ShowRankList()
end

function LWUIZoneMobilizationAllianceRankView:ShowRankList()
  self.rankInfoData = DataCenter.LWZoneMobilizationManager:GetRankInfoDataByType(self.curRankType)
  self:ShowTopThreeRank()
  self:ShowSelfAllianceRank()
  if self.rankInfoData then
    local allianceRankListCount = table.count(self.rankInfoData.allianceRankDict)
    if 4 <= allianceRankListCount then
      self.rankLoopListView:SetActive(true)
      self.rankLoopListView:SetListItemCount(allianceRankListCount - 3, false, false)
      self.rankLoopListView:RefreshAllShownItem()
    else
      self.rankLoopListView:SetActive(false)
    end
  else
    self.rankLoopListView:SetActive(false)
  end
end

function LWUIZoneMobilizationAllianceRankView:ShowTopThreeRank()
  local allianceRankListCount = self.rankInfoData and table.count(self.rankInfoData.allianceRankDict) or 0
  for i = 1, 3 do
    if i <= allianceRankListCount then
      local allianceRankData = self.rankInfoData.allianceRankDict[i]
      self.topThreeAllianceFlag[i]:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, tostring(allianceRankData.icon)))
      self.topThreeAllianceAbbrText[i]:SetText(allianceRankData.abbr)
      self.topThreeAllianceNameText[i]:SetText(allianceRankData.allianceName)
      self.topThreeAllianceScoreText[i]:SetText(string.GetFormattedSeparatorNum(allianceRankData.score))
    else
      self.topThreeAllianceFlag[i]:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, "3"))
      self.topThreeAllianceAbbrText[i]:SetText("")
      self.topThreeAllianceNameText[i]:SetLocalText("zone_mobilization_alliance_name_no_data")
      self.topThreeAllianceScoreText[i]:SetText("")
    end
  end
end

function LWUIZoneMobilizationAllianceRankView:ShowSelfAllianceRank()
  if self.rankInfoData == nil then
    if self.selfAllianceRankItem ~= nil then
      self.selfAllianceRankItem:SetActive(false)
    end
    return
  end
  local allianceRankListCount = table.count(self.rankInfoData.allianceRankDict)
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  local isShow = 0 < allianceRankListCount and hasAlliance
  local comp = self.selfAllianceRankItem
  if comp == nil then
    if isShow and self.selfAllianceRankItemReq == nil then
      self.selfAllianceRankItemReq = self:GameObjectInstantiateAsync(RankItemPrefab, function(request)
        if request.isError then
          self.selfAllianceRankItemReq = nil
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "selfAllianceRankItem"
        local item = self.content:AddComponent(LWUIZoneMobilizationAllianceRankItemRender, go)
        item:SetAnchorMinXY(0.5, 0)
        item:SetAnchorMaxXY(0.5, 0)
        item:SetPivotXY(0.5, 0)
        item:SetAnchoredPositionXY(0, 173.4)
        self.selfAllianceRankItem = item
        self:ShowSelfAllianceRank()
      end)
    end
    return
  end
  comp:SetActive(isShow)
  if isShow then
    comp:InitData(self.rankInfoData.selfAllianceRankInfo)
    if not self.initPlayAni then
      self.initPlayAni = true
      comp:PlayAni()
    end
  end
end

function LWUIZoneMobilizationAllianceRankView:OnGetItemByIndex(listView, index)
  if self.rankInfoData == nil or self.rankInfoData.allianceRankDict == nil or #self.rankInfoData.allianceRankDict <= 0 then
    return nil
  end
  local count = table.count(self.rankInfoData.allianceRankDict)
  count = count - 3
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = listView:NewListViewItem("LWUIZoneMobilizationAllianceRankItemRender")
  local script = self.rankScrollContent:GetComponent(item.gameObject.name, LWUIZoneMobilizationAllianceRankItemRender)
  if script == nil then
    local objectName = "Item" .. UIUtil.GetLoopListItemIndex()
    item.gameObject.name = objectName
    script = self.rankScrollContent:AddComponent(LWUIZoneMobilizationAllianceRankItemRender, objectName)
  end
  script:SetActive(true)
  local rankData = self.rankInfoData.allianceRankDict[index + 3]
  script:InitData(rankData)
  return item
end

function LWUIZoneMobilizationAllianceRankView:ClearRankLoopView()
  self.rankScrollContent:RemoveComponents(LWUIZoneMobilizationAllianceRankItemRender)
  self.rankLoopListView:ClearAllItems()
end

return LWUIZoneMobilizationAllianceRankView
