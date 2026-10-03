local UICommonResItemMouth = BaseClass("UICommonResItemMouth", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_common_res_item_path = "UICommonResItem"
local mouth_text_path = "bg/mouthText"

function UICommonResItemMouth:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICommonResItemMouth:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICommonResItemMouth:ComponentDefine()
  self.commonResItem = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.mouth_text = self:AddComponent(UITextMeshProUGUIEx, mouth_text_path)
end

function UICommonResItemMouth:ComponentDestroy()
  self.commonResItem = nil
  self.mouth_text = nil
end

function UICommonResItemMouth:ReInit(param)
  if param == nil then
    Logger.LogError("need param with 'rewardParam' and 'mouthText'")
    return
  end
  self.commonResItem:ReInit(param.rewardParam)
  self.mouth_text:SetText(param.mouthText)
end

return UICommonResItemMouth
