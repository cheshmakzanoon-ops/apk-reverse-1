local base = UIBaseContainer
local ChomperComponent = BaseClass("ChomperComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function ChomperComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ChomperComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChomperComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnChomper = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnChomper:SetOnClick(function()
    self:OnBtnChomperClick()
  end)
  self.imgMonster = self.viewSkin:AddComponent(self, UIImage, 2)
  self.compCheck = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compBlack = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
end

function ChomperComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnChomper = nil
  self.imgMonster = nil
  self.compCheck = nil
  self.compBlack = nil
end

function ChomperComponent:DataDefine()
end

function ChomperComponent:DataDestroy()
  self.monsterData = nil
end

function ChomperComponent:OnBtnChomperClick()
  if self.state == 1 then
    UIUtil.ShowTipsId("season6_piranha_activity_tips_2")
  elseif self.state == 2 then
    if self.monsterData then
      GoToUtil.MoveToWorldMarchAndOpen(self.monsterData.pointId, self.monsterData.monsterUuid, self.monsterData.serverId, 0)
      GoToUtil.CloseAllWindows()
    end
  else
    UIUtil.ShowTipsId("season6_piranha_activity_tips_1")
  end
end

function ChomperComponent:SetData(state, monsterData)
  self.monsterData = monsterData
  self.state = state
  if state == 1 then
    CS.UIGray.SetGray(self.imgMonster.transform, true, true)
    self.compCheck:SetActive(true)
    self.compBlack:SetActive(false)
  elseif state == 2 then
    CS.UIGray.SetGray(self.imgMonster.transform, false, true)
    self.compCheck:SetActive(false)
    self.compBlack:SetActive(false)
  else
    CS.UIGray.SetGray(self.imgMonster.transform, false, true)
    self.compCheck:SetActive(false)
    self.compBlack:SetActive(true)
  end
end

return ChomperComponent
