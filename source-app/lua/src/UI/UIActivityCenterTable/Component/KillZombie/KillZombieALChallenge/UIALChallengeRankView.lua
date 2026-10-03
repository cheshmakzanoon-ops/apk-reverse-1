local UIALChallengeRankView = BaseClass("UIALChallengeRankView", UIBaseView)
local RankListItem = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieALChallenge.Component.UIALChallengeRankComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local scroll_path = "Root/ImgBg/ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self.param = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshRankList()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.param = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  SFSNetwork.SendMessage(MsgDefines.ALMonsterChallengeGetProgress, self.param.difficulty)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.textTitle:SetText(Localization:GetString("challenge_zombie_006"))
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.challengeItemContainer = self:AddComponent(UIBaseContainer, "Root/ImgBg/ScrollView/Viewport/Content")
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.emptyTxt = self:AddComponent(UIText, "Root/ImgBg/ScrollView/Viewport/EmptyText")
  self.emptyTxt:SetText(Localization:GetString("challenge_zombie_010"))
  self.btnMask = self:AddComponent(UIButton, "Mask")
  self.btnMask:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.textTitle = nil
  self.btnClose = nil
  self.challengeItemContainer = nil
  self.ScrollView = nil
  self.btnMask = nil
end

function UIALChallengeRankView:RefreshRankList()
  self:ClearScroll()
  self.rankList = self.ctrl:GetRankList()
  local rankCount = #self.rankList
  self.ScrollView:SetTotalCount(rankCount)
  self.ScrollView:RefillCells()
  self.emptyTxt:SetActive(rankCount == 0)
  local maxCount = 0
  local maxLevel = 0
  local curDifficult = self.param.curDifficult
  local curDifficultyALCondtions = DataCenter.ActivityKillZombieManager:GetALChallengeConditionList(curDifficult)
  if curDifficultyALCondtions and curDifficultyALCondtions[1] then
    maxCount = tonumber(curDifficultyALCondtions[1].count)
    maxLevel = tonumber(curDifficultyALCondtions[1].level)
  end
  local finishedCount = 0
  for index, data in pairs(self.rankList) do
    local curLevel = data.level and tonumber(data.level) or 0
    local curDifficultuMaxLevel = maxLevel
    if maxLevel == -1 then
      local curDataDifficulty = data.curDifficulty
      local personChallengeDatas = DataCenter.ActivityKillZombieManager:GetListByType(1)
      local personChallengeData = personChallengeDatas.data[curDataDifficulty]
      curDifficultuMaxLevel = 0
      if personChallengeData then
        curDifficultuMaxLevel = #personChallengeData.monsterList
      end
    end
    if curLevel >= curDifficultuMaxLevel then
      finishedCount = finishedCount + 1
    end
  end
  self.textTitle:SetText(string.format("%s(%d/%d)", Localization:GetString("challenge_zombie_006"), finishedCount, maxCount))
end

function UIALChallengeRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(RankListItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetItemShow(self.rankList[index], self.param.curDifficult)
  end
end

function UIALChallengeRankView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, RankListItem)
end

function UIALChallengeRankView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(RankListItem)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.MonsterChallengeALProgressUpdate, self.RefreshRankList)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.MonsterChallengeALProgressUpdate, self.RefreshRankList)
  base.OnRemoveListener(self)
end

local function OnBtnCloseClick(self)
  self.ctrl.CloseSelf()
end

UIALChallengeRankView.OnCreate = OnCreate
UIALChallengeRankView.OnDestroy = OnDestroy
UIALChallengeRankView.OnEnable = OnEnable
UIALChallengeRankView.OnDisable = OnDisable
UIALChallengeRankView.ComponentDefine = ComponentDefine
UIALChallengeRankView.ComponentDestroy = ComponentDestroy
UIALChallengeRankView.DataDefine = DataDefine
UIALChallengeRankView.DataDestroy = DataDestroy
UIALChallengeRankView.OnAddListener = OnAddListener
UIALChallengeRankView.OnRemoveListener = OnRemoveListener
UIALChallengeRankView.OnBtnCloseClick = OnBtnCloseClick
return UIALChallengeRankView
