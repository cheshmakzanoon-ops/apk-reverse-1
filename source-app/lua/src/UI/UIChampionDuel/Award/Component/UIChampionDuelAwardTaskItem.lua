local UIChampionDuelAwardTaskItem = BaseClass("UIChampionDuelAwardTaskItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local text_title_path = "titleText"
local layout_path = "RewardScroll/layout"
local ylq_path = "ylq"
local btn_path = "ReceiveBtn"
local text_btn_path = "ReceiveBtn/ReceiveBtnText"

function UIChampionDuelAwardTaskItem:OnCreate()
  base.OnCreate(self)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
  self.ylq = self:AddComponent(UIImage, ylq_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnReceiveClick))
  self.text_btn = self:AddComponent(UIText, text_btn_path)
  self.text_btn:SetLocalText("170003")
  self.items = {}
end

function UIChampionDuelAwardTaskItem:OnDestroy()
  self:ClearDelays()
  self.text_title = nil
  self.ylq = nil
  self.btn = nil
  self.text_btn = nil
  self.layout:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.layout.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.layout = nil
  self.items = {}
  base.OnDestroy(self)
end

function UIChampionDuelAwardTaskItem:OnReceiveClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastBtnClickTime ~= nil and curTime - self.lastBtnClickTime <= 1000 then
    return
  end
  self.lastBtnClickTime = curTime
  if self.info then
    DataCenter.ChampionDuelManager:ReqAllRewardGet(self.info.stage)
  end
end

function UIChampionDuelAwardTaskItem:ClearDelays()
  self.layout:RemoveComponents(UICommonResItem)
  if self.asyncs then
    for _, v in pairs(self.asyncs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.asyncs = {}
end

function UIChampionDuelAwardTaskItem:ReInit(index, info)
  self:ClearDelays()
  self.info = info
  self.index = index
  local data = DataCenter.ChampionDuelManager:GetRewardInfo(info.id)
  local curNum = data ~= nil and data.value or 0
  local paras = string.split(info.para, ",")
  local needNum = tonumber(paras[2]) or 1
  local getFlag = curNum >= needNum
  local tmpCur = curNum > needNum and needNum or curNum
  local titleStr = tmpCur .. "/" .. needNum
  if getFlag then
    titleStr = string.format("<color=#73A863>%s</color>", titleStr)
  end
  self.text_title:SetText(Localization:GetString(info.task_desc, needNum) .. " (" .. titleStr .. ")")
  local state = data ~= nil and data.status or 0
  self.ylq:SetActive(state == 2)
  self.btn:SetActive(state ~= 2)
  if state ~= 2 then
    CS.UIGray.SetGray(self.btn.transform, state ~= 1, state == 1)
    self.text_btn:SetLocalText("170004")
  end
  self:RefreshReward(info.task_reward, self.layout)
end

function UIChampionDuelAwardTaskItem:RefreshReward(rewards, content)
  local rLen = rewards ~= nil and #rewards or 0
  local bHaveReward = 0 < rLen
  content:SetActive(bHaveReward)
  self:ClearDelays()
  if bHaveReward then
    for i = 1, rLen do
      self.asyncs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(content.transform)
        go.transform.localScale = Vector3.New(0.7, 0.7, 1)
        go.transform:Set_sizeDelta(100, 100)
        go.transform:Set_pivot(0, 1)
        local nameStr = "item_" .. i
        go.name = nameStr
        local cell = content:AddComponent(UICommonResItem, nameStr)
        cell:SetActive(true)
        cell:ReInit(rewards[i])
      end)
    end
  end
end

return UIChampionDuelAwardTaskItem
