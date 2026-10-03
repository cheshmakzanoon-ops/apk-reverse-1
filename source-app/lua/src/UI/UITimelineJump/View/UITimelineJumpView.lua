local UITimelineJumpView = BaseClass("UITimelineJumpView", UIBaseView)
local base = UIBaseView
local skip_btn_path = "SkipBtn"
local skip_btn_name_path = "SkipBtn/Text_uityjc20"

function UITimelineJumpView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UITimelineJumpView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UITimelineJumpView:ComponentDefine()
  self.skip_btn = self:AddComponent(UIButton, skip_btn_path)
  self.skip_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.skip_btn_name = self:AddComponent(UIText, skip_btn_name_path)
end

function UITimelineJumpView:ComponentDestroy()
  self.skip_btn = nil
  self.skip_btn_name = nil
end

function UITimelineJumpView:DataDefine()
  self.param = {}
end

function UITimelineJumpView:DataDestroy()
  self.param = {}
end

function UITimelineJumpView:OnEnable()
  base.OnEnable(self)
end

function UITimelineJumpView:OnDisable()
  base.OnDisable(self)
end

function UITimelineJumpView:ReInit()
  self.param = self:GetUserData()
  self.skip_btn_name:SetLocalText(tonumber(GameDialogDefine.SKIP))
end

function UITimelineJumpView:OnAddListener()
  base.OnAddListener(self)
end

function UITimelineJumpView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITimelineJumpView:OnBtnClick()
  if self.param ~= nil and self.param.gotoGuideId ~= nil then
    DataCenter.GuideManager:SetCurGuideId(self.param.gotoGuideId)
    DataCenter.GuideManager:DoGuide()
  end
  EventManager:GetInstance():Broadcast(EventId.GuideTimelineMarker, GuideTimeLineShowMarkerType.End)
end

return UITimelineJumpView
