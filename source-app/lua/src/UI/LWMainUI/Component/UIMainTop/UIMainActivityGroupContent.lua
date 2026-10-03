local UIMainActivityGroupContent = BaseClass("UIMainActivityGroupContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIMainActivityGroupItemBtn = require("UI.LWMainUI.Component.UIMainTop.UIMainActivityGroupItemBtn")
local activityGroupItemBtn_path = "ActivityGroupItemBtn"
local contentList_path = "contentList"

function UIMainActivityGroupContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainActivityGroupContent:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainActivityGroupContent:ComponentDefine()
  self.btnItemDict = {}
  self.content = self:AddComponent(UIBaseContainer, contentList_path)
  self.activityGroupItemBtn = self:AddComponent(UIBaseContainer, activityGroupItemBtn_path)
  self.activityGroupItemBtn:SetActive(false)
  self.activityGroupItemBtn.gameObject:GameObjectCreatePool()
  self.root = self:AddComponent(UIBaseContainer, "")
end

function UIMainActivityGroupContent:ComponentDestroy()
  self:ClearAllBtnItem()
end

function UIMainActivityGroupContent:ClearAllBtnItem()
  self.content:RemoveComponents(UIMainActivityGroupItemBtn)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.activityGroupItemBtn.gameObject:GameObjectRecycleAll()
  self.btnItemDict = {}
end

function UIMainActivityGroupContent:DataDefine()
  self.showBtnData = {}
  self.singleBtnData = {}
end

function UIMainActivityGroupContent:DataDestroy()
  self.showBtnData = nil
  self.singleBtnData = nil
end

function UIMainActivityGroupContent:Refresh()
  for groupId, data in pairs(self.showBtnData) do
    data.dataList = {}
  end
  local allNeedShowSingleList = {}
  DataCenter.ActivityListDataManager:SortActivityArr()
  local activityList = DataCenter.ActivityListDataManager:GetNowActivityList(false)
  if activityList ~= nil then
    for actId, data in pairs(activityList) do
      local groupId = data.festivalEntrance
      if 0 < groupId and not MainUICommonActivityGroupExceptShowList[groupId] then
        if self.showBtnData[groupId] == nil then
          self.showBtnData[groupId] = {
            showState = false,
            dataList = {}
          }
        end
        table.insert(self.showBtnData[groupId].dataList, data)
      elseif data.isShowOnMainUI and data.isShowOnMainUI == 1 then
        local singleGroupId = self:GetSingleGroupIdFromActivityId(data.id)
        table.insert(allNeedShowSingleList, singleGroupId)
        local singleDataList = {}
        table.insert(singleDataList, data)
        self.showBtnData[singleGroupId] = {showState = false, dataList = singleDataList}
      end
    end
  end
  local isHaveShowStateChange = false
  for groupId, data in pairs(self.showBtnData) do
    local curShowState = #data.dataList > 0
    if data.showState ~= curShowState then
      data.showState = curShowState
      isHaveShowStateChange = true
    end
  end
  local allNeedShowGroupList = {}
  for groupId, showData in pairs(self.showBtnData) do
    table.insert(allNeedShowGroupList, groupId)
  end
  local showNum = 0
  for _, groupId in ipairs(allNeedShowGroupList) do
    local showData = self.showBtnData[groupId]
    if showData.showState then
      if self.btnItemDict[groupId] == nil then
        local item = self.activityGroupItemBtn.gameObject:GameObjectSpawn(self.content.transform)
        local name = groupId
        item.name = name
        local obj = self.content:AddComponent(UIMainActivityGroupItemBtn, item.name)
        self.btnItemDict[groupId] = obj
        obj:SetData(groupId, showData.dataList, function(groupId, actId, isGroupAct)
          self:OnBtnClick(groupId, actId, isGroupAct)
        end)
      end
      self.btnItemDict[groupId]:SetActive(true)
      self.btnItemDict[groupId]:Refresh(groupId, showData.dataList)
      if isHaveShowStateChange then
        self.btnItemDict[groupId].transform:SetAsLastSibling()
      end
      showNum = showNum + 1
    elseif self.btnItemDict[groupId] then
      self.btnItemDict[groupId]:SetActive(false)
    end
  end
  self.root:SetActive(0 < showNum)
  return 0 < showNum
end

function UIMainActivityGroupContent:OnPassDayRefresh()
  for groupId, showData in pairs(self.showBtnData) do
    if showData.showState and self.btnItemDict[groupId] then
      self.btnItemDict[groupId]:Refresh(groupId, showData.dataList)
    end
  end
end

function UIMainActivityGroupContent:OnBtnClick(groupId, actId, isGroupAct)
  local lineData = LocalController:instance():tryGetLine(TableName.Activity, actId)
  if lineData ~= nil and not string.IsNullOrEmpty(lineData.festival_interface_config) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFestivalActivityCommonGroupShow, groupId)
  elseif isGroupAct or not string.find(groupId, "single_") then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCommonGroupShow, groupId)
  else
    GoToUtil.GoActWindow({actId})
  end
end

function UIMainActivityGroupContent:GetBtnByGroupId(groupId)
  if self.btnItemDict and self.btnItemDict[groupId] then
    local btn = self.btnItemDict[groupId]
    if btn:GetActive() then
      return btn
    end
  end
end

function UIMainActivityGroupContent:GetSingleGroupIdFromActivityId(activityId)
  if not activityId then
    return nil
  end
  return string.format("single_%s", activityId)
end

return UIMainActivityGroupContent
