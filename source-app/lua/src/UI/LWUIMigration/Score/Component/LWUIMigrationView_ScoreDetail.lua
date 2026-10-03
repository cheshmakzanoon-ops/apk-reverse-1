local LWUIMigrationView_ScoreDetail = BaseClass("LWUIMigrationView_ScoreDetail", UIBaseContainer)
local base = UIBaseContainer
local ContentSizeFitter = CS.UnityEngine.UI.ContentSizeFitter
local DetailItem = require("UI.LWUIMigration.Score.Component.LWUIMigrationView_ScoreDetailItem")

function LWUIMigrationView_ScoreDetail:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(BindCallback(self, self.OnCloseClick))
  self.info = self:AddComponent(UIBaseComponent, "InfoBg")
  self.arrow = self:AddComponent(UIBaseComponent, "InfoBg/Arrow")
  self.desc_content = self:AddComponent(UIBaseComponent, "InfoBg/Desc")
  self.text_desc = self:AddComponent(UIText, "InfoBg/Desc/DescText")
  self.scrollView = self:AddComponent(UIScrollView, "InfoBg/ScrollView")
  self.content = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "InfoBg/ScrollView/Viewport/Content")
  self.fitter = self.content.rectTransform:GetComponent(typeof(ContentSizeFitter))
  self.theItem = self.transform:Find("InfoBg/ScrollView/Item").gameObject
  self.theItem:GameObjectCreatePool()
  self.time_content = self:AddComponent(UIBaseComponent, "InfoBg/Time")
  self.text_time = self:AddComponent(UIText, "InfoBg/Time/TimeText")
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function LWUIMigrationView_ScoreDetail:OnDestroy()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(DetailItem)
  base.OnDestroy(self)
end

function LWUIMigrationView_ScoreDetail:OnCloseClick()
  self:SetActive(false)
end

function LWUIMigrationView_ScoreDetail:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(DetailItem, itemObj)
  cellItem:SetActive(true)
  local info = self.list[index]
  if self.type == 1 then
    cellItem:SetHero(info)
  else
    cellItem:SetSoldier(info)
  end
end

function LWUIMigrationView_ScoreDetail:OnItemMoveOut(itemObj, _)
  self.scrollView:RemoveComponent(itemObj.name, DetailItem)
end

function LWUIMigrationView_ScoreDetail:SetData(target, type)
  if type ~= 1 and type ~= 4 then
    return
  end
  self.type = type
  self:SetActive(true)
  self:UpdateInfo(type)
  self:UpdatePos(target)
end

function LWUIMigrationView_ScoreDetail:UpdateInfo(type)
  local info = DataCenter.ActMigrationManager:GetScoreInfo()
  self.text_desc:SetLocalText(type == 1 and "migration_activity_interface_10025" or "migration_activity_interface_10026")
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.desc_content.rectTransform)
  local list = type == 1 and info.heroPowerArray or info.armyPowerArray
  self.list = list
  local length = #list
  self.scrollView:SetActive(0 < length)
  if 0 < length then
    self.fitter.horizontalFit = type == 1 and ContentSizeFitter.FitMode.PreferredSize or ContentSizeFitter.FitMode.Unconstrained
    self.content:SetSpacing(type == 1 and 5 or 40)
    self.content.unity_horizontalOrVerticalLayoutGroup.childForceExpandWidth = type == 1
    if type ~= 1 then
      local size = self.scrollView:GetSizeDelta()
      self.content:SetSizeDeltaX(size.x)
    end
    self.scrollView:SetTotalCount(length)
    self.scrollView:RefillCells()
    self.scrollView:ScrollToCell(1, 500)
  end
  local time = type == 1 and info.heroPowerUpdateTime or info.armyPowerUpdateTime
  local timeStr = UITimeManager:GetInstance():TimeStampToTimeForServer(time)
  self.text_time:SetLocalText("migration_activity_interface_10105", timeStr)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.time_content.rectTransform)
end

function LWUIMigrationView_ScoreDetail:UpdatePos(target)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.info.rectTransform)
  local _, tY, _ = target:GetPositionXYZ()
  local reversal = tY < Screen.height / 3
  self.info:SetAnchorMinXY(1, reversal and 0 or 1)
  self.info:SetAnchorMaxXY(1, reversal and 0 or 1)
  self.info:SetPivotXY(1, reversal and 0 or 1)
  local x, y, z = self.info:GetPositionXYZ()
  y = tY + (reversal and 30 or -30)
  self.info:SetPositionXYZ(x, y, z)
  self.arrow:SetAnchorMinXY(1, reversal and 0 or 1)
  self.arrow:SetAnchorMaxXY(1, reversal and 0 or 1)
  self.arrow:SetLocalScaleXYZ(1, reversal and -1 or 1, 1)
  local aX, _, aZ = self.arrow:GetPositionXYZ()
  self.arrow:SetPositionXYZ(aX, y + (reversal and 6 or -3), aZ)
end

return LWUIMigrationView_ScoreDetail
