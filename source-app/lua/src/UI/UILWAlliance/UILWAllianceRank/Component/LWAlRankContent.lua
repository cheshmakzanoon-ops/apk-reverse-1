local LWAlRankContent = BaseClass("LWAlRankContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIItem = require("UI.UILWAlliance.UILWAllianceRank.Component.LWAlRankContentItem")
local rank_des_path = "select/rankDes"
local name_des_path = "select/nameDes"
local value_des_path = "select/valueDes"
local country_des_path = "select/countryDes"
local self_data_path = "SelfData"
local tip_des_path = "tipDes"
local ShowListPath = "ShowListScroll"
local ShowListContentPath = "ShowListScroll/Viewport/Content"

function LWAlRankContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWAlRankContent:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rankData then
    return nil
  end
  local ShowInfo = self.rankData[index]
  local item = loopScroll:NewListViewItem("UILWAlRankItem")
  local script = self.showListContent:GetComponent(item.gameObject.name, UIItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.showListContent:AddComponent(UIItem, objectName)
  end
  script:SetActive(true)
  script:SetItemShow(self.rankType, ShowInfo)
  return item
end

function LWAlRankContent:ComponentDefine()
  self.name_des = self:AddComponent(UIText, name_des_path)
  self.value_des = self:AddComponent(UIText, value_des_path)
  self.rank_des = self:AddComponent(UIText, rank_des_path)
  self.name_des:SetLocalText(100184)
  self.value_des:SetLocalText(455114)
  self.rank_des:SetLocalText(456531)
  self.self_data = self:AddComponent(UIItem, self_data_path)
  self.tip_des = self:AddComponent(UIText, tip_des_path)
  self.tip_des:SetText("")
  self.showList = self:AddComponent(UILoopListView2, ShowListPath)
  self.showList:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.showListContent = self:AddComponent(UIBaseContainer, ShowListContentPath)
end

function LWAlRankContent:ComponentDestroy()
  self.name_des = nil
  self.value_des = nil
  self.rank_des = nil
  self.self_data = nil
  self.showList = nil
  self.showListContent = nil
end

function LWAlRankContent:DataDefine()
  self.itemIndex = 0
end

function LWAlRankContent:DataDestroy()
end

function LWAlRankContent:SetData(rankType)
  self.rankType = rankType
  if self.rankType == nil then
    return
  end
  self:RefreshView()
end

function LWAlRankContent:RefreshView()
  if self.rankType == nil then
    return
  end
  if self.rankType == AlRankType.Power then
    self.value_des:SetLocalText(100644)
  elseif self.rankType == AlRankType.Kill then
    self.value_des:SetLocalText(310139)
  else
    self.value_des:SetLocalText(455114)
  end
  local rankData, selfRankData = self.view.ctrl:GetRankData(self.rankType)
  self.rankData = rankData
  self.selfRankData = selfRankData
  if self.selfRankData ~= nil then
    self.self_data:SetActive(true)
    self.self_data:SetItemShow(self.rankType, self.selfRankData)
  else
    self.self_data:SetActive(false)
  end
  if #self.rankData == 0 then
    self.showList:SetActive(false)
  else
    self.showList:SetActive(true)
    self.showList:SetListItemCount(#self.rankData, false, false)
    self.showList:RefreshAllShownItem()
  end
end

function LWAlRankContent:ClearScroll()
  self.showListContent:RemoveComponents(UIItem)
  self.showList:ClearAllItems()
end

return LWAlRankContent
