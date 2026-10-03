local WorkerOverviewBuildingGroupDispatchCell = BaseClass("WorkerOverviewBuildingGroupDispatchCell", UIBaseContainer)
local base = UIBaseContainer
local WorkerOverviewBuildingDispatchCell = require("UI.UILWWorker.UIWorkerOverviewList.Component.WorkerOverviewBuildingDispatchCell")
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local info_txt_path = "infoTxt"
local worker_num_txt_path = "workerNumTxt"
local red_dot_path = "redDot"
local detail_btn_path = "DetailBtn"
local detail_open_img_path = "DetailBtn/detailOpenImg"
local building_list_path = "BuildingList"
local close_content_path = "CloseContent"
local OneCellH = 190

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.showData = nil
  self.itemH = 0
end

local function DataDestroy(self)
  self.showData = nil
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.info_txt = self:AddComponent(UITextMeshProUGUIEx, info_txt_path)
  self.worker_num_txt = self:AddComponent(UITextMeshProUGUIEx, worker_num_txt_path)
  self.red_dot = self:AddComponent(UIImage, red_dot_path)
  self.detail_btn = self:AddComponent(UIButton, detail_btn_path)
  self.detail_open_img = self:AddComponent(UIImage, detail_open_img_path)
  self.building_list = self:AddComponent(UILayoutElement, building_list_path)
  self.close_content = self:AddComponent(UIBaseContainer, close_content_path)
  self.detail_btn:SetOnClick(function()
    self:ClickOpenDetailBtn()
  end)
  self.itemList = {}
  self.itemReqs = {}
end

local function ComponentDestroy(self)
  self:ClearContent()
  self.info_txt = nil
  self.worker_num_txt = nil
  self.red_dot = nil
  self.detail_btn = nil
  self.detail_open_img = nil
  self.building_list = nil
  self.close_content = nil
  self.itemList = nil
  self.itemReqs = nil
end

local function ClearContent(self)
  if table.count(self.itemList) > 0 then
    self.building_list:RemoveComponents(WorkerOverviewBuildingDispatchCell)
    self.itemList = {}
  end
  if table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      req:Destroy()
    end
    self.itemReqs = {}
  end
end

