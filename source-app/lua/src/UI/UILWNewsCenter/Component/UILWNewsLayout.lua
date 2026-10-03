local UILWNewsLayout = BaseClass("UILWNewsLayout", UIBaseContainer)
local base = UIBaseContainer
local detailsPath = "Assets/Main/Prefabs/UI/LWNewsCenter/LWNewsDetails.prefab"
local UILWNewsDetailsItem = require("UI.UILWNewsCenter.Component.UILWNewsDetailsItem")

function UILWNewsLayout:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWNewsLayout:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWNewsLayout:ComponentDefine()
end

function UILWNewsLayout:ComponentDestroy()
  self:CLearItems()
end

function UILWNewsLayout:OnBtnClick()
end

function UILWNewsLayout:SetState(tabType)
end

function UILWNewsLayout:CLearItems()
  self:RemoveComponents(UILWNewsDetailsItem)
  self.detailsList = {}
  if self.reqList ~= nil then
    for k, v in pairs(self.reqList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.reqList = {}
end

function UILWNewsLayout:SetContentViewScript(chatMainView)
  self._contentViewScript = chatMainView
end

function UILWNewsLayout:UpdateItem(data)
  self:CLearItems()
  local go, cell
  local dataList = data.list
  if dataList and 0 < #dataList then
    for i = 1, #dataList do
      local activityAssetData = self:GameObjectInstantiateAsync(detailsPath, function(request)
        if request.isError then
          return
        end
        go = request.gameObject
        go.name = "DetailsItem" .. i
        go.transform:SetParent(self.transform)
        go.transform:Set_localScale(1, 1, 1)
        cell = self:AddComponent(UILWNewsDetailsItem, go.name)
        cell:UpdateItem(dataList[i])
        table.insert(self.detailsList, cell)
      end)
      self.reqList[i] = activityAssetData
    end
  end
end

return UILWNewsLayout
