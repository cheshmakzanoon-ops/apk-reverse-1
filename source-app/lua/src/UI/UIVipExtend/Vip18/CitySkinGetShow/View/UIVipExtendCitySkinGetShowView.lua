local UIVipExtendCitySkinGetShowView = BaseClass("UIVipExtendCitySkinGetShowView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local big_title_path = "bigTitle"
local small_title_path = "smallTitle"
local bg_path = "bg"
local HIDE_PANEL_ANI_TIME = 2

function UIVipExtendCitySkinGetShowView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnReInit()
end

function UIVipExtendCitySkinGetShowView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIVipExtendCitySkinGetShowView:ComponentDefine()
  self.big_title = self:AddComponent(UITextMeshProUGUIEx, big_title_path)
  self.small_title = self:AddComponent(UITextMeshProUGUIEx, small_title_path)
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg:SetOnClick(function()
    self:OnBgClick()
  end)
  self.big_title:SetLocalText("vip_base_skin_desc9")
  self.small_title:SetLocalText("vip_base_skin_desc10")
  self.animator = self.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
end

function UIVipExtendCitySkinGetShowView:ComponentDestroy()
  self.big_title = nil
  self.small_title = nil
end

function UIVipExtendCitySkinGetShowView:DataDefine()
end

function UIVipExtendCitySkinGetShowView:DataDestroy()
end

function UIVipExtendCitySkinGetShowView:OnAddListener()
  base.OnAddListener(self)
end

function UIVipExtendCitySkinGetShowView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIVipExtendCitySkinGetShowView:OnReInit()
end

function UIVipExtendCitySkinGetShowView:OnBgClick()
  self.animator:Play("UIVipExtendCitySkinGetShowOut", -1, 0)
  self.animator:Update(0)
  TimerManager:GetInstance():DelayInvoke(function()
    if IsNull(self.gameObject) or self.animator == nil then
      return
    end
    local skinId, skinInfo = DataCenter.VipExtendManager:GetCacheSkinData()
    local skinData = DataCenter.DecorationDataManager:GetSkinDataById(skinId)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVipExtendCitySkinDetailShow, {anim = true}, skinInfo)
    self.ctrl:CloseSelf()
  end, HIDE_PANEL_ANI_TIME)
end

return UIVipExtendCitySkinGetShowView
