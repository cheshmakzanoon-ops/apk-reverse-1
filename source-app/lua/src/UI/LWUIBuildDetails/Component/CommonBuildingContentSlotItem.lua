local CommonBuildingContentSlotItem = BaseClass("CommonBuildingContentSlotItem", UIBaseContainer)
local base = UIBaseContainer
local UIWorkerShowCell = require("UI.UILWWorker.UIWorkerOverviewList.Component.UIWorkerShowCell")
local herocell_path = "herocell"
local u_i_empty_cell_path = "UIEmptyCell"
local addImg_path = "UIEmptyCell/Root/Bg/LayerNormal/ImgBg/addImg"
local red_point_path = "redPoint"
local u_i_worker_show_cell_path = "herocell/InfoPanel/UIWorkerShowCell"
local job_name_path = "herocell/InfoPanel/jobName"
local change_btn_path = "herocell/InfoPanel/changeBtn"

function CommonBuildingContentSlotItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function CommonBuildingContentSlotItem:OnDestroy()
  self:CloseAniSeq()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CommonBuildingContentSlotItem:DataDefine()
  self.param = nil
  self.aniSeq = nil
  self.recordVal = nil
end

function CommonBuildingContentSlotItem:DataDestroy()
  self.param = nil
  self.aniSeq = nil
  self.recordVal = nil
end

function CommonBuildingContentSlotItem:ComponentDefine()
  self.herocell = self:AddComponent(UIBaseContainer, herocell_path)
  self.u_i_worker_show_cell = self:AddComponent(UIWorkerShowCell, u_i_worker_show_cell_path)
  self.job_name = self:AddComponent(UITextMeshProUGUIEx, job_name_path)
  self.change_btn = self:AddComponent(UIButton, change_btn_path)
  self.u_i_empty_cell = self:AddComponent(UIBaseContainer, u_i_empty_cell_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.root = self:AddComponent(UIButton, "")
  self.ani = self:AddComponent(UIAnimator, herocell_path)
  self.addImg = self:AddComponent(UIImage, addImg_path)
  self.root:SetOnClick(function()
    self:OnRootBtnClick()
  end)
  self.change_btn:SetOnClick(function()
    self:OnChangeBtnClick()
  end)
end

function CommonBuildingContentSlotItem:ComponentDestroy()
  self.herocell = nil
  self.u_i_worker_show_cell = nil
  self.job_name = nil
  self.change_btn = nil
  self.u_i_empty_cell = nil
  self.red_point = nil
  self.root = nil
end

function CommonBuildingContentSlotItem:ReInit(param)
  self.param = param
  self:CloseAniSeq()
  if param.type == BuildDisPatchingHeroTrenchState.HERO then
    self.ani:Play("New State")
  end
  self.herocell:SetActive(param.type == BuildDisPatchingHeroTrenchState.HERO)
  self.u_i_empty_cell:SetActive(param.type ~= BuildDisPatchingHeroTrenchState.HERO)
  if param.type == BuildDisPatchingHeroTrenchState.HERO then
    self:ShowHeroInfo()
  elseif param.type == BuildDisPatchingHeroTrenchState.ADD then
  elseif param.type == BuildDisPatchingHeroTrenchState.LOCK then
  end
  self:BuildRefreshRedDot()
end

function CommonBuildingContentSlotItem:BuildRefreshRedDot()
  local isOn = self.param.curBuildData:CheckBuildingWorkerSlotRedDot(self.param.index)
  self.red_point:SetActive(isOn)
end

function CommonBuildingContentSlotItem:ShowHeroInfo()
  self.job_name:SetLocalText(self.param.workerData.firstName)
  self.u_i_worker_show_cell:SetData(self.param.workerData.cfgId, self.param.workerData.rank)
end

function CommonBuildingContentSlotItem:OnChangeBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerInfoDetail, {anim = true}, self.param.workerData.cfgId, self.param.workerData)
end

function CommonBuildingContentSlotItem:OnRootBtnClick()
  if self.param.type == BuildDisPatchingHeroTrenchState.ADD or self.param.type == BuildDisPatchingHeroTrenchState.HERO then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildHeroList, self.param.curBuildIndex, self.param.index - 1)
  end
end

function CommonBuildingContentSlotItem:CloseAniSeq()
  if self.aniSeq ~= nil then
    self.aniSeq:Kill()
    self.aniSeq = nil
  end
end

function CommonBuildingContentSlotItem:RecordCurVal()
  self.recordVal = nil
  if self.param.type == BuildDisPatchingHeroTrenchState.HERO then
    self.recordVal = self.param.workerData.uid
  end
end

function CommonBuildingContentSlotItem:IsNeedPlayAni()
  local isNeed = false
  if self.param.type == BuildDisPatchingHeroTrenchState.HERO and self.param.workerData.uid ~= self.recordVal then
    isNeed = true
  end
  return isNeed
end

function CommonBuildingContentSlotItem:TryPlayAni(delayTime)
  self:CloseAniSeq()
  self.herocell:SetActive(false)
  self.u_i_empty_cell:SetActive(false)
  self.aniSeq = DOTween.Sequence()
  self.aniSeq:AppendInterval(delayTime)
  self.aniSeq:AppendCallback(function()
    self.herocell:SetActive(true)
    self.ani:Play("Eff_ui_anim_UI_LWUBuildDetails_fangkuang_01")
  end)
  self.aniSeq:OnComplete(function()
    self:CloseAniSeq()
  end)
end

return CommonBuildingContentSlotItem
