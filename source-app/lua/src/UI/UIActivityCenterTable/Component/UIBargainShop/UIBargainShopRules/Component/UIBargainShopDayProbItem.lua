local base = UIBaseContainer
local UIBargainShopDayProbItem = BaseClass("UIBargainShopDayProbItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local prob_one_case_item_prefab = "Assets/Main/Prefabs/UI/ActivityCenter/BargainShop/Rules/ProbOneCaseItem.prefab"
local ProbOneCaseItem = require("UI.UIActivityCenterTable.Component.UIBargainShop.UIBargainShopRules.Component.ProbOneCaseItem")

function UIBargainShopDayProbItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBargainShopDayProbItem:OnDestroy()
  self:ClearAll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBargainShopDayProbItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.day_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.resItemContainer = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.price_icon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.price_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.caseContainer = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
end

function UIBargainShopDayProbItem:ComponentDestroy()
  self.viewSkin = nil
  self.day_txt = nil
  self.resItemContainer = nil
  self.price_icon = nil
  self.price_txt = nil
  self.caseContainer = nil
end

function UIBargainShopDayProbItem:DataDefine()
  self.resReq = nil
  self.caseReqList = {}
  self.rowList = nil
  self.probItemTemplate = nil
end

function UIBargainShopDayProbItem:DataDestroy()
  self.resReq = nil
  self.caseReqList = nil
  self.rowList = nil
  self.probItemTemplate = nil
end

function UIBargainShopDayProbItem:EnsureTemplate()
  if self.probItemTemplate == nil and self.gameObject then
    self.probItemTemplate = self.gameObject.transform:Find("probItem")
  end
  if self.rowList == nil then
    self.rowList = {}
    if self.probItemTemplate ~= nil then
      local rowRoot = self:GetComponent("probItem", UIBaseContainer)
      if rowRoot == nil then
        rowRoot = self:AddComponent(UIBaseContainer, self.probItemTemplate.gameObject)
      end
      self.rowList[1] = {
        rootName = "probItem",
        root = rowRoot,
        rowTf = self.probItemTemplate,
        resItemContainer = rowRoot:AddComponent(UIBaseContainer, "itemArea/resItemContainer"),
        price_icon = rowRoot:AddComponent(UIImage, "itemArea/price/icon"),
        price_txt = rowRoot:AddComponent(UITextMeshProUGUIEx, "itemArea/price/num_txst"),
        caseContainer = rowRoot:AddComponent(UIBaseContainer, "caseArea"),
        resReq = nil,
        caseReqList = {}
      }
    end
  end
end

function UIBargainShopDayProbItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBargainShopDayProbItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBargainShopDayProbItem:ClearAll()
  self:ClearAllRows()
end

function UIBargainShopDayProbItem:ClearAllRows()
  self:EnsureTemplate()
  if self.rowList and self.rowList[1] then
    self:ClearRow(self.rowList[1])
  end
  if self.rowList and #self.rowList > 1 then
    for i = #self.rowList, 2, -1 do
      local row = self.rowList[i]
      self:ClearRow(row)
      if row and row.rootName then
        self:RemoveComponents(row.rootName)
      end
      if row and row.rowTf and row.rowTf.gameObject then
        CS.UnityEngine.GameObject.Destroy(row.rowTf.gameObject)
      end
      table.remove(self.rowList, i)
    end
  end
  if self.gameObject then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.gameObject.transform)
  end
end

function UIBargainShopDayProbItem:ClearRow(row)
  if not row then
    return
  end
  if row.price_icon then
    row.price_icon:SetEnable(false)
  end
  if row.resItemContainer then
    row.resItemContainer:RemoveComponents(UICommonResItem)
  end
  if row.resReq then
    self:GameObjectDestroy(row.resReq)
    row.resReq = nil
  end
  if row.caseReqList and next(row.caseReqList) then
    for _, req in pairs(row.caseReqList) do
      if req ~= nil then
        self:GameObjectDestroy(req)
      end
    end
  end
  row.caseReqList = {}
  if row.caseContainer and row.caseContainer.transform then
    row.caseContainer:RemoveComponents(ProbOneCaseItem)
  end
end

