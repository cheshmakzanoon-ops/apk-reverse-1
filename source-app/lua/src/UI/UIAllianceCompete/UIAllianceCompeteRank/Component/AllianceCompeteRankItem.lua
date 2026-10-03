local AllianceCompeteRankItem = BaseClass("AllianceCompeteRankItem", UIBaseContainer)
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
local headBtn_path = "playerFlag/UIPlayerHead"

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
  self.headBtn = self:AddComponent(UIButton, headBtn_path)
  self.headBtn:SetOnClick(function()
    self:OnClickHeadIcon()
  end)
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
  self.firstNameTxt:SetText(self.rankInfo.name)
  self.powerTxt:SetText(string.GetFormattedStr(self.rankInfo.score))
  if self.rankInfo.abbr ~= nil then
    self.secondNameTxt:SetText("[" .. self.rankInfo.abbr .. "]" .. self.rankInfo.alName)
  else
    self.secondNameTxt:SetText("")
  end
  self.numTxt:SetText(self.rank)
  self.playerIcon.gameObject:SetActive(true)
  self.playerIcon:SetData(self.rankInfo.uid, self.rankInfo.pic, self.rankInfo.picVer)
  local serverTimeS = UITimeManager:GetInstance():GetServerSeconds()
  self.playerHeadBg:SetActive(false)
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
end

local function OnClickHeadIcon(self)
  if self.rankInfo.uid == LuaEntry.Player.uid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = true}, self.rankInfo.uid)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.rankInfo.uid)
  end
end

AllianceCompeteRankItem.OnCreate = OnCreate
AllianceCompeteRankItem.OnDestroy = OnDestroy
AllianceCompeteRankItem.OnEnable = OnEnable
AllianceCompeteRankItem.OnDisable = OnDisable
AllianceCompeteRankItem.ComponentDefine = ComponentDefine
AllianceCompeteRankItem.ComponentDestroy = ComponentDestroy
AllianceCompeteRankItem.DataDefine = DataDefine
AllianceCompeteRankItem.DataDestroy = DataDestroy
AllianceCompeteRankItem.RefreshItem = RefreshItem
AllianceCompeteRankItem.OnClickHeadIcon = OnClickHeadIcon
return AllianceCompeteRankItem
