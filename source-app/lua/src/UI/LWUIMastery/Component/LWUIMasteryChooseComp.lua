local LWUIMasteryChooseComp = BaseClass("LWUIMasteryChooseComp", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWUIMasteryChooseCompItem = require("UI.LWUIMastery.Component.LWUIMasteryChooseCompItem")
local ChooseCompSkillCell = require("UI.LWUIMastery.Component.ChooseCompSkillCell")
local masteryItemContent_path = "MasteryItemContent"
local masteryInfoContent_path = "MasteryInfoContent"
local homeItem_path = "MasteryItemContent/home"
local masteryDesTxt_path = "MasteryInfoContent/MasteryInfo/desTxt"
local skillTitleTxt_path = "MasteryInfoContent/MasteryInfo/skillTitleTxt"
local skillScroll_path = "MasteryInfoContent/MasteryInfo/skillListContent/skillScroll"
local selectBtn_path = "MasteryInfoContent/MasterySelect/selectBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.masteryItemContent = self:AddComponent(UIBaseContainer, masteryItemContent_path)
  self.masteryInfoContent = self:AddComponent(UIBaseContainer, masteryInfoContent_path)
  self.homeItems = {}
  for i = 1, 3 do
    local itemPath = homeItem_path .. i
    local homeId = MasteryHomeShowList[i]
    local homeItem = self:AddComponent(LWUIMasteryChooseCompItem, itemPath)
    homeItem:SetData(homeId, 0, function(homeId)
      self:OnMasteryItemClick(homeId)
    end)
    self.homeItems[i] = homeItem
  end
  self.masteryDesTxt = self:AddComponent(UIText, masteryDesTxt_path)
  self.skillTitleTxt = self:AddComponent(UIText, skillTitleTxt_path)
  self.skillScroll = self:AddComponent(UIScrollView, skillScroll_path)
  self.skillScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.skillScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.selectBtn = self:AddComponent(UIButton, selectBtn_path)
  self.selectBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSelectBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.masteryItemContent = nil
  self.homeItems = nil
  self.masteryInfoContent = nil
  self.masteryDesTxt = nil
  self.skillScroll = nil
  self.selectBtn = nil
end

local function DataDefine(self)
  self.selectHomeId = 0
end

local function DataDestroy(self)
  self.selectHomeId = nil
end

local function ReInit(self)
  self:Refresh()
  local plotId = 2080
  if SeasonUtil.IsNewS1() then
    plotId = LuaEntry.DataConfig:TryGetNum("mastery_newbie", "k5", 2080)
  end
  EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotId, hideMainUI = false})
end

local function Refresh(self)
  self:RefreshItemContent()
  self:RefreshInfoContent()
end

local function RefreshItemContent(self)
  for _, item in pairs(self.homeItems) do
    item:SetSelectData(self.selectHomeId)
  end
end

local function RefreshInfoContent(self)
  if self.selectHomeId == 0 then
    self.masteryInfoContent:SetActive(false)
  else
    local showTemp = DataCenter.MasteryManager:GetHomeShowTempByHomeId(self.selectHomeId)
    self.masteryInfoContent:SetActive(true)
    self.masteryDesTxt:SetLocalText(showTemp.description)
    self.skillList = showTemp.link_skill
    self.skillScroll:SetTotalCount(#self.skillList)
    self.skillScroll:RefillCells()
  end
end

local function OnMasteryItemClick(self, homeId)
  if self.selectHomeId == homeId then
    return
  end
  local showTemp = DataCenter.MasteryManager:GetHomeShowTempByHomeId(homeId)
  if not showTemp.lock then
    self.selectHomeId = homeId
    self:Refresh()
  else
    UIUtil.ShowTipsId("season_mastery_104")
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.skillScroll:AddComponent(ChooseCompSkillCell, itemObj)
  local id = self.skillList[index]
  cellItem:SetData(id)
end

local function OnItemMoveOut(self, itemObj, index)
  self.skillScroll:RemoveComponent(itemObj.name, ChooseCompSkillCell)
end

local function OnSelectBtnClick(self)
  if self.selectHomeId == 0 then
    return
  end
  local showTemp = DataCenter.MasteryManager:GetHomeShowTempByHomeId(self.selectHomeId)
  local name = Localization:GetString(showTemp.name)
  local str = Localization:GetString("season_mastery_161", name)
  if SeasonUtil.IsNewS1() then
    local masteryLevel = DataCenter.MasteryManager:GetData().level
    local k4 = LuaEntry.DataConfig:TryGetNum("mastery_newbie", "k4", 10)
    if masteryLevel < k4 then
      str = Localization:GetString("season_mastery_S1_2025_tips1", name)
    end
  end
  UIUtil.ShowSecondMessage(Localization:GetString("season_mastery_007"), str, 2, "", "", function()
    SFSNetwork.SendMessage(MsgDefines.LwSeasonMasteryHomeChange, self.selectHomeId, 0)
  end, nil, nil, nil, nil, nil, nil, nil, nil, false)
end

LWUIMasteryChooseComp.OnCreate = OnCreate
LWUIMasteryChooseComp.OnDestroy = OnDestroy
LWUIMasteryChooseComp.ComponentDefine = ComponentDefine
LWUIMasteryChooseComp.ComponentDestroy = ComponentDestroy
LWUIMasteryChooseComp.DataDefine = DataDefine
LWUIMasteryChooseComp.DataDestroy = DataDestroy
LWUIMasteryChooseComp.ReInit = ReInit
LWUIMasteryChooseComp.Refresh = Refresh
LWUIMasteryChooseComp.RefreshItemContent = RefreshItemContent
LWUIMasteryChooseComp.RefreshInfoContent = RefreshInfoContent
LWUIMasteryChooseComp.OnMasteryItemClick = OnMasteryItemClick
LWUIMasteryChooseComp.OnItemMoveIn = OnItemMoveIn
LWUIMasteryChooseComp.OnItemMoveOut = OnItemMoveOut
LWUIMasteryChooseComp.OnSelectBtnClick = OnSelectBtnClick
return LWUIMasteryChooseComp
