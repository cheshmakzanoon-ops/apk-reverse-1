local UIJoinOrCreateAllianceCtrl = BaseClass("UIJoinOrCreateAllianceCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIJoinOrCreateAlliance)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function OnClickCreate(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICreateAlliance, {anim = true, hideTop = true})
end

local function OnClickJoin(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIJoinAlliance, {anim = true, hideTop = true})
end

UIJoinOrCreateAllianceCtrl.CloseSelf = CloseSelf
UIJoinOrCreateAllianceCtrl.Close = Close
UIJoinOrCreateAllianceCtrl.OnClickCreate = OnClickCreate
UIJoinOrCreateAllianceCtrl.OnClickJoin = OnClickJoin
return UIJoinOrCreateAllianceCtrl
