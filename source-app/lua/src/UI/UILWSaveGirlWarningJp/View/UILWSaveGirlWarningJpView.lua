local UILWSaveGirlWarningJpView = BaseClass("UILWSaveGirlWarningJpView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local effectPath = "Assets/_Art_LastWar/Effect/Prefab/UI/Eff_ui_icon_trail.prefab"
local bg_path = "Bg"
local node_path = "Bg/node"
local tip1_path = "Bg/node/tip1"
local tip2_path = "Bg/node/tip2"
local tip3_path = "Bg/node/tip3"

function UILWSaveGirlWarningJpView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILWSaveGirlWarningJpView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWSaveGirlWarningJpView:OnAddListener()
  base.OnAddListener(self)
end

function UILWSaveGirlWarningJpView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSaveGirlWarningJpView:ComponentDefine()
  self.bg = self:AddComponent(UIButton, bg_path)
  self.node = self:AddComponent(UIBaseContainer, node_path)
  self.tip1 = self:AddComponent(UITextMeshProUGUIEx, tip1_path)
  self.tip2 = self:AddComponent(UITextMeshProUGUIEx, tip2_path)
  self.tip3 = self:AddComponent(UITextMeshProUGUIEx, tip3_path)
  self.tip1:SetText(Localization:GetString("save_girl_tips_1"))
  self.tip2:SetText(Localization:GetString("save_girl_tips_2"))
  self.tip3:SetText(Localization:GetString("save_girl_tips_3"))
  self.bg:SetOnClick(function()
    self:OnClick()
  end)
end

function UILWSaveGirlWarningJpView:DataDefine()
end

function UILWSaveGirlWarningJpView:ComponentDestroy()
  self.bg = nil
  self.node = nil
  self.tip1 = nil
  self.tip2 = nil
  self.tip3 = nil
end

function UILWSaveGirlWarningJpView:DataDestroy()
  self:ClearDelay()
end

function UILWSaveGirlWarningJpView:ReInit()
  self:ClearDelay()
  local param = self:GetUserData()
  local guide = param.guide or false
  self.click = param.click or false
  local startPos = self.node.transform.position
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSaveGirlWarningJp, {anim = false})
    if self.click then
      return
    end
    EventManager:GetInstance():Broadcast(EventId.SaveGirlPreFly)
    local endPos
    local view = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
    if view then
      endPos = view.View:GetSavePos(UIMainSavePosType.SaveGirlWarning)
    end
    if endPos then
      UIManager:GetInstance():EnableInteractionBlocker(2, 2.1)
      UIUtil.DoFlySimpleFunc(effectPath, startPos, endPos, 2, nil, function()
        EventManager:GetInstance():Broadcast(EventId.SaveGirlMainUIRefresh)
        EventManager:GetInstance():Broadcast(EventId.SaveGirlMainUIEffect)
        if guide then
          UIManager:GetInstance():EnableInteractionBlocker(2, 1)
          TimerManager:GetInstance():DelayInvoke(function()
            EventManager:GetInstance():Broadcast(EventId.MainUIBottomShow)
            GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILD_RADAR, true)
          end, 1)
        end
      end)
    end
  end, 3)
end

function UILWSaveGirlWarningJpView:ClearDelay()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

function UILWSaveGirlWarningJpView:OnClick()
  if not self.click then
    return
  end
  self.ctrl:CloseSelf()
end

return UILWSaveGirlWarningJpView
