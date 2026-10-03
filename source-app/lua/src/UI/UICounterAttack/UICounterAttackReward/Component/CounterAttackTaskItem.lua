local CounterAttackTaskItem = BaseClass("CounterAttackTaskItem", UIBaseContainer)
local base = UIBaseContainer
local RewardUtil = require("Util.RewardUtil")
local UIGray = CS.UIGray
local name_text_path = "NameText"
local reward_content_path = "ScrollView/Viewport/RewardContent"
local go_btn_path = "GoBtn"
local btn_text_path = "GoBtn/BtnText"
local finish_path = "finish"

function CounterAttackTaskItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function CounterAttackTaskItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function CounterAttackTaskItem:ComponentDefine()
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, btn_text_path)
  self.btn_text:SetLocalText("457010")
  self.finish = self:AddComponent(UIImage, finish_path)
  self.go_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.itemReqs = {}
  self.itemComps = {}
end

function CounterAttackTaskItem:ComponentDestroy()
  self:RemoveRewards()
end

function CounterAttackTaskItem:DataDefine()
  self.oldState = nil
  self.data = nil
end

function CounterAttackTaskItem:DataDestroy()
  self.oldState = nil
  self.data = nil
end

function CounterAttackTaskItem:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.OnCounterAttackRoundAward, self.Refresh)
end

function CounterAttackTaskItem:OnDisable()
  self:RemoveUIListener(EventId.OnCounterAttackRoundAward, self.Refresh)
  base.OnDisable(self)
end

function CounterAttackTaskItem:RemoveRewards()
  self.content:RemoveComponents(UICommonResItem)
  self.itemComps = {}
  if self.itemReqs then
    for _, req in ipairs(self.itemReqs) do
      req:Destroy()
    end
  end
  self.itemReqs = {}
end

function CounterAttackTaskItem:Refresh(round)
  if not self.data or self.data.round ~= round then
    return
  end
  local taskState = self.data.state
  if taskState == TaskState.Received then
    self.go_btn:SetActive(false)
    self.finish:SetActive(true)
    if self.oldState and self.oldState == TaskState.CanReceive then
      self:PlayReceiveAnim()
    end
  elseif taskState == TaskState.CanReceive then
    self.go_btn:SetActive(true)
    self.finish:SetActive(false)
    UIGray.SetGray(self.go_btn.transform, false, true)
  else
    self.go_btn:SetActive(true)
    self.finish:SetActive(false)
    UIGray.SetGray(self.go_btn.transform, true, true)
  end
  self.oldState = taskState
end

function CounterAttackTaskItem:PlayReceiveAnim()
  for i, v in ipairs(self.data.rewardShow) do
    local rewardType = v.rewardType
    local itemId = v.itemId
    local pic = RewardUtil.GetPic(v.rewardType, itemId)
    local req = self.itemReqs[i]
    if pic ~= "" and not IsNull(req) then
      UIUtil.DoFly(tonumber(rewardType), 3, pic, req.gameObject.transform.position, Vector3.New(0, 0, 0))
    end
  end
end

function CounterAttackTaskItem:ReInit(taskData)
  self.data = taskData
  self.name_text:SetLocalText("season_activity1000016_desc015", self.data.round)
  self:Refresh(self.data.round)
  local rewardList = taskData.rewardShow or {}
  if #self.itemComps == #rewardList then
    for i = 1, #rewardList do
      local data = rewardList[i]
      local param = UICommonResItem.Param.New()
      param.rewardType = data.type
      if type(data.value) == "table" then
        param.itemId = data.value.id
        param.count = data.value.num
      else
        param.itemId = data.type
        param.count = data.value
      end
      param.rewardType = data.type
      param.heroUuid = data.heroUuid
      param.isHeroBox = data.isHeroBox
      self.itemComps[i]:ReInit(param)
    end
    return
  end
  self:RemoveRewards()
  if #rewardList == 0 then
    return
  end
  for i = 1, #rewardList do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local transform = go.transform
      go:SetActive(true)
      transform:SetParent(self.content.transform)
      transform:Set_localScale(0.7, 0.7, 1)
      transform:Set_sizeDelta(150, 150)
      transform:Set_pivot(0, 1)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.content:AddComponent(UICommonResItem, nameStr)
      local data = rewardList[i]
      local param = UICommonResItem.Param.New()
      param.rewardType = data.type
      if type(data.value) == "table" then
        param.itemId = data.value.id
        param.count = data.value.num
      else
        param.itemId = data.type
        param.count = data.value
      end
      param.rewardType = data.type
      param.heroUuid = data.heroUuid
      param.isHeroBox = data.isHeroBox
      cell:ReInit(param)
      self.itemComps[i] = cell
    end)
  end
end

function CounterAttackTaskItem:OnBtnClick()
  local taskState = self.data.state
  if taskState == TaskState.NoComplete then
    if self.data.reason == 0 then
      UIUtil.ShowTipsId("season_activity1000016_desc022")
    elseif self.data.reason == 1 then
      UIUtil.ShowTipsId("season_activity1000016_desc020")
    else
      UIUtil.ShowTipsId("season_activity1000016_desc021")
    end
  elseif taskState == TaskState.CanReceive then
    DataCenter.CounterAttackDataManager:SendMsgCollectRoundAward(self.data.round)
  end
end

return CounterAttackTaskItem