function UIBargainShopDayProbItem:SetData(data)
  data = data or {}
  self:EnsureTemplate()
  if self.day_txt then
    self.day_txt:SetText(tostring(data.dayTitle or ""))
  end
  local items = data.items or {}
  self:ClearAllRows()
  self:EnsureTemplate()
  local needCount = #items
  if needCount < 1 then
    needCount = 1
  end
  self:EnsureRowCount(needCount)
  for i = 1, needCount do
    local row = self.rowList[i]
    local rowData = items[i]
    if row and rowData then
      self:FillRow(row, rowData, data.priceIconPath)
    elseif row and row.rowTf then
      row.rowTf.gameObject:SetActive(false)
    end
  end
  if self.gameObject then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.gameObject.transform)
  end
end

function UIBargainShopDayProbItem:EnsureRowCount(count)
  self:EnsureTemplate()
  if not self.probItemTemplate then
    return
  end
  if not self.rowList or #self.rowList == 0 then
    return
  end
  for i = #self.rowList + 1, count do
    local newGo = CS.UnityEngine.GameObject.Instantiate(self.probItemTemplate.gameObject)
    NameCount = NameCount + 1
    local name = tostring(NameCount)
    newGo.name = name
    newGo.transform:SetParent(self.probItemTemplate.parent, false)
    newGo.transform:SetAsLastSibling()
    newGo:SetActive(true)
    local rowName = name
    local rowRoot = self:AddComponent(UIBaseContainer, newGo)
    local row = {
      rootName = rowName,
      root = rowRoot,
      rowTf = newGo.transform,
      resItemContainer = rowRoot:AddComponent(UIBaseContainer, "itemArea/resItemContainer"),
      price_icon = rowRoot:AddComponent(UIImage, "itemArea/price/icon"),
      price_txt = rowRoot:AddComponent(UITextMeshProUGUIEx, "itemArea/price/num_txst"),
      caseContainer = rowRoot:AddComponent(UIBaseContainer, "caseArea"),
      resReq = nil,
      caseReqList = {}
    }
    table.insert(self.rowList, row)
  end
end

function UIBargainShopDayProbItem:FillRow(row, rowData, priceIconPath)
  if not row or not rowData then
    return
  end
  if row.rowTf then
    row.rowTf.gameObject:SetActive(true)
  end
  self:ClearRow(row)
  local itemId = tonumber(rowData.itemId)
  local count = tonumber(rowData.count) or 0
  if row.resItemContainer and itemId and itemId ~= 0 then
    local param = {
      rewardType = RewardType.GOODS,
      itemId = itemId,
      count = count
    }
    row.resReq = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError or row.resItemContainer == nil then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(row.resItemContainer.transform, false)
      go.gameObject:SetActive(true)
      local cell = row.resItemContainer:AddComponent(UICommonResItem, go)
      cell:SetLocalScaleXYZ(0.75, 0.75, 0.75)
      cell:SetPivotXY(0.5, 0.5)
      cell:SetLocalPositionXYZ(0, 0, 0)
      cell:ReInit(param)
    end)
  end
  if row.price_icon then
    if not string.IsNullOrEmpty(priceIconPath) then
      row.price_icon:SetEnable(true)
      row.price_icon:LoadSprite(priceIconPath)
    else
      row.price_icon:SetEnable(false)
    end
  end
  if row.price_txt then
    row.price_txt:SetText(tostring(rowData.originPrice or ""))
  end
  local caseList = rowData.caseList or {}
  if row.caseContainer and 0 < #caseList then
    for i, v in ipairs(caseList) do
      row.caseReqList[i] = self:GameObjectInstantiateAsync(prob_one_case_item_prefab, function(request)
        if request.isError or row.caseContainer == nil then
          return
        end
        local go = request.gameObject
        NameCount = NameCount + 1
        local name = tostring(NameCount)
        go.name = name
        go.transform:SetParent(row.caseContainer.transform, false)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.gameObject:SetActive(true)
        local cell = row.caseContainer:AddComponent(ProbOneCaseItem, go)
        cell:SetData({
          costNum = v.discount,
          prob = v.prob,
          iconPath = v.iconPath
        })
      end)
    end
  end
end

return UIBargainShopDayProbItem
