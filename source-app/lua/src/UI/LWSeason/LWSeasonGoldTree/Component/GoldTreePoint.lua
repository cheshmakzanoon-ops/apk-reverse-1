local base = UIAsyncContainer
local GoldTreePoint = BaseClass("GoldTreePoint", base)
local GoldTreeChargeItem = require("UI.LWSeason.LWSeasonGoldTree.Component.GoldTreeChargeItem")
local GoldTreePrayDetail = require("UI.LWSeason.LWSeasonGoldTree.Component.GoldTreePrayDetail")
local rankRoot_path = "bg/rankRoot"
local btnRank_path = "bg/rankRoot/rankBtn"
local btnReward_path = "bg/rankRoot/rewardBtn"
local rankScrollView_path = "bg/rankRoot/rankScrollView"
local txtEmpty_path = "bg/rankRoot/rankScrollView/txtEmpty"
local chargeProgress_path = "bg/rankRoot/chargeProgress"
local txtProgress_path = "bg/rankRoot/chargeProgress/Txtprogress"
local announceRoot_path = "bg/announceRoot"
local btnInfo_path = "bg/announceRoot/info"
local goldTreePrizeDetail_path = "bg/announceRoot/GoldTreePrayDetail"
local txtTime_path = "bg/announceRoot/Txt_Times"
local txtPrizeTips_path = "bg/announceRoot/Txt_PrizeTips"
local scrollDesc_path = "bg/announceRoot/ScrollViewDesc"
local cityDesc_path = "bg/announceRoot/ScrollViewDesc/Viewport/Content/Desc"

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
  self.rankRoot = self:AddComponent(UIBaseContainer, rankRoot_path)
  self.btnRank = self:AddComponent(UIButton, btnRank_path)
  self.btnReward = self:AddComponent(UIButton, btnReward_path)
  self.rankScrollView = self:AddComponent(UIScrollView, rankScrollView_path)
  self.txtEmpty = self:AddComponent(UIText, txtEmpty_path)
  self.chargeProgress = self:AddComponent(UISlider, chargeProgress_path)
  self.txtProgress = self:AddComponent(UIText, txtProgress_path)
  self.announceRoot = self:AddComponent(UIBaseContainer, announceRoot_path)
  self.btnInfo = self:AddComponent(UIButton, btnInfo_path)
  self.goldTreePrizeDetail = self:AddComponent(UIBaseContainer, goldTreePrizeDetail_path)
  self.txtTime = self:AddComponent(UIText, txtTime_path)
  self.txtPrizeTips = self:AddComponent(UIText, txtPrizeTips_path)
  self.scrollDesc = self:AddComponent(UIScrollRect, scrollDesc_path)
  self.cityDesc = self:AddComponent(UIText, cityDesc_path)
  self.btnRank:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.GoldTreeRank, {anim = true}, self.data.serverId, self.data.cityId)
  end)
  self.btnReward:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.GoldTreeReward)
  end)
  self.btnInfo:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.GoldTreeRule)
  end)
  self.rankScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.rankScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.goldTreePrayDetail = self:AddComponent(GoldTreePrayDetail, goldTreePrizeDetail_path)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.rankRoot = nil
  self.btnRank = nil
  self.btnReward = nil
  self.rankScrollView = nil
  self.txtEmpty = nil
  self.chargeProgress = nil
  self.txtProgress = nil
  self.announceRoot = nil
  self.btnInfo = nil
  self.goldTreePrizeDetail = nil
  self.txtTime = nil
  self.txtPrizeTips = nil
  self.scrollDesc = nil
  self.cityDesc = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function GoldTreePoint:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonGoldTreeInfo, self.UpdateData)
  self:AddUIListener(EventId.GoldTreePowerRank, self.UpdateData)
  self:AddUIListener(EventId.GoldTreeAnnouncement, self.UpdateData)
end

function GoldTreePoint:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonGoldTreeInfo, self.UpdateData)
  self:RemoveUIListener(EventId.GoldTreePowerRank, self.UpdateData)
  self:RemoveUIListener(EventId.GoldTreeAnnouncement, self.UpdateData)
  base.OnRemoveListener(self)
end

function GoldTreePoint:ReInit(data)
  self.data = data
  if not self.data then
    return
  end
  self.pointInfo = CS.SceneManager.World:GetPointInfo(self.data.pointId)
  if not self.pointInfo then
    return
  end
  self.info = SeasonUtil.TryParseAllianceCityPointInfo(self.pointInfo.PointType, self.pointInfo.extraInfo)
  self.isCharge = not self.info or not self.info.finishTime or self.info.finishTime <= 0
  self:UpdateData()
