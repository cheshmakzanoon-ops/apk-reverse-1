local AlLeaderElectResult_Leader = BaseClass("AlLeaderElectResult_Leader", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local desc_path = "NameTxt"
local headIcon_path = "Image/UIPlayerHead/HeadIcon"
local headFg_path = "Image/UIPlayerHead/Foreground"
local name_path = "Image/name"
local power_path = "Image/power/power"
local votesTxt_path = "Image/vote"
local votesNum_path = "Image/vote/voteText"

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
  self.descN = self:AddComponent(UIText, desc_path)
  self.headIconN = self:AddComponent(UIPlayerHead, headIcon_path)
  self.headFgN = self:AddComponent(UIImage, headFg_path)
  self.nameN = self:AddComponent(UIText, name_path)
  self.powerN = self:AddComponent(UIText, power_path)
  self.votesTxtN = self:AddComponent(UIText, votesTxt_path)
  self.votesTxtN:SetLocalText(390929)
  self.votesNumN = self:AddComponent(UIText, votesNum_path)
end

local function ComponentDestroy(self)
  self.descN = nil
  self.headIconN = nil
  self.headFgN = nil
  self.nameN = nil
  self.powerN = nil
  self.votesTxtN = nil
  self.votesNumN = nil
end

local function DataDefine(self)
  self.leaderInfo = nil
end

local function DataDestroy(self)
  self.leaderInfo = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, leaderInfo)
  self.leaderInfo = leaderInfo
  self.descN:SetLocalText(390943, self.leaderInfo.name)
  self.headIconN:SetData(self.leaderInfo.uid, self.leaderInfo.pic, self.leaderInfo.picVer)
  local tempFg = self.leaderInfo:GetHeadBgImg()
  if tempFg then
    self.headFgN:SetActive(true)
    self.headFgN:LoadSprite(tempFg)
  else
    self.headFgN:SetActive(false)
  end
  self.nameN:SetText(self.leaderInfo.name)
  self.powerN:SetText(string.GetFormattedSeperatorNum(self.leaderInfo.power))
  self.votesNumN:SetText(self.leaderInfo.voteNum)
end

AlLeaderElectResult_Leader.OnCreate = OnCreate
AlLeaderElectResult_Leader.OnDestroy = OnDestroy
AlLeaderElectResult_Leader.OnEnable = OnEnable
AlLeaderElectResult_Leader.OnDisable = OnDisable
AlLeaderElectResult_Leader.ComponentDefine = ComponentDefine
AlLeaderElectResult_Leader.ComponentDestroy = ComponentDestroy
AlLeaderElectResult_Leader.DataDefine = DataDefine
AlLeaderElectResult_Leader.DataDestroy = DataDestroy
AlLeaderElectResult_Leader.OnAddListener = OnAddListener
AlLeaderElectResult_Leader.OnRemoveListener = OnRemoveListener
AlLeaderElectResult_Leader.SetItem = SetItem
return AlLeaderElectResult_Leader
