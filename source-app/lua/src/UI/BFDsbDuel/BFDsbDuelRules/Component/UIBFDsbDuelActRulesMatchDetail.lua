local base = UIBaseContainer
local UIBFDsbDuelActRulesMatchDetail = BaseClass("UIBFDsbDuelActRulesMatchDetail", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActRulesMatchDetail:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActRulesMatchDetail:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActRulesMatchDetail:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compItem1 = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.compItem2 = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textBtnTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnJump = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnJump:SetOnClick(function()
    self:OnBtnJumpClick()
  end)
  self.textDesc2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compItem3 = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.textDesc3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
end

function UIBFDsbDuelActRulesMatchDetail:ComponentDestroy()
  self.viewSkin = nil
  self.compItem1 = nil
  self.compItem2 = nil
  self.textDesc = nil
  self.textBtnTxt = nil
  self.btnJump = nil
  self.textDesc2 = nil
  self.compItem3 = nil
  self.textDesc3 = nil
end

function UIBFDsbDuelActRulesMatchDetail:DataDefine()
end

function UIBFDsbDuelActRulesMatchDetail:DataDestroy()
end

function UIBFDsbDuelActRulesMatchDetail:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActRulesMatchDetail:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActRulesMatchDetail:OnBtnJumpClick()
  if not self.templateList or not self.templateList[1] then
    return
  end
  local template = self.templateList[1]
  if template.buttonsJumpTypeList[1] and template.buttonsJumpTypeList[1] ~= -1 then
    local jumpIndex = tonumber(template.buttonsJumpTypeList[1])
    if 1 <= jumpIndex and jumpIndex <= 4 then
      EventManager:GetInstance():Broadcast(EventId.DSBDuelChangeRulesViewTab, jumpIndex)
    elseif 11 <= jumpIndex and jumpIndex <= 13 then
      UIManager.Instance:DestroyWindow(UIWindowNames.UIBFDsbDuelActRules)
      EventManager:GetInstance():Broadcast(EventId.DsbDuelActBattleMainToggleChange, jumpIndex - 10)
    end
  elseif template.buttonsDetailList[1] then
    local param = {}
    param.type = "desc"
    param.title = ""
    param.desc = template.buttonsDetailList[1]
    param.alignObject = self.btnJump
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

function UIBFDsbDuelActRulesMatchDetail:UpdateData(templateList)
  self.templateList = templateList
  local cnt = table.count(self.templateList)
  if 0 < cnt then
    self.textDesc:SetLocalText(self.templateList[1].desc)
    self.textBtnTxt:SetLocalText(self.templateList[1].buttons)
  end
  if 1 < cnt then
    self.textDesc2:SetLocalText(self.templateList[2].desc)
  end
  if 2 < cnt then
    self.textDesc3:SetLocalText(self.templateList[3].desc)
  end
end

return UIBFDsbDuelActRulesMatchDetail
