local LWUITCExpGetView = BaseClass("LWUITCExpGetView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local typeofPS = typeof(CS.UnityEngine.ParticleSystem)
local eff_ui_saiji_beijing_faguang_path = "JumpBtn/Eff_ui_saiji_beijing_faguang "
local eff_ui_saiji_jingyantiao_shanshuo_path = "JumpBtn/Eff_ui_saiji_jingyantiao_shanshuo"
local eff_ui_saiji_shengji_shuzi_faguang_path = "JumpBtn/layout/exp_icon/Eff_ui_saiji_shengji_shuzi_faguang"
local CloseWaiteTime = 1

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function LWUITCExpGetView:ReopenWithoutCreate()
  self:ReInit()
end

local function OnDestroy(self)
  self:MoveTimerAndAniSeq()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.eff_ui_saiji_beijing_faguang = self:AddComponent(UIBaseContainer, eff_ui_saiji_beijing_faguang_path)
  self.eff_ui_saiji_jingyantiao_shanshuo = self:AddComponent(UIBaseContainer, eff_ui_saiji_jingyantiao_shanshuo_path)
  self.eff_ui_saiji_shengji_shuzi_faguang = self:AddComponent(UIBaseContainer, eff_ui_saiji_shengji_shuzi_faguang_path)
  self.eff_ui_saiji_beijing_faguang_particle = self.eff_ui_saiji_beijing_faguang.gameObject:GetComponent(typeofPS)
  self.eff_ui_saiji_jingyantiao_shanshuo_particle = self.eff_ui_saiji_jingyantiao_shanshuo.gameObject:GetComponent(typeofPS)
  self.eff_ui_saiji_shengji_shuzi_faguang_particle = self.eff_ui_saiji_shengji_shuzi_faguang.gameObject:GetComponent(typeofPS)
  self.icon = self:AddComponent(UIImage, "JumpBtn/layout/exp_icon/icon")
  self.num = self:AddComponent(UIText, "JumpBtn/layout/cnt_txt")
end

local function ComponentDestroy(self)
  self.eff_ui_saiji_beijing_faguang = nil
  self.eff_ui_saiji_jingyantiao_shanshuo = nil
  self.eff_ui_saiji_shengji_shuzi_faguang = nil
end

local function DataDefine(self)
  self.aniSeq = nil
  self.closeTimer = nil
end

local function DataDestroy(self)
  self:MoveTimerAndAniSeq()
end

function LWUITCExpGetView:RefreshItem()
  self.icon:LoadSprite(DataCenter.ResourceItemDataManager:GetIconPath(self.itemId))
  self.num:SetText("+" .. string.GetFormattedSeparatorNum(self.itemCnt))
end

local function ReInit(self)
  self.itemId, self.itemCnt = self:GetUserData()
  self:RefreshItem()
  self:TryState()
end

local function TryState(self)
  self:MoveTimerAndAniSeq()
  if not IsNull(self.eff_ui_saiji_beijing_faguang_particle) then
    self.eff_ui_saiji_beijing_faguang_particle:Play()
  end
  if not IsNull(self.eff_ui_saiji_jingyantiao_shanshuo_particle) then
    self.eff_ui_saiji_jingyantiao_shanshuo_particle:Play()
  end
  if not IsNull(self.eff_ui_saiji_shengji_shuzi_faguang_particle) then
    self.eff_ui_saiji_shengji_shuzi_faguang_particle:Play()
  end
  self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.view.ctrl:CloseSelf(false)
  end, CloseWaiteTime)
end

local function MoveTimerAndAniSeq(self)
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
end

LWUITCExpGetView.OnCreate = OnCreate
LWUITCExpGetView.OnDestroy = OnDestroy
LWUITCExpGetView.ComponentDefine = ComponentDefine
LWUITCExpGetView.ComponentDestroy = ComponentDestroy
LWUITCExpGetView.DataDefine = DataDefine
LWUITCExpGetView.DataDestroy = DataDestroy
LWUITCExpGetView.ReInit = ReInit
LWUITCExpGetView.TryState = TryState
LWUITCExpGetView.MoveTimerAndAniSeq = MoveTimerAndAniSeq
return LWUITCExpGetView
