local LWSeasonAllianceRankRewardInfoView = BaseClass("LWSeasonAllianceRankRewardInfoView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local LWResourceLackCell = require("UI.LWResourceLack.Res.Component.LWResourceLackCell")
local panel_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/Common_bg_orange/CloseBtn"
local u_i_common_res_item_path = "UICommonMiniPopUpTitle/Common_bg_orange/reward/UICommonResItem"
local content_path = "UICommonMiniPopUpTitle/Common_bg_orange/reward/Rect_Reward/Viewport/Content"
local access_content_path = "UICommonMiniPopUpTitle/Common_bg_orange/accessList/Viewport/accessContent"

function LWSeasonAllianceRankRewardInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Refresh()
end

function LWSeasonAllianceRankRewardInfoView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonAllianceRankRewardInfoView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self:CloseWindow()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self:CloseWindow()
  end)
  self.access_content = self:AddComponent(UIBaseContainer, access_content_path)
  self.common_res_item = self.transform:Find(u_i_common_res_item_path).gameObject
  self.common_res_item:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function LWSeasonAllianceRankRewardInfoView:ComponentDestroy()
  self.panel = nil
  self.close_btn = nil
  self.content:RemoveComponents(UICommonResItem)
  if self.common_res_item then
    self.common_res_item:GameObjectRecycleAll()
  end
  self.common_res_item = nil
  self.content = nil
  self:ClearList()
  self.access_content = nil
end

function LWSeasonAllianceRankRewardInfoView:CloseWindow()
  self.ctrl:CloseSelf()
end

function LWSeasonAllianceRankRewardInfoView:Refresh()
  local reward = DataCenter.SeasonDataManager:GetLootRewardList()
  self.content:RemoveComponents(UICommonResItem)
  self.common_res_item:GameObjectRecycleAll()
  if reward then
    for index, value in ipairs(reward) do
      local go = self.common_res_item:GameObjectSpawn(self.content.transform)
      go.gameObject:SetActive(true)
      go.transform:Set_localScale(0.8, 0.8, 0.8)
      go.name = "item" .. tostring(index)
      local cell = self.content:AddComponent(UICommonResItem, go.name)
      cell:ReInit(value)
    end
  end
  self:RefreshAccess()
end

function LWSeasonAllianceRankRewardInfoView:ClearList()
  if self.cellReqs then
    self.access_content:RemoveComponents(LWResourceLackCell)
    for k, v in pairs(self.cellReqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cellReqs = {}
  self.cells = {}
end

function LWSeasonAllianceRankRewardInfoView:RefreshAccess()
  self:ClearList()
  local templates = DataCenter.LWResourceLackManager:GetResourceWay(ResourceType.AllianceBattleReward)
  if not templates or #templates == 0 then
    return
  end
  local need = 100
  local tDatas = LWResourceLackUtil:FilterResourceTemplates(templates, need)
  local needCheckFarmer = false
  if DataCenter.SeasonFarmerManager:IsOpen() and DataCenter.SeasonFarmerManager:IsActive() then
    needCheckFarmer = true
  end
  self.dataList = {}
  for i, v in ipairs(tDatas) do
    local flag = true
    if needCheckFarmer then
      flag = toInt(v.builders_alliance_show) == 1
    else
      flag = toInt(v.builders_alliance_show) ~= 1
    end
    if flag then
      table.insert(self.dataList, v)
    end
  end
  self.selectResourceData = {
    resType = self.resType,
    need = 1
  }
  table.sort(self.dataList, function(a, b)
    return a.order < b.order
  end)
  for k, v in pairs(self.dataList) do
    self.cellReqs[k] = self:GameObjectInstantiateAsync(UIAssets.LWLackResourceItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.access_content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(k)
      go.name = nameStr
      self.cells[k] = self.access_content:AddComponent(LWResourceLackCell, nameStr)
      self.cells[k]:Refresh(self:IsFirst(k), v, self.ctrl, self.selectResourceData)
    end)
  end
end

function LWSeasonAllianceRankRewardInfoView:IsFirst(index)
  for i = 1, index - 1 do
    if self.cells[i] ~= nil then
      return false
    end
  end
  return true
end

return LWSeasonAllianceRankRewardInfoView
