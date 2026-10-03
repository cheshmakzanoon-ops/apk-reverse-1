local base = UIAsyncContainer
local LWUINewBeeMigrateLoading = BaseClass("LWUINewBeeMigrateLoading", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function LWUINewBeeMigrateLoading:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUINewBeeMigrateLoading:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUINewBeeMigrateLoading:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
end

function LWUINewBeeMigrateLoading:ComponentDestroy()
  self.viewSkin = nil
  self.compContent = nil
end

function LWUINewBeeMigrateLoading:DataDefine()
  self.asyncs = {}
end

function LWUINewBeeMigrateLoading:DataDestroy()
  self.compContent:RemoveAllComponentes()
  self.asyncs = nil
  self.rewardList = nil
end

function LWUINewBeeMigrateLoading:OnAddListener()
  base.OnAddListener(self)
end

function LWUINewBeeMigrateLoading:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUINewBeeMigrateLoading:UpdateData()
  if table.IsNullOrEmpty(self.rewardList) then
    return
  end
  local cnt = #self.rewardList
  local scale = 0.5
  for i = 1, cnt do
    local info = self.rewardList[i]
    self.asyncs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.name = UIUtil.GetLoopListItemIndex("Item_")
      go.gameObject:SetActive(true)
      local tf = go.transform
      tf:SetParent(self.compContent.transform)
      tf:Reset()
      local cell = self.compContent:AddComponent(UICommonResItem, go.name)
      cell:SetLocalScaleXYZ(scale, scale, scale)
      cell:ReInit(info)
    end)
  end
end

function LWUINewBeeMigrateLoading:SetData(rewardList)
  self.rewardList = rewardList
  self:RefreshView()
end

return LWUINewBeeMigrateLoading
