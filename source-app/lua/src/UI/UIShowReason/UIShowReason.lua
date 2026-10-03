local UIShowReason = BaseClass("UIShowReason", UIBaseContainer)
local base = UIBaseContainer
local UIShowReasonDesCell = require("UI.UIShowReason.UIShowReasonDesCell")
local info_btn_path = "InfoBtn"
local original_time_text_path = "OriginalTimeText"
local close_btn_path = "BuildReasonGo/CloseBuildReasonBtn"
local root_anim_path = "BuildReasonGo"
local total_des_text_path = "BuildReasonGo/root/TotalDesText"
local total_value_text_path = "BuildReasonGo/root/TotalDesText/TotalValueText"
local cell_parent_path = "BuildReasonGo/root/CellBg"
local root_go_path = "BuildReasonGo/root"

function UIShowReason:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIShowReason:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIShowReason:OnEnable()
  base.OnEnable(self)
end

function UIShowReason:OnDisable()
  base.OnDisable(self)
end

function UIShowReason:ComponentDefine()
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.original_time_text = self:AddComponent(UIText, original_time_text_path)
  self.root_anim = self:AddComponent(UIAnimator, root_anim_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.total_des_text = self:AddComponent(UIText, total_des_text_path)
  self.total_value_text = self:AddComponent(UIText, total_value_text_path)
  self.cell_parent = self:AddComponent(UIBaseContainer, cell_parent_path)
  self.root_go = self:AddComponent(UIBaseContainer, root_go_path)
  self.close_btn:SetOnClick(function()
    self:OnCloseBtnClick()
  end)
end

function UIShowReason:ComponentDestroy()
  self.info_btn = nil
  self.original_time_text = nil
  self.root_anim = nil
  self.close_btn = nil
  self.total_des_text = nil
  self.total_value_text = nil
  self.cell_parent = nil
  self.root_go = nil
end

function UIShowReason:DataDefine()
  self.param = {}
  self.isShow = false
  self.closeTimer = nil
  self.modelReq = {}
  self.loadCount = 0
end

function UIShowReason:DataDestroy()
  self:RemoveCloseTimer()
  self.param = nil
  self.closeTimer = nil
  self.isShow = nil
  self.modelReq = nil
  self.loadCount = nil
end

function UIShowReason:ReInit(param)
  self.param = param
  self.isShow = false
  self.root_anim:SetActive(false)
  self.original_time_text:SetText(self.param.originalTime)
  self.total_des_text:SetText(self.param.totalDes)
  self.total_value_text:SetText(self.param.totalValue)
  self:ShowCells()
end

function UIShowReason:OnInfoBtnClick()
  if not self.isShow then
    self.isShow = true
    self.root_anim:SetActive(true)
    self.root_anim:Play("CommonPopup_movein", 0, 0)
  end
end

function UIShowReason:OnCloseBtnClick()
  if self.isShow then
    self.isShow = false
    local ret, time = self.root_anim:PlayAnimationReturnTime("CommonPopup_moveout")
    if ret and self.closeTimer == nil then
      self.closeTimer = TimerManager:GetInstance():GetTimer(time, function()
        self:RemoveCloseTimer()
        if not self.isShow then
          self.root_anim:SetActive(false)
        end
      end, self, true, false, false)
      self.closeTimer:Start()
    end
  end
end

function UIShowReason:RemoveCloseTimer()
  if self.closeTimer ~= nil then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
end

function UIShowReason:ShowCells()
  self:DeleteReq()
  if self.param.cellParams ~= nil then
    self.loadCount = table.count(self.param.cellParams)
    for k, v in ipairs(self.param.cellParams) do
      self.modelReq[k] = self:GameObjectInstantiateAsync(UIAssets.UIShowReasonDesCell, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.cell_parent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:SetAsLastSibling()
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local model = self.cell_parent:AddComponent(UIShowReasonDesCell, nameStr)
        model:ReInit(v)
        self.loadCount = self.loadCount - 1
        if self.loadCount <= 0 then
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.cell_parent.rectTransform)
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root_go.rectTransform)
        end
      end)
    end
  end
end

function UIShowReason:DeleteReq()
  if self.modelReq ~= nil then
    for k, v in ipairs(self.modelReq) do
      v:Destroy()
    end
    self.modelReq = {}
  end
end

return UIShowReason
