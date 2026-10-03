local UISurfingBattleCountDownView = BaseClass("UISurfingBattleCountDownView", UIBaseView)
local base = UIBaseView
local count_down_text_path = "SafeArea/CenterRoot/CountDownText"
local center_root_path = "SafeArea/CenterRoot"

function UISurfingBattleCountDownView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UISurfingBattleCountDownView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISurfingBattleCountDownView:ComponentDefine()
  self.count_down_text = self:AddComponent(UITextMeshProUGUIEx, count_down_text_path)
  self.center_root = self:AddComponent(UIBaseContainer, center_root_path)
  self.center_root:SetActive(false)
end

function UISurfingBattleCountDownView:ComponentDestroy()
  self.count_down_text = nil
  self.center_root = nil
end

function UISurfingBattleCountDownView:DataDefine()
  self.countDownTimer = nil
  self.curTimer = nil
end

function UISurfingBattleCountDownView:DataDestroy()
  self.countDownTimer = nil
  self.curTimer = nil
end

function UISurfingBattleCountDownView:Update()
  if self.curTimer == nil then
    return
  end
  self.curTimer = self.curTimer - Time.deltaTime
  if self.countDownTimer > 0 then
    if self.curTimer <= 0 then
      self.count_down_text:SetText(tostring(self.countDownTimer))
      self.countDownTimer = self.countDownTimer - 1
      self.curTimer = 1
    end
  elseif self.curTimer <= 0 then
    self.countDownTimer = nil
    self.curTimer = nil
    if self.ctrl then
      self.ctrl:CloseSelf()
    end
    local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
    if logic then
      logic:Pause(false)
    end
  end
end

function UISurfingBattleCountDownView:InitView()
  self.countDownTimer = 3
  self.curTimer = 0
  self.count_down_text:SetText(tostring(self.countDownTimer))
  self.center_root:SetActive(true)
end

return UISurfingBattleCountDownView