local function RefreshItemView(self)
  if not table.IsNullOrEmpty(self.showData.dataList) then
    for i, data in pairs(self.showData.dataList) do
      if self.itemList[i] then
        self.itemList[i]:SetActive(true)
        self.itemList[i]:SetData(data, i, #self.showData.dataList)
      elseif self.itemReqs[i] == nil then
        local req = self:GameObjectInstantiateAsync(UIAssets.WorkerOverviewBuildingDispatchCell, function(req)
          if req == nil or IsNull(req.gameObject) then
            return
          end
          local item = req.gameObject
          item.name = "item" .. i
          item.transform:SetParent(self.building_list.transform)
          item.transform:Set_localScale(1, 1, 1)
          local cell = self.building_list:AddComponent(WorkerOverviewBuildingDispatchCell, item.name)
          self.itemList[i] = cell
          if i > #self.showData.dataList then
            self.itemList[i]:SetActive(false)
          else
            self.itemList[i]:SetActive(true)
            local data = self.showData.dataList[i]
            self.itemList[i]:SetData(data, i, #self.showData.dataList)
          end
        end)
        self.itemReqs[i] = req
      end
    end
    for i, _ in pairs(self.itemList) do
      if i > #self.showData.dataList then
        self.itemList[i]:SetActive(false)
      end
    end
  end
end

local function SetData(self, showData, scroll_view, index)
  self.showData = showData
  self.scroll_view = scroll_view
  self.index = index
  local buildingName = Localization:GetString(self.showData.buildTemplate.name)
  self.info_txt:SetText(buildingName)
  self:RefreshWorkerNum()
  self:RefreshRedDot()
  self:RefreshDetailContent()
end

local function RefreshWorkerNum(self)
  local totalNum = 0
  local curNum = 0
  for _, data in ipairs(self.showData.dataList) do
    totalNum = totalNum + data.maxLvTemp.hero_slots
    for _, trenchData in ipairs(data.trenchDataList) do
      if trenchData.type == BuildDisPatchingHeroTrenchState.HERO then
        curNum = curNum + 1
      end
    end
  end
  self.worker_num_txt:SetLocalText("worker_hall_desc8", curNum, totalNum)
end

local function RefreshRedDot(self)
  local isOn = false
  for _, data in ipairs(self.showData.dataList) do
    local curIsOn = data.data:CheckBuildingWorkerRedDot()
    if curIsOn then
      isOn = true
      break
    end
  end
  if isOn == false then
    for _, data in ipairs(self.showData.dataList) do
      for _, trenchData in ipairs(data.trenchDataList) do
        if trenchData.type == BuildDisPatchingHeroTrenchState.HERO then
          local isRankEnough = false
          local workerData = trenchData.workerData
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
          if isRankEnough then
            isOn = true
            break
          end
        end
      end
      if isOn then
        break
      end
    end
  end
  self.red_dot:SetActive(isOn)
end

local function RefreshDetailContent(self)
  if self.showData.isOpenDetail then
    self.detail_open_img:LoadSprite(string.format(LoadPath.UIWorkerSpritePath, "Mjc_tongyong_bt_xiao_shang"))
    self.close_content:SetActive(false)
    self.building_list:SetActive(true)
    local listNum = #self.showData.dataList
    local contentHeight = listNum * OneCellH
    self.itemH = contentHeight
    self.building_list:SetMinHeight(contentHeight)
    self.building_list:SetPreferredHeight(contentHeight)
    self:RefreshItemView()
  else
    self.detail_open_img:LoadSprite(string.format(LoadPath.UIWorkerSpritePath, "Mjc_tongyong_bt_xiao_xia"))
    self.close_content:SetActive(true)
    self.building_list:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
  self.scroll_view:OnItemSizeChanged(self.index)
end

local function ClickOpenDetailBtn(self)
  self.showData.isOpenDetail = not self.showData.isOpenDetail
  self:RefreshDetailContent()
end

local function RecordCurVal(self)
  for k, v in pairs(self.itemList) do
    if v:GetActive() then
      v:RecordCurVal()
    end
  end
end

local function TryPlayAni(self)
  for k, v in pairs(self.itemList) do
    if v:GetActive() then
      v:TryPlayAni()
    end
  end
end

WorkerOverviewBuildingGroupDispatchCell.OnCreate = OnCreate
WorkerOverviewBuildingGroupDispatchCell.OnDestroy = OnDestroy
WorkerOverviewBuildingGroupDispatchCell.DataDefine = DataDefine
WorkerOverviewBuildingGroupDispatchCell.DataDestroy = DataDestroy
WorkerOverviewBuildingGroupDispatchCell.ComponentDefine = ComponentDefine
WorkerOverviewBuildingGroupDispatchCell.ComponentDestroy = ComponentDestroy
WorkerOverviewBuildingGroupDispatchCell.SetData = SetData
WorkerOverviewBuildingGroupDispatchCell.ClickOpenDetailBtn = ClickOpenDetailBtn
WorkerOverviewBuildingGroupDispatchCell.RefreshWorkerNum = RefreshWorkerNum
WorkerOverviewBuildingGroupDispatchCell.RefreshRedDot = RefreshRedDot
WorkerOverviewBuildingGroupDispatchCell.RefreshDetailContent = RefreshDetailContent
WorkerOverviewBuildingGroupDispatchCell.ClearContent = ClearContent
WorkerOverviewBuildingGroupDispatchCell.RefreshItemView = RefreshItemView
WorkerOverviewBuildingGroupDispatchCell.RecordCurVal = RecordCurVal
WorkerOverviewBuildingGroupDispatchCell.TryPlayAni = TryPlayAni
return WorkerOverviewBuildingGroupDispatchCell
