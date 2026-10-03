local UILWSeasonRainforestKingDestroyRankView = BaseClass("UILWSeasonRainforestKingDestroyRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DestroyRankItem = require("UI.LWSeason6.UILWSeasonRainforestKingDestroyRank.Component.UILWSeasonRainforestKingDestroyRankItem")
local panel_path = "panel"
local title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local loading_path = "PopUpTitle/ScrollView/loading"
local empty_path = "PopUpTitle/ScrollView/empty"
local viewport_path = "PopUpTitle/ScrollView/Viewport"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local cell_path = "PopUpTitle/ScrollView/Viewport/Content/Cell"

function UILWSeasonRainforestKingDestroyRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
end

function UILWSeasonRainforestKingDestroyRankView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonRainforestKingDestroyRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.UpdateAllianceData)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.UpdateAllianceData)
end

function UILWSeasonRainforestKingDestroyRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.UpdateAllianceData)
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.UpdateAllianceData)
  base.OnRemoveListener(self)
end

function UILWSeasonRainforestKingDestroyRankView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text:SetLocalText("season_s6_activity_1200116_desc09")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.loading = self:AddComponent(UIImage, loading_path)
  self.empty = self:AddComponent(UIImage, empty_path)
  self.viewport = self:AddComponent(UIImage, viewport_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItemPool = self.transform:Find(cell_path).gameObject
  self.theItemPool:GameObjectCreatePool()
  self.loading:SetActive(false)
  self.empty:SetActive(false)
end

function UILWSeasonRainforestKingDestroyRankView:ComponentDestroy()
  self.content:RemoveComponents(DestroyRankItem)
  self.theItemPool:GameObjectRecycleAll()
  self.btn_back = nil
  self.loading = nil
  self.empty = nil
  self.viewport = nil
  self.content = nil
  self.theItemPool = nil
  self.panel = nil
  self.title_text = nil
  self.close_btn = nil
end

function UILWSeasonRainforestKingDestroyRankView:UpdateAllianceData()
  if self.nodeList then
    for _, node in pairs(self.nodeList) do
      node:UpdateAllianceData()
    end
  end
end

function UILWSeasonRainforestKingDestroyRankView:UpdateData()
  local meta
  local mgr = DataCenter.AllianceCityTemplateManager
  local factionMgr = DataCenter.SeasonFactionWarDataManager
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local allCityList = DataCenter.WorldAllianceCityDataManager:GetAllianceCityList(mySourceServerId)
  local dataList = {}
  local dataCount = 0
  if allCityList then
    local seasonInfo = SeasonUtil.GetSeasonInfo(mySourceServerId)
    local myCampId = factionMgr.myCampId
    local bigMapIndex = DataCenter.SeasonDataManager:GetNinePalacesIndex(mySourceServerId, ServerEnum.Source)
    for k, v in pairs(allCityList) do
      if v and v:IsRuins() and seasonInfo ~= nil then
        meta = mgr:GetTemplate(v.cityId, v.destroyServerId)
        if meta and meta.bigMapIndex == bigMapIndex and meta:IsCity() then
          local campId = seasonInfo:GetCampIdByServerId(v.destroyServerId)
          if campId ~= myCampId and (campId == SeasonFactionType.Rebels or campId == SeasonFactionType.Gendarmerie) then
            local data = dataList[v.allianceId]
            if data == nil then
              data = {
                allianceId = v.allianceId,
                cityList = {},
                destroy_force = 0,
                serverId = v.destroyServerId
              }
              dataList[v.allianceId] = data
              dataCount = dataCount + 1
            end
            data.destroy_force = data.destroy_force + meta:getIntValue("destroy_force", 0)
            table.insert(data.cityList, {data = v, cfg = meta})
          end
        end
      end
    end
  end
  if dataCount == 0 then
    self.content:RemoveComponents(DestroyRankItem)
    self.theItemPool:GameObjectRecycleAll()
    self.loading:SetActive(false)
    self.empty:SetActive(true)
    self.dataList = nil
    self.dataCursor = -1
  else
    self.dataList = {}
    self.nodeList = {}
    self.dataCursor = 1
    self.loading:SetActive(false)
    self.empty:SetActive(false)
    for allianceId, v in pairs(dataList) do
      table.insert(self.dataList, v)
    end
    table.sort(self.dataList, function(a, b)
      return a.destroy_force > b.destroy_force
    end)
  end
end

function UILWSeasonRainforestKingDestroyRankView:Update100MS()
  if self.dataList and self.dataCursor ~= nil and self.dataCursor > 0 then
    local data = self.dataList[self.dataCursor]
    if data == nil then
      self.dataCursor = nil
    else
      self.dataCursor = self.dataCursor + 1
      local goItem, theItem
      goItem = self.theItemPool:GameObjectSpawn(self.content.transform)
      goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
      goItem:SetActive(true)
      theItem = self.content:AddComponent(DestroyRankItem, goItem.name)
      theItem:ReInit(data)
      table.insert(self.nodeList, theItem)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(goItem.transform)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
    end
  end
end

return UILWSeasonRainforestKingDestroyRankView
