local base = UIAsyncContainer
local LLMiniMapProgressLP = BaseClass("LLMiniMapProgressLP", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function LLMiniMapProgressLP:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMiniMapProgressLP:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMiniMapProgressLP:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compLine = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
end

function LLMiniMapProgressLP:ComponentDestroy()
  self.viewSkin = nil
  self.compLine = nil
end

function LLMiniMapProgressLP:DataDefine()
  self.compLine:SetActive(false)
end

function LLMiniMapProgressLP:DataDestroy()
  self.target = nil
end

function LLMiniMapProgressLP:OnAddListener()
  base.OnAddListener(self)
end

function LLMiniMapProgressLP:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLMiniMapProgressLP:SetTarget(target)
  self.target = target
  self:RefreshView()
end

function LLMiniMapProgressLP:UpdateData()
  if self.target == nil then
    return
  end
  local sPos = self:GetAnchoredPosition()
  local tPos = self.target:GetAnchoredPosition()
  self.compLine:SetActive(true)
  local sizeX, _ = self.compLine:GetSizeDeltaXY()
  local length = math.floor(Vector2.Distance(sPos, tPos))
  self.compLine:SetSizeDeltaXY(sizeX, length + 2)
  local eulerAngleZ
  if CommonUtil.IsArabicAutoMirrorOpen() then
    eulerAngleZ = math.deg(math.atan(sPos.y - tPos.y, tPos.x - sPos.x)) - 90
  else
    eulerAngleZ = math.deg(math.atan(sPos.y - tPos.y, sPos.x - tPos.x)) - 90
  end
  self.compLine:SetEulerAnglesXYZ(0, 0, eulerAngleZ)
end

return LLMiniMapProgressLP
