local CumulativeRecharge = BaseClass("CumulativeRecharge", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICumulativeItem = require("UI.UIGiftPackage.Component.UICumulativeItem")
local view_path = "RightView"
local scroll_path = "RightView/Scroll"
local content_path = "RightView/Scroll/Content"
local score_txt_path = "RightView/Rect_Bottom/Txt_Score"
local getmore_btn_path = "RightView/Rect_Bottom/Btn_GetMore"
local getmore_txt_path = "RightView/Rect_Bottom/Btn_GetMore/Txt_GetMore"
local time_txt_path = "RightView/Rect_Bottom/Img_Time/Txt_Time"
local title_txt_path = "RightView/Rect_Bottom/layout/title_main"
local titleTop_txt_path = "RightView/Rect_Bottom/layout/title_mainTop"
local desc_txt_path = "RightView/Rect_Bottom/Txt_Desc"
local intro_path = "RightView/Rect_Bottom/layout/Intro"
local img_car_path = "RightView/Img_Car"
local img_car_pro2 = "RightView/Img_Car/Img_Pro2"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.img_car.transform:SetParent(self.view_path.transform)
  self.img_car:SetActive(false)
  self.img_car = nil
  self.anim_car = nil
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  if self.moveTime ~= nil then
    self.moveTime:Stop()
    self.moveTime = nil
  end
end

local function ComponentDefine(self)
  self.view_path = self:AddComponent(UIBaseComponent, view_path)
  self._score_txt = self:AddComponent(UIText, score_txt_path)
  self.scroll = self:AddComponent(UIScrollRect, scroll_path)
  self.content_sv = self:AddComponent(HorizontalInfinityScrollView, content_path)
  self._time_txt = self:AddComponent(UIText, time_txt_path)
  self._getMore_btn = self:AddComponent(UIButton, getmore_btn_path)
  self._getMore_btn:SetOnClick(function()
    self:OnClickGetMore()
  end)
  self.title_txt = self:AddComponent(UIText, title_txt_path)
  self.title_txt:SetLocalText(320410)
  self.titleTop_txt = self:AddComponent(UIText, titleTop_txt_path)
  self.titleTop_txt:SetLocalText(320410)
  self.getMore_txt = self:AddComponent(UIText, getmore_txt_path)
  self.getMore_txt:SetLocalText(320413)
  self.desc_txt = self:AddComponent(UIText, desc_txt_path)
  self.desc_txt:SetLocalText(320411)
  self.intro_btn = self:AddComponent(UIButton, intro_path)
  self.intro_btn:SetOnClick(function()
    UIUtil.ShowIntro(Localization:GetString("320410"), Localization:GetString("100239"), Localization:GetString("320412"))
  end)
  self.img_car = self:AddComponent(UIBaseComponent, img_car_path)
  self.anim_car = self:AddComponent(UIAnimator, img_car_path)
  self.img_car_pro2 = self:AddComponent(UIBaseComponent, img_car_pro2)
end

local function ComponentDestroy(self)
  self._score_txt = nil
  self._time_txt = nil
  self._getMore_btn = nil
  self.title_txt = nil
  self.titleTop_txt = nil
  self.desc_txt_path = nil
  self.intro_btn = nil
end

local function DataDefine(self)
  self.isFirst = true
  self.itemList = {}
  self.dataList = {}
  self.cell = {}
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.timerTree = nil
  
  function self.timer_actionTree(temp)
    self:RefreshTreeTime(temp)
  end
end

local function DataDestroy(self)
  self.itemList = nil
  self.dataList = nil
  self.cell = nil
  self.isFirst = nil
  self:DeleteTimer()
  self:DeleteTreeTimer()
  if self.moveTime ~= nil then
    self.moveTime:Stop()
    self.moveTime = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CumulativeReward, self.UpdateCellByStageId)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CumulativeReward, self.UpdateCellByStageId)
end

