local base = UIBaseView
local UITrainVIPInviteListView = BaseClass("UITrainVIPInviteListView", base)
local DriverInviteItem = require("UI.UILWRailway.UITrainDriverInvite.Component.TrainDriverInviteItem")
local Localization = CS.GameEntry.Localization
local search_input_path = "Root/FindArea/FindInputField"
local search_btn_path = "Root/FindArea/FindClickBtn"

function UITrainVIPInviteListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh(self.dataList)
end

function UITrainVIPInviteListView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UITrainVIPInviteListView:ComponentDefine()
  self.returnBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.closeBtn = self:AddComponent(UIButton, "Root/CloseBtn")
  self.returnBtn:SetOnClick(function()
    self:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self:CloseSelf()
  end)
  self.titleText = self:AddComponent(UIText, "Root/Common_img_title/titleText")
  self.descText = self:AddComponent(UIText, "Root/desc")
  self.scrollRect = self:AddComponent(UIScrollRect, "Root/ScrollView")
  self.content = self:AddComponent(UIBaseContainer, "Root/ScrollView/Viewport/Content")
  self.emptyText = self:AddComponent(UIBaseContainer, "Root/emptyText")
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

function UITrainVIPInviteListView:ComponentDestroy()
  self:RemoveItems()
  self.returnBtn = nil
  self.closeBtn = nil
  self.content = nil
  self.toggleGroup = nil
  self.confirmBtn = nil
  self.titleText = nil
  self.scrollRect = nil
end

function UITrainVIPInviteListView:DataDefine()
  self.param = self:GetUserData()
  self.dataList = DataCenter.LWAllyStationDataManager:GetVipMemberListData()
  if self.param == 0 then
    self.descText:SetLocalText("alliance_train_vip013")
    self.titleText:SetLocalText("alliance_train_vip040")
  elseif self.param == 1 then
    self.descText:SetLocalText("alliance_train_vip014")
    self.titleText:SetLocalText("alliance_train_vip041")
  end
end

function UITrainVIPInviteListView:DataDestroy()
  self.param = nil
  self.dataList = nil
  self.nameStr = nil
end

function UITrainVIPInviteListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceTrainVipInviteList, self.Refresh)
end

function UITrainVIPInviteListView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceTrainVipInviteList, self.Refresh)
end

function UITrainVIPInviteListView:CloseSelf()
  self.ctrl:CloseSelf()
end

function UITrainVIPInviteListView:Refresh(dataList)
  self:RemoveItems()
  if self.scrollRect then
    self.scrollRect:SetVerticalNormalizedPosition(1)
  end
  if not dataList then
    return
  end
  if 0 < #dataList then
    table.sort(dataList, function(a, b)
      local orderA = a.online == 1 and 1 or a.online == 2 and 2 or 3
      local orderB = b.online == 1 and 1 or b.online == 2 and 2 or 3
      if orderA ~= orderB then
        return orderA < orderB
      end
      return a.power > b.power
    end)
    self.emptyText:SetActive(false)
    for i = 1, #dataList do
      self.rewardReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UILWRailway/Scene/VipInviteItem.prefab", function(req)
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
        cell:RefreshVip(dataList[i], self.toggleGroup)
      end)
    end
  else
    self.emptyText:SetActive(true)
  end
end

function UITrainVIPInviteListView:RemoveItems()
  self.content:RemoveComponents(DriverInviteItem)
  if self.rewardReqs then
    for _, v in pairs(self.rewardReqs) do
      v:Destroy()
    end
  end
  self.rewardReqs = {}
end

function UITrainVIPInviteListView:OnSelect(uid, nameStr)
  self.curSelection = uid
  self.nameStr = nameStr
end

function UITrainVIPInviteListView:OnClickConfirm()
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  if platformData.state == TrainPlatformState.TrainWithPassenger then
    UIUtil.ShowTips(Localization:GetString("alliance_train_vip028"))
  elseif self.curSelection then
    local param = {
      type = self.param,
      vipId = self.curSelection,
      platform = 1,
      name = self.nameStr
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainVIPInviteConfirmPop, {anim = true}, param)
    self:CloseSelf()
  end
end

function UITrainVIPInviteListView:SearchIptOnValueChange(value)
  self.searchInputValue = value
  self:OnSearchClick()
end

function UITrainVIPInviteListView:OnSearchClick()
  if string.IsNullOrEmpty(self.searchInputValue) then
    self:Refresh(self.dataList)
  else
    self:searchByKeyword(self.dataList, self.searchInputValue)
  end
end

function UITrainVIPInviteListView:searchByKeyword(data, keyword)
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

return UITrainVIPInviteListView
