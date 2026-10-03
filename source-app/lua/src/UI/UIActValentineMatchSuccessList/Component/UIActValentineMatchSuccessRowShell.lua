local base = UIBaseContainer
local UIActValentineMatchSuccessRowShell = BaseClass("UIActValentineMatchSuccessRowShell", UIBaseContainer)
local UIActValentineMatchSuccessItem = require("UI.UIActValentineMatchSuccessList.Component.UIActValentineMatchSuccessItem")
local Localization = CS.GameEntry.Localization
local matchSuccessItemPath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/UIActValentineMatchSuccessItem.prefab"

function UIActValentineMatchSuccessRowShell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActValentineMatchSuccessRowShell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActValentineMatchSuccessRowShell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compPos1 = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.compPos2 = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
end

function UIActValentineMatchSuccessRowShell:ComponentDestroy()
  self.viewSkin = nil
  self.compPos1 = nil
  self.compPos2 = nil
end

function UIActValentineMatchSuccessRowShell:DataDefine()
  self.itemGoLoadReqList = {}
  self.itemScriptList = {}
end

function UIActValentineMatchSuccessRowShell:DataDestroy()
  self.compPos2:RemoveComponents(UIActValentineMatchSuccessItem)
  self.compPos1:RemoveComponents(UIActValentineMatchSuccessItem)
  if self.itemGoLoadReqList ~= nil then
    for _, req in ipairs(self.itemGoLoadReqList) do
      if req ~= nil then
        self:GameObjectDestroy(req)
      end
    end
  end
  self.itemScriptList = nil
end

function UIActValentineMatchSuccessRowShell:OnAddListener()
  base.OnAddListener(self)
end

function UIActValentineMatchSuccessRowShell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActValentineMatchSuccessRowShell:SetData(activityId, matchPlayerRowData)
  if matchPlayerRowData == nil then
    return
  end
  self.activityId = activityId
  self.matchPlayerRowData = matchPlayerRowData
  for i = 1, #self.matchPlayerRowData do
    self:GenerateItem(i, self.matchPlayerRowData[i])
  end
  if #self.matchPlayerRowData < 2 then
    if self.itemScriptList[2] then
      self.itemScriptList[2]:SetActive(false)
    elseif self.itemGoLoadReqList[2] then
      self:GameObjectDestroy(self.itemGoLoadReqList[2])
    end
  end
end

function UIActValentineMatchSuccessRowShell:GenerateItem(i, matchPlayerData)
  if self.itemScriptList[i] then
    self.itemScriptList[i]:SetData(self.activityId, matchPlayerData)
    self.itemScriptList[i]:SetActive(true)
  else
    if self.itemGoLoadReqList[i] then
      self:GameObjectDestroy(self.itemGoLoadReqList[i])
    end
    self.itemGoLoadReqList[i] = self:GameObjectInstantiateAsync(matchSuccessItemPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      NameCount = NameCount + 1
      go.name = "UIActValentineMatchSuccessItem" .. NameCount
      local compPos = self["compPos" .. i]
      go.transform:SetParent(compPos.transform)
      self.itemScriptList[i] = compPos:AddComponent(UIActValentineMatchSuccessItem, go.name)
      self.itemScriptList[i]:SetAnchoredPositionXY(0, 0)
      self.itemScriptList[i]:SetLocalScaleXYZ(1, 1, 1)
      self.itemScriptList[i]:SetActive(true)
      self.itemScriptList[i]:SetData(self.activityId, matchPlayerData)
    end)
  end
end

return UIActValentineMatchSuccessRowShell
