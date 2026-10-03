local base = UIBaseView
local UIJigsawRankView = BaseClass("UIJigsawRankView", base)
local Localization = CS.GameEntry.Localization
local JigsawRankItem = require("UI.UIJigsawRank.Component.JigsawRankItem")
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local rankTab_path = "offset/Tab/Toggle"
local rankSv_path = "offset/rank/rankSv"
local rankTxt_path = "offset/Rect_RankDes/Txt_RankName"
local useTimeTxt_path = "offset/Rect_RankDes/Txt_RankScore"
local rewardsTxt_path = "offset/Rect_RankDes/Txt_RankReward"
local selfRank_path = "offset/selfRank/selfRank"
local selfTimeTip_path = "offset/selfRank/selfRank/timeTip"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

local function OnDestroy(self)
  self:ClearRankScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetText(Localization:GetString("390040"))
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.selfRankN = self:AddComponent(JigsawRankItem, selfRank_path)
  self.selfScoreTipN = self:AddComponent(UIText, selfTimeTip_path)
  self.selfScoreTipN:SetText(Localization:GetString("372356"))
  self.rankTabTbN = {}
  for i = 1, 3 do
    local tabPath = rankTab_path .. i
    local tab = self:AddComponent(UIToggle, tabPath)
    tab:SetOnValueChanged(function(tf)
      if tf then
        self:ShowRankByIndex(i)
      end
    end)
    local newTab = {}
    newTab.rootN = tab
    newTab.chooseN = tab:AddComponent(UIBaseContainer, "Choose")
    newTab.redN = tab:AddComponent(UIBaseContainer, "ImgWarn")
    table.insert(self.rankTabTbN, newTab)
  end
  self.rankSvN = self:AddComponent(UIScrollView, rankSv_path)
  self.rankSvN:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.rankSvN:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.rankTxtN = self:AddComponent(UIText, rankTxt_path)
  self.rankTxtN:SetText(Localization:GetString("100184"))
  self.useTimeTxtN = self:AddComponent(UIText, useTimeTxt_path)
  self.useTimeTxtN:SetText(Localization:GetString("372356"))
  self.rewardsTxtN = self:AddComponent(UIText, rewardsTxt_path)
  self.rewardsTxtN:SetText(Localization:GetString("130065"))
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.closeBtnN = nil
  self.rankTabSvN = nil
  self.selfRankN = nil
  self.rankSvN = nil
  self.rankTxtN = nil
  self.useTimeTxtN = nil
  self.rewardsTxtN = nil
end

local function DataDefine(self)
  self.activityId = nil
  self.curJigsawId = nil
  self.jigsawList = nil
  self.rankInfo = nil
end

local function DataDestroy(self)
  self.activityId = nil
  self.curJigsawId = nil
  self.jigsawList = nil
  self.rankInfo = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnJigsawRankUpdate, self.RefreshRanks)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnJigsawRankUpdate, self.RefreshRanks)
  base.OnRemoveListener(self)
end

local function InitUI(self)
  self.activityId, self.curJigsawId = self:GetUserData()
  self.jigsawList = DataCenter.JigsawPuzzleManager:GetJigsawConfByActId(self.activityId)
  if not self.curJigsawId then
    self.curJigsawId = self.jigsawList[1].id
  end
  self:RefreshRankTabs()
  self:ShowRankByIndex(1)
end

local function ShowRankByIndex(self, tempIndex)
  for i = 1, #self.rankTabTbN do
    self.rankTabTbN[i].chooseN:SetActive(i == tempIndex)
  end
  local jigsawInfo = self.jigsawList[tempIndex]
  self.curJigsawId = jigsawInfo.id
  self:RefreshRanks()
end

local function RefreshRankTabs(self)
  for i, v in ipairs(self.rankTabTbN) do
    if i <= #self.jigsawList then
      v.rootN:SetActive(true)
    else
      v.rootN:SetActive(false)
    end
  end
