local UIChampionBattleRankCell = BaseClass("UIChampionBattleRankCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local firstNameTxt_path = "firstNameTxt"
local secondNameTxt_path = "secondNameTxt"
local powerTxt_path = "powerTxt"
local allianceIcon_path = "allianceFlag/allianceIcon"
local playerFlag_path = "playerFlag"
local playerIcon_path = "playerFlag/UIPlayerHead/HeadIcon"
local playHeadBg_path = "playerFlag/UIPlayerHead/Foreground"
local third_path = "third"
local second_path = "second"
local first_path = "first"
local numTxt_path = "numTxt"
local Button_path = "Button"
local winTxt_path = "winTxt"
local loseTxt_path = "loseTxt"
local playerBtn_path = "playerFlag/UIPlayerHead"
local promotion_path = "promotionGo"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.firstNameTxt = self:AddComponent(UIText, firstNameTxt_path)
  self.secondNameTxt = self:AddComponent(UIText, secondNameTxt_path)
  self.powerTxt = self:AddComponent(UIText, powerTxt_path)
  self.allianceIcon = self:AddComponent(UIImage, allianceIcon_path)
  self.playerFlag = self:AddComponent(UIImage, playerFlag_path)
  self.playerIcon = self:AddComponent(UIPlayerHead, playerIcon_path)
  self.playerHeadBg = self:AddComponent(UIImage, playHeadBg_path)
  self.third = self:AddComponent(UIBaseContainer, third_path)
  self.second = self:AddComponent(UIBaseContainer, second_path)
  self.first = self:AddComponent(UIBaseContainer, first_path)
  self.numTxt = self:AddComponent(UIText, numTxt_path)
  self.Button = self:AddComponent(UIButton, Button_path)
  self.winTxt = self:AddComponent(UIText, winTxt_path)
  self.loseTxt = self:AddComponent(UIText, loseTxt_path)
  self.playerBtn = self:AddComponent(UIButton, playerBtn_path)
  self.promotion = self:AddComponent(UIBaseContainer, promotion_path)
end

local function ComponentDestroy(self)
  self.firstNameTxt = nil
  self.secondNameTxt = nil
  self.powerTxt = nil
  self.allianceIcon = nil
  self.playerFlag = nil
  self.playerIcon = nil
  self.third = nil
  self.second = nil
  self.first = nil
  self.numTxt = nil
  self.Button = nil
  self.winTxt = nil
  self.loseTxt = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshItem(self, rankInfo, rankIndex)
  self.rankInfo = rankInfo
  self.rank = rankIndex
  if self.rankInfo == nil then
    return
  end
  local allianceName = ""
  if not string.IsNullOrEmpty(self.rankInfo.abbr) then
    allianceName = allianceName .. "[" .. self.rankInfo.abbr .. "]"
  end
  self.firstNameTxt:SetText(self.rankInfo.name)
  self.secondNameTxt:SetText(allianceName)
  self.powerTxt:SetText(string.GetFormattedSeperatorNum(self.rankInfo.score))
  self.numTxt:SetText(self.rank)
  self.playerIcon.gameObject:SetActive(true)
  self.playerIcon:SetData(self.rankInfo.uid, self.rankInfo.pic, self.rankInfo.picver)
  self.playerBtn:SetOnClick(function()
    if self.rankInfo ~= nil and not string.IsNullOrEmpty(self.rankInfo.uid) then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self.view.ctrl:ShowPlayerInfo(self.rankInfo.uid)
    end
  end)
  local headFrame = 0
  if self.rankInfo.headFrame ~= nil then
    headFrame = self.rankInfo.headFrame
  end
  self.winTxt:SetText(self.rankInfo.winRound)
  self.loseTxt:SetText(self.rankInfo.loseRound)
  self.playerHeadBg:SetActive(headFrame == 1)
  self.first.gameObject:SetActive(false)
  self.second.gameObject:SetActive(false)
  self.third.gameObject:SetActive(false)
  self.numTxt.gameObject:SetActive(true)
  if self.rank == 1 then
    self.first.gameObject:SetActive(true)
    self.numTxt.gameObject:SetActive(false)
  elseif self.rank == 2 then
    self.second.gameObject:SetActive(true)
    self.numTxt.gameObject:SetActive(false)
  elseif self.rank == 3 then
    self.third.gameObject:SetActive(true)
    self.numTxt.gameObject:SetActive(false)
  end
  local isPromotion = false
  local info = DataCenter.ActChampionBattleManager:GetChampionBattleInfo()
  if info ~= nil then
    local curIndexState = info:GetCurState()
    if curIndexState == Activity_ChampionBattle_Stage_State.Strongest then
      if self.rank <= 4 then
        isPromotion = true
      elseif self.rank <= 8 and info ~= nil and info.serverId2 == info.serverId1 then
        isPromotion = true
      end
    end
  end
  self.promotion:SetActive(isPromotion)
end

UIChampionBattleRankCell.OnCreate = OnCreate
UIChampionBattleRankCell.OnDestroy = OnDestroy
UIChampionBattleRankCell.OnEnable = OnEnable
UIChampionBattleRankCell.OnDisable = OnDisable
UIChampionBattleRankCell.ComponentDefine = ComponentDefine
UIChampionBattleRankCell.ComponentDestroy = ComponentDestroy
UIChampionBattleRankCell.DataDefine = DataDefine
UIChampionBattleRankCell.DataDestroy = DataDestroy
UIChampionBattleRankCell.RefreshItem = RefreshItem
return UIChampionBattleRankCell
