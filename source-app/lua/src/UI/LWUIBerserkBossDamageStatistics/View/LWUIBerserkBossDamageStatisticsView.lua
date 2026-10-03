local base = UIBaseView
local LWUIBerserkBossDamageStatisticsView = BaseClass("LWUIBerserkBossDamageStatisticsView", base)
local LWUIBerserkBossDamageStatisticsItemRender = require("UI.LWUIBerserkBossDamageStatistics.Component.LWUIBerserkBossDamageStatisticsItemRender")
local panelBtn_path = "panel"
local titleText_path = "PopUpContent/TitleText"
local closeBtn_path = "PopUpContent/CloseBtn"
local playerHeadObj_path = "PopUpContent/UIPlayerHead"
local nameText_path = "PopUpContent/NameText"
local powerText_path = "PopUpContent/PowerText"
local rankText_path = "PopUpContent/RankText"
local damageStatisticsContent_path = "PopUpContent/DamageStatisticsContent"
local damageStatisticsItem_path = "PopUpContent/LWUIBerserkBossDamageStatisticsItemRender"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.playerRankInfo = self:GetUserData()
  self:ReInit()
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
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.playerHeadObj = self:AddComponent(UIBaseContainer, playerHeadObj_path)
  self.nameText = self:AddComponent(UIText, nameText_path)
  self.powerText = self:AddComponent(UIText, powerText_path)
  self.rankText = self:AddComponent(UIText, rankText_path)
  self.damageStatisticsContent = self:AddComponent(UIBaseContainer, damageStatisticsContent_path)
  self.damageStatisticsItem = self:AddComponent(UIBaseContainer, damageStatisticsItem_path)
  self.titleText:SetLocalText("activity_berserkboss_title_09")
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.playerHeadView = self:AddComponent(UICommonHead, playerHeadObj_path)
  self.damageStatisticsItemObj = self.transform:Find(damageStatisticsItem_path).gameObject
  self.damageStatisticsItemObj:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.titleText = nil
  self.closeBtn = nil
  self.playerHeadObj = nil
  self.nameText = nil
  self.powerText = nil
  self.rankText = nil
  self.damageStatisticsContent = nil
  self.damageStatisticsItem = nil
  self.playerHeadView = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetBerserkBossPersonalDamageStatisticalData, self.OnGetBerserkBossPersonalDamageStatisticalData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetBerserkBossPersonalDamageStatisticalData, self.OnGetBerserkBossPersonalDamageStatisticalData)
  base.OnRemoveListener(self)
end

local function OnGetBerserkBossPersonalDamageStatisticalData(self, data)
  if self.playerRankInfo ~= nil and self.playerRankInfo.uid == data.playerUid then
    self:RefreshShowDamageStatistics(data)
  end
end

local function ReInit(self)
  if self.playerRankInfo ~= nil then
    DataCenter.LWBerserkBossManager:RequestBerserkBossUserDamageStatistics(self.playerRankInfo.uid)
    self.rankText:SetLocalText("activity_berserkboss_title_10", self.playerRankInfo.rank)
    if self.playerRankInfo.uid == LuaEntry.Player.uid then
      self.nameText:SetText(LuaEntry.Player:GetFullName())
      self.powerText:SetText(string.GetFormattedSeperatorNum(LuaEntry.Player.power))
      local userPic = LuaEntry.Player:GetPic() or ""
      local userPicVer = LuaEntry.Player.picVer or 0
      self.playerHeadView:SetData(LuaEntry.Player:GetUid(), userPic, userPicVer, nil, LuaEntry.Player:GetHeadBgImg())
    else
      self.nameText:SetText("[" .. self.playerRankInfo.alAbbr .. "] " .. self.playerRankInfo.name)
      self.powerText:SetText(string.GetFormattedSeperatorNum(self.playerRankInfo.power))
      self.playerHeadView:SetData(self.playerRankInfo.uid, self.playerRankInfo.pic, self.playerRankInfo.picVer, nil, self.playerRankInfo:GetHeadBgImg())
    end
  end
end

local function RefreshShowDamageStatistics(self, data)
  self:ClearDamageStatisticsCells()
  local dataCount = table.count(data.damagesList)
  for i = 1, dataCount do
    local damageData = data.damagesList[i]
    local go = self.damageStatisticsItemObj:GameObjectSpawn(self.damageStatisticsContent.transform)
    go.name = "item_" .. i
    go:SetActive(true)
    local itemRender = self.damageStatisticsContent:AddComponent(LWUIBerserkBossDamageStatisticsItemRender, go.name)
    itemRender:InitData(i, damageData)
  end
end

local function ClearDamageStatisticsCells(self)
  self.damageStatisticsContent:RemoveComponents(LWUIBerserkBossDamageStatisticsItemRender)
  self.damageStatisticsItemObj:GameObjectRecycleAll()
end

LWUIBerserkBossDamageStatisticsView.OnCreate = OnCreate
LWUIBerserkBossDamageStatisticsView.OnDestroy = OnDestroy
LWUIBerserkBossDamageStatisticsView.OnEnable = OnEnable
LWUIBerserkBossDamageStatisticsView.OnDisable = OnDisable
LWUIBerserkBossDamageStatisticsView.ComponentDefine = ComponentDefine
LWUIBerserkBossDamageStatisticsView.ComponentDestroy = ComponentDestroy
LWUIBerserkBossDamageStatisticsView.DataDefine = DataDefine
LWUIBerserkBossDamageStatisticsView.DataDestroy = DataDestroy
LWUIBerserkBossDamageStatisticsView.OnAddListener = OnAddListener
LWUIBerserkBossDamageStatisticsView.OnRemoveListener = OnRemoveListener
LWUIBerserkBossDamageStatisticsView.OnGetBerserkBossPersonalDamageStatisticalData = OnGetBerserkBossPersonalDamageStatisticalData
LWUIBerserkBossDamageStatisticsView.ReInit = ReInit
LWUIBerserkBossDamageStatisticsView.RefreshShowDamageStatistics = RefreshShowDamageStatistics
LWUIBerserkBossDamageStatisticsView.ClearDamageStatisticsCells = ClearDamageStatisticsCells
return LWUIBerserkBossDamageStatisticsView
