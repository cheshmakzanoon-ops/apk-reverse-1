local WorldButtonAroundPlane = BaseClass("WorldButtonAroundPlane", UIAsyncContainer)
local base = UIAsyncContainer
local UnityCanvasGroup = typeof(CS.UnityEngine.CanvasGroup)
local UIWorldPointBtn = require("UI.UIWorldPoint.Component.UIWorldPointBtn")
local UIWorldSiegePointBtn = require("UI.LWWorld.UIWorldSiegePoint.Component.UIWorldSiegePointBtn")
local content_path = "btns/content"
local build_btn_path = "btns/content/UIWorldTileBuildBtn"
local back_btn_path = "btns/Settings/backBtn"
local setting_btn_path = "btns/Settings/settingBtn"

function WorldButtonAroundPlane:OnCreate()
  base.OnCreate(self)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.setting_btn = self:AddComponent(UIButton, setting_btn_path)
  self.theItem = self.transform:Find(build_btn_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.setting_btn:SetActive(false)
  self.back_btn:SetOnClick(function()
    self:HideMe()
  end)
  self.AutoAdjustScreenPos = self.transform:GetComponent(typeof(CS.AutoAdjustScreenPos))
end

function WorldButtonAroundPlane:OnDestroy()
  self.content:RemoveComponents(UIWorldPointBtn)
  self.content:RemoveComponents(UIWorldSiegePointBtn)
  self.theItem:GameObjectRecycleAll()
  self.content = nil
  self.back_btn = nil
  self.setting_btn = nil
  if self.seqList ~= nil then
    for _, anim in ipairs(self.seqList) do
      anim:Kill()
    end
    self.seqList = nil
  end
  base.OnDestroy(self)
end

function WorldButtonAroundPlane:HideMe()
  if self.view then
    local data = self.view
    if ComponentIsValid(data.pos_go) then
      data.pos_go:SetActive(true)
      self:SetActive(false)
    end
  end
end

function WorldButtonAroundPlane:ShowMe(info, pointId, class)
  if self.view then
    local data = self.view
    if ComponentIsValid(data.pos_go) then
      data.pos_go:SetActive(false)
      self.info = info
      self.pointId = pointId
      self.class = class
      self:SetActive(true)
      self:UpdateData()
    end
  end
end

function WorldButtonAroundPlane:SetData(data, pointId, class)
  self.info = data
  self.pointId = pointId
  self.class = class
end

function WorldButtonAroundPlane:UpdateData()
  if self.view == nil or self.info == nil or self.pointId == nil or self.class == nil or IsNull(self.gameObject) or self:GetActive() ~= true then
    return
  end
  local data = self.view
  if ComponentIsValid(data.pos_go) and data.pos_go:GetActive() == false then
    local btnList = data.btnList
    if self.seqList ~= nil then
      for _, anim in ipairs(self.seqList) do
        anim:Kill()
      end
      self.seqList = nil
    end
    self.content:RemoveComponents(UIWorldPointBtn)
    self.content:RemoveComponents(UIWorldSiegePointBtn)
    self.theItem:GameObjectRecycleAll()
    if data.worldPos then
      self.AutoAdjustScreenPos:Init(data.worldPos)
    else
      self.AutoAdjustScreenPos:Init(SceneUtils.TileIndexToWorld(self.pointId))
    end
    if btnList == nil then
      self:HideMe()
      return
    end
    local btnCount = #btnList
    if 0 < btnCount then
      local goItem, theItem
      local angle = 2 * math.pi / btnCount
      local seqList = {}
      for k, v in ipairs(btnList) do
        local param = {}
        param.btnType = v
        param.pointId = self.pointId
        param.info = self.info
        local position = Vector3.New(200 * math.sin(angle * k), 200 * math.cos(angle * k), 0)
        param.position = Vector3.New(0, 0, 0)
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = UIUtil.GetLoopListItemIndex()
        goItem:SetActive(true)
        goItem.transform:Set_localScale(0.1, 0.1, 0.1)
        goItem.transform:Set_localPosition(0, 0, 0)
        theItem = self.content:AddComponent(self.class, goItem.name)
        theItem:ReInit(param)
        local unity_canvas_group = goItem:GetComponent(UnityCanvasGroup)
        if unity_canvas_group then
          unity_canvas_group.alpha = 1
        end
        local sequence = DOTween.Sequence()
        sequence:Append(goItem.transform:DOLocalMove(position, 0.3))
        sequence:Join(goItem.transform:DOScale(Vector3.New(0.8, 0.8, 0.8), 0.2))
        table.insert(seqList, sequence)
      end
      self.seqList = seqList
    end
  end
end

return WorldButtonAroundPlane
