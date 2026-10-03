local UILWAlHelpCtrl = BaseClass("UILWAlHelpCtrl", UIBaseCtrl)

local function SetView(self, view)
  self.view = view
end

local function ClearView(self)
  self.view = nil
end

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlHelp)
end

local function OnHelpClick(self, helpId, uid)
  SFSNetwork.SendMessage(MsgDefines.AllianceRenderHelp, helpId, uid)
end

local function OnClickHelpAll(self, helpAllBtnPos, toPos)
  local can_help = false
  local helpList = self.view.helpList or {}
  if 0 < #helpList then
    table.walk(helpList, function(k, v)
      if v.isSelf == false then
        can_help = true
      end
    end)
  end
  if can_help then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    SFSNetwork.SendMessage(MsgDefines.AlHelpAll, math.floor(curTime), helpAllBtnPos, toPos, nil, true)
  else
    UIUtil.ShowTipsId(393023)
  end
end

UILWAlHelpCtrl.SetView = SetView
UILWAlHelpCtrl.ClearView = ClearView
UILWAlHelpCtrl.CloseSelf = CloseSelf
UILWAlHelpCtrl.OnHelpClick = OnHelpClick
UILWAlHelpCtrl.OnClickHelpAll = OnClickHelpAll
return UILWAlHelpCtrl
