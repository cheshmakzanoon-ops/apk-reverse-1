local WorkerOverviewBuildingDispatchCell = BaseClass("WorkerOverviewBuildingDispatchCell", UIBaseContainer)
local base = UIBaseContainer
local UIWorkerShowCell = require("UI.UILWWorker.UIWorkerOverviewList.Component.UIWorkerShowCell")
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local soltShowCount = 4
local btn_path = "Btn"
local line_path = "Line"
local btn_red_path = "Btn/btnRed"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:CloseAniSeq()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.showData = nil
  self.index = nil
  self.totalNum = nil
  self.aniSeq = nil
  self.recordVal = nil
end

local function DataDestroy(self)
  self.showData = nil
  self.index = nil
  self.totalNum = nil
  self.aniSeq = nil
  self.recordVal = nil
end

local function ComponentDefine(self)
  self.buildingIcon = self:AddComponent(UIImage, "buildingIcon")
  self.buildLv = self:AddComponent(UIText, "buildLv")
  self.soltItems = {}
  for i = 1, soltShowCount do
    local soltItem = self:AddComponent(UIButton, "soltContent/soltItem" .. i)
    soltItem:SetOnClick(function()
      self:ClickSoltItem(i)
    end)
    self.soltItems[i] = {
      root = soltItem,
      uiWorkerShowCell = soltItem:AddComponent(UIWorkerShowCell, "UIWorkerShowCell"),
      uiEmptyCell = soltItem:AddComponent(UIBaseContainer, "UIEmptyCell"),
      redPoint = soltItem:AddComponent(UIBaseContainer, "redPoint"),
      arrowImg = soltItem:AddComponent(UIImage, "arrowImg")
    }
  end
  self.btn = self:AddComponent(UIButton, btn_path)
  self.line = self:AddComponent(UIImage, line_path)
  self.btn:SetOnClick(function()
    self:ClickBtn()
  end)
  self.btn_red = self:AddComponent(UIImage, btn_red_path)
end

local function ComponentDestroy(self)
  self.buildingIcon = nil
  self.infoTxt = nil
  self.soltItems = nil
  self.btn = nil
  self.line = nil
  self.btn_red = nil
end

local function SetData(self, showData, index, totalNum)
  self.showData = showData
  self.index = index
  self.totalNum = totalNum
  self:CloseAniSeq()
  self.buildingIcon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.showData.data.itemId, 1))
  local lvTxt = Localization:GetString(GameDialogDefine.LEVEL_NUMBER, self.showData.data.level)
  self.buildLv:SetText(lvTxt)
  for i = 1, soltShowCount do
    local data = self.showData.trenchDataList[i]
    local soltItem = self.soltItems[i]
    if data == nil then
      soltItem.root:SetActive(false)
    elseif data.type == BuildDisPatchingHeroTrenchState.LOCK then
      soltItem.root:SetActive(false)
    elseif data.type == BuildDisPatchingHeroTrenchState.ADD then
      soltItem.root:SetActive(true)
      soltItem.uiWorkerShowCell:SetActive(false)
      soltItem.uiEmptyCell:SetActive(true)
      local isOn = self.showData.data:CheckBuildingWorkerSlotRedDot(i)
      soltItem.redPoint:SetActive(isOn)
      soltItem.arrowImg:SetActive(false)
    elseif data.type == BuildDisPatchingHeroTrenchState.HERO then
      soltItem.root:SetActive(true)
      soltItem.uiWorkerShowCell:SetActive(true)
      soltItem.uiEmptyCell:SetActive(false)
      soltItem.uiWorkerShowCell:SetData(data.workerData.cfgId, data.workerData.rank)
      local isOn = self.showData.data:CheckBuildingWorkerSlotRedDot(i)
      soltItem.redPoint:SetActive(isOn)
      local isRankEnough = false
      local workerData = data.workerData
      if workerData.star > 0 then
        local rankBaseTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(workerData.cfgId, 1)
        local maxRank = rankBaseTemp.max_rank
        if maxRank > workerData.rank then
          local nextRankTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(workerData.cfgId, workerData.rank + 1)
          local goodsData = nextRankTemp.rank_goods_data
          if 0 < #goodsData then
            isRankEnough = true
            for _, data in ipairs(goodsData) do
              local goodsId = data[1]
              local goodsNum = data[2] or 0
              local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
              if goodsNum > curNum then
                isRankEnough = false
                break
              end
            end
          end
        end
      end
      soltItem.arrowImg:SetActive(isRankEnough)
    end
  end
  self.line:SetActive(self.index < self.totalNum)
  local isBtnRed = self.showData.data:CheckBuildingWorkerRedDot()
  self.btn_red:SetActive(isBtnRed)
end

local function ClickSoltItem(self, index)
  local data = self.showData.trenchDataList[index]
  if data == nil then
    return
  end
  if data.type == BuildDisPatchingHeroTrenchState.ADD then
    UIUtil.OpenLWUIBuildDetailsView(tostring(self.showData.data.pointId))
  elseif data.type == BuildDisPatchingHeroTrenchState.HERO then
    local workerCfgId = data.workerData.cfgId
    local workerData = data.workerData
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerInfoDetail, {anim = true}, workerCfgId, workerData)
  end
end

local function ClickBtn(self)
  UIUtil.OpenLWUIBuildDetailsView(tostring(self.showData.data.pointId))
end

local function CloseAniSeq(self)
  if self.aniSeq ~= nil then
    self.aniSeq:Kill()
    self.aniSeq = nil
  end
end

local function RecordCurVal(self)
  self.recordVal = {}
  for i = 1, soltShowCount do
    local data = self.showData.trenchDataList[i]
    if data and data.type == BuildDisPatchingHeroTrenchState.HERO then
      self.recordVal[i] = data.workerData.uid
    end
  end
end

local function TryPlayAni(self)
  self.aniSeq = DOTween.Sequence()
  for i = 1, soltShowCount do
    local data = self.showData.trenchDataList[i]
    if data and data.type == BuildDisPatchingHeroTrenchState.HERO and self.recordVal[i] ~= data.workerData.uid then
      local delayTime = 0.1
      self.soltItems[i].root:SetActive(false)
      self.aniSeq:AppendInterval(delayTime)
      self.aniSeq:AppendCallback(function()
        self.soltItems[i].root:SetActive(true)
      end)
      break
    end
  end
  self.aniSeq:OnComplete(function()
    self:CloseAniSeq()
  end)
end

WorkerOverviewBuildingDispatchCell.OnCreate = OnCreate
WorkerOverviewBuildingDispatchCell.OnDestroy = OnDestroy
WorkerOverviewBuildingDispatchCell.DataDefine = DataDefine
WorkerOverviewBuildingDispatchCell.DataDestroy = DataDestroy
WorkerOverviewBuildingDispatchCell.ComponentDefine = ComponentDefine
WorkerOverviewBuildingDispatchCell.ComponentDestroy = ComponentDestroy
WorkerOverviewBuildingDispatchCell.SetData = SetData
WorkerOverviewBuildingDispatchCell.ClickSoltItem = ClickSoltItem
WorkerOverviewBuildingDispatchCell.ClickBtn = ClickBtn
WorkerOverviewBuildingDispatchCell.RecordCurVal = RecordCurVal
WorkerOverviewBuildingDispatchCell.TryPlayAni = TryPlayAni
WorkerOverviewBuildingDispatchCell.CloseAniSeq = CloseAniSeq
return WorkerOverviewBuildingDispatchCell
