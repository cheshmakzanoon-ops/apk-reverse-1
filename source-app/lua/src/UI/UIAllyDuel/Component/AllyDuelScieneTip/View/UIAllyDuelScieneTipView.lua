local UIAllyDuelScieneTipView = BaseClass("UIAllyDuelScieneTipView", UIBaseView)
local base = UIBaseView
local desc_path = "ScienceBg/Desc"
local icon_path = "ScienceBg/Desc/Icon"
local jump_btn_path = "ScienceBg/Bot/jumpBtn"
local jump_btn_txt_path = "ScienceBg/Bot/jumpBtn/jumpBtnTxt"

function UIAllyDuelScieneTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Init()
end

function UIAllyDuelScieneTipView:OnDestroy()
  self:ComponentDestroy()
  self.data = nil
  base.OnDestroy(self)
end

function UIAllyDuelScieneTipView:ComponentDestroy()
  self.scienceBgN = nil
  self.scienceIconN = nil
  self.scienceDescN = nil
  self.jumpBtnN = nil
  self.jumpBtnTxtN = nil
end

function UIAllyDuelScieneTipView:ComponentDefine()
  self.desc = self:AddComponent(UIText, desc_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.jump_btn = self:AddComponent(UIButton, jump_btn_path)
  self.jump_btn_txt = self:AddComponent(UIText, jump_btn_txt_path)
  self.jump_btn_txt:SetLocalText(110003)
  self.jump_btn:SetOnClick(function()
    self:OnClickGo()
  end)
  self.closeBtn = self:AddComponent(UIButton, "CloseBtn")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UIAllyDuelScieneTipView:Init()
  self.data = DataCenter.AllianceCompeteDataManager:GetScienceTip()
  if not self.data then
    return
  end
  self.icon:LoadSpriteAuto(self.data.icon)
  self.desc:SetLocalText(self.data.desc)
end

function UIAllyDuelScieneTipView:OnClickGo()
  if not self.data then
    return
  end
  local jumpValue = self.data.jumpValue
  if self.data.jumpType == 1 then
    self.ctrl:CloseSelf()
    GoToUtil.GotoCityByBuildId(jumpValue)
  elseif self.data.jumpType == 2 then
    self.ctrl:CloseSelf()
    GoToUtil.GotoScience(jumpValue)
  end
end

return UIAllyDuelScieneTipView
