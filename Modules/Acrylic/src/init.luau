local Lighting = game:GetService("Lighting")
local isStudio = game:GetService("RunService"):IsStudio()
local Camera = workspace.CurrentCamera

local blurObject = nil
local universalDof = nil
local defaultIntensity = 1
local currentIntensity = 1
local connections = {}

local function init()
	if not (getgenv and ((getgenv().NoAnticheat == nil and true or getgenv().NoAnticheat) or not getgenv().SecureMode) or isStudio) then return end

	for i,v in pairs(Lighting:GetChildren()) do
		if v:IsA("DepthOfFieldEffect")
			and v.Name ~= "starlightBlur" then
			universalDof = v
		end
	end

	if universalDof == nil then
		universalDof = Instance.new("DepthOfFieldEffect")
		universalDof.FarIntensity = 0
		universalDof.NearIntensity = 0
		universalDof.FocusDistance = 500
		universalDof.InFocusRadius = 500
		universalDof.Enabled = true
	end

	local partRoot = Camera:FindFirstChild("Starlight Blur Elements") or Instance.new("Folder", Camera)
	partRoot.Name = "Starlight Blur Elements"

	local blurSize         = Vector2.new(5, 2)
	local partSize         = 0.01
	local partTransparency = 0.99

	blurObject          = Lighting:FindFirstChild("starlightBlur") ~= nil and Lighting:FindFirstChild("starlightBlur") or universalDof:Clone()
	blurObject.NearIntensity  = 0
	blurObject.FocusDistance  = universalDof.FocusDistance
	blurObject.InFocusRadius = universalDof.InFocusRadius
	blurObject.FarIntensity = universalDof.FarIntensity
	blurObject.Parent         = Lighting
	blurObject.Name = "starlightBlur"

	table.insert(connections, universalDof:GetPropertyChangedSignal("FarIntensity"):Connect(function()
		blurObject.FarIntensity = universalDof.FarIntensity
	end))
	table.insert(connections, universalDof:GetPropertyChangedSignal("InFocusRadius"):Connect(function()
		blurObject.InFocusRadius = universalDof.InFocusRadius
	end))
	table.insert(connections, universalDof:GetPropertyChangedSignal("FocusDistance"):Connect(function()
		blurObject.FocusDistance = universalDof.FocusDistance
	end))
	table.insert(connections, universalDof:GetPropertyChangedSignal("Enabled"):Connect(function()
		if universalDof.Enabled == false then
			blurObject.FarIntensity = 0
			blurObject.FocusDistance = 500
			blurObject.InFocusRadius = 500
		else
			blurObject.FarIntensity = universalDof.FarIntensity
			blurObject.InFocusRadius = universalDof.InFocusRadius
			blurObject.FocusDistance = universalDof.FocusDistance
		end
	end))

	local function enable()
		blurObject.NearIntensity = currentIntensity
	end

	local function disable()
		blurObject.NearIntensity = 0
	end
	enable()
end

-- Set blur intensity (0 to 1, higher = more blur)
local function setIntensity(level)
	currentIntensity = math.clamp(level, 0, 1)
	if blurObject then
		blurObject.NearIntensity = currentIntensity
	end
end

-- Get current blur intensity
local function getIntensity()
	return currentIntensity
end

-- Clean up acrylic resources
local function destroy()
	if blurObject and blurObject.Parent then
		blurObject:Destroy()
		blurObject = nil
	end
	if Camera then
		local partRoot = Camera:FindFirstChild("Starlight Blur Elements")
		if partRoot then
			partRoot:Destroy()
		end
	end
	for _, conn in ipairs(connections) do
		conn:Disconnect()
	end
	connections = {}
end

return {
	Init = init,
	SetIntensity = setIntensity,
	GetIntensity = getIntensity,
	Destroy = destroy,
	AcrylicBlur = require(script.AcrylicBlur),
	CreateAcrylic = require(script.CreateAcrylic),
	AcrylicPaint = require(script.AcrylicPaint),
}