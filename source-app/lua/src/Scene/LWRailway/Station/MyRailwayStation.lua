local MyRailwayStation = BaseClass("MyRailwayStation")

function MyRailwayStation:__init(transform)
  self.transform = transform
  self:ComponentDefine()
  self:Init()
end

function MyRailwayStation:__delete()
  self:Destroy()
end

function MyRailwayStation:Destroy()
  self:ComponentDestroy()
end

function MyRailwayStation:ComponentDefine()
  self.trigger = {}
  self.trigger[1] = self.transform:Find("huochezhan_zuo"):GetComponent(typeof(CS.TouchObjectEventTrigger))
  self.trigger[1].onPointerClick = function()
    self:OnClick()
  end
  self.trigger[2] = self.transform:Find("huochezhan_you"):GetComponent(typeof(CS.TouchObjectEventTrigger))
  self.trigger[2].onPointerClick = function()
    self:OnClick()
  end
  local truckStationOldSkin = self.transform:Find("A_build_tingchechang")
  if truckStationOldSkin then
    self.truckStationOldSkin = truckStationOldSkin.gameObject
  end
end

function MyRailwayStation:Init()
  if self.truckStationNewSkin then
    return
  end
  local skinMeta = DataCenter.SeasonDataManager:GetLoginServerSkinMeta()
  if not skinMeta or not skinMeta.truck_parking then
    return
  end
  self.truckStationNewSkin = CS.GameEntry.Resource:InstantiateAsync(skinMeta.truck_parking)
  self.truckStationNewSkin:completed("+", function(request)
    if self.truckStationOldSkin then
      self.truckStationOldSkin:SetActive(false)
    end
    local gameObject = request.gameObject
    local transform = gameObject.transform
    transform:SetParent(self.transform)
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    transform:Set_localPosition(0, 0, 0)
  end)
end

function MyRailwayStation:ComponentDestroy()
  if self.trigger then
    for _, v in pairs(self.trigger) do
      if not IsNull(v) then
        v.onPointerClick = nil
      end
    end
  end
  if self.truckStationNewSkin then
    self.truckStationNewSkin:Destroy()
    self.truckStationNewSkin = nil
  end
  self.trigger = {}
  self.transform = nil
  self.truckStationOldSkin = nil
end

function MyRailwayStation:OnClick()
  RailwayUtil.ClickTrainStation()
end

return MyRailwayStation
