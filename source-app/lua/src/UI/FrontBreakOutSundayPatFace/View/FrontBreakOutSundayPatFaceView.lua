local FrontBreakOutSundayPatFaceView = BaseClass("FrontBreakOutSundayPatFaceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function FrontBreakOutSundayPatFaceView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function FrontBreakOutSundayPatFaceView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FrontBreakOutSundayPatFaceView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnBlack = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnBlack:SetOnClick(function()
    self:OnBtnBlackClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.textTitle:SetLocalText("frontline_weekend_poster_01")
end

function FrontBreakOutSundayPatFaceView:ComponentDestroy()
  self.viewSkin = nil
  self.btnBlack = nil
  self.textTitle = nil
  self.btnGo = nil
end

function FrontBreakOutSundayPatFaceView:DataDefine()
end

function FrontBreakOutSundayPatFaceView:DataDestroy()
end

function FrontBreakOutSundayPatFaceView:OnAddListener()
  base.OnAddListener(self)
end

function FrontBreakOutSundayPatFaceView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function FrontBreakOutSundayPatFaceView:OnBtnBlackClick()
  self.ctrl:CloseSelf()
end

function FrontBreakOutSundayPatFaceView:OnBtnGoClick()
  if not DataCenter.ActFrontBreakSundayDataManager:IsOpen() then
    return
  end
  local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.FrontBreakSunday.Type)
  if not activityData then
    return false
  end
  local id = activityData.id
  GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, id)
end

return FrontBreakOutSundayPatFaceView
