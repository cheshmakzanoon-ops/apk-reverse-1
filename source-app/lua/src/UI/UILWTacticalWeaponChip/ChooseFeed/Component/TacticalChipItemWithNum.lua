local TacticalChipItemWithNum = BaseClass("TacticalChipItemWithNum", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local tactical_chip_item_path = "TacticalChipItem"
local delete_btn_path = "deleteBtn"
local warning_flag_path = "warningFlag"
local num_path = "num"

function TacticalChipItemWithNum:OnCreate()
  base.OnCreate(self)
  self.tactical_chip_item = self:AddComponent(UIBaseContainer, tactical_chip_item_path)
  self.delete_btn = self:AddComponent(UIButton, delete_btn_path)
  self.warning_flag = self:AddComponent(UIImage, warning_flag_path)
  self.num = self:AddComponent(UITextMeshProUGUIEx, num_path)
end

function TacticalChipItemWithNum:OnDestroy()
  base.OnDestroy(self)
end

function TacticalChipItemWithNum:OnEnable()
  base.OnEnable(self)
end

function TacticalChipItemWithNum:OnDisable()
  base.OnDisable(self)
end

function TacticalChipItemWithNum:SetData(chipInfo)
  self.chipInfo = chipInfo
end

return TacticalChipItemWithNum