end

function GoldTreePoint:UpdateData()
  if not self.data or IsNull(self.gameObject) then
    return
  end
  if self.isCharge then
    self.announceRoot:SetActive(false)
    self.rankRoot:SetActive(true)
    self:RefreshRank()
  else
    self.announceRoot:SetActive(true)
    self.rankRoot:SetActive(false)
    self:RefreshAnnounce()
  end
  self:Update1000MS()
end

function GoldTreePoint:RefreshRank()
  local rankData = DataCenter.SeasonGoldTreeManager.rankData
  if not rankData then
    return
  end
  self.showDatalist = rankData.ranks or {}
  self.rankScrollView:SetTotalCount(#self.showDatalist)
  self.rankScrollView:RefillCells()
  self.txtEmpty:SetActive(#self.showDatalist == 0)
end

function GoldTreePoint:RefreshAnnounce()
  self.EndTime = LuaEntry.Player:IsInSourceServer() and DataCenter.SeasonGoldTreeManager:GetNextPrayTime()
  if not self.EndTime then
    self.txtPrizeTips:SetActive(false)
    self.txtTime:SetActive(false)
  elseif self.EndTime == 0 then
    self.EndTime = nil
    self.txtPrizeTips:SetActive(true)
    self.txtTime:SetActive(false)
  else
    self.txtPrizeTips:SetActive(false)
    self.txtTime:SetActive(true)
  end
  local data = DataCenter.SeasonGoldTreeManager.announceMap[-1]
  local announceArr = data and data.announceArr
  local isEmpty = true
  if announceArr then
    for i, v in ipairs(announceArr) do
      if not v:IsEmpty() then
        isEmpty = false
        break
      end
    end
  end
  if isEmpty then
    self.btnInfo:SetActive(false)
    self.goldTreePrayDetail:SetActive(false)
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.data.cityId, self.data.serverId)
    self.cityDesc:SetLocalText(cityTemplate.desc)
    self.scrollDesc:SetActive(true)
  else
    self.btnInfo:SetActive(true)
    self.goldTreePrayDetail:RefreshView(data)
    self.goldTreePrayDetail:SetActive(true)
    self.scrollDesc:SetActive(false)
  end
end

function GoldTreePoint:Update1000MS()
  if IsNull(self.gameObject) then
    return
  end
  if self.isCharge then
    self:RefreshProgress()
  elseif self.EndTime and self:RefreshTime() then
    self:RefreshAnnounce()
  end
end

function GoldTreePoint:RefreshProgress()
  self.pointInfo = CS.SceneManager.World:GetPointInfo(self.data.pointId)
  if not self.pointInfo then
    return
  end
  self.info = SeasonUtil.TryParseAllianceCityPointInfo(self.pointInfo.PointType, self.pointInfo.extraInfo)
  if not self.info then
    return
  end
  local cur = self.info.power or 0
  local max = self.data.meta and self.data.meta.battery or 1
  local progress = cur / max
  self.chargeProgress:SetValue(progress)
  self.txtProgress:SetText(string.format("%s%%", math.floor(progress * 10000) * 0.01))
end

function GoldTreePoint:RefreshTime()
  return UIUtil.SetLeftTimeText(self.txtTime, nil, self.EndTime)
end

function GoldTreePoint:ClearScroll()
  self.rankScrollView:ClearCells()
  self.rankScrollView:RemoveComponents(GoldTreeChargeItem)
  self.showDatalist = {}
end

function GoldTreePoint:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.rankScrollView:AddComponent(GoldTreeChargeItem, itemObj)
  cellItem:SetData(self.showDatalist[index], index)
end

function GoldTreePoint:OnItemMoveOut(itemObj, index)
  self.rankScrollView:RemoveComponent(itemObj.name, GoldTreeChargeItem)
end

GoldTreePoint.OnCreate = OnCreate
GoldTreePoint.OnDestroy = OnDestroy
GoldTreePoint.OnEnable = OnEnable
GoldTreePoint.OnDisable = OnDisable
GoldTreePoint.ComponentDefine = ComponentDefine
GoldTreePoint.ComponentDestroy = ComponentDestroy
GoldTreePoint.DataDefine = DataDefine
GoldTreePoint.DataDestroy = DataDestroy
return GoldTreePoint
