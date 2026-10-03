local base = UIBaseContainer
local UILWAlSwitchJobCell = BaseClass("UILWAlSwitchJobCell", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIAllianceInfoHorizontalPanel = require("UI.UIAlliance.UIAllianceInfo.Component.UIAllianceInfoHorizontalPanel")

function UILWAlSwitchJobCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlSwitchJobCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlSwitchJobCell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnJoin = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnJoin:SetOnClick(function()
    self:OnBtnJoinClick()
  end)
  self.textJoinBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textNow = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compInfoPanel = self.viewSkin:AddComponent(self, UIAllianceInfoHorizontalPanel, 4)
  self.textNow:SetLocalText("alliance_switch_current")
end

function UILWAlSwitchJobCell:ComponentDestroy()
  self.viewSkin = nil
  self.btnJoin = nil
  self.textJoinBtn = nil
  self.textNow = nil
  self.compInfoPanel = nil
end

function UILWAlSwitchJobCell:DataDefine()
end

function UILWAlSwitchJobCell:DataDestroy()
end

function UILWAlSwitchJobCell:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlSwitchJobCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlSwitchJobCell:OnBtnJoinClick()
  if self.recommendInfo and self.recommendInfo.allianceId ~= LuaEntry.Player.allianceId then
    if self.recommendInfo.recruitTotal == 1 then
      UIUtil.ShowTipsId("alliance_switch_tips_applySucceed")
      SFSNetwork.SendMessage(MsgDefines.AlApply, self.recommendInfo.allianceId, self.recommendInfo.recruitTotal, self.recommendInfo.language, AlApplyCheckType.Switch)
      self.view.ctrl:CloseSelf()
    else
      UIUtil.ShowLeaveAllianceTips(function()
        SFSNetwork.SendMessage(MsgDefines.AlApply, self.recommendInfo.allianceId, self.recommendInfo.recruitTotal, self.recommendInfo.language, AlApplyCheckType.Switch)
        self.view.ctrl:CloseSelf()
      end)
    end
  else
    self.view.ctrl:CloseSelf()
  end
end

function UILWAlSwitchJobCell:SetData(recommendInfo, isNow)
  self.recommendInfo = recommendInfo
  if isNow then
    self.textNow:SetActive(true)
    self.btnJoin:SetActive(false)
  else
    self.textNow:SetActive(false)
    self.btnJoin:SetActive(true)
    local canJoin = recommendInfo.recruitTotal == 0
    if canJoin then
      self.textJoinBtn:SetLocalText("110037")
      self.btnJoin:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png")
    else
      self.textJoinBtn:SetLocalText("110090")
      self.btnJoin:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
    end
  end
  self.compInfoPanel:RefreshByRecommendInfo(recommendInfo)
end

return UILWAlSwitchJobCell
