local base = UIAsyncContainer
local UIMainBLBtnMeteoriteMoveCity = BaseClass("UIMainBLBtnMeteoriteMoveCity", base)
local Localization = CS.GameEntry.Localization

function UIMainBLBtnMeteoriteMoveCity:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainBLBtnMeteoriteMoveCity:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainBLBtnMeteoriteMoveCity:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btn = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.textTmpCountdown = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compMoveEff = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.cbMoveCity = Bind(self, self.TryMoveCity)
end

function UIMainBLBtnMeteoriteMoveCity:ComponentDestroy()
  self.viewSkin = nil
  self.btn = nil
  self.textTmpCountdown = nil
  self.compMoveEff = nil
  self.cbMoveCity = nil
end

function UIMainBLBtnMeteoriteMoveCity:DataDefine()
end

function UIMainBLBtnMeteoriteMoveCity:DataDestroy()
end

function UIMainBLBtnMeteoriteMoveCity:OnAddListener()
  base.OnAddListener(self)
end

function UIMainBLBtnMeteoriteMoveCity:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIMainBLBtnMeteoriteMoveCity:OnBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWActMeteoriteMoveCity, {anim = true}, {
    cdEndTime = 0,
    callback = self.cbMoveCity
  })
end

function UIMainBLBtnMeteoriteMoveCity:TryMoveCity()
  local pointId = DataCenter.ActMeteoriteBattleManager:GetMeteoriteCenterPointIndex()
  MoveCityUtil.OnClickMoveCity(LuaEntry.Player:GetCurServerId(), pointId)
end

function UIMainBLBtnMeteoriteMoveCity:Update1000MS()
  self:RefreshCd()
end

function UIMainBLBtnMeteoriteMoveCity:OnEnable()
  base.OnEnable(self)
  self:RefreshCd()
end

function UIMainBLBtnMeteoriteMoveCity:RefreshCd()
  local time = MeteoriteBattleUtils.GetFreeMoveCdTime()
  if 0 < time then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local gap = time - curTime
    if gap < 0 then
      if self.showCd ~= false then
        self.textTmpCountdown:SetActive(false)
        self.compMoveEff:SetActive(true)
        self.showCd = false
      end
      return
    end
    if self.showCd ~= true then
      self.textTmpCountdown:SetActive(true)
      self.compMoveEff:SetActive(false)
      self.showCd = true
    end
    self.textTmpCountdown:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutHour(gap / 1000))
  elseif self.showCd ~= false then
    self.textTmpCountdown:SetActive(false)
    self.compMoveEff:SetActive(true)
    self.showCd = false
  end
end

return UIMainBLBtnMeteoriteMoveCity
