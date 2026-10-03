local base = UIAsyncContainer
local LLMiniMapProgress = BaseClass("LLMiniMapProgress", base)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr
local BOX_PREFAB = "Assets/Main/Prefabs/UI/Landlord/World/LLMiniMapProgressBox.prefab"
local BOX_CLS = "UI.LandlordBattle.BattleMainUI.Component.LLMiniMapProgressBox"
local LP_PREFAB = "Assets/Main/Prefabs/UI/Landlord/World/LLMiniMapProgressLP.prefab"
local LP_CLS = "UI.LandlordBattle.BattleMainUI.Component.LLMiniMapProgressLP"

function LLMiniMapProgress:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMiniMapProgress:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMiniMapProgress:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.slider = self.viewSkin:AddComponent(self, UISlider, 1)
  self.imgFill = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textPercent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 4)
  self.btnSlider = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnSlider:SetOnClick(function()
    self:OnBtnSliderClick()
  end)
  self.imgIconR = self.viewSkin:AddComponent(self, UIImage, 6)
  self.imgIconL = self.viewSkin:AddComponent(self, UIImage, 7)
  self.imgFillDi = self.viewSkin:AddComponent(self, UIImage, 8)
  self.btnScore = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnScore:SetOnClick(function()
    self:OnBtnScoreClick()
  end)
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
end

function LLMiniMapProgress:ComponentDestroy()
  self.viewSkin = nil
  self.slider = nil
  self.imgFill = nil
  self.textPercent = nil
  self.imgIcon = nil
  self.btnSlider = nil
  self.imgIconR = nil
  self.imgIconL = nil
  self.imgFillDi = nil
  self.btnScore = nil
  self.textScore = nil
end

function LLMiniMapProgress:DataDefine()
end

function LLMiniMapProgress:DataDestroy()
  self.camp = nil
  self.updateBattleInfo = nil
  self.initFlag = false
  self.boxItems = nil
  self.lpItems = nil
end

function LLMiniMapProgress:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordActBattleInfo, self.RefreshView)
end

function LLMiniMapProgress:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordActBattleInfo, self.RefreshView)
  base.OnRemoveListener(self)
end

function LLMiniMapProgress:OnBtnSliderClick()
  if ActMgr:IsInMyServerGroup() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILLTaskBarTip, {anim = true}, self.btnSlider, self.clickJump)
  end
end

function LLMiniMapProgress:OnBtnScoreClick()
  if ActMgr:IsInMyServerGroup() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILLTaskBarTip, {anim = true}, self.btnSlider, self.clickJump)
  end
end

function LLMiniMapProgress:SetCamp(camp, updateBattleInfo, clickJump)
  self.camp = camp
  self.updateBattleInfo = updateBattleInfo
  self.clickJump = clickJump
  self.initFlag = true
  if self.camp == 0 then
    self.camp = LLConst.LandLordGroup.FARMER
  end
  self.curStage = ActMgr:GetActCurStage()
  self:TryUpdateBattleInfo()
  self:RefreshView()
end

function LLMiniMapProgress:UpdateData()
  if self.camp == nil then
    return
  end
  if self.initFlag then
    local bLord = self.camp == LLConst.LandLordGroup.LORD
    self.imgIcon:LoadSpriteAuto(string.format(LoadPath.LandlordPath, bLord and "lrb_jinmai_beizhan_pocheng_hong.png" or "lrb_jinmai_beizhan_pocheng_lan.png"))
    self.imgIconL:LoadSpriteAuto(string.format(LoadPath.LandlordPath, bLord and "lrb_jinmai_fenzu_fangshou.png" or "lrb_jinmai_fenzu_gongji.png"))
    self.imgIconR:LoadSpriteAuto(string.format(LoadPath.LandlordPath, bLord and "lrb_jinmai_fenzu_gongji.png" or "lrb_jinmai_fenzu_fangshou.png"))
  end
  self:RefreshScoreNum()
  local value = Mathf.Clamp(self.curScore / self.curMax, 0.01, 0.99)
  self.slider:SetValue(value)
  self.textScore:SetText(self.curScore)
  self.textPercent:SetText(self.curMax)
  if self.initFlag or self.lastScore ~= self.curScore then
    self.lastScore = self.curScore
    self:RefreshBox()
  end
  self.initFlag = false
