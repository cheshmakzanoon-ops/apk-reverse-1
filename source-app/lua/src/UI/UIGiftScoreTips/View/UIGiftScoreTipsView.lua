local UIGiftScoreTipsView = BaseClass("UIGiftScoreTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Pivot_Max = 1.1
local Pivot_Min = -0.1
local Pivot_Mid = 0.5
local _cp_btnGo = "root/Btn_Go"
local _cp_txtGO = "root/Btn_Go/Txt_Go"
local _cp_txtTop = "root/Rect_Top/Txt_Top"
local _cp_txtTip = "root/TipTextBg/TipText"
local _cp_btnBg = "Panel"
local _cp_root = "root"
local _cp_imgArrow = "root/imgArrow"

function UIGiftScoreTipsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIGiftScoreTipsView:OnEnable()
  self:Init()
end

function UIGiftScoreTipsView:Init()
  local param = self:GetUserData()
  assert(param.alignObject ~= nil)
  if param.alignObject.gameObject == nil or not param.alignObject.gameObject.activeInHierarchy then
    self.ctrl:CloseSelf()
    return
  end
  self._param = param
  self._cp_txtTop:SetLocalText(320414)
  self._cp_txtTip:SetLocalText(320415)
  self._txtGo:SetLocalText(320416)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._root.transform)
  self:CheckAlign()
end

function UIGiftScoreTipsView:CheckAlign()
  local _arrowX = 0
  local _arrowY = 0
  local _rotation = 0
  local ScreenSize = CS.UnityEngine.Screen
  local ScreenWidth = ScreenSize.width
  local ScreenHeight = ScreenSize.height
  local scale = ScreenHeight / 750.0
  local _rect = self._root.rectTransform.rect
  local BgWidth = _rect.width * scale
  local BgHeight = _rect.height * scale
  local alignObject = self._param.alignObject
  local _screenPos = PosConverse.WorldToScreenPos(alignObject.transform.position)
  local objWidth = alignObject.rectTransform.rect.width * scale
  local pivot = Vector2.New(0.5, 0.5)
  if ScreenWidth < _screenPos.x + objWidth * 0.4 + BgWidth then
    pivot.x = Pivot_Max
    _arrowX = BgWidth / scale * 0.5 + 3
  else
    pivot.x = Pivot_Min
    _arrowX = -BgWidth / scale * 0.5 - 3
  end
  if _screenPos.y - BgHeight * 0.5 < 50 then
    pivot.y = Pivot_Min
    _arrowY = -BgHeight / scale * 0.5 - 2
  elseif _screenPos.y + BgHeight * 0.5 > ScreenHeight - 50 then
    pivot.y = Pivot_Max
    _arrowY = BgHeight / scale * 0.5 + 2
  else
    pivot.y = Pivot_Mid
  end
  if pivot.x == Pivot_Max and pivot.y == Pivot_Min then
    _rotation = 135
  elseif pivot.x == Pivot_Max and pivot.y == Pivot_Max then
    _rotation = 225
  elseif pivot.x == Pivot_Max and pivot.y == Pivot_Mid then
    _rotation = 180
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Min then
    _rotation = 45
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Max then
    _rotation = 315
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Mid then
    _rotation = 0
  end
  self._imgArrow.transform.localRotation = Quaternion.Euler(0, 0, _rotation)
  self._imgArrow.rectTransform.anchoredPosition = Vector2.New(_arrowX, _arrowY)
  self._root.rectTransform.pivot = pivot
  self._root.transform.position = alignObject.transform.position
end

function UIGiftScoreTipsView:OnClickGo()
  self.ctrl:CloseSelf()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGiftPackage) then
    EventManager:GetInstance():Broadcast(EventId.GoGiftPackagePop, WelfareTagType.CumulativeRecharge)
  else
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoGiftPackView(nil, WelfareTagType.CumulativeRecharge)
  end
end

function UIGiftScoreTipsView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGiftScoreTipsView:ComponentDefine()
  self._btn = self:AddComponent(UIButton, _cp_btnBg)
  self._btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._cp_btnGo = self:AddComponent(UIButton, _cp_btnGo)
  self._cp_btnGo:SetOnClick(function()
    self:OnClickGo()
  end)
  self._txtGo = self:AddComponent(UIText, _cp_txtGO)
  self._cp_txtTop = self:AddComponent(UIText, _cp_txtTop)
  self._cp_txtTip = self:AddComponent(UIText, _cp_txtTip)
  self._root = self:AddComponent(UIBaseContainer, _cp_root)
  self._imgArrow = self:AddComponent(UIBaseContainer, _cp_imgArrow)
end

function UIGiftScoreTipsView:ComponentDestroy()
  self._btn = nil
  self._txtName = nil
  self._txtDesc = nil
end

return UIGiftScoreTipsView
