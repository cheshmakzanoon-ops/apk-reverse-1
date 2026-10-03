local base = UIBaseView
local UILeagueMatchResultView = BaseClass("UILeagueMatchResultView", base)
local Localization = CS.GameEntry.Localization
local LeagueMatchResultWeekItem = require("UI.LeagueMatch.UILeagueMatchResult.Component.LeagueMatchResultWeekItem")
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local emptyTip_path = "ImgBg/emptyTip"
local scrollView_path = "ImgBg/ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText("372630")
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.scrollViewN = self:AddComponent(UIScrollView, scrollView_path)
  self.scrollViewN:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollViewN:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.emptyTipN = self:AddComponent(UIText, emptyTip_path)
  self.emptyTipN:SetLocalText("302233")
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.closeBtnN = nil
  self.scrollViewN = nil
  self.emptyTipN = nil
end

local function DataDefine(self)
  self.weekCount = 0
  self.allianceGroupDic = {}
end

local function DataDestroy(self)
  self.weekCount = nil
  self.allianceGroupDic = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function InitUI(self)
  self.weekCount = self:GetWeekCount()
  if self.weekCount == 0 then
    self.emptyTipN:SetActive(true)
    self.scrollViewN:SetActive(false)
  else
    self.emptyTipN:SetActive(false)
    self.scrollViewN:SetActive(true)
    self.scrollViewN:SetTotalCount(self.weekCount)
    self.scrollViewN:RefillCells()
  end
end

local function GetWeekCount(self)
  local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
  local myMatchInfo = DataCenter.LeagueMatchManager:GetMyMatchInfo()
  if tempStage == LeagueMatchStage.Preview or tempStage == LeagueMatchStage.DrawLots or tempStage == LeagueMatchStage.DrawLotsFinished then
    if myMatchInfo.lastDuelInfo then
      local arr = string.IsNullOrEmpty(myMatchInfo.lastDuelInfo.roundResult) and {} or string.split(myMatchInfo.lastDuelInfo.roundResult, ";")
      return #arr
    else
      return 0
    end
  elseif myMatchInfo.duelInfo then
    local arr = string.IsNullOrEmpty(myMatchInfo.duelInfo.roundResult) and {} or string.split(myMatchInfo.duelInfo.roundResult, ";")
    return #arr
  else
    return 0
  end
end

local function GetAllianceListByWeek(self, week)
  if self.allianceGroupDic[week] then
    return self.allianceGroupDic[week]
  else
    local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
    local allianceList = {}
    if tempStage == LeagueMatchStage.Preview or tempStage == LeagueMatchStage.DrawLots or tempStage == LeagueMatchStage.DrawLotsFinished then
      allianceList = DataCenter.LeagueMatchManager:GetLastMatchGroupInfo()
    else
      allianceList = DataCenter.LeagueMatchManager:GetMatchGroupInfo()
    end
    local retList = DeepCopy(allianceList)
    local endIndex = (week - 1) * 2 - 1
    table.sort(retList, function(a, b)
      local roundResultA = 0 < endIndex and string.sub(a.roundResult, 1, endIndex) or 0
      local roundResultB = 0 < endIndex and string.sub(b.roundResult, 1, endIndex) or 0
      if roundResultA ~= roundResultB then
        return roundResultA > roundResultB
      elseif a.position ~= b.position then
        return a.position < b.position
      else
        return false
      end
    end)
    self.allianceGroupDic[week] = retList
    return retList
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewN:AddComponent(LeagueMatchResultWeekItem, itemObj)
  local reverseIndex = self.weekCount - index + 1
  local allianceList = self:GetAllianceListByWeek(reverseIndex)
  cellItem:SetItem(reverseIndex, allianceList)
end

local function OnItemMoveOut(self, itemObj, index)
  self.scrollViewN:RemoveComponent(itemObj.name, LeagueMatchResultWeekItem)
end

local function ClearScroll(self)
  self.scrollViewN:ClearCells()
  self.scrollViewN:RemoveComponents(LeagueMatchResultWeekItem)
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

UILeagueMatchResultView.OnCreate = OnCreate
UILeagueMatchResultView.OnDestroy = OnDestroy
UILeagueMatchResultView.OnAddListener = OnAddListener
UILeagueMatchResultView.OnRemoveListener = OnRemoveListener
UILeagueMatchResultView.ComponentDefine = ComponentDefine
UILeagueMatchResultView.ComponentDestroy = ComponentDestroy
UILeagueMatchResultView.DataDefine = DataDefine
UILeagueMatchResultView.DataDestroy = DataDestroy
UILeagueMatchResultView.InitUI = InitUI
UILeagueMatchResultView.GetWeekCount = GetWeekCount
UILeagueMatchResultView.GetAllianceListByWeek = GetAllianceListByWeek
UILeagueMatchResultView.OnItemMoveIn = OnItemMoveIn
UILeagueMatchResultView.OnItemMoveOut = OnItemMoveOut
UILeagueMatchResultView.ClearScroll = ClearScroll
UILeagueMatchResultView.OnClickCloseBtn = OnClickCloseBtn
return UILeagueMatchResultView
