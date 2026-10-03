local DisguiseArmyTip = BaseClass("DisguiseArmyTip", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWUIMasterySkillCell = require("UI.LWUIMastery.Component.LWUIMasterySkillCell")
local prefabPath = "Assets/Main/Prefabs/UI/UIMastery/LWUIMasterySkillCell.prefab"
local common_img_tipsarrow = "common_img_tipsarrow"
local l_w_u_i_mastery_skill_cell_path = "bg/LWUIMasterySkillCell"
local name_txt_path = "bg/nameTxt"
local desc_txt_path = "bg/descTxt"
local enter_btn_path = "bg/enterBtn"
local enter_txt_path = "bg/enterBtn/enterTxt"
local time_txt_path = "bg/enterBtn/timeTxt"
local skill_cell_parent_path = "bg/skillCellParent"

function DisguiseArmyTip:OnCreate()
  base.OnCreate(self)
  self.name_txt = self:AddComponent(UITextMeshProUGUIEx, name_txt_path)
  self.desc_txt = self:AddComponent(UITextMeshProUGUIEx, desc_txt_path)
  self.enter_btn = self:AddComponent(UIButton, enter_btn_path)
  self.enter_btn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.enter_txt = self:AddComponent(UITextMeshProUGUIEx, enter_txt_path)
  self.enter_txt:SetLocalText(150122)
  self.time_txt = self:AddComponent(UITextMeshProUGUIEx, time_txt_path)
  self.common_img_tipsarrow = self:AddComponent(UIBaseContainer, common_img_tipsarrow)
  self.skillCellParent = self:AddComponent(UIBaseContainer, skill_cell_parent_path)
end

function DisguiseArmyTip:OnDestroy()
  if self.cellItem ~= nil then
    self.cellItem:Destroy()
    self.cellItem = nil
  end
  self.l_w_u_i_mastery_skill_cell = nil
  self.name_txt = nil
  self.desc_txt = nil
  self.enter_btn = nil
  self.enter_txt = nil
  self.time_txt = nil
  self.skillCellParent = nil
  base.OnDestroy(self)
end

function DisguiseArmyTip:RefreshData(posX, posY, formationData)
  self.formationUuid = formationData.uuid
  self.common_img_tipsarrow:SetPositionXYZ(posX, posY, 0)
  if self.formationUuid ~= nil then
    local time = self.view:GetTimeInFormation(self.formationUuid)
    self.time_txt:SetText(UITimeManager:GetInstance():SecondToFmtString(time))
  end
  local skillTemplate = DataCenter.MasteryManager:GetUnlockedSkillTemplateByType(MasterySkill.CreateFakeMarch)
  if skillTemplate then
    if self.l_w_u_i_mastery_skill_cell then
      self.l_w_u_i_mastery_skill_cell:SetData(nil, skillTemplate.id)
    elseif self.cellItem == nil then
      self.cellItem = self:GameObjectInstantiateAsync(prefabPath, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        local trans = go.transform
        trans:SetParent(self.skillCellParent.transform)
        trans:Set_localScale(1, 1, 1)
        trans:Set_anchoredPosition(0, 0)
        go.name = "LWUIMasterySkillCell"
        self.go = go
        self.l_w_u_i_mastery_skill_cell = self:AddComponent(LWUIMasterySkillCell, go)
        self.l_w_u_i_mastery_skill_cell:SetData(nil, skillTemplate.id)
      end)
    end
    self.name_txt:SetLocalText(skillTemplate.name)
    self.desc_txt:SetText(skillTemplate:GetDescStr())
  end
end

function DisguiseArmyTip:OnGoClick()
  local skillTemplate = DataCenter.MasteryManager:GetUnlockedSkillTemplateByType(MasterySkill.CreateFakeMarch)
  if not skillTemplate then
    return
  end
  local param = {
    pointId = self.view.ctrl.targetPoint,
    targetUuid = self.view.ctrl.targetUuid,
    formationUuid = self.formationUuid
  }
  DataCenter.MasteryManager:SendUseSkillMsg(skillTemplate, param)
  self.view.ctrl:CloseSelf()
end

return DisguiseArmyTip