end

local function RefreshRanks(self, paramTb)
  if paramTb and (paramTb.activityId ~= self.activityId or paramTb.id ~= self.curJigsawId) then
    return
  end
  self.rankInfo = DataCenter.JigsawPuzzleManager:GetJigsawRankInfo(self.activityId, self.curJigsawId, true)
  self:ClearRankScroll()
  if self.rankInfo then
    if self.rankInfo.rankList and #self.rankInfo.rankList > 0 then
      self.rankSvN:SetTotalCount(#self.rankInfo.rankList)
      self.rankSvN:RefillCells()
    end
    self:RefreshSelfRank(self.rankInfo)
  end
end

local function RefreshSelfRank(self, tempRankInfo)
  local selfRankDetail = {}
  selfRankDetail.uid = LuaEntry.Player.uid
  selfRankDetail.rank = tempRankInfo.selfRank
  selfRankDetail.score = tempRankInfo.selfScore
  selfRankDetail.name = LuaEntry.Player.name
  selfRankDetail.pic = LuaEntry.Player.pic
  selfRankDetail.picVer = LuaEntry.Player.picVer
  local monthCardInfo = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
  selfRankDetail.monthCardEndTime = monthCardInfo and monthCardInfo.endTime or 0
  
  function selfRankDetail.GetHeadBgImg(tb)
    local headBgImg
    local serverTimeS = UITimeManager:GetInstance():GetServerSeconds()
    if tb.monthCardEndTime and serverTimeS < tb.monthCardEndTime then
      headBgImg = "Common_playerbg_golloes"
    end
    if headBgImg and headBgImg ~= "" then
      return string.format(LoadPath.CommonNewPath, headBgImg)
    end
  end
  
  local allianceBase = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  selfRankDetail.abbr = allianceBase and allianceBase.abbr or nil
  selfRankDetail.allianceName = allianceBase and allianceBase.allianceName or nil
  self.selfRankN:SetItem(selfRankDetail)
end

local function GetRankRewards(self, rank)
  return DataCenter.JigsawPuzzleManager:GetRankRewards(self.activityId, self.curJigsawId, rank)
end

local function OnRankItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.rankSvN:AddComponent(JigsawRankItem, itemObj)
  cellItem:SetItem(self.rankInfo.rankList[index])
end

local function OnRankItemMoveOut(self, itemObj, index)
  self.rankSvN:RemoveComponent(itemObj.name, JigsawRankItem)
end

local function ClearRankScroll(self)
  self.rankSvN:ClearCells()
  self.rankSvN:RemoveComponents(JigsawRankItem)
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

UIJigsawRankView.OnCreate = OnCreate
UIJigsawRankView.OnDestroy = OnDestroy
UIJigsawRankView.OnAddListener = OnAddListener
UIJigsawRankView.OnRemoveListener = OnRemoveListener
UIJigsawRankView.ComponentDefine = ComponentDefine
UIJigsawRankView.ComponentDestroy = ComponentDestroy
UIJigsawRankView.DataDefine = DataDefine
UIJigsawRankView.DataDestroy = DataDestroy
UIJigsawRankView.InitUI = InitUI
UIJigsawRankView.RefreshRankTabs = RefreshRankTabs
UIJigsawRankView.RefreshRanks = RefreshRanks
UIJigsawRankView.ShowRankByIndex = ShowRankByIndex
UIJigsawRankView.OnRankItemMoveIn = OnRankItemMoveIn
UIJigsawRankView.OnRankItemMoveOut = OnRankItemMoveOut
UIJigsawRankView.ClearRankScroll = ClearRankScroll
UIJigsawRankView.SelectJigsaw = SelectJigsaw
UIJigsawRankView.RefreshSelfRank = RefreshSelfRank
UIJigsawRankView.GetRankRewards = GetRankRewards
UIJigsawRankView.OnClickCloseBtn = OnClickCloseBtn
return UIJigsawRankView
