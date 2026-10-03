local ValentineSuccessUpgradeView = BaseClass("ValentineSuccessUpgradeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local ani_root_path = "bg/AniRoot"
local close_btn_path = "bg/CloseBtn"
local RANK_UPGRADE_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/UIActValentineStageUpgrade_%s.prefab"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local param = self:GetUserData()
  self.prevRankData = param.prevRankData
  self.curRankData = param.curRankData
  self.closeFunc = param.closeFunc
  self:ReInit()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.aniPointObj = self:AddComponent(UIBaseContainer, ani_root_path)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self:ClosePanel()
  end)
end

local function ComponentDestroy(self)
  if self.showTimer then
    self.showTimer:Stop()
    self.showTimer = nil
  end
  if self.fadeTimer then
    self.fadeTimer:Stop()
    self.fadeTimer = nil
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function ValentineSuccessUpgradeView:ReInit()
  if not self.prevRankData then
    return
  end
  local rank = self.prevRankData.type
  rank = Mathf.Clamp(rank, 1, 4)
  local path = string.format(RANK_UPGRADE_PATH, rank)
  local request = ResourceManager:InstantiateAsync(path)
  self.request = request
  self.request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject.transform:SetParent(self.aniPointObj.transform)
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    request.gameObject.transform:Set_anchorMin(0, 0)
    request.gameObject.transform:Set_anchorMax(1, 1)
    request.gameObject.transform:Set_offsetMin(0, 0)
    request.gameObject.transform:Set_offsetMax(0, 0)
    local titleText = request.gameObject.transform:Find("TitleText"):GetComponentInChildren(typeof(CS.TextMeshProUGUIEx))
    if self.curRankData then
      titleText:SetLocalText(self.curRankData.key_big)
    end
    self.animator = request.gameObject.transform:Find(""):GetComponentInChildren(typeof(CS.UnityEngine.Animator))
  end)
  if self.showTimer then
    self.showTimer:Stop()
    self.showTimer = nil
  end
  self.showTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.showTimer = nil
  end, 4)
end

function ValentineSuccessUpgradeView:ClosePanel()
  if self.showTimer then
    return
  end
  if self.fadeTimer then
    return
  end
  
  local function closeFunc()
    self.ctrl:CloseSelf()
    if self.closeFunc then
      self.closeFunc()
    end
  end
  
  if not self.animator then
    closeFunc()
    return
  end
  self.animator:SetTrigger("FadeOut")
  self.fadeTimer = TimerManager:GetInstance():DelayInvoke(function()
    closeFunc()
    self.fadeTimer = nil
  end, 0.64)
end

ValentineSuccessUpgradeView.OnCreate = OnCreate
ValentineSuccessUpgradeView.OnDestroy = OnDestroy
ValentineSuccessUpgradeView.OnEnable = OnEnable
ValentineSuccessUpgradeView.OnDisable = OnDisable
ValentineSuccessUpgradeView.ComponentDefine = ComponentDefine
ValentineSuccessUpgradeView.ComponentDestroy = ComponentDestroy
ValentineSuccessUpgradeView.DataDefine = DataDefine
ValentineSuccessUpgradeView.DataDestroy = DataDestroy
ValentineSuccessUpgradeView.OnAddListener = OnAddListener
ValentineSuccessUpgradeView.OnRemoveListener = OnRemoveListener
return ValentineSuccessUpgradeView
