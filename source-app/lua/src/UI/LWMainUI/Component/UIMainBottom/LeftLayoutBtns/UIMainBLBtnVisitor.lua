local UIMainBLBtnBase = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnBase")
local UIMainBLBtnVisitor = BaseClass("UIMainBLBtnVisitor", UIMainBLBtnBase)
local base = UIMainBLBtnBase

local function OnAddMainBtnListener(self)
  base.OnAddMainBtnListener(self)
  self:AddUIListener(EventId.RefreshVisitorBtnState, self.Refresh)
  self:AddUIListener(EventId.OnEnterCity, self.Refresh)
end

local function OnRemoveMainBtnListener(self)
  base.OnRemoveMainBtnListener(self)
  self:RemoveUIListener(EventId.RefreshVisitorBtnState, self.Refresh)
  self:RemoveUIListener(EventId.OnEnterCity, self.Refresh)
end

local function OnClick(self)
  self.commonRedPoint:SetViewed()
  local data = DataCenter.CityVisitorManager:GetFristVisitorData()
  if data and data:GetEndPos() then
    local pos = data:GetEndPos()
    GoToUtil.GotoPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      local param = {
        position = CS.CSUtils.WorldPositionToUISpacePosition(pos),
        positionType = PositionType.Screen,
        useLiteAnim = true,
        arrowType = ArrowType.CityNpc
      }
      DataCenter.ArrowManager:ShowArrow(param)
    end)
  end
end

local function CheckEnable(self)
  local unlock = self:CheckUnlock()
  local num = self:RefreshRedDotNum()
  return unlock and 0 < num
end

local function Refresh(self)
  base.Refresh(self)
  if not IsNull(self.gameObject) and self.gameObject.activeSelf and CommonUtil.PlayerPrefsGetInt("MAIN_UI_VISITOR_BTN_GUIDE", 0) == 0 then
    CommonUtil.PlayerPrefsSetInt("MAIN_UI_VISITOR_BTN_GUIDE", 1)
    local fingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
    fingerHandle:completed("+", function(handle)
      if handle.isError then
        return
      end
      CommonUtil.CallAutoArabicMirrorManually(handle)
      local gameObject = handle.gameObject
      local transform = gameObject.transform
      transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Guide.Name).transform, false)
      transform.position = self.transform.position
      TimerManager:GetInstance():DelayInvoke(function()
        fingerHandle:Destroy()
      end, 3)
    end)
  end
end

UIMainBLBtnVisitor.OnClick = OnClick
UIMainBLBtnVisitor.OnAddMainBtnListener = OnAddMainBtnListener
UIMainBLBtnVisitor.OnRemoveMainBtnListener = OnRemoveMainBtnListener
UIMainBLBtnVisitor.CheckEnable = CheckEnable
UIMainBLBtnVisitor.Refresh = Refresh
return UIMainBLBtnVisitor
