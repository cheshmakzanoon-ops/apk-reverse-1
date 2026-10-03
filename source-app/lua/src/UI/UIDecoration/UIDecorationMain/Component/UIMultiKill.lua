local UIMultiKill = BaseClass("UIMultiKill", UIBaseContainer)
local base = UIBaseContainer
local txt_content_path = "bubble/txtContent"
local head_player_path = "bubble/headPlayer"
local kill_icon_path = "bubble/killIcon"
local num1_path = "bubble/Num1"
local num2_path = "bubble/Num2"

function UIMultiKill:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMultiKill:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMultiKill:ComponentDefine()
  self.txt_content = self:AddComponent(UITextMeshProUGUIEx, txt_content_path)
  self.head_player = self:AddComponent(UICommonHead, head_player_path)
  self.kill_icon = self:AddComponent(UIImage, kill_icon_path)
  self.num1 = self:AddComponent(UIImage, num1_path)
  self.num2 = self:AddComponent(UIImage, num2_path)
  self.anim = self:AddComponent(UISimpleAnimation, "")
end

function UIMultiKill:ComponentDestroy()
  self.txt_content = nil
  self.head_player = nil
  self.kill_icon = nil
  self.num1 = nil
  self.num2 = nil
  self.anim = nil
end

function UIMultiKill:DataDefine()
end

function UIMultiKill:DataDestroy()
end

function UIMultiKill:OnEnable()
  base.OnEnable(self)
end

function UIMultiKill:OnDisable()
  base.OnDisable(self)
end

function UIMultiKill:OnDisable()
  base.OnDisable(self)
end

function UIMultiKill:RefreshView()
  self.txt_content:SetText(LuaEntry.Player:GetFullNameWithSourceServer() .. "NO.1")
  self.txt_content:SetColorRGBA(0.46, 0.93, 0.18, 1)
  self.head_player:SetAsMyself()
  self.anim:Play("Default")
  self.countDown = 3
  self.isShow = true
end

function UIMultiKill:Update1000MS()
  self.countDown = self.countDown - 1
  if self.countDown <= 0 then
    if self.isShow then
      self.countDown = 1
      self.anim:Play("FlyOut")
      self.isShow = false
    else
      self.countDown = 3
      self.anim:Play("Default")
      self.isShow = true
    end
  end
end

return UIMultiKill
