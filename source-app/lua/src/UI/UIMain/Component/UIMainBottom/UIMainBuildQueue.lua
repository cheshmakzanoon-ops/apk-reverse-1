local UIMainTroops = BaseClass("UIMainTroops", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local common_red_point_path = "btn/CommonRedPoint"
local text_path = "btn/text"
local btn_path = "btn"
local harmer_path = "btn/icon"
local EMPTY_ICON = "Assets/Main/Sprites/UI/UIBuildQueue/zyf_chengjian_dikuai.png"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.view:RegisterFunctionUnlock(LWFunctionUnlockType.MainUI_BuildQueue, self.gameObject)
  self.commonRedPoint = self:AddComponent(UICommonRedPoint, common_red_point_path)
  self.commonRedPoint:SetType(CommonRedPointPriority.LevelNormal)
  self.commonRedPoint:SetId(CommonRedPointId.MainUI_BuildQueue)
  self.text = self:AddComponent(UIText, text_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.harmer = self:AddComponent(UIBaseContainer, harmer_path)
  self.btn:SetOnClick(BindCallback(self, self.OnClickView))
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshUIBuildQueue, self.Refresh)
  self:AddUIListener(EventId.ShowBuildQueueTip, self.ShowBubble)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshUIBuildQueue, self.Refresh)
  self:RemoveUIListener(EventId.ShowBuildQueueTip, self.ShowBubble)
end

local function Refresh(self)
  if SceneUtils.GetIsInWorld() then
    self.gameObject:SetActive(false)
    return
  end
  local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_BuildQueue)
  self.gameObject:SetActive(unlock and DataCenter.BuildQueueManager:CheckMainUICanShow())
  if unlock then
    self.commonRedPoint:SetDefaultVisible(DataCenter.BuildQueueManager:GetFreeQueueUuid() > 0)
    local isInUnlimitedMode = DataCenter.BuildQueueManager:IsInUnlimitedMode()
    if isInUnlimitedMode then
      self.text:SetText(string.format("%d/%s", DataCenter.BuildQueueManager:GetOccupideQueueNum(), "\226\136\158"))
    else
      self.text:SetText(string.format("%d/%d", DataCenter.BuildQueueManager:GetOccupideQueueNum(), DataCenter.BuildQueueManager:GetAllCanUseQueueNum()))
    end
  end
end

local function OnClickView(self)
  self.commonRedPoint:SetViewed()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildQueue)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self:Refresh()
end

local function ShowBubble(self)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UILWWorkerQueue)
  if window == nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorkerQueue)
  end
end

local function CloseBubble(self)
end

UIMainTroops.OnDestroy = OnDestroy
UIMainTroops.OnCreate = OnCreate
UIMainTroops.ComponentDefine = ComponentDefine
UIMainTroops.DataDestroy = DataDestroy
UIMainTroops.ComponentDestroy = ComponentDestroy
UIMainTroops.DataDefine = DataDefine
UIMainTroops.OnEnable = OnEnable
UIMainTroops.OnDisable = OnDisable
UIMainTroops.OnClickView = OnClickView
UIMainTroops.ReInit = ReInit
UIMainTroops.Refresh = Refresh
UIMainTroops.OnAddListener = OnAddListener
UIMainTroops.OnRemoveListener = OnRemoveListener
UIMainTroops.ShowBubble = ShowBubble
UIMainTroops.CloseBubble = CloseBubble
return UIMainTroops