local function ReInit(self, welfarelist)
  self.welfarelist = welfarelist
  self.rechargeId, self.dataList = DataCenter.CumulativeRechargeManager:GetInfo()
  self._score_txt:SetText(self.dataList.score)
  self.curStage = DataCenter.CumulativeRechargeManager:GetCurStage(self.rechargeId)
  local lastStage = DataCenter.CumulativeRechargeManager:GetLastStage()
  local isStageFirst = DataCenter.CumulativeRechargeManager:GetStageIsFirst()
  self.listKill = self:ComputeKillTree(lastStage, self.curStage)
  if isStageFirst then
    self.listKill = {}
  end
  if self.isFirst then
    local OnInitCell = BindCallback(self, self.OnInitCell)
    local OnUpdateCell = BindCallback(self, self.OnUpdateCell)
    local OnDestroyCell = BindCallback(self, self.OnDestroyCell)
    self.content_sv:Init(OnInitCell, OnUpdateCell, OnDestroyCell)
    self.content_sv:SetItemCount(#self.dataList.stageInfo)
    self.isFirst = false
  else
    self.content_sv:ForceUpdate()
  end
  self.img_car:SetActive(true)
  self.img_car.transform:SetParent(self.content_sv.transform)
  self.img_car.transform:SetAsLastSibling()
  self.img_car:SetAnchoredPosition(Vector2.New(0, -31))
  if self.curStage ~= lastStage then
    DataCenter.CumulativeRechargeManager:SetCurStage(self.curStage)
    if isStageFirst then
      self.img_car:SetSizeDelta(self:ComputeCarPos(self.curStage))
      local canRecv = DataCenter.CumulativeRechargeManager:CheckCanRecv()
      if canRecv ~= 0 then
        self.content_sv:MoveItemByIndex(canRecv - 1, 0)
      else
        self.content_sv:MoveItemByIndex(self.curStage - 1, 0)
      end
    else
      self.img_car:SetSizeDelta(self:ComputeCarPos(lastStage))
      local listKill = self.listKill
      self:AddTreeTimer()
      self.moveTime = TimerManager:GetInstance():DelayInvoke(function()
        self.anim_car:Play("V_ui_tuituche_zhuan", 0, 0)
        local targetPos = self:ComputeCarPos(self.curStage)
        local time = #listKill
        self.img_car.rectTransform:DOSizeDelta(targetPos, time, true):OnComplete(function()
          DOTween.Kill(self.img_car.transform)
          self.anim_car:Play("V_ui_tuituche_daiji", 0, 0)
          self:DeleteTreeTimer()
        end):SetEase(CS.DG.Tweening.Ease.Linear)
      end, 1)
    end
  else
    self.img_car:SetSizeDelta(self:ComputeCarPos(self.curStage))
    local canRecv = DataCenter.CumulativeRechargeManager:CheckCanRecv()
    if canRecv ~= 0 then
      self.content_sv:MoveItemByIndex(canRecv - 1, 0)
    else
      self.content_sv:MoveItemByIndex(self.curStage - 1, 0)
    end
  end
  self.anim_car:Play("V_ui_tuituche_daiji", 0, 0)
  self:RefreshTime()
  self:AddTimer()
end

local function ComputeCarPos(self, Stage, isPos)
  local y = 124
  if isPos then
    y = -31
  end
  if Stage == 0 then
    return Vector2.New(0, y)
  elseif Stage == 1 then
    return Vector2.New(200, y)
  else
    return Vector2.New(208 * Stage - 14, y)
  end
end

local function ComputeKillTree(self, initStage, targetStage)
  local list = {}
  for i = initStage, targetStage do
    if i == targetStage then
      break
    end
    table.insert(list, i + 1)
  end
  return list
end

local function OnInitCell(self, go, index)
  local item = self.scroll:AddComponent(UICumulativeItem, go)
  self.itemList[go] = item
end

local function OnUpdateCell(self, go, index)
  local item = self.itemList[go]
  local data = self.dataList.stageInfo[index + 1]
  go.name = self.dataList.stageInfo[index + 1].needScore
  go:SetActive(true)
  item:ReInit({
    rechargeId = self.rechargeId,
    info = data,
    scrollView = self.scroll,
    curScore = self.dataList.score,
    curStage = self.curStage,
    index = index + 1,
    listKill = self.listKill
  })
  self.cell[data.stageId] = item
end

local function OnDestroyCell(self, go, index)
end

local function ClearScroll(self)
  self.scroll:RemoveComponents(UICumulativeItem)
  self.content_sv:DestroyChildNode()
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = self.dataList.endTime - curTime
  if 0 < deltaTime then
    self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
  else
    self.view.ctrl:CloseSelf()
  end
end

local function DeleteTimer(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTreeTimer(self)
  if self.timerTree == nil then
    self.timerTree = TimerManager:GetInstance():GetTimer(0.1, self.timer_actionTree, self, false, false, false)
  end
  self.timerTree:Start()
end

local function RefreshTreeTime(self)
  local x = self.img_car:GetSizeDelta().x
  if 60 < x and x < 80 then
    self:DoTreeAnim(1)
  elseif 240 < x and x < 260 then
    self:DoTreeAnim(2)
    self.isDoAnim = false
  elseif 450 < x and x < 470 then
    self:DoTreeAnim(3)
  elseif 660 < x and x < 680 then
    self:DoTreeAnim(4)
  elseif 870 < x and x < 890 then
    self:DoTreeAnim(5)
  elseif 1080 < x and x < 1100 then
    self:DoTreeAnim(6)
  elseif 1290 < x and x < 1310 then
    self:DoTreeAnim(7)
  elseif 1500 < x and x < 1520 then
    self:DoTreeAnim(8)
  end
end

local function DoTreeAnim(self, index)
  if index == self.isDoAnim then
    return
  end
  self.isDoAnim = index
  for i = 1, #self.listKill do
    for k, v in pairs(self.cell) do
      if self.listKill[i] == v.param.index then
        v:TestAnim(self.curStage)
        table.remove(self.listKill, i)
        return
      end
    end
  end
end

local function DeleteTreeTimer(self)
  if self.timerTree then
    self.timerTree:Stop()
    self.timerTree = nil
  end
end

local function UpdateCellByStageId(self, param)
  self.cell[param]:RewardUpdate()
end

local function OnClickGetMore(self)
  for i = 1, #self.welfarelist do
    self.view:GotoButtonType(self.welfarelist[i]:getType())
    break
  end
end

CumulativeRecharge.OnCreate = OnCreate
CumulativeRecharge.OnDestroy = OnDestroy
CumulativeRecharge.OnEnable = OnEnable
CumulativeRecharge.OnDisable = OnDisable
CumulativeRecharge.ComponentDefine = ComponentDefine
CumulativeRecharge.ComponentDestroy = ComponentDestroy
CumulativeRecharge.DataDefine = DataDefine
CumulativeRecharge.DataDestroy = DataDestroy
CumulativeRecharge.OnAddListener = OnAddListener
CumulativeRecharge.OnRemoveListener = OnRemoveListener
CumulativeRecharge.OnInitCell = OnInitCell
CumulativeRecharge.OnUpdateCell = OnUpdateCell
CumulativeRecharge.OnDestroyCell = OnDestroyCell
CumulativeRecharge.ReInit = ReInit
CumulativeRecharge.ClearScroll = ClearScroll
CumulativeRecharge.AddTimer = AddTimer
CumulativeRecharge.RefreshTime = RefreshTime
CumulativeRecharge.DeleteTimer = DeleteTimer
CumulativeRecharge.UpdateCellByStageId = UpdateCellByStageId
CumulativeRecharge.OnClickGetMore = OnClickGetMore
CumulativeRecharge.ComputeCarPos = ComputeCarPos
CumulativeRecharge.ComputeKillTree = ComputeKillTree
CumulativeRecharge.AddTreeTimer = AddTreeTimer
CumulativeRecharge.RefreshTreeTime = RefreshTreeTime
CumulativeRecharge.DeleteTreeTimer = DeleteTreeTimer
CumulativeRecharge.DoTreeAnim = DoTreeAnim
return CumulativeRecharge
