local UIPushSettingsView = BaseClass("UIPushSettingsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIPushSettingsMainItem = require("UI.UIChatNew.UIPushSettings.Component.UIPushSettingsMainItem")
local UIPushSettingsSubItem = require("UI.UIChatNew.UIPushSettings.Component.UIPushSettingsSubItem")
local compBook = {
  {
    path = "curtain",
    name = "curtain",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "panel/btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "panel/txtTitle",
    name = "txtTitle",
    type = UIText,
    textKey = 2900010
  },
  {
    path = "panel/ScrollView",
    name = "scrollView",
    type = UIDynamicVerticleScrollRectEx
  }
}

function UIPushSettingsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Refresh()
  self:AddUIListener(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
end

function UIPushSettingsView:OnDestroy()
  self:RemoveUIListener(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
  self:ComponentDestroy()
  self.ctrl.datas = nil
  base.OnDestroy(self)
end

function UIPushSettingsView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.itemIncNo = 1
  self.itemMap = {}
  self.scrollView:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "item_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local item
    if prefabIdx == 0 then
      item = self:AddComponent(UIPushSettingsMainItem, itemObj)
    else
      item = self:AddComponent(UIPushSettingsSubItem, itemObj)
    end
    if item then
      item.__prefabIdx = prefabIdx
      self.itemMap[itemObj] = item
    end
  end)
  self.scrollView:AddDisplayItemListener(function(itemObj, dataIdx)
    local item = self.itemMap[itemObj]
    if item then
      if item.__prefabIdx == 0 then
        item:Refresh()
      else
        local data = self.ctrl.datas[dataIdx + 1]
        item:Refresh(data)
      end
    end
  end)
end

function UIPushSettingsView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIPushSettingsView:Refresh()
  self.ctrl.datas = DataCenter.PushSettingsManager:GetDisplayDatas()
  local prefabIdxs = {}
  for _, data in ipairs(self.ctrl.datas) do
    table.insert(prefabIdxs, data.id and 1 or 0)
  end
  self.scrollView:SetDatas(prefabIdxs)
end

function UIPushSettingsView:OnApplicationPause(isPaused)
  if not isPaused then
    self:Refresh()
  end
end

return UIPushSettingsView
