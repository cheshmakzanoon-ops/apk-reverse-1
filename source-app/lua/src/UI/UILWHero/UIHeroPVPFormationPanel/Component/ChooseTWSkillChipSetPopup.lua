local ChooseTWSkillChipSetPopup = BaseClass("ChooseTWSkillChipSetPopup", UIBaseContainer)
local base = UIBaseContainer
local TWSkillChipSetRow = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.TWSkillChipSetRow")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local ArmyFormationUtils = require("DataCenter.ArmyFormationData.ArmyFormationUtils")
local Localization = CS.GameEntry.Localization
local btn_close_path = "btnClose"
local img_bg_path = "imgBg"
local img_arrow_path = "imgBg/imgArrow"
local modify_chip_set_btn_path = "imgBg/Function/ModifyChipSetBtn"
local container_path = "imgBg/Container"

function ChooseTWSkillChipSetPopup:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChooseTWSkillChipSetPopup:OnDestroy()
  self.squadData = nil
  self.formationType = nil
  if self.imgBg then
    local trTransform = self.imgBg.transform
    DOTween.Kill(trTransform)
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChooseTWSkillChipSetPopup:ComponentDefine()
  self.btnClose = self:AddComponent(UIButton, btn_close_path)
  self.btnClose:SetOnClick(function()
    self:SetActive(false)
  end)
  self.imgBg = self:AddComponent(UIImage, img_bg_path)
  self.imgArrow = self:AddComponent(UIImage, img_arrow_path)
  self.modifyChipSetBtn = self:AddComponent(UIButton, modify_chip_set_btn_path)
  self.modifyChipSetBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {anim = true}, TacticalWeaponPageType.SkillChip)
  end)
  self.container = self:AddComponent(UIBaseContainer, container_path)
end

function ChooseTWSkillChipSetPopup:ComponentDestroy()
end

function ChooseTWSkillChipSetPopup:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TWSkillUpdate, self.Refresh)
end

function ChooseTWSkillChipSetPopup:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.TWSkillUpdate, self.Refresh)
end

function ChooseTWSkillChipSetPopup:SetPosition(x, y)
  if self.imgBg then
    self.imgBg:SetPositionXYZ(x, y, 0)
  end
end

function ChooseTWSkillChipSetPopup:ClearSetLines()
  self.container:RemoveComponents(TWSkillChipSetRow)
  if self.setReqs then
    for _, req in pairs(self.setReqs) do
      self:GameObjectDestroy(req)
    end
  end
  self.setReqs = {}
end

function ChooseTWSkillChipSetPopup:RefreshLines()
  self:ClearSetLines()
  local sets = TacticalWeaponUtils.GetFormationSets(self.formationType, self.squadData)
  for i, setData in pairs(sets) do
    local req = self:GameObjectInstantiateAsync(UIAssets.UILWTWSkillChipSetLine, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.container.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.name = "set" .. i
      local cell = self.container:AddComponent(TWSkillChipSetRow, go.name)
      cell:SetCallBack(function(idx)
        if self.callback then
          self.callback(idx)
        end
        self:SetActive(false)
      end)
      cell:SetIndex(i, i == 1)
      if setData.unlock then
        if setData.id == self.squadData:GetLocalTWSkillChipSetId() then
          cell:SetCheck()
        elseif setData.formationId > 0 then
          cell:SetUsing(setData.formationId)
        else
          cell:SetUnuse()
        end
      else
        cell:SetLocked()
      end
    end)
    table.insert(self.setReqs, req)
  end
end

function ChooseTWSkillChipSetPopup:Popup(callback, squadData, formationType)
  self.callback = callback
  self.squadData = squadData
  self.formationType = formationType
  self:SetActive(true)
  if self.imgBg then
    local trTransform = self.imgBg.transform
    DOTween.Kill(trTransform)
    trTransform:Set_localScale(0, 0, 0)
    trTransform:DOScale(Vector3.New(1.05, 1.05, 0), 0.1):OnComplete(function()
      trTransform:DOScale(Vector3.one, 0.1)
    end):SetEase(CS.DG.Tweening.Ease.InOutCubic)
  end
end

function ChooseTWSkillChipSetPopup:Refresh()
  self:RefreshLines()
end

function ChooseTWSkillChipSetPopup:OnEnable()
  base.OnEnable(self)
  self:RefreshLines()
end

return ChooseTWSkillChipSetPopup
