local base = UIBaseView
local UITrainDriverInviteView = BaseClass("UITrainDriverInviteView", base)
local DriverInviteItem = require("UI.UILWRailway.UITrainDriverInvite.Component.TrainDriverInviteItem")
local search_input_path = "Root/FindArea/FindInputField"
local search_btn_path = "Root/FindArea/FindClickBtn"

function UITrainDriverInviteView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITrainDriverInviteView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UITrainDriverInviteView:ComponentDefine()
  self.returnBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.closeBtn = self:AddComponent(UIButton, "Root/CloseBtn")
  self.returnBtn:SetOnClick(function()
    self:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self:CloseSelf()
  end)
  self.scrollRect = self:AddComponent(UIScrollRect, "Root/ScrollView")
  self.content = self:AddComponent(UIBaseContainer, "Root/ScrollView/Viewport/Content")
  self.toggleGroup = self.content.transform:GetComponent(typeof(CS.UnityEngine.UI.ToggleGroup))
  self.confirmBtn = self:AddComponent(UIButton, "Root/confirmBtn")
  self.confirmBtn:SetOnClick(function()
    self:OnClickConfirm()
  end)
  self.searchInput = self:AddComponent(UIInput, search_input_path)
  self.searchInput:SetText("")
  self.searchInput:SetOnValueChange(function(value)
    self:SearchIptOnValueChange(value)
  end)
  self.searchBtn = self:AddComponent(UIButton, search_btn_path)
  self.searchBtn:SetOnClick(function()
    self:OnSearchClick()
  end)
end

function UITrainDriverInviteView:ComponentDestroy()
  self:RemoveItems()
  self.scrollRect = nil
end

function UITrainDriverInviteView:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.AllianceTrainInviteList)
end

function UITrainDriverInviteView:DataDestroy()
  self.dataList = nil
end

function UITrainDriverInviteView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceTrainInviteList, self.InitDataList)
  self:AddUIListener(EventId.AllianceTrainAssignMessageSuccess, self.CloseSelf)
end

function UITrainDriverInviteView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceTrainInviteList, self.InitDataList)
  self:RemoveUIListener(EventId.AllianceTrainAssignMessageSuccess, self.CloseSelf)
end

function UITrainDriverInviteView:CloseSelf()
  self.ctrl:CloseSelf()
end

function UITrainDriverInviteView:Refresh(dataList)
  self:RemoveItems()
  if self.scrollRect then
    self.scrollRect:SetVerticalNormalizedPosition(1)
  end
  if not dataList then
    return
  end
  table.sort(dataList, function(a, b)
    local orderA = a.online and 1 or 2
    local orderB = b.online and 1 or 2
    if orderA ~= orderB then
      return orderA < orderB
    end
    return a.power > b.power
  end)
  for i = 1, #dataList do
    self.rewardReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UILWRailway/DriverInviteItem.prefab", function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(1, 1, 1)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.content:AddComponent(DriverInviteItem, nameStr)
      cell:Refresh(dataList[i], self.toggleGroup)
    end)
  end
end

function UITrainDriverInviteView:RemoveItems()
  self.content:RemoveComponents(DriverInviteItem)
  if self.rewardReqs then
    for _, v in pairs(self.rewardReqs) do
      v:Destroy()
    end
  end
  self.rewardReqs = {}
end

function UITrainDriverInviteView:OnSelect(uid)
  self.curSelection = uid
end

function UITrainDriverInviteView:OnClickConfirm()
  if self.curSelection then
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainAssign, self.curSelection)
  end
end

function UITrainDriverInviteView:SearchIptOnValueChange(value)
  self.searchInputValue = value
  self:OnSearchClick()
end

function UITrainDriverInviteView:OnSearchClick()
  if string.IsNullOrEmpty(self.searchInputValue) then
    self:Refresh(self.dataList)
  else
    self:searchByKeyword(self.dataList, self.searchInputValue)
  end
end

function UITrainDriverInviteView:searchByKeyword(data, keyword)
  local result = {}
  keyword = string.lower(keyword)
  for _, item in ipairs(data) do
    local lowerName = string.lower(item.name)
    if string.find(lowerName, keyword, 1, true) then
      table.insert(result, item)
    else
      local remarkName, haveRemark = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(item.uid, item.name)
      if haveRemark then
        remarkName = string.lower(remarkName)
        if string.find(remarkName, keyword, 1, true) then
          table.insert(result, item)
        end
      end
    end
  end
  self:Refresh(result)
end

function UITrainDriverInviteView:InitDataList(dataList)
  self.dataList = dataList
  self:Refresh(dataList)
end

return UITrainDriverInviteView
