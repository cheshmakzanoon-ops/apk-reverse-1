local base = UIBaseContainer
local UIWS_H_ACell = BaseClass("UIWS_H_ACell", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIWS_H_ACell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWS_H_ACell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWS_H_ACell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnIcon = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnIcon:SetOnClick(function()
    self:OnBtnIconClick()
  end)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTimes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
end

function UIWS_H_ACell:ComponentDestroy()
  self.viewSkin = nil
  self.btnIcon = nil
  self.textName = nil
  self.textTimes = nil
  self.compRoot = nil
end

function UIWS_H_ACell:DataDefine()
end

function UIWS_H_ACell:DataDestroy()
  self.data = nil
  self.descStr = nil
end

function UIWS_H_ACell:OnAddListener()
  base.OnAddListener(self)
end

function UIWS_H_ACell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWS_H_ACell:OnBtnIconClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if string.IsNullOrEmpty(self.descStr) then
    return
  end
  UIUtil.ShowBubbleTips(self.descStr, self.btnIcon.transform.position, 0, -30, 0, nil, nil, nil, nil, true)
end

function UIWS_H_ACell:SetData(data, showRoot)
  self.data = data
  if self.data == nil then
    return
  end
  if self.data.number ~= nil then
    self.textTimes:SetText("\195\151" .. self.data.number)
    self.textTimes:SetActive(true)
  else
    self.textTimes:SetActive(false)
  end
  local lineData = LocalController:instance():getLine(TableName.LW_BattleField_Achievement, self.data.id)
  if lineData ~= nil then
    self.descStr = Localization:GetString(lineData:getValue("desc"), lineData:getValue("value"))
    local icon = lineData:getValue("icon")
    if not string.IsNullOrEmpty(icon) then
      self.btnIcon:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldWinterAchievementPath, icon))
    end
    self.textName:SetLocalText(lineData:getValue("name"))
  end
  self:ActiveRoot(showRoot)
end

function UIWS_H_ACell:ActiveRoot(bActive)
  self.compRoot:SetActive(bActive)
end

return UIWS_H_ACell
