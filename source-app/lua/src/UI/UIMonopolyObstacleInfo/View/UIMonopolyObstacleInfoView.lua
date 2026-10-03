local UIMonopolyObstacleInfoView = BaseClass("UIMonopolyObstacleInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIMonopolyObstacleInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIMonopolyObstacleInfoView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMonopolyObstacleInfoView:ComponentDestroy()
  self.name_text = nil
  self.info_text = nil
  self.des_text = nil
  self.obstacleIcon_img = nil
  self.panelBtn_btn = nil
  self.AutoAdjustScreenPos = nil
  self.infoBtn = nil
  self.infoBg = nil
  self.infoName = nil
  self.infoDesc = nil
  self:SetAllCellDestroy()
end

function UIMonopolyObstacleInfoView:DataDestroy()
  self.data = nil
end

function UIMonopolyObstacleInfoView:ComponentDefine()
  self.obstacleIcon_img = self:AddComponent(UIImage, "panel/GameObject/Image/icon/bossIcon")
  self.bg_2_img = self:AddComponent(UIImage, "panel/GameObject/Image/bg_2")
  self.name_text = self:AddComponent(UIText, "panel/GameObject/Image/bg_2/texts/name")
  self.info_text = self:AddComponent(UIText, "panel/GameObject/Image/bg_2/texts/info")
  self.des_text = self:AddComponent(UIText, "panel/GameObject/Image/bg_2/texts/des")
  self.panelBtn_btn = self:AddComponent(UIButton, "PanelBtn")
  self.scroll = self:AddComponent(UIScrollRect, "panel/GameObject/Image/bg_2/Scroll")
  self.content = self:AddComponent(UIBaseContainer, "panel/GameObject/Image/bg_2/Scroll/Viewport/Content")
  self.AutoAdjustScreenPos = self.transform:Find("panel/GameObject"):GetComponent(typeof(CS.AutoAdjustScreenPos))
  self.panelBtn_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.infoBtn = self:AddComponent(UIButton, "panel/GameObject/Image/bg_1/btnInfo")
  self.infoBtn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.infoBg = self:AddComponent(UIBaseContainer, "panel/GameObject/Image/bg_1/btnInfo/infoBg")
  self.infoName = self:AddComponent(UIText, "panel/GameObject/Image/bg_1/btnInfo/infoBg/infoName")
  self.infoDesc = self:AddComponent(UIText, "panel/GameObject/Image/bg_1/btnInfo/infoBg/infoDesc")
  self.infoBg:SetActive(false)
  self.infoState = false
  self.info_text:SetActive(false)
end

function UIMonopolyObstacleInfoView:ReInit()
  self.data = self:GetUserData()
  if self.data == nil then
    return
  end
  self.name_text:SetLocalText(self.data.name, DataCenter.MonopolyManager:GetPlacealityQuestOrder(tonumber(self.data.id)))
  self.des_text:SetLocalText(self.data.desc)
  local worldPos = self.data:GetCenterWorldPos()
  self.AutoAdjustScreenPos:Init(worldPos)
  local screenW = Screen.width / DefaultScreenWidth
  local screenH = Screen.height / DefaultScreenHeight
  local rightBase = self.data.hasLockModule and 530 or 250
  local BuildAdjust = {
    left = 250 * screenW,
    right = rightBase * screenW,
    top = 600 * screenH,
    bottom = 100 * screenH
  }
  UIUtil.ClickBuildAdjustCameraView(worldPos, BuildAdjust, 1)
  self.obstacleIcon_img:LoadSprite(self.data.image)
  self.obstacleIcon_img:SetNativeSize()
  self:InitReward()
  if self.data.hasLockModule then
    self.infoBtn:SetActive(true)
    local moduleKey = self.data.lock_module_key
    if not string.IsNullOrEmpty(moduleKey) then
      self.infoName:SetText(Localization:GetString(moduleKey))
    else
      self.infoName:SetText(nil)
    end
    local moduleTip = self.data.lock_module_tips_key
    if not string.IsNullOrEmpty(moduleTip) then
      self.infoDesc:SetText(Localization:GetString(moduleTip))
    else
      self.infoDesc:SetText(nil)
    end
  else
    self.infoBtn:SetActive(false)
  end
end

function UIMonopolyObstacleInfoView:InitReward()
  self:SetAllCellDestroy()
  local rewardStr = self.data.reward_show
  if string.IsNullOrEmpty(rewardStr) then
    self.bg_2_img:SetSizeDelta(Vector2(421, 150))
    self.scroll:SetActive(false)
    return
  end
  local rewardStrVec = string.split_ss_array(rewardStr, "|")
  local rewardList = {}
  table.walk(rewardStrVec, function(k, v)
    local str = v
    local item = DataCenter.RewardManager:ParseOneRewardStr(str)
    if item then
      table.insert(rewardList, item)
    end
  end)
  if 0 < #rewardList then
    self.bg_2_img:SetSizeDelta(Vector2(421, 250))
    self.scroll:SetActive(true)
    self:AddRewardToContainer(rewardList, self.content)
  else
    self.bg_2_img:SetSizeDelta(Vector2(421, 150))
    self.scroll:SetActive(false)
  end
end

function UIMonopolyObstacleInfoView:SetAllCellDestroy()
  self.content:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function UIMonopolyObstacleInfoView:AddRewardToContainer(list, container)
  if list ~= nil and container then
    local num = 0
    for i = 1, table.length(list) do
      num = num + 1
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(container.transform)
        go.transform:Set_localScale(0.7, 0.7, 0.7)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = container:AddComponent(UICommonResItem, nameStr)
        cell:ReInit(list[i], self.view.ctrl.type)
      end)
    end
  end
end

function UIMonopolyObstacleInfoView:DataDefine()
  self.data = nil
end

function UIMonopolyObstacleInfoView:OnInfoBtnClick()
  self.infoState = not self.infoState
  self.infoBg:SetActive(self.infoState)
end

return UIMonopolyObstacleInfoView
