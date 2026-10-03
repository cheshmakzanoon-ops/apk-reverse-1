local LWPowerOverviewView = BaseClass("LWPowerOverviewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWPowerOverviewItem = require("UI.LWPowerOverview.Component.LWPowerOverviewItem")
local titlePath = "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local black_mask_path = "UICommonPopUpTitle/panel"
local content_path = "Root/Scroll/Viewport/Content"
local confirm_btn_path = "Root/ConfirmBtn"
local confirm_btn_text_path = "Root/ConfirmBtn/ConfirmBtnText"
local confirm_btn_red_path = "Root/ConfirmBtn/RedConfirm"

function LWPowerOverviewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  local selfUid = LuaEntry.Player:GetUid()
  SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, selfUid)
end

function LWPowerOverviewView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWPowerOverviewView:ComponentDefine()
  self.title = self:AddComponent(UIText, titlePath)
  self.title:SetLocalText("power_stats_tip1")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.maskBtnN = self:AddComponent(UIButton, black_mask_path)
  self.maskBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn_text = self:AddComponent(UIText, confirm_btn_text_path)
  self.confirm_btn_text:SetLocalText("power_stats_tip2")
  self.confirm_btn:SetOnClick(function()
    if DataCenter.PlayerPowerDataManager:IsReceiveData() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWDevelopRecommend, {anim = true})
    end
  end)
  self.conform_red = self:AddComponent(UIBaseContainer, confirm_btn_red_path)
  self.cellReqs = {}
  self.cells = {}
end

function LWPowerOverviewView:ComponentDestroy()
  self:ClearList()
  self.title = nil
  self.close_btn = nil
  self.maskBtnN = nil
  self.cellReqs = nil
  self.cells = nil
end

function LWPowerOverviewView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.ReInit)
  self:AddUIListener(EventId.DevelopRecommendEntranceRedUpdate, self.OnDevelopRecommendEntranceRedUpdate)
end

function LWPowerOverviewView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.ReInit)
  self:RemoveUIListener(EventId.DevelopRecommendEntranceRedUpdate, self.OnDevelopRecommendEntranceRedUpdate)
end

function LWPowerOverviewView:IsValShow(val, powerType)
  local isShow = true
  if val <= 0 then
    isShow = false
  end
  if T11Util.IfShowT11InCamp() then
    if powerType and powerType == PowerOverviewPowerType.armyPower then
      isShow = false
    end
  elseif powerType and powerType == PowerOverviewPowerType.superSoldierPower then
    isShow = false
  end
  return isShow
end

function LWPowerOverviewView:GetShowData()
  local showData = {}
  for powerTypeIndex, powerType in ipairs(PowerOverviewShowPower) do
    local powerTypeVal = DataCenter.PlayerPowerDataManager:GetValByPowerType(powerType)
    local isPowerTypeShow = self:IsValShow(powerTypeVal, powerType)
    if isPowerTypeShow then
      local sourceTab = {}
      local sourcePath = PowerOverviewPowerSourcePath[powerType]
      if sourcePath and 0 < #sourcePath then
        for sourceIndex, sourceType in ipairs(sourcePath) do
          local sourceVal = DataCenter.PlayerPowerDataManager:GetValByPowerSourceType(sourceType)
          local isSourceTypeShow = self:IsValShow(sourceVal)
          if isSourceTypeShow then
            table.insert(sourceTab, {sourceType = sourceType, sourceVal = sourceVal})
          end
        end
      end
      table.sort(sourceTab, function(a, b)
        return a.sourceVal > b.sourceVal
      end)
      table.insert(showData, {
        powerType = powerType,
        powerTypeVal = powerTypeVal,
        sourceTab = sourceTab,
        isShowDetail = true
      })
    end
  end
  return showData
end

function LWPowerOverviewView:ReInit()
  self.showData = self:GetShowData()
  self:RefreshContent()
  self:RefreshConfirmRed()
end

function LWPowerOverviewView:RefreshContent()
  self.content:SetAnchoredPositionXY(0, 0)
  self:ClearList()
  local showData = self.showData
  for k, v in pairs(showData) do
    self.cellReqs[k] = self:GameObjectInstantiateAsync(UIAssets.LWPowerOverviewItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(k)
      go.name = nameStr
      self.cells[k] = self.content:AddComponent(LWPowerOverviewItem, nameStr)
      self.cells[k]:Refresh(showData[k])
    end)
  end
end

function LWPowerOverviewView:ClearList()
  if self.cellReqs then
    self.content:RemoveComponents(LWPowerOverviewItem)
    for k, v in pairs(self.cellReqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cellReqs = {}
  self.cells = {}
end

function LWPowerOverviewView:RefreshConfirmRed()
  local showRed = DataCenter.LWDevelopRecommendManager:IsShowEntranceRed()
  self.conform_red:SetActive(showRed)
end

function LWPowerOverviewView:OnDevelopRecommendEntranceRedUpdate()
  self:RefreshConfirmRed()
end

return LWPowerOverviewView
