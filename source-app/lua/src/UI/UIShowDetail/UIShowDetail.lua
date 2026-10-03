local UIShowDetail = BaseClass("UIShowDetail", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIDesCell = require("UI.UIBuildUpgrade.Component.UIDesCell")
local this_path = ""
local close_btn_path = "CloseBtn"

function UIShowDetail:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIShowDetail:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIShowDetail:OnEnable()
  base.OnEnable(self)
end

function UIShowDetail:OnDisable()
  base.OnDisable(self)
end

function UIShowDetail:ComponentDefine()
  self.root_anim = self:AddComponent(UIAnimator, this_path)
  self.root_anim:SetActive(false)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self:OnCloseBtnClick()
  end)
end

function UIShowDetail:ComponentDestroy()
  self.root_anim = nil
  self.close_btn = nil
end

function UIShowDetail:DataDefine()
  self.param = {}
  self.isShow = false
  self.closeTimer = nil
  self.modelReq = {}
  self.loadCount = 0
end

function UIShowDetail:DataDestroy()
  self:RemoveCloseTimer()
  self.param = nil
  self.closeTimer = nil
  self.isShow = nil
  self.modelReq = nil
  self.loadCount = nil
end

function UIShowDetail:OnShow(param)
  self.param = param
  self.close_btn.transform.position = self.param.position
  self.close_btn.transform:Set_sizeDelta(self.param.sizeX, self.param.sizeY)
  if not self.isShow then
    self.isShow = true
    self.root_anim:SetActive(true)
    self.root_anim:Play("CommonPopup_movein", 0, 0)
    self:ShowCells()
  end
end

function UIShowDetail:OnCloseBtnClick()
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

function UIShowDetail:RemoveCloseTimer()
  if self.closeTimer ~= nil then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
end

function UIShowDetail:ShowCells()
  self:InitList()
  self:DeleteReq()
  self.loadCount = table.count(self.list)
  for k, v in ipairs(self.list) do
    self.modelReq[k] = self:GameObjectInstantiateAsync(UIAssets.UIBuildUpgradeSuccessCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:SetAsLastSibling()
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local model = self:AddComponent(UIDesCell, nameStr)
      model:ReInit(v)
      self.loadCount = self.loadCount - 1
      if self.loadCount <= 0 then
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
      end
    end)
  end
end

function UIShowDetail:DeleteReq()
  if self.modelReq ~= nil then
    for k, v in ipairs(self.modelReq) do
      v:Destroy()
    end
    self.modelReq = {}
  end
end

function UIShowDetail:InitList()
  self.list = {}
  local curNums = self.param.buildCurLevelTemplate.local_num
  if self.param.buildNextLevelTemplate ~= nil then
    local nextNums = self.param.buildNextLevelTemplate.local_num
    local maxCount = table.count(nextNums)
    local diaCount = table.count(self.param.buildTemplate.effect_Local_dialog)
    if maxCount > diaCount then
      maxCount = diaCount
    end
    if 0 < maxCount then
      for i = 1, maxCount do
        local param = {}
        local dialog = self.param.buildTemplate.effect_Local_dialog[i]
        param.name = Localization:GetString(dialog)
        local type = self.param.buildTemplate.effect_Local_type[i]
        local needAdd = true
        if type == EffectLocalType.Dialog then
          local val = DataCenter.BuildManager:GetEffectNumWithType(nextNums[i], type)
          if val == nil or val == "" then
            needAdd = false
          end
          param.addValue = val
        else
          param.curValue = DataCenter.BuildManager:GetEffectNumWithType(tonumber(curNums[i]) or 0, type)
          param.addValue = DataCenter.BuildManager:GetEffectNumWithType(tonumber(nextNums[i]) or 0, type)
        end
        if needAdd then
          table.insert(self.list, param)
        end
      end
    end
    local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k1")
    if showPower <= DataCenter.BuildManager.MainLv then
      local param = {}
      param.name = Localization:GetString(GameDialogDefine.POWER)
      if self.param.buildNextLevelTemplate ~= nil then
        param.curValue = self.param.buildCurLevelTemplate.power
        param.addValue = self.param.buildNextLevelTemplate.power
      else
        param.addValue = self.param.buildCurLevelTemplate.power
      end
      table.insert(self.list, param)
    end
  end
end

return UIShowDetail
