local T11MainView = BaseClass("T11MainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local PAGE_CONFIG = {
  [T11MainPageType.Overview] = {
    name = "Overview",
    prefabPath = "Assets/Main/Prefabs/UI/T11/T11MainView/Component/PageCpt/T11OverviewPage.prefab",
    cls = "UI.T11MainView.Component.Page.T11OverviewPageComponent"
  }
}

function T11MainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local jumpPageType = self:GetUserData()
  jumpPageType = jumpPageType or T11MainPageType.Overview
  self:ChangeTargetPage(jumpPageType)
end

function T11MainView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11MainView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compPageContainer = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
end

function T11MainView:ComponentDestroy()
  self.viewSkin = nil
  self.compPageContainer = nil
  self.btnBack = nil
end

function T11MainView:DataDefine()
  self.curShowType = T11MainPageType.Overview
  self.allPageCptDic = {}
  self.curLoadReq = nil
end

function T11MainView:DataDestroy()
  self.curShowType = nil
  self.allPageCptDic = nil
  self.curLoadReq = nil
  self.compPageContainer:RemoveAllComponentes()
end

function T11MainView:OnAddListener()
  base.OnAddListener(self)
end

function T11MainView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11MainView:ChangeTargetPage(pageType)
  if self.curLoadReq then
    self.curLoadReq:Destroy()
    self.curLoadReq = nil
  end
  local prevPagCpt = self.allPageCptDic[self.curShowType]
  if prevPagCpt then
    prevPagCpt:SetActive(false)
  end
  self.curShowType = pageType
  local targetPageCpt = self.allPageCptDic[self.curShowType]
  if not targetPageCpt then
    local pageConfig = PAGE_CONFIG[pageType]
    if not pageConfig then
      Logger.LogError("T11MainView:ChangeTargetPage pageConfig is nil")
      return
    end
    local name = pageConfig.name
    local prefabPath = pageConfig.prefabPath
    local cls = pageConfig.cls
    self.curLoadReq = self:GameObjectInstantiateAsync(prefabPath, function(req)
      self.curLoadReq = nil
      req.gameObject.transform:SetParent(self.compPageContainer.transform)
      req.gameObject.transform.localPosition = Vector3(0, 0, 0)
      req.gameObject.transform.localScale = Vector3(1, 1, 1)
      req.gameObject.transform:Set_anchorMin(0, 0)
      req.gameObject.transform:Set_anchorMax(1, 1)
      req.gameObject.transform:Set_offsetMin(0, 0)
      req.gameObject.transform:Set_offsetMax(0, 0)
      req.gameObject:SetActive(true)
      req.gameObject.transform.name = name
      targetPageCpt = self.compPageContainer:AddComponent(require(cls), name)
      self.allPageCptDic[self.curShowType] = targetPageCpt
      targetPageCpt:RefreshView()
    end)
    return
  end
  targetPageCpt:RefreshView()
end

function T11MainView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

return T11MainView
