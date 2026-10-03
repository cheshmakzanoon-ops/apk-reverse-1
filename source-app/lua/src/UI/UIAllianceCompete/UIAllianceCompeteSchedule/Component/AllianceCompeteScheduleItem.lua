local AllianceCompeteScheduleItem = BaseClass("AllianceCompeteScheduleItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg1Img_path = "bg1Img"
local bg2Img_path = "bg2Img"
local bg3Img_path = "bg3Img"
local dayTxt_path = "dayTxt"
local memberTxt_path = "memeberTxt"
local scoreTxt_path = "scoreTxt"
local victoryTxt_path = "victoryTxt"
local failureTxt_path = "failureTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self.bg1Img = self:AddComponent(UIImage, bg1Img_path)
  self.bg2Img = self:AddComponent(UIImage, bg2Img_path)
  self.bg3Img = self:AddComponent(UIImage, bg3Img_path)
  self.dayTxt = self:AddComponent(UIText, dayTxt_path)
  self.memberTxt = self:AddComponent(UIText, memberTxt_path)
  self.scoreTxt = self:AddComponent(UIText, scoreTxt_path)
  self.victoryTxt = self:AddComponent(UIText, victoryTxt_path)
  self.failureTxt = self:AddComponent(UIText, failureTxt_path)
end

local function OnDestroy(self)
  self.bg1Img = nil
  self.bg2Img = nil
  self.bg3Img = nil
  self.dayTxt = nil
  self.memberTxt = nil
  self.scoreTxt = nil
  self.victoryTxt = nil
  self.failureTxt = nil
  base.OnDestroy(self)
end

local function RefreshData(self, data, index, curIndex, forceShowReuslt)
  if 0 < curIndex and index == curIndex then
    self.bg3Img:SetActive(true)
    self.bg1Img:SetActive(false)
    self.bg2Img:SetActive(false)
  else
    local fd = math.fmod(index, 2)
    self.bg3Img:SetActive(false)
    if fd == 1 then
      self.bg1Img:SetActive(true)
      self.bg2Img:SetActive(false)
    else
      self.bg1Img:SetActive(false)
      self.bg2Img:SetActive(true)
    end
  end
  self.dayTxt:SetLocalText(372099, index)
  self.memberTxt:SetLocalText(data.name)
  if data.score ~= nil then
    local scoreStr = string.GetFormattedSeperatorNum(data.score)
    self.scoreTxt:SetText(scoreStr)
  else
    self.scoreTxt:SetText("0")
  end
  self.victoryTxt:SetLocalText(390186)
  self.failureTxt:SetLocalText(390187)
  if data.isWin ~= nil then
    if data.isWin == 1 then
      self.victoryTxt:SetActive(true)
      self.failureTxt:SetActive(false)
    else
      self.victoryTxt:SetActive(false)
      self.failureTxt:SetActive(true)
    end
  else
    self.failureTxt:SetActive(forceShowReuslt and true or false)
    self.victoryTxt:SetActive(false)
  end
end

AllianceCompeteScheduleItem.OnCreate = OnCreate
AllianceCompeteScheduleItem.OnDestroy = OnDestroy
AllianceCompeteScheduleItem.RefreshData = RefreshData
return AllianceCompeteScheduleItem
