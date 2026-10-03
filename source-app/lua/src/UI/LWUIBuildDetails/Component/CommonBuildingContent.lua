local CommonBuildingContent = BaseClass("CommonBuildingContent", UIBaseContainer)
local base = UIBaseContainer
local CommonBuildingContentPropertyItem = require("UI.LWUIBuildDetails.Component.CommonBuildingContentPropertyItem")
local CommonBuildingContentSlotItem = require("UI.LWUIBuildDetails.Component.CommonBuildingContentSlotItem")
local detail_scroll_content_path = "infoContent/detailContent/ScrollView/Viewport/detailScrollContent"
local property_path = "infoContent/detailContent/ScrollView/Viewport/detailScrollContent/Property"
local solt_item_path = "infoContent/slotContent/slotItemContent/soltItem"
local empty_txt_path = "infoContent/slotContent/emptyTxt"
local worker_btn_path = "workerBtn"
local quick_btn_red_path = "workerBtn/quickBtnRed"
local propertyItemNum = 3
local soltItemNum = 4
local WaitSendMsgTime = 3000

function CommonBuildingContent:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function CommonBuildingContent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CommonBuildingContent:DataDefine()
  self.curBuildIndex = nil
  self.curBuildData = nil
  self.buildCurLevelTemplate = nil
  self.canSendMsgTime = 0
end

function CommonBuildingContent:DataDestroy()
  self.curBuildIndex = nil
  self.curBuildData = nil
  self.buildCurLevelTemplate = nil
  self.canSendMsgTime = nil
end

function CommonBuildingContent:ComponentDefine()
  self.detail_scroll_content = self:AddComponent(UIBaseContainer, detail_scroll_content_path)
  self.empty_txt = self:AddComponent(UITextMeshProUGUIEx, empty_txt_path)
  self.worker_btn = self:AddComponent(UIButton, worker_btn_path)
  self.worker_btn:SetOnClick(function()
    self:OnWorkerBtnClick()
  end)
  self.PropertyItems = {}
  for i = 1, propertyItemNum do
    local propertyItem = self:AddComponent(CommonBuildingContentPropertyItem, property_path .. i)
    self.PropertyItems[i] = propertyItem
  end
  self.soltItems = {}
  for i = 1, soltItemNum do
    local soltItem = self:AddComponent(CommonBuildingContentSlotItem, solt_item_path .. i)
    self.soltItems[i] = soltItem
  end
  self.quick_btn_red = self:AddComponent(UIImage, quick_btn_red_path)
end

function CommonBuildingContent:ComponentDestroy()
  self.detail_scroll_content = nil
  self.empty_txt = nil
  self.worker_btn = nil
  self.PropertyItems = nil
  self.soltItems = nil
  self.quick_btn_red = nil
end

function CommonBuildingContent:ReInit(curBuildIndex, curBuildData, buildCurLevelTemplate)
  self.curBuildIndex = curBuildIndex
  self.curBuildData = curBuildData
  self.buildCurLevelTemplate = buildCurLevelTemplate
  self.detail_scroll_content:SetAnchoredPositionXY(0, 0)
  self:RefreshBuildPropertys()
  self:RefreshWorkerList()
end

function CommonBuildingContent:RefreshBuildPropertys()
  local list = BuildingUtils.GetBuildingPropertyDataList(self.curBuildData)
  for i = 1, propertyItemNum do
    if list and list[i] and list[i] ~= "" then
      self.PropertyItems[i]:SetActive(true)
      local property = list[i]
      self.PropertyItems[i]:ReInit(property, self.curBuildData)
    else
      self.PropertyItems[i]:SetActive(false)
    end
  end
end

function CommonBuildingContent:RefreshWorkerList()
  local workerList = self.view.ctrl:GetTrenchDataList(self.curBuildIndex)
  for i = 1, soltItemNum do
    if workerList[i] then
      self.soltItems[i]:SetActive(true)
      local param = workerList[i]
      param.index = i
      self.soltItems[i]:ReInit(param)
    else
      self.soltItems[i]:SetActive(false)
    end
  end
  if #workerList == 0 then
    self.empty_txt:SetActive(true)
  else
    self.empty_txt:SetActive(false)
  end
  local isRed = self.curBuildData:CheckBuildingWorkerRedDot()
  self.quick_btn_red:SetActive(isRed)
end

function CommonBuildingContent:OnWorkerBtnClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime <= self.canSendMsgTime then
    return
  end
  self.canSendMsgTime = curTime + WaitSendMsgTime
  SFSNetwork.SendMessage(MsgDefines.AssignSingleBuilding, self.curBuildData.uuid)
end

function CommonBuildingContent:RecordCurVal()
  for i = 1, propertyItemNum do
    if self.PropertyItems[i]:GetActive() then
      self.PropertyItems[i]:RecordCurVal()
    end
  end
  for i = 1, soltItemNum do
    if self.soltItems[i]:GetActive() then
      self.soltItems[i]:RecordCurVal()
    end
  end
end

function CommonBuildingContent:TryPlayAni()
  for i = 1, propertyItemNum do
    if self.PropertyItems[i]:GetActive() then
      self.PropertyItems[i]:TryPlayAni()
    end
  end
  local playIndex = 1
  for i = 1, soltItemNum do
    if self.soltItems[i]:GetActive() and self.soltItems[i]:IsNeedPlayAni() then
      local delayTime = 0.1 + playIndex * 0.1
      self.soltItems[i]:TryPlayAni(delayTime)
      playIndex = playIndex + 1
    end
  end
end

return CommonBuildingContent
