local TWSkillChipSetRow = BaseClass("TWSkillChipSetRow", UIBaseContainer)
local base = UIBaseContainer
local SkillChipItem = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipItem")
local Localization = CS.GameEntry.Localization
local skill_chip_path = "SkillChip%d"
local btn_check_path = "Uncheck/ChooseBtn"
local img_check_path = "check"
local line_path = "SeperateLine"
local number_text_path = "NumberText"
local uncheck_path = "Uncheck"
local lock_icon_path = "Uncheck/LockIcon"
local using_path = "Uncheck/Using"
local using_text_path = "Uncheck/Using/UsingText"
local using_icon_path = "Uncheck/Using/UsingIcon"
local btn_path = "Btn"
local bg_path = "Bg"

function TWSkillChipSetRow:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function TWSkillChipSetRow:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TWSkillChipSetRow:ComponentDefine()
  self.skillChips = {}
  for i = 1, 4 do
    self.skillChips[i] = self:AddComponent(SkillChipItem, string.format(skill_chip_path, i))
    self.skillChips[i]:SetOnClick(function(item, chipInfo, index)
      if not chipInfo then
        return
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipDetail, {anim = true}, chipInfo, false)
    end)
  end
  self.btnCheck = self:AddComponent(UIBaseContainer, btn_check_path)
  self.imgCheck = self:AddComponent(UIImage, img_check_path)
  self.line = self:AddComponent(UIImage, line_path)
  self.numberText = self:AddComponent(UIText, number_text_path)
  self.lockIcon = self:AddComponent(UIImage, lock_icon_path)
  self.using = self:AddComponent(UIBaseContainer, using_path)
  self.usingText = self:AddComponent(UIText, using_text_path)
  self.usingIcon = self:AddComponent(UIImage, using_icon_path)
  self.uncheck = self:AddComponent(UIImage, uncheck_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    if not self.imgCheck:GetActive() and self.callback then
      self.callback(self.idx)
    end
  end)
  self.bg = self:AddComponent(UIImage, bg_path)
end

function TWSkillChipSetRow:ComponentDestroy()
end

function TWSkillChipSetRow:SetIndex(idx, hideLine)
  local skillChips = DataCenter.TWSkillChipManager:GetChipsByMasterSet(idx)
  self.idx = idx
  for i = 1, 4 do
    if skillChips[i] then
      self.skillChips[i]:SetData(skillChips[i])
    else
      self.skillChips[i]:SetSlot(i)
    end
  end
  self.numberText:SetLocalText("800323", idx)
end

function TWSkillChipSetRow:SetCheck()
  self.imgCheck:SetActive(true)
  self.uncheck:SetActive(false)
  self.bg:SetColorRGBA(0.98, 0.831, 0.611, 1)
end

function TWSkillChipSetRow:SetLocked()
  self.uncheck:SetActive(true)
  self.lockIcon:SetActive(true)
  self.using:SetActive(false)
  self.imgCheck:SetActive(false)
  self.btnCheck:SetActive(false)
  self.bg:SetColorRGBA(0.945, 0.929, 0.921, 1)
end

function TWSkillChipSetRow:SetUsing(usingIndex)
  self.uncheck:SetActive(true)
  self.lockIcon:SetActive(false)
  self.imgCheck:SetActive(false)
  self.using:SetActive(true)
  self.usingText:SetText(usingIndex)
  self.btnCheck:SetActive(false)
  self.bg:SetColorRGBA(0.945, 0.929, 0.921, 1)
end

function TWSkillChipSetRow:SetUnuse()
  self.uncheck:SetActive(true)
  self.lockIcon:SetActive(false)
  self.imgCheck:SetActive(false)
  self.using:SetActive(false)
  self.btnCheck:SetActive(true)
  self.bg:SetColorRGBA(0.945, 0.929, 0.921, 1)
end

function TWSkillChipSetRow:SetCallBack(callback)
  self.callback = callback
end

return TWSkillChipSetRow
