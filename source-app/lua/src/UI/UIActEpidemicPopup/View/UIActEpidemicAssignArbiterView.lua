local base = UIBaseView
local UIActEpidemicAssignArbiterView = BaseClass("UIActEpidemicAssignArbiterView", base)
local UIActEpidemicAssignArbiterItem = require("UI.UIActEpidemicPopup.Component.UIActEpidemicAssignArbiterItem")
local Localization = CS.GameEntry.Localization
local title_text_path = "Root/Common_img_title/titleText"
local desc_path = "Root/desc"
local lab_countdown_path = "Root/confirmBtn/LabCountdown"
local btn_txt_path = "Root/confirmBtn/BtnTxt"

function UIActEpidemicAssignArbiterView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function UIActEpidemicAssignArbiterView:OnDestroy()
  self:RemoveTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIActEpidemicAssignArbiterView:ComponentDefine()
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.lab_countdown = self:AddComponent(UITextMeshProUGUIEx, lab_countdown_path)
  self.btn_txt = self:AddComponent(UITextMeshProUGUIEx, btn_txt_path)
  self.returnBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.closeBtn = self:AddComponent(UIButton, "Root/CloseBtn")
  self.returnBtn:SetOnClick(function()
    self:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self:CloseSelf()
  end)
  self.content = self:AddComponent(UIBaseContainer, "Root/ScrollView/Viewport/Content")
  self.toggleGroup = self.content.transform:GetComponent(typeof(CS.UnityEngine.UI.ToggleGroup))
  self.confirmBtn = self:AddComponent(UIButton, "Root/confirmBtn")
  self.confirmBtn:SetOnClick(function()
    self:OnClickConfirm()
  end)
  local info_btn_path = "Root/Common_img_title/titleText/infoBtn"
  self.infoBtn = self:AddComponent(UIButton, info_btn_path)
  self.infoBtn:SetOnClick(function()
    self:OnClickInfo()
  end)
  self.title_text:SetLocalText("YiBianJinQu_trivial_tips_3")
  self.desc:SetLocalText("YiBianJinQu_trivial_tips_4")
  self.btn_txt:SetLocalText("458522")
end

function UIActEpidemicAssignArbiterView:ComponentDestroy()
  self:RemoveItems()
end

function UIActEpidemicAssignArbiterView:DataDefine()
  local args = self:GetUserData()
  self.group = args.group
  self.lastSelection = args.arbiter and args.arbiter.uid
end

function UIActEpidemicAssignArbiterView:DataDestroy()
  self.curSelection = nil
  self.lastSelection = nil
  self.group = nil
end

function UIActEpidemicAssignArbiterView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActEpidemicOnActInfoRefresh, self.Refresh)
end

function UIActEpidemicAssignArbiterView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActEpidemicOnActInfoRefresh, self.Refresh)
end

function UIActEpidemicAssignArbiterView:CloseSelf()
  self.ctrl:CloseSelf()
end

function UIActEpidemicAssignArbiterView:GetCurrentSelect()
  return self.curSelection or self.lastSelection
end

local function _Sort(a, b)
  local aOnline = a.online or false
  local bOnline = b.online or false
  if aOnline == bOnline then
    local aPower = a.power or 0
    local bPower = b.power or 0
    return aPower > bPower
  else
    return aOnline
  end
end

function UIActEpidemicAssignArbiterView:Refresh()
  local list = self.ctrl:GetMembers(self.group) or {}
  self:RemoveItems()
  if not list then
    return
  end
  table.sort(list, _Sort)
  for i = 1, #list do
    self.rewardReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicAssignArbiterItem.prefab", function(req)
      local data = list[i]
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(1, 1, 1)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.content:AddComponent(UIActEpidemicAssignArbiterItem, nameStr)
      cell:Refresh(data, self.toggleGroup, data.uid == self:GetCurrentSelect())
    end)
  end
  self:RefreshButtonLabel()
end

function UIActEpidemicAssignArbiterView:RemoveItems()
  self.content:RemoveComponents(UIActEpidemicAssignArbiterItem)
  if self.rewardReqs then
    for _, v in pairs(self.rewardReqs) do
      v:Destroy()
    end
  end
  self.rewardReqs = {}
end

function UIActEpidemicAssignArbiterView:OnSelect(uid)
  self.curSelection = uid
end

function UIActEpidemicAssignArbiterView:OnClickConfirm()
  local cd = self:GetCountdownSec()
  if 0 < cd then
    local tips = Localization:GetString("YiBianJinQu_trivial_tips_36", cd)
    UIUtil.ShowTips(tips)
    return
  end
  if self.curSelection then
    DataCenter.ActEpidemicZoneManager:RequestActivityArbiter(self.group, self.curSelection)
  end
  self.ctrl:CloseSelf()
end

function UIActEpidemicAssignArbiterView:GetCountdownSec()
  local aribiter = ActEpidemicUtils.GetArbiterByGroupId(self.group)
  local cd = aribiter and aribiter.arbiterCdTime or 0
  local gap = cd - UITimeManager:GetInstance():GetServerSeconds()
  return gap
end

function UIActEpidemicAssignArbiterView:RefreshButtonLabel()
  local gap = self:GetCountdownSec()
  if 0 < gap then
    CS.UIGray.SetGray(self.confirmBtn.transform, true, true)
    self:StartTimer()
    self.lab_countdown:SetActive(true)
    self.lab_countdown:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(gap * 1000))
  else
    CS.UIGray.SetGray(self.confirmBtn.transform, false, true)
    self:RemoveTimer()
    self.lab_countdown:SetActive(false)
  end
end

function UIActEpidemicAssignArbiterView:StartTimer()
  if not self.timer then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.RefreshButtonLabel, self, false, false, false)
    self.timer:Start()
  end
end

function UIActEpidemicAssignArbiterView:RemoveTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIActEpidemicAssignArbiterView:OnClickInfo()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicHelpView, {anim = true}, 41)
end

return UIActEpidemicAssignArbiterView