end

function LLMiniMapProgress:RefreshScoreNum()
  local maxWeek = ActMgr:GetBattleWeek()
  local curWeek = Mathf.Clamp(ActMgr:GetCurWeek(), 1, maxWeek)
  self.lastScore = self.curScore or 0
  self.curScore = ActMgr:GetDestroyScore()
  self.curMax = ActMgr:GetCityDestroyScoreMax(curWeek)
  if self.camp == LLConst.LandLordGroup.LORD then
    self.curScore = self.curMax - self.curScore
  end
end

function LLMiniMapProgress:RefreshBox()
  local rewardInfos = ActMgr:GetReward(LLConst.RewardType.Week, self.camp)
  local infos = {}
  local maxShow = 5
  local curShow = 0
  if ActMgr:IsInMyServerGroup() then
    for _, info in ipairs(rewardInfos) do
      local state = ActMgr:CheckWeekRewardState(info, self.camp)
      if state == 1 then
        table.insert(infos, info)
        curShow = curShow + 1
        if curShow == maxShow then
          break
        end
      end
    end
  end
  local width = self:GetSizeDeltaXY()
  self.boxItems = self.boxItems or {}
  self.lpItems = self.lpItems or {}
  local max = math.max(#infos, #self.lpItems)
  for i = 1, max do
    local info = infos[i]
    local lp = self.lpItems[i]
    local box = self.boxItems[i]
    if info ~= nil then
      local idx = i
      local percent = info.para[2] / self.curMax
      local x = width * percent - 4
      if lp == nil then
        lp = self:LoadComponentAsync(LP_CLS, LP_PREFAB, self, function()
          lp:SetAnchoredPositionXY(x, 0)
          self:RefreshBoxPos(idx)
        end)
        self.lpItems[i] = lp
      elseif lp:AsyncLoadDone() then
        lp:SetAnchoredPositionXY(x, 0)
        self:RefreshBoxPos(idx)
      end
      lp:SetName("LP_" .. i)
      if box == nil then
        box = self:LoadComponentAsync(BOX_CLS, BOX_PREFAB, self, function()
          box:SetAnchoredPositionXY(x, -20)
          self:RefreshBoxPos(idx)
        end)
        self.boxItems[i] = box
      elseif box:AsyncLoadDone() then
        box:SetAnchoredPositionXY(x, -20)
        self:RefreshBoxPos(idx)
      end
      box:SetName("Box_" .. i)
      box:SetReward(info, self.curScore, self.camp, self.clickJump)
    else
      if lp ~= nil then
        lp:SetActive(false)
      end
      if box ~= nil then
        box:SetActive(false)
      end
    end
  end
end

function LLMiniMapProgress:RefreshBoxPos(idx)
  local minPart = 85
  local lp = self.lpItems[idx]
  local box = self.boxItems[idx]
  if lp == nil or box == nil or not lp:GetActive() then
    return
  end
  if not lp:AsyncLoadDone() or not box:AsyncLoadDone() then
    return
  end
  local lx = lp:GetAnchoredPositionX()
  local by = box:GetAnchoredPositionY()
  if idx == 1 then
    box:SetAnchoredPositionXY(lx, by)
  else
    local lastBox = self.boxItems[idx - 1]
    local lbx = lastBox:GetAnchoredPositionX()
    if minPart > lx - lbx then
      box:SetAnchoredPositionXY(lbx + minPart, by)
    else
      box:SetAnchoredPositionXY(lx, by)
    end
  end
  box:SetActive(true)
  lp:SetTarget(box)
end

function LLMiniMapProgress:TryUpdateBattleInfo()
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local bInMyGroup = ActMgr:IsInMyServerGroup()
  local checkTime = bInMyGroup and 5 or 10
  if self.lastReqBITime == nil or checkTime < curSec - self.lastReqBITime then
    if bInMyGroup then
      ActMgr:ReqActBattleInfo()
    else
      ActMgr:ReqTargetServerDestroyScore()
    end
    self.lastReqBITime = curSec
  end
end

function LLMiniMapProgress:Update1000MS()
  if self.curStage ~= LLConst.LandlordStage.BATTLE or not self.updateBattleInfo then
    return
  end
  self:TryUpdateBattleInfo()
end

return LLMiniMapProgress
