local base = UIAsyncContainer
local WorldAlMinePanel = BaseClass("WorldAlMinePanel", base)
local Localization = CS.GameEntry.Localization
local WorldAlMinePanel_Collect = require("UI.UIWorldPoint.Component.WorldAlMinePanel_Collect")
local WorldAlMinePanel_Construct = require("UI.UIWorldPoint.Component.WorldAlMinePanel_Construct")

function WorldAlMinePanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function WorldAlMinePanel:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function WorldAlMinePanel:ComponentDefine()
  self.constructN = self:AddComponent(WorldAlMinePanel_Construct, "constructing")
  self.collectN = self:AddComponent(WorldAlMinePanel_Collect, "collecting")
end

function WorldAlMinePanel:ComponentDestroy()
end

function WorldAlMinePanel:RefreshData(pointId, pointData, serverData)
  if pointId then
    self.pointId = pointId
  end
  if pointData then
    self.pointData = pointData
  end
  if serverData then
    self.serverData = serverData
  end
  self:RefreshPanel()
end

function WorldAlMinePanel:UpdateData()
  self:RefreshPanel()
end

function WorldAlMinePanel:RefreshPanel()
  if self.pointId == nil or IsNull(self.gameObject) then
    return
  end
  local detail
  local pointInfo = CS.SceneManager.World:GetPointInfo(self.pointId)
  if pointInfo then
    detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(pointInfo.mainIndex)
  end
  if not detail then
    return
  end
  self.mineInfo = detail.alBuilding
  if not self.mineInfo then
    return
  end
  if WorldAllianceBuildUtil.IsAllianceActMineGroup(self.mineInfo.buildId) == true then
    self.constructN:SetActive(false)
    self.collectN:SetActive(true)
    self.collectN:SetData(self.pointId)
  elseif self.mineInfo.status == AllianceMineStatus.Normal then
    self.constructN:SetActive(false)
    self.collectN:SetActive(true)
    self.collectN:SetData(self.pointId)
  else
    self.collectN:SetActive(false)
    self.constructN:SetActive(true)
    self.constructN:SetData(self.pointId)
  end
end

function WorldAlMinePanel:CallBacKRefresh()
  if self.pointId == nil or IsNull(self.gameObject) then
    return
  end
  self.constructN:SetActive(false)
  self.collectN:SetActive(true)
  self.collectN:SetData(self.pointId)
end

function WorldAlMinePanel:OnInfoClick()
  UIUtil.ShowIntro(Localization:GetString("300747"), Localization:GetString("302027"), Localization:GetString("300748"))
  if self.view and self.view.ctrl then
    self.view.ctrl:CloseSelf()
  end
end

return WorldAlMinePanel
