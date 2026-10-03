local LWMainDesertCommandOrderItem = BaseClass("LWMainDesertCommandOrderItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ActDragonCommandOrderData = require("DataCenter.ActDragonManager.ActDragonCommandOrderData")
local di_path = "di"
local replace_path = "Replace"
local img_main_path = "main/ct"
local img_build_path = "main/ct/BuildIcon"
local img_new_path = "main/ct/New"
local op_path = "main/ct/Qp"
local icon_head_path = "main/ct/Qp/mask/HeadIcon"
local img_type_path = "main/ct/state/TypeImg"
local img_person_path = "main/ct/state/PersonImg"
local text_num_path = "main/ct/state/NumText"
local btn_main_path = "MainBtn"
local IMG_MY = "mjc_smfb_zhiling_bg1"
local IMG_OTHER = "mjc_smfb_zhiling_bg"
local IMG_UN_SEE = "mjc_shamofengbao_renshu_icon"
local IMG_SEE = "mjc_shamofengbao_renshu_icon1"

function LWMainDesertCommandOrderItem:OnCreate()
  base.OnCreate(self)
  self.order = ActDragonCommandOrderData.New()
  self.anim = self:AddComponent(UIAnimator, "")
  self.anim:Enable(false)
  self.di = self:AddComponent(UIBaseComponent, di_path)
  self.replace = self:AddComponent(UIBaseComponent, replace_path)
  self.img_main = self:AddComponent(UIImage, img_main_path)
  self.img_build = self:AddComponent(UIImage, img_build_path)
  self.img_new = self:AddComponent(UIImage, img_new_path)
  self.img_qp = self:AddComponent(UIBaseComponent, op_path)
  self.icon_head = self.transform:Find(icon_head_path):GetComponent(typeof(CS.UIPlayerHead))
  self.img_type = self:AddComponent(UIImage, img_type_path)
  self.img_person = self:AddComponent(UIImage, img_person_path)
  self.text_num = self:AddComponent(UIText, text_num_path)
  self.btn_main = self:AddComponent(UIButton, btn_main_path)
  self.btn_main:SetOnClick(BindCallback(self, self.OnBtnClick))
end

function LWMainDesertCommandOrderItem:OnDestroy()
  if self.animTimer then
    self.animTimer:Stop()
  end
  self.animTimer = nil
  self.info = nil
  self.order = nil
  base.OnDestroy(self)
end

function LWMainDesertCommandOrderItem:ReInit(idx, uiCO)
  self.idx = idx
  self.uiCO = uiCO
end

function LWMainDesertCommandOrderItem:OnBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.replace:GetActive() then
    if self.bMy then
      self:DoReplace()
    else
      local now = UITimeManager:GetInstance():GetServerSeconds()
      local time = CommonUtil.PlayerPrefsGetString(SettingKeys.DESERT_BATTLE_REPLACE_LOCAL_TIME, "")
      if UITimeManager:GetInstance():IsSameDayForServer(tonumber(time) or 0, now) then
        self:DoReplace()
      else
        UIUtil.ShowSecondMessageByParam({
          tipText = Localization:GetString("Desert_strom_commander_1037", self.commanderName),
          btnNum = 2,
          showToggle = true,
          toggleAction = function(isOn)
            if isOn then
              CommonUtil.PlayerPrefsSetString(SettingKeys.DESERT_BATTLE_REPLACE_LOCAL_TIME, "")
            else
              CommonUtil.PlayerPrefsSetString(SettingKeys.DESERT_BATTLE_REPLACE_LOCAL_TIME, now)
            end
          end,
          sureAction = function()
            self:DoReplace()
          end
        })
      end
    end
    return
  end
  self.uiCO:TryExec(self.idx)
end

function LWMainDesertCommandOrderItem:DoReplace()
  DataCenter.ActDragonManager:SendCommandOrder(self.idx, self.info)
  self.uiCO:ShowCommandOrder()
end

function LWMainDesertCommandOrderItem:SetOrderShow(order, info)
  self:PlayOrderAnim("BattleCommandOrderCardidle", nil, function()
    self:SetActive(true)
    if self.order.index == 0 then
      self:Refresh(order, info)
      self:PlayOrderAnim("BattleCommandOrderCardIn")
    elseif self.order:IsSame(order) then
      self:Refresh(order, info)
    else
      self:PlayOrderAnim("BattleCommandOrderCardChange", 0.2, function()
        self:Refresh(order, info)
      end)
    end
  end)
end

function LWMainDesertCommandOrderItem:Refresh(order, info)
  self.info = info
  self.order:CopyOrder(order)
  self.di:SetActive(info ~= nil)
  self.replace:SetActive(info ~= nil)
  self.btn_main:SetActive(true)
  local mgr = DataCenter.ActDragonManager
  self.bMy = order.commander == LuaEntry.Player:GetUid()
  self.img_main:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDesertPath, self.bMy and IMG_MY or IMG_OTHER))
  local icon = mgr:GetOrderIcon(order)
  if not string.IsNullOrEmpty(icon) then
    self.img_build:LoadSpriteAsyncWithCallback(icon, function(texture)
      if self.img_build then
        self.img_build:SetNativeSize()
      end
    end)
  end
  local pFlag = false
  if not BattleFieldUtil.isObserve then
    pFlag = info == nil and not order.hadJoin and not self.bMy
  end
  self.img_type:LoadSpriteAuto(mgr:GetOrderImgByType(order.type))
  self.img_person:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDesertPath, pFlag and IMG_UN_SEE or IMG_SEE))
  self.img_person:SetColorRGBA(pFlag and 1 or 0, 1, pFlag and 1 or 0, 1)
  self.text_num:SetText(order.joinCount)
  self.text_num:SetColorRGBA(pFlag and 1 or 0, 1, pFlag and 1 or 0, 1)
  self.img_qp:SetActive(true)
  local pInfo = mgr:GetPlayerInfoByUID(order.commander)
  self.img_qp:SetActive(pInfo ~= nil)
  if pInfo ~= nil then
    self.commanderName = UIUtil.FormatAllianceAndName(nil, pInfo.name, pInfo.uid)
    self.icon_head:SetData(pInfo.uid, pInfo.pic, pInfo.picVer, false)
  else
    self.commanderName = ""
  end
  self.img_new:SetActive(order.bNew)
end

function LWMainDesertCommandOrderItem:HideOrder()
  self:PlayOrderAnim("BattleCommandOrderCardidle", nil, function()
    if self.order.index == 0 then
      self:SetActive(false)
    else
      self:PlayOrderAnim("BattleCommandOrderCardClose", nil, function()
        self:SetActive(false)
      end)
    end
    self.info = nil
    self.order:ResetData()
  end)
end

function LWMainDesertCommandOrderItem:PlayOrderAnim(name, percent, cb)
  if self.animTimer then
    self.animTimer:Stop()
  end
  self.animTimer = nil
  self.anim:Enable(true)
  local ret, time = self.anim:PlayAnimationReturnTime(name)
  if ret then
    if percent then
      time = percent * time
    end
    self.animTimer = TimerManager:GetInstance():DelayInvoke(function()
      if percent == nil then
        if self.animTimer then
          self.animTimer:Stop()
        end
        self.animTimer = nil
        self.anim:Enable(false)
      end
      if cb then
        cb()
      end
    end, time)
  elseif cb then
    cb()
  end
end

return LWMainDesertCommandOrderItem
