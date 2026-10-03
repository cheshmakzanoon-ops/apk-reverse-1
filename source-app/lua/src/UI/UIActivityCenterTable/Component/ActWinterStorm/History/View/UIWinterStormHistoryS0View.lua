local UIWinterStormHistoryS0View = BaseClass("UIWinterStormHistoryS0View", UIBaseView)
local Localization = CS.GameEntry.Localization
local base = UIBaseView
local CLS_NEW = "UI.UIActivityCenterTable.Component.ActWinterStorm.History.Component.UIWS_H_HCell"
local PREFAB_NEW = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/S0/UIWS_H_HCell.prefab"
local CLS_OLD = "UI.UIActivityCenterTable.Component.ActWinterStorm.History.Component.UIWS_HistoryCell"
local PREFAB_OLD = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/UIWS_HistoryCell.prefab"

function UIWinterStormHistoryS0View:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWinterStormHistoryS0View:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWinterStormHistoryS0View:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compEmpty = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.textTitle1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTitle2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTitle3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.scrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 7)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
end

function UIWinterStormHistoryS0View:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.btnClose = nil
  self.compEmpty = nil
  self.textTitle1 = nil
  self.textTitle2 = nil
  self.textTitle3 = nil
  self.scrollRect = nil
  self.compContent = nil
end

function UIWinterStormHistoryS0View:DataDefine()
  local logInfo = DataCenter.ActWinterStormManager:GetLogInfo() or {}
  self.logs = logInfo.logs or {}
  local format = string.format
  self.textTitle1:SetText(format("%s: %s", Localization:GetString(458023), logInfo.keepWinCount or 0))
  self.textTitle2:SetText(format("%s: %s", Localization:GetString(458024), logInfo.totalFightCount or 0))
  self.textTitle3:SetText(format("%s: %s", Localization:GetString(458025), logInfo.historyWinCount or 0))
  local cnt = #self.logs
  self.scrollRect:SetActive(0 < cnt)
  self.compEmpty:SetActive(cnt == 0)
  if 0 < cnt then
    for i, data in ipairs(self.logs) do
      local bNew = data.conclusionId ~= 0
      local clsStr = bNew and CLS_NEW or CLS_OLD
      local prefabStr = bNew and PREFAB_NEW or PREFAB_OLD
      local item = self:LoadComponentAsync(clsStr, prefabStr, self.compContent, function(_, go, _, callback_param)
        go.transform:SetSiblingIndex(toInt(callback_param))
      end, i - 1)
      item:ReInit(data)
    end
  end
end

function UIWinterStormHistoryS0View:DataDestroy()
  self.logs = nil
end

function UIWinterStormHistoryS0View:OnAddListener()
  base.OnAddListener(self)
end

function UIWinterStormHistoryS0View:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWinterStormHistoryS0View:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIWinterStormHistoryS0View:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UIWinterStormHistoryS0View
