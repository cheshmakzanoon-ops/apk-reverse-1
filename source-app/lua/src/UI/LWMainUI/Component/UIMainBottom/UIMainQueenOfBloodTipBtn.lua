local UIMainQueenOfBloodTipBtn = BaseClass("UIMainQueenOfBloodTipBtn", UIBaseContainer)
local base = UIBaseContainer

function UIMainQueenOfBloodTipBtn:OnCreate()
  base.OnCreate(self)
  self.tip = self:AddComponent(UIBaseComponent, "Tip")
  self.tipText = self:AddComponent(UIText, "Tip/TipText")
  self.tip:SetActive(false)
  self.tipText:SetLocalText("s1_QueenChallenge_cannonAppear")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self.tip:SetActive(false)
    local point = DataCenter.OffSeason1QueenOfBloodManager:GetGunnerJumpPoint()
    if point == nil then
      self:SetActive(false)
      return
    end
    local v3 = SceneUtils.TileIndexToWorld(point, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, LuaEntry.Player:GetSourceServerId())
  end)
end

function UIMainQueenOfBloodTipBtn:OnDestroy()
  self.tip = nil
  self.tipText = nil
  self.btn = nil
  base.OnDestroy(self)
end

function UIMainQueenOfBloodTipBtn:OnEnable()
  base.OnEnable(self)
end

function UIMainQueenOfBloodTipBtn:OnDisable()
  self:ClearTimer()
  base.OnDisable(self)
end

function UIMainQueenOfBloodTipBtn:Refresh(needShowTip)
  local point = DataCenter.OffSeason1QueenOfBloodManager:GetGunnerJumpPoint()
  if point == nil then
    self:SetActive(false)
    return
  end
  local curScene = CS.SceneManager.CurrSceneID
  if curScene == SceneManagerSceneID.World then
    self:SetActive(true)
    self.tip:SetActive(needShowTip)
    if needShowTip then
      self:ClearTimer()
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        self.timer = nil
        if self.tip then
          self.tip:SetActive(false)
        end
      end, 5)
    end
  else
    self:SetActive(false)
  end
end

function UIMainQueenOfBloodTipBtn:ClearTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

return UIMainQueenOfBloodTipBtn
