local UIAllianceIntroCtrl = BaseClass("UIAllianceIntroCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceIntro)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function OnClickCreateBtn(self)
  local needMainLv = LuaEntry.DataConfig:TryGetNum("alliance_cost", "k12")
  if needMainLv > DataCenter.BuildManager.MainLv then
    UIUtil.ShowTips(Localization:GetString("143579", needMainLv))
    return
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICreateSetAlliance, {anim = true}, 0)
    self:CloseSelf()
  end
end

local function OnClickJoinBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIJoinAlliance, {anim = true})
  self:CloseSelf()
end

UIAllianceIntroCtrl.CloseSelf = CloseSelf
UIAllianceIntroCtrl.Close = Close
UIAllianceIntroCtrl.OnClickCreateBtn = OnClickCreateBtn
UIAllianceIntroCtrl.OnClickJoinBtn = OnClickJoinBtn
return UIAllianceIntroCtrl
