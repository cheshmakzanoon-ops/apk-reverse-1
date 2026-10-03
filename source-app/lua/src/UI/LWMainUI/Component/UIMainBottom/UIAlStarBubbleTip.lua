local UIAlStarBubbleTip = BaseClass("UIAlStarBubbleTip", UIAsyncContainer)
local base = UIAsyncContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local click_btn_path = "Btn"

function UIAlStarBubbleTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAlStarBubbleTip:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAlStarBubbleTip:ComponentDefine()
  self.icon = self:AddComponent(UIImage, "Btn/Icon")
  self.icon:LoadSprite("Assets/Main/Sprites/UI/UIAllianceStar/zyf_tongmengzhixing_shijian_icon.png")
  self.icon:SetSizeDelta(Vector2.New(55, 54.375))
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self:SetAnchoredPosition(Vector2.zero)
  self.__name = "AlStarBubbleTip"
  if GameObjectIsValid(self.gameObject) then
    self.gameObject.name = "AlStarBubbleTip"
  end
end

function UIAlStarBubbleTip:ComponentDestroy()
  self.clickBtn = nil
  self.icon = nil
end

function UIAlStarBubbleTip:DataDefine()
end

function UIAlStarBubbleTip:DataDestroy()
end

function UIAlStarBubbleTip:OnEnable()
  base.OnEnable(self)
end

function UIAlStarBubbleTip:OnDisable()
  base.OnDisable(self)
end

function UIAlStarBubbleTip:OnAddListener()
  base.OnAddListener(self)
end

function UIAlStarBubbleTip:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAlStarBubbleTip:OnClick()
  if DataCenter.AllianceStarManager:IsShowMainBubbleTip() then
    SFSNetwork.SendMessage(MsgDefines.AllianceStarGainActivityInfoNew)
    SFSNetwork.SendMessage(MsgDefines.AllianceStarGainCeremonyInfoNew)
  else
    EventManager:GetInstance():Broadcast(EventId.AllianceStarGainActivityInfoNewRefresh)
  end
end

return UIAlStarBubbleTip
