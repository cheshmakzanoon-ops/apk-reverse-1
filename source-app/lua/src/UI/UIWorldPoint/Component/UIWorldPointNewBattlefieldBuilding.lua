local base = UIAsyncContainer
local UIWorldPointNewBattlefieldBuilding = BaseClass("UIWorldPointNewBattlefieldBuilding", base)
local Localization = CS.GameEntry.Localization

function UIWorldPointNewBattlefieldBuilding:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWorldPointNewBattlefieldBuilding:OnDestroy()
  self.buildInfo = nil
  self.serverData = nil
  self.detailPlayerData = nil
  if self.dComponent then
    self.dComponent:Delete()
    self.dComponent = nil
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldPointNewBattlefieldBuilding:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
end

function UIWorldPointNewBattlefieldBuilding:ComponentDestroy()
  self.viewSkin = nil
end

function UIWorldPointNewBattlefieldBuilding:DataDefine()
end

function UIWorldPointNewBattlefieldBuilding:DataDestroy()
end

function UIWorldPointNewBattlefieldBuilding:OnAddListener()
  base.OnAddListener(self)
end

function UIWorldPointNewBattlefieldBuilding:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWorldPointNewBattlefieldBuilding:RefreshView(buildInfo, serverData)
  if buildInfo then
    self.buildInfo = buildInfo
  end
  if serverData then
    self.serverData = serverData
    self.detailPlayerData = serverData.playerData
  end
  if not self.dComponent then
    self.dComponent = UIAsyncLoaderBridge.New(self, "dComponent", self.transform, "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/Battlefield/WorldPointBattlefieldDragonComp.prefab", "UI.UIWorldPoint.Component.Battlefield.WorldPointBattlefieldDragonComp", false, Bind(self, self.AfterRefresh))
    self.dComponent:SetActive(true)
  else
    self.dComponent:Refresh(self.buildInfo, self.serverData)
    if self.detailPlayerData then
      self.dComponent:RefreshDetail(self.detailPlayerData)
    end
  end
end

function UIWorldPointNewBattlefieldBuilding:AfterRefresh()
  if self.dComponent then
    if self.buildInfo and self.serverData then
      self.dComponent:Refresh(self.buildInfo, self.serverData)
    end
    if self.detailPlayerData then
      self.dComponent:RefreshDetail(self.detailPlayerData)
    end
  end
end

function UIWorldPointNewBattlefieldBuilding:SetTopBg(path)
  if self.view then
    self.view:SetTopBg(path)
  end
end

function UIWorldPointNewBattlefieldBuilding:ReAutoFitUI()
  if self.view and self.view.ReAutoFitUI then
    self.view:ReAutoFitUI()
  end
end

return UIWorldPointNewBattlefieldBuilding
