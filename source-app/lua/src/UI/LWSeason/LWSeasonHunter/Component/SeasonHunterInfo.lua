local base = UIBaseContainer
local SeasonHunterInfo = BaseClass("SeasonHunterInfo", base)
local Localization = CS.GameEntry.Localization
local btnBg_path = "bg"
local memberText_path = "Content/memberRoot/memberText"
local killText_path = "Content/killRoot/killText"
local rankText_path = "Content/rankRoot/rankText"
local time_path = "time"
local outText_path = "Content/outRoot/outText"
local killRoot_path = "Content/killRoot"
local rankRoot_path = "Content/rankRoot"
local outRoot_path = "Content/outRoot"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnBg = self:AddComponent(UIButton, btnBg_path)
  self.memberText = self:AddComponent(UIText, memberText_path)
  self.killText = self:AddComponent(UIText, killText_path)
  self.rankText = self:AddComponent(UIText, rankText_path)
  self.time = self:AddComponent(UIText, time_path)
  self.outText = self:AddComponent(UIText, outText_path)
  self.killRoot = self:AddComponent(UIBaseContainer, killRoot_path)
  self.rankRoot = self:AddComponent(UIBaseContainer, rankRoot_path)
  self.outRoot = self:AddComponent(UIBaseContainer, outRoot_path)
  self.btnBg:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonHunterBattle)
  end)
end

local function ComponentDestroy(self)
  self.btnBg = nil
  self.memberText = nil
  self.killText = nil
  self.rankText = nil
  self.time = nil
  self.outText = nil
  self.killRoot = nil
  self.rankRoot = nil
  self.outRoot = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonHunterInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonHunterGetActivityInfo, self.Refresh)
  self:AddUIListener(EventId.SeasonHunterBattleInfo, self.Refresh)
end

function SeasonHunterInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonHunterGetActivityInfo, self.Refresh)
  self:RemoveUIListener(EventId.SeasonHunterBattleInfo, self.Refresh)
  base.OnRemoveListener(self)
end

function SeasonHunterInfo:Refresh()
  if not self.memberText then
    return
  end
  local battleInfo = DataCenter.SeasonHunterManager:GetActivityInfo()
  self.memberText:SetText(battleInfo.wolfNum or 0)
  self.endTime = battleInfo.endTime
  if DataCenter.SeasonHunterManager:IsInBattle() then
    self.requestActivityInfo = false
    self.killText:SetText(string.GetFormattedStr(math.floor(tonumber(battleInfo.score or 0))))
    self.rankText:SetText(battleInfo.matchRank or 0)
    self.killRoot:SetActive(true)
    self.rankRoot:SetActive(true)
    self.outRoot:SetActive(false)
  else
    self.requestActivityInfo = true
    self.outText:SetText(battleInfo.wolfNumOut or 0)
    self.killRoot:SetActive(false)
    self.rankRoot:SetActive(false)
    self.outRoot:SetActive(true)
  end
  self:Update1000MS()
end

function SeasonHunterInfo:Update1000MS()
  if self.requestActivityInfo then
    DataCenter.SeasonHunterManager:RequestActivityInfoByDelta()
  end
  if not self.endTime then
    return
  end
  if UIUtil.SetLeftTimeText(self.time, nil, self.endTime) then
    self.endTime = nil
    return
  end
end

SeasonHunterInfo.OnCreate = OnCreate
SeasonHunterInfo.OnDestroy = OnDestroy
SeasonHunterInfo.OnEnable = OnEnable
SeasonHunterInfo.OnDisable = OnDisable
SeasonHunterInfo.ComponentDefine = ComponentDefine
SeasonHunterInfo.ComponentDestroy = ComponentDestroy
SeasonHunterInfo.DataDefine = DataDefine
SeasonHunterInfo.DataDestroy = DataDestroy
return SeasonHunterInfo
