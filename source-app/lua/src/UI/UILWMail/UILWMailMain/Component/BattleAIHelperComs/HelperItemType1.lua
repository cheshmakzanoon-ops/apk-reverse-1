local HelperItemType1 = BaseClass("HelperItemType1", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local BattleHelperUniversalItem = require("UI.UILWMail.UILWMailMain.Component.BattleAIHelperComs.BattleHelperUniversalItem")

function HelperItemType1:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HelperItemType1:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HelperItemType1:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "bg")
  self.state_txt = self:AddComponent(UITextMeshProUGUIEx, "state_txt")
  self.jump_btn = self:AddComponent(UIButton, "jump_btn")
  self.jump_btn:SetOnClick(function()
    if self.adviceInfo then
      self.adviceInfo.extraInfo.jumpFunc()
    end
  end)
  self.jump_btn_icon = self:AddComponent(UIImage, "jump_btn/jump_btn_icon")
  self.slot = self:AddComponent(BattleHelperUniversalItem, "slot")
  self.leftDesc_txt = self:AddComponent(UIText, "left/leftDesc_txt")
  self.left_slider = self:AddComponent(UISlider, "left/left_slider")
  self.leftNum_txt = self:AddComponent(UIText, "left/leftNum_txt")
  self.rightDesc_txt = self:AddComponent(UIText, "right/rightDesc_txt")
  self.right_slider = self:AddComponent(UISlider, "right/right_slider")
  self.rightNum_txt = self:AddComponent(UIText, "right/rightNum_txt")
end

function HelperItemType1:ComponentDestroy()
  self.bg = nil
  self.state_txt = nil
  self.jump_btn = nil
  self.jump_btn_icon = nil
  self.slot = nil
  self.leftDesc_txt = nil
  self.left_slider = nil
  self.leftNum_txt = nil
  self.rightDesc_txt = nil
  self.right_slider = nil
  self.rightNum_txt = nil
end

function HelperItemType1:SetData(data)
end

function HelperItemType1:DataDefine()
end

function HelperItemType1:DataDestroy()
  self.adviceInfo = nil
end

function HelperItemType1:OnEnable()
  base.OnEnable(self)
end

function HelperItemType1:OnDisable()
  base.OnDisable(self)
end

function HelperItemType1:OnAddListener()
  base.OnAddListener(self)
end

function HelperItemType1:OnRemoveListener()
  base.OnRemoveListener(self)
end

function HelperItemType1:SetData(adviceInfo)
  local template = adviceInfo.template
  local extraInfo = adviceInfo.extraInfo
  local leftScore = extraInfo.leftScore
  local rightScore = extraInfo.rightScore
  local maxScore = extraInfo.leftScore > extraInfo.rightScore and extraInfo.leftScore or extraInfo.rightScore
  self.left_slider:SetValue(leftScore / maxScore)
  self.right_slider:SetValue(rightScore / maxScore)
  self.leftNum_txt:SetText(string.GetFormattedStr2(leftScore))
  self.rightNum_txt:SetText(string.GetFormattedStr2(rightScore))
  self.leftDesc_txt:SetLocalText(template.dialog_1)
  self.rightDesc_txt:SetLocalText(template.dialog_1)
  if extraInfo.displayData and extraInfo.displayData[1] then
    self.slot:SetActive(true)
    self.slot:ReInit(extraInfo.displayData[1])
  else
    self.slot:SetActive(false)
  end
  local standardScore = tonumber(template.typePara[1]) or 0
  if standardScore < adviceInfo.score then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_diban_01.png")
    self.state_txt:SetLocalText("report_helper_great", string.format("<color=#FFEA87>%s</color>", Localization:GetString(template.dialog_2)))
    self.state_txt:ChangeNewMaterial("Assets/Main/TMPFont/Main/TitleFontMat/Title-Outline_9D5133_31.mat")
  else
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UILWMail_Helper/ljq_zhanbao_diban_02.png")
    self.state_txt:SetLocalText("report_helper_mild", string.format("<color=#FFEA87>%s</color>", Localization:GetString(template.dialog_2)))
    self.state_txt:ChangeNewMaterial("Assets/Main/TMPFont/Main/TitleFontMat/Title-Outline_285985_31.mat")
  end
  self.jump_btn:SetActive(extraInfo ~= nil and extraInfo.jumpFunc ~= nil)
  self.adviceInfo = adviceInfo
end

return HelperItemType1
