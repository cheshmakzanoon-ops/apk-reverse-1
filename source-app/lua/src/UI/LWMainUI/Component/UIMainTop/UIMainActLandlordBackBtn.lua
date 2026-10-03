local UIMainActLandlordBackBtn = BaseClass("UIMainActLandlordBackBtn", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""

function UIMainActLandlordBackBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMainActLandlordBackBtn:OnDestroy()
  base.OnDestroy(self)
end

function UIMainActLandlordBackBtn:ComponentDefine()
  self.backBtn = self:AddComponent(UIButton, this_path)
  self.backBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UIMainActLandlordBackBtn:ReInit()
  self:RefreshBtn()
end

function UIMainActLandlordBackBtn:RefreshBtn()
  local active = true
  if not DataCenter.LandlordMgr:IsInMyServerGroup() then
    active = false
  end
  if BattleFieldUtil.InBattleField() or not SceneUtils.GetIsInWorld() then
    active = false
  end
  local curServerId = LuaEntry.Player:GetCurServerId()
  local centerServerId = DataCenter.LandlordMgr:GetCenterServerId()
  if curServerId ~= centerServerId then
    active = false
  end
  local isLLBattleStage = DataCenter.LandlordMgr:IsInNewCenterMapPeriod()
  if not isLLBattleStage then
    active = false
  end
  local curStageId = DataCenter.LandlordMgr:GetActCurStage()
  if curStageId == LLConst.LandlordStage.NONE or curStageId == LLConst.LandlordStage.PREVIEW or curStageId == LLConst.LandlordStage.ENDED then
    active = false
  end
  self:SetActive(active)
end

function UIMainActLandlordBackBtn:OnBtnClick()
  DataCenter.LandlordMgr:TryHideMainWindow()
end

function UIMainActLandlordBackBtn:OnAddListener()
  base.OnAddListener(self)
end

function UIMainActLandlordBackBtn:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UIMainActLandlordBackBtn
